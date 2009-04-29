Return-Path: <linux-kernel-owner+w=401wt.eu-S1757057AbZD2Kw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057AbZD2Kw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:52:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZD2KvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:51:08 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:23631
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754860AbZD2KvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:51:01 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-FB-SS: 5,
X-WSS-ID: 0KIUZGO-02-18N-01
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 04/29] x86/perfcounters: rework pmc_amd_save_disable_all() and pmc_amd_restore_all()
Date: Wed, 29 Apr 2009 12:47:01 +0200
Message-ID: <1241002046-8832-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 29 Apr 2009 10:50:49.0039 (UTC) FILETIME=[5B703DF0:01C9C8B8]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MSR reads and writes are expensive. This patch adds checks to avoid
its usage where possible.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_counter.c |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index d6d6529..75a0903 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -334,11 +334,13 @@ static u64 pmc_amd_save_disable_all(void)
 	for (idx = 0; idx < nr_counters_generic; idx++) {
 		u64 val;
 
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
 		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
-			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		}
+		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
+			continue;
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 
 	return enabled;
@@ -372,13 +374,15 @@ static void pmc_amd_restore_all(u64 ctrl)
 		return;
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
-		if (test_bit(idx, cpuc->active_mask)) {
-			u64 val;
+		u64 val;
 
-			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
-		}
+		if (!test_bit(idx, cpuc->active_mask))
+			continue;
+		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
+		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
+			continue;
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
 	}
 }
 
-- 
1.6.1.3


