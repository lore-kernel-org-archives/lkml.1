Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbZCSTnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbZCSTnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbZCSTnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:43:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:46793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbZCSTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:43:20 -0400
Message-Id: <20090319194233.744044174@chello.nl>
References: <20090319192610.660857280@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Mar 2009 20:26:17 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, paulus@samba.org, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 07/10] perf_counter: hook up the tracepoint events
Content-Disposition: inline; filename=perf_swcounter_event.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable usage of tracepoints as perf counter events.

tracepoint event ids can be found in /debug/tracing/event/*/*/id
and (for now) are represented as -65536+id in the type field.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_counter.h |    3 +++
 init/Kconfig                 |    5 +++++
 kernel/perf_counter.c        |   43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

Index: linux-2.6/include/linux/perf_counter.h
===================================================================
--- linux-2.6.orig/include/linux/perf_counter.h
+++ linux-2.6/include/linux/perf_counter.h
@@ -53,6 +53,8 @@ enum hw_event_types {
 	PERF_COUNT_PAGE_FAULTS_MAJ	= -7,
 
 	PERF_SW_EVENTS_MIN		= -8,
+
+	PERF_TP_EVENTS_MIN		= -65536
 };
 
 /*
@@ -222,6 +224,7 @@ struct perf_counter {
 	struct perf_data		*usrdata;
 	struct perf_data		data[2];
 
+	void (*destroy)(struct perf_counter *);
 	struct rcu_head			rcu_head;
 #endif
 };
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1152,6 +1152,9 @@ static void free_counter_rcu(struct rcu_
 
 static void free_counter(struct perf_counter *counter)
 {
+	if (counter->destroy)
+		counter->destroy(counter);
+
 	call_rcu(&counter->rcu_head, free_counter_rcu);
 }
 
@@ -1727,6 +1730,45 @@ static const struct hw_perf_counter_ops 
 	.read		= cpu_migrations_perf_counter_read,
 };
 
+#ifdef CONFIG_EVENT_PROFILE
+void perf_tpcounter_event(int event_id)
+{
+	perf_swcounter_event(PERF_TP_EVENTS_MIN + event_id, 1, 1,
+			task_pt_regs(current));
+}
+
+extern int ftrace_profile_enable(int);
+extern void ftrace_profile_disable(int);
+
+static void tp_perf_counter_destroy(struct perf_counter *counter)
+{
+	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
+
+	ftrace_profile_disable(event_id);
+}
+
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	int event_id = counter->hw_event.type - PERF_TP_EVENTS_MIN;
+	int ret;
+
+	ret = ftrace_profile_enable(event_id);
+	if (ret)
+		return NULL;
+
+	counter->destroy = tp_perf_counter_destroy;
+
+	return &perf_ops_generic;
+}
+#else
+static const struct hw_perf_counter_ops *
+tp_perf_counter_init(struct perf_counter *counter)
+{
+	return NULL;
+}
+#endif
+
 static const struct hw_perf_counter_ops *
 sw_perf_counter_init(struct perf_counter *counter)
 {
@@ -1772,6 +1814,7 @@ sw_perf_counter_init(struct perf_counter
 			hw_ops = &perf_ops_cpu_migrations;
 		break;
 	default:
+		hw_ops = tp_perf_counter_init(counter);
 		break;
 	}
 
Index: linux-2.6/init/Kconfig
===================================================================
--- linux-2.6.orig/init/Kconfig
+++ linux-2.6/init/Kconfig
@@ -945,6 +945,11 @@ config PERF_COUNTERS
 
 	  Say Y if unsure.
 
+config EVENT_PROFILE
+	bool "Tracepoint profile sources"
+	depends on PERF_COUNTERS && EVENT_TRACER
+	default y
+
 endmenu
 
 config VM_EVENT_COUNTERS

-- 

