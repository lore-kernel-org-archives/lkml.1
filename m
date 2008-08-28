Return-Path: <linux-kernel-owner+w=401wt.eu-S1756891AbYH1SU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891AbYH1SU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 14:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756558AbYH1SUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 14:20:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:41683 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbYH1SUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 14:20:30 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] FUSE: add fuse_ prefix to several functions
Date: Fri, 29 Aug 2008 03:19:00 +0900
Message-Id: <1219947544-666-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219947544-666-1-git-send-email-tj@kernel.org>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 18:20:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add fuse_ prefix to request_send*() and get_root_inode() as some of
those functions will be exported for CUSE.  With or without CUSE
export, having the function names scoped is a good idea for
debuggability.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/dev.c    |   23 ++++++++++++-----------
 fs/fuse/dir.c    |   34 +++++++++++++++++-----------------
 fs/fuse/file.c   |   30 +++++++++++++++---------------
 fs/fuse/fuse_i.h |    9 +++++----
 fs/fuse/inode.c  |   12 ++++++------
 5 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1c422f9..b448dfd 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -380,7 +380,7 @@ static void request_wait_answer(struct fuse_conn *fc, struct fuse_req *req)
 	}
 }
 
-void request_send(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->isreply = 1;
 	spin_lock(&fc->lock);
@@ -399,8 +399,8 @@ void request_send(struct fuse_conn *fc, struct fuse_req *req)
 	spin_unlock(&fc->lock);
 }
 
