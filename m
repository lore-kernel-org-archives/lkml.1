Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbZFLNFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbZFLNFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762800AbZFLM7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:59:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56502 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762809AbZFLM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:59:33 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz655Nzz1202hzzz32i17ch43j)
X-FB-SS: 5,13,
X-WSS-ID: 0KL4MQN-04-6AI-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 15/23] x86/oprofile: replace macros to calculate control register
Date: Fri, 12 Jun 2009 14:35:32 +0200
Message-ID: <1244810140-20595-16-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
References: <1244810140-20595-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 12 Jun 2009 12:59:07.0623 (UTC) FILETIME=[9253EF70:01C9EB5D]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces op_x86_get_ctrl() to calculate the value of the
performance control register. This is generic code usable for all
models. The event and reserved masks are model specific and stored in
struct op_x86_model_spec. 64 bit MSR functions are used now. The patch
removes many hard to read macros used for ctrl calculation.

The function op_x86_get_ctrl() is common code and the first step to
further merge performance counter implementations for x86 models.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/nmi_int.c       |   20 ++++++++++++++++++
 arch/x86/oprofile/op_model_amd.c  |   41 ++++++++++++++----------------------
 arch/x86/oprofile/op_model_ppro.c |   29 +++++++++++--------------
 arch/x86/oprofile/op_x86_model.h  |   15 ++++++++++---
 4 files changed, 60 insertions(+), 45 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index c31f87b..388ee15 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -31,6 +31,26 @@ static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+/* common functions */
+
+u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
+		    struct op_counter_config *counter_config)
+{
+	u64 val = 0;
+	u16 event = (u16)counter_config->event;
+
+	val |= ARCH_PERFMON_EVENTSEL_INT;
+	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
+	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
+	val |= (counter_config->unit_mask & 0xFF) << 8;
+	event &= model->event_mask ? model->event_mask : 0xFF;
+	val |= event & 0xFF;
+	val |= (event & 0x0F00) << 24;
+
+	return val;
+}
+
+
 static int profile_exceptions_notify(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 86e0a01..2406ab8 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -25,12 +25,11 @@
 
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
+#define OP_EVENT_MASK			0x0FFF
+
+#define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
 
 #define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-#define CTRL_CLEAR_LO(x) (x &= (1<<21))
-#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
-#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
-#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
 
 static unsigned long reset_value[NUM_COUNTERS];
 
@@ -84,21 +83,19 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 	}
 }
 
