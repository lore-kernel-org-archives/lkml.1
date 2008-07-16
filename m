Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbYGPPTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbYGPPTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759380AbYGPPSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:18:17 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:60078 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757163AbYGPPSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:18:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+T2ix905koXFK9MnF7OviT
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 03/10] ARM: OMAP2: Powerdomain: Add OMAP2 powerdomains
Date: Wed, 16 Jul 2008 18:19:08 +0300
Message-Id: <1216221555-18958-4-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-3-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
 <1216221555-18958-3-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Add OMAP2-specific powerdomains.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
index 56c2a8f..801e3b3 100644
--- a/arch/arm/mach-omap2/powerdomains.h
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -98,6 +98,10 @@ static struct pwrdm_dep gfx_sgx_wkdeps[] = {
 	{ NULL },
 };
 
+
+#include "powerdomains24xx.h"
+
+
 /*
  * OMAP2/3 common powerdomains
  */
@@ -140,6 +144,16 @@ static struct powerdomain *powerdomains_omap[] __initdata = {
 	&gfx_pwrdm,
 	&wkup_pwrdm,
 
+#ifdef CONFIG_ARCH_OMAP24XX
+	&dsp_pwrdm,
+	&mpu_24xx_pwrdm,
+	&core_24xx_pwrdm,
+#endif
+
+#ifdef CONFIG_ARCH_OMAP2430
+	&mdm_pwrdm,
+#endif
+
 	NULL
 };
 
diff --git a/arch/arm/mach-omap2/powerdomains24xx.h b/arch/arm/mach-omap2/powerdomains24xx.h
new file mode 100644
index 0000000..6f97c91
--- /dev/null
+++ b/arch/arm/mach-omap2/powerdomains24xx.h
@@ -0,0 +1,200 @@
+/*
+ * OMAP24XX powerdomain definitions
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
+#ifndef ARCH_ARM_MACH_OMAP2_POWERDOMAINS24XX
+#define ARCH_ARM_MACH_OMAP2_POWERDOMAINS24XX
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
+#include "prm-regbits-24xx.h"
+#include "cm.h"
+#include "cm-regbits-24xx.h"
+
+/* 24XX powerdomains and dependencies */
+
+#ifdef CONFIG_ARCH_OMAP24XX
+
+
+/* Wakeup dependency source arrays */
+
+/*
+ * 2420/2430 PM_WKDEP_DSP: CORE, MPU, WKUP
+ * 2430 PM_WKDEP_MDM: same as above
+ */
+static struct pwrdm_dep dsp_mdm_24xx_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{ NULL },
+};
+
+/*
+ * 2420 PM_WKDEP_MPU: CORE, DSP, WKUP
+ * 2430 adds MDM
+ */
+static struct pwrdm_dep mpu_24xx_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "dsp_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "mdm_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP2430)
+	},
+	{ NULL },
+};
+
+/*
+ * 2420 PM_WKDEP_CORE: DSP, GFX, MPU, WKUP
+ * 2430 adds MDM
+ */
+static struct pwrdm_dep core_24xx_wkdeps[] = {
+	{
+		.pwrdm_name = "dsp_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "gfx_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "mdm_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP2430)
+	},
+	{ NULL },
+};
+
+
+/* Powerdomains */
+
+static struct powerdomain dsp_pwrdm = {
+	.name		  = "dsp_pwrdm",
+	.prcm_offs	  = OMAP24XX_DSP_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+	.dep_bit	  = OMAP24XX_PM_WKDEP_MPU_EN_DSP_SHIFT,
+	.wkdep_srcs	  = dsp_mdm_24xx_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRDM_POWER_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET,
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,
+	},
+};
+
+static struct powerdomain mpu_24xx_pwrdm = {
+	.name		  = "mpu_pwrdm",
+	.prcm_offs	  = MPU_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+	.dep_bit	  = OMAP24XX_EN_MPU_SHIFT,
+	.wkdep_srcs	  = mpu_24xx_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.pwrsts_logic_ret = PWRSTS_OFF_RET,
+	.banks		  = 1,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRDM_POWER_RET,
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRDM_POWER_ON,
+	},
+};
+
+static struct powerdomain core_24xx_pwrdm = {
+	.name		  = "core_pwrdm",
+	.prcm_offs	  = CORE_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
+	.wkdep_srcs	  = core_24xx_wkdeps,
+	.pwrsts		  = PWRSTS_OFF_RET_ON,
+	.dep_bit	  = OMAP24XX_EN_CORE_SHIFT,
+	.banks		  = 3,
+	.pwrsts_mem_ret	  = {
+		[0] = PWRSTS_OFF_RET,	 /* MEM1RETSTATE */
+		[1] = PWRSTS_OFF_RET,	 /* MEM2RETSTATE */
+		[2] = PWRSTS_OFF_RET,	 /* MEM3RETSTATE */
+	},
+	.pwrsts_mem_on	  = {
+		[0] = PWRSTS_OFF_RET_ON, /* MEM1ONSTATE */
+		[1] = PWRSTS_OFF_RET_ON, /* MEM2ONSTATE */
+		[2] = PWRSTS_OFF_RET_ON, /* MEM3ONSTATE */
+	},
+};
+
+#endif	   /* CONFIG_ARCH_OMAP24XX */
+
+
+
+/*
+ * 2430-specific powerdomains
+ */
+
+#ifdef CONFIG_ARCH_OMAP2430
+
+/* XXX 2430 KILLDOMAINWKUP bit?  No current users apparently */
+
+/* Another case of bit name collisions between several registers: EN_MDM */
+static struct powerdomain mdm_pwrdm = {
+	.name		  = "mdm_pwrdm",
+	.prcm_offs	  = OMAP2430_MDM_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP2430),
+	.dep_bit	  = OMAP2430_PM_WKDEP_MPU_EN_MDM_SHIFT,
+	.wkdep_srcs	  = dsp_mdm_24xx_wkdeps,
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
+#endif     /* CONFIG_ARCH_OMAP2430 */
+
+
+#endif
diff --git a/arch/arm/mach-omap2/prm-regbits-24xx.h b/arch/arm/mach-omap2/prm-regbits-24xx.h
index c6d17a3..4002051 100644
--- a/arch/arm/mach-omap2/prm-regbits-24xx.h
+++ b/arch/arm/mach-omap2/prm-regbits-24xx.h
@@ -29,8 +29,10 @@
 #define OMAP24XX_WKUP1_EN				(1 << 0)
 
 /* PM_WKDEP_GFX, PM_WKDEP_MPU, PM_WKDEP_DSP, PM_WKDEP_MDM shared bits */
