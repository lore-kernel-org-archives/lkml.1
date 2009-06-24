Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZFXJIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZFXJIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbZFXJI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:08:29 -0400
Received: from smtp.nokia.com ([192.100.122.230]:49857 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbZFXJIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:08:25 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: linux-kernel@vger.kernel.org
Cc: sameo@linux.intel.com, dbrownell@users.sourceforge.net,
       linux-omap@vger.kernel.org
Subject: [PATCH 3/3] TWL4030: power: OMAP: Board-specifc DPS scripts for RX51 board
Date: Wed, 24 Jun 2009 12:08:11 +0300
Message-Id: <1245834491-7983-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
References: <1245834390-7904-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 24 Jun 2009 09:08:15.0871 (UTC) FILETIME=[4EFF50F0:01C9F4AB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Dynamic Power Switching (DPS) for the RX51 board.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  120 +++++++++++++++++++++++++-
 1 files changed, 119 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index 9a0bf67..43d081b 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap2/board-rx51-flash.c
+ * linux/arch/arm/mach-omap2/board-rx51-peripherals.c
  *
  * Copyright (C) 2008-2009 Nokia
  *
@@ -278,6 +278,123 @@ static struct twl4030_gpio_platform_data rx51_gpio_data = {
 	.setup			= rx51_twlgpio_setup,
 };
 
+static struct twl4030_ins sleep_on_seq[] __initdata = {
+/*
+ * Turn off VDD1 and VDD2.
+ */
+	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_OFF), 4},
+	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_OFF), 2},
+/*
+ * And also turn off the OMAP3 PLLs and the sysclk output.
+ */
+	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_OFF), 3},
+	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_OFF), 3},
+};
+
+static struct twl4030_script sleep_on_script __initdata = {
+	.script = sleep_on_seq,
+	.size   = ARRAY_SIZE(sleep_on_seq),
+	.flags  = TRITON_SLEEP_SCRIPT,
+};
+
+static struct twl4030_ins wakeup_seq[] __initdata = {
+/*
+ * Reenable the OMAP3 PLLs.
+ * Wakeup VDD1 and VDD2.
+ * Reenable sysclk output.
+ */
+	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_ACTIVE), 0x30},
+	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_ACTIVE), 0x30},
+	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_ACTIVE), 0x37},
+	{MSG_SINGULAR(DEV_GRP_P1, 0x19, RES_STATE_ACTIVE), 3},
+};
+
+static struct twl4030_script wakeup_script __initdata = {
+	.script	= wakeup_seq,
+	.size	= ARRAY_SIZE(wakeup_seq),
+	.flags	= TRITON_WAKEUP12_SCRIPT,
+};
+
+static struct twl4030_ins wakeup_p3_seq[] __initdata = {
+/*
+ * Wakeup VDD1 (dummy to be able to insert a delay)
+ * Enable CLKEN
+ */
+	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_ACTIVE), 3},
+};
+
+static struct twl4030_script wakeup_p3_script __initdata = {
+	.script	= wakeup_p3_seq,
+	.size	= ARRAY_SIZE(wakeup_p3_seq),
+	.flags	= TRITON_WAKEUP3_SCRIPT,
+};
+
+static struct twl4030_ins wrst_seq[] __initdata = {
+/*
+ * Reset twl4030.
+ * Reset VDD1 regulator.
+ * Reset VDD2 regulator.
+ * Reset VPLL1 regulator.
+ * Enable sysclk output.
+ * Reenable twl4030.
+ */
+	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_OFF), 2},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 0, 1, RES_STATE_ACTIVE),
+		0x13},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 2, RES_STATE_WRST), 0x13},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 3, RES_STATE_OFF), 0x13},
+	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD1, RES_STATE_WRST), 0x13},
+	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD2, RES_STATE_WRST), 0x13},
+	{MSG_SINGULAR(DEV_GRP_NULL, RES_VPLL1, RES_STATE_WRST), 0x35},
+	{MSG_SINGULAR(DEV_GRP_P1, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
+	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_ACTIVE), 2},
+};
+
+static struct twl4030_script wrst_script __initdata = {
+	.script = wrst_seq,
+	.size   = ARRAY_SIZE(wrst_seq),
+	.flags  = TRITON_WRST_SCRIPT,
+};
+
+static struct twl4030_script *twl4030_scripts[] __initdata = {
+	/* wakeup12 script should be loaded before sleep script, otherwise a
+	   board might hit retention before loading of wakeup script is
+	   completed. This can cause boot failures depending on timing issues.
+	*/
+	&wakeup_script,
+	&sleep_on_script,
+	&wakeup_p3_script,
+	&wrst_script,
+};
+
+static struct twl4030_resconfig twl4030_rconfig[] = {
+	{ .resource = RES_VINTANA1, .devgroup = -1, .type = -1, .type2 = 1 },
+	{ .resource = RES_VINTANA2, .devgroup = -1, .type = -1, .type2 = 1 },
+	{ .resource = RES_VINTDIG, .devgroup = -1, .type = -1, .type2 = 1 },
+	{ .resource = RES_VMMC1, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VMMC2, .devgroup = DEV_GRP_NULL, .type = -1,
+	  .type2 = 3},
+	{ .resource = RES_VAUX1, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VAUX2, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VAUX3, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VAUX4, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VPLL2, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VDAC, .devgroup = -1, .type = -1, .type2 = 3},
+	{ .resource = RES_VSIM, .devgroup = DEV_GRP_NULL, .type = -1,
+	  .type2 = 3},
+	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P3, .type = -1,
+		.type2 = 1 },
+	{ 0, 0},
+};
+
+static struct twl4030_power_data rx51_t2scripts_data = {
+	.scripts        = twl4030_scripts,
+	.size   = ARRAY_SIZE(twl4030_scripts),
+	.resource_config = twl4030_rconfig,
+};
+
+
+
 static struct twl4030_platform_data rx51_twldata = {
 	.irq_base		= TWL4030_IRQ_BASE,
 	.irq_end		= TWL4030_IRQ_END,
@@ -286,6 +403,7 @@ static struct twl4030_platform_data rx51_twldata = {
 	.gpio			= &rx51_gpio_data,
 	.keypad			= &rx51_kp_data,
 	.madc			= &rx51_madc_data,
+	.power			= &rx51_t2scripts_data,
 
 	.vaux1			= &rx51_vaux1,
 	.vaux2			= &rx51_vaux2,
-- 
1.6.3.1

