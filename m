Return-Path: <linux-kernel-owner+w=401wt.eu-S1755756Ab0A0Ush@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab0A0Ush (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755472Ab0A0Uqi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:38 -0500
Received: from mail.perches.com ([173.55.12.10]:1523 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206Ab0A0Uqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 02/13] drivers/block/floppy.c: Unclutter redo_fd_request logic
Date: Wed, 27 Jan 2010 12:46:18 -0800
Message-Id: <fc251691b3da86b02beae6f2f833be39fea4bca1.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change for(;;) with continue; to label: goto label
Reduces indentation and adds a bit of clarity.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |  105 ++++++++++++++++++++++++------------------------
 1 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e750554..aca5226 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2892,64 +2892,63 @@ static void redo_fd_request(void)
 	if (current_drive < N_DRIVE)
 		floppy_off(current_drive);
 
-	for (;;) {
-		if (!current_req) {
-			struct request *req;
-
-			spin_lock_irq(floppy_queue->queue_lock);
-			req = blk_fetch_request(floppy_queue);
-			spin_unlock_irq(floppy_queue->queue_lock);
-			if (!req) {
-				do_floppy = NULL;
-				unlock_fdc();
-				return;
-			}
-			current_req = req;
-		}
-		drive = (long)current_req->rq_disk->private_data;
-		set_fdc(drive);
-		reschedule_timeout(current_reqD, "redo fd request", 0);
-
-		set_floppy(drive);
-		raw_cmd = &default_raw_cmd;
-		raw_cmd->flags = 0;
-		if (start_motor(redo_fd_request))
+do_request:
+	if (!current_req) {
+		struct request *req;
+
+		spin_lock_irq(floppy_queue->queue_lock);
+		req = blk_fetch_request(floppy_queue);
+		spin_unlock_irq(floppy_queue->queue_lock);
+		if (!req) {
+			do_floppy = NULL;
+			unlock_fdc();
 			return;
-		disk_change(current_drive);
-		if (test_bit(current_drive, &fake_change) ||
-		    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
-			DPRINT("disk absent or changed during operation\n");
-			request_done(0);
-			continue;
-		}
-		if (!_floppy) {	/* Autodetection */
-			if (!probing) {
-				DRS->probed_format = 0;
-				if (next_valid_format()) {
-					DPRINT("no autodetectable formats\n");
-					_floppy = NULL;
-					request_done(0);
-					continue;
-				}
-			}
-			probing = 1;
-			_floppy =
-			    floppy_type + DP->autodetect[DRS->probed_format];
-		} else
-			probing = 0;
-		errors = &(current_req->errors);
-		tmp = make_raw_rw_request();
-		if (tmp < 2) {
-			request_done(tmp);
-			continue;
 		}
+		current_req = req;
+	}
+	drive = (long)current_req->rq_disk->private_data;
+	set_fdc(drive);
+	reschedule_timeout(current_reqD, "redo fd request", 0);
 
-		if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
-			twaddle();
-		schedule_bh(floppy_start);
-		debugt("queue fd request");
+	set_floppy(drive);
+	raw_cmd = &default_raw_cmd;
+	raw_cmd->flags = 0;
+	if (start_motor(redo_fd_request))
 		return;
+
+	disk_change(current_drive);
+	if (test_bit(current_drive, &fake_change) ||
+	    test_bit(FD_DISK_CHANGED_BIT, &DRS->flags)) {
+		DPRINT("disk absent or changed during operation\n");
+		request_done(0);
+		goto do_request;
 	}
+	if (!_floppy) {	/* Autodetection */
+		if (!probing) {
+			DRS->probed_format = 0;
+			if (next_valid_format()) {
+				DPRINT("no autodetectable formats\n");
+				_floppy = NULL;
+				request_done(0);
+				goto do_request;
+			}
+		}
+		probing = 1;
+		_floppy = floppy_type + DP->autodetect[DRS->probed_format];
+	} else
+		probing = 0;
+	errors = &(current_req->errors);
+	tmp = make_raw_rw_request();
+	if (tmp < 2) {
+		request_done(tmp);
+		goto do_request;
+	}
+
+	if (test_bit(FD_NEED_TWADDLE_BIT, &DRS->flags))
+		twaddle();
+	schedule_bh(floppy_start);
+	debugt("queue fd request");
+	return;
 }
 
 static struct cont_t rw_cont = {
-- 
1.6.6.rc0.57.gad7a

