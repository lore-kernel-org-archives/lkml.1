Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0CDQtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:52 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:56290 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121Ab0CDQtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:49 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i87h2a8h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO23-02-MP9-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/9] oprofile, perf, x86: introduce new functions to reserve perfctrs by index
Date: Thu, 4 Mar 2010 16:22:05 +0100
Message-ID: <1267716131-17908-4-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0145 (UTC) FILETIME=[9F1FC110:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current perfctr reservation code allocates single pmu msrs. The msr
addresses may differ depending on the model and offset calculation is
necessary. This can be easier implemented by reserving a counter by
its index only.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/include/asm/nmi.h             |    2 ++
 arch/x86/kernel/cpu/perfctr-watchdog.c |   29 ++++++++++++++++++++---------
 arch/x86/oprofile/op_model_amd.c       |    4 ++--
 arch/x86/oprofile/op_model_ppro.c      |    4 ++--
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index 93da9c3..f5db47d 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -19,6 +19,8 @@ extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
 extern int avail_to_resrv_perfctr_nmi_bit(unsigned int);
+extern int reserve_perfctr(unsigned int);
+extern void release_perfctr(unsigned int);
 extern int reserve_perfctr_nmi(unsigned int);
 extern void release_perfctr_nmi(unsigned int);
 extern int reserve_evntsel_nmi(unsigned int);
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index 5c129ee..0868b8b 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -117,11 +117,8 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
 }
 EXPORT_SYMBOL(avail_to_resrv_perfctr_nmi_bit);
 
-int reserve_perfctr_nmi(unsigned int msr)
+int reserve_perfctr(unsigned int counter)
 {
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
 	/* register not managed by the allocator? */
 	if (counter > NMI_MAX_COUNTER_BITS)
 		return 1;
@@ -130,19 +127,33 @@ int reserve_perfctr_nmi(unsigned int msr)
 		return 1;
 	return 0;
 }
-EXPORT_SYMBOL(reserve_perfctr_nmi);
+EXPORT_SYMBOL(reserve_perfctr);
 
-void release_perfctr_nmi(unsigned int msr)
+void release_perfctr(unsigned int counter)
 {
-	unsigned int counter;
-
-	counter = nmi_perfctr_msr_to_bit(msr);
 	/* register not managed by the allocator? */
 	if (counter > NMI_MAX_COUNTER_BITS)
 		return;
 
 	clear_bit(counter, perfctr_nmi_owner);
 }
+EXPORT_SYMBOL(release_perfctr);
+
+int reserve_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+	counter = nmi_perfctr_msr_to_bit(msr);
+	return reserve_perfctr(counter);
+}
+EXPORT_SYMBOL(reserve_perfctr_nmi);
+
+void release_perfctr_nmi(unsigned int msr)
+{
+	unsigned int counter;
+
+	counter = nmi_perfctr_msr_to_bit(msr);
+	release_perfctr(counter);
+}
 EXPORT_SYMBOL(release_perfctr_nmi);
 
 int reserve_evntsel_nmi(unsigned int msr)
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 79e79a6..905995d 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -134,7 +134,7 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i)) {
+		if (reserve_perfctr(i)) {
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
 		}
@@ -428,7 +428,7 @@ static void op_amd_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
+			release_perfctr(i);
 	}
 }
 
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index d6abdf6..a838ee4 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -35,7 +35,7 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < num_counters; i++) {
-		if (!reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i)) {
+		if (reserve_perfctr(i)) {
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
 		}
@@ -192,7 +192,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 
 	for (i = 0; i < num_counters; ++i) {
 		if (msrs->counters[i].addr)
-			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
+			release_perfctr(i);
 	}
 	if (reset_value) {
 		kfree(reset_value);
-- 
1.7.0


