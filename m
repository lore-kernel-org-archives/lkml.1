Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbXJBPxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbXJBPxZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 11:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753822AbXJBPwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 11:52:30 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:58956 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580AbXJBPw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 11:52:29 -0400
Message-Id: <20071002155219.527920814@szeredi.hu>
References: <20071002155026.650555479@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 02 Oct 2007 17:50:33 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 07/12] fuse: add atomic open+truncate support
Content-Disposition: inline; filename=fuse_atomic_open_truncate.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

This patch allows fuse filesystems to implement open(..., O_TRUNC) as
a single request, instead of separate truncate and open requests.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/dir.c
===================================================================
--- linux.orig/fs/fuse/dir.c	2007-09-26 23:32:53.000000000 +0200
+++ linux/fs/fuse/dir.c	2007-09-27 00:41:38.000000000 +0200
@@ -1083,6 +1083,9 @@ static int fuse_do_setattr(struct dentry
 			return err;
 	}
 
+	if ((attr->ia_valid & ATTR_OPEN) && fc->atomic_o_trunc)
+		return 0;
+
 	if (attr->ia_valid & ATTR_SIZE) {
 		unsigned long limit;
 		if (IS_SWAPFILE(inode))
Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-09-26 23:32:53.000000000 +0200
+++ linux/fs/fuse/file.c	2007-09-27 00:41:41.000000000 +0200
@@ -28,7 +28,9 @@ static int fuse_send_open(struct inode *
 		return PTR_ERR(req);
 
 	memset(&inarg, 0, sizeof(inarg));
-	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
+	if (!fc->atomic_o_trunc)
+		inarg.flags &= ~O_TRUNC;
 	req->in.h.opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
 	req->in.h.nodeid = get_node_id(inode);
 	req->in.numargs = 1;
Index: linux/fs/fuse/fuse_i.h
===================================================================
--- linux.orig/fs/fuse/fuse_i.h	2007-09-26 23:32:53.000000000 +0200
+++ linux/fs/fuse/fuse_i.h	2007-09-27 00:41:40.000000000 +0200
@@ -320,6 +320,9 @@ struct fuse_conn {
 	/** Do readpages asynchronously?  Only set in INIT */
 	unsigned async_read : 1;
 
+	/** Do not send separate SETATTR request before open(O_TRUNC)  */
+	unsigned atomic_o_trunc : 1;
+
 	/*
 	 * The following bitfields are only for optimization purposes
 	 * and hence races in setting them will not cause malfunction
Index: linux/fs/fuse/inode.c
===================================================================
--- linux.orig/fs/fuse/inode.c	2007-09-26 23:32:53.000000000 +0200
+++ linux/fs/fuse/inode.c	2007-09-27 00:41:40.000000000 +0200
@@ -548,6 +548,8 @@ static void process_init_reply(struct fu
 				fc->async_read = 1;
 			if (!(arg->flags & FUSE_POSIX_LOCKS))
 				fc->no_lock = 1;
+			if (arg->flags & FUSE_ATOMIC_O_TRUNC)
+				fc->atomic_o_trunc = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -570,7 +572,8 @@ static void fuse_send_init(struct fuse_c
 	arg->major = FUSE_KERNEL_VERSION;
 	arg->minor = FUSE_KERNEL_MINOR_VERSION;
 	arg->max_readahead = fc->bdi.ra_pages * PAGE_CACHE_SIZE;
-	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS;
+	arg->flags |= FUSE_ASYNC_READ | FUSE_POSIX_LOCKS | FUSE_FILE_OPS |
+		FUSE_ATOMIC_O_TRUNC;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
Index: linux/include/linux/fuse.h
===================================================================
--- linux.orig/include/linux/fuse.h	2007-09-26 23:32:53.000000000 +0200
+++ linux/include/linux/fuse.h	2007-09-27 00:41:47.000000000 +0200
@@ -101,6 +101,7 @@ struct fuse_file_lock {
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
 #define FUSE_FILE_OPS		(1 << 2)
+#define FUSE_ATOMIC_O_TRUNC	(1 << 3)
 
 /**
  * Release flags

--
