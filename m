Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752160AbYLRHl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbYLRHl2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 02:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751128AbYLRHlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 02:41:03 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:39855 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYLRHlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 02:41:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=OXsCena1jetT4Go///W1g8s9r20ghFdZFE2yfys/Vn7EUd6EYkPsTbe87BTcqMcK1v
         mA0qp+8ZGijmtMsyz75NZnbIEXq8B6EfhAnfwkW0Ey9OXRsBv+EqjIy+YGPAOjGZrJzt
         TWWyi2oVDczybgkdRvqaGPhGP7DxsdwvTsLRM=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/8] ide-atapi: compute cmd_len based on device type in ide_transfer_pc
Date: Thu, 18 Dec 2008 08:40:45 +0100
Message-Id: <1229586052-3542-2-git-send-email-petkovbb@gmail.com>
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
 drivers/ide/ide-atapi.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index d412bd2..5c143b4 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -15,6 +15,8 @@
 #define debug_log(fmt, args...) do {} while (0)
 #endif
 
+#define ATAPI_MIN_CDB_BYTES	12
+
 static inline int dev_is_idecd(ide_drive_t *drive)
 {
 	return drive->media == ide_cdrom || drive->media == ide_optical;
@@ -492,6 +494,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	struct request *rq = hwif->hwgroup->rq;
 	ide_expiry_t *expiry;
 	unsigned int timeout;
+	int cmd_len;
 	ide_startstop_t startstop;
 	u8 ireason;
 
@@ -506,6 +509,14 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 			drive->waiting_for_dma = 1;
 	}
 
+	if (dev_is_idecd(drive)) {
+		/* ATAPI commands get padded out to 12 bytes minimum */
+		cmd_len = COMMAND_SIZE(rq->cmd[0]);
+		if (cmd_len < ATAPI_MIN_CDB_BYTES)
+			cmd_len = ATAPI_MIN_CDB_BYTES;
+	} else
+		cmd_len = ATAPI_MIN_CDB_BYTES;
+
 	ireason = ide_read_ireason(drive);
 	if (drive->media == ide_tape)
 		ireason = ide_wait_ireason(drive, ireason);
@@ -513,6 +524,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 	if ((ireason & ATAPI_COD) == 0 || (ireason & ATAPI_IO)) {
 		printk(KERN_ERR "%s: (IO,CoD) != (0,1) while issuing "
 				"a packet command\n", drive->name);
+
 		return ide_do_reset(drive);
 	}
 
@@ -541,7 +553,7 @@ static ide_startstop_t ide_transfer_pc(ide_drive_t *drive)
 
 	/* Send the actual packet */
 	if ((drive->atapi_flags & IDE_AFLAG_ZIP_DRIVE) == 0)
-		hwif->tp_ops->output_data(drive, NULL, rq->cmd, 12);
+		hwif->tp_ops->output_data(drive, NULL, rq->cmd, cmd_len);
 
 	return ide_started;
 }
-- 
1.6.0.4

