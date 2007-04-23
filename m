Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbXDWVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbXDWVWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbXDWVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:22:19 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:25644 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbXDWVWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=O7eaMTKzNV56n5tFUr+5f7eH4B/ZuFoN8I/HHGT3lqmjNsVrBIxRHgfhXxbgsrebqmpZJV0L9dAcDa44tdsutY40ghdQqT69ig8+QGYP7E4Edjnlp2+C0JPndP0iwimpAPSkFqqGTvu8tIg7G8n70f12/77q5oOkD6OzFSlNJxI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [git patch] IDE fix for 2.6.21-final (Revert "adjust legacy IDE resource setting (v2)")
Date: Mon, 23 Apr 2007 23:32:38 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, Alan Cox <alan@redhat.com>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704232332.38519.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from:

master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git/

to receive the following updates:

 drivers/pci/probe.c |   45 +++++++++++++--------------------------------
 1 files changed, 13 insertions(+), 32 deletions(-)


commit 01abc2aa0f447bce2f6beb06dd0607ba0f01c5bb
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Mon Apr 23 23:19:36 2007 +0200

    Revert "adjust legacy IDE resource setting (v2)"
    
    This reverts commit ed8ccee0918ad063a4741c0656fda783e02df627.
    
    It causes hang on boot for some users and we don't yet know why:
    
    http://bugzilla.kernel.org/show_bug.cgi?id=7562
    
    http://lkml.org/lkml/2007/4/20/404
    http://lkml.org/lkml/2007/3/25/113
    
    Just reverse it for 2.6.21-final, having broken X server is somehow
    better than unbootable system.
    
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index a4a9682..2fe1d69 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -682,34 +682,7 @@ static void pci_read_irq(struct pci_dev *dev)
 	dev->irq = irq;
 }
 
-static void change_legacy_io_resource(struct pci_dev * dev, unsigned index,
-                                      unsigned start, unsigned end)
-{
-	unsigned base = start & PCI_BASE_ADDRESS_IO_MASK;
-	unsigned len = (end | ~PCI_BASE_ADDRESS_IO_MASK) - base + 1;
-
-	/*
-	 * Some X versions get confused when the BARs reported through
-	 * /sys or /proc differ from those seen in config space, thus
-	 * try to update the config space values, too.
-	 */
-	if (!(pci_resource_flags(dev, index) & IORESOURCE_IO))
-		printk(KERN_WARNING "%s: cannot adjust BAR%u (not I/O)\n",
-		       pci_name(dev), index);
-	else if (pci_resource_len(dev, index) != len)
-		printk(KERN_WARNING "%s: cannot adjust BAR%u (size %04X)\n",
-		       pci_name(dev), index, (unsigned)pci_resource_len(dev, index));
-	else {
-		printk(KERN_INFO "%s: trying to change BAR%u from %04X to %04X\n",
-		       pci_name(dev), index,
-		       (unsigned)pci_resource_start(dev, index), base);
-		pci_write_config_dword(dev, PCI_BASE_ADDRESS_0 + index * 4, base);
-	}
-	pci_resource_start(dev, index) = start;
-	pci_resource_end(dev, index)   = end;
-	pci_resource_flags(dev, index) =
-		IORESOURCE_IO | IORESOURCE_PCI_FIXED | PCI_BASE_ADDRESS_SPACE_IO;
-}
+#define LEGACY_IO_RESOURCE	(IORESOURCE_IO | IORESOURCE_PCI_FIXED)
 
 /**
  * pci_setup_device - fill in class and map information of a device
@@ -762,12 +735,20 @@ static int pci_setup_device(struct pci_dev * dev)
 			u8 progif;
 			pci_read_config_byte(dev, PCI_CLASS_PROG, &progif);
 			if ((progif & 1) == 0) {
-				change_legacy_io_resource(dev, 0, 0x1F0, 0x1F7);
-				change_legacy_io_resource(dev, 1, 0x3F6, 0x3F6);
+				dev->resource[0].start = 0x1F0;
+				dev->resource[0].end = 0x1F7;
+				dev->resource[0].flags = LEGACY_IO_RESOURCE;
+				dev->resource[1].start = 0x3F6;
+				dev->resource[1].end = 0x3F6;
+				dev->resource[1].flags = LEGACY_IO_RESOURCE;
 			}
 			if ((progif & 4) == 0) {
-				change_legacy_io_resource(dev, 2, 0x170, 0x177);
-				change_legacy_io_resource(dev, 3, 0x376, 0x376);
+				dev->resource[2].start = 0x170;
+				dev->resource[2].end = 0x177;
+				dev->resource[2].flags = LEGACY_IO_RESOURCE;
+				dev->resource[3].start = 0x376;
+				dev->resource[3].end = 0x376;
+				dev->resource[3].flags = LEGACY_IO_RESOURCE;
 			}
 		}
 		break;
