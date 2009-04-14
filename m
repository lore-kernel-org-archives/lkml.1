Return-Path: <linux-kernel-owner+w=401wt.eu-S1755324AbZDNCGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbZDNCGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 22:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754523AbZDNCFw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 22:05:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:34462 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbZDNCFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 22:05:50 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net,
       miklos@szeredi.hu, akpm@linux-foundation.org, npiggin@suse.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/5] FUSE: implement direct mmap
Date: Tue, 14 Apr 2009 11:04:22 +0900
Message-Id: <1239674662-31318-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239674662-31318-1-git-send-email-tj@kernel.org>
References: <1239674662-31318-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 02:04:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements direct mmap.  It allows FUSE server to honor
each mmap request with anonymous mapping.  FUSE server can make
multiple mmap requests share a single anonymous mapping or separate
mappings as it sees fit.

mmap request is handled in two steps.  MMAP first queries the server
whether it wants to share the mapping with an existing one or create a
new one, and if so, with which flags.  MMAP_COMMIT notifies the server
the result of mmap and if successful the fd the server can use to
access the mmap region.

Internally, shmem_file is used to back the mmap areas and vma->vm_file
is overridden from the FUSE file to the shmem_file.

For details, please read the comment on top of
fuse_file_direct_mmap().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/cuse.c       |    1 +
 fs/fuse/file.c       |  424 ++++++++++++++++++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h     |    8 +
 include/linux/fuse.h |   47 ++++++
 4 files changed, 470 insertions(+), 10 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index 2238016..301c068 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -180,6 +180,7 @@ static const struct file_operations cuse_frontend_fops = {
 	.unlocked_ioctl		= cuse_file_ioctl,
 	.compat_ioctl		= cuse_file_compat_ioctl,
 	.poll			= fuse_file_poll,
+	.mmap			= fuse_file_direct_mmap,
 };
 
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 7492577..fb5f83f 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -13,6 +13,9 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/file.h>
+#include <linux/syscalls.h>
+#include <linux/mman.h>
 
 static const struct file_operations fuse_file_operations;
 static const struct file_operations fuse_direct_io_file_operations;
@@ -1311,15 +1314,6 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	/* Can't provide the coherency needed for MAP_SHARED */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return -ENODEV;
-
-	return generic_file_mmap(file, vma);
-}
-
 static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
 {
@@ -1935,6 +1929,416 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
 	return 0;
 }
 
