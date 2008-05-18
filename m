Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYERShm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYERShm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbYERShM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:37:12 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:17236 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122AbYERShL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:37:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=w3ZSeFindcdB4v2+lpsBEtp+y41nB5p9xcUEPgtGSPJGhhCQRIT9GSmBo3e2/Bgfck1dQQVvKurGPWad3pJ8a39LKNu+nllEuGam5qf4CSQr4yITe9epYaGxUzuiEeS0hPVHwBwNeVTx+Lyj7B9hgn2jbOl75PiljiMql4ekZiE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 18 May 2008 20:54:36 +0200
Message-Id: <20080518185436.5636.19817.sendpatchset@localhost.localdomain>
In-Reply-To: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/40] ide-scsi: fix race in idescsi_transfer_pc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Start DMA engine before sending content of packet command (otherwise
it is possible that IRQ will happen before DMA engine is started).

Cc: Borislav Petkov <petkovbb@gmail.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/scsi/ide-scsi.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: b/drivers/scsi/ide-scsi.c
===================================================================
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -494,13 +494,14 @@ static ide_startstop_t idescsi_transfer_
 	/* Set the interrupt routine */
 	ide_set_handler(drive, &idescsi_pc_intr, get_timeout(pc), idescsi_expiry);
 
-	/* Send the actual packet */
-	hwif->output_data(drive, NULL, scsi->pc->c, 12);
-
 	if (pc->flags & PC_FLAG_DMA_OK) {
 		pc->flags |= PC_FLAG_DMA_IN_PROGRESS;
 		hwif->dma_ops->dma_start(drive);
 	}
+
+	/* Send the actual packet */
+	hwif->output_data(drive, NULL, scsi->pc->c, 12);
+
 	return ide_started;
 }
 
