Return-Path: <linux-kernel-owner+w=401wt.eu-S1764698AbYEOTy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698AbYEOTy2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762338AbYEOTvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:51:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57987 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759200AbYEOTve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:51:34 -0400
Message-Id: <20080515195114.643959372@szeredi.hu>
References: <20080515195019.754545421@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 15 May 2008 21:50:28 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch 9/9] fuse: lockd support
Content-Disposition: inline; filename=fuse_async_lock.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

If fuse filesystem doesn't define it's own lock operations, then allow
the lock manager to work with fuse.

Adding lockd support for remote locking is also possible, but more
difficult, because of the need handle lock cancellation.  It's also
rarely used, so leave it till later.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/file.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2008-05-09 14:04:45.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2008-05-09 14:04:52.000000000 +0200
@@ -1341,6 +1341,11 @@ static int fuse_setlk(struct file *file,
 	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
 	int err;
 
+	if (fl->fl_lmops && fl->fl_lmops->fl_grant) {
+		/* NLM needs asynchronous locks, which we don't support yet */
+		return -ENOLCK;
+	}
+
 	/* Unlock on close is handled by the flush method */
 	if (fl->fl_flags & FL_CLOSE)
 		return 0;
@@ -1365,7 +1370,9 @@ static int fuse_file_lock(struct file *f
 	struct fuse_conn *fc = get_fuse_conn(inode);
 	int err;
 
-	if (cmd == F_GETLK) {
+	if (cmd == F_CANCELLK) {
+		err = 0;
+	} else if (cmd == F_GETLK) {
 		if (fc->no_lock) {
 			posix_test_lock(file, fl);
 			err = 0;
@@ -1373,7 +1380,7 @@ static int fuse_file_lock(struct file *f
 			err = fuse_getlk(file, fl);
 	} else {
 		if (fc->no_lock)
-			err = posix_lock_file_wait(file, fl);
+			err = posix_lock_file(file, fl, NULL);
 		else
 			err = fuse_setlk(file, fl, 0);
 	}

--
