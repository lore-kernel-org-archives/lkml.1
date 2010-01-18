Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658Ab0ARR0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658Ab0ARR0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755355Ab0ARR0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:26:51 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:51627 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab0ARRVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:21:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=v1VID5272f1hFHlNVhkaJChU31uxUzHZlrgeGl1e/Q9MWE2PLZGvaPGyROzeCL+4b2
         pnus7kxDpFYbNfrJs0L/MA+TyHv0zo1bqK6Cms1EBnrICGan+A8YCfCEDB9tou/09oO6
         iX8U9ix/zI4RP3ta0/J6cW8euLHKPSSIzgW10=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:20:35 +0100
Message-Id: <20100118172035.14623.50000.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 47/64] ide: add drive->dma_mode field
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: add drive->dma_mode field

Add dma_mode field to ide_drive_t matching dma_mode field used in
struct ata_device.

The validity of the field is restricted to ->dma_pio_mode method
only currently in IDE subsystem.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/aec62xx.c       |    1 +
 drivers/ide/ide-xfer-mode.c |    2 ++
 include/linux/ide.h         |    1 +
 3 files changed, 4 insertions(+)

Index: b/drivers/ide/aec62xx.c
===================================================================
--- a/drivers/ide/aec62xx.c
+++ b/drivers/ide/aec62xx.c
@@ -136,6 +136,7 @@ static void aec6260_set_mode(ide_drive_t
 
 static void aec_set_pio_mode(ide_drive_t *drive, const u8 pio)
 {
+	drive->dma_mode = pio + XFER_PIO_0;
 	drive->hwif->port_ops->set_dma_mode(drive, pio + XFER_PIO_0);
 }
 
Index: b/drivers/ide/ide-xfer-mode.c
===================================================================
--- a/drivers/ide/ide-xfer-mode.c
+++ b/drivers/ide/ide-xfer-mode.c
@@ -167,9 +167,11 @@ int ide_set_dma_mode(ide_drive_t *drive,
 	if (hwif->host_flags & IDE_HFLAG_POST_SET_MODE) {
 		if (ide_config_drive_speed(drive, mode))
 			return -1;
+		drive->dma_mode = mode;
 		port_ops->set_dma_mode(drive, mode);
 		return 0;
 	} else {
+		drive->dma_mode = mode;
 		port_ops->set_dma_mode(drive, mode);
 		return ide_config_drive_speed(drive, mode);
 	}
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -516,6 +516,7 @@ struct ide_drive_s {
         u8	current_speed;	/* current transfer rate set */
 	u8	desired_speed;	/* desired transfer rate set */
 	u8	pio_mode;	/* for ->set_pio_mode _only_ */
+	u8	dma_mode;	/* for ->dma_pio_mode _only_ */
         u8	dn;		/* now wide spread use */
 	u8	acoustic;	/* acoustic management */
 	u8	media;		/* disk, cdrom, tape, floppy, ... */
