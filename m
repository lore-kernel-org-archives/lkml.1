Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582Ab0AVOzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0AVOzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377Ab0AVOzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:15 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:16137 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab0AVOzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:12 -0500
X-SpamScore: 5
X-BigFish: VPS5(z1039ozab9bh936eMzz1202hzzz32i87h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFL-02-1LI-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/12] perf/core, x86: make event constraint handler generic
Date: Fri, 22 Jan 2010 15:22:07 +0100
Message-ID: <1264170127-17402-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0768 (UTC) FILETIME=[DC46B980:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the handler for event constraints that was
implemented for Intel pmus general for all models. Now, an event
constraint table can be implemented and used also for AMD models.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   43 +++++++++++++++-----------------------
 1 files changed, 17 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b893ee7..ac2d3a7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1387,47 +1387,38 @@ static int fixed_mode_idx(struct hw_perf_event *hwc)
 }
 
 /*
- * generic counter allocator: get next free counter
+ * generic counter allocator
  */
 static int
 gen_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
-	int idx;
-
-again:
-	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_counters);
-	if (idx == x86_pmu.num_counters)
-		return -1;
-	if (test_and_set_bit(idx, cpuc->used_mask))
-		goto again;
-	return idx;
-}
-
-/*
- * intel-specific counter allocator: check event constraints
- */
-static inline int
-__intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
-{
 	const struct event_constraint *event_constraint;
-	int i, code;
+	int idx, code;
 
 	if (!x86_pmu.event_constraints)
-		goto skip;
+		goto get_next_free;
 
 	code = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
 
+	/* check event constraints */
 	for_each_event_constraint(event_constraint, x86_pmu.event_constraints) {
 		if (code == event_constraint->code) {
-			for_each_bit(i, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
-				if (!test_and_set_bit(i, cpuc->used_mask))
-					return i;
+			for_each_bit(idx, event_constraint->idxmsk, X86_PMC_IDX_MAX) {
+				if (!test_and_set_bit(idx, cpuc->used_mask))
+					return idx;
 			}
 			return -1;
 		}
 	}
-skip:
-	return gen_get_event_idx(cpuc, hwc);
+
+get_next_free:
+	/* get next free counter */
+	idx = find_first_zero_bit(cpuc->used_mask, x86_pmu.num_counters);
+	if (idx == x86_pmu.num_counters)
+		return -1;
+	if (test_and_set_bit(idx, cpuc->used_mask))
+		goto get_next_free;
+	return idx;
 }
 
 static int
@@ -1465,7 +1456,7 @@ intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 		/* Try to get the previous generic event again */
 		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = __intel_get_event_idx(cpuc, hwc);
+			idx = gen_get_event_idx(cpuc, hwc);
 			if (idx == -1)
 				return -EAGAIN;
 
-- 
1.6.6


