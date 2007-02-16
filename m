Return-Path: <linux-kernel-owner+w=401wt.eu-S1945915AbXBPPhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945915AbXBPPhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:37:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945941AbXBPPhY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:37:24 -0500
Received: from ms-smtp-02.texas.rr.com ([24.93.47.41]:34554 "EHLO
	ms-smtp-02.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945915AbXBPPhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:37:20 -0500
From: Eric Van Hensbergen <ericvh@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: v9fs-developer@lists.sourceforge.net,
       Eric Van Hensbergen <ericvh@gmail.com>
Subject: [PATCH] 9p: add write-cache support to loose cache mode (take 3)
Date: Fri, 16 Feb 2007 09:37:01 -0600
Message-Id: <1171640221420-git-send-email-ericvh@gmail.com>
X-Mailer: git-send-email 1.5.0.rc1.gde38
In-Reply-To: <11715506591894-git-send-email-ericvh@gmail.com>
References: <11715506591894-git-send-email-ericvh@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loose cache mode was added primarily to asssist exclusive, read-only
mounts (like venti) -- however, there is also a case for using loose
write cacheing in support of read/write exclusive mounts.  This feature
is linked to the loose cache option and is disabled by default.

This code adds the necessary code to support writes through the page
cache.  Write caches are not used for synthetic files or for files opened
in APPEND mode.

Signed-of-by: Eric Van Hensbergen <ericvh@gmail.com>
---
 fs/9p/9p.h        |    2 +-
 fs/9p/conv.c      |   18 +++++-
 fs/9p/conv.h      |    2 +-
 fs/9p/fcall.c     |   10 ++-
 fs/9p/fid.c       |   16 +++---
 fs/9p/fid.h       |    2 +-
 fs/9p/v9fs_vfs.h  |    2 +
 fs/9p/vfs_addr.c  |  183 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 fs/9p/vfs_dir.c   |    2 +-
 fs/9p/vfs_file.c  |   61 ++++++++++++++----
 fs/9p/vfs_inode.c |   20 +++++-
 fs/9p/vfs_super.c |    3 +-
 12 files changed, 275 insertions(+), 46 deletions(-)

diff --git a/fs/9p/9p.h b/fs/9p/9p.h
index 94e2f92..6f8edf0 100644
--- a/fs/9p/9p.h
+++ b/fs/9p/9p.h
@@ -370,6 +370,6 @@ int v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid,
 		u64 offset, u32 count, struct v9fs_fcall **rcall);
 
 int v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
-		 u32 count, const char __user * data,
+		 u32 count, const char __user * data, char * kdata,
 		 struct v9fs_fcall **rcall);
 int v9fs_printfcall(char *, int, struct v9fs_fcall *, int);
diff --git a/fs/9p/conv.c b/fs/9p/conv.c
index a3ed571..9bb075a 100644
--- a/fs/9p/conv.c
+++ b/fs/9p/conv.c
@@ -458,6 +458,15 @@ v9fs_put_user_data(struct cbuf *bufp, const char __user * data, int count,
 	return copy_from_user(*pdata, data, count);
 }
 
+static int
+v9fs_put_kernel_data(struct cbuf *bufp, char * kdata, int count,
+		   unsigned char **pdata)
+{
+	*pdata = buf_alloc(bufp, count);
+	memcpy(*pdata, kdata, count);
+	return 0;
+}
+
 static void
 v9fs_put_wstat(struct cbuf *bufp, struct v9fs_wstat *wstat,
 	       struct v9fs_stat *stat, int statsz, int extended)
@@ -723,7 +732,7 @@ struct v9fs_fcall *v9fs_create_tread(u32 fid, u64 offset, u32 count)
 }
 
 struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
