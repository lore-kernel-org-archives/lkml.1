Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZDNB6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZDNB6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 21:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZDNB4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 21:56:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:56162 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbZDNB4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 21:56:43 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 2/6] FUSE: use fuse objects as the main objects in file handling functions
Date: Tue, 14 Apr 2009 10:54:50 +0900
Message-Id: <1239674094-30894-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674094-30894-1-git-send-email-tj@kernel.org>
References: <1239674094-30894-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 01:55:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generic struct file and/or inode have been used as handle in file
related functions and fuse specific data structures - fuse_file and
fuse_inode - didn't have enough linkage to other objects and thus
couldn't be used as object handles (other objects couldn't be reached
via ff).  This works fine but at times which object is being needed by
a function isn't clear and requires all fuse files to have full
generic filesystem inode/superblock which won't be true for cuse
files.

This patch adds ->fc, ->fi and ->file pointers to struct fuse_file and
replace req->inode with req->fi and use fuse_file and fuse_inode as
the main object handle in file related functions.

Functions which deal with a file now only take a pointer to struct
fuse_file as object handle and deferences all other objects via it.
The following three helpers are added to help non-trivial
dereferencing and ease future changes.

  fuse_file_nodeid(ff)		: get nodeid of @ff
  fuse_file_vfs_inode(ff)	: return generic vfs inode backing @ff
  fuse_file_bad(ff)		: test whether ff's vfs inode is bad

Whenever generic vfs inode is used, it's explicitly named vfs_inode to
distinguish its usage.  vfs_inode is necessary and used only for open,
writeback and locking.

* For functions which take both @file and @inode parameters, it's
  assumed that @file->f_dentry->d_inode == @inode.  For functions
  which get @mapping someway, it's assumed that @file->f_mapping ==
  @mapping.

* fuse_open_common() now takes @fc, @fi, @vfs_inode and initializes
  @ff accordingly.

* fuse_release_common() now takes @ff.  The file->private_data == NULL
  test is moved to its callers and fuse_release_common() is made void.

* fuse_fsync() assumes that @file->f_dentry == @de.

* fuse_readpage() always sets ff->req and fuse_readpages_end() tests
  fc->async_read directly.

* fuse_readpages_fill() now gets struct fuse_req ** instead of struct
  fuse_fill_data *.  fuse_file is dereferenced using req->ff and all
  the rest from the fuse_file.  struct fuse_fill_data is dropped.

* fuse_write_fill() now takes @f_flags instead of @file.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dir.c    |   97 ++++++-----
 fs/fuse/file.c   |  497 ++++++++++++++++++++++++++----------------------------
 fs/fuse/fuse_i.h |   54 +++++--
 3 files changed, 333 insertions(+), 315 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 8b8eebc..63b9546 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -84,9 +84,9 @@ static u64 entry_attr_timeout(struct fuse_entry_out *o)
  * Mark the attributes as stale, so that at the next call to
  * ->getattr() they will be fetched from userspace
  */
-void fuse_invalidate_attr(struct inode *inode)
+void fuse_invalidate_attr(struct fuse_inode *fi)
 {
-	get_fuse_inode(inode)->i_time = 0;
+	fi->i_time = 0;
 }
 
 /*
@@ -408,7 +408,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
 		goto out_put_forget_req;
 
 	err = -ENOMEM;
-	ff = fuse_file_alloc(fc);
+	ff = fuse_file_alloc(fc, NULL, NULL);	/* will set fi and file later */
 	if (!ff)
 		goto out_put_request;
 
@@ -454,17 +454,19 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
 		fuse_send_forget(fc, forget_req, outentry.nodeid, 1);
 		return -ENOMEM;
 	}
+	ff->fi = get_fuse_inode(inode);
 	fuse_put_request(fc, forget_req);
 	d_instantiate(entry, inode);
 	fuse_change_entry_timeout(entry, &outentry);
-	fuse_invalidate_attr(dir);
+	fuse_invalidate_attr(ff->fi);
 	file = lookup_instantiate_filp(nd, entry, generic_file_open);
 	if (IS_ERR(file)) {
 		ff->fh = outopen.fh;
 		fuse_sync_release(fc, ff, outentry.nodeid, flags);
 		return PTR_ERR(file);
 	}
-	fuse_finish_open(inode, file, ff, &outopen);
+	ff->file = file;
+	fuse_finish_open(ff, &outopen);
 	return 0;
 
  out_free_ff:
@@ -540,7 +542,7 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_req *req,
 		d_instantiate(entry, inode);
 
 	fuse_change_entry_timeout(entry, &outarg);
-	fuse_invalidate_attr(dir);
+	fuse_invalidate_attr(get_fuse_inode(dir));
 	return 0;
 
  out_put_forget_req:
@@ -643,8 +645,8 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 		 * lookup/getattr.
 		 */
 		clear_nlink(inode);
-		fuse_invalidate_attr(inode);
-		fuse_invalidate_attr(dir);
+		fuse_invalidate_attr(get_fuse_inode(inode));
+		fuse_invalidate_attr(get_fuse_inode(dir));
 		fuse_invalidate_entry_cache(entry);
 	} else if (err == -EINTR)
 		fuse_invalidate_entry(entry);
@@ -669,7 +671,7 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	fuse_put_request(fc, req);
 	if (!err) {
 		clear_nlink(entry->d_inode);
-		fuse_invalidate_attr(dir);
+		fuse_invalidate_attr(get_fuse_inode(dir));
 		fuse_invalidate_entry_cache(entry);
 	} else if (err == -EINTR)
 		fuse_invalidate_entry(entry);
@@ -702,11 +704,11 @@ static int fuse_rename(struct inode *olddir, struct dentry *oldent,
 	fuse_put_request(fc, req);
 	if (!err) {
 		/* ctime changes */
-		fuse_invalidate_attr(oldent->d_inode);
+		fuse_invalidate_attr(get_fuse_inode(oldent->d_inode));
 
-		fuse_invalidate_attr(olddir);
+		fuse_invalidate_attr(get_fuse_inode(olddir));
 		if (olddir != newdir)
-			fuse_invalidate_attr(newdir);
+			fuse_invalidate_attr(get_fuse_inode(newdir));
 
 		/* newent will end up negative */
 		if (newent->d_inode)
@@ -752,7 +754,7 @@ static int fuse_link(struct dentry *entry, struct inode *newdir,
 	   etc.)
 	*/
 	if (!err || err == -EINTR)
-		fuse_invalidate_attr(inode);
+		fuse_invalidate_attr(get_fuse_inode(inode));
 	return err;
 }
 
@@ -831,21 +833,20 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	return err;
 }
 
-int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+int fuse_update_attributes(struct fuse_inode *fi, struct kstat *stat,
 			   struct file *file, bool *refreshed)
 {
-	struct fuse_inode *fi = get_fuse_inode(inode);
 	int err;
 	bool r;
 
 	if (fi->i_time < get_jiffies_64()) {
 		r = true;
-		err = fuse_do_getattr(inode, stat, file);
+		err = fuse_do_getattr(&fi->inode, stat, file);
 	} else {
 		r = false;
 		err = 0;
 		if (stat) {
-			generic_fillattr(inode, stat);
+			generic_fillattr(&fi->inode, stat);
 			stat->mode = fi->orig_i_mode;
 		}
 	}
@@ -950,7 +951,8 @@ static int fuse_permission(struct inode *inode, int mask)
 	 */
 	if ((fc->flags & FUSE_DEFAULT_PERMISSIONS) ||
 	    ((mask & MAY_EXEC) && S_ISREG(inode->i_mode))) {
-		err = fuse_update_attributes(inode, NULL, NULL, &refreshed);
+		err = fuse_update_attributes(get_fuse_inode(inode), NULL, NULL,
+					     &refreshed);
 		if (err)
 			return err;
 	}
@@ -1016,11 +1018,11 @@ static int fuse_readdir(struct file *file, void *dstbuf, filldir_t filldir)
 	int err;
 	size_t nbytes;
 	struct page *page;
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	req = fuse_get_req(fc);
@@ -1035,7 +1037,7 @@ static int fuse_readdir(struct file *file, void *dstbuf, filldir_t filldir)
 	req->out.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
+	fuse_read_fill(req, ff, file->f_pos, PAGE_SIZE, FUSE_READDIR);
 	fuse_request_send(fc, req);
 	nbytes = req->out.args[0].size;
 	err = req->out.h.error;
@@ -1045,7 +1047,7 @@ static int fuse_readdir(struct file *file, void *dstbuf, filldir_t filldir)
 				    filldir);
 
 	__free_page(page);
