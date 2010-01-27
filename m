Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555Ab0A0Uqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0A0Uqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185Ab0A0Uqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1526 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab0A0Uqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:33 -0500
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 03/13] drivers/block/floppy.c: Remove unnecessary argument from [__]reschedule_timeout
Date: Wed, 27 Jan 2010 12:46:19 -0800
Message-Id: <6e6575b52eb9a3cf92ec33c757dd33de707a3578.1264624291.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264624291.git.joe@perches.com>
References: <cover.1264624291.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to patch "drivers/block/floppy.c: Use pr_<level>"
only reschedule_timeout(,"request done"...) printed a
numeric value after a reschedule_timeout event message.

Restore that behavior and remove the now unnecessary argument.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index aca5226..25d4693 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -668,7 +668,7 @@ static int output_log_pos;
 #define current_reqD -1
 #define MAXTIMEOUT -2
 
-static void __reschedule_timeout(int drive, const char *message, int marg)
+static void __reschedule_timeout(int drive, const char *message)
 {
 	if (drive == current_reqD)
 		drive = current_drive;
@@ -680,16 +680,16 @@ static void __reschedule_timeout(int drive, const char *message, int marg)
 		fd_timeout.expires = jiffies + UDP->timeout;
 	add_timer(&fd_timeout);
 	if (UDP->flags & FD_DEBUG)
-		DPRINT("reschedule timeout %s %d\n", message, marg);
+		DPRINT("reschedule timeout %s\n", message);
 	timeout_message = message;
 }
 
-static void reschedule_timeout(int drive, const char *message, int marg)
+static void reschedule_timeout(int drive, const char *message)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&floppy_lock, flags);
-	__reschedule_timeout(drive, message, marg);
+	__reschedule_timeout(drive, message);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 }
 
@@ -900,7 +900,7 @@ static int _lock_fdc(int drive, bool interruptible, int line)
 	}
 	command_status = FD_COMMAND_NONE;
 
-	__reschedule_timeout(drive, "lock fdc", 0);
+	__reschedule_timeout(drive, "lock fdc");
 	set_fdc(drive);
 	return 0;
 }
@@ -1983,7 +1983,7 @@ static void floppy_ready(void)
 
 static void floppy_start(void)
 {
-	reschedule_timeout(current_reqD, "floppy start", 0);
+	reschedule_timeout(current_reqD, "floppy start");
 
 	scandrives();
 	debug_dcl(DP->flags, "setting NEWCHANGE in floppy_start\n");
@@ -2007,7 +2007,7 @@ static void floppy_start(void)
 
 static void do_wakeup(void)
 {
-	reschedule_timeout(MAXTIMEOUT, "do wakeup", 0);
+	reschedule_timeout(MAXTIMEOUT, "do wakeup");
 	cont = NULL;
 	command_status += 2;
 	wake_up(&command_done);
@@ -2306,9 +2306,11 @@ static void request_done(int uptodate)
 	struct request *req = current_req;
 	unsigned long flags;
 	int block;
+	char msg[sizeof("request done ") + sizeof(int) * 3];
 
 	probing = 0;
-	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
+	snprintf(msg, sizeof(msg), "request done %d", uptodate);
+	reschedule_timeout(MAXTIMEOUT, msg);
 
 	if (!req) {
 		pr_info("floppy.c: no request in request_done\n");
@@ -2908,7 +2910,7 @@ do_request:
 	}
 	drive = (long)current_req->rq_disk->private_data;
 	set_fdc(drive);
-	reschedule_timeout(current_reqD, "redo fd request", 0);
+	reschedule_timeout(current_reqD, "redo fd request");
 
 	set_floppy(drive);
 	raw_cmd = &default_raw_cmd;
@@ -4254,7 +4256,7 @@ static int __init floppy_init(void)
 		else
 			floppy_sizes[i] = MAX_DISK_SIZE << 1;
 
-	reschedule_timeout(MAXTIMEOUT, "floppy init", MAXTIMEOUT);
+	reschedule_timeout(MAXTIMEOUT, "floppy init");
 	config_types();
 
 	for (i = 0; i < N_FDC; i++) {
-- 
1.6.6.rc0.57.gad7a

