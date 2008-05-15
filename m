Return-Path: <linux-kernel-owner+w=401wt.eu-S1764119AbYEOT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764119AbYEOT4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762183AbYEOTvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:31 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57975 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYEOTv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:27 -0400
Message-Id: <20080515195108.088408770@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:23 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Subject: [patch 4/9] locks: allow ->lock() to return FILE_LOCK_DEFERRED
Content-Disposition: inline; filename=locks_allow_async_lock_method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Allow filesystem's ->lock() method to call posix_lock_file() instead
of posix_lock_file_wait(), and return FILE_LOCK_DEFERRED.  This makes
it possible to implement a such a ->lock() function, that works with
the lock manager, which needs the call to be asynchronous.

Now the vfs_lock_file() helper can be used, so this is a cleanup as
well.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: Matthew Wilcox <matthew@wil.cx>
---
 fs/locks.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2008-05-09 14:04:47.000000000 +0200
+++ linux-2.6/fs/locks.c	2008-05-09 14:04:48.000000000 +0200
@@ -1753,21 +1753,16 @@ static int do_lock_file_wait(struct file
 	if (error)
 		return error;
 
-	if (filp->f_op && filp->f_op->lock != NULL)
-		error = filp->f_op->lock(filp, cmd, fl);
-	else {
-		for (;;) {
-			error = posix_lock_file(filp, fl, NULL);
-			if (error != FILE_LOCK_DEFERRED)
-				break;
-			error = wait_event_interruptible(fl->fl_wait,
-							 !fl->fl_next);
-			if (!error)
-				continue;
-
-			locks_delete_block(fl);
+	for (;;) {
+		error = vfs_lock_file(filp, cmd, fl, NULL);
+		if (error != FILE_LOCK_DEFERRED)
 			break;
-		}
+		error = wait_event_interruptible(fl->fl_wait, !fl->fl_next);
+		if (!error)
+			continue;
+
+		locks_delete_block(fl);
+		break;
 	}
 
 	return error;

--
