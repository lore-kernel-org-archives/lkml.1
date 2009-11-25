Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbZKYREF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbZKYREF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 12:04:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759029AbZKYRED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 12:04:03 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52887 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023AbZKYREB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 12:04:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=IOsYo3uZRo33k46KMr6joAfi7RtayhCDV+HQKg4G62+KRrbnV3NiAYldujMxAYCI8q
         MWRJUT5v6/7TBOFknAFflBPsu4yh2sx0haSBeaDaahFvMNF/eITyYXZVUxz8O94JMgrB
         +8CFZvdHWrHYrv+5VYqs/jyU94y6WbSE/4Q6Y=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 25 Nov 2009 18:03:23 +0100
Message-Id: <20091125170323.5446.6849.sendpatchset@localhost>
In-Reply-To: <20091125170218.5446.13513.sendpatchset@localhost>
References: <20091125170218.5446.13513.sendpatchset@localhost>
Subject: [PATCH 09/86] pata_atiixp: no need to program PIO timings for MWDMA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_atiixp: no need to program PIO timings for MWDMA

Moreover the code to do it was buggy and programmed PIO timings
even if they were already set to a desired values.

There shouldn't be any problems with it as IDE atiixp host driver
has been allowing separate PIO/MWDMA timings for last two years.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_atiixp.c |   15 ---------------
 1 file changed, 15 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -107,7 +107,6 @@ static void atiixp_set_dmamode(struct at
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int dma = adev->dma_mode;
 	int dn = 2 * ap->port_no + adev->devno;
-	int wanted_pio;
 
 	if (adev->dma_mode >= XFER_UDMA_0) {
 		u16 udma_mode_data;
@@ -131,20 +130,6 @@ static void atiixp_set_dmamode(struct at
 		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
 				       mwdma_timing_data);
 	}
-	/*
-	 *	We must now look at the PIO mode situation. We may need to
-	 *	adjust the PIO mode to keep the timings acceptable
-	 */
-	 if (adev->dma_mode >= XFER_MW_DMA_2)
-	 	wanted_pio = 4;
-	else if (adev->dma_mode == XFER_MW_DMA_1)
-		wanted_pio = 3;
-	else if (adev->dma_mode == XFER_MW_DMA_0)
-		wanted_pio = 0;
-	else BUG();
-
-	if (adev->pio_mode != wanted_pio)
-		atiixp_set_pio_timing(ap, adev, wanted_pio);
 }
 
 /**
