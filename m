Return-Path: <linux-kernel-owner+w=401wt.eu-S1757209AbYBDNpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209AbYBDNpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756101AbYBDNmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:42 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:3574 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756045AbYBDNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=p4PppMVRl1vNsZ5QBJr/7gAA4PcPwLFDXIIZit6dP0/ESv7Oybw0Vt5GeUUPrSYxUKmHvmdlIikrPcSbVdvf0PA+GSZqAugpJwU0eBgpQzROwdPQiYPQrLB5V0ph+8hfbVddAZzbLyBldBhfvHbm/zi/XcfGHr7rM4iB7wqnUnY=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 09/22] ide-tape: remove idetape_increase_max_pipeline_stages()
Date: Mon,  4 Feb 2008 14:40:27 +0100
Message-Id: <1202132440-26648-10-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function was being used only at one place so fold it in there.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b4944ef..ae2c76d 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -771,25 +771,6 @@ static void idetape_activate_next_stage(ide_drive_t *drive)
 }
 
 /*
- *	idetape_increase_max_pipeline_stages is a part of the feedback
- *	loop which tries to find the optimum number of stages. In the
- *	feedback loop, we are starting from a minimum maximum number of
- *	stages, and if we sense that the pipeline is empty, we try to
- *	increase it, until we reach the user compile time memory limit.
- */
-static void idetape_increase_max_pipeline_stages (ide_drive_t *drive)
-{
-	idetape_tape_t *tape = drive->driver_data;
-	int increase = (tape->max_pipeline - tape->min_pipeline) / 10;
-
-	debug_log(DBG_PROCS, "Enter %s\n", __func__);
-
-	tape->max_stages += max(increase, 1);
-	tape->max_stages = max(tape->max_stages, tape->min_pipeline);
-	tape->max_stages = min(tape->max_stages, tape->max_pipeline);
-}
-
-/*
  *	idetape_kfree_stage calls kfree to completely free a stage, along with
  *	its related buffers.
  */
@@ -937,7 +918,22 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
 			(void)ide_do_drive_cmd(drive, tape->active_data_rq,
 						ide_end);
 		} else if (!error) {
-				idetape_increase_max_pipeline_stages(drive);
+			/*
+			 * This is a part of the feedback loop which tries to
+			 * find the optimum number of stages. We are starting
+			 * from a minimum maximum number of stages, and if we
+			 * sense that the pipeline is empty, we try to increase
+			 * it, until we reach the user compile time memory
+			 * limit.
+			 */
+			int i = (tape->max_pipeline - tape->min_pipeline) / 10;
+
+			tape->max_stages += max(i, 1);
+			tape->max_stages = max(tape->max_stages,
+						tape->min_pipeline);
+			tape->max_stages = min(tape->max_stages,
+						tape->max_pipeline);
+
 		}
 	}
 	ide_end_drive_cmd(drive, 0, 0);
-- 
1.5.3.7

