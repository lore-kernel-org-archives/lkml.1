Return-Path: <linux-kernel-owner+w=401wt.eu-S1759520AbZD2LAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759520AbZD2LAM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756503AbZD2Kvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:38 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:23631
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753602AbZD2KvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:03 -0400
X-BigFish: VPS-1(z5edJzzz1202hzzz32i61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGQ-02-18Q-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 25/29] x86/perfcounters: return raw count with x86_perf_counter_update()
Date: Wed, 29 Apr 2009 12:47:22 +0200
Message-ID: <1241002046-8832-26-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0555 (UTC) FILETIME=[5BBEFA30:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To check on AMD cpus if a counter overflows, the upper bit of the raw
counter value must be checked. This value is already internally
available in x86_perf_counter_update(). Now, the value is returned so
that it can be used directly to check for overflows.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index f4d59d4..a8a53ab 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -132,7 +132,7 @@ static u64 amd_pmu_raw_event(u64 event)
  * Can only be executed on the CPU where the counter is active.
  * Returns the delta events processed.
  */
-static void
+static u64
 x86_perf_counter_update(struct perf_counter *counter,
 			struct hw_perf_counter *hwc, int idx)
 {
@@ -165,6 +165,8 @@ again:
 
 	atomic64_add(delta, &counter->count);
 	atomic64_sub(delta, &hwc->period_left);
+
+	return new_raw_count;
 }
 
 static atomic_t num_counters;
@@ -785,8 +787,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs, int nmi)
 			continue;
 		counter = cpuc->counters[idx];
 		hwc = &counter->hw;
-		x86_perf_counter_update(counter, hwc, idx);
-		val = atomic64_read(&hwc->prev_count);
+		val = x86_perf_counter_update(counter, hwc, idx);
 		if (val & (1ULL << (x86_pmu.counter_bits - 1)))
 			continue;
 		/* counter overflow */
-- 
1.6.1.3


