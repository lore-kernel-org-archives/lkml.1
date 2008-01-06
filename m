Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbYAFQwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbYAFQwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759434AbYAFQvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:51:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18967 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbYAFQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:51:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=SiYB9bRslLFfIqKvDj5vAOHI3BykyY8d0pecHxvO525+jUG1mOJzXtS4yt9QTx0YahAqyYw03IVKeLgjJJFyJU2lSwxBF5l9ZFBRNuNyPWFhbqxhsfDWC+1LN5AyPwnM40Tf3kGmK6WzNe70tf5lIODdt1/iq1iQI01J1mpuCp4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 06 Jan 2008 18:02:55 +0100
Message-Id: <20080106170255.6861.36960.sendpatchset@localhost.localdomain>
In-Reply-To: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
References: <20080106170220.6861.4814.sendpatchset@localhost.localdomain>
Subject: [PATCH 5/8] ide: always set DMA masks in ide_pci_setup_ports()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always set DMA masks in ide_pci_setup_ports() to make sure that the valid
masks for a host are set.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
+34 bytes
 drivers/ide/setup-pci.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -556,10 +556,15 @@ void ide_pci_setup_ports(struct pci_dev 
 			hwif->drives[1].unmask = 1;
 		}
 
-		if (hwif->dma_base) {
-			hwif->swdma_mask = d->swdma_mask;
-			hwif->mwdma_mask = d->mwdma_mask;
-			hwif->ultra_mask = d->udma_mask;
+		hwif->swdma_mask = d->swdma_mask;
+		hwif->mwdma_mask = d->mwdma_mask;
+		hwif->ultra_mask = d->udma_mask;
+
+		if ((d->host_flags && IDE_HFLAG_NO_DMA) == 0 &&
+		    hwif->dma_base == 0) {
+			hwif->swdma_mask = 0;
+			hwif->mwdma_mask = 0;
+			hwif->ultra_mask = 0;
 		}
 
 		hwif->drives[0].autotune = 1;
