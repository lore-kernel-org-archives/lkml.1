Return-Path: <linux-kernel-owner+w=401wt.eu-S1757972AbZKXEV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972AbZKXEV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 23:21:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757287AbZKXEV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 23:21:56 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:57881 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754782AbZKXEVz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 23:21:55 -0500
From: Hemant Pedanekar <hemantp@ti.com>
To: linux-ide@vger.kernel.org
Cc: davem@davemloft.net, bzolnier@gmail.com, sshtylyov@ru.mvista.com,
       petkovbb@gmail.com, christian.engelmayer@frequentis.com,
       linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, hemantp@ti.com
Subject: [PATCH] ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode instead of UDMA6
Date: Tue, 24 Nov 2009 09:46:28 +0530
Message-Id: <1259036188-11598-1-git-send-email-hemantp@ti.com>
X-Mailer: git-send-email 1.6.2.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, ide_cmd_ioctl when invoked for setting DMA transfer mode calls
ide_find_dma_mode with requested mode as XFER_UDMA_6. This prevents setting DMA
mode to any other value than the default (maximum) supported by the device (or
UDMA6, if supported) irrespective of the actual requested transfer mode and
returns error.

For example, setting mode to UDMA2 using hdparm, where UDMA4 is the default
transfer mode gives following error:
	# ./hdparm -d1 -Xudma2  /dev/hda
	 /dev/hda:hda: UDMA/66 mode selected
	 setting using_dma to 1 (on)
	 hda: UDMA/66 mode selected
	 setting xfermode to 66 (UltraDMA mode2)
	 HDIO_DRIVE_CMD(setxfermode) failed: Invalid argument
	 using_dma     =  1 (on)

This patch fixes the issue.

Signed-off-by: Hemant Pedanekar <hemantp@ti.com>
Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-ioctls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-ioctls.c b/drivers/ide/ide-ioctls.c
index d3440b5..6e7ae2b 100644
--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -162,7 +162,7 @@ static int ide_cmd_ioctl(ide_drive_t *drive, unsigned long arg)
 	if (tf->command == ATA_CMD_SET_FEATURES &&
 	    tf->feature == SETFEATURES_XFER &&
 	    tf->nsect >= XFER_SW_DMA_0) {
-		xfer_rate = ide_find_dma_mode(drive, XFER_UDMA_6);
+		xfer_rate = ide_find_dma_mode(drive, tf->nsect);
 		if (xfer_rate != tf->nsect) {
 			err = -EINVAL;
 			goto abort;
-- 
1.6.2.4

