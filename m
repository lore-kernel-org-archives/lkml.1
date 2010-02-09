Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0BIGDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 01:03:06 -0500
Received: from hera.kernel.org ([140.211.167.34]:40694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999Ab0BIGDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 01:03:03 -0500
Message-ID: <4B70FBE4.7050700@kernel.org>
Date: Tue, 09 Feb 2010 15:08:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Miklos Szeredi <mszeredi@suse.cz>, lkml <linux-kernel@vger.kernel.org>,
       fuse-devel@lists.sourceforge.net
CC: Lars Wendler <polynomial-c@gentoo.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] FUSE/CUSE: implement direct mmap support
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 09 Feb 2010 06:01:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement FUSE direct mmap support.  The server can redirect client
mmap requests to any SHMLBA aligned offset in the custom address space
attached to the fuse channel.  The address space is managed by the
server using mmap/munmap(2).  The SHMLBA alignment requirement is
necessary to avoid cache aliasing issues on archs with virtually
indexed caches as FUSE direct mmaps are basically shared memory
between clients and the server.

The direct mmap address space is backed by pinned kernel pages which
are allocated on the first fault either from a client or the server.
If used carelessly, this can easily waste and drain memory.
Currently, a server must have CAP_SYS_ADMIN to manage dmmap regions by
mmapping and munmapping the channel fd.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
Here's the long overdue FUSE direct mmap support.  I tried several
things but this simplistic custom address space implementation turns
out to be the cleanest.  It also shouldn't be too difficult to extend
it with userland ->fault() handler if such thing ever becomes
necessary.  I'll post the library part soon.

Thanks.

 fs/fuse/cuse.c       |    1 +
 fs/fuse/dev.c        |  294 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/fuse/file.c       |  209 +++++++++++++++++++++++++++++++++--
 fs/fuse/fuse_i.h     |   19 ++++
 fs/fuse/inode.c      |    1 +
 include/linux/fuse.h |   32 ++++++
 6 files changed, 545 insertions(+), 11 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index de792dc..e5cefa6 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -181,6 +181,7 @@ static const struct file_operations cuse_frontend_fops = {
 	.unlocked_ioctl		= cuse_file_ioctl,
 	.compat_ioctl		= cuse_file_compat_ioctl,
 	.poll			= fuse_file_poll,
+	.mmap			= fuse_do_dmmap,
 };
 
 
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 51d9e33..8dbd39b 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1220,6 +1220,299 @@ static int fuse_dev_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &fc->fasync);
 }
 