-	fuse_invalidate_attr(inode); /* atime changed */
+	fuse_invalidate_attr(ff->fi); /* atime changed */
 	return err;
 }
 
@@ -1078,7 +1080,7 @@ static char *read_link(struct dentry *dentry)
 		link[req->out.args[0].size] = '\0';
  out:
 	fuse_put_request(fc, req);
-	fuse_invalidate_attr(inode); /* atime changed */
+	fuse_invalidate_attr(get_fuse_inode(inode)); /* atime changed */
 	return link;
 }
 
@@ -1101,18 +1103,29 @@ static void fuse_put_link(struct dentry *dentry, struct nameidata *nd, void *c)
 
 static int fuse_dir_open(struct inode *inode, struct file *file)
 {
-	return fuse_open_common(inode, file, 1);
+	return fuse_open_common(get_fuse_conn(inode), get_fuse_inode(inode),
+				inode, file, 1);
 }
 
 static int fuse_dir_release(struct inode *inode, struct file *file)
 {
-	return fuse_release_common(inode, file, 1);
+	struct fuse_file *ff = file->private_data;
+
+	if (ff)
+		fuse_release_common(ff, 1);
+	return 0;	/* return value is ignored by VFS */
 }
 
 static int fuse_dir_fsync(struct file *file, struct dentry *de, int datasync)
 {
+	struct fuse_file *ff;
+
 	/* nfsd can call this with no file */
-	return file ? fuse_fsync_common(file, de, datasync, 1) : 0;
+	if (!file)
+		return 0;
+
+	ff = file->private_data;
+	return fuse_fsync_common(ff, datasync, 1);
 }
 
 static bool update_mtime(unsigned ivalid)
@@ -1163,12 +1176,11 @@ static void iattr_to_fattr(struct iattr *iattr, struct fuse_setattr_in *arg)
  * This is done by adding a negative bias to the inode write counter
  * and waiting for all pending writes to finish.
  */
-void fuse_set_nowrite(struct inode *inode)
+void fuse_set_nowrite(struct fuse_inode *fi)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(&fi->inode);
 
-	BUG_ON(!mutex_is_locked(&inode->i_mutex));
+	BUG_ON(!mutex_is_locked(&fi->inode.i_mutex));
 
 	spin_lock(&fc->lock);
 	BUG_ON(fi->writectr < 0);
@@ -1183,21 +1195,19 @@ void fuse_set_nowrite(struct inode *inode)
  * Remove the bias from the writecounter and send any queued
  * writepages.
  */
-static void __fuse_release_nowrite(struct inode *inode)
+static void __fuse_release_nowrite(struct fuse_inode *fi)
 {
-	struct fuse_inode *fi = get_fuse_inode(inode);
-
 	BUG_ON(fi->writectr != FUSE_NOWRITE);
 	fi->writectr = 0;
-	fuse_flush_writepages(inode);
+	fuse_flush_writepages(fi);
 }
 
-void fuse_release_nowrite(struct inode *inode)
+void fuse_release_nowrite(struct fuse_inode *fi)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = get_fuse_conn(&fi->inode);
 
 	spin_lock(&fc->lock);
-	__fuse_release_nowrite(inode);
+	__fuse_release_nowrite(fi);
 	spin_unlock(&fc->lock);
 }
 
@@ -1214,6 +1224,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 {
 	struct inode *inode = entry->d_inode;
 	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_req *req;
 	struct fuse_setattr_in inarg;
 	struct fuse_attr_out outarg;
@@ -1250,7 +1261,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 		return PTR_ERR(req);
 
 	if (is_truncate)
-		fuse_set_nowrite(inode);
+		fuse_set_nowrite(fi);
 
 	memset(&inarg, 0, sizeof(inarg));
 	memset(&outarg, 0, sizeof(outarg));
@@ -1281,7 +1292,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	fuse_put_request(fc, req);
 	if (err) {
 		if (err == -EINTR)
-			fuse_invalidate_attr(inode);
+			fuse_invalidate_attr(fi);
 		goto error;
 	}
 
@@ -1299,7 +1310,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 
 	if (is_truncate) {
 		/* NOTE: this may release/reacquire fc->lock */
-		__fuse_release_nowrite(inode);
+		__fuse_release_nowrite(fi);
 	}
 	spin_unlock(&fc->lock);
 
@@ -1317,7 +1328,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 
 error:
 	if (is_truncate)
-		fuse_release_nowrite(inode);
+		fuse_release_nowrite(fi);
 
 	return err;
 }
@@ -1339,7 +1350,7 @@ static int fuse_getattr(struct vfsmount *mnt, struct dentry *entry,
 	if (!fuse_allow_task(fc, current))
 		return -EACCES;
 
-	return fuse_update_attributes(inode, stat, NULL, NULL);
+	return fuse_update_attributes(get_fuse_inode(inode), stat, NULL, NULL);
 }
 
 static int fuse_setxattr(struct dentry *entry, const char *name,
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 01c7245..f32d2c8 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -15,10 +15,10 @@
 
 static const struct file_operations fuse_direct_io_file_operations;
 
-static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
+static int fuse_send_open(struct fuse_file *ff, int isdir,
 			  struct fuse_open_out *outargp)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_open_in inarg;
 	struct fuse_req *req;
 	int err;
@@ -28,11 +28,11 @@ static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
 		return PTR_ERR(req);
 
 	memset(&inarg, 0, sizeof(inarg));
-	inarg.flags = file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
+	inarg.flags = ff->file->f_flags & ~(O_CREAT | O_EXCL | O_NOCTTY);
 	if (!fc->atomic_o_trunc)
 		inarg.flags &= ~O_TRUNC;
 	req->in.h.opcode = isdir ? FUSE_OPENDIR : FUSE_OPEN;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
@@ -46,7 +46,8 @@ static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
 	return err;
 }
 
-struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
+struct fuse_file *fuse_file_alloc(struct fuse_conn *fc, struct fuse_inode *fi,
+				  struct file *file)
 {
 	struct fuse_file *ff;
 
@@ -64,6 +65,9 @@ struct fuse_file *fuse_file_alloc(struct fuse_conn *fc)
 	atomic_set(&ff->count, 0);
 	RB_CLEAR_NODE(&ff->polled_node);
 	init_waitqueue_head(&ff->poll_wait);
+	ff->fc = fc;
+	ff->fi = fi;
+	ff->file = file;
 
 	spin_lock(&fc->lock);
 	ff->kh = ++fc->khctr;
@@ -94,30 +98,30 @@ static void fuse_file_put(struct fuse_file *ff)
 {
 	if (atomic_dec_and_test(&ff->count)) {
 		struct fuse_req *req = ff->reserved_req;
-		struct inode *inode = req->misc.release.dentry->d_inode;
-		struct fuse_conn *fc = get_fuse_conn(inode);
+
 		req->end = fuse_release_end;
-		fuse_request_send_background(fc, req);
+		fuse_request_send_background(ff->fc, req);
 		kfree(ff);
 	}
 }
 
-void fuse_finish_open(struct inode *inode, struct file *file,
-		      struct fuse_file *ff, struct fuse_open_out *outarg)
+void fuse_finish_open(struct fuse_file *ff, struct fuse_open_out *outarg)
 {
+	struct inode *vfs_inode = fuse_file_vfs_inode(ff);
+
 	if (outarg->open_flags & FOPEN_DIRECT_IO)
-		file->f_op = &fuse_direct_io_file_operations;
+		ff->file->f_op = &fuse_direct_io_file_operations;
 	if (!(outarg->open_flags & FOPEN_KEEP_CACHE))
-		invalidate_inode_pages2(inode->i_mapping);
+		invalidate_inode_pages2(vfs_inode->i_mapping);
 	if (outarg->open_flags & FOPEN_NONSEEKABLE)
-		nonseekable_open(inode, file);
+		nonseekable_open(vfs_inode, ff->file);
 	ff->fh = outarg->fh;
-	file->private_data = fuse_file_get(ff);
+	ff->file->private_data = fuse_file_get(ff);
 }
 
-int fuse_open_common(struct inode *inode, struct file *file, int isdir)
+int fuse_open_common(struct fuse_conn *fc, struct fuse_inode *fi,
+		     struct inode *vfs_inode, struct file *file, int isdir)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_open_out outarg;
 	struct fuse_file *ff;
 	int err;
@@ -126,21 +130,21 @@ int fuse_open_common(struct inode *inode, struct file *file, int isdir)
 	if (file->f_flags & O_DIRECT)
 		return -EINVAL;
 
-	err = generic_file_open(inode, file);
+	err = generic_file_open(vfs_inode, file);
 	if (err)
 		return err;
 
-	ff = fuse_file_alloc(fc);
+	ff = fuse_file_alloc(fc, fi, file);
 	if (!ff)
 		return -ENOMEM;
 
-	err = fuse_send_open(inode, file, isdir, &outarg);
+	err = fuse_send_open(ff, isdir, &outarg);
 	if (err)
 		fuse_file_free(ff);
 	else {
 		if (isdir)
 			outarg.open_flags &= ~FOPEN_DIRECT_IO;
-		fuse_finish_open(inode, file, ff, &outarg);
+		fuse_finish_open(ff, &outarg);
 	}
 
 	return err;
@@ -160,25 +164,17 @@ void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode)
 	req->in.args[0].value = inarg;
 }
 
