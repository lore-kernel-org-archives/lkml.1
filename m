Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbYFZAF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbYFZAF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 20:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbYFZAFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 20:05:15 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:39864 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751827AbYFZAFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 20:05:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYFAK9zYkhMQWVt/2dsb2JhbACBW7Fo
Date: Wed, 25 Jun 2008 19:55:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: [RFC PATCH] Tracepoint sched probes
Message-ID: <20080625235507.GB14249@Krystal>
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <48612879.5090809@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:52:16 up 21 days,  4:33,  3 users,  load average: 2.47, 1.65,
	1.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

** note : early RFC. This patch applies on a unreleased LTTng for
2.6.26-rc8 patchset.

Scheduler tracepoint probes

Only a single probe is implement as a POC.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Peter Zijlstra' <peterz@infradead.org>
CC: "Frank Ch. Eigler" <fche@redhat.com>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: 'Hideo AOKI' <haoki@redhat.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>
CC: 'Steven Rostedt' <rostedt@goodmis.org>
---
 init/Kconfig         |    7 +++++++
 kernel/Makefile      |    1 +
 kernel/sched-trace.c |   28 ++++++++++++++++++++++++++++
 kernel/sched-trace.h |   11 +++++++++++
 kernel/sched.c       |    5 +++--
 5 files changed, 50 insertions(+), 2 deletions(-)

Index: linux-2.6.26-rc7-lttng/kernel/sched-trace.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc7-lttng/kernel/sched-trace.c	2008-06-25 18:36:11.000000000 -0400
@@ -0,0 +1,28 @@
+#include <linux/module.h>
+#include "sched-trace.h"
+
+static void probe_sched_switch(void *private_data, struct task_struct *prev,
+	struct task_struct *next)
+{
+	trace_mark(kernel_sched_schedule,
+		"prev_pid %d next_pid %d prev_state %ld",
+		prev->pid, next->pid, prev->state);
+}
+
+int __init sched_trace_init(void)
+{
+	return register_trace_sched_switch(probe_sched_switch, NULL);
+}
+
+module_init(sched_trace_init);
+
+void __exit sched_trace_exit(void)
+{
+	unregister_trace_sched_switch(probe_sched_switch, NULL);
+}
+
+module_exit(sched_trace_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mathieu Desnoyers");
+MODULE_DESCRIPTION("Scheduler Tracpoint Probes");
Index: linux-2.6.26-rc7-lttng/kernel/sched-trace.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.26-rc7-lttng/kernel/sched-trace.h	2008-06-25 18:36:11.000000000 -0400
@@ -0,0 +1,11 @@
+#ifndef _KERNEL_SCHED_TRACE_H
+#define _KERNEL_SCHED_TRACE_H
+
+#include <linux/sched.h>
+#include <linux/tracepoint.h>
+
+DEFINE_TRACE(sched_switch,
+	TPPROTO(struct task_struct *prev, struct task_struct *next),
+	TPARGS(prev, next));
+
+#endif
Index: linux-2.6.26-rc7-lttng/kernel/sched.c
===================================================================
--- linux-2.6.26-rc7-lttng.orig/kernel/sched.c	2008-06-25 18:35:42.000000000 -0400
+++ linux-2.6.26-rc7-lttng/kernel/sched.c	2008-06-25 18:36:11.000000000 -0400
@@ -75,6 +75,8 @@
 #include <asm/tlb.h>
 #include <asm/irq_regs.h>
 
+#include "sched-trace.h"
+
 /*
  * Convert user-nice values [ -20 ... 0 ... 19 ]
  * to static priority [ MAX_RT_PRIO..MAX_PRIO-1 ],
@@ -2458,8 +2460,7 @@
 	struct mm_struct *mm, *oldmm;
 
 	prepare_task_switch(rq, prev, next);
-	trace_mark(internal_kernel_sched_schedule,
-		"prev %p next %p", prev, next);
+	trace_sched_switch(prev, next);
 	mm = next->mm;
 	oldmm = prev->active_mm;
 	/*
Index: linux-2.6.26-rc7-lttng/kernel/Makefile
===================================================================
--- linux-2.6.26-rc7-lttng.orig/kernel/Makefile	2008-06-25 18:35:42.000000000 -0400
+++ linux-2.6.26-rc7-lttng/kernel/Makefile	2008-06-25 18:36:11.000000000 -0400
@@ -70,6 +70,7 @@
 obj-$(USE_IMMEDIATE) += immediate.o
 obj-$(CONFIG_MARKERS) += marker.o
 obj-$(CONFIG_TRACEPOINTS) += tracepoint.o
+obj-$(CONFIG_SCHED_TRACE) += sched-trace.o
 obj-$(CONFIG_LATENCYTOP) += latencytop.o
 
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
Index: linux-2.6.26-rc7-lttng/init/Kconfig
===================================================================
--- linux-2.6.26-rc7-lttng.orig/init/Kconfig	2008-06-25 18:36:07.000000000 -0400
+++ linux-2.6.26-rc7-lttng/init/Kconfig	2008-06-25 18:36:26.000000000 -0400
@@ -789,6 +789,13 @@
 	  Place an empty function call at each tracepoint site. Can be
 	  dynamically changed for a probe function.
 
+config SCHED_TRACE
+	depends on TRACEPOINTS
+	tristate "Scheduler tracing"
+	default y
+	help
+	  Build the scheduler tracing probes.
+
 config MARKERS
 	bool "Activate markers"
 	help

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