-#define OMAP24XX_EN_MPU					(1 << 1)
-#define OMAP24XX_EN_CORE				(1 << 0)
+#define OMAP24XX_EN_MPU_SHIFT				1
+#define OMAP24XX_EN_MPU_MASK				(1 << 1)
+#define OMAP24XX_EN_CORE_SHIFT 				0
+#define OMAP24XX_EN_CORE_MASK				(1 << 0)
 
 /*
  * PM_PWSTCTRL_MPU, PM_PWSTCTRL_GFX, PM_PWSTCTRL_DSP, PM_PWSTCTRL_MDM
@@ -140,8 +142,10 @@
 /* 2430 calls GLOBALWMPU_RST "GLOBALWARM_RST" instead */
 
 /* PM_WKDEP_MPU specific bits */
-#define OMAP2430_PM_WKDEP_MPU_EN_MDM			(1 << 5)
-#define OMAP24XX_PM_WKDEP_MPU_EN_DSP			(1 << 2)
+#define OMAP2430_PM_WKDEP_MPU_EN_MDM_SHIFT		5
+#define OMAP2430_PM_WKDEP_MPU_EN_MDM_MASK		(1 << 5)
+#define OMAP24XX_PM_WKDEP_MPU_EN_DSP_SHIFT		2
+#define OMAP24XX_PM_WKDEP_MPU_EN_DSP_MASK		(1 << 2)
 
 /* PM_EVGENCTRL_MPU specific bits */
 
