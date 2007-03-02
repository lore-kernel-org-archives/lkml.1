Return-Path: <linux-kernel-owner+w=401wt.eu-S2992745AbXCBXdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992745AbXCBXdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:33:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992747AbXCBXdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:33:14 -0500
Received: from tim.rpsys.net ([194.106.48.114]:57555 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992745AbXCBXdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:33:11 -0500
Subject: Re: 2.6.21-rc2 radeon backlight
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@gmail.com>,
       James Simmons <jsimmons@infradead.org>
Cc: Alex Romosan <romosan@sycorax.lbl.gov>, linux-kernel@vger.kernel.org,
       linux-fbdev-devel@lists.sourceforge.net,
       "David S. Miller" <davem@davemloft.net>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Yaroslav Halchenko <lists@onerussian.com>
In-Reply-To: <20070302122920.a2967ebf.akpm@linux-foundation.org>
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
	 <20070301184531.b3aeafe3.akpm@linux-foundation.org>
	 <87tzx35zkc.fsf@sycorax.lbl.gov>
	 <20070302122920.a2967ebf.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 02 Mar 2007 23:32:18 +0000
Message-Id: <1172878338.11149.198.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-02 at 12:29 -0800, Andrew Morton wrote:
> On Fri, 02 Mar 2007 09:24:03 -0800
> Alex Romosan <romosan@sycorax.lbl.gov> wrote:
> > > Unclear. Are you saying that the backlight comes on OK if you use
> > > the IBM acpi module?
> > 
> > yes, if i disable the radeon backlight and use the ibm acpi module,
> > than the backlight works. if i enable the radeon backlight, the screen
> > stays dark and i can't turn it on (i tried using radeontool to control
> > it but nothing happened).
> 
> Richard, is this actually a bug, or is it a config error or something like that?
> 
> And should we track it as a post-2.6.20 regression?

Its a regression IMO. Arguably its a Kconfig error but a nasty one as
the defaults cause the problems. Different people seem to have different
interpretations but to me it appears that the patch from James causes
backlights to fail to turn on for a variety of devices which worked
before.

I propose the following patch (I was previously waiting on James for
this). It avoids backing out the problematic Kconfig changes but means a
user has to explicitly enable the backlight via a kernel or module
parameter.

Can people with backlight problems try enabling them in Kconfig but
applying the following patch? Hopefully I have you all cc'd.

If it works I will add it to the other fix I have queued and pass to
Linus via the backlight tree. If it doesn't, I will revert the
problematic Kconfig changes for the next -rc.

----

Enabling the backlight by default appears to cause problems for mamny
users. Disable backlight controls unless explicitly enabled by users via
a module parameter. Since PMAC users are known to work, default to
enabled in that case.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net>

--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -357,6 +357,12 @@ static int default_lcd_on __devinitdata = 1;
 static int mtrr = 1;
 #endif
 
+#ifdef CONFIG_PMAC_BACKLIGHT
+static int backlight __devinitdata = 1;
+#else
+static int backlight __devinitdata = 0;
+#endif
+
 /* PLL constants */
 struct aty128_constants {
 	u32 ref_clk;
@@ -1652,6 +1658,9 @@ static int __devinit aty128fb_setup(char *options)
 		} else if (!strncmp(this_opt, "crt:", 4)) {
 			default_crt_on = simple_strtoul(this_opt+4, NULL, 0);
 			continue;
+		} else if (!strncmp(this_opt, "backlight:", 10)) {
+			backlight = simple_strtoul(this_opt+10, NULL, 0);
+			continue;
 		}
 #ifdef CONFIG_MTRR
 		if(!strncmp(this_opt, "nomtrr", 6)) {
@@ -1985,7 +1994,8 @@ static int __devinit aty128_init(struct pci_dev *pdev, const struct pci_device_i
 	par->lock_blank = 0;
 
 #ifdef CONFIG_FB_ATY128_BACKLIGHT
-	aty128_bl_init(par);
+	if (backlight)
+		aty128_bl_init(par);
 #endif
 
 	if (register_framebuffer(info) < 0)
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index a7e0062..00a5183 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -308,6 +308,12 @@ static int xclk;
 static int comp_sync __devinitdata = -1;
 static char *mode;
 
+#ifdef CONFIG_PMAC_BACKLIGHT
+static int backlight __devinitdata = 1;
+#else
+static int backlight __devinitdata = 0;
+#endif
+
 #ifdef CONFIG_PPC
 static int default_vmode __devinitdata = VMODE_CHOOSE;
 static int default_cmode __devinitdata = CMODE_CHOOSE;
@@ -2575,7 +2581,7 @@ static int __devinit aty_init(struct fb_info *info)
 			   | (USE_F32KHZ | TRISTATE_MEM_EN), par);
 	} else
 #endif
