Return-Path: <linux-kernel-owner+w=401wt.eu-S1762406AbZAGWak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762406AbZAGWak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:30:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762466AbZAGWXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:23:30 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:39359 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762447AbZAGWX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:23:29 -0500
X-BigFish: VPS3(zzzzzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KD4GUJ-01-K43-01
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 16/18] oprofile: rename variable ibs_allowed to has_ibs in op_model_amd.c
Date: Wed, 7 Jan 2009 23:17:33 +0100
Message-ID: <1231366655-17837-17-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
References: <1231366655-17837-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 07 Jan 2009 22:22:59.0616 (UTC) FILETIME=[7F536200:01C97116]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch renames ibs_allowed to has_ibs. Varible name fits better
now.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c5b5c7f..423a954 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -106,7 +106,7 @@ struct ibs_op_sample {
 	unsigned int ibs_dc_phys_high;
 };
 
-static int ibs_allowed;	/* AMD Family10h and later */
+static int has_ibs;	/* AMD Family10h and later */
 
 struct op_ibs_config {
 	unsigned long op_enabled;
@@ -201,7 +201,7 @@ op_amd_handle_ibs(struct pt_regs * const regs,
 	struct ibs_fetch_sample ibs_fetch;
 	struct ibs_op_sample ibs_op;
 
-	if (!ibs_allowed)
+	if (!has_ibs)
 		return 1;
 
 	if (ibs_config.fetch_enabled) {
@@ -305,14 +305,14 @@ static void op_amd_start(struct op_msrs const * const msrs)
 	}
 
 #ifdef CONFIG_OPROFILE_IBS
-	if (ibs_allowed && ibs_config.fetch_enabled) {
+	if (has_ibs && ibs_config.fetch_enabled) {
 		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
 		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
 			+ IBS_FETCH_HIGH_ENABLE;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
-	if (ibs_allowed && ibs_config.op_enabled) {
+	if (has_ibs && ibs_config.op_enabled) {
 		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
 			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
 			+ IBS_OP_LOW_ENABLE;
@@ -341,14 +341,14 @@ static void op_amd_stop(struct op_msrs const * const msrs)
 	}
 
 #ifdef CONFIG_OPROFILE_IBS
-	if (ibs_allowed && ibs_config.fetch_enabled) {
+	if (has_ibs && ibs_config.fetch_enabled) {
 		/* clear max count and enable */
 		low = 0;
 		high = 0;
 		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
 	}
 
-	if (ibs_allowed && ibs_config.op_enabled) {
+	if (has_ibs && ibs_config.op_enabled) {
 		/* clear max count and enable */
 		low = 0;
 		high = 0;
@@ -437,20 +437,20 @@ static int init_ibs_nmi(void)
 /* uninitialize the APIC for the IBS interrupts if needed */
 static void clear_ibs_nmi(void)
 {
-	if (ibs_allowed)
+	if (has_ibs)
 		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
 }
 
 /* initialize the APIC for the IBS interrupts if available */
 static void ibs_init(void)
 {
-	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
+	has_ibs = boot_cpu_has(X86_FEATURE_IBS);
 
-	if (!ibs_allowed)
+	if (!has_ibs)
 		return;
 
 	if (init_ibs_nmi()) {
-		ibs_allowed = 0;
+		has_ibs = 0;
 		return;
 	}
 
@@ -459,7 +459,7 @@ static void ibs_init(void)
 
 static void ibs_exit(void)
 {
-	if (!ibs_allowed)
+	if (!has_ibs)
 		return;
 
 	clear_ibs_nmi();
@@ -479,7 +479,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 	if (ret)
 		return ret;
 
-	if (!ibs_allowed)
+	if (!has_ibs)
 		return ret;
 
 	/* model specific files */
-- 
1.6.0.1


