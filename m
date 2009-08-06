Return-Path: <linux-kernel-owner+w=401wt.eu-S1756159AbZHFPrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159AbZHFPrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 11:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755922AbZHFPrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 11:47:45 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:35587 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZHFPro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 11:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=qX2cq36GqO8pcftjkowrwdHRIwbdbBG5XpVWaUSQKX0hiWk8xrJk257rxGZelYG1TE
         1y8vDT3e0f7BVIrsLxfGl6Wx8AKTsEE4viNXPbUr1TwKNnxV115tJ2XWReXo+RzQsC+1
         N/pXMuaIJjHvOPXJQqEWbfvab8nbipNroEmQg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] pata_atiixp: fix slave device support
Date: Thu, 6 Aug 2009 17:47:05 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-next-20090806; KDE/4.2.4; i686; ; )
Cc: Krystian Juskowiak <jusko@tlen.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bbpetkov@yahoo.de>,
       Robert Hancock <hancockrwd@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200908061740.15902.bzolnier@gmail.com>
In-Reply-To: <200908061740.15902.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908061747.05944.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 August 2009 17:40:15 Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] pata_atiixp: fix slave device support

Argh, I pushed the "Send" button too quick..

Below version with the correct patch description
(I doubt that this fix will help with bug #13921)..

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH v2] pata_atiixp: fix second channel support

PIO and MWDMA timings are never programmed for the second channel
because timing registers are treated as 16-bit long ones.

The bug is an attixp -> pata_atiixp regression and goes back to:

	commit 669a5db411d85a14f86cd92bc16bf7ab5b8aa235
	Author: Jeff Garzik <jeff@garzik.org>
	Date:   Tue Aug 29 18:12:40 2006 -0400

	    [libata] Add a bunch of PATA drivers.

Cc: Krystian Juskowiak <jusko@tlen.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Robert Hancock <hancockrwd@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
After this patch pata_atiixp still have two bugs (+ few superfluous oddities)
not present in atiixp (although not as severe as this one)..

 drivers/ata/pata_atiixp.c |   19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

Index: b/drivers/ata/pata_atiixp.c
===================================================================
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -1,6 +1,7 @@
 /*
  * pata_atiixp.c 	- ATI PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2009 Bartlomiej Zolnierkiewicz
  *
  * Based on
  *
@@ -61,20 +62,19 @@ static void atiixp_set_pio_timing(struct
 
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
 	int dn = 2 * ap->port_no + adev->devno;
-
-	/* Check this is correct - the order is odd in both drivers */
 	int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
-	u16 pio_mode_data, pio_timing_data;
+	u32 pio_timing_data;
+	u16 pio_mode_data;
 
 	pci_read_config_word(pdev, ATIIXP_IDE_PIO_MODE, &pio_mode_data);
 	pio_mode_data &= ~(0x7 << (4 * dn));
 	pio_mode_data |= pio << (4 * dn);
 	pci_write_config_word(pdev, ATIIXP_IDE_PIO_MODE, pio_mode_data);
 
-	pci_read_config_word(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
+	pci_read_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, &pio_timing_data);
 	pio_timing_data &= ~(0xFF << timing_shift);
 	pio_timing_data |= (pio_timings[pio] << timing_shift);
-	pci_write_config_word(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
+	pci_write_config_dword(pdev, ATIIXP_IDE_PIO_TIMING, pio_timing_data);
 }
 
 /**
@@ -119,16 +119,17 @@ static void atiixp_set_dmamode(struct at
 		udma_mode_data |= dma << (4 * dn);
 		pci_write_config_word(pdev, ATIIXP_IDE_UDMA_MODE, udma_mode_data);
 	} else {
-		u16 mwdma_timing_data;
-		/* Check this is correct - the order is odd in both drivers */
 		int timing_shift = (16 * ap->port_no) + 8 * (adev->devno ^ 1);
+		u32 mwdma_timing_data;
 
 		dma -= XFER_MW_DMA_0;
 
-		pci_read_config_word(pdev, ATIIXP_IDE_MWDMA_TIMING, &mwdma_timing_data);
+		pci_read_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				      &mwdma_timing_data);
 		mwdma_timing_data &= ~(0xFF << timing_shift);
 		mwdma_timing_data |= (mwdma_timings[dma] << timing_shift);
-		pci_write_config_word(pdev, ATIIXP_IDE_MWDMA_TIMING, mwdma_timing_data);
+		pci_write_config_dword(pdev, ATIIXP_IDE_MWDMA_TIMING,
+				       mwdma_timing_data);
 	}
 	/*
 	 *	We must now look at the PIO mode situation. We may need to
