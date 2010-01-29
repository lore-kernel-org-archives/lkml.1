Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238Ab0A2QH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0A2QH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479Ab0A2QHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:07:53 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:53041 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab0A2QHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:07:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ESL1dQGZQPFrzx3TmUlUk24LdRuQvxU3OP5vOb/QQ05nPBEZRhX9XfY9jFTmCsbxDX
         qTTXZIpTS8jyE3WDfXcdIIYD0DBN8KW29BNrN76wyi3qtXdWLhy/mLq1CSBDao2NvpRw
         9T6tcERINuQJJwg+fU7bUUJUp2xye8t8X+c90=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 29 Jan 2010 17:07:43 +0100
Message-Id: <20100129160743.21495.78502.sendpatchset@localhost>
In-Reply-To: <20100129160308.21495.14120.sendpatchset@localhost>
References: <20100129160308.21495.14120.sendpatchset@localhost>
Subject: [PATCH 43/68] cs5520: convert to ide2libata
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5520: convert to ide2libata

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/cs5520.c |   44 ++++----------------------------------------
 1 file changed, 4 insertions(+), 40 deletions(-)

Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -42,55 +42,19 @@
 
 #define DRV_NAME "cs5520"
 
-struct pio_clocks
-{
-	int address;
-	int assert;
-	int recovery;
-};
-
-static struct pio_clocks cs5520_pio_clocks[]={
-	{3, 6, 11},
-	{2, 5, 6},
-	{1, 4, 3},
-	{1, 3, 2},
-	{1, 2, 1}
-};
-
-static void cs5520_set_pio_mode(ide_hwif_t *hwif, ide_drive_t *drive)
-{
-	struct pci_dev *pdev = to_pci_dev(hwif->dev);
-	int controller = drive->dn > 1 ? 1 : 0;
-	const u8 pio = drive->pio_mode - XFER_PIO_0;
-
-	/* 8bit CAT/CRT - 8bit command timing for channel */
-	pci_write_config_byte(pdev, 0x62 + controller, 
-		(cs5520_pio_clocks[pio].recovery << 4) |
-		(cs5520_pio_clocks[pio].assert));
-
-	/* 0x64 - 16bit Primary, 0x68 - 16bit Secondary */
-
-	/* FIXME: should these use address ? */
-	/* Data read timing */
-	pci_write_config_byte(pdev, 0x64 + 4*controller + (drive->dn&1),
-		(cs5520_pio_clocks[pio].recovery << 4) |
-		(cs5520_pio_clocks[pio].assert));
-	/* Write command timing */
-	pci_write_config_byte(pdev, 0x66 + 4*controller + (drive->dn&1),
-		(cs5520_pio_clocks[pio].recovery << 4) |
-		(cs5520_pio_clocks[pio].assert));
-}
+#include <linux/ide2libata.h>
+#include "../ata/pata_cs5520.h"
 
 static void cs5520_set_dma_mode(ide_hwif_t *hwif, ide_drive_t *drive)
 {
 	printk(KERN_ERR "cs55x0: bad ide timing.\n");
 
 	drive->pio_mode = XFER_PIO_0 + 0;
-	cs5520_set_pio_mode(hwif, drive);
+	cs5520_set_piomode(hwif, drive);
 }
 
 static const struct ide_port_ops cs5520_port_ops = {
-	.set_pio_mode		= cs5520_set_pio_mode,
+	.set_pio_mode		= cs5520_set_piomode,
 	.set_dma_mode		= cs5520_set_dma_mode,
 };
 
