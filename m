Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYC1APS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYC1APS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbYC1APG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:15:06 -0400
Received: from mail.queued.net ([207.210.101.209]:4424 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbYC1APF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:15:05 -0400
Date: Thu, 27 Mar 2008 20:15:45 -0400
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: info-linux@geode.amd.com, jordan.crouse@amd.com
Subject: geode GX/LX framebuffer register compare patch
Message-ID: <20080327201545.70b87859@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This code isn't destined for the kernel, but is useful for debugging
suspend/resume issues where register values aren't being properly restored.
It turned up a few bugs in the lxfb and gxfb power mgmt code that OLPC
uses.  I'm sending it out to get indexed by google/archived in case
other people find it useful.





>From fdb4da1ba350ec346a4a5eedd36e6b8dbe155524 Mon Sep 17 00:00:00 2001
From: Andres Salomon <dilinger@debian.org>
Date: Thu, 27 Mar 2008 14:56:20 -0400
Subject: [PATCH] lxfb/gxfb: register comparison code

Compare video registers before and after suspend to ensure that we've
correctly restored them in the resume path.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/video/geode/lxfb_ops.c   |  101 ++++++++++++++++++++++++++++++++++++++
 drivers/video/geode/suspend_gx.c |   71 ++++++++++++++++++++++++++
 2 files changed, 172 insertions(+), 0 deletions(-)

diff --git a/drivers/video/geode/lxfb_ops.c b/drivers/video/geode/lxfb_ops.c
index cf8007c..069196a 100644
--- a/drivers/video/geode/lxfb_ops.c
+++ b/drivers/video/geode/lxfb_ops.c
@@ -523,6 +523,106 @@ int lx_blank_display(struct fb_info *info, int blank_mode)
 
 #ifdef CONFIG_PM
 
+static void lx_cmp_regs(struct lxfb_par *par)
+{
+	int i;
+	uint32_t val;
+
+	rdmsrl(MSR_LX_MSR_PADSEL, val);
+	if ((uint32_t) par->msr.padsel != val)
+		printk(KERN_WARNING "%s: MSR_LX_MSR_PADSEL contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.padsel);
+	
+	rdmsrl(MSR_GLCP_DOTPLL, val);
+	if ((uint32_t) par->msr.dotpll != val)
+		printk(KERN_WARNING "%s: MSR_GLCP_DOTPLL contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.dotpll);
+
+
+	rdmsrl(MSR_LX_GLD_MSR_CONFIG, val);
+	if ((uint32_t) par->msr.dfglcfg != val)
+		printk(KERN_WARNING "%s: MSR_LX_GLD_MSR_CONFIG contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.dfglcfg);
+
+	rdmsrl(MSR_LX_SPARE_MSR, val);
+	if ((uint32_t) par->msr.dcspare != val)
+		printk(KERN_WARNING "%s: MSR_LX_SPARE_MSR contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.dcspare);
+
+	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
+		switch (i) {
+		case GP_VECTOR_MODE:
+		case GP_BLT_MODE:
+		case GP_BLT_STATUS:
+		case GP_HST_SRC:
+			/* ignore WO and RO regs */
+			break;
+		default:
+			val = read_gp(par, i);
+			if (par->gp[i] != val)
+				printk(KERN_WARNING "%s: GP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*4, val, par->gp[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->dc); i++) {
+		switch (i) {
+		case DC_RSVD_0:
+		case DC_RSVD_1:
+		case DC_RSVD_2:
+		case DC_RSVD_3:
+		case DC_RSVD_4:
+		case DC_RSVD_5:
+		case DC_LINE_CNT:
+		case DC_PAL_ADDRESS:
+		case DC_PAL_DATA:
+		case DC_DFIFO_DIAG:
+		case DC_CFIFO_DIAG:
+			/* ignore WO and RO regs */
+			break;
+		default:
+			val = read_dc(par, i);
+			if (par->dc[i] != val)
+				printk(KERN_WARNING "%s: DC register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*4, val, par->dc[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->vp); i++) {
+		switch (i) {
+		case VP_PAR:
+		case VP_PDR:
+		case VP_RSVD_0:
+		case VP_RSVD_1:
+		case VP_CRC32:
+		case VP_AWT:
+			/* ignore WO and RO regs */
+			break;
+		default:
+			val = read_vp(par, i);
+			if (par->vp[i] != val)
+				printk(KERN_WARNING "%s: VP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*8, val, (uint32_t) par->vp[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->fp); i++) {
+		switch (i) {
+		case FP_RSVD_0:
+		case FP_RSVD_1:
+		case FP_RSVD_2:
+		case FP_RSVD_3:
+		case FP_RSVD_4:
+			/* ignore WO and RO regs */
+			break;
+		default:
+			val = read_fp(par, i);
+			if (par->fp[i] != val)
+				printk(KERN_WARNING "%s: FP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*8, val, (uint32_t) par->fp[i]);
+		}
+	}
+
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++) {
+		val = read_dc(par, DC_PAL_DATA);
+		if (par->pal[i] != val)
+			printk(KERN_WARNING "%s: palette address %x contains 0x%x, but saved value is 0x%x!\n", __func__, i, val, par->pal[i]);
+	}
+}
+
 static void lx_save_regs(struct lxfb_par *par)
 {
 	uint32_t filt;
@@ -764,6 +864,7 @@ int lx_powerup(struct fb_info *info)
 		return 0;
 
 	lx_restore_regs(par);
+	lx_cmp_regs(par);
 
 	par->powered_down = 0;
 	return 0;
diff --git a/drivers/video/geode/suspend_gx.c b/drivers/video/geode/suspend_gx.c
index 9aff32e..c9e3159 100644
--- a/drivers/video/geode/suspend_gx.c
+++ b/drivers/video/geode/suspend_gx.c
@@ -17,6 +17,76 @@
 
 #ifdef CONFIG_PM
 
+static void gx_cmp_regs(struct gxfb_par *par)
+{
+	int i;
+	uint32_t val;
+
+	rdmsrl(MSR_GX_MSR_PADSEL, val);
+	if ((uint32_t) par->msr.padsel != val)
+		printk(KERN_WARNING "%s: MSR_GX_MSR_PADSEL contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.padsel);
+
+	rdmsrl(MSR_GLCP_DOTPLL, val);
+	if ((uint32_t) par->msr.dotpll != val)
+		printk(KERN_WARNING "%s: MSR_GLCP_DOTPLL contains 0x%x, but saved value is 0x%x!\n", __func__, val, (uint32_t) par->msr.dotpll);
+
+	for (i = 0; i < ARRAY_SIZE(par->gp); i++) {
+		switch (i) {
+		case GP_BLT_MODE:
+		case GP_BLT_STATUS:
+		case GP_HST_SRC:
+			/* ignore WO and RO regs */
+			break;
+		default:
+			val = read_gp(par, i);
+			if (par->gp[i] != val)
+				printk(KERN_WARNING "%s: GP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*4, val, par->gp[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->dc); i++) {
+		switch (i) {
+		case DC_RSVD_0:
+		case DC_RSVD_1:
+		case DC_RSVD_2:
+		case DC_RSVD_3:
+		case DC_RSVD_4:
+		case DC_RSVD_5:
+			/* ignore reserved regs */
+			break;
+		default:
+			val = read_dc(par, i);
+			if (par->dc[i] != val)
+				printk(KERN_WARNING "%s: DC register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*4, val, par->dc[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->vp); i++) {
+		switch (i) {
+		default:
+			val = read_vp(par, i);
+			if (par->vp[i] != val)
+				printk(KERN_WARNING "%s: VP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*8, val, (uint32_t) par->vp[i]);
+		}
+	}
+
+	for (i = 0; i < ARRAY_SIZE(par->fp); i++) {
+		switch (i) {
+		default:
+			val = read_fp(par, i);
+			if (par->fp[i] != val)
+				printk(KERN_WARNING "%s: FP register %x contains 0x%x, but saved value is 0x%x!\n", __func__, i*8, val, (uint32_t) par->fp[i]);
+		}
+	}
+
+	write_dc(par, DC_PAL_ADDRESS, 0);
+	for (i = 0; i < ARRAY_SIZE(par->pal); i++) {
+		val = read_dc(par, DC_PAL_DATA);
+		if (par->pal[i] != val)
+			printk(KERN_WARNING "%s: palette address %x contains 0x%x, but saved value is 0x%x!\n", __func__, i, val, par->pal[i]);
+	}
+}
+
 static void gx_save_regs(struct gxfb_par *par)
 {
 	int i;
@@ -259,6 +329,7 @@ int gx_powerup(struct fb_info *info)
 
 	gx_restore_regs(par);
 	gx_enable_graphics(par);
+	gx_cmp_regs(par);
 
 	par->powered_down  = 0;
 	return 0;
-- 
1.5.3.7

