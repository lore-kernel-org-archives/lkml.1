Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab0CDQtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:40 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:47519 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab0CDQtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:35 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO28-02-MPJ-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 8/9] oprofile/x86: group IBS code
Date: Thu, 4 Mar 2010 16:22:10 +0100
Message-ID: <1267716131-17908-9-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
References: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0348 (UTC) FILETIME=[9F3EBAC0:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moving code in preparation of the next patch. This groups all IBS code
together.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |  202 +++++++++++++++++++-------------------
 1 files changed, 101 insertions(+), 101 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 128d84c..9c0d978 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -105,107 +105,6 @@ static u32 get_ibs_caps(void)
 	return ibs_caps;
 }
 
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-
-static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
-			       struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
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
-/* functions for op_amd_spec */
-
-static void op_amd_shutdown(struct op_msrs const * const msrs);
-
-static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
-{
-	int i;
-
-	for (i = 0; i < NUM_COUNTERS; i++) {
-		if (reserve_perfctr(i)) {
-			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
-			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
-		} else if (counter_config[i].enabled) {
-			op_x86_warn_reserved(i);
-			op_amd_shutdown(msrs);
-			return -EBUSY;
-		}
-	}
-
-	return 0;
-}
-
-static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
-			      struct op_msrs const * const msrs)
-{
-	u64 val;
-	int i;
-
-	/* setup reset_value */
-	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
-		if (counter_config[i].enabled
-		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
-			reset_value[i] = counter_config[i].count;
-		else
-			reset_value[i] = 0;
-	}
-
-	/* clear all counters */
-	for (i = 0; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!msrs->controls[i].addr)) {
-			if (counter_config[i].enabled && !smp_processor_id())
-				/*
-				 * counter is reserved, this is on all
-				 * cpus, so report only for cpu #0
-				 */
-				op_x86_warn_reserved(i);
-			continue;
-		}
-		rdmsrl(msrs->controls[i].addr, val);
-		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
-			op_x86_warn_in_use(i);
-		val &= model->reserved;
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-
-	/* avoid a false detection of ctr overflows in NMI handler */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!msrs->counters[i].addr))
-			continue;
-		wrmsrl(msrs->counters[i].addr, -1LL);
-	}
-
-	/* enable active counters */
-	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int virt = op_x86_phys_to_virt(i);
-		if (!reset_value[virt])
-			continue;
-
-		/* setup counter registers */
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
-
-		/* setup control registers */
-		rdmsrl(msrs->controls[i].addr, val);
-		val &= model->reserved;
-		val |= op_x86_get_ctrl(model, &counter_config[virt]);
-		wrmsrl(msrs->controls[i].addr, val);
-	}
-}
-
 /*
  * 16-bit Linear Feedback Shift Register (LFSR)
  *
@@ -370,6 +269,107 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
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
+		if (!reset_value[virt])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#endif
+
+/* functions for op_amd_spec */
+
+static void op_amd_shutdown(struct op_msrs const * const msrs);
+
+static int op_amd_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_COUNTERS; i++) {
+		if (reserve_perfctr(i)) {
+			msrs->counters[i].addr = MSR_K7_PERFCTR0 + i;
+			msrs->controls[i].addr = MSR_K7_EVNTSEL0 + i;
+		} else if (counter_config[i].enabled) {
+			op_x86_warn_reserved(i);
+			op_amd_shutdown(msrs);
+			return -EBUSY;
+		}
+	}
+
+	return 0;
+}
+
+static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
+			      struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled
+		    && msrs->counters[op_x86_virt_to_phys(i)].addr)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
+	/* clear all counters */
+	for (i = 0; i < NUM_CONTROLS; ++i) {
+		if (unlikely(!msrs->controls[i].addr)) {
+			if (counter_config[i].enabled && !smp_processor_id())
+				/*
+				 * counter is reserved, this is on all
+				 * cpus, so report only for cpu #0
+				 */
+				op_x86_warn_reserved(i);
+			continue;
+		}
+		rdmsrl(msrs->controls[i].addr, val);
+		if (val & ARCH_PERFMON_EVENTSEL_ENABLE)
+			op_x86_warn_in_use(i);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+
+	/* avoid a false detection of ctr overflows in NMI handler */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (unlikely(!msrs->counters[i].addr))
+			continue;
+		wrmsrl(msrs->counters[i].addr, -1LL);
+	}
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
+			continue;
+
+		/* setup counter registers */
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
+
+		/* setup control registers */
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
-- 
1.7.0


