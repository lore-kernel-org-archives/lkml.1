Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZFCFj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZFCFj3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 01:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZFCFjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 01:39:20 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61379 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZFCFjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 01:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=QCrssEt3E1OttBgzlDHjUGaXOZ2eWrpLQTH6v8RObNm2YCFxjVvMZydr6wBNZoVl8L
         QS8yvlj0ExuqGvgPaw5pUy4zAJwF8uKlQilNYl+ShHb0tEmbk9hUwaGo0rzRFCuNY/aK
         wDt6qvcbWuoo0gvPq7+0R0ijwGFLGnbfBF6og=
Date: Wed, 3 Jun 2009 07:39:16 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC
	non-atomically
Message-ID: <20090603053916.GA3577@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com> <200906021218.33787.bzolnier@gmail.com> <9ea470500906020608o14f8bc8dwaedabff70c1cb707@mail.gmail.com> <200906021517.53027.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200906021517.53027.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > > Are you seeing a real problem with gcc here?  No sane compiler should need
> > > a barrier() here (we would probably need zillions of them in kernel if it
> > > really does).
> > 
> > No, this is just a precaution. The asm I checked looked fine but since
> > the flag is set and right afterwards checked, it will be bad if this
> > somehow got reordered. I actually haven't checked whether anything like
> > that would be possible, at all.
> 
> Please remove it then.

---

From: Borislav Petkov <petkovbb@gmail.com>
Date: Mon, 1 Jun 2009 13:43:49 +0200
Subject: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically

There are two sites where the flag is being changed: ide_retry_pc
and idetape_do_request. Both codepaths are protected by hwif->busy
(ide_lock_port) and therefore we shouldn't need the atomic accesses.

Spotted-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-atapi.c |    2 +-
 drivers/ide/ide-tape.c  |   12 +++++++-----
 2 files changed, 8 insertions(+), 6 deletions(-)

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
index 203bbea..f1d3c7b 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -656,15 +656,15 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
 
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
+	if (!(drive->atapi_flags & IDE_AFLAG_IGNORE_DSC) &&
+	    !(stat & ATA_DSC)) {
 		if (postponed_rq == NULL) {
 			tape->dsc_polling_start = jiffies;
 			tape->dsc_poll_freq = tape->best_dsc_rw_freq;
@@ -684,7 +684,9 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
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


-- 
Regards/Gruss,
    Boris.