-
 static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 			      struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	/* clear all counters */
 	for (i = 0 ; i < NUM_CONTROLS; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
-		rdmsr(msrs->controls[i].addr, low, high);
-		CTRL_CLEAR_LO(low);
-		CTRL_CLEAR_HI(high);
-		wrmsr(msrs->controls[i].addr, low, high);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
@@ -112,19 +109,11 @@ static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
 	for (i = 0; i < NUM_COUNTERS; ++i) {
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
-
 			wrmsr(msrs->counters[i].addr, -(unsigned int)counter_config[i].count, -1);
-
-			rdmsr(msrs->controls[i].addr, low, high);
-			CTRL_CLEAR_LO(low);
-			CTRL_CLEAR_HI(high);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
-			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
-			wrmsr(msrs->controls[i].addr, low, high);
+			rdmsrl(msrs->controls[i].addr, val);
+			val &= model->reserved;
+			val |= op_x86_get_ctrl(model, &counter_config[i]);
+			wrmsrl(msrs->controls[i].addr, val);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -486,14 +475,16 @@ static void op_amd_exit(void) {}
 #endif /* CONFIG_OPROFILE_IBS */
 
 struct op_x86_model_spec const op_amd_spec = {
-	.init			= op_amd_init,
-	.exit			= op_amd_exit,
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
+	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
+	.event_mask		= OP_EVENT_MASK,
+	.init			= op_amd_init,
+	.exit			= op_amd_exit,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
-	.shutdown		= &op_amd_shutdown
+	.shutdown		= &op_amd_shutdown,
 };
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 40b44ee..3092f99 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -10,6 +10,7 @@
  * @author Philippe Elie
  * @author Graydon Hoare
  * @author Andi Kleen
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #include <linux/oprofile.h>
@@ -26,8 +27,8 @@ static int num_counters = 2;
 static int counter_width = 32;
 
 #define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
-#define CTRL_CLEAR(x) (x &= (1<<21))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+
+#define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
 
 static u64 *reset_value;
 
@@ -54,7 +55,7 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 			    struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value) {
@@ -85,9 +86,9 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	for (i = 0 ; i < num_counters; ++i) {
 		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
-		rdmsr(msrs->controls[i].addr, low, high);
-		CTRL_CLEAR(low);
-		wrmsr(msrs->controls[i].addr, low, high);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
@@ -101,17 +102,11 @@ static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
 	for (i = 0; i < num_counters; ++i) {
 		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
-
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
-
-			rdmsr(msrs->controls[i].addr, low, high);
-			CTRL_CLEAR(low);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
-			wrmsr(msrs->controls[i].addr, low, high);
+			rdmsrl(msrs->controls[i].addr, val);
+			val &= model->reserved;
+			val |= op_x86_get_ctrl(model, &counter_config[i]);
+			wrmsrl(msrs->controls[i].addr, val);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -205,6 +200,7 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 struct op_x86_model_spec const op_ppro_spec = {
 	.num_counters		= 2,
 	.num_controls		= 2,
+	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
 	.check_ctrs		= &ppro_check_ctrs,
@@ -249,6 +245,7 @@ static int arch_perfmon_init(struct oprofile_operations *ignore)
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {
+	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.init			= &arch_perfmon_init,
 	/* num_counters/num_controls filled in at runtime */
 	.fill_in_addresses	= &ppro_fill_in_addresses,
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 6161c7f..3220d4c 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -6,21 +6,19 @@
  * @remark Read the file COPYING
  *
  * @author Graydon Hoare
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #ifndef OP_X86_MODEL_H
 #define OP_X86_MODEL_H
 
+#include <asm/types.h>
 #include <asm/intel_arch_perfmon.h>
 
 #define CTR_IS_RESERVED(msrs, c)	((msrs)->counters[(c)].addr ? 1 : 0)
 #define CTRL_IS_RESERVED(msrs, c)	((msrs)->controls[(c)].addr ? 1 : 0)
 #define CTRL_SET_ACTIVE(val)		((val) |= ARCH_PERFMON_EVENTSEL0_ENABLE)
-#define CTRL_SET_ENABLE(val)		((val) |= ARCH_PERFMON_EVENTSEL_INT)
 #define CTRL_SET_INACTIVE(val)		((val) &= ~ARCH_PERFMON_EVENTSEL0_ENABLE)
-#define CTRL_SET_KERN(val, k)		((val) |= ((k) ? ARCH_PERFMON_EVENTSEL_OS : 0))
-#define CTRL_SET_USR(val, u)		((val) |= ((u) ? ARCH_PERFMON_EVENTSEL_USR : 0))
-#define CTRL_SET_UM(val, m)		((val) |= ((m) << 8))
 
 struct op_saved_msr {
 	unsigned int high;
@@ -39,12 +37,16 @@ struct op_msrs {
 
 struct pt_regs;
 
+struct oprofile_operations;
+
 /* The model vtable abstracts the differences between
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
 	unsigned int	num_counters;
 	unsigned int	num_controls;
+	u64		reserved;
+	u16		event_mask;
 	int		(*init)(struct oprofile_operations *ops);
 	void		(*exit)(void);
 	void		(*fill_in_addresses)(struct op_msrs * const msrs);
@@ -57,6 +59,11 @@ struct op_x86_model_spec {
 	void		(*shutdown)(struct op_msrs const * const msrs);
 };
 
+struct op_counter_config;
+
+extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
+			   struct op_counter_config *counter_config);
+
 extern struct op_x86_model_spec const op_ppro_spec;
 extern struct op_x86_model_spec const op_p4_spec;
 extern struct op_x86_model_spec const op_p4_ht2_spec;
-- 
1.6.3.1