+struct fuse_mmap {
+	struct fuse_conn	*fc;	/* associated fuse_conn */
+	struct file		*file;	/* associated file */
+	struct kref		kref;	/* reference count */
+	u64			mmap_unique; /* mmap req which created this */
+	int			mmap_fd;     /* server side fd for shmem file */
+	struct file		*mmap_file;  /* shmem file backing this mmap */
+	unsigned long		start;
+	unsigned long		len;
+
+	/* our copy of vm_ops w/ open and close overridden */
+	struct vm_operations_struct vm_ops;
+};
+
+/*
+ * Create fuse_mmap structure which represents a single mmapped
+ * region.  If @mfile is specified the created fuse_mmap would be
+ * associated with it; otherwise, a new shmem_file is created.
+ */
+static struct fuse_mmap *create_fuse_mmap(struct fuse_conn *fc,
+					  struct file *file, struct file *mfile,
+					  u64 mmap_unique, int mmap_fd,
+					  struct vm_area_struct *vma)
+{
+	char dname[] = "dev/fuse";
+	loff_t off = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+	size_t len = vma->vm_end - vma->vm_start;
+	struct fuse_mmap *fmmap;
+	int err;
+
+	err = -ENOMEM;
+	fmmap = kzalloc(sizeof(*fmmap), GFP_KERNEL);
+	if (!fmmap)
+		goto fail;
+	kref_init(&fmmap->kref);
+
+	if (mfile) {
+		/*
+		 * dentry name with a slash in it can't be created
+		 * from userland, so testing dname ensures that the fd
+		 * is the one we've created.  Note that @mfile is
+		 * already grabbed by fuse_mmap_end().
+		 */
+		err = -EINVAL;
+		if (strcmp(mfile->f_dentry->d_name.name, dname))
+			goto fail;
+	} else {
+		/*
+		 * Create a new shmem_file.  As fuse direct mmaps can
+		 * be shared, offset can't be zapped to zero.  Use off
+		 * + len as the default size.  Server has a chance to
+		 * adjust this and other stuff while processing the
+		 * COMMIT request before the client sees this mmap
+		 * area.
+		 */
+		mfile = shmem_file_setup(dname, off + len, vma->vm_flags);
+		if (IS_ERR(mfile)) {
+			err = PTR_ERR(mfile);
+			goto fail;
+		}
+	}
+	fmmap->mmap_file = mfile;
+
+	fmmap->fc = fuse_conn_get(fc);
+	get_file(file);
+	fmmap->file = file;
+	fmmap->mmap_unique = mmap_unique;
+	fmmap->mmap_fd = mmap_fd;
+	fmmap->start = vma->vm_start;
+	fmmap->len = len;
+
+	return fmmap;
+
+ fail:
+	kfree(fmmap);
+	return ERR_PTR(err);
+}
+
+static void destroy_fuse_mmap(struct fuse_mmap *fmmap)
+{
+	/* mmap_file reference is managed by VM */
+	fuse_conn_put(fmmap->fc);
+	fput(fmmap->file);
+	kfree(fmmap);
+}
+
+static void fuse_vm_release(struct kref *kref)
+{
+	struct fuse_mmap *fmmap = container_of(kref, struct fuse_mmap, kref);
+	struct fuse_conn *fc = fmmap->fc;
+	struct fuse_file *ff = fmmap->file->private_data;
+	struct fuse_req *req;
+	struct fuse_munmap_in *inarg;
+
+	/* failing this might lead to resource leak in server, don't fail */
+	req = fuse_get_req_nofail(fc, fmmap->file);
+	inarg = &req->misc.munmap.in;
+
+	inarg->fh = ff->fh;
+	inarg->mmap_unique = fmmap->mmap_unique;
+	inarg->fd = fmmap->mmap_fd;
+	inarg->addr = fmmap->start;
+	inarg->len = fmmap->len;
+
+	req->in.h.opcode = FUSE_MUNMAP;
+	req->in.h.nodeid = get_node_id(fmmap->file->f_dentry->d_inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(*inarg);
+	req->in.args[0].value = inarg;
+
+	fuse_request_send_noreply(fc, req);
+
+	destroy_fuse_mmap(fmmap);
+}
+
+static void fuse_vm_open(struct vm_area_struct *vma)
+{
+	struct fuse_mmap *fmmap = vma->vm_private_data;
+
+	kref_get(&fmmap->kref);
+}
+
+static void fuse_vm_close(struct vm_area_struct *vma)
+{
+	struct fuse_mmap *fmmap = vma->vm_private_data;
+
+	kref_put(&fmmap->kref, fuse_vm_release);
+}
+
+static void fuse_mmap_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_mmap_out *mmap_out = req->out.args[0].value;
+	int fd = mmap_out->fd;
+	struct file *file;
+
+	/*
+	 * If aborted, we're in a different context and the server is
+	 * gonna die soon anyway.  Don't bother.
+	 */
+	if (unlikely(req->aborted))
+		return;
+
+	if (!req->out.h.error && fd >= 0) {
+		/*
+		 * fget() failure should be handled differently as the
+		 * userland is expecting MMAP_COMMIT.  Set ERR_PTR
+		 * value in misc.mmap.file instead of setting
+		 * out.h.error.
+		 */
+		file = fget(fd);
+		if (!file)
+			file = ERR_PTR(-EBADF);
+		req->misc.mmap.file = file;
+	}
+}
+
+static int fuse_mmap_commit_prep(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_mmap_commit_in *commit_in = (void *)req->in.args[0].value;
+	struct file *mfile = req->misc.mmap.file;
+	int fd;
+
+	if (!mfile)
+		return 0;
+
+	/* new mmap.file has been created, assign a fd to it */
+	fd = commit_in->fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return 0;
+
+	get_file(mfile);
+	fd_install(fd, mfile);
+	return 0;
+}
+
+static void fuse_mmap_commit_end(struct fuse_conn *fc, struct fuse_req *req)
+{
+	struct fuse_mmap_commit_in *commit_in = (void *)req->in.args[0].value;
+
+	/*
+	 * If aborted, we're in a different context and the server is
+	 * gonna die soon anyway.  Don't bother.
+	 */
+	if (unlikely(req->aborted))
+		return;
+
+	/*
+	 * If a new fd was assigned to mmap.file but the request
+	 * failed, close the fd.
+	 */
+	if (req->misc.mmap.file && commit_in->fd >= 0 && req->out.h.error)
+		sys_close(commit_in->fd);
+}
+
+/*
+ * Direct mmap is implemented using two requests - FUSE_MMAP and
+ * FUSE_MMAP_COMMIT.  This is to allow the userland server to choose
+ * whether to share an existing mmap or create a new one.
+ *
+ * Each separate mmap area is backed by a shmem_file (an anonymous
+ * mapping).  If the server specifies fd to an existing shmem_file
+ * created by previous FUSE_MMAP_COMMIT, the shmem_file for that
+ * mapping is reused.  If not, a new shmem_file is created and a new
+ * fd is opened and notified to the server via FUSE_MMAP_COMMIT.
+ *
+ * Because the server might allocate resources on FUSE_MMAP, FUSE
+ * guarantees that FUSE_MMAP_COMMIT will be sent whether the mmap
+ * attempt succeeds or not.  On failure, commit_in.fd will contain
+ * negative error code; otherwise, it will contain the fd for the
+ * shmem_file.  The server is then free to truncate the fd to desired
+ * size and fill in the content.  The client will only see the area
+ * only after COMMIT is successfully replied.  If the server fails the
+ * COMMIT request and new fd has been allocated for it, the fd will be
+ * automatically closed by the kernel.
+ *
+ * FUSE guarantees that MUNMAP request will be sent when the area gets
+ * unmapped.
+ *
+ * The server can associate the three related requests - MMAP,
+ * MMAP_COMMIT and MUNMAP using ->unique of the MMAP request.  The
+ * latter two requests carry ->mmap_unique field which contains
+ * ->unique of the MMAP request.
+ */
+int fuse_file_direct_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_mmap *fmmap = NULL;
+	struct fuse_req *req;
+	struct fuse_mmap_in mmap_in;
+	struct fuse_mmap_out mmap_out;
+	struct fuse_mmap_commit_in commit_in;
+	struct file *mfile;
+	u64 mmap_unique;
+	int err;
+
+	/*
+	 * First, execute FUSE_MMAP which will query the server
+	 * whether this mmap request is valid and which fd it wants to
+	 * use to mmap this request.
+	 */
+	req = fuse_get_req(fc);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto err;
+	}
+
+	memset(&mmap_in, 0, sizeof(mmap_in));
+	mmap_in.fh = ff->fh;
+	mmap_in.addr = vma->vm_start;
+	mmap_in.len = vma->vm_end - vma->vm_start;
+	mmap_in.prot = ((vma->vm_flags & VM_READ) ? PROT_READ : 0) |
+		       ((vma->vm_flags & VM_WRITE) ? PROT_WRITE : 0) |
+		       ((vma->vm_flags & VM_EXEC) ? PROT_EXEC : 0);
+	mmap_in.flags = ((vma->vm_flags & VM_GROWSDOWN) ? MAP_GROWSDOWN : 0) |
+			((vma->vm_flags & VM_DENYWRITE) ? MAP_DENYWRITE : 0) |
+			((vma->vm_flags & VM_EXECUTABLE) ? MAP_EXECUTABLE : 0) |
+			((vma->vm_flags & VM_LOCKED) ? MAP_LOCKED : 0);
+	mmap_in.offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+
+	req->in.h.opcode = FUSE_MMAP;
+	req->in.h.nodeid = fuse_file_nodeid(ff);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(mmap_in);
+	req->in.args[0].value = &mmap_in;
+	req->out.numargs = 1;
+	req->out.args[0].size = sizeof(mmap_out);
+	req->out.args[0].value = &mmap_out;
+
+	req->end = fuse_mmap_end;
+
+	fuse_request_send(fc, req);
+
+	/* mmap.file is set if server requested to reuse existing mapping */
+	mfile = req->misc.mmap.file;
+	mmap_unique = req->in.h.unique;
+	err = req->out.h.error;
+
+	fuse_put_request(fc, req);
+
+	/* ERR_PTR value in mfile means fget failure, send failure COMMIT */
+	if (IS_ERR(mfile)) {
+		err = PTR_ERR(mfile);
+		goto commit;
+	}
+	/* userland indicated failure, we can just fail */
+	if (err)
+		goto err;
+
+	/*
+	 * Second, create mmap as the server requested.
+	 */
+	fmmap = create_fuse_mmap(fc, file, mfile, mmap_unique, mmap_out.fd,
+				 vma);
+	if (IS_ERR(fmmap)) {
+		err = PTR_ERR(fmmap);
+		if (mfile)
+			fput(mfile);
+		fmmap = NULL;
+		goto commit;
+	}
+
+	/*
+	 * fmmap points to shm_file to mmap, give it to vma.  From
+	 * this point on, the mfile reference is managed by the vma.
+	 */
+	mfile = fmmap->mmap_file;
+	fput(vma->vm_file);
+	vma->vm_file = mfile;
+
+	/* add flags server requested and mmap the shm_file */
+	if (mmap_out.flags & FUSE_MMAP_DONT_COPY)
+		vma->vm_flags |= VM_DONTCOPY;
+	if (mmap_out.flags & FUSE_MMAP_DONT_EXPAND)
+		vma->vm_flags |= VM_DONTEXPAND;
+
+	err = mfile->f_op->mmap(mfile, vma);
+	if (err)
+		goto commit;
+
+	/*
+	 * Override vm_ops->open and ->close.  This is a bit hacky but
+	 * vma's can't easily be nested and FUSE needs to notify the
+	 * server when to release resources for mmaps.  Both shmem and
+	 * tiny_shmem implementations are okay with this trick but if
+	 * there's a cleaner way to do this, please update it.
+	 */
+	err = -EINVAL;
+	if (vma->vm_ops->open || vma->vm_ops->close || vma->vm_private_data) {
+		printk(KERN_ERR "FUSE: can't do direct mmap. shmem mmap has "
+		       "open, close or vm_private_data\n");
+		goto commit;
+	}
+
+	fmmap->vm_ops = *vma->vm_ops;
+	vma->vm_ops = &fmmap->vm_ops;
+	vma->vm_ops->open = fuse_vm_open;
+	vma->vm_ops->close = fuse_vm_close;
+	vma->vm_private_data = fmmap;
+	err = 0;
+
+ commit:
+	/*
+	 * Third, either mmap succeeded or failed after MMAP request
+	 * succeeded.  Notify userland what happened.
+	 */
+
+	/* missing commit can cause resource leak on server side, don't fail */
+	req = fuse_get_req_nofail(fc, file);
+
+	memset(&commit_in, 0, sizeof(commit_in));
+	commit_in.fh = ff->fh;
+	commit_in.mmap_unique = mmap_unique;
+	commit_in.addr = mmap_in.addr;
+	commit_in.len = mmap_in.len;
+	commit_in.prot = mmap_in.prot;
+	commit_in.flags = mmap_in.flags;
+	commit_in.offset = mmap_in.offset;
+
+	if (!err) {
+		commit_in.fd = fmmap->mmap_fd;
+		/*
+		 * If fmmap->mmap_fd < 0, new fd needs to be created
+		 * when the server reads MMAP_COMMIT.  Pass the file
+		 * pointer.  A fd will be assigned to it by the
+		 * fuse_mmap_commit_prep callback.
+		 */
+		if (fmmap->mmap_fd < 0)
+			req->misc.mmap.file = mfile;
+	} else
+		commit_in.fd = err;
+
+	req->in.h.opcode = FUSE_MMAP_COMMIT;
+	req->in.h.nodeid = fuse_file_nodeid(ff);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(commit_in);
+	req->in.args[0].value = &commit_in;
+
+	req->prep = fuse_mmap_commit_prep;
+	req->end = fuse_mmap_commit_end;
+
+	fuse_request_send(fc, req);
+	if (!err)			/* notified failure to userland */
+		err = req->out.h.error;
+	if (!err && commit_in.fd < 0)	/* failed to allocate fd */
+		err = commit_in.fd;
+	fuse_put_request(fc, req);
+
+	if (!err) {
+		fmmap->mmap_fd = commit_in.fd;
+		return 0;
+	}
+
+	/* fall through */
+ err:
+	if (fmmap)
+		destroy_fuse_mmap(fmmap);
+
+	if (err == -ENOSYS) {
+		/* Can't provide the coherency needed for MAP_SHARED */
+		if (vma->vm_flags & VM_MAYSHARE)
+			return -ENODEV;
+
+		return generic_file_mmap(file, vma);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(fuse_file_direct_mmap);
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
@@ -1958,7 +2362,7 @@ static const struct file_operations fuse_direct_io_file_operations = {
 	.llseek		= fuse_file_llseek,
 	.read		= fuse_direct_read,
 	.write		= fuse_direct_write,
-	.mmap		= fuse_direct_mmap,
+	.mmap		= fuse_file_direct_mmap,
 	.open		= fuse_open,
 	.flush		= fuse_flush,
 	.release	= fuse_release,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index ca5b8e9..6baa307 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -271,6 +271,13 @@ struct fuse_req {
 			struct fuse_write_out out;
 		} write;
 		struct fuse_lk_in lk_in;
+		struct {
+			/** to move filp for mmap between client and server */
+			struct file *file;
+		} mmap;
+		struct {
+			struct fuse_munmap_in in;
+		} munmap;
 	} misc;
 
 	/** page vector */
@@ -596,6 +603,7 @@ int fuse_flush(struct file *file, fl_owner_t id);
  * Send FSYNCDIR or FSYNC request
  */
 int fuse_fsync(struct file *file, struct dentry *de, int datasync);
+int fuse_file_direct_mmap(struct file *file, struct vm_area_struct *vma);
 
 /**
  * Send IOCTL request
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index cc51548..3bb82f6 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -171,6 +171,15 @@ struct fuse_file_lock {
  */
 #define FUSE_POLL_SCHEDULE_NOTIFY (1 << 0)
 
+/**
+ * Mmap flags
+ *
+ * FUSE_MMAP_DONT_COPY: don't copy the region on fork
+ * FUSE_MMAP_DONT_EXPAND: can't be expanded with mremap()
+ */
+#define FUSE_MMAP_DONT_COPY	(1 << 0)
+#define FUSE_MMAP_DONT_EXPAND	(1 << 1)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -210,6 +219,9 @@ enum fuse_opcode {
 	FUSE_DESTROY       = 38,
 	FUSE_IOCTL         = 39,
 	FUSE_POLL          = 40,
+	FUSE_MMAP          = 41,
+	FUSE_MMAP_COMMIT   = 42,
+	FUSE_MUNMAP        = 43,
 
 	CUSE_BASE          = 4096,
 };
@@ -449,6 +461,41 @@ struct fuse_notify_poll_wakeup_out {
 	__u64	kh;
 };
 
+struct fuse_mmap_in {
+	__u64	fh;
+	__u64	addr;
+	__u64	len;
+	__s32	prot;
+	__s32	flags;
+	__u64	offset;
+};
+
+struct fuse_mmap_out {
+	__s32	fd;
+	__u32	flags;
+};
+
+struct fuse_mmap_commit_in {
+	__u64	fh;
+	__u64	mmap_unique;
+	__u64	addr;
+	__u64	len;
+	__s32	prot;
+	__s32	flags;
+	__s32	fd;
+	__u32	padding;
+	__u64	offset;
+};
+
+struct fuse_munmap_in {
+	__u64	fh;
+	__u64	mmap_unique;
+	__u64	addr;
+	__u64	len;
+	__s32	fd;
+	__u32	padding;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.6.0.2

