Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965544Ab0BZRgQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:16 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39741 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965476Ab0BZRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:01 -0500
X-SpamScore: 0
X-BigFish: VPS0(zba6lz936eMab9bhzz1202hzzz32i6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7R-02-2LR-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>, stable@kernel.org
Subject: [PATCH 10/15] oprofile/x86: fix perfctr nmi reservation for mulitplexing
Date: Fri, 26 Feb 2010 18:30:02 +0100
Message-ID: <1267205407-6523-11-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0367 (UTC) FILETIME=[21891B70:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple virtual counters share one physical counter. The reservation
of virtual counters fails due to duplicate allocation of the same
counter. The counters are already reserved. Thus, virtual counter
reservation may removed at all. This also makes the code easier.

Cc: stable@kernel.org
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c      |   11 ++++++-----
 arch/x86/oprofile/op_model_amd.c |   19 -------------------
 2 files changed, 6 insertions(+), 24 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 3347f69..7170d1e 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -179,7 +179,6 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 		if (counter_config[i].enabled) {
 			multiplex[i].saved = -(u64)counter_config[i].count;
 		} else {
-			multiplex[i].addr  = 0;
 			multiplex[i].saved = 0;
 		}
 	}
@@ -189,25 +188,27 @@ static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
 
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			rdmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
 {
+	struct op_msr *counters = msrs->counters;
 	struct op_msr *multiplex = msrs->multiplex;
 	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
 		int virt = op_x86_phys_to_virt(i);
-		if (multiplex[virt].addr)
-			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+		if (counters[i].addr)
+			wrmsrl(counters[i].addr, multiplex[virt].saved);
 	}
 }
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index ef9d735..2aab018 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -118,19 +118,6 @@ static u32 get_ibs_caps(void)
 
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
-static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = op_x86_virt_to_phys(i);
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
-		else
-			msrs->multiplex[i].addr = 0;
-	}
-}
-
 static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 			       struct op_msrs const * const msrs)
 {
@@ -149,10 +136,6 @@ static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
 	}
 }
 
-#else
-
-static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
-
 #endif
 
 /* functions for op_amd_spec */
@@ -174,8 +157,6 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 		else
 			msrs->controls[i].addr = 0;
 	}
-
-	op_mux_fill_in_addresses(msrs);
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
-- 
1.6.6


