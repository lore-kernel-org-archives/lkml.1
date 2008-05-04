Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYEDOjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYEDOjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754106AbYEDOiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:38:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:24018 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYEDOiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=jb/MiEQc6f/otGqEFzW1gBhBo5npu1EYgaU8D2ky06Vm3DFUwajJD27Ar+U8cimK3TIjQtJ2HDUg3Bh8BMPdSzUHsrPWSowjSnY+9jYp2LwBqRT4oLgmwkxbHgL8N04d/Zud2lGwlOnRn9HqmYdXohcvLMk8jDsr5k6yWih2fU0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH] ide: IDE_HFLAG_SERIALIZE_DMA bugfix
Date: Sun, 4 May 2008 16:54:35 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805041654.35362.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch re-ordering could be harmful:

commit 1fd1890594bd355a4217f5658a34763e77decee3
Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date:   Sat Apr 26 22:25:24 2008 +0200

    ide: add IDE_HFLAG_SERIALIZE_DMA host flag
...

is buggy because ->init_dma method / ide_hwif_setup_dma() is called
before IDE_HFLAG_SERIALIZE_DMA host flag is checked.

Fix it by checking IDE_HFLAG_SERIALIZE[_DMA] after DMA initialization.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-probe.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: b/drivers/ide/ide-probe.c
===================================================================
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1355,12 +1355,6 @@ static void ide_init_port(ide_hwif_t *hw
 	if (hwif->chipset != ide_dtc2278 || hwif->channel == 0)
 		hwif->port_ops = d->port_ops;
 
-	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
-	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
-		if (hwif->mate)
-			hwif->mate->serialized = hwif->serialized = 1;
-	}
-
 	hwif->swdma_mask = d->swdma_mask;
 	hwif->mwdma_mask = d->mwdma_mask;
 	hwif->ultra_mask = d->udma_mask;
@@ -1382,6 +1376,12 @@ static void ide_init_port(ide_hwif_t *hw
 			hwif->dma_ops = d->dma_ops;
 	}
 
+	if ((d->host_flags & IDE_HFLAG_SERIALIZE) ||
+	    ((d->host_flags & IDE_HFLAG_SERIALIZE_DMA) && hwif->dma_base)) {
+		if (hwif->mate)
+			hwif->mate->serialized = hwif->serialized = 1;
+	}
+
 	if (d->host_flags & IDE_HFLAG_RQSIZE_256)
 		hwif->rqsize = 256;
 
