Return-Path: <linux-kernel-owner+w=401wt.eu-S1759011AbXJOIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759011AbXJOIlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 04:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756033AbXJOIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 04:41:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38849 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754160AbXJOIlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 04:41:00 -0400
Date: Mon, 15 Oct 2007 09:40:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
Message-ID: <20071015084052.GA21870@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Laurent Riffard <laurent.riffard@free.fr>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47129992.4040903@free.fr>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2007 at 12:34:58AM +0200, Laurent Riffard wrote:
> reiserfs_delete_xattrs
> reiserfs_delete_inode
> generic_delete_inode
> generic_drop_inode
> iput
> do_unlinkat
> sys_unlink
> sys_enter_past_esp
> 
> I reported a similar BUG in 2.6.22-rc8-mm2 (see
> http://lkml.org/lkml/2007/9/27/235). Dave Hansen sent a patch for it, I
> tested it and it was OK for 2.6.22-rc8-mm2.
> 
> I tried this patch on 2.6.23-mm1, and it fixed the BUGs here too.

The delete path is a similar case as the one Dave fixed, also cause by
a NULL vfsmount passed to dentry_open, but through a different code-path.

Untested fix for this problem below:

Index: linux-2.6.23-rc8/fs/reiserfs/xattr.c
===================================================================
--- linux-2.6.23-rc8.orig/fs/reiserfs/xattr.c	2007-09-30 14:13:46.000000000 +0200
+++ linux-2.6.23-rc8/fs/reiserfs/xattr.c	2007-09-30 14:18:30.000000000 +0200
@@ -207,9 +207,8 @@ static struct dentry *get_xa_file_dentry
  * we're called with i_mutex held, so there are no worries about the directory
  * changing underneath us.
  */
-static int __xattr_readdir(struct file *filp, void *dirent, filldir_t filldir)
+static int __xattr_readdir(struct inode *inode, void *dirent, filldir_t filldir)
 {
-	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct cpu_key pos_key;	/* key of current position in the directory (key of directory entry) */
 	INITIALIZE_PATH(path_to_entry);
 	struct buffer_head *bh;
@@ -352,24 +351,19 @@ static int __xattr_readdir(struct file *
  * this is stolen from vfs_readdir
  *
  */
-static
-int xattr_readdir(struct file *file, filldir_t filler, void *buf)
+static int xattr_readdir(struct inode *inode, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
 	int res = -ENOTDIR;
-	if (!file->f_op || !file->f_op->readdir)
-		goto out;
+
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_XATTR);
-//        down(&inode->i_zombie);
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
 		lock_kernel();
-		res = __xattr_readdir(file, buf, filler);
+		res = __xattr_readdir(inode, buf, filler);
 		unlock_kernel();
 	}
-//        up(&inode->i_zombie);
 	mutex_unlock(&inode->i_mutex);
-      out:
+
 	return res;
 }
 
@@ -721,7 +715,6 @@ reiserfs_delete_xattrs_filler(void *buf,
 /* This is called w/ inode->i_mutex downed */
 int reiserfs_delete_xattrs(struct inode *inode)
 {
-	struct file *fp;
 	struct dentry *dir, *root;
 	int err = 0;
 
@@ -742,15 +735,8 @@ int reiserfs_delete_xattrs(struct inode 
 		return 0;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	lock_kernel();
-	err = xattr_readdir(fp, reiserfs_delete_xattrs_filler, dir);
+	err = xattr_readdir(dir->d_inode, reiserfs_delete_xattrs_filler, dir);
 	if (err) {
 		unlock_kernel();
 		goto out_dir;
@@ -770,7 +756,7 @@ int reiserfs_delete_xattrs(struct inode 
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	if (!err)
@@ -812,7 +798,6 @@ reiserfs_chown_xattrs_filler(void *buf, 
 
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_chown_buf buf;
@@ -836,13 +821,6 @@ int reiserfs_chown_xattrs(struct inode *
 		goto out;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	lock_kernel();
 
 	attrs->ia_valid &= (ATTR_UID | ATTR_GID | ATTR_CTIME);
@@ -850,7 +828,7 @@ int reiserfs_chown_xattrs(struct inode *
 	buf.attrs = attrs;
 	buf.inode = inode;
 
-	err = xattr_readdir(fp, reiserfs_chown_xattrs_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_chown_xattrs_filler, &buf);
 	if (err) {
 		unlock_kernel();
 		goto out_dir;
@@ -860,7 +838,7 @@ int reiserfs_chown_xattrs(struct inode *
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	attrs->ia_valid = ia_valid;
@@ -1008,7 +986,6 @@ reiserfs_listxattr_filler(void *buf, con
  */
 ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_listxattr_buf buf;
@@ -1031,13 +1008,6 @@ ssize_t reiserfs_listxattr(struct dentry
 		goto out;
 	}
 
-	fp = dentry_open(dir, NULL, O_RDWR);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
-		/* dentry_open dputs the dentry if it fails */
-		goto out;
-	}
-
 	buf.r_buf = buffer;
 	buf.r_size = buffer ? size : 0;
 	buf.r_pos = 0;
@@ -1045,7 +1015,7 @@ ssize_t reiserfs_listxattr(struct dentry
 
 	REISERFS_I(dentry->d_inode)->i_flags |= i_has_xattr_dir;
 
-	err = xattr_readdir(fp, reiserfs_listxattr_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_listxattr_filler, &buf);
 	if (err)
 		goto out_dir;
 
@@ -1055,7 +1025,7 @@ ssize_t reiserfs_listxattr(struct dentry
 		err = buf.r_pos;
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	reiserfs_read_unlock_xattr_i(dentry->d_inode);
