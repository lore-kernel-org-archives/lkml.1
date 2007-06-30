Return-Path: <linux-kernel-owner+w=401wt.eu-S1753948AbXF3DOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948AbXF3DOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 23:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbXF3DOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 23:14:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:63907 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbXF3DOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 23:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=a1eQi4suJ2lEf4yY5m2G78xbriaF4gcuKhTGsl0zpb6PWxr170A1xkxmERQwWUpLQPL2XWwArwDXAYILj9D08qGKfWMXcF3lYBWSyeOH4YBkLrXZoLawRbQZmzZ/CDWpXGMDy4RPRgjL8mNIAJvmAywTs5Io2ONtOeum+OMl4O0=
Date: Sat, 30 Jun 2007 12:05:16 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] void unregister_chrdev - ignore the return value
Message-ID: <20070630030516.GA4045@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

register_chrdev() always returns 0.
There is no need to check the return value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 arch/cris/arch-v10/drivers/pcf8563.c |    4 +---
 arch/cris/arch-v32/drivers/pcf8563.c |    4 +---
 arch/sparc64/solaris/socksys.c       |    3 +--
 drivers/block/acsi_slm.c             |    3 +--
 drivers/char/ip2/ip2main.c           |    4 +---
 drivers/char/mbcs.c                  |    7 +------
 drivers/char/stallion.c              |    5 +----
 drivers/char/viotape.c               |    7 +------
 drivers/net/ppp_generic.c            |    3 +--
 sound/core/sound.c                   |    3 +--
 10 files changed, 10 insertions(+), 33 deletions(-)

Index: 2.6-mm/drivers/net/ppp_generic.c
===================================================================
--- 2.6-mm.orig/drivers/net/ppp_generic.c
+++ 2.6-mm/drivers/net/ppp_generic.c
@@ -2684,8 +2684,7 @@ static void __exit ppp_cleanup(void)
 	if (atomic_read(&ppp_unit_count) || atomic_read(&channel_count))
 		printk(KERN_ERR "PPP: removing module but units remain!\n");
 	cardmap_destroy(&all_ppp_units);
-	if (unregister_chrdev(PPP_MAJOR, "ppp") != 0)
-		printk(KERN_ERR "PPP: failed to unregister PPP device\n");
+	unregister_chrdev(PPP_MAJOR, "ppp");
 	device_destroy(ppp_class, MKDEV(PPP_MAJOR, 0));
 	class_destroy(ppp_class);
 }
Index: 2.6-mm/drivers/char/ip2/ip2main.c
===================================================================
--- 2.6-mm.orig/drivers/char/ip2/ip2main.c
+++ 2.6-mm/drivers/char/ip2/ip2main.c
@@ -425,9 +425,7 @@ cleanup_module(void)
 		printk(KERN_ERR "IP2: failed to unregister tty driver (%d)\n", err);
 	}
 	put_tty_driver(ip2_tty_driver);
-	if ( ( err = unregister_chrdev ( IP2_IPL_MAJOR, pcIpl ) ) ) {
-		printk(KERN_ERR "IP2: failed to unregister IPL driver (%d)\n", err);
-	}
+	unregister_chrdev(IP2_IPL_MAJOR, pcIpl);
 	remove_proc_entry("ip2mem", &proc_root);
 
 	// free memory
Index: 2.6-mm/sound/core/sound.c
===================================================================
--- 2.6-mm.orig/sound/core/sound.c
+++ 2.6-mm/sound/core/sound.c
@@ -451,8 +451,7 @@ static void __exit alsa_sound_exit(void)
 {
 	snd_info_minor_unregister();
 	snd_info_done();
-	if (unregister_chrdev(major, "alsa") != 0)
-		snd_printk(KERN_ERR "unable to unregister major device number %d\n", major);
+	unregister_chrdev(major, "alsa");
 }
 
 module_init(alsa_sound_init)
Index: 2.6-mm/drivers/block/acsi_slm.c
===================================================================
--- 2.6-mm.orig/drivers/block/acsi_slm.c
+++ 2.6-mm/drivers/block/acsi_slm.c
@@ -1025,8 +1025,7 @@ int init_module(void)
 
 void cleanup_module(void)
 {
-	if (unregister_chrdev( ACSI_MAJOR, "slm" ) != 0)
-		printk( KERN_ERR "acsi_slm: cleanup_module failed\n");
+	unregister_chrdev(ACSI_MAJOR, "slm");
 	atari_stram_free( SLMBuffer );
 }
 #endif
