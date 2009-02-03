Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZBCJVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZBCJVK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 04:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbZBCJUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 04:20:49 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:38410 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZBCJUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 04:20:46 -0500
Date: Tue, 3 Feb 2009 02:20:44 -0700 (MST)
From: Paul Walmsley <paul@pwsan.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH B 02/10] OMAP2/3 clockdomains: combine pwrdm, pwrdm_name
 into union in struct clockdomain
In-Reply-To: <20090131120112.GG1394@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.00.0902030149520.29513@utopia.booyaka.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain> <20090128024408.27240.32198.stgit@localhost.localdomain> <20090131120112.GG1394@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Sat, 31 Jan 2009, Russell King - ARM Linux wrote:

> On Tue, Jan 27, 2009 at 07:44:11PM -0700, Paul Walmsley wrote:
> > struct clockdomain contains a struct powerdomain *pwrdm and const char
> > *pwrdm_name.  The pwrdm_name is only used at initialization to look up
> > the appropriate pwrdm pointer.  Combining these into a union saves
> > about 100 bytes on 3430SDP.  This patch should not cause any change in
> > kernel function.
> 
> For the same reasons as B1, this would seem to be unsafe.

Fixed; updated patch attached below.


- Paul

Author: Paul Walmsley <paul@pwsan.com>
Date:   Tue Feb 3 02:10:03 2009 -0700

    OMAP2/3 clockdomains: combine pwrdm, pwrdm_name into union in struct clockdomain
    
    struct clockdomain contains a struct powerdomain *pwrdm and const char
    *pwrdm_name.  The pwrdm_name is only used at initialization to look up
    the appropriate pwrdm pointer.  Combining these into a union saves
    about 100 bytes on 3430SDP.  This patch should not cause any change in
    kernel function.

    Updated to gracefully handle autodeps that contain invalid powerdomains,
    per Russell King's review comments.

    Boot-tested on BeagleBoard ES2.1.
    
    linux-omap source commit is 718fc6cd4db902aa2242a736cc3feb8744a4c71a.
    
    Signed-off-by: Paul Walmsley <paul@pwsan.com>
    Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/clockdomain.c b/arch/arm/mach-omap2/clockdomain.c
index 4c3ce9c..e9b4f6c 100644
--- a/arch/arm/mach-omap2/clockdomain.c
+++ b/arch/arm/mach-omap2/clockdomain.c
@@ -22,6 +22,7 @@
 #include <linux/delay.h>
 #include <linux/clk.h>
 #include <linux/limits.h>
+#include <linux/err.h>
 
 #include <linux/io.h>
 
@@ -71,14 +72,14 @@ static void _autodep_lookup(struct clkdm_pwrdm_autodep *autodep)
 	if (!omap_chip_is(autodep->omap_chip))
 		return;
 
-	pwrdm = pwrdm_lookup(autodep->pwrdm_name);
+	pwrdm = pwrdm_lookup(autodep->pwrdm.name);
 	if (!pwrdm) {
 		pr_debug("clockdomain: _autodep_lookup: powerdomain %s "
-			 "does not exist\n", autodep->pwrdm_name);
+			 "does not exist\n", autodep->pwrdm.name);
 		WARN_ON(1);
-		return;
+		pwrdm = ERR_PTR(-ENOENT);
 	}
-	autodep->pwrdm = pwrdm;
+	autodep->pwrdm.ptr = pwrdm;
 
 	return;
 }
