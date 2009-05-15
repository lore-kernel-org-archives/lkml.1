Return-Path: <linux-kernel-owner+w=401wt.eu-S1761756AbZEOFOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761756AbZEOFOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 01:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbZEOFLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 01:11:50 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:56583 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbZEOFLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 01:11:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Bl6pm5ZTdzZN7heMM5NzMXc7+MWBdGngnLa6VXfrASIMv5uQmRkHYm/ExK73A77YLP
         hDUT8fXAUAnLnXRY2uF9uSBmRBYBXSA/3AfFIlp9oN8ooD8K3oF4p+m5CzihWwyFBohI
         CiPB5sGouiIZyL5UOaHF8v1KMm9pL1E+sKaPs=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] ide-atapi: use local sense buffer
Date: Fri, 15 May 2009 07:11:27 +0200
Message-Id: <1242364293-29223-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3
In-Reply-To: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
References: <1242364293-29223-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Access the sense buffer through the bio in ->pc_callback method thus
alleviating the need for the pc->buf pointer.

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c  |    4 +++-
 drivers/ide/ide-floppy.c |    3 ++-
 drivers/ide/ide-tape.c   |    5 +++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index b12be1f..66ea1e7 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -253,7 +253,9 @@ void ide_retry_pc(ide_drive_t *drive)
 	/* init pc from sense_rq */
 	ide_init_pc(pc);
 	memcpy(pc->c, sense_rq->cmd, 12);
-	pc->buf = bio_data(sense_rq->bio);	/* pointer to mapped address */
+
+	/* pointer to mapped address */
+	pc->buf = bio_data(sense_rq->bio);
 	pc->req_xfer = blk_rq_bytes(sense_rq);
 
 	if (drive->media == ide_tape)
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 060c893..14e5e9c 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -77,7 +77,8 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
 	    (rq && blk_pc_request(rq)))
 		uptodate = 1; /* FIXME */
 	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {
-		u8 *buf = pc->buf;
+
+		u8 *buf = bio_data(rq->bio);
 
 		if (!pc->error) {
 			floppy->sense_key = buf[2] & 0x0F;
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1f7f504..ef5f342 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -288,11 +288,12 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
-static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
+static void idetape_analyze_error(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc *pc = drive->failed_pc;
 	struct request *rq = drive->hwif->rq;
+	u8 *sense = bio_data(rq->bio);
 
 	tape->sense_key = sense[2] & 0xF;
 	tape->asc       = sense[12];
@@ -362,7 +363,7 @@ static int ide_tape_callback(ide_drive_t *drive, int dsc)
 
 	if (pc->c[0] == REQUEST_SENSE) {
 		if (uptodate)
-			idetape_analyze_error(drive, pc->buf);
+			idetape_analyze_error(drive);
 		else
 			printk(KERN_ERR "ide-tape: Error in REQUEST SENSE "
 					"itself - Aborting request!\n");
-- 
1.6.3