+/*
+ * Direct mmap implementation.
+ *
+ * A simple custom address space is available for each fuse_conn at
+ * fc->dmmap_regions, which is managed by the server.  The server can
+ * access it by mmap system calls on the fuse channel fd.  mmap()
+ * creates a region, the final munmap() of the region destroys the
+ * region and overlapping regions aren't allowed.
+ *
+ * When a client invokes mmap(), the server can specify the offset the
+ * mmap request should be mapped to in the above adress space.  Please
+ * note that the offset adjusted by the server and the originally
+ * requested offset must share the same alignment with respect to
+ * SHMLBA to avoid cache aliasing issues on architectures with
+ * virtually indexed caches.  IOW, the following should hold.
+ *
+ * REQUESTED_OFFSET & (SHMLBA - 1) == ADJUSTED_OFFSET & (SHMLBA - 1)
+ *
+ * As long as the above holds, the server is free to specify any
+ * offset allowing it to assign and share any region among arbitrary
+ * set of clients.
+ *
+ * The direct mmap address space is backed by pinned kernel pages
+ * which are allocated on the first fault either from a client or the
+ * server.  If used carelessly, this can easily waste and drain
+ * memory.  Currently, a server must have CAP_SYS_ADMIN to manage
+ * dmmap regions by mmapping and munmapping the channel fd.
+ *
+ * fuse_dmmap_region describes single region in the dmmap address
+ * space.
+ */
+struct fuse_dmmap_region {
+	struct rb_node		node;
+	atomic_t		count;		/* reference count */
+	pgoff_t			pgoff;		/* pgoff into dmmap AS */
+	pgoff_t			nr_pages;	/* number of pages */
+	struct page		*pages[0];	/* pointer to allocated pages */
+};
+
+/**
+ * fuse_find_dmmap_node - find dmmap region for given page offset
+ * @fc: fuse connection to search dmmap_node from
+ * @pgoff: page offset
+ * @parentp: optional out parameter for parent
+ *
+ * Look for dmmap region which contains @pgoff in it.  @parentp, if
+ * not NULL, will be filled with pointer to the immediate parent which
+ * may be NULL or the immediate previous or next node.
+ *
+ * CONTEXT:
+ * spin_lock(fc->lock)
+ *
+ * RETURNS:
+ * Always returns pointer to the rbtree slot.  If matching node is
+ * found, the returned slot contains non-NULL pointer.  The returned
+ * slot can be used to node insertion if it contains NULL.
+ */
+static struct rb_node **fuse_find_dmmap_node(struct fuse_conn *fc,
+					     unsigned long pgoff,
+					     struct rb_node **parentp)
+{
+	struct rb_node **link = &fc->dmmap_regions.rb_node;
+	struct rb_node *last = NULL;
+
+	while (*link) {
+		struct fuse_dmmap_region *region;
+
+		last = *link;
+		region = rb_entry(last, struct fuse_dmmap_region, node);
+
+		if (pgoff < region->pgoff)
+			link = &last->rb_left;
+		else if (pgoff >= region->pgoff + region->nr_pages)
+			link = &last->rb_right;
+		else
+			return link;
+	}
+
+	if (parentp)
+		*parentp = last;
+	return link;
+}
+
+static void fuse_dmmap_put_region(struct fuse_conn *fc,
+				  struct fuse_dmmap_region *region)
+{
+	pgoff_t i;
+
+	if (!atomic_dec_and_test(&region->count))
+		return;
+
+	/* refcnt hit zero, unlink and free */
+	spin_lock(&fc->lock);
+	rb_erase(&region->node, &fc->dmmap_regions);
+	spin_unlock(&fc->lock);
+
+	for (i = 0; i < region->nr_pages; i++)
+		if (region->pages[i])
+			put_page(region->pages[i]);
+	kfree(region);
+}
+
+/**
+ * fuse_dmmap_find_get_page - find or create page for given page offset
+ * @fc: fuse connection of interest
+ * @pgoff: page offset
+ * @pagep: out parameter for the found
+ *
+ * Find or create page at @pgoff in @fc, increment reference and store
+ * it to *@pagep.
+ *
+ * CONTEXT:
+ * May sleep.
+ *
+ * RETURNS:
+ * 0 on success.  VM_FAULT_SIGBUS if matching dmmap region doesn't
+ * exist.  VM_FAULT_OOM if allocation fails.
+ */
+int fuse_dmmap_find_get_page(struct fuse_conn *fc, pgoff_t pgoff,
+			     struct page **pagep)
+{
+	struct rb_node **link;
+	struct fuse_dmmap_region *region = NULL;
+	struct page *new_page = NULL;
+	pgoff_t idx;
+
+	/* find the region and see if the page is already there */
+	spin_lock(&fc->lock);
+
+	link = fuse_find_dmmap_node(fc, pgoff, NULL);
+	if (unlikely(!*link)) {
+		spin_unlock(&fc->lock);
+		return VM_FAULT_SIGBUS;
+	}
+
+	region = rb_entry(*link, struct fuse_dmmap_region, node);
+	idx = pgoff - region->pgoff;
+	*pagep = region->pages[idx];
+	if (*pagep)
+		get_page(*pagep);
+	else
+		atomic_inc(&region->count);
+
+	spin_unlock(&fc->lock);
+
+	/*
+	 * At this point, we're holding a reference to either the
+	 * *pagep or region.  If *pagep, we're done.
+	 */
+	if (*pagep)
+		return 0;
+
+	/* need to allocate and install a new page */
+	new_page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+	if (!new_page) {
+		fuse_dmmap_put_region(fc, region);
+		return VM_FAULT_OOM;
+	}
+
+	/* try to install, check whether someone else already did it */
+	spin_lock(&fc->lock);
+
+	*pagep = region->pages[idx];
+	if (!*pagep) {
+		*pagep = region->pages[idx] = new_page;
+		new_page = NULL;
+	}
+	get_page(*pagep);
+
+	spin_unlock(&fc->lock);
+
+	fuse_dmmap_put_region(fc, region);
+	if (new_page)
+		put_page(new_page);
+
+	return 0;
+}
+
+static void fuse_dev_vm_open(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_region *region = vma->vm_private_data;
+
+	atomic_inc(&region->count);
+}
+
+static void fuse_dev_vm_close(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_region *region = vma->vm_private_data;
+	struct fuse_conn *fc = fuse_get_conn(vma->vm_file);
+
+	BUG_ON(!fc);
+	fuse_dmmap_put_region(fc, region);
+}
+
+static int fuse_dev_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct fuse_conn *fc = fuse_get_conn(vma->vm_file);
+
+	if (!fc)
+		return VM_FAULT_SIGBUS;
+
+	return fuse_dmmap_find_get_page(fc, vmf->pgoff, &vmf->page);
+}
+
+static const struct vm_operations_struct fuse_dev_vm_ops = {
+	.open		= fuse_dev_vm_open,
+	.close		= fuse_dev_vm_close,
+	.fault		= fuse_dev_vm_fault,
+};
+
+static int fuse_dev_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fuse_conn *fc = fuse_get_conn(file);
+	struct fuse_dmmap_region *region = NULL, *overlap = NULL;
+	struct rb_node **link, *parent_link;
+	pgoff_t nr_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+	int ret;
+
+	/* server side dmmap will consume pinned pages, allow only root */
+	ret = -EPERM;
+	if (!fc || !capable(CAP_SYS_ADMIN))
+		goto out;
+
+	/* alloc and init region */
+	ret = -ENOMEM;
+	region = kzalloc(sizeof(*region) + sizeof(region->pages[0]) * nr_pages,
+			 GFP_KERNEL);
+	if (!region)
+		goto out;
+
+	atomic_set(&region->count, 1);
+	region->pgoff = vma->vm_pgoff;
+	region->nr_pages = nr_pages;
+
+	/* check for overlapping regions and insert it */
+	spin_lock(&fc->lock);
+
+	link = fuse_find_dmmap_node(fc, region->pgoff, &parent_link);
+
+	if (*link) {
+		/*
+		 * This covers coinciding starting pgoff and the prev
+		 * region going over this one.
+		 */
+		overlap = rb_entry(*link, struct fuse_dmmap_region, node);
+	} else if (parent_link) {
+		struct fuse_dmmap_region *parent, *next = NULL;
+
+		/* determine next */
+		parent = rb_entry(parent_link, struct fuse_dmmap_region, node);
+		if (parent->pgoff < region->pgoff) {
+			struct rb_node *next_link = rb_next(parent_link);
+			if (next_link)
+				next = rb_entry(next_link,
+						struct fuse_dmmap_region, node);
+		} else
+			next = parent;
+
+		/* and see whether the new region goes over the next one */
+		if (next && region->pgoff + nr_pages > next->pgoff)
+			overlap = next;
+	}
+
+	if (overlap) {
+		printk("FUSE: server %u tries to dmmap %lu-%lu which overlaps "
+		       "with %lu-%lu\n",
+		       task_pid_nr(current),
+		       (unsigned long)region->pgoff,
+		       (unsigned long)(region->pgoff + nr_pages - 1),
+		       (unsigned long)overlap->pgoff,
+		       (unsigned long)(overlap->pgoff + overlap->nr_pages - 1));
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	/* yay, nothing overlaps, link region and initialize vma */
+	rb_link_node(&region->node, parent_link, link);
+	rb_insert_color(&region->node, &fc->dmmap_regions);
+
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_ops = &fuse_dev_vm_ops;
+	vma->vm_private_data = region;
+
+	region = NULL;
+	ret = 0;
+
+out_unlock:
+	spin_unlock(&fc->lock);
+out:
+	kfree(region);
+	return ret;
+}
+
 const struct file_operations fuse_dev_operations = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
