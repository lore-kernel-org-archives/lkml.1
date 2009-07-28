Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZG1RWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZG1RWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754781AbZG1RS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:29 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:33581 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450AbZG1RSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:05 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DP-03-BM0-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 12/26] oprofile: Grouping multiplexing code in op_model_amd.c
Date: Tue, 28 Jul 2009 19:07:12 +0200
Message-ID: <1248800846-25422-13-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:49.0056 (UTC) FILETIME=[54D32800:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves some multiplexing code to the new function
op_mux_fill_in_addresses(). Also, the whole multiplexing code is now
at a single location.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   75 +++++++++++++++++++++-----------------
 1 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 67f830d..644980f 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -74,6 +74,45 @@ static struct op_ibs_config ibs_config;
 
 #endif
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
+		int hw_counter = i % NUM_COUNTERS;
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
+		else
+			msrs->multiplex[i].addr = 0;
+	}
+}
+
+static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#else
+
+static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
+
+#endif
+
 /* functions for op_amd_spec */
 
 static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
@@ -94,15 +133,7 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 			msrs->controls[i].addr = 0;
 	}
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
-		int hw_counter = i % NUM_COUNTERS;
-		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
-			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
-		else
-			msrs->multiplex[i].addr = 0;
-	}
-#endif
+	op_mux_fill_in_addresses(msrs);
 }
 
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
@@ -155,30 +186,6 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	}
 }
 
-
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void op_amd_switch_ctrl(struct op_x86_model_spec const *model,
-			       struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!counter_config[virt].enabled)
-			continue;
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
-#endif
-
-
 #ifdef CONFIG_OPROFILE_IBS
 
 static inline int
@@ -535,6 +542,6 @@ struct op_x86_model_spec const op_amd_spec = {
 	.stop			= &op_amd_stop,
 	.shutdown		= &op_amd_shutdown,
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-	.switch_ctrl		= &op_amd_switch_ctrl,
+	.switch_ctrl		= &op_mux_switch_ctrl,
 #endif
 };
-- 
1.6.3.3


