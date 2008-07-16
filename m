Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYGPPTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYGPPTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 11:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbYGPPSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 11:18:09 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59928 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759379AbYGPPSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 11:18:06 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/948vsJcnH1JskD/O33b8L
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-omap@vger.kernel.org,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 02/10] ARM: OMAP2: Powerdomain: Add OMAP2/3 common powerdomains
Date: Wed, 16 Jul 2008 18:19:07 +0300
Message-Id: <1216221555-18958-3-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.5.6.rc3.21.g8c6b5
In-Reply-To: <1216221555-18958-2-git-send-email-tony@atomide.com>
References: <1216221555-18958-1-git-send-email-tony@atomide.com>
 <1216221555-18958-2-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Walmsley <paul@pwsan.com>

Add powerdomains common to both OMAP2 and OMAP3 (WKUP and GFX/SGX).
Modify mach-omap2/io.c to initialize the powerdomain code on boot.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/io.c b/arch/arm/mach-omap2/io.c
index 69c8174..20ddfaa 100644
--- a/arch/arm/mach-omap2/io.c
+++ b/arch/arm/mach-omap2/io.c
@@ -24,6 +24,10 @@
 #include <asm/arch/mux.h>
 #include <asm/arch/omapfb.h>
 
+#include <asm/arch/powerdomain.h>
+
+#include "powerdomains.h"
+
 extern void omap_sram_init(void);
 extern int omap2_clk_init(void);
 extern void omap2_check_revision(void);
@@ -101,6 +105,7 @@ void __init omap2_map_common_io(void)
 void __init omap2_init_common_hw(void)
 {
 	omap2_mux_init();
+	pwrdm_init(powerdomains_omap);
 	omap2_clk_init();
 /*
  * Need to Fix this for 2430
diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
new file mode 100644
index 0000000..56c2a8f
--- /dev/null
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -0,0 +1,147 @@
+/*
+ * OMAP2/3 common powerdomain definitions
+ *
+ * Copyright (C) 2007-8 Texas Instruments, Inc.
+ * Copyright (C) 2007-8 Nokia Corporation
+ *
+ * Written by Paul Walmsley
+ * Debugging and integration fixes by Jouni Högander
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef ARCH_ARM_MACH_OMAP2_POWERDOMAINS
+#define ARCH_ARM_MACH_OMAP2_POWERDOMAINS
+
+/*
+ * This file contains all of the powerdomains that have some element
+ * of software control for the OMAP24xx and OMAP34XX chips.
+ *
+ * A few notes:
+ *
+ * This is not an exhaustive listing of powerdomains on the chips; only
+ * powerdomains that can be controlled in software.
+ *
+ * A useful validation rule for struct powerdomain:
+ * Any powerdomain referenced by a wkdep_srcs or sleepdep_srcs array
+ * must have a dep_bit assigned.  So wkdep_srcs/sleepdep_srcs are really
+ * just software-controllable dependencies.  Non-software-controllable
+ * dependencies do exist, but they are not encoded below (yet).
+ *
+ * 24xx does not support programmable sleep dependencies (SLEEPDEP)
+ *
+ */
+
+/*
+ * The names for the DSP/IVA2 powerdomains are confusing.
+ *
+ * Most OMAP chips have an on-board DSP.
+ *
+ * On the 2420, this is a 'C55 DSP called, simply, the DSP.  Its
+ * powerdomain is called the "DSP power domain."  On the 2430, the
+ * on-board DSP is a 'C64 DSP, now called the IVA2 or IVA2.1.  Its
+ * powerdomain is still called the "DSP power domain."	On the 3430,
+ * the DSP is a 'C64 DSP like the 2430, also known as the IVA2; but
+ * its powerdomain is now called the "IVA2 power domain."
+ *
+ * The 2420 also has something called the IVA, which is a separate ARM
+ * core, and has nothing to do with the DSP/IVA2.
+ *
+ * Ideally the DSP/IVA2 could just be the same powerdomain, but the PRCM
+ * address offset is different between the C55 and C64 DSPs.
+ *
+ * The overly-specific dep_bit names are due to a bit name collision
+ * with CM_FCLKEN_{DSP,IVA2}.  The DSP/IVA2 PM_WKDEP and CM_SLEEPDEP shift
+ * value are the same for all powerdomains: 2
+ */
+
+/*
+ * XXX should dep_bit be a mask, so we can test to see if it is 0 as a
+ * sanity check?
+ * XXX encode hardware fixed wakeup dependencies -- esp. for 3430 CORE
+ */
+
+#include <asm/arch/powerdomain.h>
+
+#include "prcm-common.h"
+#include "prm.h"
+#include "cm.h"
+
+/* OMAP2/3-common powerdomains and wakeup dependencies */
+
+/*
+ * 2420/2430 PM_WKDEP_GFX: CORE, MPU, WKUP
+ * 3430ES1 PM_WKDEP_GFX: adds IVA2, removes CORE
+ * 3430ES2 PM_WKDEP_SGX: adds IVA2, removes CORE
+ */
+static struct pwrdm_dep gfx_sgx_wkdeps[] = {
+	{
+		.pwrdm_name = "core_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX)
+	},
+	{
+		.pwrdm_name = "iva2_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "mpu_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX |
+					    CHIP_IS_OMAP3430)
+	},
+	{
+		.pwrdm_name = "wkup_pwrdm",
+		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX |
+					    CHIP_IS_OMAP3430)
+	},
+	{ NULL },
+};
+
+/*
+ * OMAP2/3 common powerdomains
+ */
+
+/* XXX add sleepdeps for this powerdomain : 3430 */
+
+/*
+ * The GFX powerdomain is not present on 3430ES2, but currently we do not
+ * have a macro to filter it out at compile-time.
+ */
+static struct powerdomain gfx_pwrdm = {
+	.name		  = "gfx_pwrdm",
+	.prcm_offs	  = GFX_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP24XX |
+					   CHIP_IS_OMAP3430ES1),
+	.wkdep_srcs	  = gfx_sgx_wkdeps,
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
+static struct powerdomain wkup_pwrdm = {
+	.name		= "wkup_pwrdm",
+	.prcm_offs	= WKUP_MOD,
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
+	.dep_bit	= OMAP_EN_WKUP_SHIFT,
+};
+
+
+
+/* As powerdomains are added or removed above, this list must also be changed */
+static struct powerdomain *powerdomains_omap[] __initdata = {
+
+	&gfx_pwrdm,
+	&wkup_pwrdm,
+
+	NULL
+};
+
+
+#endif
diff --git a/arch/arm/mach-omap2/prm.h b/arch/arm/mach-omap2/prm.h
index bbf41fc..eb9982f 100644
--- a/arch/arm/mach-omap2/prm.h
+++ b/arch/arm/mach-omap2/prm.h
@@ -305,7 +305,8 @@ static inline u32 prm_clear_mod_reg_bits(u32 bits, s16 module, s16 idx)
  * 3430: PM_WKDEP_IVA2, PM_WKDEP_GFX, PM_WKDEP_DSS, PM_WKDEP_CAM,
  *	 PM_WKDEP_PER
  */
-#define OMAP_EN_WKUP					(1 << 4)
+#define OMAP_EN_WKUP_SHIFT				4
+#define OMAP_EN_WKUP_MASK				(1 << 4)
 
 /*
  * 24XX: PM_PWSTCTRL_MPU, PM_PWSTCTRL_CORE, PM_PWSTCTRL_GFX,
