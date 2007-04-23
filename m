Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbXDWN55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbXDWN55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 09:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbXDWN55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 09:57:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58428 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932AbXDWN54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 09:57:56 -0400
Date: Mon, 23 Apr 2007 15:01:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: adaplas@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Nvidia/Riva FB: Switch to pci_get refcounting APIs not
 pci_find_slot
Message-ID: <20070423150134.6fcb815e@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/video/nvidia/nv_hw.c linux-2.6.21-rc6-mm1/drivers/video/nvidia/nv_hw.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/video/nvidia/nv_hw.c	2007-04-12 13:40:47.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/video/nvidia/nv_hw.c	2007-04-23 12:16:11.636926608 +0100
@@ -686,7 +686,7 @@
 
 	if ((par->Chipset & 0x0FF0) == 0x01A0) {
 		unsigned int uMClkPostDiv;
-		dev = pci_find_slot(0, 3);
+		dev = pci_get_bus_and_slot(0, 3);
 		pci_read_config_dword(dev, 0x6C, &uMClkPostDiv);
 		uMClkPostDiv = (uMClkPostDiv >> 8) & 0xf;
 
@@ -694,11 +694,11 @@
 			uMClkPostDiv = 4;
 		MClk = 400000 / uMClkPostDiv;
 	} else {
-		dev = pci_find_slot(0, 5);
+		dev = pci_get_bus_and_slot(0, 5);
 		pci_read_config_dword(dev, 0x4c, &MClk);
 		MClk /= 1000;
 	}
-
+	
 	pll = NV_RD32(par->PRAMDAC0, 0x0500);
 	M = (pll >> 0) & 0xFF;
 	N = (pll >> 8) & 0xFF;
@@ -707,19 +707,21 @@
 	sim_data.pix_bpp = (char)pixelDepth;
 	sim_data.enable_video = 0;
 	sim_data.enable_mp = 0;
-	pci_find_slot(0, 1);
+	/* pci_find_slot(0, 1); */
 	pci_read_config_dword(dev, 0x7C, &sim_data.memory_type);
+	pci_dev_put(dev);
 	sim_data.memory_type = (sim_data.memory_type >> 12) & 1;
 	sim_data.memory_width = 64;
 
-	dev = pci_find_slot(0, 3);
+	dev = pci_get_bus_and_slot(0, 3);
 	pci_read_config_dword(dev, 0, &memctrl);
+	pci_dev_put(dev);
 	memctrl >>= 16;
 
 	if ((memctrl == 0x1A9) || (memctrl == 0x1AB) || (memctrl == 0x1ED)) {
 		int dimm[3];
 
-		pci_find_slot(0, 2);
+		/* pci_find_slot(0, 2); */
 		pci_read_config_dword(dev, 0x40, &dimm[0]);
 		dimm[0] = (dimm[0] >> 8) & 0x4f;
 		pci_read_config_dword(dev, 0x44, &dimm[1]);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/video/nvidia/nv_setup.c linux-2.6.21-rc6-mm1/drivers/video/nvidia/nv_setup.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/video/nvidia/nv_setup.c	2007-04-12 13:40:47.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/video/nvidia/nv_setup.c	2007-04-23 12:16:47.848421624 +0100
@@ -261,7 +261,7 @@
 	}
 #endif
 
-	dev = pci_find_slot(0, 1);
+	dev = pci_get_bus_and_slot(0, 1);
 	if ((par->Chipset & 0xffff) == 0x01a0) {
 		int amt = 0;
 
@@ -276,6 +276,7 @@
 		par->RamAmountKBytes =
 		    (NV_RD32(par->PFB, 0x020C) & 0xFFF00000) >> 10;
 	}
+	pci_dev_put(dev);
 
 	par->CrystalFreqKHz = (NV_RD32(par->PEXTDEV, 0x0000) & (1 << 6)) ?
 	    14318 : 13500;
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/video/riva/nv_driver.c linux-2.6.21-rc6-mm1/drivers/video/riva/nv_driver.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/video/riva/nv_driver.c	2007-04-12 13:40:47.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/video/riva/nv_driver.c	2007-04-23 12:17:38.764681176 +0100
@@ -231,12 +231,14 @@
 	case NV_ARCH_30:
 		if(chipset == NV_CHIP_IGEFORCE2) {
 
-			dev = pci_find_slot(0, 1);
+			dev = pci_get_bus_and_slot(0, 1);
 			pci_read_config_dword(dev, 0x7C, &amt);
+			pci_dev_put(dev);
 			memlen = (((amt >> 6) & 31) + 1) * 1024;
 		} else if (chipset == NV_CHIP_0x01F0) {
-			dev = pci_find_slot(0, 1);
+			dev = pci_get_bus_and_slot(0, 1);
 			pci_read_config_dword(dev, 0x84, &amt);
+			pci_dev_put(dev);
 			memlen = (((amt >> 4) & 127) + 1) * 1024;
 		} else {
 			switch ((NV_RD32(chip->PFB, 0x0000020C) >> 20) &
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc6-mm1/drivers/video/riva/riva_hw.c linux-2.6.21-rc6-mm1/drivers/video/riva/riva_hw.c
--- linux.vanilla-2.6.21-rc6-mm1/drivers/video/riva/riva_hw.c	2007-04-12 14:15:05.000000000 +0100
+++ linux-2.6.21-rc6-mm1/drivers/video/riva/riva_hw.c	2007-04-23 12:19:03.149852680 +0100
@@ -1118,8 +1118,9 @@
     unsigned int uMClkPostDiv;
     struct pci_dev *dev;
 
-    dev = pci_find_slot(0, 3);
+    dev = pci_get_bus_and_slot(0, 3);
     pci_read_config_dword(dev, 0x6C, &uMClkPostDiv);
+    pci_dev_put(dev);
     uMClkPostDiv = (uMClkPostDiv >> 8) & 0xf;
 
     if(!uMClkPostDiv) uMClkPostDiv = 4;
@@ -1132,8 +1133,9 @@
     sim_data.enable_video   = 0;
     sim_data.enable_mp      = 0;
 
-    dev = pci_find_slot(0, 1);
+    dev = pci_get_bus_and_slot(0, 1);
     pci_read_config_dword(dev, 0x7C, &sim_data.memory_type);
+    pci_dev_put(dev);
     sim_data.memory_type    = (sim_data.memory_type >> 12) & 1;
 
     sim_data.memory_width   = 64;
@@ -2112,12 +2114,14 @@
      * Fill in chip configuration.
      */
     if(chipset == NV_CHIP_IGEFORCE2) {
-        dev = pci_find_slot(0, 1);
+        dev = pci_get_bus_and_slot(0, 1);
         pci_read_config_dword(dev, 0x7C, &amt);
+        pci_dev_put(dev);
         chip->RamAmountKBytes = (((amt >> 6) & 31) + 1) * 1024;
     } else if(chipset == NV_CHIP_0x01F0) {
-        dev = pci_find_slot(0, 1);
+        dev = pci_get_bus_and_slot(0, 1);
         pci_read_config_dword(dev, 0x84, &amt);
+        pci_dev_put(dev);
         chip->RamAmountKBytes = (((amt >> 4) & 127) + 1) * 1024;
     } else {
         switch ((NV_RD32(chip->PFB, 0x0000020C) >> 20) & 0x000000FF)
