Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYA1FwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYA1FwV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 00:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750777AbYA1FwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 00:52:12 -0500
Received: from po-out-1718.google.com ([72.14.252.157]:2364 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYA1FwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 00:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent;
        b=KN3XZgJvjfolPzTt7G1ZWnGWVq+lHAayg+wZxf/uDN1duEkxdn0w0cBZmtziSOD46n8OpMNTukRAKvSrRyizVkMmnlWCmZ/xcQJW/cyTsgzlzwqysHITHQvt1fTO6UnitRPBp9WF7ZCXWCNKPyv99nAEpMJXWkEJSOekJE84Lb8=
Date: Mon, 28 Jan 2008 13:49:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: (Try#3) [Patch] Shut up warnings from files under drivers/
Message-ID: <20080128054917.GA10504@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org> <20080127041521.GC2495@hacking> <20080127092100.GA18116@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080127092100.GA18116@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2008 at 10:21:00AM +0100, Sam Ravnborg wrote:
>Hi WANG.
>
>Thanks for chasing these annoying warnings - it is
>good to keep the warning level low so we keep
>attention when new warnings happens!
>
>> index d775eb6..eec1624 100644
>> --- a/drivers/video/aty/atyfb_base.c
>> +++ b/drivers/video/aty/atyfb_base.c
>> @@ -244,7 +244,9 @@ static int atyfb_sync(struct fb_info *info);
>>       */
>>  
>>  static int aty_init(struct fb_info *info);
>> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>>  static void aty_resume_chip(struct fb_info *info);
>> +#endif
>
>It is preferable to have the forward declaration unconditional
>to keep the #if/#endif count low.
>
>
>>  #endif
>> @@ -2709,6 +2711,7 @@ aty_init_exit:
>>  	return -1;
>>  }
>>  
>> +#if defined(CONFIG_PM) && defined(CONFIG_PCI)
>>  static void aty_resume_chip(struct fb_info *info)
>>  {
>>  	struct atyfb_par *par = info->par;
>> @@ -2721,6 +2724,7 @@ static void aty_resume_chip(struct fb_info *info)
>>  	if (par->aux_start)
>>  		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
>>  }
>> +#endif
>
>Moving the aty_resume_chip() function down just above
>atyfb_pci_resume() would put in in the same #if/#endif
>block and you can kill the forward declaration too.
>Did you try that out?

Yes, it works.

Here's the updated patch, and I dropped the drivers/char/applicom.c
part as Jiri Slaby has better fix.

------->

Fix defined-but-not-used warnings from files under drivers/,
such as:

drivers/video/aty/atyfb_base.c:2713: warning: ‘aty_resume_chip’ defined but not used

Compile tests passed.

Cc: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---

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
index d775eb6..3829f3e 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -244,7 +244,6 @@ static int atyfb_sync(struct fb_info *info);
      */
 
 static int aty_init(struct fb_info *info);
-static void aty_resume_chip(struct fb_info *info);
 #ifdef CONFIG_ATARI
 static int store_video_par(char *videopar, unsigned char m64_num);
 #endif
@@ -2076,6 +2075,20 @@ static int atyfb_pci_suspend(struct pci_dev *pdev, pm_message_t state)
 	return 0;
 }
 
+static void aty_resume_chip(struct fb_info *info)
+{
+	struct atyfb_par *par = info->par;
+
+	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
+
+	if (par->pll_ops->resume_pll)
+		par->pll_ops->resume_pll(info, &par->pll);
+
+	if (par->aux_start)
+		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
+}
+
+
 static int atyfb_pci_resume(struct pci_dev *pdev)
 {
 	struct fb_info *info = pci_get_drvdata(pdev);
@@ -2709,19 +2722,6 @@ aty_init_exit:
 	return -1;
 }
 
-static void aty_resume_chip(struct fb_info *info)
-{
-	struct atyfb_par *par = info->par;
-
-	aty_st_le32(MEM_CNTL, par->mem_cntl, par);
-
-	if (par->pll_ops->resume_pll)
-		par->pll_ops->resume_pll(info, &par->pll);
-
-	if (par->aux_start)
-		aty_st_le32(BUS_CNTL, aty_ld_le32(BUS_CNTL, par) | BUS_APER_REG_DIS, par);
-}
-
 #ifdef CONFIG_ATARI
 static int __devinit store_video_par(char *video_str, unsigned char m64_num)
 {
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
