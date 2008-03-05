Return-Path: <linux-kernel-owner+w=401wt.eu-S1765504AbYCEWy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765504AbYCEWy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 17:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758856AbYCEWwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 17:52:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:55049 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758765AbYCEWwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 17:52:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NF3FPmlWZyPWMpcThdLn+IsleWPYXTEdFNCglS92vh1DRCxhtCUwXOxhiQQBeFdHnGOiU+uXma+8eXccccY445gyfFCjHG1FcIG0oCO15h5/8kC1LxEwf4KOMtpXmKUQSa8bqlHadkVdQAxB1ce3iAqeCZvAseC2UFzew5bpNMc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/3] ide: remove ide_dma_iobase()
Date: Thu, 6 Mar 2008 00:01:24 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803060001.24459.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* ide_mapped_mmio_dma() and ide_iomio_dma() are called only by
  ide_dma_iobase() so inline them there.

* ide_dma_iobase() is called only by ide_setup_dma() so inline
  it there.

* Setup hwif->extra_base also if hwif->mmio flag is set.

There should be no functional changes casued by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |   34 +++++++---------------------------
 1 file changed, 7 insertions(+), 27 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -838,37 +838,17 @@ static int ide_allocate_dma_engine(ide_h
 	return 1;
 }
 
-static int ide_mapped_mmio_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	printk(KERN_INFO "    %s: MMIO-DMA ", hwif->name);
-
-	return 0;
-}
-
-static int ide_iomio_dma(ide_hwif_t *hwif, unsigned long base)
-{
-	printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
-	       hwif->name, base, base + 7);
-
-	hwif->extra_base = base + (hwif->channel ? 8 : 16);
-
-	return 0;
-}
-
-static int ide_dma_iobase(ide_hwif_t *hwif, unsigned long base)
-{
-	if (hwif->mmio)
-		return ide_mapped_mmio_dma(hwif, base);
-
-	return ide_iomio_dma(hwif, base);
-}
-
 void ide_setup_dma(ide_hwif_t *hwif, unsigned long base)
 {
 	u8 dma_stat;
 
-	if (ide_dma_iobase(hwif, base))
-		return;
+	if (hwif->mmio)
+		printk(KERN_INFO "    %s: MMIO-DMA ", hwif->name);
+	else
+		printk(KERN_INFO "    %s: BM-DMA at 0x%04lx-0x%04lx",
+				 hwif->name, base, base + 7);
+
+	hwif->extra_base = base + (hwif->channel ? 8 : 16);
 
 	if (ide_allocate_dma_engine(hwif)) {
 		ide_release_dma_engine(hwif);
