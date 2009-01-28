Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZA1UnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZA1UnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbZA1Uaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:30:39 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:33005 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669AbZA1Uah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:30:37 -0500
MBOX-Line: From nobody Tue Jan 27 19:44:11 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH B 02/10] OMAP2/3 clockdomains: combine pwrdm,
	pwrdm_name into union in struct clockdomain
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Paul Walmsley <paul@pwsan.com>,
       Tony Lindgren <tony@atomide.com>
Date: Tue, 27 Jan 2009 19:44:11 -0700
Message-ID: <20090128024408.27240.32198.stgit@localhost.localdomain>
In-Reply-To: <20090128024301.27240.39391.stgit@localhost.localdomain>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct clockdomain contains a struct powerdomain *pwrdm and const char
*pwrdm_name.  The pwrdm_name is only used at initialization to look up
the appropriate pwrdm pointer.  Combining these into a union saves
about 100 bytes on 3430SDP.  This patch should not cause any change in
kernel function.

Boot-tested on 3430SDP ES2.

linux-omap source commit is 718fc6cd4db902aa2242a736cc3feb8744a4c71a.

Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/clockdomain.c             |   58 +++++++++++--------------
 arch/arm/mach-omap2/clockdomains.h            |   54 ++++++++++++-----------
 arch/arm/plat-omap/include/mach/clockdomain.h |   24 ++++++----
 3 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index 4c3ce9c..882809d 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -71,14 +71,14 @@ static void _autodep_lookup(struct clkdm_pwrdm_autodep *autodep)
 	if (!omap_chip_is(autodep->omap_chip))
 		return;
 
-	pwrdm = pwrdm_lookup(autodep->pwrdm_name);
+	pwrdm = pwrdm_lookup(autodep->pwrdm.name);
 	if (!pwrdm) {
 		pr_debug("clockdomain: _autodep_lookup: powerdomain %s "
-			 "does not exist\n", autodep->pwrdm_name);
+			 "does not exist\n", autodep->pwrdm.name);
 		WARN_ON(1);
 		return;
 	}
-	autodep->pwrdm = pwrdm;
+	autodep->pwrdm.ptr = pwrdm;
 
 	return;
 }
@@ -95,16 +95,13 @@ static void _clkdm_add_autodeps(struct clockdomain *clkdm)
 {
 	struct clkdm_pwrdm_autodep *autodep;
 
-	for (autodep = autodeps; autodep->pwrdm_name; autodep++) {
-		if (!autodep->pwrdm)
-			continue;
-
+	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
 		pr_debug("clockdomain: adding %s sleepdep/wkdep for "
-			 "pwrdm %s\n", autodep->pwrdm_name,
-			 clkdm->pwrdm->name);
+			 "pwrdm %s\n", autodep->pwrdm.ptr->name,
+			 clkdm->pwrdm.ptr->name);
 
-		pwrdm_add_sleepdep(clkdm->pwrdm, autodep->pwrdm);
-		pwrdm_add_wkdep(clkdm->pwrdm, autodep->pwrdm);
+		pwrdm_add_sleepdep(clkdm->pwrdm.ptr, autodep->pwrdm.ptr);
+		pwrdm_add_wkdep(clkdm->pwrdm.ptr, autodep->pwrdm.ptr);
 	}
 }
 
@@ -120,16 +117,13 @@ static void _clkdm_del_autodeps(struct clockdomain *clkdm)
 {
 	struct clkdm_pwrdm_autodep *autodep;
 
-	for (autodep = autodeps; autodep->pwrdm_name; autodep++) {
-		if (!autodep->pwrdm)
-			continue;
-
+	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
 		pr_debug("clockdomain: removing %s sleepdep/wkdep for "
-			 "pwrdm %s\n", autodep->pwrdm_name,
-			 clkdm->pwrdm->name);
+			 "pwrdm %s\n", autodep->pwrdm.ptr->name,
+			 clkdm->pwrdm.ptr->name);
 
-		pwrdm_del_sleepdep(clkdm->pwrdm, autodep->pwrdm);
-		pwrdm_del_wkdep(clkdm->pwrdm, autodep->pwrdm);
+		pwrdm_del_sleepdep(clkdm->pwrdm.ptr, autodep->pwrdm.ptr);
+		pwrdm_del_wkdep(clkdm->pwrdm.ptr, autodep->pwrdm.ptr);
 	}
 }
 
