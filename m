Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbXKEHVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbXKEHVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 02:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbXKEHVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 02:21:14 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:42733 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbXKEHVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 02:21:13 -0500
Subject: [PATCH 2/2 -mm] sisusb: *_ioctl32_conversion functions do not
	exist in recent kernels
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: thomas@winischhofer.net, akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 05 Nov 2007 16:21:11 +0900
Message-Id: <1194247271.13121.33.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove dead code while at it.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.24-rc1-git13-orig/drivers/video/sis/sis.h linux-2.6.24-rc1-git13/drivers/video/sis/sis.h
--- linux-2.6.24-rc1-git13-orig/drivers/video/sis/sis.h	2007-10-10 05:31:38.000000000 +0900
+++ linux-2.6.24-rc1-git13/drivers/video/sis/sis.h	2007-11-05 15:24:15.000000000 +0900
@@ -39,12 +39,7 @@
 #include <linux/spinlock.h>
 
 #ifdef CONFIG_COMPAT
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,10)
-#include <linux/ioctl32.h>
-#define SIS_OLD_CONFIG_COMPAT
-#else
 #define SIS_NEW_CONFIG_COMPAT
-#endif
 #endif	/* CONFIG_COMPAT */
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,6,8)
@@ -607,9 +602,6 @@ struct sis_video_info {
 	int		haveXGIROM;
 	int		registered;
 	int		warncount;
-#ifdef SIS_OLD_CONFIG_COMPAT
-	int		ioctl32registered;
-#endif
 
 	int		sisvga_engine;
 	int		hwcursor_size;
diff -urNp linux-2.6.24-rc1-git13-orig/drivers/video/sis/sis_main.c linux-2.6.24-rc1-git13/drivers/video/sis/sis_main.c
--- linux-2.6.24-rc1-git13-orig/drivers/video/sis/sis_main.c	2007-11-05 10:22:15.000000000 +0900
+++ linux-2.6.24-rc1-git13/drivers/video/sis/sis_main.c	2007-11-05 15:25:47.000000000 +0900
@@ -5804,9 +5804,6 @@ sisfb_probe(struct pci_dev *pdev, const 
 	ivideo->pcifunc = PCI_FUNC(pdev->devfn);
 	ivideo->subsysvendor = pdev->subsystem_vendor;
 	ivideo->subsysdevice = pdev->subsystem_device;
-#ifdef SIS_OLD_CONFIG_COMPAT
-	ivideo->ioctl32registered = 0;
-#endif
 
 #ifndef MODULE
 	if(sisfb_mode_idx == -1) {
@@ -6419,30 +6416,6 @@ error_3:	vfree(ivideo->bios_abase);
 		ivideo->next = card_list;
 		card_list = ivideo;
 
-#ifdef SIS_OLD_CONFIG_COMPAT
-		{
-		int ret;
-		/* Our ioctls are all "32/64bit compatible" */
-		ret =  register_ioctl32_conversion(FBIO_ALLOC,             NULL);
-		ret |= register_ioctl32_conversion(FBIO_FREE,              NULL);
-		ret |= register_ioctl32_conversion(FBIOGET_VBLANK,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_INFO_SIZE,    NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_INFO,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_TVPOSOFFSET,  NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_TVPOSOFFSET,  NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_LOCK,         NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_VBRSTATUS,    NULL);
-		ret |= register_ioctl32_conversion(SISFB_GET_AUTOMAXIMIZE, NULL);
-		ret |= register_ioctl32_conversion(SISFB_SET_AUTOMAXIMIZE, NULL);
-		ret |= register_ioctl32_conversion(SISFB_COMMAND,          NULL);
-		if(ret)
-			printk(KERN_ERR
-				"sisfb: Error registering ioctl32 translations\n");
-		else
-			ivideo->ioctl32registered = 1;
-		}
-#endif
-
 		printk(KERN_INFO "sisfb: 2D acceleration is %s, y-panning %s\n",
 			ivideo->sisfb_accel ? "enabled" : "disabled",
 			ivideo->sisfb_ypan  ?
@@ -6472,27 +6445,6 @@ static void __devexit sisfb_remove(struc
 	int			registered = ivideo->registered;
 	int			modechanged = ivideo->modechanged;
 
-#ifdef SIS_OLD_CONFIG_COMPAT
-	if(ivideo->ioctl32registered) {
-		int ret;
-		ret =  unregister_ioctl32_conversion(FBIO_ALLOC);
-		ret |= unregister_ioctl32_conversion(FBIO_FREE);
-		ret |= unregister_ioctl32_conversion(FBIOGET_VBLANK);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_INFO_SIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_INFO);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_TVPOSOFFSET);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_TVPOSOFFSET);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_LOCK);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_VBRSTATUS);
-		ret |= unregister_ioctl32_conversion(SISFB_GET_AUTOMAXIMIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_SET_AUTOMAXIMIZE);
-		ret |= unregister_ioctl32_conversion(SISFB_COMMAND);
-		if(ret)
-			printk(KERN_ERR
-			     "sisfb: Error unregistering ioctl32 translations\n");
-	}
-#endif
-
 	/* Unmap */
 	iounmap(ivideo->mmio_vbase);
 	iounmap(ivideo->video_vbase);


