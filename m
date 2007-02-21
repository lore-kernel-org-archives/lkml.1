Return-Path: <linux-kernel-owner+w=401wt.eu-S1751094AbXBUBoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094AbXBUBoA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 20:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbXBUBnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 20:43:23 -0500
Received: from hub.freebsd.org ([69.147.83.54]:25547 "EHLO hub.freebsd.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbXBUBmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 20:42:54 -0500
Date: Wed, 21 Feb 2007 01:21:12 +0000
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Don't change transfer speed while requests are in flight
Message-ID: <20070221012112.GB1777@freefall.freebsd.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Use ide_wait_cmd() in ide_config_drive_speed() if the drive has been
initialized and we're not in an interrupt, to avoid changing the
xfer speed while requests are in flight.

An easy way to trigger the problem is to dd the disk while doing
while :; do hdparm -d 1 /dev/hdc> /dev/null; done

While there, remove some commented-out code.

Signed-off-by:	Suleiman Souhlal <suleiman@google.com>

---
 drivers/ide/ide-iops.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/ide/ide-iops.c b/drivers/ide/ide-iops.c
index c67b3b1..35ab3af 100644
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -748,32 +748,36 @@ int ide_config_drive_speed (ide_drive_t 
 	int	i, error	= 1;
 	u8 stat;
 
-//	while (HWGROUP(drive)->busy)
-//		msleep(50);
+	/*
+	 * Just use ide_wait_cmd() if the drive has been initialized and we
+	 * aren't in an interrupt handler, to avoid changing the xfer speed
+	 * while requests are in flight.
+	 *
+	 * If we are in an interrupt, it should be safe to issue
+	 * SETFEATURES manually, since there shouldn't be any requests in
+	 * flight.
+	 */
+	if (drive->queue != NULL && !in_interrupt()) {
+		error = ide_wait_cmd(drive, WIN_SETFEATURES, speed,
+		    SETFEATURES_XFER, 0, NULL);
+		if (error) {
+			stat = hwif->INB(IDE_STATUS_REG);
+			ide_dump_status(drive, "set_drive_speed_status", stat);
+			return (error);
+		}
+		goto done;
+	}
 
 #ifdef CONFIG_BLK_DEV_IDEDMA
 	if (hwif->ide_dma_check)	 /* check if host supports DMA */
 		hwif->dma_host_off(drive);
 #endif
 
-	/*
-	 * Don't use ide_wait_cmd here - it will
-	 * attempt to set_geometry and recalibrate,
-	 * but for some reason these don't work at
-	 * this point (lost interrupt).
-	 */
         /*
          * Select the drive, and issue the SETFEATURES command
          */
 	disable_irq_nosync(hwif->irq);
 	
-	/*
-	 *	FIXME: we race against the running IRQ here if
-	 *	this is called from non IRQ context. If we use
-	 *	disable_irq() we hang on the error path. Work
-	 *	is needed.
-	 */
-	 
 	udelay(1);
 	SELECT_DRIVE(drive);
 	SELECT_MASK(drive, 0);
@@ -835,6 +839,7 @@ #ifdef CONFIG_BLK_DEV_IDEDMA
 		hwif->dma_off_quietly(drive);
 #endif
 
+done:
 	switch(speed) {
 		case XFER_UDMA_7:   drive->id->dma_ultra |= 0x8080; break;
 		case XFER_UDMA_6:   drive->id->dma_ultra |= 0x4040; break;

