Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZJSMLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZJSMLy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 08:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755699AbZJSMLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 08:11:53 -0400
Received: from smtp.nokia.com ([192.100.122.233]:49952 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952AbZJSMLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 08:11:51 -0400
From: Amit Kucheria <amit.kucheria@verdurent.com>
To: List Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tero Kristo <tero.kristo@nokia.com>,
       linux-omap@vger.kernel.org
Subject: [PATCH 5/5] mfd: twl4030-power: Optimised power scripts for the rx51
Date: Mon, 19 Oct 2009 15:11:08 +0300
Message-Id: <1255954268-29162-1-git-send-email-amit.kucheria@verdurent.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
References: <1255954211-28496-1-git-send-email-amit.kucheria@verdurent.com>
X-OriginalArrivalTime: 19 Oct 2009 12:11:07.0442 (UTC) FILETIME=[3CE4F120:01CA50B5]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power scripts optimisation was mainly done by:
Tero Kristo <tero.kristo@nokia.com> and
Arnaud Mandy <ext-arnaud.2.mandy@nokia.com>

I'm only refactoring and testing it against the mainline kernel.

Signed-off-by: Amit Kucheria <amit.kucheria@verdurent.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Tero Kristo <tero.kristo@nokia.com>
Cc: linux-omap@vger.kernel.org
---
 arch/arm/mach-omap2/board-rx51-peripherals.c |  118 ++++++++++++++++++--------
 1 files changed, 82 insertions(+), 36 deletions(-)

diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
index c1af532..d933050 100644
--- a/arch/arm/mach-omap2/board-rx51-peripherals.c
+++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
@@ -292,15 +292,9 @@ static struct twl4030_usb_data rx51_usb_data = {
 
 static struct twl4030_ins sleep_on_seq[] __initdata = {
 /*
- * Turn off VDD1 and VDD2.
+ * Turn off everything
  */
-	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_OFF), 4},
-	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_OFF), 2},
-/*
- * And also turn off the OMAP3 PLLs and the sysclk output.
- */
-	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_OFF), 3},
-	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_OFF), 3},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_SLEEP), 2},
 };
 
 static struct twl4030_script sleep_on_script __initdata = {
@@ -311,14 +305,9 @@ static struct twl4030_script sleep_on_script __initdata = {
 
 static struct twl4030_ins wakeup_seq[] __initdata = {
 /*
- * Reenable the OMAP3 PLLs.
- * Wakeup VDD1 and VDD2.
- * Reenable sysclk output.
+ * Reenable everything
  */
-	{MSG_SINGULAR(DEV_GRP_P1, 0x7, RES_STATE_ACTIVE), 0x30},
-	{MSG_SINGULAR(DEV_GRP_P1, 0xf, RES_STATE_ACTIVE), 0x30},
-	{MSG_SINGULAR(DEV_GRP_P1, 0x10, RES_STATE_ACTIVE), 0x37},
-	{MSG_SINGULAR(DEV_GRP_P1, 0x19, RES_STATE_ACTIVE), 3},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_ACTIVE), 2},
 };
 
 static struct twl4030_script wakeup_script __initdata = {
@@ -329,10 +318,9 @@ static struct twl4030_script wakeup_script __initdata = {
 
 static struct twl4030_ins wakeup_p3_seq[] __initdata = {
 /*
- * Wakeup VDD1 (dummy to be able to insert a delay)
- * Enable CLKEN
+ * Reenable everything
  */
-	{MSG_SINGULAR(DEV_GRP_P1, 0x17, RES_STATE_ACTIVE), 3},
+	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 1, 0, RES_STATE_ACTIVE), 2},
 };
 
 static struct twl4030_script wakeup_p3_script __initdata = {
@@ -353,12 +341,11 @@ static struct twl4030_ins wrst_seq[] __initdata = {
 	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_OFF), 2},
 	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_ALL, 0, 1, RES_STATE_ACTIVE),
 		0x13},
-	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 2, RES_STATE_WRST), 0x13},
 	{MSG_BROADCAST(DEV_GRP_NULL, RES_GRP_PP, 0, 3, RES_STATE_OFF), 0x13},
 	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD1, RES_STATE_WRST), 0x13},
 	{MSG_SINGULAR(DEV_GRP_NULL, RES_VDD2, RES_STATE_WRST), 0x13},
 	{MSG_SINGULAR(DEV_GRP_NULL, RES_VPLL1, RES_STATE_WRST), 0x35},
-	{MSG_SINGULAR(DEV_GRP_P1, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
+	{MSG_SINGULAR(DEV_GRP_P3, RES_HFCLKOUT, RES_STATE_ACTIVE), 2},
 	{MSG_SINGULAR(DEV_GRP_NULL, RES_RESET, RES_STATE_ACTIVE), 2},
 };
 
@@ -380,22 +367,81 @@ static struct twl4030_script *twl4030_scripts[] __initdata = {
 };
 
 static struct twl4030_resconfig twl4030_rconfig[] __initdata = {
-	{ .resource = RES_VINTANA1, .devgroup = -1, .type = -1, .type2 = 1 },
-	{ .resource = RES_VINTANA2, .devgroup = -1, .type = -1, .type2 = 1 },
-	{ .resource = RES_VINTDIG, .devgroup = -1, .type = -1, .type2 = 1 },
-	{ .resource = RES_VMMC1, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VMMC2, .devgroup = DEV_GRP_NULL, .type = -1,
-	  .type2 = 3},
-	{ .resource = RES_VAUX1, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VAUX2, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VAUX3, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VAUX4, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VPLL2, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VDAC, .devgroup = -1, .type = -1, .type2 = 3},
-	{ .resource = RES_VSIM, .devgroup = DEV_GRP_NULL, .type = -1,
-	  .type2 = 3},
-	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P3, .type = -1,
-		.type2 = 1 },
+	{ .resource = RES_VDD1, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
+	  .remap_sleep = RES_STATE_OFF
+	},
+	{ .resource = RES_VDD2, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
+	  .remap_sleep = RES_STATE_OFF
+	},
+	{ .resource = RES_VPLL1, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = RES_STATE_OFF,
+	  .remap_sleep = RES_STATE_OFF
+	},
+	{ .resource = RES_VPLL2, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VAUX1, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VAUX2, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VAUX3, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VAUX4, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VMMC1, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VMMC2, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VDAC, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VSIM, .devgroup = -1,
+	  .type = -1, .type2 = 3, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VINTANA1, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = -1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VINTANA2, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VINTDIG, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = -1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_VIO, .devgroup = DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_CLKEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = 1, .type2 = -1 , .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_REGEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_NRES_PWRON, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_SYSEN, .devgroup = DEV_GRP_P1 | DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_HFCLKOUT, .devgroup = DEV_GRP_P3,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_32KCLKOUT, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_RESET, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
+	{ .resource = RES_Main_Ref, .devgroup = -1,
+	  .type = 1, .type2 = -1, .remap_off = -1, .remap_sleep = -1
+	},
 	{ 0, 0},
 };
 
-- 
1.6.3.3

