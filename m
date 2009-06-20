Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZFTFGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZFTFGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 01:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751978AbZFTFGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 01:06:18 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63055 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZFTFGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 01:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=mLEiVTrM5RGTgNf++jQqwYQpKAuKCzpctV8VO2ycl0NnHXFXormsRw7ExYTFThwuR2
         Ih62IUBVTeKwGzt0aaVEv6DWT+trCIoIXrQ8Su2OM7Y+8xU52Q50ko32Ln2hk6MKGZQc
         TvZtON3/yXHyTKDXFawuq5UvoWvi038ofSpQc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, stable@kernel.org
Subject: [PATCH 1/2] tracing/urgent: fix unbalanced ftrace_start_up
Date: Sat, 20 Jun 2009 07:06:11 +0200
Message-Id: <1245474372-5249-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
References: <1245474372-5249-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@kernel.org
---
 kernel/trace/trace_functions.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
index c9a0b7d..90f1347 100644
--- a/kernel/trace/trace_functions.c
+++ b/kernel/trace/trace_functions.c
@@ -193,9 +193,11 @@ static void tracing_start_function_trace(void)
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
-- 
1.6.2.3

