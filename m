Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbZFBHFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbZFBHFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbZFBHFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:05:15 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:34067 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016AbZFBHFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:05:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=iIufSL0hcVJv8Q12c8Z9KBZPOK9LILq6XKNnjf+AvbgWqC1nQERmAI49XvDMGe1pGV
         vwVYfnZ6daloPG0yQk8wPZyFLXOcfAdAGXDRc2nnx6tMSJKZ5rznp1BN13sslRF/op3J
         2pHs8jMYlJgGkyugRpa2uRlGvCWRH1oWUlLI0=
From: Borislav Petkov <petkovbb@googlemail.com>
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically
Date: Tue,  2 Jun 2009 09:05:07 +0200
Message-Id: <1243926308-32385-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two sites where the flag is being changed: ide_retry_pc
and idetape_do_request. Both codepaths are protected by hwif->busy
(ide_lock_port) and therefore we shouldn't need the atomic accesses. The
only problem would be the compiler reordering the accesses, therefore the
optimization barrier.

Spotted-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    2 +-
 drivers/ide/ide-tape.c  |   21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index afe5a43..fbcb851 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -258,7 +258,7 @@ void ide_retry_pc(ide_drive_t *drive)
 	pc->req_xfer = sense_rq->data_len;
 
 	if (drive->media == ide_tape)
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 
 	if (ide_queue_sense_rq(drive, pc))
 		ide_complete_rq(drive, -EIO, blk_rq_bytes(drive->hwif->rq));
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 203bbea..4ff50cc 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -656,15 +656,24 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
 	if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
 	    (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 
 	if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
-		set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
+		drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
 		drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
 	}
 
-	if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
-	    (stat & ATA_DSC) == 0) {
+	/*
+	 * This is a precaution for IDE_AFLAG_IGNORE_DSC being conditionally set
+	 * above. We don't need a stronger enforcement of ordering because the
+	 * read below cannot precede the earlier write out-of-order since it is
+	 * to the same location. Also, since we have the ide port locked during
+	 * the ->do_request(), we only have to be aware of gcc reordering stuff.
+	 */
+	barrier();
+
+	if (!(drive->atapi_flags & IDE_AFLAG_IGNORE_DSC) &&
+	    !(stat & ATA_DSC)) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
@@ -684,7 +693,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 			tape->dsc_poll_freq = IDETAPE_DSC_MA_SLOW;
 		idetape_postpone_request(drive);
 		return ide_stopped;
-	}
+	} else
+		drive->atapi_flags &= ~IDE_AFLAG_IGNORE_DSC;
+
 	if (rq->cmd[13] & REQ_IDETAPE_READ) {
 		pc = &tape->queued_pc;
 		ide_tape_create_rw_cmd(tape, pc, rq, READ_6);
-- 
1.6.3.1

