Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab0CDQt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:56 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:48302 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab0CDQtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:52 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO26-01-NBO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 2/9] oprofile, perf, x86: do not allocate evntsel counter msr
Date: Thu, 4 Mar 2010 16:22:04 +0100
Message-ID: <1267716131-17908-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0098 (UTC) FILETIME=[9F189520:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two msrs must be reserverd per generic counter though both are
depending each other. Allocating the evntsel counter msr is not
necessary if the corresponding perfctr msr is already reserved. This
patch removes evntsel counter msr reservation.

This is implemented for AMD and P6 models only. for P4 still the
legacy code is used, so no changes there.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   15 +--------------
 arch/x86/kernel/cpu/perfctr-watchdog.c |    6 ------
 arch/x86/kernel/tsc.c                  |    2 --
 arch/x86/oprofile/op_model_amd.c       |   11 ++---------
 arch/x86/oprofile/op_model_ppro.c      |   11 ++---------
 5 files changed, 5 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 96b3a98..62a1a5e 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -248,19 +248,8 @@ static bool reserve_pmc_hardware(void)
 			goto perfctr_fail;
 	}
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
-		if (!reserve_evntsel_nmi(x86_pmu.eventsel + i))
-			goto eventsel_fail;
-	}
-
 	return true;
 
-eventsel_fail:
-	for (i--; i >= 0; i--)
-		release_evntsel_nmi(x86_pmu.eventsel + i);
-
-	i = x86_pmu.num_events;
-
 perfctr_fail:
 	for (i--; i >= 0; i--)
 		release_perfctr_nmi(x86_pmu.perfctr + i);
@@ -275,10 +264,8 @@ static void release_pmc_hardware(void)
 {
 	int i;
 
-	for (i = 0; i < x86_pmu.num_events; i++) {
+	for (i = 0; i < x86_pmu.num_events; i++)
 		release_perfctr_nmi(x86_pmu.perfctr + i);
-		release_evntsel_nmi(x86_pmu.eventsel + i);
-	}
 
 	if (nmi_watchdog == NMI_LOCAL_APIC)
 		enable_lapic_nmi_watchdog();
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fb329e9..5c129ee 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -313,17 +313,11 @@ static int single_msr_reserve(void)
 {
 	if (!reserve_perfctr_nmi(wd_ops->perfctr))
 		return 0;
-
-	if (!reserve_evntsel_nmi(wd_ops->evntsel)) {
-		release_perfctr_nmi(wd_ops->perfctr);
-		return 0;
-	}
 	return 1;
 }
 
 static void single_msr_unreserve(void)
 {
-	release_evntsel_nmi(wd_ops->evntsel);
 	release_perfctr_nmi(wd_ops->perfctr);
 }
 
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 597683a..ff98ef2 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -883,7 +883,6 @@ static unsigned long __init calibrate_cpu(void)
 		rdmsrl(MSR_K7_PERFCTR3, pmc3);
 	} else {
 		reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 	local_irq_save(flags);
 	/* start measuring cycles, incrementing from 0 */
@@ -902,7 +901,6 @@ static unsigned long __init calibrate_cpu(void)
 		wrmsrl(MSR_K7_EVNTSEL3, evntsel3);
 	} else {
 		release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
-		release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 
 	return pmc_now * tsc_khz / (tsc_now - tsc_start);
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 090cbbe..79e79a6 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -134,13 +134,10 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i)) {
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-	}
-
-	for (i = 0; i < NUM_CONTROLS; i++) {
-		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		}
 	}
 }
 
@@ -433,10 +430,6 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
-	}
 }
 
 static u8 ibs_eilvt_off;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 2bf90fa..d6abdf6 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -35,13 +35,10 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < num_counters; i++) {
-		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
+		if (!reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i)) {
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
-	}
-
-	for (i = 0; i < num_counters; i++) {
-		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
+		}
 	}
 }
 
@@ -197,10 +194,6 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 	}
-	for (i = 0; i < num_counters; ++i) {
-		if (msrs->controls[i].addr)
-			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
-	}
 	if (reset_value) {
 		kfree(reset_value);
 		reset_value = NULL;
-- 
1.7.0


