Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZBFDxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZBFDxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 22:53:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbZBFDw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 22:52:56 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:59979 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZBFDwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:53 -0500
MBOX-Line: From nobody Thu Feb  5 20:45:25 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH 2/3] OMAP3: update ES level flags to discriminate between
	post-ES2 revisions
To: linux@arm.linux.org.uk
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel@vger.kernel.org, paul@pwsan.com
Date: Thu, 05 Feb 2009 20:45:25 -0700
Message-ID: <20090206034516.31313.17310.stgit@localhost.localdomain>
In-Reply-To: <20090206033847.31313.45612.stgit@localhost.localdomain>
References: <20090206033847.31313.45612.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some OMAP3 chip behaviors change in ES levels after ES2.  Modify the
existing omap_chip flags to add options for ES3.0 and ES3.1.

Add a new macro, CHIP_GE_OMAP3430ES2, to cover ES levels from ES2
onwards - a common pattern for OMAP3 features.  Update all current
users of the omap_chip macros to use this new macro.

Also add CHIP_GE_OMAP3430ES3_1 to cover the USBTLL SAR errata case
(described and fixed in the following patch)

Signed-off-by: Paul Walmsley <paul@pwsan.com>
---
 arch/arm/mach-omap2/clockdomains.h     |    6 +++---
 arch/arm/mach-omap2/id.c               |    7 ++++++-
 arch/arm/mach-omap2/powerdomains34xx.h |    8 ++++----
 arch/arm/plat-omap/include/mach/cpu.h  |   26 ++++++++++++++++++++------
 4 files changed, 33 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index b29035e..81b9b2b 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -185,7 +185,7 @@ static struct clockdomain sgx_clkdm = {
 	.pwrdm		= { .name = "sgx_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_SGX_MASK,
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 };
 
 /*
@@ -240,7 +240,7 @@ static struct clockdomain usbhost_clkdm = {
 	.pwrdm		= { .name = "usbhost_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_USBHOST_MASK,
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 };
 
 static struct clockdomain per_clkdm = {
@@ -290,7 +290,7 @@ static struct clockdomain dpll4_clkdm = {
 static struct clockdomain dpll5_clkdm = {
 	.name		= "dpll5_clkdm",
 	.pwrdm		= { .name = "dpll5_pwrdm" },
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 };
 
 #endif   /* CONFIG_ARCH_OMAP34XX */
diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
index b52a02f..34b5914 100644
--- a/arch/arm/mach-omap2/id.c
+++ b/arch/arm/mach-omap2/id.c
@@ -217,8 +217,13 @@ void __init omap2_check_revision(void)
 		omap_chip.oc = CHIP_IS_OMAP3430;
 		if (omap_rev() == OMAP3430_REV_ES1_0)
 			omap_chip.oc |= CHIP_IS_OMAP3430ES1;
-		else if (omap_rev() > OMAP3430_REV_ES1_0)
+		else if (omap_rev() >= OMAP3430_REV_ES2_0 &&
+			 omap_rev() <= OMAP3430_REV_ES2_1)
 			omap_chip.oc |= CHIP_IS_OMAP3430ES2;
+		else if (omap_rev() == OMAP3430_REV_ES3_0)
+			omap_chip.oc |= CHIP_IS_OMAP3430ES3_0;
+		else if (omap_rev() == OMAP3430_REV_ES3_1)
+			omap_chip.oc |= CHIP_IS_OMAP3430ES3_1;
 	} else {
 		pr_err("Uninitialized omap_chip, please fix!\n");
 	}
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index edfad42..6b9d126 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -221,7 +221,7 @@ static struct powerdomain core_34xx_es1_pwrdm = {
 static struct powerdomain core_34xx_es2_pwrdm = {
 	.name		  = "core_pwrdm",
 	.prcm_offs	  = CORE_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.dep_bit	  = OMAP3430_EN_CORE_SHIFT,
 	.flags		  = PWRDM_HAS_HDWR_SAR, /* for USBTLL only */
@@ -263,7 +263,7 @@ static struct powerdomain dss_pwrdm = {
 static struct powerdomain sgx_pwrdm = {
 	.name		  = "sgx_pwrdm",
 	.prcm_offs	  = OMAP3430ES2_SGX_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 	.wkdep_srcs	  = gfx_sgx_wkdeps,
 	.sleepdep_srcs	  = cam_gfx_sleepdeps,
 	/* XXX This is accurate for 3430 SGX, but what about GFX? */
@@ -331,7 +331,7 @@ static struct powerdomain neon_pwrdm = {
 static struct powerdomain usbhost_pwrdm = {
 	.name		  = "usbhost_pwrdm",
 	.prcm_offs	  = OMAP3430ES2_USBHOST_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 	.wkdep_srcs	  = per_usbhost_wkdeps,
 	.sleepdep_srcs	  = dss_per_usbhost_sleepdeps,
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
@@ -373,7 +373,7 @@ static struct powerdomain dpll4_pwrdm = {
 static struct powerdomain dpll5_pwrdm = {
 	.name		= "dpll5_pwrdm",
 	.prcm_offs	= PLL_MOD,
-	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
+	.omap_chip	= OMAP_CHIP_INIT(CHIP_GE_OMAP3430ES2),
 };
 
 
diff --git a/arch/arm/plat-omap/include/mach/cpu.h b/arch/arm/plat-omap/include/mach/cpu.h
index a8e1178..4166a97 100644
--- a/arch/arm/plat-omap/include/mach/cpu.h
+++ b/arch/arm/plat-omap/include/mach/cpu.h
@@ -355,13 +355,27 @@ IS_OMAP_TYPE(3430, 0x3430)
  * use omap_chip_is().
  *
  */
-#define CHIP_IS_OMAP2420       (1 << 0)
-#define CHIP_IS_OMAP2430       (1 << 1)
-#define CHIP_IS_OMAP3430       (1 << 2)
-#define CHIP_IS_OMAP3430ES1    (1 << 3)
-#define CHIP_IS_OMAP3430ES2    (1 << 4)
+#define CHIP_IS_OMAP2420		(1 << 0)
+#define CHIP_IS_OMAP2430		(1 << 1)
+#define CHIP_IS_OMAP3430		(1 << 2)
+#define CHIP_IS_OMAP3430ES1		(1 << 3)
+#define CHIP_IS_OMAP3430ES2		(1 << 4)
+#define CHIP_IS_OMAP3430ES3_0		(1 << 5)
+#define CHIP_IS_OMAP3430ES3_1		(1 << 6)
+
+#define CHIP_IS_OMAP24XX		(CHIP_IS_OMAP2420 | CHIP_IS_OMAP2430)
+
+/*
+ * "GE" here represents "greater than or equal to" in terms of ES
+ * levels.  So CHIP_GE_OMAP3430ES2 is intended to match all OMAP3430
+ * chips at ES2 and beyond, but not, for example, any OMAP lines after
+ * OMAP3.
+ */
+#define CHIP_GE_OMAP3430ES2		(CHIP_IS_OMAP3430ES2 | \
+					 CHIP_IS_OMAP3430ES3_0 | \
+					 CHIP_IS_OMAP3430ES3_1)
+#define CHIP_GE_OMAP3430ES3_1		(CHIP_IS_OMAP3430ES3_1)
 
-#define CHIP_IS_OMAP24XX       (CHIP_IS_OMAP2420 | CHIP_IS_OMAP2430)
 
 int omap_chip_is(struct omap_chip_id oci);
 int omap_type(void);


