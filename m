Return-Path: <linux-kernel-owner+w=401wt.eu-S1761982AbYBWUFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761982AbYBWUFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:05:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762952AbYBWUEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:04:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:16461 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYBWUD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:03:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mYNlV4Rcv72e8cIzh3NrUmtlMxHvauwBKwC+TR2dvS8GFnnmzUGGQm3BGsffD4dyz7xBtMuLU3GXNBon7fBPGzcJ0x6uX7J+5QsJ0QuZUsqVAzeaiiDVWPbOitjWrCAmxKmO1TquoWS+TdTX1UURccTPQpmUD0BH6hP90l3s7+w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 3/4] ide: sanitize handling of IDE_HFLAG_NO_SET_MODE host flag
Date: Sat, 23 Feb 2008 21:15:11 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802232115.11908.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Check for IDE_HFLAG_NO_SET_MODE host flag in ide_set_pio(),
  ide_set_[pio,dma]_mode(), ide_set_xfer_rate() and set_pio_mode().

* Remove no longer needed IDE_HFLAG_NO_SET_MODE host flag checking
  from ide_tune_dma().

* Remove superfluous ->set_pio_mode checking from do_special().

This is a part of preparations for adding 'struct ide_port_ops'.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-dma.c |    3 ---
 drivers/ide/ide-io.c  |    4 ----
 drivers/ide/ide-lib.c |   12 ++++++++++--
 drivers/ide/ide.c     |    4 +++-
 4 files changed, 13 insertions(+), 10 deletions(-)

Index: b/drivers/ide/ide-dma.c
===================================================================
--- a/drivers/ide/ide-dma.c
+++ b/drivers/ide/ide-dma.c
@@ -706,9 +706,6 @@ static int ide_tune_dma(ide_drive_t *dri
 	if (!speed)
 		return 0;
 
-	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
-		return 1;
-
 	if (ide_set_dma_mode(drive, speed))
 		return 0;
 
Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -726,10 +726,6 @@ static ide_startstop_t do_special (ide_d
 		s->b.set_tune = 0;
 
 		if (set_pio_mode_abuse(drive->hwif, req_pio)) {
-
-			if (hwif->set_pio_mode == NULL)
-				return ide_stopped;
-
 			/*
 			 * take ide_lock for drive->[no_]unmask/[no_]io_32bit
 			 */
Index: b/drivers/ide/ide-lib.c
===================================================================
--- a/drivers/ide/ide-lib.c
+++ b/drivers/ide/ide-lib.c
@@ -300,7 +300,8 @@ void ide_set_pio(ide_drive_t *drive, u8 
 	ide_hwif_t *hwif = drive->hwif;
 	u8 host_pio, pio;
 
-	if (hwif->set_pio_mode == NULL)
+	if (hwif->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return;
 
 	BUG_ON(hwif->pio_mask == 0x00);
@@ -353,6 +354,9 @@ int ide_set_pio_mode(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
 	if (hwif->set_pio_mode == NULL)
 		return -1;
 
@@ -380,6 +384,9 @@ int ide_set_dma_mode(ide_drive_t *drive,
 {
 	ide_hwif_t *hwif = drive->hwif;
 
+	if (hwif->host_flags & IDE_HFLAG_NO_SET_MODE)
+		return 0;
+
 	if (hwif->set_dma_mode == NULL)
 		return -1;
 
@@ -410,7 +417,8 @@ int ide_set_xfer_rate(ide_drive_t *drive
 {
 	ide_hwif_t *hwif = drive->hwif;
 
-	if (hwif->set_dma_mode == NULL)
+	if (hwif->set_dma_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -1;
 
 	rate = ide_rate_filter(drive, rate);
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -586,11 +586,13 @@ out:
 int set_pio_mode(ide_drive_t *drive, int arg)
 {
 	struct request rq;
+	ide_hwif_t *hwif = drive->hwif;
 
 	if (arg < 0 || arg > 255)
 		return -EINVAL;
 
-	if (drive->hwif->set_pio_mode == NULL)
+	if (hwif->set_pio_mode == NULL ||
+	    (hwif->host_flags & IDE_HFLAG_NO_SET_MODE))
 		return -ENOSYS;
 
 	if (drive->special.b.set_tune)
