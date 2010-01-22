Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758Ab0AVQB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab0AVQB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 11:01:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846Ab0AVP7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:59:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41702 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755549Ab0AVP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:59:42 -0500
Message-Id: <20100122155535.595961269@chello.nl>
References: <20100122155044.391857484@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 22 Jan 2010 16:50:49 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@google.com, fweisbec@gmail.com, paulus@samba.org, mingo@elte.hu,
       davem@davemloft.net, robert.richter@amd.com
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 05/10] perf_event: x86: Clean up some of the u64/long bitmask casting
Content-Disposition: inline; filename=perf-change-idxmask-type.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need this to be u64 for direct assigment, but the bitmask functions
all work on unsigned long, leading to cast heaven, solve this by using a
union.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 arch/x86/kernel/cpu/perf_event.c |   47 +++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -69,10 +69,11 @@ struct debug_store {
 	u64	pebs_event_reset[MAX_PEBS_EVENTS];
 };
 
-#define BITS_TO_U64(nr) DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(u64))
-
 struct event_constraint {
-	u64	idxmsk[BITS_TO_U64(X86_PMC_IDX_MAX)];
+	union {
+		unsigned long	idxmsk[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+		u64		idxmsk64[1];
+	};
 	int	code;
 	int	cmask;
 };
@@ -91,13 +92,14 @@ struct cpu_hw_events {
 	struct perf_event	*event_list[X86_PMC_IDX_MAX]; /* in enabled order */
 };
 
-#define EVENT_CONSTRAINT(c, n, m) { \
-	.code = (c),	\
-	.cmask = (m),	\
-	.idxmsk[0] = (n) }
+#define EVENT_CONSTRAINT(c, n, m) { 	\
+	{ .idxmsk64[0] = (n) },		\
+	.code = (c),			\
+	.cmask = (m),			\
+}
 
 #define EVENT_CONSTRAINT_END \
-	{ .code = 0, .cmask = 0, .idxmsk[0] = 0 }
+	EVENT_CONSTRAINT(0, 0, 0)
 
 #define for_each_event_constraint(e, c) \
 	for ((e) = (c); (e)->cmask; (e)++)
@@ -127,8 +129,11 @@ struct x86_pmu {
 	u64		intel_ctrl;
 	void		(*enable_bts)(u64 config);
 	void		(*disable_bts)(void);
-	void		(*get_event_constraints)(struct cpu_hw_events *cpuc, struct perf_event *event, u64 *idxmsk);
-	void		(*put_event_constraints)(struct cpu_hw_events *cpuc, struct perf_event *event);
+	void		(*get_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event,
+						 unsigned long *idxmsk);
+	void		(*put_event_constraints)(struct cpu_hw_events *cpuc,
+						 struct perf_event *event);
 	const struct event_constraint *event_constraints;
 };
 
@@ -2154,14 +2159,11 @@ perf_event_nmi_handler(struct notifier_b
 	return NOTIFY_STOP;
 }
 
-static struct event_constraint bts_constraint = {
-	.code = 0,
-	.cmask = 0,
-	.idxmsk[0] = 1ULL << X86_PMC_IDX_FIXED_BTS
-};
+static struct event_constraint bts_constraint =
+	EVENT_CONSTRAINT(0, 1ULL << X86_PMC_IDX_FIXED_BTS, 0);
 
 static int intel_special_constraints(struct perf_event *event,
-				     u64 *idxmsk)
+				     unsigned long *idxmsk)
 {
 	unsigned int hw_event;
 
@@ -2181,14 +2183,14 @@ static int intel_special_constraints(str
 
 static void intel_get_event_constraints(struct cpu_hw_events *cpuc,
 					struct perf_event *event,
-					u64 *idxmsk)
+					unsigned long *idxmsk)
 {
 	const struct event_constraint *c;
 
 	/*
 	 * cleanup bitmask
 	 */
-	bitmap_zero((unsigned long *)idxmsk, X86_PMC_IDX_MAX);
+	bitmap_zero(idxmsk, X86_PMC_IDX_MAX);
 
 	if (intel_special_constraints(event, idxmsk))
 		return;
@@ -2196,10 +2198,7 @@ static void intel_get_event_constraints(
 	if (x86_pmu.event_constraints) {
 		for_each_event_constraint(c, x86_pmu.event_constraints) {
 			if ((event->hw.config & c->cmask) == c->code) {
-
-				bitmap_copy((unsigned long *)idxmsk,
-					    (unsigned long *)c->idxmsk,
-					    X86_PMC_IDX_MAX);
+				bitmap_copy(idxmsk, c->idxmsk, X86_PMC_IDX_MAX);
 				return;
 			}
 		}
@@ -2210,10 +2209,10 @@ static void intel_get_event_constraints(
 
 static void amd_get_event_constraints(struct cpu_hw_events *cpuc,
 				      struct perf_event *event,
-				      u64 *idxmsk)
+				      unsigned long *idxmsk)
 {
 	/* no constraints, means supports all generic counters */
-	bitmap_fill((unsigned long *)idxmsk, x86_pmu.num_events);
+	bitmap_fill(idxmsk, x86_pmu.num_events);
 }
 
 static int x86_event_sched_in(struct perf_event *event,

-- 

