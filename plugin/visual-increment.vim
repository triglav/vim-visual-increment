" visual-increment.vim - easily create increasing sequence of numbers or letters
" via visual mode
" Author: Triglav <trojhlav@gmail.com>
" Home: https://github.com/triglav/vim-visual-increment

" exit if the plugin is already loaded or disabled or when 'compatible' is set
if (exists("g:loaded_visual_increment") && g:loaded_visual_increment) || &cp
  finish
endif
let g:loaded_visual_increment = 1

let s:cpo_save = &cpo
set cpo&vim

" a:step - increment step, default 1
" a:1 - default null, when set to any value, decrement instead
function! s:doincrement(step, ...)
  " visual block start
  let start_column = col("'<")
  let start_row = line("'<")
  " visual block end, as well as the cursor position
  let end_row = line("'>")
  " when 2nd parameter is passed, we are decrementing the numbers instead
  let incrementer = (a:0 > 0 ? '' : '')

  if start_row == end_row
    " just increment/decrement the value if only one line is selected
    exe "normal! ".a:step.incrementer
  else
    " each next line is increased by <a>, from the previous one
    let i = 0
    while line('.') != end_row
      " move to the next line
      call setpos('.', [0, line('.')+1, start_column, 0])
      " if the current line is shorter, skip it
      if start_column < col("$")
        let i += a:step
        " increment the current line by <i>
        exe "normal! ".i.incrementer
      end
    endwhile
  endif
endfunction

vnoremap <silent> <Plug>VisualIncrement :<C-U>call <SID>doincrement(v:count1)<CR>
vnoremap <silent> <Plug>VisualDecrement :<C-U>call <SID>doincrement(v:count1, 1)<CR>

if !hasmapto("<Plug>VisualIncrement")
  vmap <C-A>  <Plug>VisualIncrement
endif
if !hasmapto("<Plug>VisualDecrement")
  vmap <C-X>  <Plug>VisualDecrement
endif

let &cpo = s:cpo_save

