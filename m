Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYH1Rox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYH1Rox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 13:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755917AbYH1Rmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 13:42:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:52439 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbYH1Rmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 13:42:47 -0400
From: Tejun Heo <tj@kernel.org>
To: fuse-devel@lists.sourceforge.net, miklos@szeredi.hu, greg@kroah.com,
       linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/7] FUSE: implement ioctl support
Date: Fri, 29 Aug 2008 02:41:01 +0900
Message-Id: <1219945263-21074-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1219945263-21074-1-git-send-email-tj@kernel.org>
References: <1219945263-21074-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 28 Aug 2008 17:42:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl support is tricky to implement because only the ioctl
implementation itself knows which memory regions need to be read
and/or written.  To support this, fuse client can request retry of
ioctl specifying memory regions to read and write.  Deep copying
(nested pointers) can be implemented by retrying multiple times
resolving one depth of dereference at a time.

Plese read the comment on top of fs/fuse/file.c::fuse_file_do_ioctl()
for more information.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 fs/fuse/file.c       |  241 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fuse.h |   30 ++++++
 2 files changed, 271 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index fa27edb..75a9b53 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1507,6 +1507,243 @@ static loff_t fuse_file_llseek(struct file *file, loff_t offset, int origin)
 	return retval;
 }
 
+static int fuse_ioctl_copy_user(struct page **pages, struct iovec *iov,
+			unsigned int nr_segs, size_t bytes, bool to_user)
+{
+	struct iov_iter ii;
+	int page_idx = 0;
+
+	if (!bytes)
+		return 0;
+
+	iov_iter_init(&ii, iov, nr_segs, bytes, 0);
+
+	while (iov_iter_count(&ii)) {
+		struct page *page = pages[page_idx++];
+		size_t todo = min_t(size_t, PAGE_SIZE, iov_iter_count(&ii));
+		void *kaddr, *map;
+
+		kaddr = map = kmap(page);
+
+		while (todo) {
+			char __user *uaddr = ii.iov->iov_base + ii.iov_offset;
+			size_t iov_len = ii.iov->iov_len - ii.iov_offset;
+			size_t copy = min(todo, iov_len);
+			size_t left;
+
+			if (!to_user)
+				left = copy_from_user(kaddr, uaddr, copy);
+			else
+				left = copy_to_user(uaddr, kaddr, copy);
+
+			if (unlikely(left))
+				return -EFAULT;
+
+			iov_iter_advance(&ii, copy);
+			todo -= copy;
+			kaddr += copy;
+		}
+
+		kunmap(map);
+	}
+
+	return 0;
+}
+
+/*
+ * For ioctls, there is no generic way to determine how much memory
+ * needs to be read and/or written.  Furthermore, ioctls are allowed
+ * to dereference the passed pointer, so the parameter requires deep
+ * copying but FUSE has no idea whatsoever about what to copy in or
+ * out.
+ *
+ * This is solved by allowing FUSE client to retry ioctl with
+ * necessary in/out iovecs.  Let's assume the ioctl implementation
+ * needs to read in the following structure.
+ *
+ * struct a {
+ *	char	*buf;
+ *	size_t	buflen;
+ * }
+ *
+ * On the first callout to FUSE client, inarg->in_size and
+ * inarg->out_size will be NULL; then, the client completes the ioctl
+ * with FUSE_IOCTL_RETRY set in out->flags, out->in_iovs set to 1 and
+ * the actual iov array to
+ *
+ * { { .iov_base = inarg.arg,	.iov_len = sizeof(struct a) } }
+ *
+ * which tells FUSE to copy in the requested area and retry the ioctl.
+ * On the second round, the client has access to the structure and
+ * from that it can tell what to look for next, so on the invocation,
+ * it sets FUSE_IOCTL_RETRY, out->in_iovs to 2 and iov array to
+ *
+ * { { .iov_base = inarg.arg,	.iov_len = sizeof(struct a)	},
+ *   { .iov_base = a.buf,	.iov_len = a.buflen		} }
+ *
+ * FUSE will copy both struct a and the pointed buffer from the
+ * process doing the ioctl and retry ioctl with both struct a and the
+ * buffer.
+ *
+ * This time, FUSE client has everything it needs and completes ioctl
+ * without FUSE_IOCTL_RETRY which finishes the ioctl call.
+ *
+ * Copying data out works the same way.
+ */
+static long fuse_file_do_ioctl(struct file *file, unsigned int cmd,
+			       unsigned long arg, unsigned int flags)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = get_fuse_conn(inode);
+	struct fuse_ioctl_in inarg = { .fh = ff->fh, .cmd = cmd, .arg = arg,
+				       .flags = flags };
+	struct fuse_ioctl_out outarg;
+	struct fuse_req *req = NULL;
+	struct page **pages = NULL;
+	struct page *iov_page = NULL;
+	struct iovec *in_iov = NULL, *out_iov = NULL;
+	unsigned int in_iovs = 0, out_iovs = 0, num_pages = 0, max_pages;
+	size_t in_size, out_size, transferred;
+	int err;
+
+	/* assume all the iovs returned by client always fits in a page */
+	BUILD_BUG_ON(sizeof(struct iovec) * FUSE_IOCTL_MAX_IOV > PAGE_SIZE);
+
+	err = -EIO;
+	if (is_bad_inode(inode))
+		goto out;
+
+	err = -ENOMEM;
+	pages = kzalloc(sizeof(pages[0]) * FUSE_MAX_PAGES_PER_REQ, GFP_KERNEL);
+	iov_page = alloc_page(GFP_KERNEL);
+	if (!pages || !iov_page)
+		goto out;
+
+ retry:
+	inarg.in_size = in_size = iov_length(in_iov, in_iovs);
+	inarg.out_size = out_size = iov_length(out_iov, out_iovs);
+
+	/*
+	 * Out data can be used either for actual out data or iovs,
+	 * make sure there always is at least one page.
+	 */
+	out_size = max_t(size_t, out_size, PAGE_SIZE);
+	max_pages = DIV_ROUND_UP(max(in_size, out_size), PAGE_SIZE);
+
+	/* make sure there are enough buffer pages and init request with them */
+	err = -ENOMEM;
+	if (max_pages > FUSE_MAX_PAGES_PER_REQ)
+		goto out;
+	while (num_pages < max_pages) {
+		pages[num_pages] = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (!pages[num_pages])
+			goto out;
+		num_pages++;
+	}
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req)) {
+		req = NULL;
+		err = PTR_ERR(req);
+		goto out;
+	}
+	memcpy(req->pages, pages, sizeof(req->pages[0]) * num_pages);
+	req->num_pages = num_pages;
+
+	/* okay, let's send it to the client */
+	req->in.h.opcode = FUSE_IOCTL;
+	req->in.h.nodeid = get_node_id(inode);
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	if (in_size) {
+		req->in.numargs++;
+		req->in.args[1].size = in_size;
+		req->in.argpages = 1;
+
+		err = fuse_ioctl_copy_user(pages, in_iov, in_iovs, in_size,
+					   false);
+		if (err)
+			goto out;
+	}
+
+	req->out.numargs = 2;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+	req->out.args[1].size = out_size;
+	req->out.argpages = 1;
+	req->out.argvar = 1;
+
+	request_send(fc, req);
+	err = req->out.h.error;
+	transferred = req->out.args[1].size;
+	fuse_put_request(fc, req);
+	req = NULL;
+	if (err)
+		goto out;
+
+	/* did it ask for retry? */
+	if (outarg.flags & FUSE_IOCTL_RETRY) {
+		char *vaddr;
+
+		in_iovs = outarg.in_iovs;
+		out_iovs = outarg.out_iovs;
+
+		/*
+		 * Make sure things are in boundary, separate checks
+		 * are to protect against overflow.
+		 */
+		err = -ENOMEM;
+		if (in_iovs > FUSE_IOCTL_MAX_IOV ||
+		    out_iovs > FUSE_IOCTL_MAX_IOV ||
+		    in_iovs + out_iovs > FUSE_IOCTL_MAX_IOV)
+			goto out;
+
+		err = -EBADE;
+		if ((in_iovs + out_iovs) * sizeof(struct iovec) != transferred)
+			goto out;
+
+		/* okay, copy in iovs and retry */
+		vaddr = kmap_atomic(pages[0], KM_USER0);
+		memcpy(page_address(iov_page), vaddr, transferred);
+		kunmap_atomic(vaddr, KM_USER0);
+
+		in_iov = page_address(iov_page);
+		out_iov = in_iov + in_iovs;
+
+		goto retry;
+	}
+
+	err = -EBADE;
+	if (transferred > inarg.out_size)
+		goto out;
+
+	err = fuse_ioctl_copy_user(pages, out_iov, out_iovs, transferred, true);
+ out:
+	if (req)
+		fuse_put_request(fc, req);
+	if (iov_page)
+		__free_page(iov_page);
+	while (num_pages)
+		__free_page(pages[--num_pages]);
+	kfree(pages);
+
+	return err ? err : outarg.result;
+}
+
+static long fuse_file_ioctl(struct file *file, unsigned int cmd,
+			    unsigned long arg)
+{
+	return fuse_file_do_ioctl(file, cmd, arg, 0);
+}
+
+static long fuse_file_compat_ioctl(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	return fuse_file_do_ioctl(file, cmd, arg, FUSE_IOCTL_COMPAT);
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
@@ -1521,6 +1758,8 @@ static const struct file_operations fuse_file_operations = {
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
 	.splice_read	= generic_file_splice_read,
+	.unlocked_ioctl	= fuse_file_ioctl,
+	.compat_ioctl	= fuse_file_compat_ioctl,
 };
 
 static const struct file_operations fuse_direct_io_file_operations = {
@@ -1533,6 +1772,8 @@ static const struct file_operations fuse_direct_io_file_operations = {
 	.fsync		= fuse_fsync,
 	.lock		= fuse_file_lock,
 	.flock		= fuse_file_flock,
+	.unlocked_ioctl	= fuse_file_ioctl,
+	.compat_ioctl	= fuse_file_compat_ioctl,
 	/* no mmap and splice_read */
 };
 
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 508d54e..5a396d3 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -152,6 +152,19 @@ struct fuse_file_lock {
 #define FUSE_READ_LOCKOWNER	(1 << 1)
 #define FUSE_READ_NONBLOCK	(1 << 2)
 
+/**
+ * Ioctl flags
+ *
+ * FUSE_IOCTL_COMPAT: 32bit compat ioctl on 64bit machine
+ * FUSE_IOCTL_RETRY: retry with new iovecs
+ *
+ * FUSE_IOCTL_MAX_IOV: maximum of in_iovecs + out_iovecs
+ */
+#define FUSE_IOCTL_COMPAT	(1 << 0)
+#define FUSE_IOCTL_RETRY	(1 << 1)
+
+#define FUSE_IOCTL_MAX_IOV	256
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -190,6 +203,7 @@ enum fuse_opcode {
 	FUSE_BMAP          = 37,
 	FUSE_DESTROY       = 38,
 	FUSE_LSEEK         = 39,
+	FUSE_IOCTL         = 40,
 };
 
 /* The read buffer is required to be at least 8k, but may be much larger */
@@ -402,6 +416,22 @@ struct fuse_lseek_out {
 	__u64	pos;			/* new position */
 };
 
+struct fuse_ioctl_in {
+	__u64	fh;
+	__u32	flags;
+	__u32	cmd;
+	__u64	arg;
+	__u32	in_size;
+	__u32	out_size;
+};
+
+struct fuse_ioctl_out {
+	__s32	result;
+	__u32	flags;
+	__u32	in_iovs;
+	__u32	out_iovs;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.5.4.5

