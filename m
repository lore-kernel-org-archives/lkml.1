Return-Path: <linux-kernel-owner+w=401wt.eu-S1754444AbYINLjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444AbYINLjZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbYINLg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:27 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3884 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYINLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=Ypoxje7AtFNyiiRN3bDNZPMXFcqWV6Bjzhdcw//TeQ6uBsfNn27NgJICmcLZ9SdbOa
         P/HN8w7E3hvB8iEp61u6A3byP/IVUFlESP5gvfGBQiukCgq2IS2XjBXZ8nNGPFQvvOSn
         UIZWkayQ7hqfkBp3JpU9LkpWP0uVMIY7EN0mM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 10/10] ide-cd: use generic ide_issue_pc
Date: Sun, 14 Sep 2008 13:35:58 +0200
Message-Id: <1221392158-3848-11-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... and remove cdrom_start_packet_command.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |   48 ++++--------------------------------------------
 1 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 29bd205..495e5bb 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -513,50 +513,9 @@ end_request:
 }
 
 /*
- * Set up the device registers for transferring a packet command on DEV,
- * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
- * which actually transfers the command to the drive.  If this is a
- * drq_interrupt device, this routine will arrange for HANDLER to be
- * called when the interrupt from the drive arrives.  Otherwise, HANDLER
- * will be called immediately after the drive is prepared for the transfer.
- */
-static ide_startstop_t cdrom_start_packet_command(ide_drive_t *drive,
-						  int xferlen,
-						  ide_handler_t *handler)
-{
-	ide_hwif_t *hwif = drive->hwif;
-
-	ide_debug_log(IDE_DBG_PC, "Call %s, xferlen: %d\n", __func__, xferlen);
-
-	/* FIXME: for Virtual DMA we must check harder */
-	if (drive->dma)
-		drive->dma = !hwif->dma_ops->dma_setup(drive);
-
-	/* set up the controller registers */
-	ide_pktcmd_tf_load(drive, IDE_TFLAG_OUT_NSECT | IDE_TFLAG_OUT_LBAL,
-			   xferlen, drive->dma);
-
-	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
-		/* waiting for CDB interrupt, not DMA yet. */
-		if (drive->dma)
-			drive->waiting_for_dma = 0;
-
-		/* packet command */
-		ide_execute_command(drive, ATA_CMD_PACKET, handler,
-				    ATAPI_WAIT_PC, cdrom_timer_expiry);
-		return ide_started;
-	} else {
-		ide_execute_pkt_cmd(drive);
-
-		return (*handler) (drive);
-	}
-}
-
-/*
  * Send a packet command to DRIVE described by CMD_BUF and CMD_LEN. The device
- * registers must have already been prepared by cdrom_start_packet_command.
- * HANDLER is the interrupt handler to call when the command completes or
- * there's data ready.
+ * registers must have already been prepared by ide_issue_pc. HANDLER is the
+ * interrupt handler to call when the command completes or there's data ready.
  */
 #define ATAPI_MIN_CDB_BYTES 12
 static ide_startstop_t cdrom_transfer_packet_command(ide_drive_t *drive,
@@ -1290,7 +1249,8 @@ static ide_startstop_t ide_cd_do_request(ide_drive_t *drive, struct request *rq,
 		return ide_stopped;
 	}
 
-	return cdrom_start_packet_command(drive, xferlen, fn);
+	return ide_issue_pc(drive, ATAPI_WAIT_PC, cdrom_timer_expiry,
+			    xferlen, fn);
 }
 
 /*
-- 
1.5.5.1

