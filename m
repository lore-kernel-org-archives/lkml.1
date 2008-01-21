Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbYAUXXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbYAUXXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYAUXTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:19:10 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43432 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761053AbYAUXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ASU11klA/8MnL5iZmnXcxvhrVCubCd7c5Ls4FL1UgrJTt0LgCmJtmtdQzZtrwadVCi7tG1dHy3KZyOmEMBgD0I7WW3RYIbVkEY7dmZnuXd2KUGPaE2P/Afn7dfyMOZKQmyFouwrr+dBIggBkpK6K0/ze/pt4+pCQQylrISWvgZg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 22 Jan 2008 00:32:12 +0100
Message-Id: <20080121233212.30311.71098.sendpatchset@localhost.localdomain>
In-Reply-To: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
References: <20080121233036.30311.76015.sendpatchset@localhost.localdomain>
Subject: [PATCH 14/16] ide: move drive->crc_count check out from check_dma_crc()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -968,13 +968,10 @@ static ide_startstop_t reset_pollfunc (i
 static void check_dma_crc(ide_drive_t *drive)
 {
 #ifdef CONFIG_BLK_DEV_IDEDMA
-	if (drive->crc_count) {
-		ide_dma_off_quietly(drive);
-		ide_set_xfer_rate(drive, ide_auto_reduce_xfer(drive));
-		if (drive->current_speed >= XFER_SW_DMA_0)
-			ide_dma_on(drive);
-	} else
-		ide_dma_off(drive);
+	ide_dma_off_quietly(drive);
+	ide_set_xfer_rate(drive, ide_auto_reduce_xfer(drive));
+	if (drive->current_speed >= XFER_SW_DMA_0)
+		ide_dma_on(drive);
 #endif
 }
 
@@ -999,17 +996,20 @@ static void pre_reset(ide_drive_t *drive
 	else
 		drive->post_reset = 1;
 
-	if (!drive->keep_settings) {
-		if (drive->using_dma) {
+	if (drive->using_dma) {
+		if (drive->crc_count)
 			check_dma_crc(drive);
-		} else {
+		else
+			ide_dma_off(drive);
+	}
+
+	if (!drive->keep_settings) {
+		if (!drive->using_dma) {
 			drive->unmask = 0;
 			drive->io_32bit = 0;
 		}
 		return;
 	}
-	if (drive->using_dma)
-		check_dma_crc(drive);
 
 	if (HWIF(drive)->pre_reset != NULL)
 		HWIF(drive)->pre_reset(drive);