@@ -1230,6 +1523,7 @@ const struct file_operations fuse_dev_operations = {
 	.poll		= fuse_dev_poll,
 	.release	= fuse_dev_release,
 	.fasync		= fuse_dev_fasync,
+	.mmap		= fuse_dev_mmap,
 };
 EXPORT_SYMBOL_GPL(fuse_dev_operations);
 
diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index a9f5e13..8c5988c 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -13,6 +13,8 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/module.h>
+#include <linux/mman.h>
+#include <asm/shmparam.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -1344,17 +1346,6 @@ static int fuse_file_mmap(struct file *file, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	/* Can't provide the coherency needed for MAP_SHARED */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return -ENODEV;
-
-	invalidate_inode_pages2(file->f_mapping);
-
-	return generic_file_mmap(file, vma);
-}
-
 static int convert_fuse_file_lock(const struct fuse_file_lock *ffl,
 				  struct file_lock *fl)
 {
@@ -1974,6 +1965,202 @@ int fuse_notify_poll_wakeup(struct fuse_conn *fc,
 	return 0;
 }
 
+/*
+ * For details on dmmap implementation, please read "Direct mmap
+ * implementation" in dev.c.
+ *
+ * fuse_dmmap_vm represents the result of a single mmap() call, which
+ * can be shared by multiple client vmas created by forking.
+ * fuse_dmmap_vm maintains the original length so that it can be used
+ * to notify the server of the final put of this area.  This is
+ * necessary because vmas can be shrinked using mremap().
+ */
+struct fuse_dmmap_vm {
+	atomic_t		count;		/* reference count */
+	u64			mh;		/* unique dmmap id */
+	size_t			len;
+};
+
+static void fuse_dmmap_vm_open(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_vm *fdvm = vma->vm_private_data;
+
+	/* vma copied */
+	atomic_inc(&fdvm->count);
+}
+
+static void fuse_dmmap_vm_close(struct vm_area_struct *vma)
+{
+	struct fuse_dmmap_vm *fdvm = vma->vm_private_data;
+	struct fuse_file *ff = vma->vm_file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_req *req;
+	struct fuse_munmap_in *inarg;
+
+	if (!atomic_dec_and_test(&fdvm->count))
+		return;
+	/*
+	 * Notify server that the mmap region has been unmapped.
+	 * Failing this might lead to resource leak in server, don't
+	 * fail.
+	 */
+	req = fuse_get_req_nofail(fc, vma->vm_file);
+	inarg = &req->misc.munmap_in;
+
+	inarg->fh = ff->fh;
+	inarg->mh = fdvm->mh;
+	inarg->len = fdvm->len;
+	inarg->offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	req->in.h.opcode = FUSE_MUNMAP;
+	req->in.h.nodeid = ff->nodeid;
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(*inarg);
+	req->in.args[0].value = inarg;
+
+	fuse_request_send_noreply(fc, req);
+	kfree(fdvm);
+}
+
+static int fuse_dmmap_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct fuse_file *ff = vma->vm_file->private_data;
+	struct fuse_conn *fc = ff->fc;
+
+	return fuse_dmmap_find_get_page(fc, vmf->pgoff, &vmf->page);
+}
+
+static const struct vm_operations_struct fuse_dmmap_vm_ops = {
+	.open		= fuse_dmmap_vm_open,
+	.close		= fuse_dmmap_vm_close,
+	.fault		= fuse_dmmap_vm_fault,
+};
+
+int fuse_do_dmmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fuse_file *ff = file->private_data;
+	struct fuse_conn *fc = ff->fc;
+	struct fuse_dmmap_vm *fdvm = NULL;
+	struct fuse_req *req = NULL;
+	struct fuse_mmap_in inarg;
+	struct fuse_mmap_out outarg;
+	int err;
+
+	if (fc->no_dmmap)
+		return -ENOSYS;
+
+	/* allocate and initialize fdvm */
+	err = -ENOMEM;
+	fdvm = kzalloc(sizeof(*fdvm), GFP_KERNEL);
+	if (!fdvm)
+		goto fail;
+
+	atomic_set(&fdvm->count, 1);
+	fdvm->len = vma->vm_end - vma->vm_start;
+
+	spin_lock(&fc->lock);
+	fdvm->mh = ++fc->dmmapctr;
+	spin_unlock(&fc->lock);
+
+	req = fuse_get_req(fc);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto fail;
+	}
+
+	/* ask server whether this mmap is okay and what the offset should be */
+	memset(&inarg, 0, sizeof(inarg));
+	inarg.fh = ff->fh;
+	inarg.mh = fdvm->mh;
+	inarg.addr = vma->vm_start;
+	inarg.len = fdvm->len;
+	inarg.prot = ((vma->vm_flags & VM_READ) ? PROT_READ : 0) |
+		     ((vma->vm_flags & VM_WRITE) ? PROT_WRITE : 0) |
+		     ((vma->vm_flags & VM_EXEC) ? PROT_EXEC : 0);
+	inarg.flags = ((vma->vm_flags & VM_GROWSDOWN) ? MAP_GROWSDOWN : 0) |
+		      ((vma->vm_flags & VM_DENYWRITE) ? MAP_DENYWRITE : 0) |
+		      ((vma->vm_flags & VM_EXECUTABLE) ? MAP_EXECUTABLE : 0) |
+		      ((vma->vm_flags & VM_LOCKED) ? MAP_LOCKED : 0);
+	inarg.offset = (loff_t)vma->vm_pgoff << PAGE_SHIFT;
+
+	req->in.h.opcode = FUSE_MMAP;
+	req->in.h.nodeid = ff->nodeid;
+	req->in.numargs = 1;
+	req->in.args[0].size = sizeof(inarg);
+	req->in.args[0].value = &inarg;
+	req->out.numargs = 1;
+	req->out.args[0].size = sizeof(outarg);
+	req->out.args[0].value = &outarg;
+
+	fuse_request_send(fc, req);
+	err = req->out.h.error;
+	if (err) {
+		if (err == -ENOSYS)
+			fc->no_dmmap = 1;
+		goto fail;
+	}
+
+	/*
+	 * Make sure the returned offset has the same SHMLBA alignment
+	 * as the requested one; otherwise, virtual cache aliasing may
+	 * happen.  This checks also makes sure that the offset is
+	 * page aligned.
+	 */
+	if ((outarg.offset & (SHMLBA - 1)) != (inarg.offset & (SHMLBA - 1))) {
+		if (!fc->dmmap_misalign_warned) {
+			pr_err("FUSE: mmap offset 0x%lx returned by server "
+			       "is misaligned, failing mmap\n",
+			       (unsigned long)outarg.offset);
+			fc->dmmap_misalign_warned = 1;
+		}
+		err = -EINVAL;
+		goto fail;
+	}
+
+	/* initialize @vma accordingly */
+	vma->vm_pgoff = outarg.offset >> PAGE_SHIFT;
+	vma->vm_ops = &fuse_dmmap_vm_ops;
+	vma->vm_private_data = fdvm;
+
+	vma->vm_flags |= VM_DONTEXPAND;		/* disallow expansion for now */
+	if (outarg.flags & FUSE_MMAP_DONT_COPY)
+		vma->vm_flags |= VM_DONTCOPY;
+
+	fuse_put_request(fc, req);
+	return 0;
+
+fail:
+	kfree(fdvm);
+	if (req)
+		fuse_put_request(fc, req);
+	return err;
+}
+EXPORT_SYMBOL_GPL(fuse_do_dmmap);
+
+static int fuse_direct_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file->f_dentry->d_inode;
+	int ret;
+
+	if (is_bad_inode(inode))
+		return -EIO;
+
+	ret = fuse_do_dmmap(file, vma);
+	if (ret != -ENOSYS)
+		return ret;
+
+	/*
+	 * Fall back to generic mmap.
+	 * Generic mmap can't provide the coherency needed for MAP_SHARED.
+	 */
+	if (vma->vm_flags & VM_MAYSHARE)
+		return -ENODEV;
+
+	invalidate_inode_pages2(file->f_mapping);
+
+	return generic_file_mmap(file, vma);
+}
+
 static const struct file_operations fuse_file_operations = {
 	.llseek		= fuse_file_llseek,
 	.read		= do_sync_read,
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 01cc462..32f01dd 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -21,6 +21,7 @@
 #include <linux/rwsem.h>
 #include <linux/rbtree.h>
 #include <linux/poll.h>
+#include <linux/radix-tree.h>
 
 /** Max number of pages that can be used in a single read request */
 #define FUSE_MAX_PAGES_PER_REQ 32
@@ -270,6 +271,7 @@ struct fuse_req {
 			struct fuse_write_out out;
 		} write;
 		struct fuse_lk_in lk_in;
+		struct fuse_munmap_in munmap_in;
 	} misc;
 
 	/** page vector */
