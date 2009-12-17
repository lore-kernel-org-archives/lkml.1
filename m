Return-Path: <linux-kernel-owner+w=401wt.eu-S1763697AbZLQBVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763697AbZLQBVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763624AbZLQBUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:20:37 -0500
Received: from kroah.org ([198.145.64.141]:47976 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763629AbZLQBU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:29 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:03 2009
Message-Id: <20091217011603.624534895@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:14:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Hemant Pedanekar <hemantp@ti.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [44/90] ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode instead of UDMA6
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hemant Pedanekar <hemantp@ti.com>

[ Upstream commit 28c1969ff887bc2a7df39272850dece01de03285 ]

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
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/ide/ide-ioctls.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ide/ide-ioctls.c
+++ b/drivers/ide/ide-ioctls.c
@@ -162,7 +162,7 @@ static int ide_cmd_ioctl(ide_drive_t *dr
 	if (tf->command == ATA_CMD_SET_FEATURES &&
 	    tf->feature == SETFEATURES_XFER &&
 	    tf->nsect >= XFER_SW_DMA_0) {
-		xfer_rate = ide_find_dma_mode(drive, XFER_UDMA_6);
+		xfer_rate = ide_find_dma_mode(drive, tf->nsect);
 		if (xfer_rate != tf->nsect) {
 			err = -EINVAL;
 			goto abort;


