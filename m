Return-Path: <linux-kernel-owner+w=401wt.eu-S1758511AbZBBVgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758511AbZBBVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbZBBVgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:36:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:13673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbZBBVgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:36:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=YHXB3N7nfM5/6n55uw8eWpM7nbRHjvhsvNujRa8+L4zXEVm4zgoX6VVEeP4+psxOS+
         7WT7ytZ2ajlR5GPAQIonZGW4W9N4IkZnGBRyEJn2v0INyBkRakXYNRCJxGQNb8iB4Y/t
         xI28l+phs5/jI4ajmfDxDh96ViTbXGTBKMQkg=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:13 +0100
Message-Id: <20090202213713.17960.98328.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/14] ide: use blk_fs_request() check in ide-taskfile.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: use blk_fs_request() check in ide-taskfile.c

Use blk_fs_request() in ide-taskfile.c instead of checking for:
- rq->bio in ide_pio_datablock() and task_error()
- rq->cmd_type == REQ_TYPE_ATA_TASKFILE in task_end_request()

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -264,7 +264,7 @@ static void ide_pio_datablock(ide_drive_
 	ide_task_t *task = &drive->hwif->task;
 	u8 saved_io_32bit = drive->io_32bit;
 
-	if (rq->bio)	/* fs request */
+	if (blk_fs_request(rq))
 		rq->errors = 0;
 
 	if (task->tf_flags & IDE_TFLAG_IO_16BIT)
@@ -288,7 +288,7 @@ static void ide_pio_datablock(ide_drive_
 static ide_startstop_t task_error(ide_drive_t *drive, struct request *rq,
 				  const char *s, u8 stat)
 {
-	if (rq->bio) {
+	if (blk_fs_request(rq)) {
 		ide_hwif_t *hwif = drive->hwif;
 		ide_task_t *task = &hwif->task;
 		int sectors = hwif->nsect - hwif->nleft;
@@ -319,7 +319,7 @@ static ide_startstop_t task_error(ide_dr
 
 void task_end_request(ide_drive_t *drive, struct request *rq, u8 stat)
 {
-	if (rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
+	if (blk_fs_request(rq) == 0) {
 		ide_task_t *task = rq->special;
 		u8 err = ide_read_error(drive);
 