-static void request_send_nowait_locked(struct fuse_conn *fc,
-				       struct fuse_req *req)
+static void fuse_request_send_nowait_locked(struct fuse_conn *fc,
+					    struct fuse_req *req)
 {
 	req->background = 1;
 	fc->num_background++;
@@ -414,11 +414,11 @@ static void request_send_nowait_locked(struct fuse_conn *fc,
 	flush_bg_queue(fc);
 }
 
-static void request_send_nowait(struct fuse_conn *fc, struct fuse_req *req)
+static void fuse_request_send_nowait(struct fuse_conn *fc, struct fuse_req *req)
 {
 	spin_lock(&fc->lock);
 	if (fc->connected) {
-		request_send_nowait_locked(fc, req);
+		fuse_request_send_nowait_locked(fc, req);
 		spin_unlock(&fc->lock);
 	} else {
 		req->out.h.error = -ENOTCONN;
@@ -426,16 +426,16 @@ static void request_send_nowait(struct fuse_conn *fc, struct fuse_req *req)
 	}
 }
 
-void request_send_noreply(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_request_send_noreply(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->isreply = 0;
-	request_send_nowait(fc, req);
+	fuse_request_send_nowait(fc, req);
 }
 
-void request_send_background(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_request_send_background(struct fuse_conn *fc, struct fuse_req *req)
 {
 	req->isreply = 1;
-	request_send_nowait(fc, req);
+	fuse_request_send_nowait(fc, req);
 }
 
 /*
@@ -443,10 +443,11 @@ void request_send_background(struct fuse_conn *fc, struct fuse_req *req)
  *
  * fc->connected must have been checked previously
  */
-void request_send_background_locked(struct fuse_conn *fc, struct fuse_req *req)
+void fuse_request_send_background_locked(struct fuse_conn *fc,
+					 struct fuse_req *req)
 {
 	req->isreply = 1;
-	request_send_nowait_locked(fc, req);
+	fuse_request_send_nowait_locked(fc, req);
 }
 
 /*
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index fd03330..fa28925 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -189,7 +189,7 @@ static int fuse_dentry_revalidate(struct dentry *entry, struct nameidata *nd)
 		parent = dget_parent(entry);
 		fuse_lookup_init(fc, req, get_node_id(parent->d_inode),
 				 &entry->d_name, &outarg);
-		request_send(fc, req);
+		fuse_request_send(fc, req);
 		dput(parent);
 		err = req->out.h.error;
 		fuse_put_request(fc, req);
@@ -283,7 +283,7 @@ int fuse_lookup_name(struct super_block *sb, u64 nodeid, struct qstr *name,
 	attr_version = fuse_get_attr_version(fc);
 
 	fuse_lookup_init(fc, req, nodeid, name, outarg);
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	/* Zero nodeid is same as -ENOENT, but with valid timeout */
@@ -369,7 +369,7 @@ static void fuse_sync_release(struct fuse_conn *fc, struct fuse_file *ff,
 {
 	fuse_release_fill(ff, nodeid, flags, FUSE_RELEASE);
 	ff->reserved_req->force = 1;
-	request_send(fc, ff->reserved_req);
+	fuse_request_send(fc, ff->reserved_req);
 	fuse_put_request(fc, ff->reserved_req);
 	kfree(ff);
 }
@@ -432,7 +432,7 @@ static int fuse_create_open(struct inode *dir, struct dentry *entry, int mode,
 	req->out.args[0].value = &outentry;
 	req->out.args[1].size = sizeof(outopen);
 	req->out.args[1].value = &outopen;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	if (err) {
 		if (err == -ENOSYS)
@@ -502,7 +502,7 @@ static int create_new_entry(struct fuse_conn *fc, struct fuse_req *req,
 	else
 		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err)
@@ -631,7 +631,7 @@ static int fuse_unlink(struct inode *dir, struct dentry *entry)
 	req->in.numargs = 1;
 	req->in.args[0].size = entry->d_name.len + 1;
 	req->in.args[0].value = entry->d_name.name;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
@@ -662,7 +662,7 @@ static int fuse_rmdir(struct inode *dir, struct dentry *entry)
 	req->in.numargs = 1;
 	req->in.args[0].size = entry->d_name.len + 1;
 	req->in.args[0].value = entry->d_name.name;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
@@ -695,7 +695,7 @@ static int fuse_rename(struct inode *olddir, struct dentry *oldent,
 	req->in.args[1].value = oldent->d_name.name;
 	req->in.args[2].size = newent->d_name.len + 1;
 	req->in.args[2].value = newent->d_name.name;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
@@ -811,7 +811,7 @@ static int fuse_do_getattr(struct inode *inode, struct kstat *stat,
 	else
 		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err) {
@@ -904,7 +904,7 @@ static int fuse_access(struct inode *inode, int mask)
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS) {
@@ -1026,7 +1026,7 @@ static int fuse_readdir(struct file *file, void *dstbuf, filldir_t filldir)
 	req->num_pages = 1;
 	req->pages[0] = page;
 	fuse_read_fill(req, file, inode, file->f_pos, PAGE_SIZE, FUSE_READDIR);
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	nbytes = req->out.args[0].size;
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
@@ -1060,7 +1060,7 @@ static char *read_link(struct dentry *dentry)
 	req->out.numargs = 1;
 	req->out.args[0].size = PAGE_SIZE - 1;
 	req->out.args[0].value = link;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	if (req->out.h.error) {
 		free_page((unsigned long) link);
 		link = ERR_PTR(req->out.h.error);
@@ -1266,7 +1266,7 @@ static int fuse_do_setattr(struct dentry *entry, struct iattr *attr,
 	else
 		req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err) {
@@ -1360,7 +1360,7 @@ static int fuse_setxattr(struct dentry *entry, const char *name,
 	req->in.args[1].value = name;
 	req->in.args[2].size = size;
 	req->in.args[2].value = value;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS) {
@@ -1406,7 +1406,7 @@ static ssize_t fuse_getxattr(struct dentry *entry, const char *name,
 		req->out.args[0].size = sizeof(outarg);
 		req->out.args[0].value = &outarg;
 	}
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	ret = req->out.h.error;
 	if (!ret)
 		ret = size ? req->out.args[0].size : outarg.size;
@@ -1456,7 +1456,7 @@ static ssize_t fuse_listxattr(struct dentry *entry, char *list, size_t size)
 		req->out.args[0].size = sizeof(outarg);
 		req->out.args[0].value = &outarg;
 	}
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	ret = req->out.h.error;
 	if (!ret)
 		ret = size ? req->out.args[0].size : outarg.size;
@@ -1489,7 +1489,7 @@ static int fuse_removexattr(struct dentry *entry, const char *name)
 	req->in.numargs = 1;
 	req->in.args[0].size = strlen(name) + 1;
 	req->in.args[0].value = name;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS) {
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5d704e3..40895ed 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -39,7 +39,7 @@ static int fuse_send_open(struct inode *inode, struct file *file, int isdir,
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(*outargp);
 	req->out.args[0].value = outargp;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
@@ -91,7 +91,7 @@ static void fuse_file_put(struct fuse_file *ff)
 		struct inode *inode = req->misc.release.dentry->d_inode;
 		struct fuse_conn *fc = get_fuse_conn(inode);
 		req->end = fuse_release_end;
-		request_send_background(fc, req);
+		fuse_request_send_background(fc, req);
 		kfree(ff);
 	}
 }
@@ -286,7 +286,7 @@ static int fuse_flush(struct file *file, fl_owner_t id)
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
 	req->force = 1;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS) {
@@ -350,7 +350,7 @@ int fuse_fsync_common(struct file *file, struct dentry *de, int datasync,
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(inarg);
 	req->in.args[0].value = &inarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS) {
@@ -403,7 +403,7 @@ static size_t fuse_send_read(struct fuse_req *req, struct file *file,
 	}
 	if (file->f_flags & O_NONBLOCK)
 		inarg->read_flags |= FUSE_READ_NONBLOCK;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	return req->out.args[0].size;
 }
 
@@ -516,9 +516,9 @@ static void fuse_send_readpages(struct fuse_req *req, struct file *file,
 		struct fuse_file *ff = file->private_data;
 		req->ff = fuse_file_get(ff);
 		req->end = fuse_readpages_end;
-		request_send_background(fc, req);
+		fuse_request_send_background(fc, req);
 	} else {
-		request_send(fc, req);
+		fuse_request_send(fc, req);
 		fuse_readpages_end(fc, req);
 	}
 }
@@ -646,7 +646,7 @@ static size_t fuse_send_write(struct fuse_req *req, struct file *file,
 	}
 	if (file->f_flags & O_NONBLOCK)
 		inarg->write_flags |= FUSE_WRITE_NONBLOCK;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	return req->misc.write.out.size;
 }
 
@@ -1089,7 +1089,7 @@ static void fuse_send_writepage(struct fuse_conn *fc, struct fuse_req *req)
 
 	req->in.args[1].size = inarg->size;
 	fi->writectr++;
-	request_send_background_locked(fc, req);
+	fuse_request_send_background_locked(fc, req);
 	return;
 
  out_free:
@@ -1335,7 +1335,7 @@ static int fuse_getlk(struct file *file, struct file_lock *fl)
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (!err)
@@ -1367,7 +1367,7 @@ static int fuse_setlk(struct file *file, struct file_lock *fl, int flock)
 		return PTR_ERR(req);
 
 	fuse_lk_fill(req, file, fl, opcode, pid, flock);
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	/* locking is restartable */
 	if (err == -EINTR)
@@ -1443,7 +1443,7 @@ static sector_t fuse_bmap(struct address_space *mapping, sector_t block)
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 	if (err == -ENOSYS)
@@ -1483,7 +1483,7 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 		req->out.numargs = 1;
 		req->out.args[0].size = sizeof(outarg);
 		req->out.args[0].value = &outarg;
-		request_send(fc, req);
+		fuse_request_send(fc, req);
 		err = req->out.h.error;
 		fuse_put_request(fc, req);
 
@@ -1681,7 +1681,7 @@ static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
 	req->out.argpages = 1;
 	req->out.argvar = 1;
 
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	transferred = req->out.args[1].size;
 	fuse_put_request(fc, req);
@@ -1847,7 +1847,7 @@ static unsigned fuse_file_poll(struct file *file, poll_table *wait)
 	req->out.numargs = 1;
 	req->out.args[0].size = sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	fuse_put_request(fc, req);
 
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index f884160..c5c11d7 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -619,19 +619,20 @@ void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req);
 /**
  * Send a request (synchronous)
  */
-void request_send(struct fuse_conn *fc, struct fuse_req *req);
+void fuse_request_send(struct fuse_conn *fc, struct fuse_req *req);
 
 /**
  * Send a request with no reply
  */
-void request_send_noreply(struct fuse_conn *fc, struct fuse_req *req);
+void fuse_request_send_noreply(struct fuse_conn *fc, struct fuse_req *req);
 
 /**
  * Send a request in the background
  */
-void request_send_background(struct fuse_conn *fc, struct fuse_req *req);
+void fuse_request_send_background(struct fuse_conn *fc, struct fuse_req *req);
 
-void request_send_background_locked(struct fuse_conn *fc, struct fuse_req *req);
+void fuse_request_send_background_locked(struct fuse_conn *fc,
+					 struct fuse_req *req);
 
 /* Abort all requests */
 void fuse_abort_conn(struct fuse_conn *fc);
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 088ba6e..c8806bb 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -94,7 +94,7 @@ void fuse_send_forget(struct fuse_conn *fc, struct fuse_req *req,
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(struct fuse_forget_in);
 	req->in.args[0].value = inarg;
-	request_send_noreply(fc, req);
+	fuse_request_send_noreply(fc, req);
 }
 
 static void fuse_clear_inode(struct inode *inode)
@@ -269,7 +269,7 @@ static void fuse_send_destroy(struct fuse_conn *fc)
 		fc->destroy_req = NULL;
 		req->in.h.opcode = FUSE_DESTROY;
 		req->force = 1;
-		request_send(fc, req);
+		fuse_request_send(fc, req);
 		fuse_put_request(fc, req);
 	}
 }
@@ -334,7 +334,7 @@ static int fuse_statfs(struct dentry *dentry, struct kstatfs *buf)
 	req->out.args[0].size =
 		fc->minor < 4 ? FUSE_COMPAT_STATFS_SIZE : sizeof(outarg);
 	req->out.args[0].value = &outarg;
-	request_send(fc, req);
+	fuse_request_send(fc, req);
 	err = req->out.h.error;
 	if (!err)
 		convert_fuse_statfs(buf, &outarg.st);
@@ -543,7 +543,7 @@ struct fuse_conn *fuse_conn_get(struct fuse_conn *fc)
 	return fc;
 }
 
-static struct inode *get_root_inode(struct super_block *sb, unsigned mode)
+static struct inode *fuse_get_root_inode(struct super_block *sb, unsigned mode)
 {
 	struct fuse_attr attr;
 	memset(&attr, 0, sizeof(attr));
@@ -797,7 +797,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 	req->out.args[0].size = sizeof(struct fuse_init_out);
 	req->out.args[0].value = &req->misc.init_out;
 	req->end = process_init_reply;
-	request_send_background(fc, req);
+	fuse_request_send_background(fc, req);
 }
 
 static int fuse_fill_super(struct super_block *sb, void *data, int silent)
@@ -851,7 +851,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_fs_info = fc;
 
 	err = -ENOMEM;
-	root = get_root_inode(sb, d.rootmode);
+	root = fuse_get_root_inode(sb, d.rootmode);
 	if (!root)
 		goto err;
 
-- 
1.5.4.5

