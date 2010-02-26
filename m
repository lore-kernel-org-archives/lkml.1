Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554Ab0BZRgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:36:19 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:39741 "EHLO
	TX2EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965526Ab0BZRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:08 -0500
X-SpamScore: -3
X-BigFish: VPS-3(zz936eMab9bha84eizz1202hzzz32i87h6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7T-02-2LV-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 05/15] oprofile/x86: implement IBS cpuid feature detection
Date: Fri, 26 Feb 2010 18:29:57 +0100
Message-ID: <1267205407-6523-6-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0320 (UTC) FILETIME=[2181EF80:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds IBS feature detection using cpuid flags. An IBS
capability mask is introduced to test for certain IBS features. The
bit mask is the same as for IBS cpuid feature flags (Fn8000_001B_EAX),
but bit 0 is used to indicate the existence of IBS.

The patch also changes the handling of the IbsOpCntCtl bit (periodic
op counter count control). The oprofilefs file for this feature
(ibs_op/dispatched_ops) will be only exposed if the feature is
available, also the default for the bit is set to count clock cycles.

In general, the userland can detect the availability of a feature by
checking for the corresponding file in oprofilefs. If it exists, the
feature also exists. This may lead to a dynamic file layout depending
on the cpu type with that the userland has to deal with. Current
opcontrol is compatible.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   80 ++++++++++++++++++++++++++++++--------
 1 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 4eb3071..6557683 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -23,6 +23,8 @@
 #include <asm/msr.h>
 #include <asm/nmi.h>
 #include <asm/apic.h>
+#include <asm/processor.h>
+#include <asm/cpufeature.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -58,7 +60,7 @@ static unsigned long reset_value[NUM_VIRT_COUNTERS];
 #define IBS_FETCH_SIZE			6
 #define IBS_OP_SIZE			12
 
-static int has_ibs;	/* AMD Family10h and later */
+static u32 ibs_caps;
 
 struct op_ibs_config {
 	unsigned long op_enabled;
@@ -71,6 +73,40 @@ struct op_ibs_config {
 
 static struct op_ibs_config ibs_config;
 
+/*
+ * IBS cpuid feature detection
+ */
+
+#define IBS_CPUID_FEATURES      0x8000001b
+
+/*
+ * Same bit mask as for IBS cpuid feature flags (Fn8000_001B_EAX), but
+ * bit 0 is used to indicate the existence of IBS.
+ */
+#define IBS_CAPS_AVAIL			(1LL<<0)
+#define IBS_CAPS_OPCNT			(1LL<<4)
+
+static u32 get_ibs_caps(void)
+{
+	u32 ibs_caps;
+	unsigned int max_level;
+
+	if (!boot_cpu_has(X86_FEATURE_IBS))
+		return 0;
+
+	/* check IBS cpuid feature flags */
+	max_level = cpuid_eax(0x80000000);
+	if (max_level < IBS_CPUID_FEATURES)
+		return IBS_CAPS_AVAIL;
+
+	ibs_caps = cpuid_eax(IBS_CPUID_FEATURES);
+	if (!(ibs_caps & IBS_CAPS_AVAIL))
+		/* cpuid flags not valid */
+		return IBS_CAPS_AVAIL;
+
+	return ibs_caps;
+}
+
 #ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
 
 static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
@@ -189,7 +225,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	u64 val, ctl;
 	struct op_entry entry;
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	if (ibs_config.fetch_enabled) {
@@ -241,16 +277,21 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 static inline void op_amd_start_ibs(void)
 {
 	u64 val;
-	if (has_ibs && ibs_config.fetch_enabled) {
+
+	if (!ibs_caps)
+		return;
+
+	if (ibs_config.fetch_enabled) {
 		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
 		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
 		val |= IBS_FETCH_ENABLE;
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
 	}
 
-	if (has_ibs && ibs_config.op_enabled) {
+	if (ibs_config.op_enabled) {
 		val = (ibs_config.max_cnt_op >> 4) & 0xFFFF;
-		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
+		if (ibs_caps & IBS_CAPS_OPCNT && ibs_config.dispatched_ops)
+			val |= IBS_OP_CNT_CTL;
 		val |= IBS_OP_ENABLE;
 		wrmsrl(MSR_AMD64_IBSOPCTL, val);
 	}
@@ -258,11 +299,14 @@ static inline void op_amd_start_ibs(void)
 
 static void op_amd_stop_ibs(void)
 {
-	if (has_ibs && ibs_config.fetch_enabled)
+	if (!ibs_caps)
+		return;
+
+	if (ibs_config.fetch_enabled)
 		/* clear max count and enable */
 		wrmsrl(MSR_AMD64_IBSFETCHCTL, 0);
 
-	if (has_ibs && ibs_config.op_enabled)
+	if (ibs_config.op_enabled)
 		/* clear max count and enable */
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
@@ -395,29 +439,30 @@ static int init_ibs_nmi(void)
 /* uninitialize the APIC for the IBS interrupts if needed */
 static void clear_ibs_nmi(void)
 {
-	if (has_ibs)
+	if (ibs_caps)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
 /* initialize the APIC for the IBS interrupts if available */
 static void ibs_init(void)
 {
-	has_ibs = boot_cpu_has(X86_FEATURE_IBS);
+	ibs_caps = get_ibs_caps();
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	if (init_ibs_nmi()) {
-		has_ibs = 0;
+		ibs_caps = 0;
 		return;
 	}
 
-	printk(KERN_INFO "oprofile: AMD IBS detected\n");
+	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n",
+	       (unsigned)ibs_caps);
 }
 
 static void ibs_exit(void)
 {
-	if (!has_ibs)
+	if (!ibs_caps)
 		return;
 
 	clear_ibs_nmi();
@@ -437,7 +482,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	if (ret)
 		return ret;
 
-	if (!has_ibs)
+	if (!ibs_caps)
 		return ret;
 
 	/* model specific files */
@@ -447,7 +492,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	ibs_config.fetch_enabled = 0;
 	ibs_config.max_cnt_op = 250000;
 	ibs_config.op_enabled = 0;
-	ibs_config.dispatched_ops = 1;
+	ibs_config.dispatched_ops = 0;
 
 	dir = oprofilefs_mkdir(sb, root, "ibs_fetch");
 	oprofilefs_create_ulong(sb, dir, "enable",
@@ -462,8 +507,9 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 				&ibs_config.op_enabled);
 	oprofilefs_create_ulong(sb, dir, "max_count",
 				&ibs_config.max_cnt_op);
-	oprofilefs_create_ulong(sb, dir, "dispatched_ops",
-				&ibs_config.dispatched_ops);
+	if (ibs_caps & IBS_CAPS_OPCNT)
+		oprofilefs_create_ulong(sb, dir, "dispatched_ops",
+					&ibs_config.dispatched_ops);
 
 	return 0;
 }
-- 
1.6.6