-				      const char __user * data)
+				      const char __user * data, char * kdata)
 {
 	int size, err;
 	struct v9fs_fcall *fc;
@@ -738,7 +747,12 @@ struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
 	v9fs_put_int32(bufp, fid, &fc->params.twrite.fid);
 	v9fs_put_int64(bufp, offset, &fc->params.twrite.offset);
 	v9fs_put_int32(bufp, count, &fc->params.twrite.count);
-	err = v9fs_put_user_data(bufp, data, count, &fc->params.twrite.data);
+	if(data)
+		err = v9fs_put_user_data(bufp, data, count,
+						&fc->params.twrite.data);
+	else
+		err = v9fs_put_kernel_data(bufp, kdata, count,
+						&fc->params.twrite.data);
 	if (err) {
 		kfree(fc);
 		fc = ERR_PTR(err);
diff --git a/fs/9p/conv.h b/fs/9p/conv.h
index dd5b6b1..8091672 100644
--- a/fs/9p/conv.h
+++ b/fs/9p/conv.h
@@ -42,7 +42,7 @@ struct v9fs_fcall *v9fs_create_tcreate(u32 fid, char *name, u32 perm, u8 mode,
 	char *extension, int extended);
 struct v9fs_fcall *v9fs_create_tread(u32 fid, u64 offset, u32 count);
 struct v9fs_fcall *v9fs_create_twrite(u32 fid, u64 offset, u32 count,
-	const char __user *data);
+	const char __user *data, char *kdata);
 struct v9fs_fcall *v9fs_create_tclunk(u32 fid);
 struct v9fs_fcall *v9fs_create_tremove(u32 fid);
 struct v9fs_fcall *v9fs_create_tstat(u32 fid);
diff --git a/fs/9p/fcall.c b/fs/9p/fcall.c
index dc336a6..ca77839 100644
--- a/fs/9p/fcall.c
+++ b/fs/9p/fcall.c
@@ -367,7 +367,7 @@ v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
 	int ret;
 	struct v9fs_fcall *tc, *rc;
 
-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
+	dprintk(DEBUG_9P, "fid %d offset 0x%llx count 0x%x\n", fid,
 		(long long unsigned) offset, count);
 
 	tc = v9fs_create_tread(fid, offset, count);
@@ -393,21 +393,23 @@ v9fs_t_read(struct v9fs_session_info *v9ses, u32 fid, u64 offset,
  * @fid: fid to write to
  * @offset: offset to start write at
  * @count: how many bytes to write
+ * @data: userspace data
+ * @kdata: kernelspace data
  * @fcall: pointer to response fcall
  *
  */
 
 int
 v9fs_t_write(struct v9fs_session_info *v9ses, u32 fid, u64 offset, u32 count,
-	const char __user *data, struct v9fs_fcall **rcp)
+	const char __user *data, char *kdata, struct v9fs_fcall **rcp)
 {
 	int ret;
 	struct v9fs_fcall *tc, *rc;
 
-	dprintk(DEBUG_9P, "fid %d offset 0x%llux count 0x%x\n", fid,
+	dprintk(DEBUG_9P, "fid %d offset 0x%llx count 0x%x\n", fid,
 		(long long unsigned) offset, count);
 
-	tc = v9fs_create_twrite(fid, offset, count, data);
+	tc = v9fs_create_twrite(fid, offset, count, data, kdata);
 	if (!IS_ERR(tc)) {
 		ret = v9fs_mux_rpc(v9ses->mux, tc, &rc);
 
diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 9041971..47dd950 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -40,19 +40,18 @@
  *
  */
 
-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry)
+int v9fs_fid_insert(struct v9fs_fid *fid, void **priv)
 {
-	struct list_head *fid_list = (struct list_head *)dentry->d_fsdata;
-	dprintk(DEBUG_9P, "fid %d (%p) dentry %s (%p)\n", fid->fid, fid,
-		dentry->d_iname, dentry);
-	if (dentry->d_fsdata == NULL) {
-		dentry->d_fsdata =
+	struct list_head *fid_list= (struct list_head *) *priv;
+
+	if (fid_list == NULL) {
+		*priv =
 		    kmalloc(sizeof(struct list_head), GFP_KERNEL);
-		if (dentry->d_fsdata == NULL) {
+		if (*priv == NULL) {
 			dprintk(DEBUG_ERROR, "Out of memory\n");
 			return -ENOMEM;
 		}
-		fid_list = (struct list_head *)dentry->d_fsdata;
+		fid_list = (struct list_head *)*priv;
 		INIT_LIST_HEAD(fid_list);	/* Initialize list head */
 	}
 
@@ -80,6 +79,7 @@ struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *v9ses, int fid)
 
 	new->fid = fid;
 	new->v9ses = v9ses;
+	new->filp = NULL;
 	new->fidopen = 0;
 	new->fidclunked = 0;
 	new->iounit = 0;
diff --git a/fs/9p/fid.h b/fs/9p/fid.h
index 48fc170..dd19181 100644
--- a/fs/9p/fid.h
+++ b/fs/9p/fid.h
@@ -56,7 +56,7 @@ struct v9fs_fid *v9fs_fid_lookup(struct dentry *dentry);
 struct v9fs_fid *v9fs_fid_get_created(struct dentry *);
 void v9fs_fid_destroy(struct v9fs_fid *fid);
 struct v9fs_fid *v9fs_fid_create(struct v9fs_session_info *, int fid);
-int v9fs_fid_insert(struct v9fs_fid *fid, struct dentry *dentry);
+int v9fs_fid_insert(struct v9fs_fid *fid, void **priv);
 struct v9fs_fid *v9fs_fid_clone(struct dentry *dentry);
 void v9fs_fid_clunk(struct v9fs_session_info *v9ses, struct v9fs_fid *fid);
 
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index 8ada4c5..36b21ef 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -44,6 +44,7 @@ extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_dir_operations;
 extern struct dentry_operations v9fs_dentry_operations;
 extern struct dentry_operations v9fs_cached_dentry_operations;
+extern const struct inode_operations v9fs_cached_file_inode_operations;
 
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
 ino_t v9fs_qid2ino(struct v9fs_qid *qid);
@@ -53,3 +54,4 @@ int v9fs_file_open(struct inode *inode, struct file *file);
 void v9fs_inode2stat(struct inode *inode, struct v9fs_stat *stat);
 void v9fs_dentry_release(struct dentry *);
 int v9fs_uflags2omode(int uflags);
+ssize_t v9fs_write(struct file *filp, const char __user * data, char * kdata, size_t count, loff_t * offset);
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index bed48fa..9ae7a08 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -6,6 +6,9 @@
  *  Copyright (C) 2005 by Eric Van Hensbergen <ericvh@gmail.com>
  *  Copyright (C) 2002 by Ron Minnich <rminnich@lanl.gov>
  *
+ *  Some operations based on code from fs/cifs/file.c
+ *  Copyright (C) International Business Machines  Corp., 2002,2003
+ *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License version 2
  *  as published by the Free Software Foundation.
@@ -41,14 +44,14 @@
 #include "fid.h"
 
 /**
- * v9fs_vfs_readpage - read an entire page in from 9P
+ * v9fs_vfs_readpage_worker - read an entire page in from 9P
  *
  * @file: file being read
  * @page: structure to page
  *
  */
 
-static int v9fs_vfs_readpage(struct file *filp, struct page *page)
+static int v9fs_vfs_readpage_worker(struct file *filp, struct page *page)
 {
 	char *buffer = NULL;
 	int retval = -EIO;
@@ -63,21 +66,18 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 	int total = 0;
 	int result = 0;
 
-	dprintk(DEBUG_VFS, "\n");
-
+	page_cache_get(page);
 	buffer = kmap(page);
 	do {
 		if (count < rsize)
 			rsize = count;
 
 		result = v9fs_t_read(v9ses, fid, offset, rsize, &fcall);
-
 		if (result < 0) {
-			printk(KERN_ERR "v9fs_t_read returned %d\n",
-			       result);
+			printk(KERN_ERR "v9fs_t_read returned %d\n", result);
 
 			kfree(fcall);
-			goto UnmapAndUnlock;
+			goto io_error;
 		} else
 			offset += result;
 
@@ -98,12 +98,175 @@ static int v9fs_vfs_readpage(struct file *filp, struct page *page)
 	SetPageUptodate(page);
 	retval = 0;
 
-UnmapAndUnlock:
+      io_error:
+	kunmap(page);
+	page_cache_release(page);
+	return retval;
+}
+
+/**
+ * v9fs_prepare_write - prepare for mmap or page-cache I/O
+ *
+ * @file: file being read
+ * @page: structure to page
+ * @from: starting offset
+ * @to: ending offset
+ *
+ */
+
+int v9fs_prepare_write(struct file *file, struct page *page,
+		       unsigned from, unsigned to)
+{
+	if(!PageUptodate(page)) {
+		if (to - from != PAGE_CACHE_SIZE) {
+			void *kaddr = kmap_atomic(page, KM_USER0);
+			memset(kaddr, 0, from);
+			memset(kaddr + to, 0, PAGE_CACHE_SIZE - to);
+			flush_dcache_page(page);
+			kunmap_atomic(kaddr, KM_USER0);
+		}
+		if ((file->f_flags & O_ACCMODE) != O_WRONLY)
+			v9fs_vfs_readpage_worker(file, page);
+	}
+
+	return 0;
+}
+
+/**
+ * v9fs_commit_write - prepare for mmap or page-cache I/O
+ *
+ * @file: file being read
+ * @page: structure to page
+ * @offset: starting offset
+ * @to: ending offset
+ *
+ * TODO: Perhaps I should just do the write here?
+ */
+
+int v9fs_commit_write(struct file *file, struct page *page,
+		       unsigned offset, unsigned to)
+{
+        struct inode *inode = page->mapping->host;
+        loff_t pos = ((loff_t)page->index << PAGE_CACHE_SHIFT) + to;
+
+	dprintk(DEBUG_VFS, "\n");
+
+	if(!PageUptodate(page))
+		SetPageUptodate(page);
+
+        /*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold the i_mutex.
+	 *
+	 */
+        if (pos > inode->i_size)
+                i_size_write(inode, pos);
+        set_page_dirty(page);
+	dprintk(DEBUG_CURRENT, "inode->size: %llx\n",inode->i_size);
+
+	return 0;
+}
+
+
+
+/**
+ * v9fs_vfs_readpage - read an entire page in from 9P
+ *
+ * @file: file being read
+ * @page: structure to page
+ *
+ */
+
+static int v9fs_vfs_readpage(struct file *filp, struct page *page)
+{
+	int retval;
+
+	dprintk(DEBUG_VFS, "\n");
+
+	retval = v9fs_vfs_readpage_worker(filp, page);
+
+	unlock_page(page);
+	return retval;
+}
+
+/**
+ * v9fs_find_file - find a file pointer based on page
+ * @page: page to lookup file based on
+ *
+ */
+static struct file *v9fs_find_file(struct page *page)
+{
+	struct inode *inode = page->mapping->host;
+	struct v9fs_fid *fid = NULL;
+	struct list_head *p;
+
+	dprintk(DEBUG_VFS, " page: %p\n", page);
+
+	p = inode->i_private;
+	if (!p) {
+		dprintk(DEBUG_ERROR, "No list_head\n");
+		return NULL;
+	}
+
+	fid = list_entry(p->next, struct v9fs_fid, list);
+
+	if (fid)
+		return fid->filp;
+
+	dprintk(DEBUG_VFS, " filp not found for page: %p\n", page);
+	return NULL;
+}
+
+/**
+ * v9fs_vfs_writepage - write a mmaped page to server
+ * @page: page to write
+ * @wbc: writeback control
+ *
+ */
+
+static int v9fs_vfs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	char *buffer = NULL;
+	struct address_space *mapping = page->mapping;
+	int retval = -EIO;
+	loff_t offset = 0;
+	pgoff_t end_index;
+	int count = PAGE_CACHE_SIZE;
+	struct file *filp = v9fs_find_file(page);
+	struct inode *inode = mapping->host;
+
+	dprintk(DEBUG_VFS, "page: %p\n", page);
+
+	if ((!inode) || (!filp))
+		goto UnlockPage;
+
+	end_index = inode->i_size >> PAGE_CACHE_SHIFT;
+
+	/* complicated case at end of file */
+	if (page->index >= end_index) {
+		/* things got complicated... */
+		count = inode->i_size & (PAGE_CACHE_SIZE - 1);
+		if (page->index >= end_index + 1 || !count)
+			return 0;	/* truncated - don't care */
+	}
+
+	buffer = kmap(page);
+	offset = ((loff_t) page->index << PAGE_CACHE_SHIFT);
+	page_cache_get(page);
+	retval = v9fs_write(filp, NULL, buffer, count, &offset);
+
 	kunmap(page);
+
+      UnlockPage:
 	unlock_page(page);
+	page_cache_release(page);
+
 	return retval;
 }
 
 const struct address_space_operations v9fs_addr_operations = {
-      .readpage = v9fs_vfs_readpage,
+	.prepare_write = v9fs_prepare_write,
+	.commit_write = v9fs_commit_write,
+	.readpage = v9fs_vfs_readpage,
+	.writepage = v9fs_vfs_writepage,
 };
diff --git a/fs/9p/vfs_dir.c b/fs/9p/vfs_dir.c
index 3129688..9dbf50c 100644
--- a/fs/9p/vfs_dir.c
+++ b/fs/9p/vfs_dir.c
@@ -197,7 +197,7 @@ int v9fs_dir_release(struct inode *inode, struct file *filp)
 			dprintk(DEBUG_ERROR, "clunk failed\n");
 
 		kfree(fid->rdir_fcall);
-		kfree(fid);
+		v9fs_fid_destroy(fid);
 
 		filp->private_data = NULL;
 	}
diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index 653dfa5..5ed22e4 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -79,13 +79,16 @@ int v9fs_file_open(struct inode *inode, struct file *file)
 	vfid->filp = file;
 	kfree(fcall);
 
-	if((vfid->qid.version) && (v9ses->cache)) {
-		dprintk(DEBUG_VFS, "cached");
+	if((vfid->qid.version) && (v9ses->cache) && !(file->f_flags&O_APPEND)) {
 		/* enable cached file options */
-		if(file->f_op == &v9fs_file_operations)
+		if(file->f_op == &v9fs_file_operations) {
 			file->f_op = &v9fs_cached_file_operations;
+			inode->i_op = &v9fs_cached_file_inode_operations;
+		}
 	}
 
+         v9fs_fid_insert(vfid, &inode->i_private);
+
 	return 0;
 
 Clunk_Fid:
@@ -187,17 +190,18 @@ v9fs_file_read(struct file *filp, char __user * data, size_t count,
 }
 
 /**
- * v9fs_file_write - write to a file
+ * v9fs_write - write to a file  (generic)
  * @filep: file pointer to write
- * @data: data buffer to write data from
+ * @data: user data buffer to write data from
+ * @kdata: kernel data buffer to write data from
  * @count: size of buffer
  * @offset: offset at which to write data
  *
  */
 
-static ssize_t
-v9fs_file_write(struct file *filp, const char __user * data,
-		size_t count, loff_t * offset)
+ssize_t
+v9fs_write(struct file *filp, const char __user * data,
+		char* kdata, size_t count, loff_t * offset)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
 	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
@@ -208,8 +212,8 @@ v9fs_file_write(struct file *filp, const char __user * data,
 	int rsize = 0;
 	int total = 0;
 
-	dprintk(DEBUG_VFS, "data %p count %d offset %x\n", data, (int)count,
-		(int)*offset);
+	dprintk(DEBUG_VFS, "count %d offset %x\n",
+			(int)count, (int)*offset);
 	rsize = v9ses->maxdata - V9FS_IOHDRSZ;
 	if (v9fid->iounit != 0 && rsize > v9fid->iounit)
 		rsize = v9fid->iounit;
@@ -218,7 +222,8 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		if (count < rsize)
 			rsize = count;
 
-		result = v9fs_t_write(v9ses, fid, *offset, rsize, data, &fcall);
+		result = v9fs_t_write(v9ses, fid, *offset, rsize,
+						data, kdata, &fcall);
 		if (result < 0) {
 			PRINT_FCALL_ERROR("error while writing", fcall);
 			kfree(fcall);
@@ -237,19 +242,47 @@ v9fs_file_write(struct file *filp, const char __user * data,
 		}
 
 		count -= result;
-		data += result;
+		if(data)
+			data += result;
+		else
+			kdata += result;
 		total += result;
 	} while (count);
 
-	invalidate_inode_pages2(inode->i_mapping);
 	return total;
 }
 
+
+/**
+ * v9fs_file_write - write to a file
+ * @filep: file pointer to write
+ * @data: data buffer to write data from
+ * @count: size of buffer
+ * @offset: offset at which to write data
+ *
+ */
+
+static ssize_t
+v9fs_file_write(struct file *filp, const char __user * data,
+		size_t count, loff_t * offset)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	ssize_t ret;
+
+	dprintk(DEBUG_VFS, "count %d offset %x\n",
+			(int)count, (int)*offset);
+	ret = v9fs_write(filp, data, NULL, count, offset);
+	if(invalidate_inode_pages2(inode->i_mapping) < 0)
+		eprintk(KERN_WARNING, "failed to flush page cache on write\n");
+	return ret;
+}
+
 const struct file_operations v9fs_cached_file_operations = {
 	.llseek = generic_file_llseek,
 	.read = do_sync_read,
 	.aio_read = generic_file_aio_read,
-	.write = v9fs_file_write,
+	.write = do_sync_write,
+	.aio_write = generic_file_aio_write,
 	.open = v9fs_file_open,
 	.release = v9fs_dir_release,
 	.lock = v9fs_file_lock,
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 124a085..d2f34b5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -208,6 +208,7 @@ struct inode *v9fs_get_inode(struct super_block *sb, int mode)
 		inode->i_rdev = 0;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		inode->i_mapping->a_ops = &v9fs_addr_operations;
+		inode->i_private = NULL;
 
 		switch (mode & S_IFMT) {
 		case S_IFIFO:
@@ -340,7 +341,7 @@ v9fs_clone_walk(struct v9fs_session_info *v9ses, u32 fid, struct dentry *dentry)
 		goto clunk_fid;
 	}
 
-	err = v9fs_fid_insert(ret, dentry);
+	err = v9fs_fid_insert(ret, &dentry->d_fsdata);
 	if (err < 0) {
 		v9fs_fid_destroy(ret);
 		goto clunk_fid;
@@ -520,13 +521,22 @@ v9fs_vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 			v9fs_fid_destroy(ffid);
 			return PTR_ERR(filp);
 		}
-
 		ffid->rdir_pos = 0;
 		ffid->rdir_fcall = NULL;
 		ffid->fidopen = 1;
 		ffid->iounit = iounit;
 		ffid->filp = filp;
 		filp->private_data = ffid;
+	        if((vfid->qid.version) && (v9ses->cache) &&
+		  !(flags & O_APPEND)) {
+			/* enable cached file options */
+			if(filp->f_op == &v9fs_file_operations) {
+				filp->f_op = &v9fs_cached_file_operations;
+				inode->i_op =
+					&v9fs_cached_file_inode_operations;
+			}
+		}
+		v9fs_fid_insert(ffid, &inode->i_private);
 	}
 
 	return 0;
@@ -696,7 +706,7 @@ static struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 		goto FreeFcall;
 	}
 
-	result = v9fs_fid_insert(fid, dentry);
+	result = v9fs_fid_insert(fid, &dentry->d_fsdata);
 	if (result < 0)
 		goto FreeFcall;
 
@@ -1347,6 +1357,10 @@ static const struct inode_operations v9fs_file_inode_operations = {
 	.setattr = v9fs_vfs_setattr,
 };
 
+const struct inode_operations v9fs_cached_file_inode_operations = {
+	.setattr = v9fs_vfs_setattr,
+};
+
 static const struct inode_operations v9fs_symlink_inode_operations = {
 	.readlink = v9fs_vfs_readlink,
 	.follow_link = v9fs_vfs_follow_link,
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 0ec42f6..7c4c289 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -56,6 +56,7 @@ static const struct super_operations v9fs_super_ops;
 static void v9fs_clear_inode(struct inode *inode)
 {
 	filemap_fdatawrite(inode->i_mapping);
+	kfree(inode->i_private);
 }
 
 /**
@@ -167,7 +168,7 @@ static int v9fs_get_sb(struct file_system_type *fs_type, int flags,
 			goto put_back_sb;
 		}
 
-		retval = v9fs_fid_insert(root_fid, root);
+		retval = v9fs_fid_insert(root_fid, &root->d_fsdata);
 		if (retval < 0) {
 			kfree(fcall);
 			goto put_back_sb;
-- 
1.5.0.rc1.gde38

