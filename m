Return-Path: <linux-kernel-owner+w=401wt.eu-S1753500AbYJDS3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbYJDS3i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 14:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbYJDS3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 14:29:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:47238 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbYJDS33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 14:29:29 -0400
Date: Sat, 4 Oct 2008 11:29:15 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ftrace: Add a C-state tracer to help power
 optimization
Message-ID: <20081004112915.7c2b45ea@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
References: <20081004105447.0e48d6d4@infradead.org>
 <alpine.DEB.1.10.0810041410390.6571@gandalf.stny.rr.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008 14:17:47 -0400 (EDT)
Steven Rostedt <rostedt@goodmis.org> wrote:
> > +	struct trace_cstate *field = (struct trace_cstate *)entry;
> 
> Ingo, isn't the trace_assign_type in your latest tree?


like this?


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Fri, 3 Oct 2008 10:18:21 -0700
Subject: [PATCH v3] ftrace: Add a C-state tracer to help power optimization

This patch adds a C-state ftrace plugin that will generate
detailed statistics about the C-states that are being used,
so that we can look at detailed decisions that the C-state
code is making, rather than the too high level "average"
that we have today.

An example way of using this is:
mount -t debugfs none /sys/kernel/debug
echo cstate > /sys/kernel/debug/tracing/current_tracer
echo 1 > /sys/kernel/debug/tracing/tracing_enabled
sleep 1
echo 0 > /sys/kernel/debug/tracing/tracing_enabled
cat /sys/kernel/debug/tracing/trace | perl scripts/trace/cstate.pl > out.svg

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 arch/x86/kernel/process.c   |   15 +++++
 include/linux/ftrace.h      |   14 +++++
 kernel/trace/Kconfig        |   10 +++
 kernel/trace/Makefile       |    1 +
 kernel/trace/trace.h        |    7 ++
 kernel/trace/trace_cstate.c |  135 +++++++++++++++++++++++++++++++++++++++++++
 scripts/trace/cstate.pl     |   84 +++++++++++++++++++++++++++
 7 files changed, 266 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_cstate.c
 create mode 100644 scripts/trace/cstate.pl

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 3468131..9733ef4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -7,6 +7,7 @@
 #include <linux/module.h>
 #include <linux/pm.h>
 #include <linux/clockchips.h>
+#include <linux/ftrace.h>
 #include <asm/system.h>
 
 unsigned long idle_halt;
@@ -100,6 +101,9 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
+		struct cstate_trace it;
+
+		trace_cstate_start(&it, 1);
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -112,6 +116,7 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
+		trace_cstate_end(&it);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -154,24 +159,31 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
+	struct cstate_trace it;
+
+	trace_cstate_start(&it, (ax>>4)+1);
 	if (!need_resched()) {
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
+	trace_cstate_end(&it);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
+	struct cstate_trace it;
 	if (!need_resched()) {
+		trace_cstate_start(&it, 1);
 		__monitor((void *)&current_thread_info()->flags, 0, 0);
 		smp_mb();
 		if (!need_resched())
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
+		trace_cstate_end(&it);
 	} else
 		local_irq_enable();
 }
@@ -183,9 +195,12 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
+	struct cstate_trace it;
+	trace_cstate_start(&it, 0);
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
+	trace_cstate_end(&it);
 }
 
 /*
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 5812dba..fc477aa 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -232,6 +232,20 @@ static inline void start_boot_trace(void) { }
 static inline void stop_boot_trace(void) { }
 #endif
 
+struct cstate_trace {
+	ktime_t			stamp;
+	ktime_t			end;
+	int			state;
+};
+
+#ifdef CONFIG_CSTATE_TRACER
+extern void trace_cstate_start(struct cstate_trace *it, unsigned int state);
+extern void trace_cstate_end(struct cstate_trace *it);
+#else
+static inline void trace_cstate_start(struct cstate_trace *it, int state) { }
+static inline void trace_cstate_end(struct cstate_trace *it) { }
+#endif
+
 
 
 #endif /* _LINUX_FTRACE_H */
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 396aea1..92f91ae 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -134,6 +134,16 @@ config BOOT_TRACER
 	  be enabled if this tracer is selected since only one tracer
 	  should touch the tracing buffer at a time.
 
