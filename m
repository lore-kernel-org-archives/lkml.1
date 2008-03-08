Return-Path: <linux-kernel-owner+w=401wt.eu-S1756331AbYCHVXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331AbYCHVXm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2008 16:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbYCHVVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Mar 2008 16:21:39 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:54620 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYCHVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2008 16:21:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=HZcDgOX0Ddb5zPCSYHXf/r/FUG6XolWTgzqXA/kB2yCqJZTOtZBSSPnc0p8ExHL+NG+Cn/qLyBTMw3CnhC1i9zrcoqBcFS+R2e1UoER35HqzDORW7IXJit+W3QBO+nFPOQ+X5JwWLppWLPRg+VWcH+q1zAn22s+ojvHz8lGIvos=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/7] alim15x3: skip DMA initialization completely on revs < 0x20
Date: Sat, 8 Mar 2008 22:31:09 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803082231.10085.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip DMA initialization completely on revs < 0x20 by setting IDE_HFLAG_NO_DMA
host flag and resetting DMA host masks in alim15x3_init_one() (currently
ide_hwif_setup_dma() will try to obtain DMA base and setup PCI bus-mastering
but init_dma_ali15x3() will fail).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -732,8 +732,6 @@ static void __devinit init_hwif_ali15x3 
 
 static void __devinit init_dma_ali15x3 (ide_hwif_t *hwif, unsigned long dmabase)
 {
-	if (m5229_revision < 0x20)
-		return;
 	if (!hwif->channel)
 		outb(inb(dmabase + 2) & 0x60, dmabase + 2);
 	ide_setup_dma(hwif, dmabase);
@@ -794,6 +792,10 @@ static int __devinit alim15x3_init_one(s
 			d.udma_mask = ATA_UDMA5;
 		else
 			d.udma_mask = ATA_UDMA6;
+	} else {
+		d.host_flags |= IDE_HFLAG_NO_DMA;
+
+		d.mwdma_mask = d.swdma_mask = 0;
 	}
 
 	if (idx == 0)
