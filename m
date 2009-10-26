Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZJZVUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZJZVUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 17:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbZJZVUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 17:20:15 -0400
Received: from e28smtp09.in.ibm.com ([59.145.155.9]:52806 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753449AbZJZVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 17:20:11 -0400
Date: Tue, 27 Oct 2009 02:50:09 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [RFC Patch 4/4] Enable perf-events to use hw-breakpoints
Message-ID: <20091026212009.GE15529@in.ibm.com>
References: <20091026211225.214925175@xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline; filename=perf_hbkpt_integration_04
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable perf-events to collect memory access statistics on kernel-space
data in the context of a running process.

TODO: Fix issues caused by this patch to parsing of other events.
Allow kernel-space addresses to be specified in addition to symbol name.
Fix the issues seen with the target process when run through perf.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 include/linux/perf_event.h     |   17 ++++++
 kernel/perf_event.c            |  101 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c |   42 +++++++++++++++++
 3 files changed, 159 insertions(+), 1 deletion(-)

Index: linux-2.6-tip.perf_hbkpt/include/linux/perf_event.h
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/include/linux/perf_event.h
+++ linux-2.6-tip.perf_hbkpt/include/linux/perf_event.h
@@ -31,6 +31,7 @@ enum perf_type_id {
 	PERF_TYPE_TRACEPOINT			= 2,
 	PERF_TYPE_HW_CACHE			= 3,
 	PERF_TYPE_RAW				= 4,
+	PERF_TYPE_BREAKPOINT			= 5,
 
 	PERF_TYPE_MAX,				/* non-ABI */
 };
@@ -106,6 +107,14 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
 
+/* Various breakpoint types for monitoring accesses over variables */
+enum perf_bp_id {
+	PERF_COUNT_BP_WRITE		= 0,
+	PERF_COUNT_BP_RW		= 1,
+
+	PERF_COUNT_BP_MAX,		/* non-ABI */
+};
+
 /*
  * Bits that can be set in attr.sample_type to request information
  * in the overflow packets.
@@ -207,6 +216,10 @@ struct perf_event_attr {
 		__u32		wakeup_events;	  /* wakeup every n events */
 		__u32		wakeup_watermark; /* bytes before wakeup   */
 	};
+
+	/* Store the symbol name for breakpoint request */
+	char			ksym_name[128];
+
 	__u32			__reserved_2;
 
 	__u64			__reserved_3;
@@ -476,6 +489,10 @@ struct hw_perf_event {
 			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
+		struct { /* hardware breakpoints */
+			struct hw_breakpoint	*bp;
+			int			counter;
+		};
 	};
 	atomic64_t			prev_count;
 	u64				sample_period;
Index: linux-2.6-tip.perf_hbkpt/kernel/perf_event.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/kernel/perf_event.c
+++ linux-2.6-tip.perf_hbkpt/kernel/perf_event.c
@@ -4,7 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
- *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
+ *  Copyright  ï¿½  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  * For licensing details see kernel-base/COPYING
  */
@@ -31,6 +31,7 @@
 #include <linux/ftrace_event.h>
 
 #include <asm/irq_regs.h>
+#include <asm/hw_breakpoint.h>
 
 /*
  * Each CPU has a list of per CPU events:
@@ -4124,6 +4125,27 @@ static const struct pmu perf_ops_task_cl
 	.read		= task_clock_perf_event_read,
 };
 
+static int breakpoint_perf_event_enable(struct perf_event *event)
+{
+	enable_hw_breakpoint(event->hw.bp);
+	return 0;
+}
+
+static void breakpoint_perf_event_disable(struct perf_event *event)
+{
+	disable_hw_breakpoint(event->hw.bp);
+}
+
+static void breakpoint_perf_event_read(struct perf_event *event)
+{
+}
+
+static const struct pmu perf_ops_breakpoint = {
+	.enable		= breakpoint_perf_event_enable,
+	.disable	= breakpoint_perf_event_disable,
+	.read		= breakpoint_perf_event_read,
+};
+
 #ifdef CONFIG_EVENT_PROFILE
 
 void perf_tp_event(int event_id, u64 addr, u64 count, void *record,
@@ -4285,6 +4307,79 @@ static const struct pmu *sw_perf_event_i
 	return pmu;
 }
 
+static void perf_breakpoint_handler(struct hw_breakpoint *bp,
+					struct pt_regs *regs)
+{
+	int event_id = 0;
+
+	switch (bp->info.type) {
+	case HW_BREAKPOINT_WRITE:
+		event_id = PERF_COUNT_BP_WRITE;
+		break;
+
+	case HW_BREAKPOINT_RW:
+		event_id = PERF_COUNT_BP_RW;
+		break;
+
+	default:
+		return;
+	}
+
+	do_perf_sw_event(PERF_TYPE_BREAKPOINT, event_id, 1, 1,
+			 NULL, regs);
+}
+
+static void breakpoint_perf_event_destroy(struct perf_event *event)
+{
+	struct hw_breakpoint *bp = event->hw.bp;
+
+	unregister_kernel_hw_breakpoint(bp);
+	kfree(bp);
+}
+
+static const struct pmu *breakpoint_perf_event_init(struct perf_event *event,
+						    int cpu, gfp_t gfpflags)
+{
+	int ret;
+	struct perf_event_attr *attr = &event->attr;
+	u64 event_id = attr->config;
+	struct hw_breakpoint *bp;
+
+	bp = event->hw.bp = kzalloc(sizeof(struct hw_breakpoint), gfpflags);
+	if (!bp)
+		return ERR_PTR(-ENOMEM);
+
+	switch (event_id) {
+
+	case PERF_COUNT_BP_WRITE:
+		bp->info.type = HW_BREAKPOINT_WRITE;
+		break;
+	case PERF_COUNT_BP_RW:
+		bp->info.type = HW_BREAKPOINT_RW;
+		break;
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+
+	bp->info.len = HW_BREAKPOINT_LEN_1;
+	bp->triggered = perf_breakpoint_handler;
+
+	if (attr->ksym_name)
+		bp->info.name = attr->ksym_name;
+	else
+		return ERR_PTR(-EINVAL);
+
+	if (cpu != -1)
+		bp->cpumask = cpumask_of(cpu);
+
+	ret = register_kernel_hw_breakpoint(bp);
+	if (ret)
+		return ERR_PTR(ret);
+
+	event->destroy = breakpoint_perf_event_destroy;
+	return &perf_ops_breakpoint;
+}
+
 /*
  * Allocate and initialize a event structure
  */
