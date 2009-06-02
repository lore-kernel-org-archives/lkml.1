Return-Path: <linux-kernel-owner+w=401wt.eu-S1758875AbZFBEoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbZFBEoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 00:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756520AbZFBEnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 00:43:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:35698 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbZFBEni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 00:43:38 -0400
Message-Id: <20090602044339.565690900@goodmis.org>
References: <20090602044315.439593107@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Jun 2009 00:43:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 02/10] tracing: fix config options to not show when automatically selected
Content-Disposition: inline; filename=0002-tracing-fix-config-options-to-not-show-when-automati.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are two options that are selected by all tracers, but we want
to have those options available when no tracer is selected. These are

 The event tracer and sched switch tracer.

The are enabled by all tracers, but if a tracer is not selected we want
the options to appear. All tracers including them select TRACING.
Thus what we would like to do is:

  config EVENT_TRACER
	bool "prompt"
	depends on TRACING
	select TRACING

But that gives us a bug in the kbuild system since we just created a
circular dependency. We only want the prompt to show when TRACING is off.

This patch adds GENERIC_TRACER that all tracers will select instead of
TRACING. The two options (sched switch and event tracer) will select
TRACING directly and depend on !GENERIC_TRACER. This solves the cicular
dependency.

[ Impact: hide options that are selected by default ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig |   43 ++++++++++++++++++++++++++++---------------
 1 files changed, 28 insertions(+), 15 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a508b9d..6e55cc3 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -56,6 +56,13 @@ config CONTEXT_SWITCH_TRACER
 	select MARKERS
 	bool
 
+# All tracer options should select GENERIC_TRACER. For those options that are
+# enabled by all tracers (context switch and event tracer) they select TRACING.
+# This allows those options to appear when no other tracer is selected. But the
+# options do not appear when something else selects it. We need the two options
+# GENERIC_TRACER and TRACING to avoid circular dependencies to accomplish the
+# hidding of the automatic options options.
+
 config TRACING
 	bool
 	select DEBUG_FS
@@ -66,6 +73,10 @@ config TRACING
 	select BINARY_PRINTF
 	select EVENT_TRACING
 
+config GENERIC_TRACER
+	bool
+	select TRACING
+
 #
 # Minimum requirements an architecture has to meet for us to
 # be able to offer generic tracing facilities:
@@ -95,7 +106,7 @@ config FUNCTION_TRACER
 	depends on HAVE_FUNCTION_TRACER
 	select FRAME_POINTER
 	select KALLSYMS
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  Enable the kernel to trace every kernel function. This is done
@@ -126,7 +137,7 @@ config IRQSOFF_TRACER
 	depends on TRACE_IRQFLAGS_SUPPORT
 	depends on GENERIC_TIME
 	select TRACE_IRQFLAGS
-	select TRACING
+	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	help
 	  This option measures the time spent in irqs-off critical
@@ -147,7 +158,7 @@ config PREEMPT_TRACER
 	default n
 	depends on GENERIC_TIME
 	depends on PREEMPT
-	select TRACING
+	select GENERIC_TRACER
 	select TRACER_MAX_TRACE
 	help
 	  This option measures the time spent in preemption off critical
@@ -166,7 +177,7 @@ config PREEMPT_TRACER
 config SYSPROF_TRACER
 	bool "Sysprof Tracer"
 	depends on X86
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer provides the trace needed by the 'Sysprof' userspace
@@ -174,7 +185,7 @@ config SYSPROF_TRACER
 
 config SCHED_TRACER
 	bool "Scheduling Latency Tracer"
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	select TRACER_MAX_TRACE
 	help
@@ -183,6 +194,7 @@ config SCHED_TRACER
 
 config ENABLE_CONTEXT_SWITCH_TRACER
 	bool "Trace process context switches"
+	depends on !GENERIC_TRACER
 	select TRACING
 	select CONTEXT_SWITCH_TRACER
 	help
@@ -191,6 +203,7 @@ config ENABLE_CONTEXT_SWITCH_TRACER
 
 config ENABLE_EVENT_TRACING
 	bool "Trace various events in the kernel"
+	depends on !GENERIC_TRACER
 	select TRACING
 	help
 	  This tracer hooks to various trace points in the kernel
@@ -204,14 +217,14 @@ config ENABLE_EVENT_TRACING
 config FTRACE_SYSCALLS
 	bool "Trace syscalls"
 	depends on HAVE_FTRACE_SYSCALLS
-	select TRACING
+	select GENERIC_TRACER
 	select KALLSYMS
 	help
 	  Basic tracer to catch the syscall entry and exit events.
 
 config BOOT_TRACER
 	bool "Trace boot initcalls"
-	select TRACING
+	select GENERIC_TRACER
 	select CONTEXT_SWITCH_TRACER
 	help
 	  This tracer helps developers to optimize boot times: it records
@@ -228,7 +241,7 @@ config BOOT_TRACER
 
 config TRACE_BRANCH_PROFILING
 	bool
-	select TRACING
+	select GENERIC_TRACER
 
 choice
 	prompt "Branch Profiling"
@@ -308,7 +321,7 @@ config BRANCH_TRACER
 config POWER_TRACER
 	bool "Trace power consumption behavior"
 	depends on X86
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  This tracer helps developers to analyze and optimize the kernels
 	  power management decisions, specifically the C-state and P-state
@@ -342,14 +355,14 @@ config STACK_TRACER
 config HW_BRANCH_TRACER
 	depends on HAVE_HW_BRANCH_TRACER
 	bool "Trace hw branches"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  This tracer records all branches on the system in a circular
 	  buffer giving access to the last N branches for each cpu.
 
 config KMEMTRACE
 	bool "Trace SLAB allocations"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  kmemtrace provides tracing for slab allocator functions, such as
 	  kmalloc, kfree, kmem_cache_alloc, kmem_cache_free etc.. Collected
@@ -369,7 +382,7 @@ config KMEMTRACE
 
 config WORKQUEUE_TRACER
 	bool "Trace workqueues"
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  The workqueue tracer provides some statistical informations
           about each cpu workqueue thread such as the number of the
@@ -385,7 +398,7 @@ config BLK_DEV_IO_TRACE
 	select RELAY
 	select DEBUG_FS
 	select TRACEPOINTS
-	select TRACING
+	select GENERIC_TRACER
 	select STACKTRACE
 	help
 	  Say Y here if you want to be able to trace the block layer actions
@@ -446,7 +459,7 @@ config FTRACE_SELFTEST
 
 config FTRACE_STARTUP_TEST
 	bool "Perform a startup test on ftrace"
-	depends on TRACING
+	depends on GENERIC_TRACER
 	select FTRACE_SELFTEST
 	help
 	  This option performs a series of startup tests on ftrace. On bootup
@@ -457,7 +470,7 @@ config FTRACE_STARTUP_TEST
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
 	depends on HAVE_MMIOTRACE_SUPPORT && PCI
-	select TRACING
+	select GENERIC_TRACER
 	help
 	  Mmiotrace traces Memory Mapped I/O access and is meant for
 	  debugging and reverse engineering. It is called from the ioremap
-- 
1.6.3.1

-- 
