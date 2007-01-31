Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXAaQ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXAaQ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:58:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932951AbXAaQ6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:58:40 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35317 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932950AbXAaQ6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:58:39 -0500
Date: Wed, 31 Jan 2007 17:10:46 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: [PATCH] pata_atiixp: propogate cable detection hack from
 drivers/ide to the new driver
Message-ID: <20070131171046.075946d7@localhost.localdomain>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_atiixp.c linux-2.6.20-rc6-mm3/drivers/ata/pata_atiixp.c
--- linux.vanilla-2.6.20-rc6-mm3/drivers/ata/pata_atiixp.c	2007-01-31 14:20:10.000000000 +0000
+++ linux-2.6.20-rc6-mm3/drivers/ata/pata_atiixp.c	2007-01-31 15:05:11.000000000 +0000
@@ -36,15 +36,22 @@
 static int atiixp_pre_reset(struct ata_port *ap)
 {
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-	static struct pci_bits atiixp_enable_bits[] = {
+	static const struct pci_bits atiixp_enable_bits[] = {
 		{ 0x48, 1, 0x01, 0x00 },
 		{ 0x48, 1, 0x08, 0x00 }
 	};
+	u8 udma;
 
 	if (!pci_test_config_bits(pdev, &atiixp_enable_bits[ap->port_no]))
 		return -ENOENT;
 
-	ap->cbl = ATA_CBL_PATA80;
+	/* Hack from drivers/ide/pci. Really we want to know how to do the
+	   raw detection not play follow the bios mode guess */
+	pci_read_config_byte(pdev, ATIIXP_IDE_UDMA_MODE + ap->port_no, &udma);
+	if ((udma & 0x07) >= 0x04 || (udma & 0x70) >= 0x40)
+		ap->cbl = ATA_CBL_PATA80;
+	else
+		ap->cbl = ATA_CBL_PATA40;
 	return ata_std_prereset(ap);
 }
 
