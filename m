Return-Path: <linux-kernel-owner+w=401wt.eu-S1030283AbXAaQyF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030283AbXAaQyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:54:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030277AbXAaQyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:54:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35313 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030283AbXAaQyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:54:04 -0500
Date: Wed, 31 Jan 2007 17:06:20 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pm3fb: kill pci_find_device usage
Message-ID: <20070131170620.13d88820@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/video/pm3fb.c linux-2.6.20-rc6-mm3/drivers/video/pm3fb.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/video/pm3fb.c	2007-01-31 14:20:10.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/video/pm3fb.c	2007-01-31 14:36:25.000000000 +0000
@@ -3299,14 +3299,12 @@
 		fb_info[i].dev = NULL;
 	}
 
-	dev =
-	    pci_find_device(PCI_VENDOR_ID_3DLABS,
+	dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
 			    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
 
 	for (i = 0; ((i < PM3_MAX_BOARD) && dev); i++) {
 		dev_array[i] = dev;
-		dev =
-		    pci_find_device(PCI_VENDOR_ID_3DLABS,
+		dev = pci_get_device(PCI_VENDOR_ID_3DLABS,
 				    PCI_DEVICE_ID_3DLABS_PERMEDIA3, dev);
 	}
 
@@ -3353,7 +3351,7 @@
 	/* now, initialize... or not */
 	for (i = 0; i < PM3_MAX_BOARD; i++) {
 		l_fb_info = &(fb_info[i]);
-		if ((l_fb_info->dev) && (!disable[i])) {	/* PCI device was found and not disabled by user */
+		if (l_fb_info->dev && !disable[i]) {	/* PCI device was found and not disabled by user */
 			DPRINTK(2,
 				"found @%lx Vendor %lx Device %lx ; base @ : %lx - %lx - %lx - %lx - %lx - %lx, irq %ld\n",
 				(unsigned long) l_fb_info->dev,
@@ -3608,7 +3606,7 @@
 
 	pm3fb_init();
 
-	return (0);
+	return 0;
 }
 
 void cleanup_module(void)
@@ -3619,23 +3617,18 @@
 		struct pm3fb_info *l_fb_info;
 		for (i = 0; i < PM3_MAX_BOARD; i++) {
 			l_fb_info = &(fb_info[i]);
-			if ((l_fb_info->dev != NULL)
-			    && (!(disable[l_fb_info->board_num]))) {
-				if (l_fb_info->vIOBase !=
-				    (unsigned char *) -1) {
+			pci_dev_put(l_fb_info->dev);
+			if (l_fb_info->dev != NULL  && !(disable[l_fb_info->board_num])) {
+				if (l_fb_info->vIOBase != (unsigned char *) -1) {
 					pm3fb_unmapIO(l_fb_info);
 					release_mem_region(l_fb_info->p_fb,
-							   l_fb_info->
-							   fb_size);
-					release_mem_region(l_fb_info->
-							   pIOBase,
-							   PM3_REGS_SIZE);
+						   l_fb_info->fb_size);
+					release_mem_region(l_fb_info->pIOBase,
+						   PM3_REGS_SIZE);
 				}
-				unregister_framebuffer(&l_fb_info->gen.
-						       info);
+				unregister_framebuffer(&l_fb_info->gen.info);
 			}
 		}
 	}
-	return;
 }
 #endif /* MODULE */
