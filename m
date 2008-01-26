Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYAZJch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYAZJch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 04:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbYAZJc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 04:32:26 -0500
Received: from qb-out-0506.google.com ([72.14.204.230]:46263 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYAZJcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 04:32:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version:content-type:content-disposition:user-agent;
        b=tupg+xr5NzDkXm/eEZdTCrPnvGJrJO+snkKMCFxoU2EkTn8wzuzzDnu9kobHWeWI75CNNB6jtzNcvjpUsUpawIiOZ/oHeVsCKfEVIgYSnsFPHu7i3vQHXqO9lkGgrIFsEa1EfTQUPwKXljkYU44oWrP8LCVGredrW4eS6qTSXxs=
Date: Sat, 26 Jan 2008 17:30:07 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080126093007.GB20935@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix two kind of defined-but-not-used warnings.

One is due to defination of MODULE_DEVICE_TABLE, the
other is due to __devexit_p. The solution is just to
add proper directives to protect those usages.

Compile tests passed.

Cc: Greg KH <gregkh@suse.de>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 1f0b752..247bc16 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -65,6 +65,7 @@ static char *applicom_pci_devnames[] = {
 	"PCI2000PFB"
 };
 
+#ifdef MODULE
 static struct pci_device_id applicom_pci_tbl[] = {
 	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
@@ -74,6 +75,8 @@ static struct pci_device_id applicom_pci_tbl[] = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ 0 }
 };
+#endif
+
 MODULE_DEVICE_TABLE(pci, applicom_pci_tbl);
 
 MODULE_AUTHOR("David Woodhouse & Applicom International");
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..2009dc9 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -897,7 +897,9 @@ static char *driver_version = "$Revision: 4.38 $";
 
 static int synclink_init_one (struct pci_dev *dev,
 				     const struct pci_device_id *ent);
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void synclink_remove_one (struct pci_dev *dev);
+#endif
 
 static struct pci_device_id synclink_pci_tbl[] = {
 	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_USC, PCI_ANY_ID, PCI_ANY_ID, },
@@ -8166,7 +8168,8 @@ static int __devinit synclink_init_one (struct pci_dev *dev,
 	return 0;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void __devexit synclink_remove_one (struct pci_dev *dev)
 {
 }
-
+#endif
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 16413e5..635f651 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2046,6 +2046,7 @@ static irqreturn_t hifn_interrupt(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void hifn_flush(struct hifn_device *dev)
 {
 	unsigned long flags;
@@ -2073,6 +2074,7 @@ static void hifn_flush(struct hifn_device *dev)
 	}
 	spin_unlock_irqrestore(&dev->lock, flags);
 }
+#endif
 
 static int hifn_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 		unsigned int len)
@@ -2730,6 +2732,7 @@ err_out_disable_pci_device:
 	return err;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void hifn_remove(struct pci_dev *pdev)
 {
 	int i;
@@ -2767,6 +2770,7 @@ static void hifn_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
+#endif
 
 static struct pci_device_id hifn_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HIFN, PCI_DEVICE_ID_HIFN_7955) },
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..1877084 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -284,11 +284,13 @@ static int samplerate = 100;
 
 module_param(ixjdebug, int, 0);
 
+#ifdef MODULE
 static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
 	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
+#endif
 
 MODULE_DEVICE_TABLE(pci, ixj_pci_tbl);
 
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index cbd3308..3a1aa7e 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -165,7 +165,9 @@ static const char *r128_family[] __devinitdata = {
  */
 static int aty128_probe(struct pci_dev *pdev,
                                const struct pci_device_id *ent);
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void aty128_remove(struct pci_dev *pdev);
+#endif
 static int aty128_pci_suspend(struct pci_dev *pdev, pm_message_t state);
 static int aty128_pci_resume(struct pci_dev *pdev);
 static int aty128_do_resume(struct pci_dev *pdev);
@@ -1844,11 +1846,14 @@ error:
 	return;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void aty128_bl_exit(struct backlight_device *bd)
 {
 	backlight_device_unregister(bd);
 	printk("aty128: Backlight unloaded\n");
 }
+#endif
+
 #endif /* CONFIG_FB_ATY128_BACKLIGHT */
 
 /*
@@ -2125,6 +2130,7 @@ err_free_fb:
 	return -ENODEV;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void __devexit aty128_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -2155,6 +2161,7 @@ static void __devexit aty128_remove(struct pci_dev *pdev)
 			   pci_resource_len(pdev, 2));
 	framebuffer_release(info);
 }
+#endif /* MODULE || CONFIG_HOTPLUG */
 #endif /* CONFIG_PCI */
 
 
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index d775eb6..eec1624 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -244,7 +244,9 @@ static int atyfb_sync(struct fb_info *info);
      */
 
 static int aty_init(struct fb_info *info);
+#if defined(CONFIG_PM) && defined(CONFIG_PCI)
 static void aty_resume_chip(struct fb_info *info);
+#endif
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2709,6 +2711,7 @@ aty_init_exit:
 	return -1;
 }
 
+#if defined(CONFIG_PM) && defined(CONFIG_PCI)
 static void aty_resume_chip(struct fb_info *info)
 {
 	struct atyfb_par *par = info->par;
@@ -2721,6 +2724,7 @@ static void aty_resume_chip(struct fb_info *info)
 	if (par->aux_start)
 		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
 }
+#endif
 
 #ifdef CONFIG_ATARI
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
diff --git a/drivers/video/imsttfb.c b/drivers/video/imsttfb.c
index 3ab91bf..d0c023d 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -400,7 +400,9 @@ static struct imstt_regvals tvp_reg_init_20 = {
  * PCI driver prototypes
  */
 static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void imsttfb_remove(struct pci_dev *pdev);
+#endif
 
 /*
  * Register access
@@ -1533,6 +1535,7 @@ imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void __devexit
 imsttfb_remove(struct pci_dev *pdev)
 {
@@ -1547,6 +1550,7 @@ imsttfb_remove(struct pci_dev *pdev)
 	release_mem_region(info->fix.smem_start, size);
 	framebuffer_release(info);
 }
+#endif
 
 #ifndef MODULE
 static int __init
diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index acb9370..437ebd0 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -90,7 +90,9 @@ static int nomtrr __devinitdata = 0;
 
 /* PCI driver prototypes */
 static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void kyrofb_remove(struct pci_dev *pdev);
+#endif
 
 static struct fb_videomode kyro_modedb[] __devinitdata = {
 	{
@@ -754,6 +756,7 @@ out_unmap:
 	return -EINVAL;
 }
 
+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
 static void __devexit kyrofb_remove(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -783,6 +786,7 @@ static void __devexit kyrofb_remove(struct pci_dev *pdev)
 	pci_set_drvdata(pdev, NULL);
 	framebuffer_release(info);
 }
+#endif
 
 static int __init kyrofb_init(void)
 {
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index b481cc0..05ddf80 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -311,11 +311,13 @@ static int ali_notify_sys(struct notifier_block *this, unsigned long code, void
  *	want to register another driver on the same PCI id.
  */
 
+#ifdef MODULE
 static struct pci_device_id ali_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
+#endif
 MODULE_DEVICE_TABLE(pci, ali_pci_tbl);
 
 /*
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 67aed9f..401eead 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -409,11 +409,13 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
+#ifdef MODULE
 static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
 };
+#endif
 
 MODULE_DEVICE_TABLE(pci, alim7101_pci_tbl);
 
