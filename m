Return-Path: <linux-kernel-owner+w=401wt.eu-S1757736AbYLKQvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbYLKQvU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 11:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756909AbYLKQsv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 11:48:51 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:32459 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756871AbYLKQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 11:48:48 -0500
X-BigFish: VPS1(zzzzzzz32i66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KBQ1CS-02-VL2-01
From: Robert Richter <robert.richter@amd.com>
To: oprofile-list <oprofile-list@lists.sourceforge.net>
CC: LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH 06/10] x86/oprofile: cleanup IBS init/exit functions in op_model_amd.c
Date: Thu, 11 Dec 2008 16:04:42 +0100
Message-ID: <1229007886-14362-7-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
In-Reply-To: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 11 Dec 2008 16:48:26.0948 (UTC) FILETIME=[49EE1040:01C95BB0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implementation of pairwise init/exit funcions for IBS and IBS NMI
setup. There are also some function renames and the removal of forward
function declarations.

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   32 +++++++++++++++++---------------
 1 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 8ff657b..98658f2 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -106,11 +106,6 @@ struct ibs_op_sample {
 	unsigned int ibs_dc_phys_high;
 };
 
-/*
- * unitialize the APIC for the IBS interrupts if needed on AMD Family10h+
- */
-static void clear_ibs_nmi(void);
-
 static int ibs_allowed;	/* AMD Family10h and later */
 
 struct op_ibs_config {
@@ -390,7 +385,7 @@ static inline void apic_clear_ibs_nmi_per_cpu(void *arg)
 	setup_APIC_eilvt_ibs(0, APIC_EILVT_MSG_FIX, 1);
 }
 
-static int pfm_amd64_setup_eilvt(void)
+static int init_ibs_nmi(void)
 {
 #define IBSCTL_LVTOFFSETVAL		(1 << 8)
 #define IBSCTL				0x1cc
@@ -438,15 +433,22 @@ static int pfm_amd64_setup_eilvt(void)
 	return 0;
 }
 
+/* uninitialize the APIC for the IBS interrupts if needed */
+static void clear_ibs_nmi(void)
+{
+	if (ibs_allowed)
+		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+}
+
 /* initialize the APIC for the IBS interrupts if available */
-static void setup_ibs(void)
+static void ibs_init(void)
 {
 	ibs_allowed = boot_cpu_has(X86_FEATURE_IBS);
 
 	if (!ibs_allowed)
 		return;
 
-	if (pfm_amd64_setup_eilvt()) {
+	if (init_ibs_nmi()) {
 		ibs_allowed = 0;
 		return;
 	}
@@ -454,12 +456,12 @@ static void setup_ibs(void)
 	printk(KERN_INFO "oprofile: AMD IBS detected\n");
 }
 
-
-/* uninitialize the APIC for the IBS interrupts if needed */
-static void clear_ibs_nmi(void)
+static void ibs_exit(void)
 {
-	if (ibs_allowed)
-		on_each_cpu(apic_clear_ibs_nmi_per_cpu, NULL, 1);
+	if (!ibs_allowed)
+		return;
+
+	clear_ibs_nmi();
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
@@ -509,7 +511,7 @@ static int setup_ibs_files(struct super_block *sb, struct dentry *root)
 
 static int op_amd_init(struct oprofile_operations *ops)
 {
-	setup_ibs();
+	ibs_init();
 	create_arch_files = ops->create_files;
 	ops->create_files = setup_ibs_files;
 	return 0;
@@ -517,7 +519,7 @@ static int op_amd_init(struct oprofile_operations *ops)
 
 static void op_amd_exit(void)
 {
-	clear_ibs_nmi();
+	ibs_exit();
 }
 
 #else
-- 
1.6.0.1


