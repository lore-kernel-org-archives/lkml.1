Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936397Ab0CMBV4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:21:56 -0500
Received: from kroah.org ([198.145.64.141]:60896 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934938Ab0CMAUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:22 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:11 2010
Message-Id: <20100313001510.941247308@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:44 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 066/123] pata_hpt3x2n: always stretch UltraDMA timing
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 60661933995bc7a09686c901439e17c2a4ea7d5d upstream.

The UltraDMA Tss timing must be stretched with ATA clock of 66 MHz, but the
driver only does this when PCI clock is 66 MHz, whereas it always programs
DPLL clock (which is used as the ATA clock) to 66 MHz.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/pata_hpt3x2n.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/ata/pata_hpt3x2n.c
+++ b/drivers/ata/pata_hpt3x2n.c
@@ -25,7 +25,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME	"pata_hpt3x2n"
-#define DRV_VERSION	"0.3.8"
+#define DRV_VERSION	"0.3.9"
 
 enum {
 	HPT_PCI_FAST	=	(1 << 31),
@@ -544,16 +544,16 @@ static int hpt3x2n_init_one(struct pci_d
 	       pci_mhz);
 	/* Set our private data up. We only need a few flags so we use
 	   it directly */
-	if (pci_mhz > 60) {
+	if (pci_mhz > 60)
 		hpriv = (void *)(PCI66 | USE_DPLL);
-		/*
-		 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
-		 * the MISC. register to stretch the UltraDMA Tss timing.
-		 * NOTE: This register is only writeable via I/O space.
-		 */
-		if (dev->device == PCI_DEVICE_ID_TTI_HPT371)
-			outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
-	}
+
+	/*
+	 * On  HPT371N, if ATA clock is 66 MHz we must set bit 2 in
+	 * the MISC. register to stretch the UltraDMA Tss timing.
+	 * NOTE: This register is only writeable via I/O space.
+	 */
+	if (dev->device == PCI_DEVICE_ID_TTI_HPT371)
+		outb(inb(iobase + 0x9c) | 0x04, iobase + 0x9c);
 
 	/* Now kick off ATA set up */
 	return ata_pci_sff_init_one(dev, ppi, &hpt3x2n_sht, hpriv);


