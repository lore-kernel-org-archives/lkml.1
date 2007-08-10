Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbXHJVb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbXHJVb4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 17:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750973AbXHJVbo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 17:31:44 -0400
Received: from ns2.bglans.net ([217.79.67.244]:37406 "EHLO mail.bglans.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbXHJVbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 17:31:40 -0400
Date: Sat, 11 Aug 2007 00:31:30 +0300 (EEST)
From: ivaylo@bglans.net
To: linux-kernel@vger.kernel.org
cc: w@1wt.eu
Subject: 2.4.XX ICH7 PATA UDMA Support
Message-ID: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

I have ASUS P5LD2-VM mobo with Intel ICH7 PATA IDE. It works only
in PIO mode, so I changed piix driver in 2.4.35 to support UDMA modes - 
patch is bellow.

I'm a little bit confused about the specifications of ICH7 PATA, from ASUS
say it is UDMA 100, but from Intel and in 2.6.XX kernel tree it is as UDMA 
133. My confusion became stronger and from bios ide SATA/PATA options of 
my mobo.

Anyway, the patch works for me and it should work for all mobos with 945 
chipset, but need to be tested. If there are any volunteers to apply patch 
and test it will be good.

Please report the results and play around with mobo bios SATA/PATA IDE 
setings.

Best Regards,
Ivaylo Josifov


diff -ru a/drivers/ide/pci/piix.c b/drivers/ide/pci/piix.c
--- a/drivers/ide/pci/piix.c    2007-07-26 23:53:41.000000000 +0300
+++ b/drivers/ide/pci/piix.c    2007-08-10 20:08:13.000000000 +0300
@@ -155,6 +155,7 @@
                         case PCI_DEVICE_ID_INTEL_82801E_11:
                         case PCI_DEVICE_ID_INTEL_ESB_2:
                         case PCI_DEVICE_ID_INTEL_ICH6_2:
+                       case PCI_DEVICE_ID_INTEL_ICH7_21:
                                 p += sprintf(p, "PIIX4 Ultra 100 ");
                                 break;
                         case PCI_DEVICE_ID_INTEL_82372FB_1:
@@ -294,6 +295,7 @@
                 case PCI_DEVICE_ID_INTEL_82801EB_11:
                 case PCI_DEVICE_ID_INTEL_ESB_2:
                 case PCI_DEVICE_ID_INTEL_ICH6_2:
+               case PCI_DEVICE_ID_INTEL_ICH7_21:
                         mode = 3;
                         break;
                 /* UDMA 66 capable */
@@ -683,6 +685,7 @@
                 case PCI_DEVICE_ID_INTEL_82801E_11:
                 case PCI_DEVICE_ID_INTEL_ESB_2:
                 case PCI_DEVICE_ID_INTEL_ICH6_2:
+               case PCI_DEVICE_ID_INTEL_ICH7_21:
                 {
                         unsigned int extra = 0;
                         pci_read_config_dword(dev, 0x54, &extra);
@@ -882,6 +885,7 @@
  #endif
         { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 19},
         { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 20},
+       { PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 21},
         { 0, },
  };

diff -ru a/drivers/ide/pci/piix.h b/drivers/ide/pci/piix.h
--- a/drivers/ide/pci/piix.h    2007-07-26 23:53:41.000000000 +0300
+++ b/drivers/ide/pci/piix.h    2007-08-10 20:21:02.000000000 +0300
@@ -333,6 +333,20 @@
                 .enablebits     = {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
                 .bootable       = ON_BOARD,
                 .extra          = 0,
+       },{     /* 21 */
+               .vendor         = PCI_VENDOR_ID_INTEL,
+               .device         = PCI_DEVICE_ID_INTEL_ICH7_21,
+               .name           = "ICH7",
+               .init_setup     = init_setup_piix,
+               .init_chipset   = init_chipset_piix,
+               .init_iops      = NULL,
+               .init_hwif      = init_hwif_piix,
+               .init_dma       = init_dma_piix,
+               .channels       = 1,
+               .autodma        = AUTODMA,
+               .enablebits     = {{0x41,0x80,0x80}, {0x43,0x80,0x80}},
+               .bootable       = ON_BOARD,
+               .extra          = 0,
         },{
                 .vendor         = 0,
                 .device         = 0,

diff -ru a/include/linux/pci_ids.h b/include/linux/pci_ids.h
--- a/include/linux/pci_ids.h   2007-07-26 23:53:41.000000000 +0300
+++ b/include/linux/pci_ids.h   2007-08-10 20:11:13.000000000 +0300
@@ -1978,6 +1978,7 @@
  #define PCI_DEVICE_ID_INTEL_ICH6_1     0x2641
  #define PCI_DEVICE_ID_INTEL_ICH6_2     0x266f
  #define PCI_DEVICE_ID_INTEL_ICH6_18    0x266e
+#define PCI_DEVICE_ID_INTEL_ICH7_21    0x27df
  #define PCI_DEVICE_ID_INTEL_82850_HB   0x2530
  #define PCI_DEVICE_ID_INTEL_82845G_HB  0x2560
  #define PCI_DEVICE_ID_INTEL_SMCH       0x3590

