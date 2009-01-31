Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZAaCt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZAaCt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 21:49:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZAaCqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 21:46:43 -0500
Received: from kroah.org ([198.145.64.141]:54794 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753463AbZAaCql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 21:46:41 -0500
Date: Fri, 30 Jan 2009 18:39:59 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Brandon Philips <bphilips@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [patch 09/32] it821x: Add ultra_mask quirk for Vortex86SX
Message-ID: <20090131023959.GJ12147@kroah.com>
References: <20090131023411.032399235@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="it821x-add-ultra_mask-quirk-for-vortex86sx.patch"
In-Reply-To: <20090131023906.GA12147@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brandon Philips <brandon@ifup.org>

commit b94b898f3107046b5c97c556e23529283ea5eadd upstream.

On Vortex86SX with IDE controller revision 0x11 ultra DMA must be
disabled. This patch was tested by DMP and seems to work.

It is a cleaned up version of their older Kernel patch:
 http://www.dmp.com.tw/tech/vortex86sx/patch-2.6.24-DMP.gz

Tested-by: Shawn Lin <shawn@dmp.com.tw>
Signed-off-by: Brandon Philips <bphilips@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/pci/it821x.c |   12 ++++++++++++
 include/linux/pci_ids.h  |    1 +
 2 files changed, 13 insertions(+)

--- a/drivers/ide/pci/it821x.c
+++ b/drivers/ide/pci/it821x.c
@@ -69,6 +69,8 @@
 
 #define DRV_NAME "it821x"
 
+#define QUIRK_VORTEX86 1
+
 struct it821x_dev
 {
 	unsigned int smart:1,		/* Are we in smart raid mode */
@@ -80,6 +82,7 @@ struct it821x_dev
 	u16	pio[2];			/* Cached PIO values */
 	u16	mwdma[2];		/* Cached MWDMA values */
 	u16	udma[2];		/* Cached UDMA values (per drive) */
+	u16	quirks;
 };
 
 #define ATA_66		0
@@ -586,6 +589,12 @@ static void __devinit init_hwif_it821x(i
 
 	hwif->ultra_mask = ATA_UDMA6;
 	hwif->mwdma_mask = ATA_MWDMA2;
+
+	/* Vortex86SX quirk: prevent Ultra-DMA mode to fix BadCRC issue */
+	if (idev->quirks & QUIRK_VORTEX86) {
+		if (dev->revision == 0x11)
+			hwif->ultra_mask = 0;
+	}
 }
 
 static void __devinit it8212_disable_raid(struct pci_dev *dev)
@@ -658,6 +667,8 @@ static int __devinit it821x_init_one(str
 		return -ENOMEM;
 	}
 
+	itdevs->quirks = id->driver_data;
+
 	rc = ide_pci_init_one(dev, &it821x_chipset, itdevs);
 	if (rc)
 		kfree(itdevs);
@@ -677,6 +688,7 @@ static void __devexit it821x_remove(stru
 static const struct pci_device_id it821x_pci_tbl[] = {
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8211), 0 },
 	{ PCI_VDEVICE(ITE, PCI_DEVICE_ID_ITE_8212), 0 },
+	{ PCI_VDEVICE(RDC, PCI_DEVICE_ID_RDC_D1010), QUIRK_VORTEX86 },
 	{ 0, },
 };
 
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2148,6 +2148,7 @@
 #define PCI_DEVICE_ID_RDC_R6040		0x6040
 #define PCI_DEVICE_ID_RDC_R6060		0x6060
 #define PCI_DEVICE_ID_RDC_R6061		0x6061
+#define PCI_DEVICE_ID_RDC_D1010		0x1010
 
 #define PCI_VENDOR_ID_LENOVO		0x17aa
 

