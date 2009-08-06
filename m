Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZHFPWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZHFPWJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755920AbZHFPWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:22:09 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:55012 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755635AbZHFPWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:22:08 -0400
Date: Thu, 6 Aug 2009 07:57:01 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ftrace: Add vim script to enable folding for
 function_graph traces
Message-ID: <20090806145701.GB7661@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

function_graph traces look like nested function calls, complete with
braces denoting the start and end of functions.  function-graph-fold.vim
teaches vim how to fold these functions, to make it more convenient to
browse them.

To use, :source function-graph-fold.vim while viewing a function_graph
trace, or use "view -S function-graph-fold.vim some-trace" to load it
from the command-line together with a trace.  You can then use the usual
vim fold commands, such as "za", to open and close nested functions.
While closed, a fold will show the total time taken for a call, as would
normally appear on the line with the closing brace.  Folded functions
will not include finish_task_switch(), so folding should remain
relatively sane even through a context switch.

Note that this will almost certainly only work well with a single-CPU
trace (e.g. trace-cmd report --cpu 1).  It also takes some time to run
(a few seconds for a large trace on my laptop).  Nevertheless, I found
it very handy to get an overview of a trace and then drill down on
problematic calls.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 Documentation/trace/function-graph-fold.vim |   42 +++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/trace/function-graph-fold.vim

diff --git a/Documentation/trace/function-graph-fold.vim b/Documentation/trace/function-graph-fold.vim
new file mode 100644
index 0000000..0544b50
--- /dev/null
+++ b/Documentation/trace/function-graph-fold.vim
@@ -0,0 +1,42 @@
+" Enable folding for ftrace function_graph traces.
+"
+" To use, :source this file while viewing a function_graph trace, or use vim's
+" -S option to load from the command-line together with a trace.  You can then
+" use the usual vim fold commands, such as "za", to open and close nested
+" functions.  While closed, a fold will show the total time taken for a call,
+" as would normally appear on the line with the closing brace.  Folded
+" functions will not include finish_task_switch(), so folding should remain
+" relatively sane even through a context switch.
+"
+" Note that this will almost certainly only work well with a
+" single-CPU trace (e.g. trace-cmd report --cpu 1).
+
+function! FunctionGraphFoldExpr(lnum)
+  let line = getline(a:lnum)
+  if line[-1:] == '{'
+    if line =~ 'finish_task_switch() {$'
+      return '>1'
+    endif
+    return 'a1'
+  elseif line[-1:] == '}'
+    return 's1'
+  else
+    return '='
+  endif
+endfunction
+
+function! FunctionGraphFoldText()
+  let s = split(getline(v:foldstart), '|', 1)
+  if getline(v:foldend+1) =~ 'finish_task_switch() {$'
+    let s[2] = ' task switch  '
+  else
+    let e = split(getline(v:foldend), '|', 1)
+    let s[2] = e[2]
+  endif
+  return join(s, '|')
+endfunction
+
+setlocal foldexpr=FunctionGraphFoldExpr(v:lnum)
+setlocal foldtext=FunctionGraphFoldText()
+setlocal foldcolumn=12
+setlocal foldmethod=expr
-- 
1.6.3.3

