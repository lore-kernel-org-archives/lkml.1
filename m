Return-Path: <linux-kernel-owner+w=401wt.eu-S1753338AbZG1RSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbZG1RSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbZG1RSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:18:23 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:31292
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753317AbZG1RSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:18:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i87h203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KNI5DO-03-BLW-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 11/26] oprofile: Introduce op_x86_phys_to_virt()
Date: Tue, 28 Jul 2009 19:07:11 +0200
Message-ID: <1248800846-25422-12-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
References: <1248800846-25422-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 17:17:48.0884 (UTC) FILETIME=[54B8E940:01CA0FA7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This new function translates physical to virtual counter numbers.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c      |   43 +++++++++++---------
 arch/x86/oprofile/op_model_amd.c |   80 +++++++++++++++-----------------------
 arch/x86/oprofile/op_x86_model.h |    1 +
 3 files changed, 55 insertions(+), 69 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index b211d33..02b57b8 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -27,12 +27,6 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
-
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-DEFINE_PER_CPU(int, switch_index);
-#endif
-
-
 static struct op_x86_model_spec const *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
@@ -103,6 +97,21 @@ static void nmi_cpu_save_registers(struct op_msrs *msrs)
 	}
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static DEFINE_PER_CPU(int, switch_index);
+
+inline int op_x86_phys_to_virt(int phys)
+{
+	return __get_cpu_var(switch_index) + phys;
+}
+
+#else
+
+inline int op_x86_phys_to_virt(int phys) { return phys; }
+
+#endif
+
 static void free_msrs(void)
 {
 	int i;
@@ -248,31 +257,25 @@ static int nmi_setup(void)
 
 static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
 {
-	unsigned int si = __get_cpu_var(switch_index);
 	struct op_msr *multiplex = msrs->multiplex;
-	unsigned int i;
+	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
-		int offset = i + si;
-		if (multiplex[offset].addr) {
-			rdmsrl(multiplex[offset].addr,
-			       multiplex[offset].saved);
-		}
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
 	}
 }
 
 static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
 {
-	unsigned int si = __get_cpu_var(switch_index);
 	struct op_msr *multiplex = msrs->multiplex;
-	unsigned int i;
+	int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
-		int offset = i + si;
-		if (multiplex[offset].addr) {
-			wrmsrl(multiplex[offset].addr,
-			       multiplex[offset].saved);
-		}
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
 	}
 }
 
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index dcfd450..67f830d 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -42,9 +42,6 @@
 #define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
 
 static unsigned long reset_value[NUM_VIRT_COUNTERS];
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-DECLARE_PER_CPU(int, switch_index);
-#endif
 
 #ifdef CONFIG_OPROFILE_IBS
 
@@ -141,21 +138,20 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		int offset = i + __get_cpu_var(switch_index);
-#else
-		int offset = i;
-#endif
-		if (counter_config[offset].enabled && msrs->counters[i].addr) {
-			/* setup counter registers */
-			wrmsrl(msrs->counters[i].addr, -(u64)reset_value[offset]);
-
-			/* setup control registers */
-			rdmsrl(msrs->controls[i].addr, val);
-			val &= model->reserved;
-			val |= op_x86_get_ctrl(model, &counter_config[offset]);
-			wrmsrl(msrs->controls[i].addr, val);
-		}
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		if (!msrs->counters[i].addr)
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
 	}
 }
 
@@ -170,14 +166,13 @@ static void op_amd_switch_ctrl(struct op_x86_model_spec const *model,
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		int offset = i + __get_cpu_var(switch_index);
-		if (counter_config[offset].enabled) {
-			/* setup control registers */
-			rdmsrl(msrs->controls[i].addr, val);
-			val &= model->reserved;
-			val |= op_x86_get_ctrl(model, &counter_config[offset]);
-			wrmsrl(msrs->controls[i].addr, val);
-		}
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
 
@@ -292,19 +287,15 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		int offset = i + __get_cpu_var(switch_index);
-#else
-		int offset = i;
-#endif
-		if (!reset_value[offset])
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
 		/* bit is clear if overflowed: */
 		if (val & OP_CTR_OVERFLOW)
 			continue;
-		oprofile_add_sample(regs, offset);
-		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[offset]);
+		oprofile_add_sample(regs, virt);
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
 	}
 
 	op_amd_handle_ibs(regs, msrs);
@@ -319,16 +310,11 @@ static void op_amd_start(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		int offset = i + __get_cpu_var(switch_index);
-#else
-		int offset = i;
-#endif
-		if (reset_value[offset]) {
-			rdmsrl(msrs->controls[i].addr, val);
-			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
-			wrmsrl(msrs->controls[i].addr, val);
-		}
+		if (!reset_value[op_x86_phys_to_virt(i)])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	op_amd_start_ibs();
@@ -344,11 +330,7 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	 * pm callback
 	 */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
-		if (!reset_value[i + per_cpu(switch_index, smp_processor_id())])
-#else
-		if (!reset_value[i])
-#endif
+		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
 		rdmsrl(msrs->controls[i].addr, val);
 		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 0d07d23..e874dc3 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -60,6 +60,7 @@ struct op_counter_config;
 
 extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
 			   struct op_counter_config *counter_config);
+extern int op_x86_phys_to_virt(int phys);
 
 extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
-- 
1.6.3.3


