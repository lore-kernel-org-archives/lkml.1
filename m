Return-Path: <linux-kernel-owner+w=401wt.eu-S1756322AbZA3KWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322AbZA3KWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:22:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZA3KSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:18:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54400 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbZA3KRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:55 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove enable_apic_mode genapic hook
Date: Fri, 30 Jan 2009 11:17:18 +0100
Message-Id: <1233310639-27916-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-12-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
 <1233310639-27916-3-git-send-email-andi@firstfloor.org>
 <1233310639-27916-4-git-send-email-andi@firstfloor.org>
 <1233310639-27916-5-git-send-email-andi@firstfloor.org>
 <1233310639-27916-6-git-send-email-andi@firstfloor.org>
 <1233310639-27916-7-git-send-email-andi@firstfloor.org>
 <1233310639-27916-8-git-send-email-andi@firstfloor.org>
 <1233310639-27916-9-git-send-email-andi@firstfloor.org>
 <1233310639-27916-10-git-send-email-andi@firstfloor.org>
 <1233310639-27916-11-git-send-email-andi@firstfloor.org>
 <1233310639-27916-12-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Only used by es7000

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/genapic.h      |    1 -
 arch/x86/kernel/apic.c              |    2 --
 arch/x86/kernel/bigsmp_32.c         |    1 -
 arch/x86/kernel/es7000_32.c         |   21 ---------------------
 arch/x86/kernel/genapic_flat_64.c   |    2 --
 arch/x86/kernel/genx2apic_cluster.c |    1 -
 arch/x86/kernel/genx2apic_phys.c    |    1 -
 arch/x86/kernel/genx2apic_uv_x.c    |    1 -
 arch/x86/kernel/numaq_32.c          |    1 -
 arch/x86/kernel/probe_32.c          |    1 -
 arch/x86/kernel/summit_32.c         |    1 -
 11 files changed, 0 insertions(+), 33 deletions(-)

diff --git a/arch/x86/include/asm/genapic.h b/arch/x86/include/asm/genapic.h
index 658d66a..7ffa1e6 100644
--- a/arch/x86/include/asm/genapic.h
+++ b/arch/x86/include/asm/genapic.h
@@ -45,7 +45,6 @@ struct genapic {
 	int (*cpu_present_to_apicid)(int mps_cpu);
 	physid_mask_t (*apicid_to_cpu_present)(int phys_apicid);
 	int (*check_phys_apicid_present)(int boot_cpu_physical_apicid);
-	void (*enable_apic_mode)(void);
 	int (*phys_pkg_id)(int cpuid_apic, int index_msb);
 
 	/*
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 968c817..0bb30b7 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1761,8 +1761,6 @@ void __init connect_bsp_APIC(void)
 		outb(0x01, 0x23);
 	}
 #endif
-	if (apic->enable_apic_mode)
-		apic->enable_apic_mode();
 }
 
 /**
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index 17c6c06..bbc78ff 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -233,7 +233,6 @@ struct genapic apic_bigsmp = {
 	.cpu_present_to_apicid		= bigsmp_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= bigsmp_apicid_to_cpu_present,
 	.check_phys_apicid_present	= bigsmp_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= bigsmp_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index bb4f525..4dd4557 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -351,25 +351,6 @@ es7000_mip_write(struct mip_reg *mip_reg)
 	return status;
 }
 
-void __init es7000_enable_apic_mode(void)
-{
-	struct mip_reg es7000_mip_reg;
-	int mip_status;
-
-	if (!es7000_plat)
-		return;
-
-	printk("ES7000: Enabling APIC mode.\n");
-       	memset(&es7000_mip_reg, 0, sizeof(struct mip_reg));
-       	es7000_mip_reg.off_0 = MIP_SW_APIC;
-       	es7000_mip_reg.off_38 = MIP_VALID;
-
-       	while ((mip_status = es7000_mip_write(&es7000_mip_reg)) != 0) {
-		printk("es7000_enable_apic_mode: command failed, status = %x\n",
-			mip_status);
-	}
-}
-
 /*
  * APIC driver for the Unisys ES7000 chipset.
  */
@@ -393,7 +374,6 @@ void __init es7000_enable_apic_mode(void)
 
 #define APIC_DFR_VALUE			(APIC_DFR_FLAT)
 
-extern void es7000_enable_apic_mode(void);
 extern int apic_version [MAX_APICS];
 extern u8 cpu_2_logical_apicid[];
 extern unsigned int boot_cpu_physical_apicid;
@@ -766,7 +746,6 @@ struct genapic apic_es7000 = {
 	.cpu_present_to_apicid		= es7000_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= es7000_apicid_to_cpu_present,
 	.check_phys_apicid_present	= es7000_check_phys_apicid_present,
-	.enable_apic_mode		= es7000_enable_apic_mode,
 	.phys_pkg_id			= es7000_phys_pkg_id,
 	.mps_oem_check			= es7000_mps_oem_check,
 
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index a7c42d4..b88003a 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -203,7 +203,6 @@ struct genapic apic_flat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
@@ -341,7 +340,6 @@ struct genapic apic_physflat =  {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= flat_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_cluster.c b/arch/x86/kernel/genx2apic_cluster.c
index 71534eb..c0bbe5a 100644
--- a/arch/x86/kernel/genx2apic_cluster.c
+++ b/arch/x86/kernel/genx2apic_cluster.c
@@ -208,7 +208,6 @@ struct genapic apic_x2apic_cluster = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 02b3e37..b039497 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -194,7 +194,6 @@ struct genapic apic_x2apic_phys = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index def1b26..e1c72aa 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -267,7 +267,6 @@ struct genapic apic_x2apic_uv_x = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= uv_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index e719520..6ddacbc 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -493,7 +493,6 @@ struct genapic apic_numaq = {
 	.cpu_present_to_apicid		= numaq_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= numaq_apicid_to_cpu_present,
 	.check_phys_apicid_present	= numaq_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= numaq_phys_pkg_id,
 	.mps_oem_check			= __numaq_mps_oem_check,
 
diff --git a/arch/x86/kernel/probe_32.c b/arch/x86/kernel/probe_32.c
index 826bc86..de86aa0 100644
--- a/arch/x86/kernel/probe_32.c
+++ b/arch/x86/kernel/probe_32.c
@@ -99,7 +99,6 @@ struct genapic apic_default = {
 	.cpu_present_to_apicid		= default_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= default_apicid_to_cpu_present,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= default_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index f528723..950c5cb 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -569,7 +569,6 @@ struct genapic apic_summit = {
 	.cpu_present_to_apicid		= summit_cpu_present_to_apicid,
 	.apicid_to_cpu_present		= summit_apicid_to_cpu_present,
 	.check_phys_apicid_present	= summit_check_phys_apicid_present,
-	.enable_apic_mode		= NULL,
 	.phys_pkg_id			= summit_phys_pkg_id,
 	.mps_oem_check			= summit_mps_oem_check,
 
-- 
1.5.6.5

