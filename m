Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbYGPPTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbYGPPTv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759561AbYGPPS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:18:27 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60277 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517AbYGPPSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:18:24 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/026OElZWFdpCSj2nzy5le
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 04/10] ARM: OMAP: Powerdomain: Add OMAP3 powerdomains
Date: Wed, 16 Jul 2008 18:19:09 +0300
Message-Id: <1216221555-18958-5-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-4-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
 <1216221555-18958-4-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Add OMAP3-specific powerdomains.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
index 801e3b3..5ad9cb0 100644
--- a/arch/arm/mach-omap2/powerdomains.h
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -98,16 +98,28 @@ static struct pwrdm_dep gfx_sgx_wkdeps[] = {
 	{ NULL },
 };
 
+/*
+ * 3430: CM_SLEEPDEP_CAM: MPU
+ * 3430ES1: CM_SLEEPDEP_GFX: MPU
+ * 3430ES2: CM_SLEEPDEP_SGX: MPU
+ */
+static struct pwrdm_dep cam_gfx_sleepdeps[] = {
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
 
 #include "powerdomains24xx.h"
+#include "powerdomains34xx.h"
 
 
 /*
  * OMAP2/3 common powerdomains
  */
 
-/* XXX add sleepdeps for this powerdomain : 3430 */
-
 /*
  * The GFX powerdomain is not present on 3430ES2, but currently we do not
  * have a macro to filter it out at compile-time.
@@ -118,6 +130,7 @@ static struct powerdomain gfx_pwrdm = {
 	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX |
 					   CHIP_IS_OMAP3430ES1),
 	.wkdep_srcs	  = gfx_sgx_wkdeps,
+	.sleepdep_srcs	  = cam_gfx_sleepdeps,
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.pwrsts_logic_ret = PWRDM_POWER_RET,
 	.banks		  = 1,
@@ -154,6 +167,19 @@ static struct powerdomain *powerdomains_omap[] __initdata = {
 	&mdm_pwrdm,
 #endif
 
+#ifdef CONFIG_ARCH_OMAP34XX
+	&iva2_pwrdm,
+	&mpu_34xx_pwrdm,
+	&neon_pwrdm,
+	&core_34xx_pwrdm,
+	&cam_pwrdm,
+	&dss_pwrdm,
+	&per_pwrdm,
+	&emu_pwrdm,
+	&sgx_pwrdm,
+	&usbhost_pwrdm,
+#endif
+
 	NULL
 };
 
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
new file mode 100644
index 0000000..1e1146a
--- /dev/null
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -0,0 +1,327 @@
+/*
+ * OMAP34XX powerdomain definitions
+ *
+ * Copyright (C) 2007-2008 Texas Instruments, Inc.
+ * Copyright (C) 2007-2008 Nokia Corporation
+ *
+ * Written by Paul Walmsley
+ * Debugging and integration fixes by Jouni Högander
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ARCH_ARM_MACH_OMAP2_POWERDOMAINS34XX
+#define ARCH_ARM_MACH_OMAP2_POWERDOMAINS34XX
+
+/*
+ * N.B. If powerdomains are added or removed from this file, update
+ * the array in mach-omap2/powerdomains.h.
+ */
+
+#include <asm/arch/powerdomain.h>
+
+#include "prcm-common.h"
+#include "prm.h"
+#include "prm-regbits-34xx.h"
+#include "cm.h"
+#include "cm-regbits-34xx.h"
+
+/*
+ * 34XX-specific powerdomains, dependencies
+ */
+
+#ifdef CONFIG_ARCH_OMAP34XX
+
+/*
+ * 3430: PM_WKDEP_{PER,USBHOST}: CORE, IVA2, MPU, WKUP
+ * (USBHOST is ES2 only)
+ */
+static struct pwrdm_dep per_usbhost_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+/*
+ * 3430 PM_WKDEP_MPU: CORE, IVA2, DSS, PER
+ */
+static struct pwrdm_dep mpu_34xx_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "dss_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "per_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+/*
+ * 3430 PM_WKDEP_IVA2: CORE, MPU, WKUP, DSS, PER
+ */
+static struct pwrdm_dep iva2_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "dss_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "per_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+
+/* 3430 PM_WKDEP_{CAM,DSS}: IVA2, MPU, WKUP */
+static struct pwrdm_dep cam_dss_wkdeps[] = {
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+/* 3430: PM_WKDEP_NEON: MPU */
+static struct pwrdm_dep neon_wkdeps[] = {
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+
+/* Sleep dependency source arrays for 34xx-specific pwrdms - 34XX only */
+
+/*
+ * 3430: CM_SLEEPDEP_{DSS,PER}: MPU, IVA
+ * 3430ES2: CM_SLEEPDEP_USBHOST: MPU, IVA
+ */
+static struct pwrdm_dep dss_per_usbhost_sleepdeps[] = {
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+
+/*
+ * Powerdomains
+ */
+
+static struct powerdomain iva2_pwrdm = {
+	.name		  = "iva2_pwrdm",
+	.prcm_offs	  = OMAP3430_IVA2_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.dep_bit	  = OMAP3430_PM_WKDEP_MPU_EN_IVA2_SHIFT,
+	.wkdep_srcs	  = iva2_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.banks		  = 4,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,
+		[1] = PWRSTS_OFF_RET,
+		[2] = PWRSTS_OFF_RET,
+		[3] = PWRSTS_OFF_RET,
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,
+		[1] = PWRDM_POWER_ON,
+		[2] = PWRSTS_OFF_ON,
+		[3] = PWRDM_POWER_ON,
+	},
+};
+
+static struct powerdomain mpu_34xx_pwrdm = {
+	.name		  = "mpu_pwrdm",
+	.prcm_offs	  = MPU_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.dep_bit	  = OMAP3430_EN_MPU_SHIFT,
+	.wkdep_srcs	  = mpu_34xx_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRSTS_OFF_ON,
+	},
+};
+
+/* No wkdeps or sleepdeps for 34xx core apparently */
+static struct powerdomain core_34xx_pwrdm = {
+	.name		  = "core_pwrdm",
+	.prcm_offs	  = CORE_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.dep_bit	  = OMAP3430_EN_CORE_SHIFT,
+	.banks		  = 2,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,	 /* MEM1RETSTATE */
+		[1] = PWRSTS_OFF_RET,	 /* MEM2RETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRSTS_OFF_RET_ON, /* MEM1ONSTATE */
+		[1] = PWRSTS_OFF_RET_ON, /* MEM2ONSTATE */
+	},
+};
+
+/* Another case of bit name collisions between several registers: EN_DSS */
+static struct powerdomain dss_pwrdm = {
+	.name		  = "dss_pwrdm",
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.prcm_offs	  = OMAP3430_DSS_MOD,
+	.dep_bit	  = OMAP3430_PM_WKDEP_MPU_EN_DSS_SHIFT,
+	.wkdep_srcs	  = cam_dss_wkdeps,
+	.sleepdep_srcs	  = dss_per_usbhost_sleepdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,  /* MEMONSTATE */
+	},
+};
+
+static struct powerdomain sgx_pwrdm = {
+	.name		  = "sgx_pwrdm",
+	.prcm_offs	  = OMAP3430ES2_SGX_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.wkdep_srcs	  = gfx_sgx_wkdeps,
+	.sleepdep_srcs	  = cam_gfx_sleepdeps,
+	/* XXX This is accurate for 3430 SGX, but what about GFX? */
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,  /* MEMONSTATE */
+	},
+};
+
+static struct powerdomain cam_pwrdm = {
+	.name		  = "cam_pwrdm",
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.prcm_offs	  = OMAP3430_CAM_MOD,
+	.wkdep_srcs	  = cam_dss_wkdeps,
+	.sleepdep_srcs	  = cam_gfx_sleepdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,  /* MEMONSTATE */
+	},
+};
+
+static struct powerdomain per_pwrdm = {
+	.name		  = "per_pwrdm",
+	.prcm_offs	  = OMAP3430_PER_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.dep_bit	  = OMAP3430_EN_PER_SHIFT,
+	.wkdep_srcs	  = per_usbhost_wkdeps,
+	.sleepdep_srcs	  = dss_per_usbhost_sleepdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,  /* MEMONSTATE */
+	},
+};
+
+static struct powerdomain emu_pwrdm = {
+	.name		= "emu_pwrdm",
+	.prcm_offs	= OMAP3430_EMU_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+};
+
+static struct powerdomain neon_pwrdm = {
+	.name		  = "neon_pwrdm",
+	.prcm_offs	  = OMAP3430_NEON_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.wkdep_srcs	  = neon_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+};
+
+static struct powerdomain usbhost_pwrdm = {
+	.name		  = "usbhost_pwrdm",
+	.prcm_offs	  = OMAP3430ES2_USBHOST_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.wkdep_srcs	  = per_usbhost_wkdeps,
+	.sleepdep_srcs	  = dss_per_usbhost_sleepdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET, /* MEMRETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,  /* MEMONSTATE */
+	},
+};
+
+#endif    /* CONFIG_ARCH_OMAP34XX */
+
+
+#endif
diff --git a/arch/arm/mach-omap2/prcm-common.h b/arch/arm/mach-omap2/prcm-common.h
index 54c32f4..4a32822 100644
--- a/arch/arm/mach-omap2/prcm-common.h
+++ b/arch/arm/mach-omap2/prcm-common.h
@@ -312,7 +312,8 @@
 #define OMAP3430_ST_GPT2				(1 << 3)
 
 /* CM_SLEEPDEP_PER, PM_WKDEP_IVA2, PM_WKDEP_MPU, PM_WKDEP_PER shared bits */