@@ -179,7 +173,7 @@ void clkdm_init(struct clockdomain **clkdms,
 
 	autodeps = init_autodeps;
 	if (autodeps)
-		for (autodep = autodeps; autodep->pwrdm_name; autodep++)
+		for (autodep = autodeps; autodep->pwrdm.ptr; autodep++)
 			_autodep_lookup(autodep);
 }
 
@@ -202,13 +196,13 @@ int clkdm_register(struct clockdomain *clkdm)
 	if (!omap_chip_is(clkdm->omap_chip))
 		return -EINVAL;
 
-	pwrdm = pwrdm_lookup(clkdm->pwrdm_name);
+	pwrdm = pwrdm_lookup(clkdm->pwrdm.name);
 	if (!pwrdm) {
 		pr_debug("clockdomain: clkdm_register %s: powerdomain %s "
-			 "does not exist\n", clkdm->name, clkdm->pwrdm_name);
+			 "does not exist\n", clkdm->name, clkdm->pwrdm.name);
 		return -EINVAL;
 	}
-	clkdm->pwrdm = pwrdm;
+	clkdm->pwrdm.ptr = pwrdm;
 
 	mutex_lock(&clkdm_mutex);
 	/* Verify that the clockdomain is not already registered */
@@ -242,7 +236,7 @@ int clkdm_unregister(struct clockdomain *clkdm)
 	if (!clkdm)
 		return -EINVAL;
 
-	pwrdm_del_clkdm(clkdm->pwrdm, clkdm);
+	pwrdm_del_clkdm(clkdm->pwrdm.ptr, clkdm);
 
 	mutex_lock(&clkdm_mutex);
 	list_del(&clkdm->node);
@@ -327,7 +321,7 @@ struct powerdomain *clkdm_get_pwrdm(struct clockdomain *clkdm)
 	if (!clkdm)
 		return NULL;
 
-	return clkdm->pwrdm;
+	return clkdm->pwrdm.ptr;
 }
 
 
@@ -348,7 +342,7 @@ static int omap2_clkdm_clktrctrl_read(struct clockdomain *clkdm)
 	if (!clkdm)
 		return -EINVAL;
 
-	v = cm_read_mod_reg(clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+	v = cm_read_mod_reg(clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 	v &= clkdm->clktrctrl_mask;
 	v >>= __ffs(clkdm->clktrctrl_mask);
 
@@ -380,7 +374,7 @@ int omap2_clkdm_sleep(struct clockdomain *clkdm)
 	if (cpu_is_omap24xx()) {
 
 		cm_set_mod_reg_bits(OMAP24XX_FORCESTATE,
-				    clkdm->pwrdm->prcm_offs, PM_PWSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, PM_PWSTCTRL);
 
 	} else if (cpu_is_omap34xx()) {
 
@@ -388,7 +382,7 @@ int omap2_clkdm_sleep(struct clockdomain *clkdm)
 			 __ffs(clkdm->clktrctrl_mask));
 
 		cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask, v,
-				    clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 
 	} else {
 		BUG();
@@ -422,7 +416,7 @@ int omap2_clkdm_wakeup(struct clockdomain *clkdm)
 	if (cpu_is_omap24xx()) {
 
 		cm_clear_mod_reg_bits(OMAP24XX_FORCESTATE,
-				      clkdm->pwrdm->prcm_offs, PM_PWSTCTRL);
+				      clkdm->pwrdm.ptr->prcm_offs, PM_PWSTCTRL);
 
 	} else if (cpu_is_omap34xx()) {
 
@@ -430,7 +424,7 @@ int omap2_clkdm_wakeup(struct clockdomain *clkdm)
 			 __ffs(clkdm->clktrctrl_mask));
 
 		cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask, v,
-				    clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 
 	} else {
 		BUG();
@@ -478,7 +472,7 @@ void omap2_clkdm_allow_idle(struct clockdomain *clkdm)
 
 	cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask,
 			    v << __ffs(clkdm->clktrctrl_mask),
-			    clkdm->pwrdm->prcm_offs,
+			    clkdm->pwrdm.ptr->prcm_offs,
 			    CM_CLKSTCTRL);
 }
 
