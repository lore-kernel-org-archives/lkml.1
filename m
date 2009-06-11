Return-Path: <linux-kernel-owner+w=401wt.eu-S1762031AbZFKKA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762031AbZFKKA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 06:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761374AbZFKKAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 06:00:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:54784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761586AbZFKKAd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 06:00:33 -0400
Subject: [PATCH 2/2 -tip] x86: perf_counter update AMD hw caching related
 event table
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1244714289.6923.0.camel@ht.satnam>
References: <1244714289.6923.0.camel@ht.satnam>
Content-Type: text/plain
Date: Thu, 11 Jun 2009 15:29:39 +0530
Message-Id: <1244714379.6923.2.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


AMD shares same hw caching related event table.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   36 +++++++++++++++---------------------
 1 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 719a7d5..e7c9500 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -389,23 +389,23 @@ static u64 intel_pmu_raw_event(u64 event)
 	return event & CORE_EVNTSEL_MASK;
 }
 
-static const u64 amd_0f_hw_cache_event_ids
+static const u64 amd_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
 {
  [ C(L1D) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0042, /* Data Cache Refills from L2 */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0267, /* Data Prefetcher :attempts  */
+		[ C(RESULT_MISS)   ] = 0x0167, /* Data Prefetcher :cancelled */
 	},
  },
  [ C(L1I ) ] = {
@@ -418,17 +418,17 @@ static const u64 amd_0f_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x014B, /* Prefetch Instructions :Load */
 		[ C(RESULT_MISS)   ] = 0,
 	},
  },
  [ C(L2  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x037D, /* Requests to L2 Cache :IC+DC */
+		[ C(RESULT_MISS)   ] = 0x037E, /* L2 Cache Misses : IC+DC     */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x017F, /* L2 Fill/Writeback           */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
@@ -438,8 +438,8 @@ static const u64 amd_0f_hw_cache_event_ids
  },
  [ C(DTLB) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = 0,
-		[ C(RESULT_MISS)   ] = 0,
+		[ C(RESULT_ACCESS) ] = 0x0040, /* Data Cache Accesses        */
+		[ C(RESULT_MISS)   ] = 0x0046, /* L1 DTLB and L2 DLTB Miss   */
 	},
 	[ C(OP_WRITE) ] = {
 		[ C(RESULT_ACCESS) ] = 0,
@@ -1458,16 +1458,10 @@ static int amd_pmu_init(void)
 
 	x86_pmu = amd_pmu;
 
-	switch (boot_cpu_data.x86) {
-	case 0x0f:
-	case 0x10:
-	case 0x11:
-		memcpy(hw_cache_event_ids, amd_0f_hw_cache_event_ids,
-		       sizeof(hw_cache_event_ids));
+	/* Events are common for all AMDs */
+	memcpy(hw_cache_event_ids, amd_hw_cache_event_ids,
+	       sizeof(hw_cache_event_ids));
 
-		pr_cont("AMD Family 0f/10/11 events, ");
-		break;
-	}
 	return 0;
 }
 
-- 
1.6.0.6



