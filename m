Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbXJ0Sjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbXJ0Sjg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbXJ0Sj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:39:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48246 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbXJ0Sj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:39:27 -0400
Date: Sat, 27 Oct 2007 19:39:23 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: bzolnier@gmail.com, rmk@arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH] ide/arm/icside: fallout from commit 86f3a492bb09eee5745b93af35f2212179c251fd
Message-ID: <20071027183923.GO8181@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

struct device doesn't have ->dma; it's in struct expansion_card where
that struct device is embedded into.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/drivers/ide/arm/icside.c b/drivers/ide/arm/icside.c
index 410a0d1..93f71fc 100644
--- a/drivers/ide/arm/icside.c
+++ b/drivers/ide/arm/icside.c
@@ -316,13 +316,13 @@ static int icside_dma_end(ide_drive_t *drive)
 
 	drive->waiting_for_dma = 0;
 
-	disable_dma(state->dev->dma);
+	disable_dma(ECARD_DEV(state->dev)->dma);
 
 	/* Teardown mappings after DMA has completed. */
 	dma_unmap_sg(state->dev, hwif->sg_table, hwif->sg_nents,
 		     hwif->sg_dma_direction);
 
-	return get_dma_residue(state->dev->dma) != 0;
+	return get_dma_residue(ECARD_DEV(state->dev)->dma) != 0;
 }
 
 static void icside_dma_start(ide_drive_t *drive)
@@ -331,8 +331,8 @@ static void icside_dma_start(ide_drive_t *drive)
 	struct icside_state *state = hwif->hwif_data;
 
 	/* We can not enable DMA on both channels simultaneously. */
-	BUG_ON(dma_channel_active(state->dev->dma));
-	enable_dma(state->dev->dma);
+	BUG_ON(dma_channel_active(ECARD_DEV(state->dev)->dma));
+	enable_dma(ECARD_DEV(state->dev)->dma);
 }
 
 static int icside_dma_setup(ide_drive_t *drive)
@@ -350,7 +350,7 @@ static int icside_dma_setup(ide_drive_t *drive)
 	/*
 	 * We can not enable DMA on both channels.
 	 */
-	BUG_ON(dma_channel_active(state->dev->dma));
+	BUG_ON(dma_channel_active(ECARD_DEV(state->dev)->dma));
 
 	icside_build_sglist(drive, rq);
 
@@ -367,14 +367,14 @@ static int icside_dma_setup(ide_drive_t *drive)
 	/*
 	 * Select the correct timing for this drive.
 	 */
-	set_dma_speed(state->dev->dma, drive->drive_data);
+	set_dma_speed(ECARD_DEV(state->dev)->dma, drive->drive_data);
 
 	/*
 	 * Tell the DMA engine about the SG table and
 	 * data direction.
 	 */
-	set_dma_sg(state->dev->dma, hwif->sg_table, hwif->sg_nents);
-	set_dma_mode(state->dev->dma, dma_mode);
+	set_dma_sg(ECARD_DEV(state->dev)->dma, hwif->sg_table, hwif->sg_nents);
+	set_dma_mode(ECARD_DEV(state->dev)->dma, dma_mode);
 
 	drive->waiting_for_dma = 1;
 
