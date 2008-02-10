Return-Path: <linux-kernel-owner+w=401wt.eu-S1757905AbYBJHZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905AbYBJHZj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:25:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758120AbYBJHVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:21:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35468 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758099AbYBJHU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:20:58 -0500
Date: Sun, 10 Feb 2008 08:20:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Steven Rostedt <rostedt@goodmis.org>
Subject: [12/19] ftrace: function tracer
Message-ID: <20080210072046.GM4100@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

This is a simple trace that uses the ftrace infrastructure. It is
designed to be fast and small, and easy to use. It is useful to
record things that happen over a very short period of time, and
not to analyze the system in general.

 Updates:

  available_tracers
     "function" is added to this file.

  current_tracer
    To enable the function tracer:

      echo function > /debugfs/tracing/current_tracer

     To disable the tracer:

       echo disable > /debugfs/tracing/current_tracer

The output of the function_trace file is as follows

  "echo noverbose > /debugfs/tracing/iter_ctrl"

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 0 us, #419428/4361791, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

                 _------=> CPU#
                / _-----=> irqs-off
               | / _----=> need-resched
               || / _---=> hardirq/softirq
               ||| / _--=> preempt-depth
               |||| /
               |||||     delay
   cmd     pid ||||| time  |   caller
      \   /    |||||   \   |   /
 swapper-0     0d.h. 1595128us+: set_normalized_timespec+0x8/0x2d <c043841d> (ktime_get_ts+0x4a/0x4e <c04499d4>)
 swapper-0     0d.h. 1595131us+: _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)

Or with verbose turned on:

  "echo verbose > /debugfs/tracing/iter_ctrl"

preemption latency trace v1.1.5 on 2.6.24-rc7-tst
--------------------------------------------------------------------
 latency: 0 us, #419428/4361791, CPU#1 | (M:desktop VP:0, KP:0, SP:0 HP:0 #P:4)
    -----------------
    | task: -0 (uid:0 nice:0 policy:0 rt_prio:0)
    -----------------

         swapper     0 0 9 00000000 00000000 [f3675f41] 1595.128ms (+0.003ms): set_normalized_timespec+0x8/0x2d <c043841d> (ktime_get_ts+0x4a/0x4e <c04499d4>)
         swapper     0 0 9 00000000 00000001 [f3675f45] 1595.131ms (+0.003ms): _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)
         swapper     0 0 9 00000000 00000002 [f3675f48] 1595.135ms (+0.003ms): _spin_lock+0x8/0x18 <c0630690> (hrtimer_interrupt+0x6e/0x1b0 <c0449c56>)

The "trace" file is not affected by the verbose mode, but is by the symonly.

 echo "nosymonly" > /debugfs/tracing/iter_ctrl

tracer:
[   81.479967] CPU 0: bash:3154 register_ftrace_function+0x5f/0x66 <ffffffff80337a4d> <-- _spin_unlock_irqrestore+0xe/0x5a <ffffffff8048cc8f>
[   81.479967] CPU 0: bash:3154 _spin_unlock_irqrestore+0x3e/0x5a <ffffffff8048ccbf> <-- sub_preempt_count+0xc/0x7a <ffffffff80233d7b>
[   81.479968] CPU 0: bash:3154 sub_preempt_count+0x30/0x7a <ffffffff80233d9f> <-- in_lock_functions+0x9/0x24 <ffffffff8025a75d>
[   81.479968] CPU 0: bash:3154 vfs_write+0x11d/0x155 <ffffffff8029a043> <-- dnotify_parent+0x12/0x78 <ffffffff802d54fb>
[   81.479968] CPU 0: bash:3154 dnotify_parent+0x2d/0x78 <ffffffff802d5516> <-- _spin_lock+0xe/0x70 <ffffffff8048c910>
[   81.479969] CPU 0: bash:3154 _spin_lock+0x1b/0x70 <ffffffff8048c91d> <-- add_preempt_count+0xe/0x77 <ffffffff80233df7>
[   81.479969] CPU 0: bash:3154 add_preempt_count+0x3e/0x77 <ffffffff80233e27> <-- in_lock_functions+0x9/0x24 <ffffffff8025a75d>

 echo "symonly" > /debugfs/tracing/iter_ctrl

