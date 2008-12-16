Return-Path: <linux-kernel-owner+w=401wt.eu-S1757105AbYLPHit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757105AbYLPHit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 02:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbYLPHg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 02:36:27 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:51259 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYLPHgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 02:36:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=n1cQ8T0sn0gXP75l98R6qp7t6ZWLdCC2dq3LWJ9XkDLPekKSLU7iFNf8evDo5I2Ig5
         XKdh+j0HPpRG60mmjv5jQuJg93nEqDEadsL88EhZO2oXUm6o94VK8+K7ZUJZHuYTn7VX
         jbeHOfKnjhYMz44J4YrDKXj1LgR3VIEdm73bQ=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 9/9] ide-atapi: remove pc arg to drive->pc_update_buffers
Date: Tue, 16 Dec 2008 08:36:09 +0100
Message-Id: <1229412969-3552-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
References: <1229412969-3552-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... however, since this is called with different pc's in ide-tape also, use a
temporary int arg to differentiate between the call sites.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    2 +-
 drivers/ide/ide-floppy.c |    4 ++--
 drivers/ide/ide-tape.c   |   15 ++++++++++++---
 include/linux/ide.h      |    2 +-
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 160d085..e83f5e3 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -339,7 +339,7 @@ static ide_startstop_t ide_pc_intr(ide_drive_t *drive)
 		} else {
 			rq->data_len = drive->pc_req_xfer;
 			if (drive->pc_update_buffers)
-				drive->pc_update_buffers(drive, pc);
+				drive->pc_update_buffers(drive, 0);
 		}
 		debug_log("%s: DMA finished\n", drive->name);
 	}
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 3d6345e..6dd3e8b 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -105,9 +105,9 @@ static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
 	return 0;
 }
 
-static void idefloppy_update_buffers(ide_drive_t *drive,
-				struct ide_atapi_pc *pc)
+static void idefloppy_update_buffers(ide_drive_t *drive, unsigned int which_pc)
 {
+	struct ide_atapi_pc *pc = drive->pc;
 	struct request *rq = pc->rq;
 	struct bio *bio = rq->bio;
 
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 015b417..94fc3e6 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -370,13 +370,22 @@ static void idetape_output_buffers(ide_drive_t *drive, unsigned int bcount)
 	}
 }
 
-static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
+static void idetape_update_buffers(ide_drive_t *drive, unsigned int which_pc)
 {
-	struct idetape_bh *bh = pc->bh;
+	struct idetape_bh *bh;
+	struct ide_atapi_pc *pc;
+	idetape_tape_t *tape = drive->driver_data;
 	struct request *rq = drive->hwif->hwgroup->rq;
 	int count;
 	unsigned int bcount = rq->data_len;
 
+	if (which_pc)
+		pc = tape->failed_pc;
+	else
+		pc = drive->pc;
+
+	bh = pc->bh;
+
 	if (rq_data_dir(rq) == WRITE)
 		return;
 	while (bcount) {
@@ -416,7 +425,7 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
 		rq->data_len = drive->pc_req_xfer -
 			tape->blk_size *
 			get_unaligned_be32(&sense[3]);
-		idetape_update_buffers(drive, pc);
+		idetape_update_buffers(drive, 1);
 	}
 
 	/*
diff --git a/include/linux/ide.h b/include/linux/ide.h
index 291600c..ac4d30f 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -663,7 +663,7 @@ struct ide_drive_s {
 	/* callback for packet commands */
 	void (*pc_callback)(struct ide_drive_s *, int);
 
-	void (*pc_update_buffers)(struct ide_drive_s *, struct ide_atapi_pc *);
+	void (*pc_update_buffers)(struct ide_drive_s *, unsigned int);
 	int  (*pc_io_buffers)(struct ide_drive_s *, unsigned int, int);
 
 	unsigned long atapi_flags;
-- 
1.6.0.4

