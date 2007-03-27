Return-Path: <linux-kernel-owner+w=401wt.eu-S1753775AbXC0KdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbXC0KdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 06:33:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbXC0KdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 06:33:11 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:48461 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776AbXC0KdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 06:33:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=r8x6zuw1YoRMDJvNiQOw2+JMj1a0Yt/37QPHgPS58PfYfB7WDe8g9+G5UWluTfLLfmT2QEKSiMLQ6ffFIm8cvi5MyvWPLCY0eRAHFAF2jNfoSx2tVUkh6Pd85PE474V2SuvHY/IVG/Cz/1/M7uHUhgM8IP5c+94yN409X+UO+Es=
Message-ID: <5767b9100703270333k71361b89n756281124fd78c80@mail.gmail.com>
Date: Tue, 27 Mar 2007 18:33:05 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Tejun Heo" <htejun@gmail.com>
Subject: [PATCH] ahci.c: walkaround for SB600 SATA internal error issue
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

   There is a HW issue in ATI SB600 SATA that PxSERR.E should not be
set on some conditions, for example, when there is no media in SATA
CD/DVD drive or media is not ready, AHCI controller fails to execute
ATAPI commands and reports PORT_IRQ_TF_ERR, but ATI SB600 SATA
controller sets PxSERR.E at the
same time, which is not necessary.
    This patch is just to ignore the INTERNAL ERROR in such case.
Without this patch, ahci error handler will report many errors as
below:
    ----------- cut from dmesg -----------
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/00:00:00:00:20/00:00:00:00:00/a0 tag 0 cdb 0x0 data 0
        res 51/24:03:00:00:20/00:00:00:00:00/a0 Emask 0x40 (internal error)
ata9: soft resetting port
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata9.00: configured for UDMA/33
ata9: EH complete
ata9.00: exception Emask 0x40 SAct 0x0 SErr 0x800 action 0x2
ata9.00: (irq_stat 0x40000001)
ata9.00: cmd a0/01:00:00:00:00/00:00:00:00:00/a0 tag 0 cdb 0x43 data 12 in
        res 51/24:03:00:00:00/00:00:00:00:00/a0 Emask 0x40 (internal error)
    -------- end cut ---------

Signed-off-by: Conke Hu <conke.hu@amd.com>

--- 2.6.21-rc5-git1/drivers/ata/ahci.c.orig	2007-04-07 22:36:51.000000000 +0800
+++ 2.6.21-rc5-git1/drivers/ata/ahci.c	2007-04-07 22:44:42.000000000 +0800
@@ -80,6 +80,7 @@ enum {
 	board_ahci_pi		= 1,
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
+	board_ahci_sb600	= 4,

 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -168,6 +169,7 @@ enum {
 	AHCI_FLAG_NO_NCQ		= (1 << 24),
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
+	AHCI_FLAG_IGN_SERR_INTERNAL	= (1 << 27), /* ignore SERR_INTERNAL */
 };

 struct ahci_cmd_hdr {
@@ -362,6 +364,18 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_sb600 */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY |
+				  AHCI_FLAG_IGN_SERR_INTERNAL,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},
+
 };

 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -399,7 +413,7 @@ static const struct pci_device_id ahci_p
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },

 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_sb600 }, /* ATI SB600 non-raid */
 	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */

 	/* VIA */
@@ -1067,8 +1081,11 @@ static void ahci_error_intr(struct ata_p
 	if (ap->flags & AHCI_FLAG_IGN_IRQ_IF_ERR)
 		irq_stat &= ~PORT_IRQ_IF_ERR;

-	if (irq_stat & PORT_IRQ_TF_ERR)
+	if (irq_stat & PORT_IRQ_TF_ERR) {
 		err_mask |= AC_ERR_DEV;
+		if (ap->flags & AHCI_FLAG_IGN_SERR_INTERNAL)
+			serror &= ~SERR_INTERNAL;
+	}

 	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
 		err_mask |= AC_ERR_HOST_BUS;
