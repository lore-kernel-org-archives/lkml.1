Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYCIP0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYCIP0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 11:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYCIPYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 11:24:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:14646 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbYCIPYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 11:24:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=uKIZKKj+yZ46V2cWk1pyzc26PN50Is9XhILdmdpGj9ZrvkS+DpoWW10+lCc6nPW+RgijKQ6kRFcVpcssekP9SJ0NNGErdHY16av3V1wBWDLvV8/IvDbRXu/HUj622A2JxHQGjJKNTiG4d4jaWRp0AnCYyf3NFfX8FatvDq736bU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 6/7] palm_bk3710: use ->init_dma method
Date: Sun, 9 Mar 2008 16:32:50 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803091632.50199.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Move DMA setup to palm_bk3710_init_dma().

* Convert the driver to use ->init_dma method.

Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/arm/palm_bk3710.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: b/drivers/ide/arm/palm_bk3710.c
===================================================================
--- a/drivers/ide/arm/palm_bk3710.c
+++ b/drivers/ide/arm/palm_bk3710.c
@@ -317,6 +317,22 @@ static u8 __devinit palm_bk3710_cable_de
 	return ATA_CBL_PATA80;
 }
 
+static int __devinit palm_bk3710_init_dma(ide_hwif_t *hwif,
+					  const struct ide_port_info *d)
+{
+	unsigned long base =
+		hwif->io_ports[IDE_DATA_OFFSET] - IDE_PALM_ATA_PRI_REG_OFFSET;
+
+	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
+
+	if (ide_allocate_dma_engine(hwif))
+		return -1;
+
+	ide_setup_dma(hwif, base);
+
+	return 0;
+}
+
 static const struct ide_port_ops palm_bk3710_ports_ops = {
 	.set_pio_mode		= palm_bk3710_set_pio_mode,
 	.set_dma_mode		= palm_bk3710_set_dma_mode,
@@ -324,8 +340,8 @@ static const struct ide_port_ops palm_bk
 };
 
 static const struct ide_port_info __devinitdata palm_bk3710_port_info = {
+	.init_dma		= palm_bk3710_init_dma,
 	.port_ops		= &palm_bk3710_ports_ops,
-	.host_flags		= IDE_HFLAG_NO_DMA, /* hack (no PCI) */
 	.pio_mask		= ATA_PIO4,
 	.udma_mask		= ATA_UDMA4,	/* (input clk 99MHz) */
 	.mwdma_mask		= ATA_MWDMA2,
@@ -392,11 +408,6 @@ static int __devinit palm_bk3710_probe(s
 	hwif->mmio = 1;
 	default_hwif_mmiops(hwif);
 
-	printk(KERN_INFO "    %s: MMIO-DMA\n", hwif->name);
-
-	if (ide_allocate_dma_engine(hwif) == 0)
-		ide_setup_dma(hwif, mem->start);
-
 	idx[0] = i;
 
 	ide_device_add(idx, &palm_bk3710_port_info);
