Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874Ab0AVOzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab0AVOzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:55:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754838Ab0AVOzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:55:41 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:9061 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0AVOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:55:39 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFL-02-1LH-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 10/12] perf/core, x86: removing fixed counter handling for AMD pmu
Date: Fri, 22 Jan 2010 15:22:05 +0100
Message-ID: <1264170127-17402-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0627 (UTC) FILETIME=[DC3135B0:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD pmu does not support fixed counters. Thus, fixed counters may
not be considered for scheduling decissions. This patch implements an
AMD specific event scheduler without fixed counter calculation that
also improves code performance in the fast path.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3f81f91..3e0fc29 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1407,8 +1407,8 @@ again:
 /*
  * intel-specific counter allocator: check event constraints
  */
-static int
-intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
+static inline int
+__intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
 	const struct event_constraint *event_constraint;
 	int i, code;
@@ -1432,7 +1432,7 @@ skip:
 }
 
 static int
-x86_schedule_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
+intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 {
 	int idx;
 
@@ -1466,7 +1466,7 @@ x86_schedule_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 		/* Try to get the previous generic event again */
 		if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
 try_generic:
-			idx = x86_pmu.get_event_idx(cpuc, hwc);
+			idx = __intel_get_event_idx(cpuc, hwc);
 			if (idx == -1)
 				return -EAGAIN;
 
@@ -1479,6 +1479,32 @@ try_generic:
 	return idx;
 }
 
+static int
+amd_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
+{
+	int idx;
+
+	idx = hwc->idx;
+	/* Try to get the previous generic event again */
+	if (idx == -1 || test_and_set_bit(idx, cpuc->used_mask)) {
+		idx = gen_get_event_idx(cpuc, hwc);
+		if (idx == -1)
+			return -EAGAIN;
+
+		hwc->idx = idx;
+	}
+	hwc->config_base = x86_pmu.eventsel;
+	hwc->event_base  = x86_pmu.perfctr;
+
+	return idx;
+}
+
+static int
+x86_schedule_event(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
+{
+	return x86_pmu.get_event_idx(cpuc, hwc);
+}
+
 /*
  * Find a PMC slot for the freshly enabled / scheduled in event:
  */
@@ -2008,7 +2034,7 @@ static __initconst struct x86_pmu amd_pmu = {
 	.apic			= 1,
 	/* use highest bit to detect overflow */
 	.max_period		= (1ULL << 47) - 1,
-	.get_event_idx		= gen_get_event_idx,
+	.get_event_idx		= amd_get_event_idx,
 };
 
 static __init int p6_pmu_init(void)
-- 
1.6.6


