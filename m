Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbZG1RVF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbZG1RVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:21:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZG1RSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:39 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:16501
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753584AbZG1RSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:09 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DS-03-BM5-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 24/26] x86/oprofile: Implement op_x86_virt_to_phys()
Date: Tue, 28 Jul 2009 19:07:24 +0200
Message-ID: <1248800846-25422-25-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:51.0572 (UTC) FILETIME=[56531140:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements a common x86 function to convert virtual counter
numbers to physical.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c      |    6 ++++++
 arch/x86/oprofile/op_model_amd.c |    2 +-
 arch/x86/oprofile/op_x86_model.h |    1 +
 3 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 7b3362f..5856e61 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -129,6 +129,11 @@ inline int op_x86_phys_to_virt(int phys)
 	return __get_cpu_var(switch_index) + phys;
 }
 
+inline int op_x86_virt_to_phys(int virt)
+{
+	return virt % model->num_counters;
+}
+
 static void nmi_shutdown_mux(void)
 {
 	int i;
@@ -270,6 +275,7 @@ static void mux_clone(int cpu)
 #else
 
 inline int op_x86_phys_to_virt(int phys) { return phys; }
+inline int op_x86_virt_to_phys(int virt) { return virt; }
 static inline void nmi_shutdown_mux(void) { }
 static inline int nmi_setup_mux(void) { return 1; }
 static inline void
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index dce69b5..1ea1982 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -81,7 +81,7 @@ static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = i % NUM_COUNTERS;
+		int hw_counter = op_x86_virt_to_phys(i);
 		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
 			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
 		else
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 4e2e7c2..b837761 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -60,6 +60,7 @@ struct op_counter_config;
 extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
 extern int op_x86_phys_to_virt(int phys);
+extern int op_x86_virt_to_phys(int virt);
 
 extern struct op_x86_model_spec op_ppro_spec;
 extern struct op_x86_model_spec op_p4_spec;
-- 
1.6.3.3


