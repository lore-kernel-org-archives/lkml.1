Return-Path: <linux-kernel-owner+w=401wt.eu-S1754220AbZCELEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbZCELEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 06:04:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZCELEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 06:04:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:45453 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbZCELEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 06:04:06 -0500
Date: Thu, 5 Mar 2009 11:03:33 GMT
From: Frederic Weisbecker <fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, rostedt@goodmis.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
References: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
Subject: [tip:tracing/function-graph-tracer] tracing/function-graph-tracer: use the more lightweight local clock
Message-ID: <tip-bf467399b5f6301e7a6dc21460e66b1f40e16c7e@git.kernel.org>
Git-Commit-ID: bf467399b5f6301e7a6dc21460e66b1f40e16c7e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 05 Mar 2009 11:03:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf467399b5f6301e7a6dc21460e66b1f40e16c7e
Gitweb:     http://git.kernel.org/tip/bf467399b5f6301e7a6dc21460e66b1f40e16c7e
Author:     "Frederic Weisbecker" <fweisbec@gmail.com>
AuthorDate: Thu, 5 Mar 2009 01:49:22 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 5 Mar 2009 12:01:52 +0100

tracing/function-graph-tracer: use the more lightweight local clock

Impact: decrease hangs risks with the graph tracer on slow systems

Since the function graph tracer can spend too much time on timer
interrupts, it's better now to use the more lightweight local
clock. Anyway, the function graph traces are more reliable on a
per cpu trace.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <49af243d.06e9300a.53ad.ffff840c@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ftrace.c             |    2 +-
 kernel/trace/trace_functions_graph.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 3925ec0..a85da17 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -436,7 +436,7 @@ void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr)
 		return;
 	}
 
-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = trace_clock_local();
 
 	if (ftrace_push_return_trace(old, calltime,
 				self_addr, &trace.depth) == -EBUSY) {
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index c009553..e527f2f 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -112,7 +112,7 @@ unsigned long ftrace_return_to_handler(void)
 	unsigned long ret;
 
 	ftrace_pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = trace_clock_local();
 	ftrace_graph_return(&trace);
 
 	if (unlikely(!ret)) {
