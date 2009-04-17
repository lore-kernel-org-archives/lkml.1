Return-Path: <linux-kernel-owner+w=401wt.eu-S1759303AbZDQVM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbZDQVM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbZDQVMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:12:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbZDQVMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:12:32 -0400
Message-Id: <20090417211231.411979179@goodmis.org>
References: <20090417211135.408179566@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 17 Apr 2009 17:11:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 4/5] tracing: protect trace_printk from recursion
Content-Disposition: inline; filename=0004-tracing-protect-trace_printk-from-recursion.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

trace_printk can be called from any context, including NMIs.
If this happens, then we must test for for recursion before
grabbing any spinlocks.

This patch prevents trace_printk from being called recursively.

[ Impact: prevent hard lockup in lockdep event tracer ]

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 183d788..b9a3adc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1259,6 +1259,7 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	struct trace_array_cpu *data;
 	struct bprint_entry *entry;
 	unsigned long flags;
+	int disable;
 	int resched;
 	int cpu, len = 0, size, pc;
 
@@ -1273,7 +1274,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
-	if (unlikely(atomic_read(&data->disabled)))
+	disable = atomic_inc_return(&data->disabled);
+	if (unlikely(disable != 1))
 		goto out;
 
 	/* Lockdep uses trace_printk for lock tracing */
@@ -1301,6 +1303,7 @@ out_unlock:
 	local_irq_restore(flags);
 
 out:
+	atomic_dec_return(&data->disabled);
 	ftrace_preempt_enable(resched);
 	unpause_graph_tracing();
 
@@ -1320,6 +1323,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	int cpu, len = 0, size, pc;
 	struct print_entry *entry;
 	unsigned long irq_flags;
+	int disable;
 
 	if (tracing_disabled || tracing_selftest_running)
 		return 0;
@@ -1329,7 +1333,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	cpu = raw_smp_processor_id();
 	data = tr->data[cpu];
 
-	if (unlikely(atomic_read(&data->disabled)))
+	disable = atomic_inc_return(&data->disabled);
+	if (unlikely(disable != 1))
 		goto out;
 
 	pause_graph_tracing();
@@ -1357,6 +1362,7 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 	raw_local_irq_restore(irq_flags);
 	unpause_graph_tracing();
  out:
+	atomic_dec_return(&data->disabled);
 	preempt_enable_notrace();
 
 	return len;
-- 
1.6.2.1

-- 
