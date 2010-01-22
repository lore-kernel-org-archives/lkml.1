Return-Path: <linux-kernel-owner+w=401wt.eu-S1755055Ab0AVO5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab0AVO5B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:57:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889Ab0AVO46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:56:58 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:46808 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0AVO44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:56:56 -0500
X-SpamScore: -2
X-BigFish: VPS-2(zzab9bh936eMzz1202hzzz32i6bh87h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KWNLFN-01-74C-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@googlemail.com>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 08/12] perf/core, x86: implement ARCH_PERFMON_EVENTSEL bit masks
Date: Fri, 22 Jan 2010 15:22:03 +0100
Message-ID: <1264170127-17402-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
References: <1264170127-17402-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jan 2010 14:54:55.0580 (UTC) FILETIME=[DC2A09C0:01CA9B72]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARCH_PERFMON_EVENTSEL bit masks are offen used in the kernel. This
patch adds macros for the bit masks and removes local defines.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/perf_event.h |   16 ++++++++++---
 arch/x86/kernel/cpu/perf_event.c  |   42 +++++++++++-------------------------
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index c7f723a..448bcf5 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -18,10 +18,18 @@
 #define MSR_ARCH_PERFMON_EVENTSEL0			     0x186
 #define MSR_ARCH_PERFMON_EVENTSEL1			     0x187
 
-#define ARCH_PERFMON_EVENTSEL_ENABLE			  (1 << 22)
-#define ARCH_PERFMON_EVENTSEL_INT			  (1 << 20)
-#define ARCH_PERFMON_EVENTSEL_OS			  (1 << 17)
-#define ARCH_PERFMON_EVENTSEL_USR			  (1 << 16)
+#define ARCH_PERFMON_EVENTSEL_EVENT			0x000000FFULL
+#define ARCH_PERFMON_EVENTSEL_UMASK			0x0000FF00ULL
+#define ARCH_PERFMON_EVENTSEL_USR			(1ULL << 16)
+#define ARCH_PERFMON_EVENTSEL_OS			(1ULL << 17)
+#define ARCH_PERFMON_EVENTSEL_EDGE			(1ULL << 18)
+#define ARCH_PERFMON_EVENTSEL_INT			(1ULL << 20)
+#define ARCH_PERFMON_EVENTSEL_ENABLE			(1ULL << 22)
+#define ARCH_PERFMON_EVENTSEL_INV			(1ULL << 23)
+#define ARCH_PERFMON_EVENTSEL_CMASK			0xFF000000ULL
+
+#define AMD64_EVENTSEL_EVENT	\
+	(ARCH_PERFMON_EVENTSEL_EVENT | 0x0FULL << 32)
 
 /*
  * Includes eventsel and unit mask as well:
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 96cbfe6..4eb0355 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -27,6 +27,16 @@
 #include <asm/stacktrace.h>
 #include <asm/nmi.h>
 
+#define X86_RAW_EVENT_MASK		\
+	(ARCH_PERFMON_EVENTSEL_EVENT |	\
+	 ARCH_PERFMON_EVENTSEL_UMASK |	\
+	 ARCH_PERFMON_EVENTSEL_EDGE  |	\
+	 ARCH_PERFMON_EVENTSEL_INV   |	\
+	 ARCH_PERFMON_EVENTSEL_CMASK)
+#define AMD64_RAW_EVENT_MASK		\
+	(X86_RAW_EVENT_MASK          |  \
+	 AMD64_EVENTSEL_EVENT)
+
 /* The maximal number of PEBS events: */
 #define MAX_PEBS_EVENTS	4
 
@@ -499,20 +509,7 @@ static __initconst u64 atom_hw_cache_event_ids
 
 static u64 intel_pmu_raw_event(u64 hw_event)
 {
-#define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
-#define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
-#define CORE_EVNTSEL_EDGE_MASK		0x00040000ULL
-#define CORE_EVNTSEL_INV_MASK		0x00800000ULL
-#define CORE_EVNTSEL_REG_MASK		0xFF000000ULL
-
-#define CORE_EVNTSEL_MASK		\
-	(CORE_EVNTSEL_EVENT_MASK |	\
-	 CORE_EVNTSEL_UNIT_MASK  |	\
-	 CORE_EVNTSEL_EDGE_MASK  |	\
-	 CORE_EVNTSEL_INV_MASK  |	\
-	 CORE_EVNTSEL_REG_MASK)
-
-	return hw_event & CORE_EVNTSEL_MASK;
+	return hw_event & X86_RAW_EVENT_MASK;
 }
 
 static __initconst u64 amd_hw_cache_event_ids
@@ -626,20 +623,7 @@ static u64 amd_pmu_event_map(int hw_event)
 
 static u64 amd_pmu_raw_event(u64 hw_event)
 {
-#define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
-#define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
-#define K7_EVNTSEL_EDGE_MASK	0x000040000ULL
-#define K7_EVNTSEL_INV_MASK	0x000800000ULL
-#define K7_EVNTSEL_REG_MASK	0x0FF000000ULL
-
-#define K7_EVNTSEL_MASK			\
-	(K7_EVNTSEL_EVENT_MASK |	\
-	 K7_EVNTSEL_UNIT_MASK  |	\
-	 K7_EVNTSEL_EDGE_MASK  |	\
-	 K7_EVNTSEL_INV_MASK   |	\
-	 K7_EVNTSEL_REG_MASK)
-
-	return hw_event & K7_EVNTSEL_MASK;
+	return hw_event & AMD64_RAW_EVENT_MASK;
 }
 
 /*
@@ -1427,7 +1411,7 @@ intel_get_event_idx(struct cpu_hw_events *cpuc, struct hw_perf_event *hwc)
 	if (!event_constraints)
 		goto skip;
 
-	code = hwc->config & CORE_EVNTSEL_EVENT_MASK;
+	code = hwc->config & ARCH_PERFMON_EVENTSEL_EVENT;
 
 	for_each_event_constraint(event_constraint, event_constraints) {
 		if (code == event_constraint->code) {
-- 
1.6.6


