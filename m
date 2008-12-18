Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753436AbYLRHmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLRHmj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYLRHlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:11 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42077 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbYLRHlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=NUoZb6biid3kYlHeEFpTFBTLUNiuTxTPyyutN/sKSXIGpONu58NwIOanKg9mhjXZIS
         3+9fIAyKLdNkAoscjGA+ram+QsmVisMuV7aMaSd4IdULy1c9M6Y0SC7GodRmmAJTR+Jv
         PTdrr8HuZKrAKzE7jEoYhdqICuJk+TpAZdMcg=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 2/8] ide-atapi: assign expiry and timeout based on device type
Date: Thu, 18 Dec 2008 08:40:46 +0100
Message-Id: <1229586052-3542-3-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
References: <1229586052-3542-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |   35 ++++++++++++++++++++---------------
 1 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 5c143b4..5295b26 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -514,9 +514,28 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		cmd_len = COMMAND_SIZE(rq->cmd[0]);
 		if (cmd_len < ATAPI_MIN_CDB_BYTES)
 			cmd_len = ATAPI_MIN_CDB_BYTES;
-	} else
+
+		timeout = rq->timeout;
+		expiry  = ide_cd_expiry;
+
+	} else {
 		cmd_len = ATAPI_MIN_CDB_BYTES;
 
+		/*
+		 * If necessary schedule the packet transfer to occur 'timeout'
+		 * miliseconds later in ide_delayed_transfer_pc() after the
+		 * device says it's ready for a packet.
+		 */
+		if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
+			timeout = drive->pc_delay;
+			expiry = &ide_delayed_transfer_pc;
+		} else {
+			timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
+							       : WAIT_TAPE_CMD;
+			expiry = NULL;
+		}
+	}
+
 	ireason = ide_read_ireason(drive);
 	if (drive->media == ide_tape)
 		ireason = ide_wait_ireason(drive, ireason);
@@ -528,20 +547,6 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 		return ide_do_reset(drive);
 	}
 
-	/*
-	 * If necessary schedule the packet transfer to occur 'timeout'
-	 * miliseconds later in ide_delayed_transfer_pc() after the device
-	 * says it's ready for a packet.
-	 */
-	if (drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) {
-		timeout = drive->pc_delay;
-		expiry = &ide_delayed_transfer_pc;
-	} else {
-		timeout = (drive->media == ide_floppy) ? WAIT_FLOPPY_CMD
-						       : WAIT_TAPE_CMD;
-		expiry = NULL;
-	}
-
 	/* Set the interrupt routine */
 	ide_set_handler(drive, ide_pc_intr, timeout, expiry);
 
-- 
1.6.0.4