@@ -447,6 +449,12 @@ struct fuse_conn {
 	/** Is poll not implemented by fs? */
 	unsigned no_poll:1;
 
+	/** Is direct mmap not implemente by fs? */
+	unsigned no_dmmap:1;
+
+	/** Already warned unaligned direct mmap */
+	unsigned dmmap_misalign_warned:1;
+
 	/** Do multi-page cached writes */
 	unsigned big_writes:1;
 
@@ -494,6 +502,12 @@ struct fuse_conn {
 
 	/** Read/write semaphore to hold when accessing sb. */
 	struct rw_semaphore killsb;
+
+	/** dmmap unique id */
+	u64 dmmapctr;
+
+	/** Direct mmap regions */
+	struct rb_root dmmap_regions;
 };
 
 static inline struct fuse_conn *get_fuse_conn_super(struct super_block *sb)
@@ -746,4 +760,9 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 unsigned fuse_file_poll(struct file *file, poll_table *wait);
 int fuse_dev_release(struct inode *inode, struct file *file);
 
+int fuse_dmmap_find_get_page(struct fuse_conn *fc, pgoff_t pgoff,
+			     struct page **pagep);
+
+int fuse_do_dmmap(struct file *file, struct vm_area_struct *vma);
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1a822ce..8557b59 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -541,6 +541,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->blocked = 1;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
+	fc->dmmap_regions = RB_ROOT;
 }
 EXPORT_SYMBOL_GPL(fuse_conn_init);
 
