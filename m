Return-Path: <linux-kernel-owner+w=401wt.eu-S1756506AbXIVWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbXIVWWw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753118AbXIVWWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 18:22:44 -0400
Received: from khc.piap.pl ([195.187.100.11]:60569 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384AbXIVWWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 18:22:43 -0400
To: adaplas@gmail.com, sylvain.meyer@worldonline.fr, akpm@linux-foundation.org
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] Intel FB: more interlaced mode support
References: <m33ax65ot6.fsf@maximus.localdomain>
From: Krzysztof Halasa <khc@pm.waw.pl>
In-Reply-To: <m33ax65ot6.fsf@maximus.localdomain> (Krzysztof Halasa's message of "Sun, 23 Sep 2007 00:16:05 +0200")
Date: Sun, 23 Sep 2007 00:22:39 +0200
Message-ID: <m3r6kq49xs.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Intel FB: allow odd- and even-field-first in interlaced modes, and
proper sync to vertical retrace

Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>

--- a/drivers/video/intelfb/intelfbhw.c
+++ b/drivers/video/intelfb/intelfbhw.c
@@ -376,7 +376,7 @@ int intelfbhw_pan_display(struct fb_var_screeninfo *var, struct fb_info *info)
 
 	dinfo->vsync.pan_offset = offset;
 	if ((var->activate & FB_ACTIVATE_VBL) &&
-	    !intelfbhw_enable_irq(dinfo, 0))
+	    !intelfbhw_enable_irq(dinfo))
 		dinfo->vsync.pan_display = 1;
 	else {
 		dinfo->vsync.pan_display = 0;
@@ -1240,7 +1240,7 @@ int intelfbhw_program_mode(struct intelfb_info *dinfo,
 	u32 tmp;
 	const u32 *dpll, *fp0, *fp1, *pipe_conf;
 	const u32 *hs, *ht, *hb, *vs, *vt, *vb, *ss;
-	u32 dpll_reg, fp0_reg, fp1_reg, pipe_conf_reg;
+	u32 dpll_reg, fp0_reg, fp1_reg, pipe_conf_reg, pipe_stat_reg;
 	u32 hsync_reg, htotal_reg, hblank_reg;
 	u32 vsync_reg, vtotal_reg, vblank_reg;
 	u32 src_size_reg;
@@ -1281,6 +1281,7 @@ int intelfbhw_program_mode(struct intelfb_info *dinfo,
 		fp0_reg = FPB0;
 		fp1_reg = FPB1;
 		pipe_conf_reg = PIPEBCONF;
+		pipe_stat_reg = PIPEBSTAT;
 		hsync_reg = HSYNC_B;
 		htotal_reg = HTOTAL_B;
 		hblank_reg = HBLANK_B;
@@ -1304,6 +1305,7 @@ int intelfbhw_program_mode(struct intelfb_info *dinfo,
 		fp0_reg = FPA0;
 		fp1_reg = FPA1;
 		pipe_conf_reg = PIPEACONF;
+		pipe_stat_reg = PIPEASTAT;
 		hsync_reg = HSYNC_A;
 		htotal_reg = HTOTAL_A;
 		hblank_reg = HBLANK_A;
@@ -1390,6 +1392,17 @@ int intelfbhw_program_mode(struct intelfb_info *dinfo,
 	OUTREG(vtotal_reg, *vt);
 	OUTREG(src_size_reg, *ss);
 
+	switch (dinfo->info->var.vmode & (FB_VMODE_INTERLACED |
+					  FB_VMODE_ODD_FLD_FIRST)) {
+	case FB_VMODE_INTERLACED | FB_VMODE_ODD_FLD_FIRST:
+		OUTREG(pipe_stat_reg, 0xFFFF | PIPESTAT_FLD_EVT_ODD_EN);
+		break;
+	case FB_VMODE_INTERLACED: /* even lines first */
+		OUTREG(pipe_stat_reg, 0xFFFF | PIPESTAT_FLD_EVT_EVEN_EN);
+		break;
+	default:		/* non-interlaced */
+		OUTREG(pipe_stat_reg, 0xFFFF); /* clear all status bits only */
+	}
 	/* Enable pipe */
 	OUTREG(pipe_conf_reg, *pipe_conf | PIPECONF_ENABLE);
 
@@ -1955,71 +1968,72 @@ void intelfbhw_cursor_reset(struct intelfb_info *dinfo)
 	}
 }
 
-static irqreturn_t
-intelfbhw_irq(int irq, void *dev_id) {
-	int handled = 0;
+static irqreturn_t intelfbhw_irq(int irq, void *dev_id)
+{
 	u16 tmp;
 	struct intelfb_info *dinfo = (struct intelfb_info *)dev_id;
 
 	spin_lock(&dinfo->int_lock);
 
 	tmp = INREG16(IIR);
-	tmp &= VSYNC_PIPE_A_INTERRUPT;
+	if (dinfo->info->var.vmode & FB_VMODE_INTERLACED)
+		tmp &= PIPE_A_EVENT_INTERRUPT;
+	else
+		tmp &= VSYNC_PIPE_A_INTERRUPT; /* non-interlaced */
 
 	if (tmp == 0) {
 		spin_unlock(&dinfo->int_lock);
-		return IRQ_RETVAL(handled);
+		return IRQ_RETVAL(0); /* not us */
 	}
 
-	OUTREG16(IIR, tmp);
+	/* clear status bits 0-15 ASAP and don't touch bits 16-31 */
+	OUTREG(PIPEASTAT, INREG(PIPEASTAT));
 
-	if (tmp & VSYNC_PIPE_A_INTERRUPT) {
-		dinfo->vsync.count++;
-		if (dinfo->vsync.pan_display) {
-			dinfo->vsync.pan_display = 0;
-			OUTREG(DSPABASE, dinfo->vsync.pan_offset);
-		}
-		wake_up_interruptible(&dinfo->vsync.wait);
-		handled = 1;
+	OUTREG16(IIR, tmp);
+	if (dinfo->vsync.pan_display) {
+		dinfo->vsync.pan_display = 0;
+		OUTREG(DSPABASE, dinfo->vsync.pan_offset);
 	}
 
+	dinfo->vsync.count++;
+	wake_up_interruptible(&dinfo->vsync.wait);
+
 	spin_unlock(&dinfo->int_lock);
 
-	return IRQ_RETVAL(handled);
+	return IRQ_RETVAL(1);
 }
 
-int
-intelfbhw_enable_irq(struct intelfb_info *dinfo, int reenable) {
-
+int intelfbhw_enable_irq(struct intelfb_info *dinfo)
+{
+	u16 tmp;
 	if (!test_and_set_bit(0, &dinfo->irq_flags)) {
 		if (request_irq(dinfo->pdev->irq, intelfbhw_irq, IRQF_SHARED,
-		     "intelfb", dinfo)) {
+				"intelfb", dinfo)) {
 			clear_bit(0, &dinfo->irq_flags);
 			return -EINVAL;
 		}
 
 		spin_lock_irq(&dinfo->int_lock);
-		OUTREG16(HWSTAM, 0xfffe);
-		OUTREG16(IMR, 0x0);
-		OUTREG16(IER, VSYNC_PIPE_A_INTERRUPT);
-		spin_unlock_irq(&dinfo->int_lock);
-	} else if (reenable) {
-		u16 ier;
-
+		OUTREG16(HWSTAM, 0xfffe); /* i830 DRM uses ffff */
+		OUTREG16(IMR, 0);
+	} else
 		spin_lock_irq(&dinfo->int_lock);
-		ier = INREG16(IER);
-		if ((ier & VSYNC_PIPE_A_INTERRUPT)) {
-			DBG_MSG("someone disabled the IRQ [%08X]\n", ier);
-			OUTREG(IER, VSYNC_PIPE_A_INTERRUPT);
-		}
-		spin_unlock_irq(&dinfo->int_lock);
+
+	if (dinfo->info->var.vmode & FB_VMODE_INTERLACED)
+		tmp = PIPE_A_EVENT_INTERRUPT;
+	else
+		tmp = VSYNC_PIPE_A_INTERRUPT; /* non-interlaced */
+	if (tmp != INREG16(IER)) {
+		DBG_MSG("changing IER to 0x%X\n", tmp);
+		OUTREG16(IER, tmp);
 	}
+
+	spin_unlock_irq(&dinfo->int_lock);
 	return 0;
 }
 
-void
-intelfbhw_disable_irq(struct intelfb_info *dinfo) {
-
+void intelfbhw_disable_irq(struct intelfb_info *dinfo)
+{
 	if (test_and_clear_bit(0, &dinfo->irq_flags)) {
 		if (dinfo->vsync.pan_display) {
 			dinfo->vsync.pan_display = 0;
@@ -2051,7 +2065,7 @@ int intelfbhw_wait_for_vsync(struct intelfb_info *dinfo, u32 pipe)
 			return -ENODEV;
 	}
 
-	ret = intelfbhw_enable_irq(dinfo, 0);
+	ret = intelfbhw_enable_irq(dinfo);
 	if (ret)
 		return ret;
 
@@ -2061,7 +2075,6 @@ int intelfbhw_wait_for_vsync(struct intelfb_info *dinfo, u32 pipe)
 	if (ret < 0)
 		return ret;
 	if (ret == 0) {
-		intelfbhw_enable_irq(dinfo, 1);
 		DBG_MSG("wait_for_vsync timed out!\n");
 		return -ETIMEDOUT;
 	}
--- a/drivers/video/intelfb/intelfbhw.h
+++ b/drivers/video/intelfb/intelfbhw.h
@@ -280,6 +280,9 @@
 #define PIPEB_DSL		0x71000
 #define PIPEACONF		0x70008
 #define PIPEBCONF		0x71008
+#define PIPEASTAT		0x70024 /* bits 0-15 are "write 1 to clear" */
+#define PIPEBSTAT		0x71024
+
 #define PIPECONF_ENABLE			(1 << 31)
 #define PIPECONF_DISABLE		0
 #define PIPECONF_DOUBLE_WIDE		(1 << 30)
@@ -293,6 +296,31 @@
 #define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
 #define PIPECONF_INTERLACE_MASK			(7 << 21)
 
+/* enable bits, write 1 to enable */
+#define PIPESTAT_FIFO_UNDERRUN		(1 << 31)
+#define PIPESTAT_CRC_ERROR_EN		(1 << 29)
+#define PIPESTAT_CRC_DONE_EN		(1 << 28)
+#define PIPESTAT_HOTPLUG_EN		(1 << 26)
+#define PIPESTAT_VERTICAL_SYNC_EN	(1 << 25)
+#define PIPESTAT_DISPLINE_COMP_EN	(1 << 24)
+#define PIPESTAT_FLD_EVT_ODD_EN		(1 << 21)
+#define PIPESTAT_FLD_EVT_EVEN_EN	(1 << 20)
+#define PIPESTAT_TV_HOTPLUG_EN		(1 << 18)
+#define PIPESTAT_VBLANK_EN		(1 << 17)
+#define PIPESTAT_OVL_UPDATE_EN		(1 << 16)
+/* status bits, write 1 to clear */
+#define PIPESTAT_HOTPLUG_STATE		(1 << 15)
+#define PIPESTAT_CRC_ERROR		(1 << 13)
+#define PIPESTAT_CRC_DONE		(1 << 12)
+#define PIPESTAT_HOTPLUG		(1 << 10)
+#define PIPESTAT_VSYNC			(1 << 9)
+#define PIPESTAT_DISPLINE_COMP		(1 << 8)
+#define PIPESTAT_FLD_EVT_ODD		(1 << 5)
+#define PIPESTAT_FLD_EVT_EVEN		(1 << 4)
+#define PIPESTAT_TV_HOTPLUG		(1 << 2)
+#define PIPESTAT_VBLANK			(1 << 1)
+#define PIPESTAT_OVL_UPDATE		(1 << 0)
+
 #define DISPARB			0x70030
 #define DISPARB_AEND_MASK		0x1ff
 #define DISPARB_AEND_SHIFT		0
@@ -573,7 +601,7 @@ extern void intelfbhw_cursor_setcolor(struct intelfb_info *dinfo, u32 bg,
 extern void intelfbhw_cursor_load(struct intelfb_info *dinfo, int width,
 				  int height, u8 *data);
 extern void intelfbhw_cursor_reset(struct intelfb_info *dinfo);
-extern int intelfbhw_enable_irq(struct intelfb_info *dinfo, int reenable);
+extern int intelfbhw_enable_irq(struct intelfb_info *dinfo);
 extern void intelfbhw_disable_irq(struct intelfb_info *dinfo);
 extern int intelfbhw_wait_for_vsync(struct intelfb_info *dinfo, u32 pipe);
 
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -206,6 +206,7 @@ struct fb_bitfield {
 #define FB_VMODE_NONINTERLACED  0	/* non interlaced */
 #define FB_VMODE_INTERLACED	1	/* interlaced	*/
 #define FB_VMODE_DOUBLE		2	/* double scan */
+#define FB_VMODE_ODD_FLD_FIRST	4	/* interlaced: top line first */
 #define FB_VMODE_MASK		255
 
 #define FB_VMODE_YWRAP		256	/* ywrap instead of panning     */
