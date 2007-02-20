Return-Path: <linux-kernel-owner+w=401wt.eu-S1030262AbXBTQp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030262AbXBTQp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 11:45:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030256AbXBTQp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 11:45:56 -0500
Received: from [81.2.110.250] ([81.2.110.250]:46867 "EHLO lxorguk.ukuu.org.uk"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030241AbXBTQpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 11:45:55 -0500
Date: Tue, 20 Feb 2007 17:49:25 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: jgarzik@pobox.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_sil680: Assorted fixes
Message-ID: <20070220174925.227a7b4d@localhost.localdomain>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Correct iordy handling and DMA bit flag handling.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-mm2/drivers/ata/pata_sil680.c linux-2.6.20-mm2/drivers/ata/pata_sil680.c
--- linux.vanilla-2.6.20-mm2/drivers/ata/pata_sil680.c	2007-02-20 13:37:58.000000000 +0000
+++ linux-2.6.20-mm2/drivers/ata/pata_sil680.c	2007-02-20 13:56:39.000000000 +0000
@@ -33,7 +33,7 @@
 #include <linux/libata.h>
 
 #define DRV_NAME "pata_sil680"
-#define DRV_VERSION "0.4.1"
+#define DRV_VERSION "0.4.5"
 
 /**
  *	sil680_selreg		-	return register base
@@ -139,10 +139,13 @@
 
 	unsigned long tfaddr = sil680_selreg(ap, 0x02);
 	unsigned long addr = sil680_seldev(ap, adev, 0x04);
+	unsigned long addr_mask = 0x80 + 4 * ap->port_no;
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int pio = adev->pio_mode - XFER_PIO_0;
 	int lowest_pio = pio;
+	int port_shift = 4 * adev->devno;
 	u16 reg;
+	u8 mode;
 
 	struct ata_device *pair = ata_dev_pair(adev);
 
@@ -153,10 +156,17 @@
 	pci_write_config_word(pdev, tfaddr, speed_t[lowest_pio]);
 
 	pci_read_config_word(pdev, tfaddr-2, &reg);
+	pci_read_config_byte(pdev, addr_mask, &mode);
+	
 	reg &= ~0x0200;			/* Clear IORDY */
-	if (ata_pio_need_iordy(adev))
+	mode &= ~(3 << port_shift);	/* Clear IORDY and DMA bits */
+	
+	if (ata_pio_need_iordy(adev)) {
 		reg |= 0x0200;		/* Enable IORDY */
+		mode |= 1 << port_shift;
+	}
 	pci_write_config_word(pdev, tfaddr-2, reg);
+	pci_write_config_byte(pdev, addr_mask, mode);
 }
 
 /**
