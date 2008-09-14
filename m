Return-Path: <linux-kernel-owner+w=401wt.eu-S1754431AbYINLjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431AbYINLjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 07:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754302AbYINLg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 07:36:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:9560 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbYINLgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 07:36:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=r1wG1n5oQRy3+Gs6YgeACN3fWb3Y0pa/c7krDBWhzp5sIcvASFq8kxdD2IiUMZyqx0
         NUmMI+udFI26QMJkHl/Ssi1Qg5sPLACbXVbzyRU1vplLooKPBecwtJKg2h0g7MYsWCmy
         Ha4r71O0lrrxAcdadnWFkwARQt16zj34jPCVw=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 07/10] ide-atapi: prepare ide-cd expiry handler
Date: Sun, 14 Sep 2008 13:35:55 +0200
Message-Id: <1221392158-3848-8-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
References: <1221392158-3848-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Push ide-cd expiry handler into the ide-cd header. Also, pass expiry
handler to ide_execute_command() in ide_issue_pc() for later.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    6 +++++-
 drivers/ide/ide-cd.c    |   32 --------------------------------
 drivers/ide/ide-cd.h    |   29 +++++++++++++++++++++++++++++
 3 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index e1fa52d..480b9f3 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -7,6 +7,8 @@
 #include <linux/ide.h>
 #include <scsi/scsi.h>
 
+#include "ide-cd.h"
+
 #ifdef DEBUG
 #define debug_log(fmt, args...) \
 	printk(KERN_INFO "ide: " fmt, ## args)
@@ -600,8 +602,10 @@ ide_startstop_t ide_issue_pc(ide_drive_t *drive, unsigned int timeout,
 	if (drive->atapi_flags & IDE_AFLAG_DRQ_INTERRUPT) {
 		if (drive->dma)
 			drive->waiting_for_dma = 0;
+
 		ide_execute_command(drive, ATA_CMD_PACKET, ide_transfer_pc,
-				    timeout, NULL);
+				    timeout, expiry);
+
 		return ide_started;
 	} else {
 		ide_execute_pkt_cmd(drive);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6258c5f..29bd205 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -512,38 +512,6 @@ end_request:
 	return 1;
 }
 
-static int cdrom_timer_expiry(ide_drive_t *drive)
-{
-	struct request *rq = HWGROUP(drive)->rq;
-	unsigned long wait = 0;
-
-	ide_debug_log(IDE_DBG_RQ, "Call %s: rq->cmd[0]: 0x%x\n", __func__,
-		      rq->cmd[0]);
-
-	/*
-	 * Some commands are *slow* and normally take a long time to complete.
-	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
-	 * commands/drives support that. Let ide_timer_expiry keep polling us
-	 * for these.
-	 */
-	switch (rq->cmd[0]) {
-	case GPCMD_BLANK:
-	case GPCMD_FORMAT_UNIT:
-	case GPCMD_RESERVE_RZONE_TRACK:
-	case GPCMD_CLOSE_TRACK:
-	case GPCMD_FLUSH_CACHE:
-		wait = ATAPI_WAIT_PC;
-		break;
-	default:
-		if (!(rq->cmd_flags & REQ_QUIET))
-			printk(KERN_INFO PFX "cmd 0x%x timed out\n",
-					 rq->cmd[0]);
-		wait = 0;
-		break;
-	}
-	return wait;
-}
-
 /*
  * Set up the device registers for transferring a packet command on DEV,
  * expecting to later transfer XFERLEN bytes.  HANDLER is the routine
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index 5882b9a..69c456f 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -126,4 +126,33 @@ int ide_cdrom_reset(struct cdrom_device_info *cdi);
 int ide_cdrom_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 int ide_cdrom_packet(struct cdrom_device_info *, struct packet_command *);
 
+static inline int cdrom_timer_expiry(ide_drive_t *drive)
+{
+	struct request *rq = drive->hwif->hwgroup->rq;
+	unsigned long wait = 0;
+
+	/*
+	 * Some commands are *slow* and normally take a long time to complete.
+	 * Usually we can use the ATAPI "disconnect" to bypass this, but not all
+	 * commands/drives support that. Let ide_timer_expiry keep polling us
+	 * for these.
+	 */
+	switch (rq->cmd[0]) {
+	case GPCMD_BLANK:
+	case GPCMD_FORMAT_UNIT:
+	case GPCMD_RESERVE_RZONE_TRACK:
+	case GPCMD_CLOSE_TRACK:
+	case GPCMD_FLUSH_CACHE:
+		wait = ATAPI_WAIT_PC;
+		break;
+	default:
+		if (!(rq->cmd_flags & REQ_QUIET))
+			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
+					 rq->cmd[0]);
+		wait = 0;
+		break;
+	}
+	return wait;
+}
+
 #endif /* _IDE_CD_H */
-- 
1.5.5.1

