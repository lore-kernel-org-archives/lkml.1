Return-Path: <linux-kernel-owner+w=401wt.eu-S1752862AbYDGEpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbYDGEpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 00:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYDGEpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 00:45:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:37098 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYDGEot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 00:44:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=mW28GNAsnP84RWLu4boAKhyjL6plUR8Bujy+Tkj9YgaikQ53WD3l1n9Fv0IWaRJnQOu+PUThss/JwaOVg2lSvYfnV+6wklKnXhhmbey+8n1nkEkprXqGchsl2WVGQSfpyqVElNMWZkd0L0LportZI+5+0jrPen8T1F3+awaUebU=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 3/6] ide-tape: mv idetape_empty_write_pipeline ide_tape_flush_merge_buffer
Date: Mon,  7 Apr 2008 06:45:01 +0200
Message-Id: <1207543504-27888-4-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
References: <1207543504-27888-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index ecc11c1..d5ca673 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1779,7 +1779,7 @@ static int idetape_add_chrdev_write_request(ide_drive_t *drive, int blocks)
 				     blocks, tape->merge_stage->bh);
 }
 
-static void idetape_empty_write_pipeline(ide_drive_t *drive)
+static void ide_tape_flush_merge_buffer(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	int blocks, min;
@@ -1841,7 +1841,7 @@ static int idetape_init_read(ide_drive_t *drive)
 	/* Initialize read operation */
 	if (tape->chrdev_dir != IDETAPE_DIR_READ) {
 		if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-			idetape_empty_write_pipeline(drive);
+			ide_tape_flush_merge_buffer(drive);
 			idetape_flush_tape_buffers(drive);
 		}
 		if (tape->merge_stage || tape->merge_stage_size) {
@@ -2357,7 +2357,7 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
 	debug_log(DBG_CHRDEV, "Enter %s, cmd=%u\n", __func__, cmd);
 
 	if (tape->chrdev_dir == IDETAPE_DIR_WRITE) {
-		idetape_empty_write_pipeline(drive);
+		ide_tape_flush_merge_buffer(drive);
 		idetape_flush_tape_buffers(drive);
 	}
 	if (cmd == MTIOCGET || cmd == MTIOCPOS) {
@@ -2506,7 +2506,7 @@ static void idetape_write_release(ide_drive_t *drive, unsigned int minor)
 {
 	idetape_tape_t *tape = drive->driver_data;
 
-	idetape_empty_write_pipeline(drive);
+	ide_tape_flush_merge_buffer(drive);
 	tape->merge_stage = ide_tape_kmalloc_buffer(tape, 1, 0);
 	if (tape->merge_stage != NULL) {
 		idetape_pad_zeros(drive, tape->blk_size *
-- 
1.5.4.1

