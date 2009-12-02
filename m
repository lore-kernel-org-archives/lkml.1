Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbZLBGJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbZLBGJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 01:09:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbZLBGHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 01:07:54 -0500
Received: from mail.perches.com ([173.55.12.10]:1222 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZLBGHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 01:07:49 -0500
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH 06/13] drivers/block/floppy.c: remove macros CALL, WAIT and IWAIT
Date: Tue,  1 Dec 2009 22:07:46 -0800
Message-Id: <9ce3c99a9d67867a09a33e1d82a5568fc0483704.1259733457.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1259733456.git.joe@perches.com>
References: <cover.1259733456.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obfuscating macros with embedded returns are not nice

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/floppy.c |   19 ++++++++-----------
 1 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9582e4e..9665ab2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1039,11 +1039,6 @@ static DECLARE_WAIT_QUEUE_HEAD(command_done);
 
 #define NO_SIGNAL (!interruptible || !signal_pending(current))
 
-#define CALL(x)		do { if ((x) == -EINTR) return -EINTR; } while (0)
-#define _WAIT(x, i)	CALL(ret = wait_til_done((x), i))
-#define WAIT(x)		_WAIT((x), interruptible)
-#define IWAIT(x)	_WAIT((x), 1)
-
 /* Errors during formatting are counted here. */
 static int format_errors;
 
@@ -2796,7 +2791,9 @@ static int do_format(int drive, struct format_descr *tmp_format_req)
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
@@ -3524,8 +3521,6 @@ static struct cont_t poll_cont = {
 
 static int poll_drive(int interruptible, int flag)
 {
-	int ret;
-
 	/* no auto-sense, just clear dcl */
 	raw_cmd = &default_raw_cmd;
 	raw_cmd->flags = flag;
@@ -3534,8 +3529,8 @@ static int poll_drive(int interruptible, int flag)
 	cont = &poll_cont;
 	debug_dcl(DP->flags, "setting NEWCHANGE in poll_drive\n");
 	set_bit(FD_DISK_NEWCHANGE_BIT, &DRS->flags);
-	WAIT(floppy_ready);
-	return ret;
+
+	return wait_til_done(floppy_ready, interruptible);
 }
 
 /*
@@ -3566,7 +3561,9 @@ static int user_reset_fdc(int drive, int arg, int interruptible)
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