diff --git a/include/linux/fuse.h b/include/linux/fuse.h
index 3e2925a..44bf759 100644
--- a/include/linux/fuse.h
+++ b/include/linux/fuse.h
@@ -209,6 +209,13 @@ struct fuse_file_lock {
  */
 #define FUSE_POLL_SCHEDULE_NOTIFY (1 << 0)
 
+/**
+ * Mmap flags
+ *
+ * FUSE_MMAP_DONT_COPY: don't copy the region on fork
+ */
+#define FUSE_MMAP_DONT_COPY	(1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP	   = 1,
 	FUSE_FORGET	   = 2,  /* no reply */
@@ -248,6 +255,8 @@ enum fuse_opcode {
 	FUSE_DESTROY       = 38,
 	FUSE_IOCTL         = 39,
 	FUSE_POLL          = 40,
+	FUSE_MMAP          = 41,
+	FUSE_MUNMAP        = 42,
 
 	/* CUSE specific operations */
 	CUSE_INIT          = 4096,
@@ -523,6 +532,29 @@ struct fuse_notify_poll_wakeup_out {
 	__u64	kh;
 };
 
+struct fuse_mmap_in {
+	__u64	fh;
+	__u64	mh;
+	__u64	addr;
+	__u64	len;
+	__u32	prot;
+	__u32	flags;
+	__u64	offset;
+};
+
+struct fuse_mmap_out {
+	__u64	offset;
+	__u32	flags;
+	__u32	padding;
+};
+
+struct fuse_munmap_in {
+	__u64	fh;
+	__u64	mh;
+	__u64	len;
+	__u64	offset;
+};
+
 struct fuse_in_header {
 	__u32	len;
 	__u32	opcode;
-- 
1.6.4.2

