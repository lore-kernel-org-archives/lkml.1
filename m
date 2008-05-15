Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYEOTzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYEOTzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762446AbYEOTvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:41 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57990 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762370AbYEOTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:39 -0400
Message-Id: <20080515195106.430304113@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:22 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
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
