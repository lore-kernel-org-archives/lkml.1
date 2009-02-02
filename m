Return-Path: <linux-kernel-owner+w=401wt.eu-S1758879AbZBBVhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758879AbZBBVhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 16:37:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758631AbZBBVgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 16:36:54 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:63868 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbZBBVgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 16:36:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=XTrtckLYv6dGa02p0x5zczkFqXtcqutWBR+/fUHUoxQ2luIZOaZd2GE6My2Hl7P7mz
         +HqzT35iIS+5HvCHUUPMkZNAndWgFtFg+WZCGaJYjjFkh2sa2bmCy+RSlWk+TPeGyKIc
         XimpsHehEpFNLprA+Qavtr4foSNly56ak0FyA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 02 Feb 2009 22:37:48 +0100
Message-Id: <20090202213748.17960.34658.sendpatchset@localhost.localdomain>
In-Reply-To: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
References: <20090202213707.17960.61897.sendpatchset@localhost.localdomain>
Subject: [PATCH 06/14] ide: set IDE_TFLAG_WRITE basing on data phase used in ide_taskfile_ioctl()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: set IDE_TFLAG_WRITE basing on data phase used in ide_taskfile_ioctl()

Also take care of fixing up incorrect TASKFILE_IN_DMA[Q] data phase when
IDE_DRIVE_TASK_RAW_WRITE is requested (no need to do it for TASKFILE_NO_DATA
and TASKFILE_[MULTI]_IN -- it had no chance of working previously).

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-taskfile.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -582,7 +582,14 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 	if (req_task->in_flags.b.data)
 		cmd.ftf_flags |= IDE_FTFLAG_IN_DATA;
 
-	switch(req_task->data_phase) {
+	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE) {
+		/* fixup data phase if needed */
+		if (req_task->data_phase == TASKFILE_IN_DMAQ ||
+		    req_task->data_phase == TASKFILE_IN_DMA)
+			cmd.data_phase = TASKFILE_OUT_DMA;
+	}
+
+	switch (cmd.data_phase) {
 		case TASKFILE_MULTI_OUT:
 			if (!drive->mult_count) {
 				/* (hs): give up if multcount is not set */
@@ -597,6 +604,7 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 			/* fall through */
 		case TASKFILE_OUT_DMAQ:
 		case TASKFILE_OUT_DMA:
+			cmd.tf_flags |= IDE_TFLAG_WRITE;
 			nsect = taskout / SECTOR_SIZE;
 			data_buf = outbuf;
 			break;
@@ -637,9 +645,6 @@ int ide_taskfile_ioctl(ide_drive_t *driv
 		}
 	}
 
-	if (req_task->req_cmd == IDE_DRIVE_TASK_RAW_WRITE)
-		cmd.tf_flags |= IDE_TFLAG_WRITE;
-
 	err = ide_raw_taskfile(drive, &cmd, data_buf, nsect);
 
 	memcpy(req_task->hob_ports, &cmd.tf_array[0],
