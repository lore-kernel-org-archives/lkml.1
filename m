Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965561Ab0BZRjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:39:45 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10482
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965510Ab0BZRgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:05 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7T-02-2LW-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>, stable@kernel.org
Subject: [PATCH 11/15] oprofile/x86: use kzalloc() instead of kmalloc()
Date: Fri, 26 Feb 2010 18:30:03 +0100
Message-ID: <1267205407-6523-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0492 (UTC) FILETIME=[219C2E40:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |    6 +++---
 arch/x86/oprofile/op_model_amd.c  |    4 ----
 arch/x86/oprofile/op_model_p4.c   |    6 ------
 arch/x86/oprofile/op_model_ppro.c |    6 +-----
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 7170d1e..2c505ee 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -159,7 +159,7 @@ static int nmi_setup_mux(void)
 
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).multiplex =
-			kmalloc(multiplex_size, GFP_KERNEL);
+			kzalloc(multiplex_size, GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).multiplex)
 			return 0;
 	}
@@ -304,11 +304,11 @@ static int allocate_msrs(void)
 
 	int i;
 	for_each_possible_cpu(i) {
-		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
+		per_cpu(cpu_msrs, i).counters = kzalloc(counters_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).counters)
 			return 0;
-		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
+		per_cpu(cpu_msrs, i).controls = kzalloc(controls_size,
 							GFP_KERNEL);
 		if (!per_cpu(cpu_msrs, i).controls)
 			return 0;
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 2aab018..f4ebc45 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -147,15 +147,11 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < NUM_COUNTERS; i++) {
 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < NUM_CONTROLS; i++) {
 		if (reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
 }
 
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index ac6b354..e6a160a 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -394,12 +394,6 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 	setup_num_counters();
 	stag = get_stagger();
 
-	/* initialize some registers */
-	for (i = 0; i < num_counters; ++i)
-		msrs->counters[i].addr = 0;
-	for (i = 0; i < num_controls; ++i)
-		msrs->controls[i].addr = 0;
-
 	/* the counter & cccr registers we pay attention to */
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index c344525..5d1727b 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -37,15 +37,11 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_perfctr_nmi(MSR_P6_PERFCTR0 + i))
 			msrs->counters[i].addr = MSR_P6_PERFCTR0 + i;
-		else
-			msrs->counters[i].addr = 0;
 	}
 
 	for (i = 0; i < num_counters; i++) {
 		if (reserve_evntsel_nmi(MSR_P6_EVNTSEL0 + i))
 			msrs->controls[i].addr = MSR_P6_EVNTSEL0 + i;
-		else
-			msrs->controls[i].addr = 0;
 	}
 }
 
@@ -57,7 +53,7 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	int i;
 
 	if (!reset_value) {
-		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
+		reset_value = kzalloc(sizeof(reset_value[0]) * num_counters,
 					GFP_ATOMIC);
 		if (!reset_value)
 			return;
-- 
1.6.6


