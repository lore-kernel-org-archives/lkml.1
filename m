Return-Path: <linux-kernel-owner+w=401wt.eu-S1765209AbYEFJTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765209AbYEFJTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764260AbYEFJOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:14:39 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59544 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763711AbYEFJOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:14:37 -0400
Message-Id: <20080506091424.412297465@szeredi.hu>
References: <20080506091327.259950960@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Tue, 06 May 2008 11:13:41 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: hch@infradead.org, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: [patch 14/24] vfs: splice remove_suid() cleanup
Content-Disposition: inline; filename=splice_remove_suid_cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

generic_file_splice_write() duplicates remove_suid() just because it
doesn't hold i_mutex.  But it grabs i_mutex inside splice_from_pipe()
anyway, so this is rather pointless.

Move locking to generic_file_splice_write() and call remove_suid() and
__splice_from_pipe() instead.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
CC: Jens Axboe <jens.axboe@oracle.com>
---
 fs/splice.c        |   29 +++++++++++++----------------
 include/linux/fs.h |    1 -
 mm/filemap.c       |    2 +-
 3 files changed, 14 insertions(+), 18 deletions(-)

Index: linux-2.6/fs/splice.c
===================================================================
--- linux-2.6.orig/fs/splice.c	2008-05-06 11:04:28.000000000 +0200
+++ linux-2.6/fs/splice.c	2008-05-06 11:04:37.000000000 +0200
@@ -811,24 +811,19 @@ generic_file_splice_write(struct pipe_in
 {
 	struct address_space *mapping = out->f_mapping;
 	struct inode *inode = mapping->host;
-	int killsuid, killpriv;
+	struct splice_desc sd = {
+		.total_len = len,
+		.flags = flags,
+		.pos = *ppos,
+		.u.file = out,
+	};
 	ssize_t ret;
-	int err = 0;
 
-	killpriv = security_inode_need_killpriv(out->f_path.dentry);
-	killsuid = should_remove_suid(out->f_path.dentry);
-	if (unlikely(killsuid || killpriv)) {
-		mutex_lock(&inode->i_mutex);
-		if (killpriv)
-			err = security_inode_killpriv(out->f_path.dentry);
-		if (!err && killsuid)
-			err = __remove_suid(out->f_path.dentry, killsuid);
-		mutex_unlock(&inode->i_mutex);
-		if (err)
-			return err;
-	}
-
-	ret = splice_from_pipe(pipe, out, ppos, len, flags, pipe_to_file);
+	inode_double_lock(inode, pipe->inode);
+	ret = remove_suid(out->f_path.dentry);
+	if (likely(!ret))
+		ret = __splice_from_pipe(pipe, &sd, pipe_to_file);
+	inode_double_unlock(inode, pipe->inode);
 	if (ret > 0) {
 		unsigned long nr_pages;
 
@@ -840,6 +835,8 @@ generic_file_splice_write(struct pipe_in
 		 * sync it.
 		 */
 		if (unlikely((out->f_flags & O_SYNC) || IS_SYNC(inode))) {
+			int err;
+
 			mutex_lock(&inode->i_mutex);
 			err = generic_osync_inode(inode, mapping,
 						  OSYNC_METADATA|OSYNC_DATA);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2008-05-06 11:04:36.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2008-05-06 11:04:37.000000000 +0200
@@ -1823,7 +1823,6 @@ extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
-extern int __remove_suid(struct dentry *, int);
 extern int should_remove_suid(struct dentry *);
 extern int remove_suid(struct dentry *);
 
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2008-05-06 11:04:28.000000000 +0200
+++ linux-2.6/mm/filemap.c	2008-05-06 11:04:37.000000000 +0200
@@ -1655,7 +1655,7 @@ int should_remove_suid(struct dentry *de
 }
 EXPORT_SYMBOL(should_remove_suid);
 
-int __remove_suid(struct dentry *dentry, int kill)
+static int __remove_suid(struct dentry *dentry, int kill)
 {
 	struct iattr newattrs;
 

--