-	if (M64_HAS(MOBIL_BUS)) {
+	if (M64_HAS(MOBIL_BUS) && backlight) {
 #ifdef CONFIG_FB_ATY_BACKLIGHT
 		aty_bl_init (par);
 #endif
@@ -3757,6 +3763,8 @@ static int __init atyfb_setup(char *options)
 			xclk = simple_strtoul(this_opt+5, NULL, 0);
 		else if (!strncmp(this_opt, "comp_sync:", 10))
 			comp_sync = simple_strtoul(this_opt+10, NULL, 0);
+		else if (!strncmp(this_opt, "backlight:", 10))
+			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_PPC
 		else if (!strncmp(this_opt, "vmode:", 6)) {
 			unsigned int vmode =
diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
index 7e228ad..7de3ff9 100644
--- a/drivers/video/aty/radeon_base.c
+++ b/drivers/video/aty/radeon_base.c
@@ -268,6 +268,11 @@ static int nomtrr = 0;
 #endif
 static int force_sleep;
 static int ignore_devlist;
+#ifdef CONFIG_PMAC_BACKLIGHT
+static int backlight = 1;
+#else
+static int backlight = 0;
+#endif
 
 /*
  * prototypes
@@ -2349,7 +2354,8 @@ static int __devinit radeonfb_pci_register (struct pci_dev *pdev,
 						 MTRR_TYPE_WRCOMB, 1);
 #endif
 
-	radeonfb_bl_init(rinfo);
+	if (backlight)
+		radeonfb_bl_init(rinfo);
 
 	printk ("radeonfb (%s): %s\n", pci_name(rinfo->pdev), rinfo->name);
 
@@ -2470,6 +2476,8 @@ static int __init radeonfb_setup (char *options)
 			force_dfp = 1;
 		} else if (!strncmp(this_opt, "panel_yres:", 11)) {
 			panel_yres = simple_strtoul((this_opt+11), NULL, 0);
+		} else if (!strncmp(this_opt, "backlight:", 10)) {
+			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
diff --git a/drivers/video/nvidia/nvidia.c b/drivers/video/nvidia/nvidia.c
index c18e955..b97ec69 100644
--- a/drivers/video/nvidia/nvidia.c
+++ b/drivers/video/nvidia/nvidia.c
@@ -83,6 +83,11 @@ static int bpp __devinitdata = 8;
 #ifdef CONFIG_MTRR
 static int nomtrr __devinitdata = 0;
 #endif
+#ifdef CONFIG_PMAC_BACKLIGHT
+static int backlight __devinitdata = 1;
+#else
+static int backlight __devinitdata = 0;
+#endif
 
 static char *mode_option __devinitdata = NULL;
 
@@ -1311,7 +1316,10 @@ static int __devinit nvidiafb_probe(struct pci_dev *pd,
 	nvidia_save_vga(par, &par->SavedReg);
 
 	pci_set_drvdata(pd, info);
-	nvidia_bl_init(par);
+
+	if (backlight)
+		nvidia_bl_init(par);
+
 	if (register_framebuffer(info) < 0) {
 		printk(KERN_ERR PFX "error registering nVidia framebuffer\n");
 		goto err_out_iounmap_fb;
@@ -1408,6 +1416,8 @@ static int __devinit nvidiafb_setup(char *options)
 			paneltweak = simple_strtoul(this_opt+11, NULL, 0);
 		} else if (!strncmp(this_opt, "vram:", 5)) {
 			vram = simple_strtoul(this_opt+5, NULL, 0);
+		} else if (!strncmp(this_opt, "backlight:", 10)) {
+			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;
diff --git a/drivers/video/riva/fbdev.c b/drivers/video/riva/fbdev.c
index f8a3d60..1d1c7c6 100644
--- a/drivers/video/riva/fbdev.c
+++ b/drivers/video/riva/fbdev.c
@@ -215,6 +215,11 @@ static int noaccel   __devinitdata = 0;
 #ifdef CONFIG_MTRR
 static int nomtrr __devinitdata = 0;
 #endif
+#ifdef CONFIG_PMAC_BACKLIGHT
+static int backlight __devinitdata = 1;
+#else
+static int backlight __devinitdata = 0;
+#endif
 
 static char *mode_option __devinitdata = NULL;
 static int  strictmode       = 0;
@@ -2059,7 +2064,10 @@ static int __devinit rivafb_probe(struct pci_dev *pd,
 	info->monspecs.modedb = NULL;
 
 	pci_set_drvdata(pd, info);
-	riva_bl_init(info->par);
+
+	if (backlight)
+		riva_bl_init(info->par);
+
 	ret = register_framebuffer(info);
 	if (ret < 0) {
 		printk(KERN_ERR PFX
@@ -2157,6 +2165,8 @@ static int __init rivafb_setup(char *options)
 				forceCRTC = -1;
 		} else if (!strncmp(this_opt, "flatpanel", 9)) {
 			flatpanel = 1;
+		} else if (!strncmp(this_opt, "backlight:", 10)) {
+			backlight = simple_strtoul(this_opt+10, NULL, 0);
 #ifdef CONFIG_MTRR
 		} else if (!strncmp(this_opt, "nomtrr", 6)) {
 			nomtrr = 1;