Index: 2.6-mm/drivers/char/stallion.c
===================================================================
--- 2.6-mm.orig/drivers/char/stallion.c
+++ 2.6-mm/drivers/char/stallion.c
@@ -4797,7 +4797,6 @@ static void __exit stallion_module_exit(
 {
 	struct stlbrd *brdp;
 	unsigned int i, j;
-	int retval;
 
 	pr_debug("cleanup_module()\n");
 
@@ -4820,9 +4819,7 @@ static void __exit stallion_module_exit(
 
 	for (i = 0; i < 4; i++)
 		class_device_destroy(stallion_class, MKDEV(STL_SIOMEMMAJOR, i));
-	if ((retval = unregister_chrdev(STL_SIOMEMMAJOR, "staliomem")))
-		printk("STALLION: failed to un-register serial memory device, "
-			"errno=%d\n", -retval);
+	unregister_chrdev(STL_SIOMEMMAJOR, "staliomem");
 	class_destroy(stallion_class);
 
 	pci_unregister_driver(&stl_pcidriver);
Index: 2.6-mm/arch/cris/arch-v10/drivers/pcf8563.c
===================================================================
--- 2.6-mm.orig/arch/cris/arch-v10/drivers/pcf8563.c
+++ 2.6-mm/arch/cris/arch-v10/drivers/pcf8563.c
@@ -180,9 +180,7 @@ err:
 void __exit
 pcf8563_exit(void)
 {
-	if (unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME) < 0) {
-		printk(KERN_INFO "%s: Unable to unregister device.\n", PCF8563_NAME);
-	}
+	unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME);
 }
 
 /*
Index: 2.6-mm/arch/sparc64/solaris/socksys.c
===================================================================
--- 2.6-mm.orig/arch/sparc64/solaris/socksys.c
+++ 2.6-mm/arch/sparc64/solaris/socksys.c
@@ -199,6 +199,5 @@ int __init init_socksys(void)
 
 void __exit cleanup_socksys(void)
 {
-	if (unregister_chrdev(30, "socksys"))
-		printk ("Couldn't unregister socksys character device\n");
+	unregister_chrdev(30, "socksys");
 }
Index: 2.6-mm/arch/cris/arch-v32/drivers/pcf8563.c
===================================================================
--- 2.6-mm.orig/arch/cris/arch-v32/drivers/pcf8563.c
+++ 2.6-mm/arch/cris/arch-v32/drivers/pcf8563.c
@@ -193,9 +193,7 @@ err:
 void __exit
 pcf8563_exit(void)
 {
-	if (unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME) < 0) {
-		printk(KERN_INFO "%s: Unable to unregister device.\n", PCF8563_NAME);
-	}
+	unregister_chrdev(PCF8563_MAJOR, DEVICE_NAME);
 }
 
 /*
Index: 2.6-mm/drivers/char/mbcs.c
===================================================================
--- 2.6-mm.orig/drivers/char/mbcs.c
+++ 2.6-mm/drivers/char/mbcs.c
@@ -817,12 +817,7 @@ struct cx_drv mbcs_driver = {
 
 static void __exit mbcs_exit(void)
 {
-	int rv;
-
-	rv = unregister_chrdev(mbcs_major, DEVICE_NAME);
-	if (rv < 0)
-		DBG(KERN_ALERT "Error in unregister_chrdev: %d\n", rv);
-
+	unregister_chrdev(mbcs_major, DEVICE_NAME);
 	cx_driver_unregister(&mbcs_driver);
 }
 
Index: 2.6-mm/drivers/char/viotape.c
===================================================================
--- 2.6-mm.orig/drivers/char/viotape.c
+++ 2.6-mm/drivers/char/viotape.c
@@ -1098,15 +1098,10 @@ static int chg_state(int index, unsigned
 /* Cleanup */
 static void __exit viotap_exit(void)
 {
-	int ret;
-
 	remove_proc_entry("iSeries/viotape", NULL);
 	vio_unregister_driver(&viotape_driver);
 	class_destroy(tape_class);
-	ret = unregister_chrdev(VIOTAPE_MAJOR, "viotape");
-	if (ret < 0)
-		printk(VIOTAPE_KERN_WARN "Error unregistering device: %d\n",
-				ret);
+	unregister_chrdev(VIOTAPE_MAJOR, "viotape");
 	if (viotape_unitinfo)
 		dma_free_coherent(iSeries_vio_dev,
 				sizeof(viotape_unitinfo[0]) * VIOTAPE_MAX_TAPE,
