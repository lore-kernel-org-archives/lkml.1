Return-Path: <linux-kernel-owner+w=401wt.eu-S1756156AbYGEMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156AbYGEMvr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 08:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYGEMvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 08:51:13 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:10928 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797AbYGEMvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 08:51:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=MXxGUtEaKzsr0P5/t0XJ8+7qCkIbxCOeC62B3gzCLjVPi+TrJQMWFUob/OE1PXH/bh
         JWDdh5gRJX2rtKQIMGCsx19ESmzt7N0Qp/uf4Nn1/U7YQCjoNdGF+cyAi5F6r0YNeNer
         zJVaIIUEj1tDDY/iVYxiI4og0hWHgiFtkNV6U=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/2] ide: ide_unregister() locking bugfix
Date: Sat, 5 Jul 2008 14:51:18 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807051451.18784.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holding ide_lock for ide_release_dma_engine() call is unnecessary
and triggers WARN_ON(irqs_disabled()) in dma_free_coherent().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -352,15 +352,15 @@ void ide_unregister(ide_hwif_t *hwif)
 	blk_unregister_region(MKDEV(hwif->major, 0), MAX_DRIVES<<PARTN_BITS);
 	kfree(hwif->sg_table);
 	unregister_blkdev(hwif->major, hwif->name);
-	spin_lock_irq(&ide_lock);
 
 	if (hwif->dma_base)
 		ide_release_dma_engine(hwif);
 
+	spin_lock_irq(&ide_lock);
 	/* restore hwif data to pristine status */
 	ide_init_port_data(hwif, hwif->index);
-
 	spin_unlock_irq(&ide_lock);
+
 	mutex_unlock(&ide_cfg_mtx);
 }
 
