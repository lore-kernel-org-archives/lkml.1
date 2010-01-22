Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925Ab0AVE4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925Ab0AVE4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 23:56:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401Ab0AVE4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 23:56:25 -0500
Received: from mail.perches.com ([173.55.12.10]:1350 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab0AVExA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 23:53:00 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 18/24] drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
Date: Thu, 21 Jan 2010 20:52:48 -0800
Message-Id: <ede2cfe4c04a8c75df5703f4082cd6cb69d66dd3.1264133863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264133863.git.joe@perches.com>
References: <cover.1264133863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obfuscating macros with embedded returns are not nice

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a1eb5fe..de5dc29 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -519,10 +519,6 @@ static DECLARE_WAIT_QUEUE_HEAD(fdc_wait);
 static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
-#define CALL(x)		if ((x) == -EINTR) return -EINTR
-#define _WAIT(x,i)	CALL(ret=wait_til_done((x),i))
-#define WAIT(x)		_WAIT((x),interruptible)
-#define IWAIT(x)	_WAIT((x),1)
 
 /* Errors during formatting are counted here. */
 static int format_errors;
@@ -2268,7 +2264,9 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
 	format_errors = 0;
 	cont = &format_cont;
 	errors = &format_errors;
-	IWAIT(redo_format);
+	ret = wait_til_done(redo_format, 1);
+	if (ret == -EINTR)
+		return -EINTR;
 	process_fd_request();
 	return ret;
 }
@@ -2996,8 +2994,6 @@ static struct cont_t poll_cont = {
 
 static int poll_drive(int interruptible, int flag)
 {
-	int ret;
-
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3006,8 +3002,8 @@ static int poll_drive(int interruptible, int flag)
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
-	WAIT(floppy_ready);
-	return ret;
+
+	return wait_til_done(floppy_ready, interruptible);
 }
 
 /*
@@ -3038,7 +3034,9 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
 		FDCS->reset = 1;
 	if (FDCS->reset) {
 		cont = &reset_cont;
-		WAIT(reset_fdc);
+		ret = wait_til_done(reset_fdc, interruptible);
+		if (ret == -EINTR)
+			return -EINTR;
 	}
 	process_fd_request();
 	return 0;
-- 
1.6.6.rc0.57.gad7a

