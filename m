Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYCQGpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYCQGpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 02:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYCQGmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 02:42:32 -0400
Received: from hu-out-0506.google.com ([72.14.214.226]:30208 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311AbYCQGlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 02:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=MjA5VohJl157Q3Fzs8t+orD8IjusG8tEYg5OmnL+LMNOb/FwRSYprZ8BtHKRMF2oLgJY4AhejuXTI2jGn8bs0K/k8M/ITEXATmiuT4pqsZzcc+i3pQVUMl/vp0hTuIeB7EvbNG8nl0n2pO7WoPdGKbbDfNY1KSoC04XFT++/w7c=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 11/17] ide-tape: remove pipeline-specific code from idetape_setup
Date: Mon, 17 Mar 2008 07:41:24 +0100
Message-Id: <1205736090-4435-12-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   40 ++++------------------------------------
 1 files changed, 4 insertions(+), 36 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index c612c8c..0056a26 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2690,11 +2690,10 @@ static inline void idetape_add_settings(ide_drive_t *drive) { ; }
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
@@ -2719,10 +2718,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
 	if (((gcw[0] & 0x60) >> 5) == 1)
 		set_bit(IDETAPE_FLAG_DRQ_INTERRUPT, &tape->flags);
 
-	tape->min_pipeline = 10;
-	tape->max_pipeline = 10;
-	tape->max_stages   = 10;
-
 	idetape_get_inquiry_results(drive);
 	idetape_get_mode_sense_results(drive);
 	ide_tape_get_bsize_from_bdesc(drive);
@@ -2740,36 +2735,10 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
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
@@ -2779,11 +2748,10 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
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

