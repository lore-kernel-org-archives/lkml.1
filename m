Return-Path: <linux-kernel-owner+w=401wt.eu-S1756323Ab0A2J23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756323Ab0A2J23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 04:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966Ab0A2J2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 04:28:25 -0500
Received: from hera.kernel.org ([140.211.167.34]:57417 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab0A2J2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 04:28:21 -0500
Date: Fri, 29 Jan 2010 09:27:33 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100122155535.595961269@chello.nl>
References: <20100122155535.595961269@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf_event: x86: Clean up some of the u64/long bitmask casting
Message-ID: <tip-c91e0f5da81c6f3a611a1bd6d0cca6717c90fdab@git.kernel.org>
Git-Commit-ID: c91e0f5da81c6f3a611a1bd6d0cca6717c90fdab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 29 Jan 2010 09:27:33 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c91e0f5da81c6f3a611a1bd6d0cca6717c90fdab
Gitweb:     http://git.kernel.org/tip/c91e0f5da81c6f3a611a1bd6d0cca6717c90fdab
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 22 Jan 2010 15:25:59 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 29 Jan 2010 09:01:37 +0100

perf_event: x86: Clean up some of the u64/long bitmask casting

We need this to be u64 for direct assigment, but the bitmask functions
all work on unsigned long, leading to cast heaven, solve this by using a
union.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100122155535.595961269@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |   47 ++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 7e181a5..921bbf7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
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
@@ -90,13 +91,14 @@ struct cpu_hw_events {
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
@@ -126,8 +128,11 @@ struct x86_pmu {
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
 
@@ -2144,14 +2149,11 @@ perf_event_nmi_handler(struct notifier_block *self,
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
 
@@ -2171,14 +2173,14 @@ static int intel_special_constraints(struct perf_event *event,
 
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
@@ -2186,10 +2188,7 @@ static void intel_get_event_constraints(struct cpu_hw_events *cpuc,
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
@@ -2200,10 +2199,10 @@ static void intel_get_event_constraints(struct cpu_hw_events *cpuc,
 
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
