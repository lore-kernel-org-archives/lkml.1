Return-Path: <linux-kernel-owner+w=401wt.eu-S1765727AbYEIMpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765727AbYEIMpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 08:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbYEIMl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 08:41:56 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59665 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761715AbYEIMlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 08:41:50 -0400
Message-Id: <20080509124129.744762296@szeredi.hu>
References: <20080509124107.645600519@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Fri, 09 May 2008 14:41:10 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: [patch 3/9] locks: cleanup code duplication
Content-Disposition: inline; filename=locks_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Extract common code into a function.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Matthew Wilcox <matthew@wil.cx>
---
 fs/locks.c |   71 ++++++++++++++++++++++++++-----------------------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2008-05-09 14:04:46.000000000 +0200
+++ linux-2.6/fs/locks.c	2008-05-09 14:04:47.000000000 +0200
@@ -1744,6 +1744,35 @@ int vfs_lock_file(struct file *filp, uns
 }
 EXPORT_SYMBOL_GPL(vfs_lock_file);
 
+static int do_lock_file_wait(struct file *filp, unsigned int cmd,
+			     struct file_lock *fl)
+{
+	int error;
+
+	error = security_file_lock(filp, fl->fl_type);
+	if (error)
+		return error;
+
+	if (filp->f_op && filp->f_op->lock != NULL)
+		error = filp->f_op->lock(filp, cmd, fl);
+	else {
+		for (;;) {
+			error = posix_lock_file(filp, fl, NULL);
+			if (error != FILE_LOCK_DEFERRED)
+				break;
+			error = wait_event_interruptible(fl->fl_wait,
+							 !fl->fl_next);
+			if (!error)
+				continue;
+
+			locks_delete_block(fl);
+			break;
+		}
+	}
+
+	return error;
+}
+
 /* Apply the lock described by l to an open file descriptor.
  * This implements both the F_SETLK and F_SETLKW commands of fcntl().
  */
@@ -1801,26 +1830,7 @@ again:
 		goto out;
 	}
 
-	error = security_file_lock(filp, file_lock->fl_type);
-	if (error)
-		goto out;
-
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(file_lock);
-			break;
-		}
-	}
+	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
 	 * Attempt to detect a close/fcntl race and recover by
@@ -1938,26 +1948,7 @@ again:
 		goto out;
 	}
 
-	error = security_file_lock(filp, file_lock->fl_type);
-	if (error)
-		goto out;
-
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, file_lock);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, file_lock, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(file_lock->fl_wait,
-					!file_lock->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(file_lock);
-			break;
-		}
-	}
+	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
 	 * Attempt to detect a close/fcntl race and recover by

--
