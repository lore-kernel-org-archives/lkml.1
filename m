Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYA0ERz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYA0ERz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 23:17:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753337AbYA0ERp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 23:17:45 -0500
Received: from po-out-1718.google.com ([72.14.252.156]:3829 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbYA0ERo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 23:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=d6rATuzALNGLT7y0vVpsW/tH2E330ArVf2Ztc3egQOrpZo2tolJw9AbG2Z2XFND3UIUZD1JZzOfeb8Jg6GtfCkccaT5XOpZfKOPwVziLsfJ5BWctTSPQN7GwI/bVs3avQLHTV2HzCL9RSQ1ck9tx854tErIJtsuycdTAlEfx3Gs=
Date: Sun, 27 Jan 2008 12:15:21 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: (Updated) [Patch] Shut up warnings from files under drivers/
Message-ID: <20080127041521.GC2495@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080126191717.GA25701@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Investigating a bit more I realized that gcc looses the
>__used__ attribution due to the prototype.
>So there are two correct fixes:
>a) move the function up so we do not need the forward
>   declaration
>b) add a __devexit to the forward decalration too.
>
>I strongly prefer the first version and this is the
>correct fix for these cases.
>
>Do we have a gcc bug here - I did not see a definitive answer in gcc docs?
>

Here is the updated version.

---->

Fix defined-but-not-used warnings from files under drivers/,
such as:

drivers/char/applicom.c:68: warning: ‘applicom_pci_tbl’ defined but not used

Compile tests passed.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 1f0b752..97171ad 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -65,7 +65,7 @@ static char *applicom_pci_devnames[] = {
 	"PCI2000PFB"
 };
 