@@ -95,16 +96,16 @@ static void _clkdm_add_autodeps(struct clockdomain *clkdm)
 {
 	struct clkdm_pwrdm_autodep *autodep;
 
-	for (autodep = autodeps; autodep->pwrdm_name; autodep++) {
-		if (!autodep->pwrdm)
+	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
+		if (IS_ERR(autodep->pwrdm.ptr))
 			continue;
 
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
 
@@ -120,16 +121,16 @@ static void _clkdm_del_autodeps(struct clockdomain *clkdm)
 {
 	struct clkdm_pwrdm_autodep *autodep;
 
-	for (autodep = autodeps; autodep->pwrdm_name; autodep++) {
-		if (!autodep->pwrdm)
+	for (autodep = autodeps; autodep->pwrdm.ptr; autodep++) {
+		if (IS_ERR(autodep->pwrdm.ptr))
 			continue;
 
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
 
@@ -179,7 +180,7 @@ void clkdm_init(struct clockdomain **clkdms,
 
 	autodeps = init_autodeps;
 	if (autodeps)
-		for (autodep = autodeps; autodep->pwrdm_name; autodep++)
+		for (autodep = autodeps; autodep->pwrdm.ptr; autodep++)
 			_autodep_lookup(autodep);
 }
 
@@ -202,13 +203,13 @@ int clkdm_register(struct clockdomain *clkdm)
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
@@ -242,7 +243,7 @@ int clkdm_unregister(struct clockdomain *clkdm)
 	if (!clkdm)
 		return -EINVAL;
 
-	pwrdm_del_clkdm(clkdm->pwrdm, clkdm);
+	pwrdm_del_clkdm(clkdm->pwrdm.ptr, clkdm);
 
 	mutex_lock(&clkdm_mutex);
 	list_del(&clkdm->node);
@@ -327,7 +328,7 @@ struct powerdomain *clkdm_get_pwrdm(struct clockdomain *clkdm)
 	if (!clkdm)
 		return NULL;
 
-	return clkdm->pwrdm;
+	return clkdm->pwrdm.ptr;
 }
 
 
@@ -348,7 +349,7 @@ static int omap2_clkdm_clktrctrl_read(struct clockdomain *clkdm)
 	if (!clkdm)
 		return -EINVAL;
 
-	v = cm_read_mod_reg(clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+	v = cm_read_mod_reg(clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 	v &= clkdm->clktrctrl_mask;
 	v >>= __ffs(clkdm->clktrctrl_mask);
 
@@ -380,7 +381,7 @@ int omap2_clkdm_sleep(struct clockdomain *clkdm)
 	if (cpu_is_omap24xx()) {
 
 		cm_set_mod_reg_bits(OMAP24XX_FORCESTATE,
-				    clkdm->pwrdm->prcm_offs, PM_PWSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, PM_PWSTCTRL);
 
 	} else if (cpu_is_omap34xx()) {
 
@@ -388,7 +389,7 @@ int omap2_clkdm_sleep(struct clockdomain *clkdm)
 			 __ffs(clkdm->clktrctrl_mask));
 
 		cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask, v,
-				    clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 
 	} else {
 		BUG();
@@ -422,7 +423,7 @@ int omap2_clkdm_wakeup(struct clockdomain *clkdm)
 	if (cpu_is_omap24xx()) {
 
 		cm_clear_mod_reg_bits(OMAP24XX_FORCESTATE,
-				      clkdm->pwrdm->prcm_offs, PM_PWSTCTRL);
+				      clkdm->pwrdm.ptr->prcm_offs, PM_PWSTCTRL);
 
 	} else if (cpu_is_omap34xx()) {
 
@@ -430,7 +431,7 @@ int omap2_clkdm_wakeup(struct clockdomain *clkdm)
 			 __ffs(clkdm->clktrctrl_mask));
 
 		cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask, v,
-				    clkdm->pwrdm->prcm_offs, CM_CLKSTCTRL);
+				    clkdm->pwrdm.ptr->prcm_offs, CM_CLKSTCTRL);
 
 	} else {
 		BUG();
@@ -478,7 +479,7 @@ void omap2_clkdm_allow_idle(struct clockdomain *clkdm)
 
 	cm_rmw_mod_reg_bits(clkdm->clktrctrl_mask,
 			    v << __ffs(clkdm->clktrctrl_mask),
-			    clkdm->pwrdm->prcm_offs,
+			    clkdm->pwrdm.ptr->prcm_offs,
 			    CM_CLKSTCTRL);
 }
 
@@ -516,7 +517,7 @@ void omap2_clkdm_deny_idle(struct clockdomain *clkdm)
 
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
