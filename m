Return-Path: <linux-kernel-owner+w=401wt.eu-S1759539AbZA1Uok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759539AbZA1Uok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZA1Uat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:49 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33011 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZA1Uak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:40 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:25 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL module)
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:25 -0700
Message-ID: <20090128024421.27240.95450.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

34xx TRM Delta G->H notes that the CORE powerdomain has a hardware
save-and-restore (SAR) control bit for the USBTLL module, similar to
the USBHOST powerdomain SAR bit.  Split the existing core_34xx struct
powerdomain into two structs, one for ES1 and one for ES2, and add the
PWRDM_HAS_HDWR_SAR flag to the ES2 powerdomain.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/powerdomains.h     |    3 ++-
 arch/arm/mach-omap2/powerdomains34xx.h |   23 +++++++++++++++++++++--
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-omap2/powerdomains.h b/arch/arm/mach-omap2/powerdomains.h
index 1329443..51623e2 100644
--- a/arch/arm/mach-omap2/powerdomains.h
+++ b/arch/arm/mach-omap2/powerdomains.h
@@ -171,7 +171,8 @@ static struct powerdomain *powerdomains_omap[] __initdata = {
 	&iva2_pwrdm,
 	&mpu_34xx_pwrdm,
 	&neon_pwrdm,
-	&core_34xx_pwrdm,
+	&core_34xx_es1_pwrdm,
+	&core_34xx_es2_pwrdm,
 	&cam_pwrdm,
 	&dss_pwrdm,
 	&per_pwrdm,
diff --git a/arch/arm/mach-omap2/powerdomains34xx.h b/arch/arm/mach-omap2/powerdomains34xx.h
index 7b63fa0..446a1ed 100644
--- a/arch/arm/mach-omap2/powerdomains34xx.h
+++ b/arch/arm/mach-omap2/powerdomains34xx.h
@@ -200,12 +200,31 @@ static struct powerdomain mpu_34xx_pwrdm = {
 };
 
 /* No wkdeps or sleepdeps for 34xx core apparently */
-static struct powerdomain core_34xx_pwrdm = {
+static struct powerdomain core_34xx_es1_pwrdm = {
 	.name		  = "core_pwrdm",
 	.prcm_offs	  = CORE_MOD,
-	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
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
+/* No wkdeps or sleepdeps for 34xx core apparently */
+static struct powerdomain core_34xx_es2_pwrdm = {
+	.name		  = "core_pwrdm",
+	.prcm_offs	  = CORE_MOD,
+	.omap_chip	  = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
 	.pwrsts		  = PWRSTS_OFF_RET_ON,
 	.dep_bit	  = OMAP3430_EN_CORE_SHIFT,
+	.flags		  = PWRDM_HAS_HDWR_SAR, /* for USBTLL only */
 	.banks		  = 2,
 	.pwrsts_mem_ret	  = {
 		[0] = PWRSTS_OFF_RET,	 /* MEM1RETSTATE */


