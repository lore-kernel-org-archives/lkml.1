Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYKASUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYKASUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 14:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYKASTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 14:19:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58319 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbYKASTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 14:19:51 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] fix O_NONBLOCK in dmasound_core
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1KwL4f-0000St-EW@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 01 Nov 2008 18:19:49 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In 2.3.11-pre3 we had O_NONBLOCK handling broken in dmasound_core - the
original code copied f_flags to open_mode and then checked for O_NONBLOCK
in there, but that got changed to copying f_mode and O_NONBLOCK had not
reached that field in any kernel version.

Since we do not care for any other bits, the fix is obvious...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 sound/oss/dmasound/dmasound.h      |    2 +-
 sound/oss/dmasound/dmasound_core.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/oss/dmasound/dmasound.h b/sound/oss/dmasound/dmasound.h
index 1cb13fe..1308d8d 100644
--- a/sound/oss/dmasound/dmasound.h
+++ b/sound/oss/dmasound/dmasound.h
@@ -235,7 +235,7 @@ struct sound_queue {
      */
     int active;
     wait_queue_head_t action_queue, open_queue, sync_queue;
-    fmode_t open_mode;
+    int non_blocking;
     int busy, syncing, xruns, died;
 };
 
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index b8239f3..793b7f4 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -603,7 +603,7 @@ static ssize_t sq_write(struct file *file, const char __user *src, size_t uLeft,
 	while (uLeft) {
 		while (write_sq.count >= write_sq.max_active) {
 			sq_play();
-			if (write_sq.open_mode & O_NONBLOCK)
+			if (write_sq.non_blocking)
 				return uWritten > 0 ? uWritten : -EAGAIN;
 			SLEEP(write_sq.action_queue);
 			if (signal_pending(current))
@@ -718,7 +718,7 @@ static int sq_open2(struct sound_queue *sq, struct file *file, fmode_t mode,
 			return rc;
 		}
 
-		sq->open_mode = file->f_mode;
+		sq->non_blocking = file->f_flags & O_NONBLOCK;
 	}
 	return rc;
 }
-- 
1.5.6.5


