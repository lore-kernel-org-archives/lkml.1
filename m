Return-Path: <linux-kernel-owner+w=401wt.eu-S1762663AbYCAJFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762663AbYCAJFE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 04:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757581AbYCAI7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 03:59:34 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:8725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbYCAI7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 03:59:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=MiXOAkSeuAgjWefLyt2DTa8+Svs0/gS0vsleeHB1HjoYR8J6IdIUetwhJ+dZL6z5yi2FKqyMXjtWSijQWugc4n+La6ORiwL1id2uN2wPA7Trn8X9U/OXkI8NHNzqMdT1OckIP4qt78oT2pTA2sJWIhzVLSa1OQlEnwp0KCFaTTw=
To: <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 18/24] ide-tape: remove pipeline-specific code from idetape_setup
Date: Sat,  1 Mar 2008 09:58:42 +0100
Message-Id: <1204361928-30229-19-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   40 ++++------------------------------------
 1 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 5f57bdb..2718006 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2699,11 +2699,10 @@ static inline void idetape_add_settings(ide_drive_t *drive) { ; }
  */
 static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 {
-	unsigned long t1, tmid, tn, t;
+	unsigned long t;
 	int speed;
 	int stage_size;
 	u8 gcw[2];
-	struct sysinfo si;
 	u16 *ctl = (u16 *)&tape->caps[12];
 
 	spin_lock_init(&tape->lock);
@@ -2730,10 +2729,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
 
-	tape->min_pipeline = 10;
-	tape->max_pipeline = 10;
-	tape->max_stages   = 10;
-
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -2751,36 +2746,10 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 		tape->excess_bh_size = PAGE_SIZE - stage_size % PAGE_SIZE;
 	}
 
-	/* Select the "best" DSC read/write polling freq and pipeline size. */
+	/* select the "best" DSC read/write polling freq */
 	speed = max(*(u16 *)&tape->caps[14], *(u16 *)&tape->caps[8]);
 
-	tape->max_stages = speed * 1000 * 10 / tape->stage_size;
-
-	/* Limit memory use for pipeline to 10% of physical memory */
-	si_meminfo(&si);
-	if (tape->max_stages * tape->stage_size >
-			si.totalram * si.mem_unit / 10)
-		tape->max_stages =
-			si.totalram * si.mem_unit / (10 * tape->stage_size);
-
-	tape->max_stages   = min(tape->max_stages, IDETAPE_MAX_PIPELINE_STAGES);
-	tape->min_pipeline = min(tape->max_stages, IDETAPE_MIN_PIPELINE_STAGES);
-	tape->max_pipeline =
-		min(tape->max_stages * 2, IDETAPE_MAX_PIPELINE_STAGES);
-	if (tape->max_stages == 0) {
-		tape->max_stages   = 1;
-		tape->min_pipeline = 1;
-		tape->max_pipeline = 1;
-	}
-
-	t1 = (tape->stage_size * HZ) / (speed * 1000);
-	tmid = (*(u16 *)&tape->caps[16] * 32 * HZ) / (speed * 125);
-	tn = (IDETAPE_FIFO_THRESHOLD * tape->stage_size * HZ) / (speed * 1000);
-
-	if (tape->max_stages)
-		t = tn;
-	else
-		t = t1;
+	t = (tape->stage_size * HZ) / (speed * 1000);
 
 	/*
 	 * Ensure that the number we got makes sense; limit it within
@@ -2790,11 +2759,10 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 				min_t(unsigned long, t, IDETAPE_DSC_RW_MAX),
 				IDETAPE_DSC_RW_MIN);
 	printk(KERN_INFO "ide-tape: %s <-> %s: %dKBps, %d*%dkB buffer, "
-		"%dkB pipeline, %lums tDSC%s\n",
+		"%lums tDSC%s\n",
 		drive->name, tape->name, *(u16 *)&tape->caps[14],
 		(*(u16 *)&tape->caps[16] * 512) / tape->stage_size,
 		tape->stage_size / 1024,
-		tape->max_stages * tape->stage_size / 1024,
 		tape->best_dsc_rw_freq * 1000 / HZ,
 		drive->using_dma ? ", DMA":"");
 
-- 
1.5.4.1