+config CSTATE_TRACER
+	bool "Trace C-state behavior"
+	depends on DEBUG_KERNEL
+	depends on X86
+	select TRACING
+	help
+	  This tracer helps developers to analyize and optimize the kernels
+	  power management decisions, specifically the C-state behavior.
+
+
 config STACK_TRACER
 	bool "Trace max stack"
 	depends on HAVE_FTRACE
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index a85dfba..2b85724 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -24,5 +24,6 @@ obj-$(CONFIG_NOP_TRACER) += trace_nop.o
 obj-$(CONFIG_STACK_TRACER) += trace_stack.o
 obj-$(CONFIG_MMIOTRACE) += trace_mmiotrace.o
 obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
+obj-$(CONFIG_CSTATE_TRACER) += trace_cstate.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f1f9957..06363df 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -22,6 +22,7 @@ enum trace_type {
 	TRACE_MMIO_RW,
 	TRACE_MMIO_MAP,
 	TRACE_BOOT,
+	TRACE_CSTATE,
 
 	__TRACE_LAST_TYPE
 };
@@ -117,6 +118,11 @@ struct trace_boot {
 	struct boot_trace	initcall;
 };
 
+struct trace_cstate {
+	struct trace_entry	ent;
+	struct cstate_trace	state_data;
+};
+
 /*
  * trace_flag_type is an enumeration that holds different
  * states when a trace occurs. These are:
@@ -217,6 +223,7 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct trace_mmiotrace_map,		\
 			  TRACE_MMIO_MAP);				\
 		IF_ASSIGN(var, ent, struct trace_boot, TRACE_BOOT);	\
+		IF_ASSIGN(var, ent, struct trace_cstate, TRACE_CSTATE); \
 		__ftrace_bad_type();					\
 	} while (0)
 
diff --git a/kernel/trace/trace_cstate.c b/kernel/trace/trace_cstate.c
new file mode 100644
index 0000000..f41dc7d
--- /dev/null
+++ b/kernel/trace/trace_cstate.c
@@ -0,0 +1,135 @@
+/*
+ * ring buffer based C-state tracer
+ *
+ * Arjan van de Ven <arjan@linux.intel.com>
+ * Copyright (C) 2009 Intel Corporation
+ *
+ * Much is borrowed from trace_boot.c which is
+ * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ */
+
+#include <linux/init.h>
+#include <linux/debugfs.h>
+#include <linux/ftrace.h>
+#include <linux/kallsyms.h>
+
+#include "trace.h"
+
+static struct trace_array *cstate_trace;
+static int trace_cstate_enabled;
+
+
+static void start_cstate_trace(void)
+{
+	trace_cstate_enabled = 1;
+}
+
+static void stop_cstate_trace(struct trace_array *tr)
+{
+	trace_cstate_enabled = 0;
+}
+
+static void cstate_trace_init(struct trace_array *tr)
+{
+	int cpu;
+	cstate_trace = tr;
+
+	trace_cstate_enabled = 1;
+
+	for_each_cpu_mask(cpu, cpu_possible_map)
+		tracing_reset(tr, cpu);
+}
+
+static void cstate_trace_ctrl_update(struct trace_array *tr)
+{
+	if (tr->ctrl)
+		start_cstate_trace();
+	else
+		stop_cstate_trace(tr);
+}
+
+static enum print_line_t cstate_print_line(struct trace_iterator *iter)
+{
+	int ret;
+	struct trace_entry *entry = iter->ent;
+	struct trace_cstate *field ;
+	struct cstate_trace *it;
+	struct trace_seq *s = &iter->seq;
+	struct timespec stamp;
+	struct timespec duration;
+
+	trace_assign_type(field, entry);
+	it = &field->state_data;
+	stamp = ktime_to_timespec(it->stamp);
+	duration = ktime_to_timespec(ktime_sub(it->end, it->stamp));
+
+	if (entry->type == TRACE_CSTATE) {
+		ret = trace_seq_printf(s, "[%5ld.%09ld] Going to C%i on cpu %i for %ld.%09ld\n",
+					  stamp.tv_sec,
+					  stamp.tv_nsec,
+					  it->state, iter->cpu,
+					  duration.tv_sec,
+					  duration.tv_nsec);
+		if (!ret)
+			return TRACE_TYPE_PARTIAL_LINE;
+		return TRACE_TYPE_HANDLED;
+	}
+	return TRACE_TYPE_UNHANDLED;
+}
+
+static struct tracer cstate_tracer __read_mostly =
+{
+	.name		= "cstate",
+	.init		= cstate_trace_init,
+	.reset		= stop_cstate_trace,
+	.ctrl_update	= cstate_trace_ctrl_update,
+	.print_line	= cstate_print_line,
+};
+
+static int init_cstate_trace(void)
+{
+	return register_tracer(&cstate_tracer);
+}
+device_initcall(init_cstate_trace);
+
+void trace_cstate_start(struct cstate_trace *it, unsigned int level)
+{
+	if (!trace_cstate_enabled)
+		return;
+
+	memset(it, 0, sizeof(struct cstate_trace));
+	it->state = level;
+	it->stamp = ktime_get();
+}
+
+void trace_cstate_end(struct cstate_trace *it)
+{
+	struct ring_buffer_event *event;
+	struct trace_cstate *entry;
+	struct trace_array_cpu *data;
+	unsigned long irq_flags;
+	struct trace_array *tr = cstate_trace;
+
+	if (!trace_cstate_enabled)
+		return;
+
+	preempt_disable();
+	it->end = ktime_get();
+	data = tr->data[smp_processor_id()];
+
+	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
+					 &irq_flags);
+	if (!event)
+		goto out;
+	entry	= ring_buffer_event_data(event);
+	tracing_generic_entry_update(&entry->ent, 0, 0);
+	entry->ent.type = TRACE_CSTATE;
+	entry->state_data = *it;
+	ring_buffer_unlock_commit(tr->buffer, event, irq_flags);
+
+	trace_wake_up();
+
+ out:
+	preempt_enable();
+}
diff --git a/scripts/trace/cstate.pl b/scripts/trace/cstate.pl
new file mode 100644
index 0000000..cd71033
--- /dev/null
+++ b/scripts/trace/cstate.pl
@@ -0,0 +1,84 @@
+#!/usr/bin/perl
+
+# Copyright 2008, Intel Corporation
+#
+# This file is part of the Linux kernel
+#
+# This program file is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License.
+#
+# This program is distributed in the hope that it will be useful, but WITHOUT
+# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+# for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program in a file named COPYING; if not, write to the
+# Free Software Foundation, Inc.,
+# 51 Franklin Street, Fifth Floor,
+# Boston, MA 02110-1301 USA
+#
+# Authors:
+# 	Arjan van de Ven <arjan@linux.intel.com>
+
+
+#
+# This script turns a cstate ftrace output into a SVG graphic that shows 
+# historic C-state information
+#
+#
+# 	cat /sys/kernel/debug/tracer/trace | perl cstate.pl > out.svg
+#
+
+my @rows;
+my @styles;
+my $base = 0;
+
+
+$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+$styles[8] = "fill:rgb(255,0,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
+my $stylecounter = 0;
+
+
+print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
+print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
+
+my $scale = 30000.0;
+while (<>) {
+	my $line = $_;
+	if ($line =~ /([0-9\.]+)\] Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
+#	if ($line =~ /([0-9\.]+)\] Going to C([0-9]) /) {
+		if ($base == 0) {
+			$base = $1;
+		}
+		my $time = $1 - $base;	
+		my $time = $time * $scale;
+		my $C = $2;
+		my $cpu = $3;
+		my $y = 200 * $cpu;
+		my $duration = $4 * $scale;
+		my $msec = int($4 * 100000)/100.0;
+		my $height = $C * 20;
+		$style = $styles[$C];
+		
+		$y = $y + 140 - $height;
+		
+		$x2 = $time + 4;
+		$y2 = $y + 4;
+
+
+		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
+		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
+	}
+}
+
+
+print "</svg>\n";
-- 
1.5.5.1

