Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXCNJWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXCNJWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030803AbXCNJWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:22:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4488 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030812AbXCNJWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:22:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=iMyH28UZ0efQotWuOxAZRGxwwXagXxBgEm6dAAm/VEDshpbr6i+faa24E89wOiduz/dBDo0jnMl4MgII/mmZuyhKBQQS4eqxW1NFU3gJeSIo/DcQXw1hjBp41gHZmSJjZknGEjnPkapYbc01D7DvJqM+tbH47gTOk+3CkeVGpfQ=
Message-ID: <5767b9100703140222k79dbed9dq6419b4f35d276242@mail.gmail.com>
Date: Wed, 14 Mar 2007 17:22:02 +0800
From: "Conke Hu" <conke.hu@gmail.com>
To: "Jeff Garzik" <jeff@garzik.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       "Tejun Heo" <htejun@gmail.com>, "Andrew Morton" <akpm@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] ahci.c: fix ati sb600 sata IRQ_TF_ERR
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    When there is no media in SATA CD/DVD drive or media is not ready,
AHCI controller fails to execute the ATAPI commands TEST_UNIT_READY,
READ_CAPACITY or READ_TOC and reports PORT_IRQ_TF_ERR. But ATI SB600
SATA controller sets SERR_INTERNAL bit in the error register at the
same time, which is not necessary. This patch is just to ignore the
INTERNAL ERROR in such case. Without this patch, ahci error handler
will report many errors as below:
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

--- linux-2.6.21-rc3-git8/drivers/ata/ahci.c.orig	2007-03-25
20:57:31.000000000 +0800
+++ linux-2.6.21-rc3-git8/drivers/ata/ahci.c	2007-03-25 21:03:54.000000000 +0800
@@ -80,6 +80,7 @@ enum {
 	board_ahci_pi		= 1,
 	board_ahci_vt8251	= 2,
 	board_ahci_ign_iferr	= 3,
+	board_ahci_ati	= 4,

 	/* global controller registers */
 	HOST_CAP		= 0x00, /* host capabilities */
@@ -168,6 +169,7 @@ enum {
 	AHCI_FLAG_NO_NCQ		= (1 << 24),
 	AHCI_FLAG_IGN_IRQ_IF_ERR	= (1 << 25), /* ignore IRQ_IF_ERR */
 	AHCI_FLAG_HONOR_PI		= (1 << 26), /* honor PORTS_IMPL */
+	AHCI_FLAG_TF_ERR_FIX	= (1 << 27), /* ignore INTERNAL ERROR on IRQ_TF_ERROR */
 };

 struct ahci_cmd_hdr {
@@ -362,6 +364,16 @@ static const struct ata_port_info ahci_p
 		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
 		.port_ops	= &ahci_ops,
 	},
+	/* board_ahci_ati */
+	{
+		.sht		= &ahci_sht,
+		.flags		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
+				  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
+				  ATA_FLAG_SKIP_D2H_BSY | AHCI_FLAG_TF_ERR_FIX,
+		.pio_mask	= 0x1f, /* pio0-4 */
+		.udma_mask	= 0x7f, /* udma0-6 ; FIXME */
+		.port_ops	= &ahci_ops,
+	},	
 };

 static const struct pci_device_id ahci_pci_tbl[] = {
@@ -399,7 +411,7 @@ static const struct pci_device_id ahci_p
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },

 	/* ATI */
-	{ PCI_VDEVICE(ATI, 0x4380), board_ahci }, /* ATI SB600 non-raid */
+	{ PCI_VDEVICE(ATI, 0x4380), board_ahci_ati }, /* ATI SB600 non-raid */
 	{ PCI_VDEVICE(ATI, 0x4381), board_ahci }, /* ATI SB600 raid */

 	/* VIA */
@@ -1063,12 +1075,22 @@ static void ahci_error_intr(struct ata_p
 	/* analyze @irq_stat */
 	ata_ehi_push_desc(ehi, "irq_stat 0x%08x", irq_stat);

+	qc = ata_qc_from_tag(ap, ap->active_tag);
+
 	/* some controllers set IRQ_IF_ERR on device errors, ignore it */
 	if (ap->flags & AHCI_FLAG_IGN_IRQ_IF_ERR)
 		irq_stat &= ~PORT_IRQ_IF_ERR;

-	if (irq_stat & PORT_IRQ_TF_ERR)
+	if (irq_stat & PORT_IRQ_TF_ERR) {
 		err_mask |= AC_ERR_DEV;
+		
+		/* some controllers set INTERNAL ERROR on ATAPI IRQ_TF_ERROR, ignore it */
+		if ((serror & SERR_INTERNAL) &&
+		     (ap->flags & AHCI_FLAG_TF_ERR_FIX) &&
+	 	      qc && qc->dev->class == ATA_DEV_ATAPI) {
+			serror &= ~SERR_INTERNAL;
+		}
+	}

 	if (irq_stat & (PORT_IRQ_HBUS_ERR | PORT_IRQ_HBUS_DATA_ERR)) {
 		err_mask |= AC_ERR_HOST_BUS;
@@ -1100,7 +1122,6 @@ static void ahci_error_intr(struct ata_p
 	ehi->serror |= serror;
 	ehi->action |= action;

-	qc = ata_qc_from_tag(ap, ap->active_tag);
 	if (qc)
 		qc->err_mask |= err_mask;
 	else
