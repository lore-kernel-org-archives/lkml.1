Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbXJOS3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbXJOS3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXJOS2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:28:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:54357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760841AbXJOS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:28:49 -0400
Message-ID: <4713B1E7.2010504@suse.com>
Date: Mon, 15 Oct 2007 14:31:03 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
       Laurent Riffard <laurent.riffard@free.fr>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
Subject: Re: 2.6.23-mm1: BUG in reiserfs_delete_xattrs
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <47129992.4040903@free.fr> <20071015084052.GA21870@infradead.org>
In-Reply-To: <20071015084052.GA21870@infradead.org>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Oct 15, 2007 at 12:34:58AM +0200, Laurent Riffard wrote:
>> reiserfs_delete_xattrs
>> reiserfs_delete_inode
>> generic_delete_inode
>> generic_drop_inode
>> iput
>> do_unlinkat
>> sys_unlink
>> sys_enter_past_esp
>>
>> I reported a similar BUG in 2.6.22-rc8-mm2 (see
>> http://lkml.org/lkml/2007/9/27/235). Dave Hansen sent a patch for it, I
>> tested it and it was OK for 2.6.22-rc8-mm2.
>>
>> I tried this patch on 2.6.23-mm1, and it fixed the BUGs here too.
> 
> The delete path is a similar case as the one Dave fixed, also cause by
> a NULL vfsmount passed to dentry_open, but through a different code-path.
> 
> Untested fix for this problem below:

Here's a patch I worked up the other night that kills off struct file
completely from the xattr code. I've tested it locally.


 After several posts and bug reports regarding interaction with the NULL
 nameidata, here's a patch to clean up the mess with struct file in the
 reiserfs xattr code.

 As observed in several of the posts, there's really no need for struct file
 to exist in the xattr code. It was really only passed around due to the
 f_op->readdir() and a_ops->{prepare,commit}_write prototypes requiring it.

 reiserfs_prepare_write() and reiserfs_commit_write() don't actually use
 the struct file passed to it, and the xattr code uses a private version of
 reiserfs_readdir() to enumerate the xattr directories.

 I do have patches in my queue to convert the xattrs to use reiserfs_readdir(),
 but I guess I'll just have to rework those.

 This is pretty close to the patch by Dave Hansen for -mm, but I didn't
 notice it until after I wrote this up.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 fs/reiserfs/xattr.c |  111 ++++++++++++++--------------------------------------
 1 file changed, 31 insertions(+), 80 deletions(-)

--- a/fs/reiserfs/xattr.c	2007-08-27 14:03:39.000000000 -0400
+++ b/fs/reiserfs/xattr.c	2007-10-14 22:11:05.000000000 -0400
@@ -191,28 +191,11 @@ static struct dentry *get_xa_file_dentry
 	dput(xadir);
 	if (err)
 		xafile = ERR_PTR(err);
-	return xafile;
-}
-
-/* Opens a file pointer to the attribute associated with inode */
-static struct file *open_xa_file(const struct inode *inode, const char *name,
-				 int flags)
-{
-	struct dentry *xafile;
-	struct file *fp;
-
-	xafile = get_xa_file_dentry(inode, name, flags);
-	if (IS_ERR(xafile))
-		return ERR_PTR(PTR_ERR(xafile));
 	else if (!xafile->d_inode) {
 		dput(xafile);
-		return ERR_PTR(-ENODATA);
+		xafile = ERR_PTR(-ENODATA);
 	}
-
-	fp = dentry_open(xafile, NULL, O_RDWR);
-	/* dentry_open dputs the dentry if it fails */
-
-	return fp;
+	return xafile;
 }
 
 /*
@@ -228,9 +211,8 @@ static struct file *open_xa_file(const s
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
@@ -374,23 +356,16 @@ static int __xattr_readdir(struct file *
  *
  */
 static
-int xattr_readdir(struct file *file, filldir_t filler, void *buf)
+int xattr_readdir(struct inode *inode, filldir_t filler, void *buf)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	int res = -ENOTDIR;
-	if (!file->f_op || !file->f_op->readdir)
-		goto out;
+	int res = -ENOENT;
 	mutex_lock_nested(&inode->i_mutex, I_MUTEX_XATTR);
-//        down(&inode->i_zombie);
-	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
 		lock_kernel();
-		res = __xattr_readdir(file, buf, filler);
+		res = __xattr_readdir(inode, buf, filler);
 		unlock_kernel();
 	}
-//        up(&inode->i_zombie);
 	mutex_unlock(&inode->i_mutex);
-      out:
 	return res;
 }
 