@@ -516,7 +510,7 @@ void omap2_clkdm_deny_idle(struct clockdomain *clkdm)
 
 	cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask,
 			    v << __ffs(clkdm->clktrctrl_mask),
-			    clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+			    clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 
 	if (atomic_read(&clkdm->usecount) > 0)
 		_clkdm_del_autodeps(clkdm);
diff --git a/arch/arm/mach-omap2/clockdomains.h b/arch/arm/mach-omap2/clockdomains.h
index cd86dcc..e17c369 100644
--- a/arch/arm/mach-omap2/clockdomains.h
+++ b/arch/arm/mach-omap2/clockdomains.h
@@ -19,7 +19,7 @@
 /* This is an implicit clockdomain - it is never defined as such in TRM */
 static struct clockdomain wkup_clkdm = {
 	.name		= "wkup_clkdm",
-	.pwrdm_name	= "wkup_pwrdm",
+	.pwrdm		= { .name = "wkup_pwrdm" },
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX | CHIP_IS_OMAP3430),
 };
 
@@ -31,7 +31,7 @@ static struct clockdomain wkup_clkdm = {
 
 static struct clockdomain mpu_2420_clkdm = {
 	.name		= "mpu_clkdm",
-	.pwrdm_name	= "mpu_pwrdm",
+	.pwrdm		= { .name = "mpu_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_MPU_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2420),
@@ -39,7 +39,7 @@ static struct clockdomain mpu_2420_clkdm = {
 
 static struct clockdomain iva1_2420_clkdm = {
 	.name		= "iva1_clkdm",
-	.pwrdm_name	= "dsp_pwrdm",
+	.pwrdm		= { .name = "dsp_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP2420_AUTOSTATE_IVA_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2420),
@@ -56,7 +56,7 @@ static struct clockdomain iva1_2420_clkdm = {
 
 static struct clockdomain mpu_2430_clkdm = {
 	.name		= "mpu_clkdm",
-	.pwrdm_name	= "mpu_pwrdm",
+	.pwrdm		= { .name = "mpu_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_MPU_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2430),
@@ -64,7 +64,7 @@ static struct clockdomain mpu_2430_clkdm = {
 
 static struct clockdomain mdm_clkdm = {
 	.name		= "mdm_clkdm",
-	.pwrdm_name	= "mdm_pwrdm",
+	.pwrdm		= { .name = "mdm_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP2430_AUTOSTATE_MDM_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP2430),
@@ -81,7 +81,7 @@ static struct clockdomain mdm_clkdm = {
 
 static struct clockdomain dsp_clkdm = {
 	.name		= "dsp_clkdm",
-	.pwrdm_name	= "dsp_pwrdm",
+	.pwrdm		= { .name = "dsp_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_DSP_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
@@ -89,7 +89,7 @@ static struct clockdomain dsp_clkdm = {
 
 static struct clockdomain gfx_24xx_clkdm = {
 	.name		= "gfx_clkdm",
-	.pwrdm_name	= "gfx_pwrdm",
+	.pwrdm		= { .name = "gfx_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_GFX_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
@@ -97,7 +97,7 @@ static struct clockdomain gfx_24xx_clkdm = {
 
 static struct clockdomain core_l3_24xx_clkdm = {
 	.name		= "core_l3_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_L3_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
@@ -105,7 +105,7 @@ static struct clockdomain core_l3_24xx_clkdm = {
 
 static struct clockdomain core_l4_24xx_clkdm = {
 	.name		= "core_l4_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_L4_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
@@ -113,7 +113,7 @@ static struct clockdomain core_l4_24xx_clkdm = {
 
 static struct clockdomain dss_24xx_clkdm = {
 	.name		= "dss_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP24XX_AUTOSTATE_DSS_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP24XX),
@@ -130,7 +130,7 @@ static struct clockdomain dss_24xx_clkdm = {
 
 static struct clockdomain mpu_34xx_clkdm = {
 	.name		= "mpu_clkdm",
-	.pwrdm_name	= "mpu_pwrdm",
+	.pwrdm		= { .name = "mpu_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP | CLKDM_CAN_FORCE_WAKEUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_MPU_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -138,7 +138,7 @@ static struct clockdomain mpu_34xx_clkdm = {
 
 static struct clockdomain neon_clkdm = {
 	.name		= "neon_clkdm",
-	.pwrdm_name	= "neon_pwrdm",
+	.pwrdm		= { .name = "neon_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_NEON_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -146,7 +146,7 @@ static struct clockdomain neon_clkdm = {
 
 static struct clockdomain iva2_clkdm = {
 	.name		= "iva2_clkdm",
-	.pwrdm_name	= "iva2_pwrdm",
+	.pwrdm		= { .name = "iva2_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_IVA2_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -154,7 +154,7 @@ static struct clockdomain iva2_clkdm = {
 
 static struct clockdomain gfx_3430es1_clkdm = {
 	.name		= "gfx_clkdm",
-	.pwrdm_name	= "gfx_pwrdm",
+	.pwrdm		= { .name = "gfx_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430ES1_CLKTRCTRL_GFX_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES1),
@@ -162,7 +162,7 @@ static struct clockdomain gfx_3430es1_clkdm = {
 
 static struct clockdomain sgx_clkdm = {
 	.name		= "sgx_clkdm",
-	.pwrdm_name	= "sgx_pwrdm",
+	.pwrdm		= { .name = "sgx_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_SGX_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
@@ -177,7 +177,7 @@ static struct clockdomain sgx_clkdm = {
  */
 static struct clockdomain d2d_clkdm = {
 	.name		= "d2d_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP3430ES1_CLKTRCTRL_D2D_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -185,7 +185,7 @@ static struct clockdomain d2d_clkdm = {
 
 static struct clockdomain core_l3_34xx_clkdm = {
 	.name		= "core_l3_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_L3_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -193,7 +193,7 @@ static struct clockdomain core_l3_34xx_clkdm = {
 
 static struct clockdomain core_l4_34xx_clkdm = {
 	.name		= "core_l4_clkdm",
-	.pwrdm_name	= "core_pwrdm",
+	.pwrdm		= { .name = "core_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_L4_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -201,7 +201,7 @@ static struct clockdomain core_l4_34xx_clkdm = {
 
 static struct clockdomain dss_34xx_clkdm = {
 	.name		= "dss_clkdm",
-	.pwrdm_name	= "dss_pwrdm",
+	.pwrdm		= { .name = "dss_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_DSS_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -209,7 +209,7 @@ static struct clockdomain dss_34xx_clkdm = {
 
 static struct clockdomain cam_clkdm = {
 	.name		= "cam_clkdm",
-	.pwrdm_name	= "cam_pwrdm",
+	.pwrdm		= { .name = "cam_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_CAM_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -217,7 +217,7 @@ static struct clockdomain cam_clkdm = {
 
 static struct clockdomain usbhost_clkdm = {
 	.name		= "usbhost_clkdm",
-	.pwrdm_name	= "usbhost_pwrdm",
+	.pwrdm		= { .name = "usbhost_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430ES2_CLKTRCTRL_USBHOST_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
@@ -225,7 +225,7 @@ static struct clockdomain usbhost_clkdm = {
 
 static struct clockdomain per_clkdm = {
 	.name		= "per_clkdm",
-	.pwrdm_name	= "per_pwrdm",
+	.pwrdm		= { .name = "per_pwrdm" },
 	.flags		= CLKDM_CAN_HWSUP_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_PER_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -233,7 +233,7 @@ static struct clockdomain per_clkdm = {
 
 static struct clockdomain emu_clkdm = {
 	.name		= "emu_clkdm",
-	.pwrdm_name	= "emu_pwrdm",
+	.pwrdm		= { .name = "emu_pwrdm" },
 	.flags		= CLKDM_CAN_ENABLE_AUTO | CLKDM_CAN_SWSUP,
 	.clktrctrl_mask = OMAP3430_CLKTRCTRL_EMU_MASK,
 	.omap_chip	= OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
@@ -247,14 +247,16 @@ static struct clockdomain emu_clkdm = {
 
 static struct clkdm_pwrdm_autodep clkdm_pwrdm_autodeps[] = {
 	{
-		.pwrdm_name = "mpu_pwrdm",
+		.pwrdm	   = { .name = "mpu_pwrdm" },
 		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
 	},
 	{
-		.pwrdm_name = "iva2_pwrdm",
+		.pwrdm	   = { .name = "iva2_pwrdm" },
 		.omap_chip = OMAP_CHIP_INIT(CHIP_IS_OMAP3430)
 	},
-	{ NULL }
+	{
+		.pwrdm	   = { .name = NULL },
+	}
 };
 
 /*
diff --git a/arch/arm/plat-omap/include/mach/clockdomain.h b/arch/arm/plat-omap/include/mach/clockdomain.h
index 1f51f01..b9d0dd2 100644
--- a/arch/arm/plat-omap/include/mach/clockdomain.h
+++ b/arch/arm/plat-omap/include/mach/clockdomain.h
@@ -1,5 +1,5 @@
 /*
- * linux/include/asm-arm/arch-omap/clockdomain.h
+ * arch/arm/plat-omap/include/mach/clockdomain.h
  *
  * OMAP2/3 clockdomain framework functions
  *
@@ -48,11 +48,13 @@
  */
 struct clkdm_pwrdm_autodep {
 
-	/* Name of the powerdomain to add a wkdep/sleepdep on */
-	const char *pwrdm_name;
+	union {
+		/* Name of the powerdomain to add a wkdep/sleepdep on */
+		const char *name;
 
-	/* Powerdomain pointer (looked up at clkdm_init() time) */
-	struct powerdomain *pwrdm;
+		/* Powerdomain pointer (looked up at clkdm_init() time) */
+		struct powerdomain *ptr;
+	} pwrdm;
 
 	/* OMAP chip types that this clockdomain dep is valid on */
 	const struct omap_chip_id omap_chip;
@@ -64,8 +66,13 @@ struct clockdomain {
 	/* Clockdomain name */
 	const char *name;
 
-	/* Powerdomain enclosing this clockdomain */
-	const char *pwrdm_name;
+	union {
+		/* Powerdomain enclosing this clockdomain */
+		const char *name;
+
+		/* Powerdomain pointer assigned at clkdm_register() */
+		struct powerdomain *ptr;
+	} pwrdm;
 
 	/* CLKTRCTRL/AUTOSTATE field mask in CM_CLKSTCTRL reg */
 	const u16 clktrctrl_mask;
@@ -79,9 +86,6 @@ struct clockdomain {
 	/* Usecount tracking */
 	atomic_t usecount;
 
-	/* Powerdomain pointer assigned at clkdm_register() */
-	struct powerdomain *pwrdm;
-
 	struct list_head node;
 
 };


