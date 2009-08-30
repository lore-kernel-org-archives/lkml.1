Return-Path: <linux-kernel-owner+w=401wt.eu-S1753514AbZH3M6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbZH3M6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Aug 2009 08:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZH3M6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Aug 2009 08:58:33 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:62832 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448AbZH3M6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Aug 2009 08:58:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=mvWsnqqR0C6aPuKXTNCk+PR9p6VLs7iVx83PCgnBulWdm/7BeIu5tRHv/5x0yXl5FH
         ffZwQ0cZf5QDQ9U4FjATVpiYfLVBHjAveV97RN09Pjph3iSOQhpc+U+srDcJn6V8idUl
         zkq6Hyt0NNGILvz1x3fvtrXYQc31956YeH+NA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] ata_piix: parallel scanning on PATA needs an extra locking
Date: Sun, 30 Aug 2009 14:56:30 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc8-00015-gadda766-dirty; KDE/4.3.0; i686; ; )
Cc: Arjan van de Ven <arjan@linux.intel.com>, Alan Cox <alan@linux.intel.com>,
       Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200908301456.30132.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This one is quite late but it fixes rather nasty 2.6.31 regression..


From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ata_piix: parallel scanning on PATA needs an extra locking

Commit log for commit 517d3cc15b36392e518abab6bacbb72089658313
("[libata] ata_piix: Enable parallel scan") says:

    This patch turns on parallel scanning for the ata_piix driver.
    This driver is used on most netbooks (no AHCI for cheap storage it seems).
    The scan is the dominating time factor in the kernel boot for these
    devices; with this flag it gets cut in half for the device I used
    for testing (eeepc).
    Alan took a look at the driver source and concluded that it ought to be safe
    to do for this driver.  Alan has also checked with the hardware team.

and it is all true but once we put all things together additional
constraints for PATA controllers show up (some hardware registers
have per-host not per-port atomicity) and we risk misprogramming
the controller.

I used the following test to check whether the issue is real:

@@ -736,8 +736,20 @@ static void piix_set_piomode(struct ata_
 			(timings[pio][1] << 8);
 	}
 	pci_write_config_word(dev, master_port, master_data);
-	if (is_slave)
+	if (is_slave) {
+		if (ap->port_no == 0) {
+			u8 tmp = slave_data;
+
+			while (slave_data == tmp) {
+				pci_read_config_byte(dev, slave_port, &tmp);
+				msleep(50);
+			}
+
+			dev_printk(KERN_ERR, &dev->dev, "PATA parallel scan "
+				   "race detected\n");
+		}
 		pci_write_config_byte(dev, slave_port, slave_data);
+	}
 
 	/* Ensure the UDMA bit is off - it will be turned back on if
 	   UDMA is selected */

and it indeed triggered the error message.

Lets fix all such races by adding an extra locking to ->set_piomode
and ->set_dmamode methods for PATA controllers.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/ata_piix.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: b/drivers/ata/ata_piix.c
===================================================================
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -664,6 +664,8 @@ static int piix_pata_prereset(struct ata
 	return ata_sff_prereset(link, deadline);
 }
 
+static DEFINE_SPINLOCK(piix_lock);
+
 /**
  *	piix_set_piomode - Initialize host controller PATA PIO timings
  *	@ap: Port whose timings we are configuring
@@ -677,8 +679,9 @@ static int piix_pata_prereset(struct ata
 
 static void piix_set_piomode(struct ata_port *ap, struct ata_device *adev)
 {
-	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
+	unsigned int pio	= adev->pio_mode - XFER_PIO_0;
 	unsigned int is_slave	= (adev->devno != 0);
 	unsigned int master_port= ap->port_no ? 0x42 : 0x40;
 	unsigned int slave_port	= 0x44;
@@ -708,6 +711,8 @@ static void piix_set_piomode(struct ata_
 	if (adev->class == ATA_DEV_ATA)
 		control |= 4;	/* PPE enable */
 
+	spin_lock_irqsave(&piix_lock, flags);
+
 	/* PIO configuration clears DTE unconditionally.  It will be
 	 * programmed in set_dmamode which is guaranteed to be called
 	 * after set_piomode if any DMA mode is available.
@@ -747,6 +752,8 @@ static void piix_set_piomode(struct ata_
 		udma_enable &= ~(1 << (2 * ap->port_no + adev->devno));
 		pci_write_config_byte(dev, 0x48, udma_enable);
 	}
+
+	spin_unlock_irqrestore(&piix_lock, flags);
 }
 
 /**
@@ -764,6 +771,7 @@ static void piix_set_piomode(struct ata_
 static void do_pata_set_dmamode(struct ata_port *ap, struct ata_device *adev, int isich)
 {
 	struct pci_dev *dev	= to_pci_dev(ap->host->dev);
+	unsigned long flags;
 	u8 master_port		= ap->port_no ? 0x42 : 0x40;
 	u16 master_data;
 	u8 speed		= adev->dma_mode;
@@ -777,6 +785,8 @@ static void do_pata_set_dmamode(struct a
 			    { 2, 1 },
 			    { 2, 3 }, };
 
+	spin_lock_irqsave(&piix_lock, flags);
+
 	pci_read_config_word(dev, master_port, &master_data);
 	if (ap->udma_mask)
 		pci_read_config_byte(dev, 0x48, &udma_enable);
@@ -867,6 +877,8 @@ static void do_pata_set_dmamode(struct a
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)
 		pci_write_config_byte(dev, 0x48, udma_enable);
+
+	spin_unlock_irqrestore(&piix_lock, flags);
 }
 
 /**