@@ -436,7 +411,7 @@ reiserfs_xattr_set(struct inode *inode, 
 		   size_t buffer_size, int flags)
 {
 	int err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	struct page *page;
 	char *data;
 	struct address_space *mapping;
@@ -454,18 +429,18 @@ reiserfs_xattr_set(struct inode *inode, 
 		xahash = xattr_hash(buffer, buffer_size);
 
       open_file:
-	fp = open_xa_file(inode, name, flags);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, flags);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
 	/* we need to copy it off.. */
 	if (xinode->i_nlink > 1) {
-		fput(fp);
+		dput(dentry);
 		err = reiserfs_xattr_del(inode, name);
 		if (err < 0)
 			goto out;
@@ -479,7 +454,7 @@ reiserfs_xattr_set(struct inode *inode, 
 	newattrs.ia_size = buffer_size;
 	newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 	mutex_lock(&xinode->i_mutex);
-	err = notify_change(fp->f_path.dentry, &newattrs);
+	err = notify_change(dentry, &newattrs);
 	if (err)
 		goto out_filp;
 
@@ -512,15 +487,15 @@ reiserfs_xattr_set(struct inode *inode, 
 			rxh->h_hash = cpu_to_le32(xahash);
 		}
 
-		err = mapping->a_ops->prepare_write(fp, page, page_offset,
+		err = mapping->a_ops->prepare_write(NULL, page, page_offset,
 						    page_offset + chunk + skip);
 		if (!err) {
 			if (buffer)
 				memcpy(data + skip, buffer + buffer_pos, chunk);
-			err =
-			    mapping->a_ops->commit_write(fp, page, page_offset,
-							 page_offset + chunk +
-							 skip);
+			err = mapping->a_ops->commit_write(NULL, page,
+			                                   page_offset,
+			                                   page_offset + chunk +
+			                                   skip);
 		}
 		unlock_page(page);
 		reiserfs_put_page(page);
@@ -542,7 +517,7 @@ reiserfs_xattr_set(struct inode *inode, 
 
       out_filp:
 	mutex_unlock(&xinode->i_mutex);
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -556,7 +531,7 @@ reiserfs_xattr_get(const struct inode *i
 		   size_t buffer_size)
 {
 	ssize_t err = 0;
-	struct file *fp;
+	struct dentry *dentry;
 	size_t isize;
 	size_t file_pos = 0;
 	size_t buffer_pos = 0;
@@ -572,13 +547,13 @@ reiserfs_xattr_get(const struct inode *i
 	if (get_inode_sd_version(inode) == STAT_DATA_V1)
 		return -EOPNOTSUPP;
 
-	fp = open_xa_file(inode, name, FL_READONLY);
-	if (IS_ERR(fp)) {
-		err = PTR_ERR(fp);
+	dentry = get_xa_file_dentry(inode, name, FL_READONLY);
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
 		goto out;
 	}
 
-	xinode = fp->f_path.dentry->d_inode;
+	xinode = dentry->d_inode;
 	isize = xinode->i_size;
 	REISERFS_I(inode)->i_flags |= i_has_xattr_dir;
 
@@ -646,7 +621,7 @@ reiserfs_xattr_get(const struct inode *i
 	}
 
       out_dput:
-	fput(fp);
+	dput(dentry);
 
       out:
 	return err;
@@ -736,7 +711,6 @@ reiserfs_delete_xattrs_filler(void *buf,
 /* This is called w/ inode->i_mutex downed */
 int reiserfs_delete_xattrs(struct inode *inode)
 {
-	struct file *fp;
 	struct dentry *dir, *root;
 	int err = 0;
 
@@ -757,15 +731,8 @@ int reiserfs_delete_xattrs(struct inode 
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
@@ -785,7 +752,7 @@ int reiserfs_delete_xattrs(struct inode 
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	if (!err)
@@ -827,7 +794,6 @@ reiserfs_chown_xattrs_filler(void *buf, 
 
 int reiserfs_chown_xattrs(struct inode *inode, struct iattr *attrs)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_chown_buf buf;
@@ -851,13 +817,6 @@ int reiserfs_chown_xattrs(struct inode *
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
@@ -865,7 +824,7 @@ int reiserfs_chown_xattrs(struct inode *
 	buf.attrs = attrs;
 	buf.inode = inode;
 
-	err = xattr_readdir(fp, reiserfs_chown_xattrs_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_chown_xattrs_filler, &buf);
 	if (err) {
 		unlock_kernel();
 		goto out_dir;
@@ -875,7 +834,7 @@ int reiserfs_chown_xattrs(struct inode *
 	unlock_kernel();
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	attrs->ia_valid = ia_valid;
@@ -1023,7 +982,6 @@ reiserfs_listxattr_filler(void *buf, con
  */
 ssize_t reiserfs_listxattr(struct dentry * dentry, char *buffer, size_t size)
 {
-	struct file *fp;
 	struct dentry *dir;
 	int err = 0;
 	struct reiserfs_listxattr_buf buf;
@@ -1046,13 +1004,6 @@ ssize_t reiserfs_listxattr(struct dentry
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
@@ -1060,7 +1011,7 @@ ssize_t reiserfs_listxattr(struct dentry
 
 	REISERFS_I(dentry->d_inode)->i_flags |= i_has_xattr_dir;
 
-	err = xattr_readdir(fp, reiserfs_listxattr_filler, &buf);
+	err = xattr_readdir(dir->d_inode, reiserfs_listxattr_filler, &buf);
 	if (err)
 		goto out_dir;
 
@@ -1070,7 +1021,7 @@ ssize_t reiserfs_listxattr(struct dentry
 		err = buf.r_pos;
 
       out_dir:
-	fput(fp);
+	dput(dir);
 
       out:
 	reiserfs_read_unlock_xattr_i(dentry->d_inode);



-- 
Jeff Mahoney
SUSE Labs