-#define OMAP3430_EN_CORE				(1 << 0)
+#define OMAP3430_EN_CORE_SHIFT				0
+#define OMAP3430_EN_CORE_MASK				(1 << 0)
 
 #endif
 
diff --git a/arch/arm/mach-omap2/prm-regbits-34xx.h b/arch/arm/mach-omap2/prm-regbits-34xx.h
index b4686bc..5b5ecfe 100644
--- a/arch/arm/mach-omap2/prm-regbits-34xx.h
+++ b/arch/arm/mach-omap2/prm-regbits-34xx.h
@@ -68,7 +68,8 @@
 #define OMAP3430_VPINIDLE				(1 << 0)
 
 /* PM_WKDEP_IVA2, PM_WKDEP_MPU shared bits */
-#define OMAP3430_EN_PER					(1 << 7)
+#define OMAP3430_EN_PER_SHIFT				7
+#define OMAP3430_EN_PER_MASK				(1 << 7)
 
 /* PM_PWSTCTRL_IVA2, PM_PWSTCTRL_MPU, PM_PWSTCTRL_CORE shared bits */
 #define OMAP3430_MEMORYCHANGE				(1 << 3)
@@ -77,7 +78,7 @@
 #define OMAP3430_LOGICSTATEST				(1 << 2)
 
 /* PM_PREPWSTST_IVA2, PM_PREPWSTST_CORE shared bits */
-#define OMAP3430_LASTLOGICSTATEENTERED				(1 << 2)
+#define OMAP3430_LASTLOGICSTATEENTERED			(1 << 2)
 
 /*
  * PM_PREPWSTST_IVA2, PM_PREPWSTST_MPU, PM_PREPWSTST_CORE,
@@ -278,8 +279,10 @@
 #define OMAP3430_EMULATION_MPU_RST			(1 << 11)
 
 /* PM_WKDEP_MPU specific bits */
-#define OMAP3430_PM_WKDEP_MPU_EN_DSS			(1 << 5)
-#define OMAP3430_PM_WKDEP_MPU_EN_IVA2			(1 << 2)
+#define OMAP3430_PM_WKDEP_MPU_EN_DSS_SHIFT		5
+#define OMAP3430_PM_WKDEP_MPU_EN_DSS_MASK		(1 << 5)
+#define OMAP3430_PM_WKDEP_MPU_EN_IVA2_SHIFT		2
+#define OMAP3430_PM_WKDEP_MPU_EN_IVA2_MASK		(1 << 2)
 
 /* PM_EVGENCTRL_MPU */
 #define OMAP3430_OFFLOADMODE_SHIFT			3