@@ -4370,6 +4465,10 @@ perf_event_alloc(struct perf_event_attr 
 		pmu = tp_perf_event_init(event);
 		break;
 
+	case PERF_TYPE_BREAKPOINT:
+		pmu = breakpoint_perf_event_init(event, cpu, gfpflags);
+		break;
+
 	default:
 		break;
 	}
Index: linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.c
===================================================================
--- linux-2.6-tip.perf_hbkpt.orig/tools/perf/util/parse-events.c
+++ linux-2.6-tip.perf_hbkpt/tools/perf/util/parse-events.c
@@ -30,6 +30,7 @@ char debugfs_path[MAXPATHLEN];
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
 #define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
+#define CBP(x) .type = PERF_TYPE_BREAKPOINT, .config = PERF_COUNT_BP_##x
 
 static struct event_symbol event_symbols[] = {
   { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
@@ -47,6 +48,9 @@ static struct event_symbol event_symbols
   { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
   { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
   { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
+
+  { CBP(WRITE),			"breakpoint-write",	""		},
+  { CBP(RW),			"breakpoint-readwrite", ""		},
 };
 
 #define __PERF_EVENT_FIELD(config, name) \
@@ -77,6 +81,11 @@ static const char *sw_event_names[] = {
 	"major-faults",
 };
 
+static const char *hbp_event_names[] = {
+	"breakpoint-write",
+	"breakpoint-readwrite",
+};
+
 #define MAX_ALIASES 8
 
 static const char *hw_cache[][MAX_ALIASES] = {
@@ -322,6 +331,9 @@ const char *__event_name(int type, u64 c
 	case PERF_TYPE_TRACEPOINT:
 		return tracepoint_id_to_name(config);
 
+	case PERF_TYPE_BREAKPOINT:
+		return hbp_event_names[config];
+
 	default:
 		break;
 	}
@@ -621,6 +633,31 @@ parse_numeric_event(const char **strp, s
 }
 
 static enum event_result
+parse_hbp_event(const char **strp, struct perf_event_attr *attr)
+{
+	unsigned int i, flag = 0;
+
+	char *bp_data = (char *)(*strp);
+	char *bp_event_name = strsep(&bp_data, ":");
+
+	for (i = 0; i < ARRAY_SIZE(hbp_event_names); i++) {
+		if (strncmp(bp_event_name, hbp_event_names[i],
+						strlen(bp_event_name)))
+			continue;
+		attr->config = i;
+		flag = 1;
+	}
+	if (flag == 0)
+		return EVT_FAILED;
+
+	attr->type = PERF_TYPE_BREAKPOINT;
+	strcpy(attr->ksym_name, bp_data);
+	*strp = (*strp) + strlen(*strp) + strlen(bp_data) + 1;
+
+	return EVT_HANDLED;
+}
+
+static enum event_result
 parse_event_modifier(const char **strp, struct perf_event_attr *attr)
 {
 	const char *str = *strp;
@@ -670,6 +707,10 @@ parse_event_symbols(const char **str, st
 	if (ret != EVT_FAILED)
 		goto modifier;
 
+	ret = parse_hbp_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
 	ret = parse_symbolic_event(str, attr);
 	if (ret != EVT_FAILED)
 		goto modifier;
@@ -773,6 +814,7 @@ static const char * const event_type_des
 	"Software event",
 	"Tracepoint event",
 	"Hardware cache event",
+	"Breakpoint event"
 };
 
 /*

