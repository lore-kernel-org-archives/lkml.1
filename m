Return-Path: <linux-kernel-owner+w=401wt.eu-S965700AbXAYIWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965700AbXAYIWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 03:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965703AbXAYIWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 03:22:49 -0500
Received: from jenny.ondioline.org ([66.220.1.122]:3924 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbXAYIWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 03:22:48 -0500
X-Greylist: delayed 1353 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 03:22:48 EST
From: Paul Collins <paul@briny.ondioline.org>
To: airlied@linux.ie
Cc: benh@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: gpu sharing layer for kernel
References: <1169637623985-git-send-email-airlied@linux.ie>
Date: Thu, 25 Jan 2007 20:56:37 +1300
In-Reply-To: <1169637623985-git-send-email-airlied@linux.ie>
	(airlied@linux.ie's message of "Wed\, 24 Jan 2007 22\:20\:18 +1100")
Message-ID: <87k5zbsfnu.fsf@briny.internal.ondioline.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

airlied@linux.ie writes:

> This patch series contains the gpu sharing layer for kernel that
> I've mentioned before. It should apply against Linus's git tree.

I gave the patches a go on my PowerBook.  I had to make a few changes
to get it to compile.  Works fine so far: I switched between VTs and X
with an accelerated GLX client active a few times, no problems.

When I did a sleep/resume cycle it wedged on resume, but I expect this
is due to my hacking up radeonfb_early_resume(), as seen in the last
hunk below, which was just aimed at just getting it to compile.


diff --git a/drivers/video/aty/radeon_backlight.c b/drivers/video/aty/radeon_backlight.c
index 3abfd4a..560568b 100644
--- a/drivers/video/aty/radeon_backlight.c
+++ b/drivers/video/aty/radeon_backlight.c
@@ -105,7 +105,7 @@ static int radeon_bl_update_status(struct backlight_device *bd)
 		   RADEON_PIXCLK_LVDS_ALWAYS_ON bit is off
 		*/
 		tmpPixclksCntl = INPLL(PIXCLKS_CNTL);
-		if (rinfo->is_mobility || rinfo->is_IGP)
+		if (rinfo->gpu_info->is_mobility || rinfo->gpu_info->is_IGP)
 			OUTPLLP(PIXCLKS_CNTL, 0, ~PIXCLK_LVDS_ALWAYS_ONb);
 		lvds_gen_cntl &= ~(LVDS_BL_MOD_LEVEL_MASK | LVDS_BL_MOD_EN);
 		lvds_gen_cntl |= (radeon_bl_get_level_brightness(pdata, 0) <<
@@ -119,7 +119,7 @@ static int radeon_bl_update_status(struct backlight_device *bd)
 		rinfo->pending_lvds_gen_cntl = lvds_gen_cntl;
 		mod_timer(&rinfo->lvds_timer,
 			  jiffies + msecs_to_jiffies(rinfo->panel_info.pwr_delay));
-		if (rinfo->is_mobility || rinfo->is_IGP)
+		if (rinfo->gpu_info->is_mobility || rinfo->gpu_info->is_IGP)
 			OUTPLL(PIXCLKS_CNTL, tmpPixclksCntl);
 	}
 	rinfo->init_state.lvds_gen_cntl &= ~LVDS_STATE_MASK;
@@ -176,10 +176,10 @@ void radeonfb_bl_init(struct radeonfb_info *rinfo)
 	 * direction backlight should work on a given panel?
 	 */
 	pdata->negative =
-		(rinfo->family != CHIP_FAMILY_RV200 &&
-		 rinfo->family != CHIP_FAMILY_RV250 &&
-		 rinfo->family != CHIP_FAMILY_RV280 &&
-		 rinfo->family != CHIP_FAMILY_RV350);
+		(rinfo->gpu_info->family != CHIP_FAMILY_RV200 &&
+		 rinfo->gpu_info->family != CHIP_FAMILY_RV250 &&
+		 rinfo->gpu_info->family != CHIP_FAMILY_RV280 &&
+		 rinfo->gpu_info->family != CHIP_FAMILY_RV350);
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	pdata->negative = pdata->negative ||
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index f634c43..c8cc173 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -1837,7 +1837,8 @@ static int radeonfb_set_par(struct fb_info *info)
 
 #ifdef CONFIG_BOOTX_TEXT
 	/* Update debug text engine */
-	btext_update_display(rinfo->fb_base_phys, mode->xres, mode->yres,
+	btext_update_display(rinfo->gpu_info->fb_base_phys,
+			     mode->xres, mode->yres,
 			     rinfo->depth, info->fix.line_length);
 #endif
 
diff --git a/drivers/video/aty/radeon_monitor.c b/drivers/video/aty/radeon_monitor.c
index 8625f5d..4cd4f34 100644
--- a/drivers/video/aty/radeon_monitor.c
+++ b/drivers/video/aty/radeon_monitor.c
@@ -122,7 +122,7 @@ static int __devinit radeon_probe_OF_head(struct radeonfb_info *rinfo, int head_
         while (dp == NULL)
 		return MT_NONE;
 
-	if (rinfo->has_CRTC2) {
+	if (rinfo->gpu_info->has_CRTC2) {
 		const char *pname;
 		int len, second = 0;
 
@@ -141,7 +141,7 @@ static int __devinit radeon_probe_OF_head(struct radeonfb_info *rinfo, int head_
 				/* Maybe check for LVDS_GEN_CNTL here ? I need to check out
 				 * what OF does when booting with lid closed
 				 */
-				if (mt == MT_DFP && rinfo->is_mobility)
+				if (mt == MT_DFP && rinfo->gpu_info->is_mobility)
 					mt = MT_LCD;
 				return mt;
 			} else if (pname[len-1] == 'B' && head_no == 1)
@@ -655,7 +655,7 @@ static void radeon_fixup_panel_info(struct radeonfb_info *rinfo)
 	 * PPC only for now...
 	 */
 	if (!rinfo->panel_info.use_bios_dividers && rinfo->mon1_type == MT_LCD
-	    && rinfo->is_mobility) {
+	    && rinfo->gpu_info->is_mobility) {
 		int ppll_div_sel;
 		u32 ppll_divn;
 		ppll_div_sel = INREG8(CLOCK_CNTL_INDEX + 1) & 0x3;
diff --git a/drivers/video/aty/radeon_pm.c b/drivers/video/aty/radeon_pm.c
index 9a59804..f113616 100644
--- a/drivers/video/aty/radeon_pm.c
+++ b/drivers/video/aty/radeon_pm.c
@@ -957,7 +957,7 @@ static void radeon_pm_setup_for_suspend(struct radeonfb_info *rinfo)
 #ifdef CONFIG_PPC_PMAC
 	if (machine_is(powermac)) {
 		/* AGP PLL control */
-		if (rinfo->family <= CHIP_FAMILY_RV280) {
+		if (rinfo->gpu_info->family <= CHIP_FAMILY_RV280) {
 			OUTREG(BUS_CNTL1, INREG(BUS_CNTL1) |  BUS_CNTL1__AGPCLK_VALID);
 			OUTREG(BUS_CNTL1,
 			       (INREG(BUS_CNTL1) & ~BUS_CNTL1__MOBILE_PLATFORM_SEL_MASK)
@@ -2817,7 +2817,7 @@ static void radeonfb_early_resume(void *data)
         struct radeonfb_info *rinfo = data;
 
 	rinfo->no_schedule = 1;
-	radeonfb_pci_resume(rinfo->pdev);
+	radeonfb_gpu_resume(rinfo->gpu_info->info.device);
 	rinfo->no_schedule = 0;
 }
 #endif /* CONFIG_PPC_OF */


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
