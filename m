Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYI2SLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYI2SLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYI2SD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:28 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54361 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754023AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180254.065935000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:19 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 29/31] cpumask: clean trace files
Content-Disposition: inline; filename=clean-trace
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 kernel/trace/trace.c         |   14 +++++++-------
 kernel/trace/trace_sysprof.c |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

--- struct-cpumasks.orig/kernel/trace/trace.c
+++ struct-cpumasks/kernel/trace/trace.c
@@ -40,7 +40,7 @@ unsigned long __read_mostly	tracing_max_
 unsigned long __read_mostly	tracing_thresh;
 
 static unsigned long __read_mostly	tracing_nr_buffers;
-static cpumask_t __read_mostly		tracing_buffer_mask;
+static cpumask_map_t __read_mostly	tracing_buffer_mask;
 
 #define for_each_tracing_cpu(cpu)	\
 	for_each_cpu(cpu, tracing_buffer_mask)
@@ -2163,13 +2163,13 @@ static struct file_operations show_trace
 /*
  * Only trace on a CPU if the bitmask is set:
  */
-static cpumask_t tracing_cpumask = CPU_MASK_ALL;
+static cpumask_map_t tracing_cpumask = CPU_MASK_ALL;
 
 /*
  * When tracing/tracing_cpu_mask is modified then this holds
  * the new bitmask we are about to install:
  */
-static cpumask_t tracing_cpumask_new;
+static cpumask_map_t tracing_cpumask_new;
 
 /*
  * The tracer itself will not take this lock, but still we want
@@ -2235,7 +2235,7 @@ tracing_cpumask_write(struct file *filp,
 	__raw_spin_unlock(&ftrace_max_lock);
 	raw_local_irq_enable();
 
-	tracing_cpumask = tracing_cpumask_new;
+	cpus_copy(tracing_cpumask, tracing_cpumask_new);
 
 	mutex_unlock(&tracing_cpumask_update_lock);
 
@@ -2600,7 +2600,7 @@ tracing_read_pipe(struct file *filp, cha
 {
 	struct trace_iterator *iter = filp->private_data;
 	struct trace_array_cpu *data;
-	static cpumask_t mask;
+	static cpumask_var_t mask;
 	unsigned long flags;
 #ifdef CONFIG_FTRACE
 	int ftrace_save;
@@ -3235,7 +3235,7 @@ void ftrace_dump(void)
 	/* use static because iter can be a bit big for the stack */
 	static struct trace_iterator iter;
 	struct trace_array_cpu *data;
-	static cpumask_t mask;
+	static cpumask_var_t mask;
 	static int dump_ran;
 	unsigned long flags;
 	int cnt = 0;
@@ -3454,7 +3454,7 @@ __init static int tracer_alloc_buffers(v
 
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	tracing_nr_buffers = num_possible_cpus();
-	tracing_buffer_mask = cpu_possible_map;
+	cpus_copy(tracing_buffer_mask, cpu_possible_map);
 
 	/* Allocate the first page for all buffers */
 	for_each_tracing_cpu(i) {
--- struct-cpumasks.orig/kernel/trace/trace_sysprof.c
+++ struct-cpumasks/kernel/trace/trace_sysprof.c
@@ -216,7 +216,7 @@ static void start_stack_timers(void)
 		set_cpus_allowed(current, cpumask_of_cpu(cpu));
 		start_stack_timer(cpu);
 	}
-	set_cpus_allowed(current, &saved_mask);
+	set_cpus_allowed(current, saved_mask);
 }
 
 static void stop_stack_timer(int cpu)

-- 