tracer:
[   81.479913] CPU 0: bash:3154 register_ftrace_function+0x5f/0x66 <-- _spin_unlock_irqrestore+0xe/0x5a
[   81.479913] CPU 0: bash:3154 _spin_unlock_irqrestore+0x3e/0x5a <-- sub_preempt_count+0xc/0x7a
[   81.479913] CPU 0: bash:3154 sub_preempt_count+0x30/0x7a <-- in_lock_functions+0x9/0x24
[   81.479914] CPU 0: bash:3154 vfs_write+0x11d/0x155 <-- dnotify_parent+0x12/0x78
[   81.479914] CPU 0: bash:3154 dnotify_parent+0x2d/0x78 <-- _spin_lock+0xe/0x70
[   81.479914] CPU 0: bash:3154 _spin_lock+0x1b/0x70 <-- add_preempt_count+0xe/0x77
[   81.479914] CPU 0: bash:3154 add_preempt_count+0x3e/0x77 <-- in_lock_functions+0x9/0x24

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/trace/Kconfig           |   13 +++++++
 kernel/trace/Makefile          |    1 
 kernel/trace/trace_functions.c |   73 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 87 insertions(+)

Index: linux/kernel/trace/Kconfig
===================================================================
--- linux.orig/kernel/trace/Kconfig
+++ linux/kernel/trace/Kconfig
@@ -8,3 +8,16 @@ config TRACING
 	bool
 	select DEBUG_FS
 
+config FTRACE
+	bool "Kernel Function Tracer"
+	depends on DEBUG_KERNEL && HAVE_FTRACE
+	select FRAME_POINTER
+	select TRACING
+	help
+	  Enable the kernel to trace every kernel function. This is done
+	  by using a compiler feature to insert a small, 5-byte No-Operation
+	  instruction to the beginning of every kernel function, which NOP
+	  sequence is then dynamically patched into a tracer call when
+	  tracing is enabled by the administrator. If it's runtime disabled
+	  (the bootup default), then the overhead of the instructions is very
+	  small and not measurable even in micro-benchmarks.
Index: linux/kernel/trace/Makefile
===================================================================
--- linux.orig/kernel/trace/Makefile
+++ linux/kernel/trace/Makefile
@@ -1,5 +1,6 @@
 obj-$(CONFIG_FTRACE) += libftrace.o
 
 obj-$(CONFIG_TRACING) += trace.o
+obj-$(CONFIG_FTRACE) += trace_functions.o
 
 libftrace-y := ftrace.o
Index: linux/kernel/trace/trace_functions.c
===================================================================
--- /dev/null
+++ linux/kernel/trace/trace_functions.c
@@ -0,0 +1,73 @@
+/*
+ * ring buffer based function tracer
+ *
+ * Copyright (C) 2007-2008 Steven Rostedt <srostedt@redhat.com>
+ * Copyright (C) 2008 Ingo Molnar <mingo@redhat.com>
+ *
+ * Based on code from the latency_tracer, that is:
+ *
+ *  Copyright (C) 2004-2006 Ingo Molnar
+ *  Copyright (C) 2004 William Lee Irwin III
+ */
+#include <linux/fs.h>
+#include <linux/debugfs.h>
+#include <linux/uaccess.h>
+#include <linux/ftrace.h>
+
+#include "trace.h"
+
+static notrace void function_reset(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr->data[cpu]);
+}
+
+static notrace void start_function_trace(struct trace_array *tr)
+{
+	function_reset(tr);
+	tracing_start_function_trace();
+}
+
+static notrace void stop_function_trace(struct trace_array *tr)
+{
+	tracing_stop_function_trace();
+}
+
+static notrace void function_trace_init(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_function_trace(tr);
+}
+
+static notrace void function_trace_reset(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		stop_function_trace(tr);
+}
+
+static notrace void function_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_function_trace(tr);
+	else
+		stop_function_trace(tr);
+}
+
+static struct tracer function_trace __read_mostly =
+{
+	.name	     = "ftrace",
+	.init	     = function_trace_init,
+	.reset	     = function_trace_reset,
+	.ctrl_update = function_trace_ctrl_update,
+};
+
+static __init int init_function_trace(void)
+{
+	return register_tracer(&function_trace);
+}
+
+device_initcall(init_function_trace);
