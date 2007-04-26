Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbXDZREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbXDZREF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:04:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbXDZRDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:03:38 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39803 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbXDZRBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:01:44 -0400
Date: Thu, 26 Apr 2007 09:57:22 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 33/33] Revert "adjust legacy IDE resource setting (v2)"
Message-ID: <20070426165722.GH1898@kroah.com>
References: <20070426165111.393445007@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="revert-adjust-legacy-ide-resource-setting.patch"
In-Reply-To: <20070426165445.GA1898@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Revert "adjust legacy IDE resource setting (v2)"

This reverts commit ed8ccee0918ad063a4741c0656fda783e02df627.

It causes hang on boot for some users and we don't yet know why:

http://bugzilla.kernel.org/show_bug.cgi?id=7562

http://lkml.org/lkml/2007/4/20/404
http://lkml.org/lkml/2007/3/25/113

Just reverse it for 2.6.21-final, having broken X server is somehow
better than unbootable system.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |   45 +++++++++++++--------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -639,34 +639,7 @@ static void pci_read_irq(struct pci_dev 
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
@@ -719,12 +692,20 @@ static int pci_setup_device(struct pci_d
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

-- 
