Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbZHZFBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbZHZFBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 01:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756016AbZHZFAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 01:00:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41529 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934AbZHZFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 01:00:50 -0400
Message-Id: <20090826050050.893406395@goodmis.org>
References: <20090826045945.201094161@goodmis.org>
User-Agent: quilt/0.46-1
Date: Wed, 26 Aug 2009 00:59:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 2/8] tracing: Add vim script to enable folding for function_graph traces
Content-Disposition: inline; filename=0002-tracing-Add-vim-script-to-enable-folding-for-functio.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Triplett <josh@joshtriplett.org>

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
LKML-Reference: <20090806145701.GB7661@feather>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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

-- 