-static struct pci_device_id applicom_pci_tbl[] = {
+static struct pci_device_id applicom_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCIGENERIC,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ PCI_VENDOR_ID_APPLICOM, PCI_DEVICE_ID_APPLICOM_PCI2000IBS_CAN,
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 905d1f5..ae1f565 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -897,7 +897,6 @@ static char *driver_version = "$Revision: 4.38 $";
 
 static int synclink_init_one (struct pci_dev *dev,
 				     const struct pci_device_id *ent);
-static void synclink_remove_one (struct pci_dev *dev);
 
 static struct pci_device_id synclink_pci_tbl[] = {
 	{ PCI_VENDOR_ID_MICROGATE, PCI_DEVICE_ID_MICROGATE_USC, PCI_ANY_ID, PCI_ANY_ID, },
@@ -908,6 +907,10 @@ MODULE_DEVICE_TABLE(pci, synclink_pci_tbl);
 
 MODULE_LICENSE("GPL");
 
+static void __devexit synclink_remove_one (struct pci_dev *dev)
+{
+}
+
 static struct pci_driver synclink_pci_driver = {
 	.name		= "synclink",
 	.id_table	= synclink_pci_tbl,
@@ -8166,7 +8169,3 @@ static int __devinit synclink_init_one (struct pci_dev *dev,
 	return 0;
 }
 
-static void __devexit synclink_remove_one (struct pci_dev *dev)
-{
-}
-
diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index dfbf24c..f33f82a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -2730,7 +2730,7 @@ err_out_disable_pci_device:
 	return err;
 }
 
-static void hifn_remove(struct pci_dev *pdev)
+static void __devexit hifn_remove(struct pci_dev *pdev)
 {
 	int i;
 	struct hifn_device *dev;
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..1549c0b 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -284,7 +284,7 @@ static int samplerate = 100;
 
 module_param(ixjdebug, int, 0);
 
-static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
+static struct pci_device_id ixj_pci_tbl[] __used __devinitdata = {
 	{ PCI_VENDOR_ID_QUICKNET, PCI_DEVICE_ID_QUICKNET_XJ,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
diff --git a/drivers/video/aty/aty128fb.c b/drivers/video/aty/aty128fb.c
index cbd3308..4e57fcf 100644
--- a/drivers/video/aty/aty128fb.c
+++ b/drivers/video/aty/aty128fb.c
@@ -165,7 +165,7 @@ static const char *r128_family[] __devinitdata = {
  */
 static int aty128_probe(struct pci_dev *pdev,
                                const struct pci_device_id *ent);
-static void aty128_remove(struct pci_dev *pdev);
+static void __devexit aty128_remove(struct pci_dev *pdev);
 static int aty128_pci_suspend(struct pci_dev *pdev, pm_message_t state);
 static int aty128_pci_resume(struct pci_dev *pdev);
 static int aty128_do_resume(struct pci_dev *pdev);
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
index 3ab91bf..cdedd72 100644
--- a/drivers/video/imsttfb.c
+++ b/drivers/video/imsttfb.c
@@ -400,7 +400,6 @@ static struct imstt_regvals tvp_reg_init_20 = {
  * PCI driver prototypes
  */
 static int imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void imsttfb_remove(struct pci_dev *pdev);
 
 /*
  * Register access
@@ -1328,6 +1327,21 @@ static struct pci_device_id imsttfb_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, imsttfb_pci_tbl);
 
+static void __devexit
+imsttfb_remove(struct pci_dev *pdev)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct imstt_par *par = info->par;
+	int size = pci_resource_len(pdev, 0);
+
+	unregister_framebuffer(info);
+	iounmap(par->cmap_regs);
+	iounmap(par->dc_regs);
+	iounmap(info->screen_base);
+	release_mem_region(info->fix.smem_start, size);
+	framebuffer_release(info);
+}
+
 static struct pci_driver imsttfb_pci_driver = {
 	.name =		"imsttfb",
 	.id_table =	imsttfb_pci_tbl,
@@ -1533,21 +1547,6 @@ imsttfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 }
 
-static void __devexit
-imsttfb_remove(struct pci_dev *pdev)
-{
-	struct fb_info *info = pci_get_drvdata(pdev);
-	struct imstt_par *par = info->par;
-	int size = pci_resource_len(pdev, 0);
-
-	unregister_framebuffer(info);
-	iounmap(par->cmap_regs);
-	iounmap(par->dc_regs);
-	iounmap(info->screen_base);
-	release_mem_region(info->fix.smem_start, size);
-	framebuffer_release(info);
-}
-
 #ifndef MODULE
 static int __init
 imsttfb_setup(char *options)
diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
index acb9370..6e49c7a 100644
--- a/drivers/video/kyro/fbdev.c
+++ b/drivers/video/kyro/fbdev.c
@@ -90,7 +90,6 @@ static int nomtrr __devinitdata = 0;
 
 /* PCI driver prototypes */
 static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
-static void kyrofb_remove(struct pci_dev *pdev);
 
 static struct fb_videomode kyro_modedb[] __devinitdata = {
 	{
@@ -649,6 +648,36 @@ static struct pci_device_id kyrofb_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, kyrofb_pci_tbl);
 
+static void __devexit kyrofb_remove(struct pci_dev *pdev)
+{
+	struct fb_info *info = pci_get_drvdata(pdev);
+	struct kyrofb_info *par = info->par;
+
+	/* Reset the board */
+	StopVTG(deviceInfo.pSTGReg);
+	DisableRamdacOutput(deviceInfo.pSTGReg);
+
+	/* Sync up the PLL */
+	SetCoreClockPLL(deviceInfo.pSTGReg, pdev);
+
+	deviceInfo.ulNextFreeVidMem = 0;
+	deviceInfo.ulOverlayOffset = 0;
+
+	iounmap(info->screen_base);
+	iounmap(par->regbase);
+
+#ifdef CONFIG_MTRR
+	if (par->mtrr_handle)
+		mtrr_del(par->mtrr_handle,
+			 info->fix.smem_start,
+			 info->fix.smem_len);
+#endif
+
+	unregister_framebuffer(info);
+	pci_set_drvdata(pdev, NULL);
+	framebuffer_release(info);
+}
+
 static struct pci_driver kyrofb_pci_driver = {
 	.name		= "kyrofb",
 	.id_table	= kyrofb_pci_tbl,
@@ -754,36 +783,6 @@ out_unmap:
 	return -EINVAL;
 }
 
-static void __devexit kyrofb_remove(struct pci_dev *pdev)
-{
-	struct fb_info *info = pci_get_drvdata(pdev);
-	struct kyrofb_info *par = info->par;
-
-	/* Reset the board */
-	StopVTG(deviceInfo.pSTGReg);
-	DisableRamdacOutput(deviceInfo.pSTGReg);
-
-	/* Sync up the PLL */
-	SetCoreClockPLL(deviceInfo.pSTGReg, pdev);
-
-	deviceInfo.ulNextFreeVidMem = 0;
-	deviceInfo.ulOverlayOffset = 0;
-
-	iounmap(info->screen_base);
-	iounmap(par->regbase);
-
-#ifdef CONFIG_MTRR
-	if (par->mtrr_handle)
-		mtrr_del(par->mtrr_handle,
-			 info->fix.smem_start,
-			 info->fix.smem_len);
-#endif
-
-	unregister_framebuffer(info);
-	pci_set_drvdata(pdev, NULL);
-	framebuffer_release(info);
-}
-
 static int __init kyrofb_init(void)
 {
 #ifndef MODULE
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index b481cc0..fd2dfa1 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -311,7 +311,7 @@ static int ali_notify_sys(struct notifier_block *this, unsigned long code, void
  *	want to register another driver on the same PCI id.
  */
 
-static struct pci_device_id ali_pci_tbl[] = {
+static struct pci_device_id ali_pci_tbl[] __used = {
 	{ PCI_VENDOR_ID_AL, 0x1533, PCI_ANY_ID, PCI_ANY_ID,},
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index 67aed9f..4bcae99 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -409,7 +409,7 @@ err_out:
 module_init(alim7101_wdt_init);
 module_exit(alim7101_wdt_unload);
 
-static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
+static struct pci_device_id alim7101_pci_tbl[] __used __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M7101) },
 	{ }