-int fuse_release_common(struct inode *inode, struct file *file, int isdir)
+void fuse_release_common(struct fuse_file *ff, int isdir)
 {
-	struct fuse_conn *fc;
-	struct fuse_file *ff;
-	struct fuse_req *req;
-
-	ff = file->private_data;
-	if (unlikely(!ff))
-		return 0;	/* return value is ignored by VFS */
-
-	fc = get_fuse_conn(inode);
-	req = ff->reserved_req;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_req *req = ff->reserved_req;
 
-	fuse_release_fill(ff, get_node_id(inode), file->f_flags,
+	fuse_release_fill(ff, fuse_file_nodeid(ff), ff->file->f_flags,
 			  isdir ? FUSE_RELEASEDIR : FUSE_RELEASE);
 
 	/* Hold vfsmount and dentry until release is finished */
-	req->misc.release.vfsmount = mntget(file->f_path.mnt);
-	req->misc.release.dentry = dget(file->f_path.dentry);
+	req->misc.release.vfsmount = mntget(ff->file->f_path.mnt);
+	req->misc.release.dentry = dget(ff->file->f_path.dentry);
 
 	spin_lock(&fc->lock);
 	list_del(&ff->write_entry);
@@ -193,17 +189,21 @@ int fuse_release_common(struct inode *inode, struct file *file, int isdir)
 	 * the sending will be delayed.
 	 */
 	fuse_file_put(ff);
-	return 0;
 }
 
 static int fuse_open(struct inode *inode, struct file *file)
 {
-	return fuse_open_common(inode, file, 0);
+	return fuse_open_common(get_fuse_conn(inode), get_fuse_inode(inode),
+				inode, file, 0);
 }
 
 static int fuse_release(struct inode *inode, struct file *file)
 {
-	return fuse_release_common(inode, file, 0);
+	struct fuse_file *ff = file->private_data;
+
+	if (ff)
+		fuse_release_common(ff, 0);
+	return 0;	/* return value is ignored by VFS */
 }
 
 /*
@@ -234,10 +234,9 @@ u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id)
  * This is currently done by walking the list of writepage requests
  * for the inode, which can be pretty inefficient.
  */
-static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
+static bool fuse_page_is_writeback(struct fuse_inode *fi, pgoff_t index)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(&fi->inode);
 	struct fuse_req *req;
 	bool found = false;
 
@@ -245,7 +244,7 @@ static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
 	list_for_each_entry(req, &fi->writepages, writepages_entry) {
 		pgoff_t curr_index;
 
-		BUG_ON(req->inode != inode);
+		BUG_ON(req->fi != fi);
 		curr_index = req->misc.write.in.offset >> PAGE_CACHE_SHIFT;
 		if (curr_index == index) {
 			found = true;
@@ -263,24 +262,21 @@ static bool fuse_page_is_writeback(struct inode *inode, pgoff_t index)
  * Since fuse doesn't rely on the VM writeback tracking, this has to
  * use some other means.
  */
-static int fuse_wait_on_page_writeback(struct inode *inode, pgoff_t index)
+static int fuse_wait_on_page_writeback(struct fuse_inode *fi, pgoff_t index)
 {
-	struct fuse_inode *fi = get_fuse_inode(inode);
-
-	wait_event(fi->page_waitq, !fuse_page_is_writeback(inode, index));
+	wait_event(fi->page_waitq, !fuse_page_is_writeback(fi, index));
 	return 0;
 }
 
 static int fuse_flush(struct file *file, fl_owner_t id)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
 	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	struct fuse_flush_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	if (fc->no_flush)
@@ -291,7 +287,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	inarg.fh = ff->fh;
 	inarg.lock_owner = fuse_lock_owner_id(fc, id);
 	req->in.h.opcode = FUSE_FLUSH;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
@@ -315,23 +311,20 @@ static int fuse_flush(struct file *file, fl_owner_t id)
  * This must be called under i_mutex, otherwise the FUSE_NOWRITE usage
  * could conflict with truncation.
  */
-static void fuse_sync_writes(struct inode *inode)
+static void fuse_sync_writes(struct fuse_inode *fi)
 {
-	fuse_set_nowrite(inode);
-	fuse_release_nowrite(inode);
+	fuse_set_nowrite(fi);
+	fuse_release_nowrite(fi);
 }
 
-int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
-		      int isdir)
+int fuse_fsync_common(struct fuse_file *ff, int datasync, int isdir)
 {
-	struct inode *inode = de->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	struct fuse_fsync_in inarg;
 	int err;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	if ((!isdir && fc->no_fsync) || (isdir && fc->no_fsyncdir))
@@ -342,11 +335,11 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 	 * wait for all outstanding writes, before sending the FSYNC
 	 * request.
 	 */
-	err = write_inode_now(inode, 0);
+	err = write_inode_now(fuse_file_vfs_inode(ff), 0);
 	if (err)
 		return err;
 
-	fuse_sync_writes(inode);
+	fuse_sync_writes(ff->fi);
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
@@ -356,7 +349,7 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 	inarg.fh = ff->fh;
 	inarg.fsync_flags = datasync ? 1 : 0;
 	req->in.h.opcode = isdir ? FUSE_FSYNCDIR : FUSE_FSYNC;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
@@ -375,21 +368,23 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 
 static int fuse_fsync(struct file *file, struct dentry *de, int datasync)
 {
-	return fuse_fsync_common(file, de, datasync, 0);
+	struct fuse_file *ff = file->private_data;
+
+	return fuse_fsync_common(ff, datasync, 0);
 }
 
-void fuse_read_fill(struct fuse_req *req, struct file *file,
-		    struct inode *inode, loff_t pos, size_t count, int opcode)
+void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+		    loff_t pos, size_t count, int opcode)
+
 {
 	struct fuse_read_in *inarg = &req->misc.read.in;
-	struct fuse_file *ff = file->private_data;
 
 	inarg->fh = ff->fh;
 	inarg->offset = pos;
 	inarg->size = count;
-	inarg->flags = file->f_flags;
+	inarg->flags = ff->file->f_flags;
 	req->in.h.opcode = opcode;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(struct fuse_read_in);
 	req->in.args[0].value = inarg;
@@ -398,41 +393,38 @@ void fuse_read_fill(struct fuse_req *req, struct file *file,
 	req->out.args[0].size = count;
 }
 
-static size_t fuse_send_read(struct fuse_req *req, struct file *file,
-			     struct inode *inode, loff_t pos, size_t count,
-			     fl_owner_t owner)
+static size_t fuse_send_read(struct fuse_req *req, struct fuse_file *ff,
+			     loff_t pos, size_t count, fl_owner_t owner)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-
-	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, ff, pos, count, FUSE_READ);
 	if (owner != NULL) {
 		struct fuse_read_in *inarg = &req->misc.read.in;
 
 		inarg->read_flags |= FUSE_READ_LOCKOWNER;
-		inarg->lock_owner = fuse_lock_owner_id(fc, owner);
+		inarg->lock_owner = fuse_lock_owner_id(ff->fc, owner);
 	}
-	fuse_request_send(fc, req);
+	fuse_request_send(ff->fc, req);
 	return req->out.args[0].size;
 }
 
-static void fuse_read_update_size(struct inode *inode, loff_t size,
+static void fuse_read_update_size(struct fuse_file *ff, loff_t size,
 				  u64 attr_ver)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_inode *fi = ff->fi;
 
 	spin_lock(&fc->lock);
-	if (attr_ver == fi->attr_version && size < inode->i_size) {
+	if (attr_ver == fi->attr_version && size < fi->inode.i_size) {
 		fi->attr_version = ++fc->attr_version;
-		i_size_write(inode, size);
+		i_size_write(&fi->inode, size);
 	}
 	spin_unlock(&fc->lock);
 }
 
 static int fuse_readpage(struct file *file, struct page *page)
 {
-	struct inode *inode = page->mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	size_t num_read;
 	loff_t pos = page_offset(page);
@@ -441,7 +433,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		goto out;
 
 	/*
@@ -449,7 +441,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	 * page-cache page, so make sure we read a properly synced
 	 * page.
 	 */
-	fuse_wait_on_page_writeback(inode, page->index);
+	fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	req = fuse_get_req(fc);
 	err = PTR_ERR(req);
@@ -462,7 +454,7 @@ static int fuse_readpage(struct file *file, struct page *page)
 	req->out.argpages = 1;
 	req->num_pages = 1;
 	req->pages[0] = page;
-	num_read = fuse_send_read(req, file, inode, pos, count, NULL);
+	num_read = fuse_send_read(req, ff, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
@@ -471,12 +463,12 @@ static int fuse_readpage(struct file *file, struct page *page)
 		 * Short read means EOF.  If file size is larger, truncate it
 		 */
 		if (num_read < count)
-			fuse_read_update_size(inode, pos + num_read, attr_ver);
+			fuse_read_update_size(ff, pos + num_read, attr_ver);
 
 		SetPageUptodate(page);
 	}
 
-	fuse_invalidate_attr(inode); /* atime changed */
+	fuse_invalidate_attr(ff->fi); /* atime changed */
  out:
 	unlock_page(page);
 	return err;
@@ -485,19 +477,19 @@ static int fuse_readpage(struct file *file, struct page *page)
 static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 {
 	int i;
+	struct fuse_file *ff = req->ff;
 	size_t count = req->misc.read.in.size;
 	size_t num_read = req->out.args[0].size;
-	struct inode *inode = req->pages[0]->mapping->host;
 
 	/*
 	 * Short read means EOF.  If file size is larger, truncate it
 	 */
 	if (!req->out.h.error && num_read < count) {
 		loff_t pos = page_offset(req->pages[0]) + num_read;
-		fuse_read_update_size(inode, pos, req->misc.read.attr_ver);
+		fuse_read_update_size(ff, pos, req->misc.read.attr_ver);
 	}
 
-	fuse_invalidate_attr(inode); /* atime changed */
+	fuse_invalidate_attr(ff->fi); /* atime changed */
 
 	for (i = 0; i < req->num_pages; i++) {
 		struct page *page = req->pages[i];
@@ -507,54 +499,49 @@ static void fuse_readpages_end(struct fuse_conn *fc, struct fuse_req *req)
 			SetPageError(page);
 		unlock_page(page);
 	}
-	if (req->ff)
+
+	if (fc->async_read)
 		fuse_file_put(req->ff);
 }
 
-static void fuse_send_readpages(struct fuse_req *req, struct file *file,
-				struct inode *inode)
+static void fuse_send_readpages(struct fuse_req *req, struct fuse_file *ff)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	loff_t pos = page_offset(req->pages[0]);
 	size_t count = req->num_pages << PAGE_CACHE_SHIFT;
 
 	req->out.argpages = 1;
 	req->out.page_zeroing = 1;
-	fuse_read_fill(req, file, inode, pos, count, FUSE_READ);
+	fuse_read_fill(req, ff, pos, count, FUSE_READ);
 	req->misc.read.attr_ver = fuse_get_attr_version(fc);
+
 	if (fc->async_read) {
-		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
 		fuse_request_send_background(fc, req);
 	} else {
+		req->ff = ff;
 		fuse_request_send(fc, req);
 		fuse_readpages_end(fc, req);
 		fuse_put_request(fc, req);
 	}
 }
 
-struct fuse_fill_data {
-	struct fuse_req *req;
-	struct file *file;
-	struct inode *inode;
-};
-
-static int fuse_readpages_fill(void *_data, struct page *page)
+static int fuse_readpages_fill(void *data, struct page *page)
 {
-	struct fuse_fill_data *data = _data;
-	struct fuse_req *req = data->req;
-	struct inode *inode = data->inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_req **reqp = data;
+	struct fuse_req *req = *reqp;
+	struct fuse_file *ff = req->ff;
+	struct fuse_conn *fc = ff->fc;
 
-	fuse_wait_on_page_writeback(inode, page->index);
+	fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	if (req->num_pages &&
 	    (req->num_pages == FUSE_MAX_PAGES_PER_REQ ||
 	     (req->num_pages + 1) * PAGE_CACHE_SIZE > fc->max_read ||
 	     req->pages[req->num_pages - 1]->index + 1 != page->index)) {
-		fuse_send_readpages(req, data->file, inode);
-		data->req = req = fuse_get_req(fc);
+		fuse_send_readpages(req, ff);
+		*reqp = req = fuse_get_req(fc);
 		if (IS_ERR(req)) {
 			unlock_page(page);
 			return PTR_ERR(req);
@@ -568,28 +555,27 @@ static int fuse_readpages_fill(void *_data, struct page *page)
 static int fuse_readpages(struct file *file, struct address_space *mapping,
 			  struct list_head *pages, unsigned nr_pages)
 {
-	struct inode *inode = mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_fill_data data;
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_req *req;
 	int err;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		goto out;
 
-	data.file = file;
-	data.inode = inode;
-	data.req = fuse_get_req(fc);
-	err = PTR_ERR(data.req);
-	if (IS_ERR(data.req))
+	req = fuse_get_req(fc);
+	err = PTR_ERR(req);
+	if (IS_ERR(req))
 		goto out;
 
-	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &data);
+	req->ff = ff;
+	err = read_cache_pages(mapping, pages, fuse_readpages_fill, &req);
 	if (!err) {
-		if (data.req->num_pages)
-			fuse_send_readpages(data.req, file, inode);
+		if (req->num_pages)
+			fuse_send_readpages(req, ff);
 		else
-			fuse_put_request(fc, data.req);
+			fuse_put_request(fc, req);
 	}
 out:
 	return err;
@@ -598,15 +584,16 @@ out:
 static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 				  unsigned long nr_segs, loff_t pos)
 {
-	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct fuse_file *ff = iocb->ki_filp->private_data;
+	struct fuse_inode *fi = ff->fi;
 
-	if (pos + iov_length(iov, nr_segs) > i_size_read(inode)) {
+	if (pos + iov_length(iov, nr_segs) > i_size_read(&fi->inode)) {
 		int err;
 		/*
 		 * If trying to read past EOF, make sure the i_size
 		 * attribute is up-to-date.
 		 */
-		err = fuse_update_attributes(inode, NULL, iocb->ki_filp, NULL);
+		err = fuse_update_attributes(fi, NULL, iocb->ki_filp, NULL);
 		if (err)
 			return err;
 	}
@@ -614,11 +601,11 @@ static ssize_t fuse_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 	return generic_file_aio_read(iocb, iov, nr_segs, pos);
 }
 
-static void fuse_write_fill(struct fuse_req *req, struct file *file,
-			    struct fuse_file *ff, struct inode *inode,
-			    loff_t pos, size_t count, int writepage)
+static void fuse_write_fill(struct fuse_req *req, struct fuse_file *ff,
+			    unsigned int f_flags, loff_t pos, size_t count,
+			    int writepage)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_write_in *inarg = &req->misc.write.in;
 	struct fuse_write_out *outarg = &req->misc.write.out;
 
@@ -627,9 +614,9 @@ static void fuse_write_fill(struct fuse_req *req, struct file *file,
 	inarg->offset = pos;
 	inarg->size = count;
 	inarg->write_flags = writepage ? FUSE_WRITE_CACHE : 0;
-	inarg->flags = file ? file->f_flags : 0;
+	inarg->flags = f_flags;
 	req->in.h.opcode = FUSE_WRITE;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 2;
 	if (fc->minor < 9)
 		req->in.args[0].size = FUSE_COMPAT_WRITE_IN_SIZE;
@@ -642,12 +629,12 @@ static void fuse_write_fill(struct fuse_req *req, struct file *file,
 	req->out.args[0].value = outarg;
 }
 
-static size_t fuse_send_write(struct fuse_req *req, struct file *file,
-			      struct inode *inode, loff_t pos, size_t count,
-			      fl_owner_t owner)
+static size_t fuse_send_write(struct fuse_req *req, struct fuse_file *ff,
+			      loff_t pos, size_t count, fl_owner_t owner)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	fuse_write_fill(req, file, file->private_data, inode, pos, count, 0);
+	struct fuse_conn *fc = ff->fc;
+
+	fuse_write_fill(req, ff, ff->file->f_flags, pos, count, 0);
 	if (owner != NULL) {
 		struct fuse_write_in *inarg = &req->misc.write.in;
 		inarg->write_flags |= FUSE_WRITE_LOCKOWNER;
@@ -669,35 +656,35 @@ static int fuse_write_begin(struct file *file, struct address_space *mapping,
 	return 0;
 }
 
-static void fuse_write_update_size(struct inode *inode, loff_t pos)
+static void fuse_write_update_size(struct fuse_file *ff, loff_t pos)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_inode *fi = ff->fi;
 
 	spin_lock(&fc->lock);
 	fi->attr_version = ++fc->attr_version;
-	if (pos > inode->i_size)
-		i_size_write(inode, pos);
+	if (pos > fi->inode.i_size)
+		i_size_write(&fi->inode, pos);
 	spin_unlock(&fc->lock);
 }
 
-static int fuse_buffered_write(struct file *file, struct inode *inode,
-			       loff_t pos, unsigned count, struct page *page)
+static int fuse_buffered_write(struct fuse_file *ff, loff_t pos, unsigned count,
+			       struct page *page)
 {
 	int err;
 	size_t nres;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	struct fuse_req *req;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	/*
 	 * Make sure writepages on the same page are not mixed up with
 	 * plain writes.
 	 */
-	fuse_wait_on_page_writeback(inode, page->index);
+	fuse_wait_on_page_writeback(ff->fi, page->index);
 
 	req = fuse_get_req(fc);
 	if (IS_ERR(req))
@@ -707,18 +694,18 @@ static int fuse_buffered_write(struct file *file, struct inode *inode,
 	req->num_pages = 1;
 	req->pages[0] = page;
 	req->page_offset = offset;
-	nres = fuse_send_write(req, file, inode, pos, count, NULL);
+	nres = fuse_send_write(req, ff, pos, count, NULL);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err && !nres)
 		err = -EIO;
 	if (!err) {
 		pos += nres;
-		fuse_write_update_size(inode, pos);
+		fuse_write_update_size(ff, pos);
 		if (count == PAGE_CACHE_SIZE)
 			SetPageUptodate(page);
 	}
-	fuse_invalidate_attr(inode);
+	fuse_invalidate_attr(ff->fi);
 	return err ? err : nres;
 }
 
@@ -726,29 +713,28 @@ static int fuse_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	struct inode *inode = mapping->host;
+	struct fuse_file *ff = file->private_data;
 	int res = 0;
 
 	if (copied)
-		res = fuse_buffered_write(file, inode, pos, copied, page);
+		res = fuse_buffered_write(ff, pos, copied, page);
 
 	unlock_page(page);
 	page_cache_release(page);
 	return res;
 }
 
-static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
-				    struct inode *inode, loff_t pos,
-				    size_t count)
+static size_t fuse_send_write_pages(struct fuse_req *req, struct fuse_file *ff,
+				    loff_t pos, size_t count)
 {
 	size_t res;
 	unsigned offset;
 	unsigned i;
 
 	for (i = 0; i < req->num_pages; i++)
-		fuse_wait_on_page_writeback(inode, req->pages[i]->index);
+		fuse_wait_on_page_writeback(ff->fi, req->pages[i]->index);
 
-	res = fuse_send_write(req, file, inode, pos, count, NULL);
+	res = fuse_send_write(req, ff, pos, count, NULL);
 
 	offset = req->page_offset;
 	count = res;
@@ -771,11 +757,11 @@ static size_t fuse_send_write_pages(struct fuse_req *req, struct file *file,
 	return res;
 }
 
-static ssize_t fuse_fill_write_pages(struct fuse_req *req,
-			       struct address_space *mapping,
-			       struct iov_iter *ii, loff_t pos)
+static ssize_t fuse_fill_write_pages(struct fuse_req *req, struct fuse_file *ff,
+				     struct iov_iter *ii, loff_t pos)
 {
-	struct fuse_conn *fc = get_fuse_conn(mapping->host);
+	struct fuse_conn *fc = ff->fc;
+	struct address_space *mapping = ff->file->f_mapping;
 	unsigned offset = pos & (PAGE_CACHE_SIZE - 1);
 	size_t count = 0;
 	int err;
@@ -833,16 +819,14 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 	return count > 0 ? count : err;
 }
 
-static ssize_t fuse_perform_write(struct file *file,
-				  struct address_space *mapping,
-				  struct iov_iter *ii, loff_t pos)
+static ssize_t fuse_perform_write(struct fuse_file *ff, struct iov_iter *ii,
+				  loff_t pos)
 {
-	struct inode *inode = mapping->host;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	int err = 0;
 	ssize_t res = 0;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	do {
@@ -855,14 +839,14 @@ static ssize_t fuse_perform_write(struct file *file,
 			break;
 		}
 
-		count = fuse_fill_write_pages(req, mapping, ii, pos);
+		count = fuse_fill_write_pages(req, ff, ii, pos);
 		if (count <= 0) {
 			err = count;
 		} else {
 			size_t num_written;
 
-			num_written = fuse_send_write_pages(req, file, inode,
-							    pos, count);
+			num_written = fuse_send_write_pages(req, ff, pos,
+							    count);
 			err = req->out.h.error;
 			if (!err) {
 				res += num_written;
@@ -877,9 +861,9 @@ static ssize_t fuse_perform_write(struct file *file,
 	} while (!err && iov_iter_count(ii));
 
 	if (res > 0)
-		fuse_write_update_size(inode, pos);
+		fuse_write_update_size(ff, pos);
 
-	fuse_invalidate_attr(inode);
+	fuse_invalidate_attr(ff->fi);
 
 	return res > 0 ? res : err;
 }
@@ -887,11 +871,11 @@ static ssize_t fuse_perform_write(struct file *file,
 static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 				   unsigned long nr_segs, loff_t pos)
 {
-	struct file *file = iocb->ki_filp;
-	struct address_space *mapping = file->f_mapping;
+	struct fuse_file *ff = iocb->ki_filp->private_data;
+	struct address_space *mapping = ff->file->f_mapping;
 	size_t count = 0;
 	ssize_t written = 0;
-	struct inode *inode = mapping->host;
+	struct inode *vfs_inode = fuse_file_vfs_inode(ff);
 	ssize_t err;
 	struct iov_iter i;
 
@@ -901,33 +885,34 @@ static ssize_t fuse_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
 	if (err)
 		return err;
 
-	mutex_lock(&inode->i_mutex);
-	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
+	mutex_lock(&vfs_inode->i_mutex);
+	vfs_check_frozen(vfs_inode->i_sb, SB_FREEZE_WRITE);
 
 	/* We can write back this queue in page reclaim */
 	current->backing_dev_info = mapping->backing_dev_info;
 
-	err = generic_write_checks(file, &pos, &count, S_ISBLK(inode->i_mode));
+	err = generic_write_checks(ff->file, &pos, &count,
+				   S_ISBLK(vfs_inode->i_mode));
 	if (err)
 		goto out;
 
 	if (count == 0)
 		goto out;
 
-	err = file_remove_suid(file);
+	err = file_remove_suid(ff->file);
 	if (err)
 		goto out;
 
-	file_update_time(file);
+	file_update_time(ff->file);
 
 	iov_iter_init(&i, iov, nr_segs, count, 0);
-	written = fuse_perform_write(file, mapping, &i, pos);
+	written = fuse_perform_write(ff, &i, pos);
 	if (written >= 0)
 		iocb->ki_pos = pos + written;
 
 out:
 	current->backing_dev_info = NULL;
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&vfs_inode->i_mutex);
 
 	return written ? written : err;
 }
@@ -986,17 +971,16 @@ static int fuse_get_user_pages(struct fuse_req *req, const char __user *buf,
 	return 0;
 }
 
-static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
+static ssize_t fuse_direct_io(struct fuse_file *ff, const char __user *buf,
 			      size_t count, loff_t *ppos, int write)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	size_t nmax = write ? fc->max_write : fc->max_read;
 	loff_t pos = *ppos;
 	ssize_t res = 0;
 	struct fuse_req *req;
 
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		return -EIO;
 
 	req = fuse_get_req(fc);
@@ -1013,10 +997,10 @@ static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 		}
 
 		if (write)
-			nres = fuse_send_write(req, file, inode, pos, nbytes,
+			nres = fuse_send_write(req, ff, pos, nbytes,
 					       current->files);
 		else
-			nres = fuse_send_read(req, file, inode, pos, nbytes,
+			nres = fuse_send_read(req, ff, pos, nbytes,
 					      current->files);
 		fuse_release_user_pages(req, !write);
 		if (req->out.h.error) {
@@ -1043,10 +1027,10 @@ static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 	fuse_put_request(fc, req);
 	if (res > 0) {
 		if (write)
-			fuse_write_update_size(inode, pos);
+			fuse_write_update_size(ff, pos);
 		*ppos = pos;
 	}
-	fuse_invalidate_attr(inode);
+	fuse_invalidate_attr(ff->fi);
 
 	return res;
 }
@@ -1054,20 +1038,24 @@ static ssize_t fuse_direct_io(struct file *file, const char __user *buf,
 static ssize_t fuse_direct_read(struct file *file, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
-	return fuse_direct_io(file, buf, count, ppos, 0);
+	struct fuse_file *ff = file->private_data;
+
+	return fuse_direct_io(ff, buf, count, ppos, 0);
 }
 
 static ssize_t fuse_direct_write(struct file *file, const char __user *buf,
 				 size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fuse_file *ff = file->private_data;
+	struct inode *vfs_inode = fuse_file_vfs_inode(ff);
 	ssize_t res;
+
 	/* Don't allow parallel writes to the same file */
-	mutex_lock(&inode->i_mutex);
+	mutex_lock(&vfs_inode->i_mutex);
 	res = generic_write_checks(file, ppos, &count, 0);
 	if (!res)
-		res = fuse_direct_io(file, buf, count, ppos, 1);
-	mutex_unlock(&inode->i_mutex);
+		res = fuse_direct_io(ff, buf, count, ppos, 1);
+	mutex_unlock(&vfs_inode->i_mutex);
 	return res;
 }
 
@@ -1079,9 +1067,8 @@ static void fuse_writepage_free(struct fuse_conn *fc, struct fuse_req *req)
 
 static void fuse_writepage_finish(struct fuse_conn *fc, struct fuse_req *req)
 {
-	struct inode *inode = req->inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
-	struct backing_dev_info *bdi = inode->i_mapping->backing_dev_info;
+	struct fuse_inode *fi = req->fi;
+	struct backing_dev_info *bdi = fi->inode.i_mapping->backing_dev_info;
 
 	list_del(&req->writepages_entry);
 	dec_bdi_stat(bdi, BDI_WRITEBACK);
@@ -1095,8 +1082,8 @@ static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
 __releases(&fc->lock)
 __acquires(&fc->lock)
 {
-	struct fuse_inode *fi = get_fuse_inode(req->inode);
-	loff_t size = i_size_read(req->inode);
+	struct fuse_inode *fi = req->fi;
+	loff_t size = i_size_read(&fi->inode);
 	struct fuse_write_in *inarg = &req->misc.write.in;
 
 	if (!fc->connected)
@@ -1130,12 +1117,11 @@ __acquires(&fc->lock)
  *
  * Called with fc->lock
  */
-void fuse_flush_writepages(struct inode *inode)
+void fuse_flush_writepages(struct fuse_inode *fi)
 __releases(&fc->lock)
 __acquires(&fc->lock)
 {
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_conn *fc = get_fuse_conn(&fi->inode);
 	struct fuse_req *req;
 
 	while (fi->writectr >= 0 && !list_empty(&fi->queued_writes)) {
@@ -1147,10 +1133,9 @@ __acquires(&fc->lock)
 
 static void fuse_writepage_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	struct inode *inode = req->inode;
-	struct fuse_inode *fi = get_fuse_inode(inode);
+	struct fuse_inode *fi = req->fi;
 
-	mapping_set_error(inode->i_mapping, req->out.h.error);
+	mapping_set_error(fi->inode.i_mapping, req->out.h.error);
 	spin_lock(&fc->lock);
 	fi->writectr--;
 	fuse_writepage_finish(fc, req);
@@ -1184,7 +1169,7 @@ static int fuse_writepage_locked(struct page *page)
 	req->ff = fuse_file_get(ff);
 	spin_unlock(&fc->lock);
 
-	fuse_write_fill(req, NULL, ff, inode, page_offset(page), 0, 1);
+	fuse_write_fill(req, ff, 0, page_offset(page), 0, 1);
 
 	copy_highpage(tmp_page, page);
 	req->in.argpages = 1;
@@ -1192,7 +1177,7 @@ static int fuse_writepage_locked(struct page *page)
 	req->pages[0] = tmp_page;
 	req->page_offset = 0;
 	req->end = fuse_writepage_end;
-	req->inode = inode;
+	req->fi = fi;
 
 	inc_bdi_stat(mapping->backing_dev_info, BDI_WRITEBACK);
 	inc_zone_page_state(tmp_page, NR_WRITEBACK_TEMP);
@@ -1201,7 +1186,7 @@ static int fuse_writepage_locked(struct page *page)
 	spin_lock(&fc->lock);
 	list_add(&req->writepages_entry, &fi->writepages);
 	list_add_tail(&req->list, &fi->queued_writes);
-	fuse_flush_writepages(inode);
+	fuse_flush_writepages(fi);
 	spin_unlock(&fc->lock);
 
 	return 0;
@@ -1227,10 +1212,11 @@ static int fuse_launder_page(struct page *page)
 {
 	int err = 0;
 	if (clear_page_dirty_for_io(page)) {
-		struct inode *inode = page->mapping->host;
+		struct fuse_inode *fi = get_fuse_inode(page->mapping->host);
+
 		err = fuse_writepage_locked(page);
 		if (!err)
-			fuse_wait_on_page_writeback(inode, page->index);
+			fuse_wait_on_page_writeback(fi, page->index);
 	}
 	return err;
 }
@@ -1266,9 +1252,9 @@ static int fuse_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	 * Don't use page->mapping as it may become NULL from a
 	 * concurrent truncate.
 	 */
-	struct inode *inode = vma->vm_file->f_mapping->host;
+	struct fuse_inode *fi = get_fuse_inode(vma->vm_file->f_mapping->host);
 
-	fuse_wait_on_page_writeback(inode, page->index);
+	fuse_wait_on_page_writeback(fi, page->index);
 	return 0;
 }
 
@@ -1281,17 +1267,15 @@ static struct vm_operations_struct fuse_file_vm_ops = {
 static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE)) {
-		struct inode *inode = file->f_dentry->d_inode;
-		struct fuse_conn *fc = get_fuse_conn(inode);
-		struct fuse_inode *fi = get_fuse_inode(inode);
 		struct fuse_file *ff = file->private_data;
+		struct fuse_conn *fc = ff->fc;
 		/*
 		 * file may be written through mmap, so chain it onto the
 		 * inodes's write_file list
 		 */
 		spin_lock(&fc->lock);
 		if (list_empty(&ff->write_entry))
-			list_add(&ff->write_entry, &fi->write_files);
+			list_add(&ff->write_entry, &ff->fi->write_files);
 		spin_unlock(&fc->lock);
 	}
 	file_accessed(file);
@@ -1333,13 +1317,11 @@ static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 	return 0;
 }
 
-static void fuse_lk_fill(struct fuse_req *req, struct file *file,
+static void fuse_lk_fill(struct fuse_req *req, struct fuse_file *ff,
 			 const struct file_lock *fl, int opcode, pid_t pid,
 			 int flock)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
-	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_lk_in *arg = &req->misc.lk_in;
 
 	arg->fh = ff->fh;
@@ -1351,16 +1333,15 @@ static void fuse_lk_fill(struct fuse_req *req, struct file *file,
 	if (flock)
 		arg->lk_flags |= FUSE_LK_FLOCK;
 	req->in.h.opcode = opcode;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
 	req->in.args[0].value = arg;
 }
 
-static int fuse_getlk(struct file *file, struct file_lock *fl)
+static int fuse_getlk(struct fuse_file *ff, struct file_lock *fl)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	struct fuse_lk_out outarg;
 	int err;
@@ -1369,7 +1350,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, FUSE_GETLK, 0, 0);
+	fuse_lk_fill(req, ff, fl, FUSE_GETLK, 0, 0);
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
@@ -1382,10 +1363,9 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	return err;
 }
 
-static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
+static int fuse_setlk(struct fuse_file *ff, struct file_lock *fl, int flock)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	int opcode = (fl->fl_flags & FL_SLEEP) ? FUSE_SETLKW : FUSE_SETLK;
 	pid_t pid = fl->fl_type != F_UNLCK ? current->tgid : 0;
@@ -1404,7 +1384,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 
-	fuse_lk_fill(req, file, fl, opcode, pid, flock);
+	fuse_lk_fill(req, ff, fl, opcode, pid, flock);
 	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	/* locking is restartable */
@@ -1416,8 +1396,8 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 
 static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	int err;
 
 	if (cmd == F_CANCELLK) {
@@ -1427,20 +1407,20 @@ static int fuse_file_lock(struct file *file, int cmd, struct file_lock *fl)
 			posix_test_lock(file, fl);
 			err = 0;
 		} else
-			err = fuse_getlk(file, fl);
+			err = fuse_getlk(ff, fl);
 	} else {
 		if (fc->no_lock)
 			err = posix_lock_file(file, fl, NULL);
 		else
-			err = fuse_setlk(file, fl, 0);
+			err = fuse_setlk(ff, fl, 0);
 	}
 	return err;
 }
 
 static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
 	int err;
 
 	if (fc->no_lock) {
@@ -1448,7 +1428,7 @@ static int fuse_file_flock(struct file *file, int cmd, struct file_lock *fl)
 	} else {
 		/* emulate flock with POSIX locks */
 		fl->fl_owner = (fl_owner_t) file;
-		err = fuse_setlk(file, fl, 1);
+		err = fuse_setlk(ff, fl, 1);
 	}
 
 	return err;
@@ -1493,21 +1473,22 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 {
 	loff_t retval;
-	struct inode *inode = file->f_path.dentry->d_inode;
+	struct fuse_file *ff = file->private_data;
+	struct inode *vfs_inode = fuse_file_vfs_inode(ff);
 
-	mutex_lock(&inode->i_mutex);
+	mutex_lock(&vfs_inode->i_mutex);
 	switch (origin) {
 	case SEEK_END:
-		retval = fuse_update_attributes(inode, NULL, file, NULL);
+		retval = fuse_update_attributes(ff->fi, NULL, file, NULL);
 		if (retval)
 			goto exit;
-		offset += i_size_read(inode);
+		offset += i_size_read(vfs_inode);
 		break;
 	case SEEK_CUR:
 		offset += file->f_pos;
 	}
 	retval = -EINVAL;
-	if (offset >= 0 && offset <= inode->i_sb->s_maxbytes) {
+	if (offset >= 0 && offset <= vfs_inode->i_sb->s_maxbytes) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
@@ -1515,7 +1496,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 		retval = offset;
 	}
 exit:
-	mutex_unlock(&inode->i_mutex);
+	mutex_unlock(&vfs_inode->i_mutex);
 	return retval;
 }
 
@@ -1608,12 +1589,10 @@ static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
  * limits ioctl data transfers to well-formed ioctls and is the forced
  * behavior for all FUSE servers.
  */
-static long fuse_file_ioctl_common(struct file *file, unsigned int cmd,
+static long fuse_file_ioctl_common(struct fuse_file *ff, unsigned int cmd,
 				   unsigned long arg, unsigned int flags)
 {
-	struct inode *inode = file->f_dentry->d_inode;
-	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_ioctl_in inarg = {
 		.fh = ff->fh,
 		.cmd = cmd,
@@ -1636,7 +1615,7 @@ static long fuse_file_ioctl_common(struct file *file, unsigned int cmd,
 		return -EACCES;
 
 	err = -EIO;
-	if (is_bad_inode(inode))
+	if (fuse_file_bad(ff))
 		goto out;
 
 	err = -ENOMEM;
@@ -1699,7 +1678,7 @@ static long fuse_file_ioctl_common(struct file *file, unsigned int cmd,
 
 	/* okay, let's send it to the client */
 	req->in.h.opcode = FUSE_IOCTL;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
@@ -1786,13 +1765,17 @@ static long fuse_file_ioctl_common(struct file *file, unsigned int cmd,
 static long fuse_file_ioctl(struct file *file, unsigned int cmd,
 			    unsigned long arg)
 {
-	return fuse_file_ioctl_common(file, cmd, arg, 0);
+	struct fuse_file *ff = file->private_data;
+
+	return fuse_file_ioctl_common(ff, cmd, arg, 0);
 }
 
 static long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
 				   unsigned long arg)
 {
-	return fuse_file_ioctl_common(file, cmd, arg, FUSE_IOCTL_COMPAT);
+	struct fuse_file *ff = file->private_data;
+
+	return fuse_file_ioctl_common(ff, cmd, arg, FUSE_IOCTL_COMPAT);
 }
 
 /*
@@ -1831,9 +1814,10 @@ static struct rb_node **fuse_find_polled_node(struct fuse_conn *fc, u64 kh,
  * not removed before the file is released.  This is because a file
  * polled once is likely to be polled again.
  */
-static void fuse_register_polled_file(struct fuse_conn *fc,
-				      struct fuse_file *ff)
+static void fuse_register_polled_file(struct fuse_file *ff)
 {
+	struct fuse_conn *fc = ff->fc;
+
 	spin_lock(&fc->lock);
 	if (RB_EMPTY_NODE(&ff->polled_node)) {
 		struct rb_node **link, *parent;
@@ -1848,9 +1832,8 @@ static void fuse_register_polled_file(struct fuse_conn *fc,
 
 static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 {
-	struct inode *inode = file->f_dentry->d_inode;
 	struct fuse_file *ff = file->private_data;
-	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_conn *fc = ff->fc;
 	struct fuse_poll_in inarg = { .fh = ff->fh, .kh = ff->kh };
 	struct fuse_poll_out outarg;
 	struct fuse_req *req;
@@ -1867,7 +1850,7 @@ static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 	 */
 	if (waitqueue_active(&ff->poll_wait)) {
 		inarg.flags |= FUSE_POLL_SCHEDULE_NOTIFY;
-		fuse_register_polled_file(fc, ff);
+		fuse_register_polled_file(ff);
 	}
 
 	req = fuse_get_req(fc);
@@ -1875,7 +1858,7 @@ static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 		return PTR_ERR(req);
 
 	req->in.h.opcode = FUSE_POLL;
-	req->in.h.nodeid = get_node_id(inode);
+	req->in.h.nodeid = fuse_file_nodeid(ff);
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 6fc5aed..c9ffaa0 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -102,6 +102,15 @@ struct fuse_file {
 	/** Request reserved for flush and release */
 	struct fuse_req *reserved_req;
 
+	/** The fuse_conn this ff is associated with */
+	struct fuse_conn *fc;
+
+	/** The fuse_inode this ff is associated with */
+	struct fuse_inode *fi;
+
+	/** The VFS file this ff is associated with */
+	struct file *file;
+
 	/** Kernel file handle guaranteed to be unique */
 	u64 kh;
 
@@ -277,7 +286,7 @@ struct fuse_req {
 	struct fuse_file *ff;
 
 	/** Inode used in the request or NULL */
-	struct inode *inode;
+	struct fuse_inode *fi;
 
 	/** Link on fi->writepages */
 	struct list_head writepages_entry;
@@ -490,6 +499,21 @@ static inline u64 get_node_id(struct inode *inode)
 	return get_fuse_inode(inode)->nodeid;
 }
 
+static inline u64 fuse_file_nodeid(struct fuse_file *ff)
+{
+	return ff->fi->nodeid;
+}
+
+static inline struct inode *fuse_file_vfs_inode(struct fuse_file *ff)
+{
+	return ff->file->f_dentry->d_inode;
+}
+
+static inline bool fuse_file_bad(struct fuse_file *ff)
+{
+	return is_bad_inode(fuse_file_vfs_inode(ff));
+}
+
 /** Device operations */
 extern const struct file_operations fuse_dev_operations;
 
@@ -514,18 +538,19 @@ void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
 /**
  * Initialize READ or READDIR request
  */
-void fuse_read_fill(struct fuse_req *req, struct file *file,
-		    struct inode *inode, loff_t pos, size_t count, int opcode);
+void fuse_read_fill(struct fuse_req *req, struct fuse_file *ff,
+		    loff_t pos, size_t count, int opcode);
 
 /**
  * Send OPEN or OPENDIR request
  */
-int fuse_open_common(struct inode *inode, struct file *file, int isdir);
+int fuse_open_common(struct fuse_conn *fc, struct fuse_inode *fi,
+		     struct inode *inode, struct file *file, int isdir);
 
-struct fuse_file *fuse_file_alloc(struct fuse_conn *fc);
+struct fuse_file *fuse_file_alloc(struct fuse_conn *fc, struct fuse_inode *fi,
+				  struct file *file);
 void fuse_file_free(struct fuse_file *ff);
-void fuse_finish_open(struct inode *inode, struct file *file,
-		      struct fuse_file *ff, struct fuse_open_out *outarg);
+void fuse_finish_open(struct fuse_file *ff, struct fuse_open_out *outarg);
 
 /** Fill in ff->reserved_req with a RELEASE request */
 void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode);
@@ -533,13 +558,12 @@ void fuse_release_fill(struct fuse_file *ff, u64 nodeid, int flags, int opcode);
 /**
  * Send RELEASE or RELEASEDIR request
  */
-int fuse_release_common(struct inode *inode, struct file *file, int isdir);
+void fuse_release_common(struct fuse_file *ff, int isdir);
 
 /**
  * Send FSYNC or FSYNCDIR request
  */
-int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
-		      int isdir);
+int fuse_fsync_common(struct fuse_file *ff, int datasync, int isdir);
 
 /**
  * Notify poll wakeup
@@ -643,7 +667,7 @@ void fuse_abort_conn(struct fuse_conn *fc);
 /**
  * Invalidate inode attributes
  */
-void fuse_invalidate_attr(struct inode *inode);
+void fuse_invalidate_attr(struct fuse_inode *fi);
 
 void fuse_invalidate_entry_cache(struct dentry *entry);
 
@@ -684,13 +708,13 @@ int fuse_allow_task(struct fuse_conn *fc, struct task_struct *task);
 
 u64 fuse_lock_owner_id(struct fuse_conn *fc, fl_owner_t id);
 
-int fuse_update_attributes(struct inode *inode, struct kstat *stat,
+int fuse_update_attributes(struct fuse_inode *fi, struct kstat *stat,
 			   struct file *file, bool *refreshed);
 
-void fuse_flush_writepages(struct inode *inode);
+void fuse_flush_writepages(struct fuse_inode *fi);
 
-void fuse_set_nowrite(struct inode *inode);
-void fuse_release_nowrite(struct inode *inode);
+void fuse_set_nowrite(struct fuse_inode *fi);
+void fuse_release_nowrite(struct fuse_inode *fi);
 
 u64 fuse_get_attr_version(struct fuse_conn *fc);
 
-- 
1.6.0.2

