Return-Path: <linux-kernel-owner+w=401wt.eu-S1757111AbZHZHXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111AbZHZHXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757098AbZHZHX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:23:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:46801 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074AbZHZHXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:23:24 -0400
Date: Wed, 26 Aug 2009 07:22:52 GMT
From: tip-bot for Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, josh@joshtriplett.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, josh@joshtriplett.org
In-Reply-To: <20090806145701.GB7661@feather>
References: <20090806145701.GB7661@feather>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Add vim script to enable folding for function_graph traces
Message-ID: <tip-6591b493871cf9b17de2ba272edb8ab529a8058b@git.kernel.org>
Git-Commit-ID: 6591b493871cf9b17de2ba272edb8ab529a8058b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 07:22:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6591b493871cf9b17de2ba272edb8ab529a8058b
Gitweb:     http://git.kernel.org/tip/6591b493871cf9b17de2ba272edb8ab529a8058b
Author:     Josh Triplett <josh@joshtriplett.org>
AuthorDate: Thu, 6 Aug 2009 07:57:01 -0700
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Wed, 26 Aug 2009 00:32:04 -0400

tracing: Add vim script to enable folding for function_graph traces

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
