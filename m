Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbZGABJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbZGABJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761537AbZGAAf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:27 -0400
Received: from kroah.org ([198.145.64.141]:60570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760333AbZGAAfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:19 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:37 2009
Message-Id: <20090701002437.409563985@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [patch 077/108] tracing/urgent: fix unbalanced ftrace_start_up
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=tracing-urgent-fix-unbalanced-ftrace_start_up.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Frederic Weisbecker <fweisbec@gmail.com>

commit c85a17e22695969aa24a7ffa40cf26d6e6fcfd50 upstream.

Perfcounter reports the following stats for a wide system
profiling:

 #
 # (2364 samples)
 #
 # Overhead  Symbol
 # ........  ......
 #
    15.40%  [k] mwait_idle_with_hints
     8.29%  [k] read_hpet
     5.75%  [k] ftrace_caller
     3.60%  [k] ftrace_call
     [...]

This snapshot has been taken while neither the function tracer nor
the function graph tracer was running.
With dynamic ftrace, such results show a wrong ftrace behaviour
because all calls to ftrace_caller or ftrace_graph_caller (the patched
calls to mcount) are supposed to be patched into nop if none of those
tracers are running.

The problem occurs after the first run of the function tracer. Once we
launch it a second time, the callsites will never be nopped back,
unless you set custom filters.
For example it happens during the self tests at boot time.
The function tracer selftest runs, and then the dynamic tracing is
tested too. After that, the callsites are left un-nopped.

This is because the reset callback of the function tracer tries to
unregister two ftrace callbacks in once: the common function tracer
and the function tracer with stack backtrace, regardless of which
one is currently in use.
It then creates an unbalance on ftrace_start_up value which is expected
to be zero when the last ftrace callback is unregistered. When it
reaches zero, the FTRACE_DISABLE_CALLS is set on the next ftrace
command, triggering the patching into nop. But since it becomes
unbalanced, ie becomes lower than zero, if the kernel functions
are patched again (as in every further function tracer runs), they
won't ever be nopped back.

Note that ftrace_call and ftrace_graph_call are still patched back
to ftrace_stub in the off case, but not the callers of ftrace_call
and ftrace_graph_caller. It means that the tracing is well deactivated
but we waste a useless call into every kernel function.

This patch just unregisters the right ftrace_ops for the function
tracer on its reset callback and ignores the other one which is
not registered, fixing the unbalance. The problem also happens
is .30

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace_functions.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -193,9 +193,11 @@ static void tracing_start_function_trace
 static void tracing_stop_function_trace(void)
 {
 	ftrace_function_enabled = 0;
-	/* OK if they are not registered */
-	unregister_ftrace_function(&trace_stack_ops);
-	unregister_ftrace_function(&trace_ops);
+
+	if (func_flags.val & TRACE_FUNC_OPT_STACK)
+		unregister_ftrace_function(&trace_stack_ops);
+	else
+		unregister_ftrace_function(&trace_ops);
 }
 
 static int func_set_flag(u32 old_flags, u32 bit, int set)


