Return-Path: <linux-kernel-owner+w=401wt.eu-S1765458AbYDYXWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765458AbYDYXWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756931AbYDYXWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:22:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:44854 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754988AbYDYXW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:22:29 -0400
Date: Fri, 25 Apr 2008 19:20:00 -0400
Message-Id: <200804252320.m3PNK0Bw014449@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Subject: [PATCH] VM: vm_ops->fault takes explicit struct file
Cc: krh@redhat.com, stefanr@s5r6.in-berlin.de, airlied@linux.ie,
       rolandd@cisco.com, James.Bottomley@HansenPartnership.com,
       hjk@linutronix.de, vandrove@vc.cvut.cz, mfasheh@suse.com,
       hugh@veritas.com, perex@perex.cz, avi@qumranet.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some stackable file systems don't change the file data between the layers.
Unionfs is one such example. (eCryptfs, on the other hand, does change it's
data between the cleartext and ciphertext layers.)  Stackable file systems
that don't change the data across layers can implement the simpler one
vm_operations->fault operation instead of implementing a substantial subset
of address_space_operations.

There's a problem in implementing ->fault in a stackable file system.  The
->fault method takes a vma field which includes the vma->vm_file field --
the file on which we're operating.  A stackable file system has both an
upper layer struct file and a lower layer one.  Therefore, an implementation
of ->fault for a stackable layer has to look something like this:

	struct file *lower_file, *saved_upper_file;
	saved_upper_file = vma->vm_file;
	lower_file = get_lower_file_from_upper_file(saved_upper_file);
	vma->vm_file = lower_file; // temporary override
	call the lower vm_ops->fault(vma, vmf);
	vma->vm_file = saved_upper_file; // reset back to normal

The above code has a race which is easily triggered by LTP's mm tests.  The
problem is that ->fault can be called concurrently and without any
serialization or locking by the VM.  The above code temporarily overrides
and then resets back the value of vma->vm_file.  A concurrent call of
->fault could find the wrong value of vma->vm_file, causing an oops.
(Locking at this low level function is not easily accomplished, if at all
possible.)  Unionfs currently works around this race by copying the vma onto
the stack, which is a suboptimal solution (see the patch in
<http://lkml.org/lkml/2008/4/25/445>).

A cleaner solution to this was proposed at LSF'08 by Christoph Hellwig:
change the ->fault API to also take an explicit struct file.  That way each
user implementing a ->fault op will have to take its file from a passed on
argument, not from inside the vma it gets.  The patch here implements this
API change for 2.6.25-4569-gb69d398.  It was tested for unionfs as well
(using a small add-on unionfs-only patch, not included here), and verified
(via LTP's mm tests) that the race is gone.

For convenience of review and bisectability, I present the changes as one
patch here.  If desired, I can split it for each subsystem.

Cheers,
Erez.


Diffstats:

 drivers/char/drm/drm_vm.c                    |   38 ++++++++++++++++-----------
 drivers/ieee1394/dma.c                       |    2 -
 drivers/infiniband/hw/ipath/ipath_file_ops.c |    2 -
 drivers/media/video/videobuf-dma-sg.c        |    3 +-
 drivers/scsi/sg.c                            |    3 +-
 drivers/uio/uio.c                            |    3 +-
 drivers/video/fb_defio.c                     |    2 -
 fs/ncpfs/mmap.c                              |    3 --
 fs/ocfs2/mmap.c                              |    5 ++-
 include/linux/mm.h                           |    6 ++--
 ipc/shm.c                                    |    6 ++--
 kernel/relay.c                               |    3 +-
 mm/filemap.c                                 |    5 ++-
 mm/filemap_xip.c                             |    4 +-
 mm/hugetlb.c                                 |    3 +-
 mm/memory.c                                  |    2 -
 mm/mmap.c                                    |    2 -
 mm/shmem.c                                   |    5 ++-
 sound/core/pcm_native.c                      |    6 ++--
 sound/usb/usx2y/usX2Yhwdep.c                 |    2 -
 sound/usb/usx2y/usx2yhwdeppcm.c              |    2 -
 virt/kvm/kvm_main.c                          |   10 ++++---
 22 files changed, 68 insertions(+), 49 deletions(-)


--cut-here----cut-here----cut-here----cut-here----cut-here----cut-here--

VM: vm_ops->fault takes explicit struct file

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>

diff --git a/drivers/char/drm/drm_vm.c b/drivers/char/drm/drm_vm.c
index 3d65c4d..0bd02a9 100644
--- a/drivers/char/drm/drm_vm.c
+++ b/drivers/char/drm/drm_vm.c
@@ -76,9 +76,10 @@ static pgprot_t drm_io_prot(uint32_t map_type, struct vm_area_struct *vma)
  * map, get the page, increment the use count and return it.
  */
 #if __OS_HAS_AGP
-static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			   struct file *file)
 {
-	struct drm_file *priv = vma->vm_file->private_data;
+	struct drm_file *priv = file->private_data;
 	struct drm_device *dev = priv->head->dev;
 	struct drm_map *map = NULL;
 	struct drm_map_list *r_list;
@@ -163,7 +164,8 @@ static int drm_do_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
  * Get the mapping, find the real physical page to map, get the page, and
  * return it.
  */
-static int drm_do_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			       struct file *file)
 {
 	struct drm_map *map = (struct drm_map *) vma->vm_private_data;
 	unsigned long offset;
@@ -272,9 +274,10 @@ static void drm_vm_shm_close(struct vm_area_struct *vma)
  *
  * Determine the page number from the page offset and get it from drm_device_dma::pagelist.
  */
-static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			       struct file *file)
 {
-	struct drm_file *priv = vma->vm_file->private_data;
+	struct drm_file *priv = file->private_data;
 	struct drm_device *dev = priv->head->dev;
 	struct drm_device_dma *dma = dev->dma;
 	unsigned long offset;
@@ -306,10 +309,11 @@ static int drm_do_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
  *
  * Determine the map offset from the page offset and get it from drm_sg_mem::pagelist.
  */
-static int drm_do_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_do_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			      struct file *file)
 {
 	struct drm_map *map = (struct drm_map *) vma->vm_private_data;
-	struct drm_file *priv = vma->vm_file->private_data;
+	struct drm_file *priv = file->private_data;
 	struct drm_device *dev = priv->head->dev;
 	struct drm_sg_mem *entry = dev->sg;
 	unsigned long offset;
@@ -332,24 +336,28 @@ static int drm_do_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return 0;
 }
 
-static int drm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			struct file *file)
 {
-	return drm_do_vm_fault(vma, vmf);
+	return drm_do_vm_fault(vma, vmf, file);
 }
 
-static int drm_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			    struct file *file)
 {
-	return drm_do_vm_shm_fault(vma, vmf);
+	return drm_do_vm_shm_fault(vma, vmf, file);
 }
 
-static int drm_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			    struct file *file)
 {
-	return drm_do_vm_dma_fault(vma, vmf);
+	return drm_do_vm_dma_fault(vma, vmf, file);
 }
 
-static int drm_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int drm_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			   struct file *file)
 {
-	return drm_do_vm_sg_fault(vma, vmf);
+	return drm_do_vm_sg_fault(vma, vmf, file);
 }
 
 /** AGP virtual memory operations */
diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index 73685e7..558c6f1 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -232,7 +232,7 @@ void dma_region_sync_for_device(struct dma_region *dma, unsigned long offset,
 #ifdef CONFIG_MMU
 
 static int dma_region_pagefault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+				struct vm_fault *vmf, struct file *file)
 {
 	struct dma_region *dma = (struct dma_region *)vma->vm_private_data;
 
diff --git a/drivers/infiniband/hw/ipath/ipath_file_ops.c b/drivers/infiniband/hw/ipath/ipath_file_ops.c
index 7e025c8..2be7f4d 100644
--- a/drivers/infiniband/hw/ipath/ipath_file_ops.c
+++ b/drivers/infiniband/hw/ipath/ipath_file_ops.c
@@ -1119,7 +1119,7 @@ bail:
  * ipath_file_vma_fault - handle a VMA page fault.
  */
 static int ipath_file_vma_fault(struct vm_area_struct *vma,
-					struct vm_fault *vmf)
+				struct vm_fault *vmf, struct file *file)
 {
 	struct page *page;
 
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 53fed4b..495cabf 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -386,7 +386,8 @@ videobuf_vm_close(struct vm_area_struct *vma)
  * video capture has.
  */
 static int
-videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+videobuf_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		  struct file *file)
 {
 	struct page *page;
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e5156aa..e1df33c 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1161,7 +1161,8 @@ sg_fasync(int fd, struct file *filp, int mode)
 }
 
 static int
-sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+sg_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+	     struct file *file)
 {
 	Sg_fd *sfp;
 	unsigned long offset, len, sa;
diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index e8a01f2..e9641d1 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -437,7 +437,8 @@ static void uio_vma_close(struct vm_area_struct *vma)
 	idev->vma_count--;
 }
 
-static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			 struct file *file)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
diff --git a/drivers/video/fb_defio.c b/drivers/video/fb_defio.c
index 0f8cfb9..d33a6cd 100644
--- a/drivers/video/fb_defio.c
+++ b/drivers/video/fb_defio.c
@@ -26,7 +26,7 @@
 
 /* this is to find and return the vmalloc-ed fb pages */
 static int fb_deferred_io_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+				struct vm_fault *vmf, struct file *file)
 {
 	unsigned long offset;
 	struct page *page;
diff --git a/fs/ncpfs/mmap.c b/fs/ncpfs/mmap.c
index 5d8dcb9..32be0de 100644
--- a/fs/ncpfs/mmap.c
+++ b/fs/ncpfs/mmap.c
@@ -28,9 +28,8 @@
  * page?
  */
 static int ncp_file_mmap_fault(struct vm_area_struct *area,
-					struct vm_fault *vmf)
+			       struct vm_fault *vmf, struct file *file)
 {
-	struct file *file = area->vm_file;
 	struct dentry *dentry = file->f_path.dentry;
 	struct inode *inode = dentry->d_inode;
 	char *pg_addr;
diff --git a/fs/ocfs2/mmap.c b/fs/ocfs2/mmap.c
index 3dc18d6..b854182 100644
--- a/fs/ocfs2/mmap.c
+++ b/fs/ocfs2/mmap.c
@@ -60,7 +60,8 @@ static inline int ocfs2_vm_op_unblock_sigs(sigset_t *oldset)
 	return sigprocmask(SIG_SETMASK, oldset, NULL);
 }
 
-static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
+static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf,
+		       struct file *file)
 {
 	sigset_t blocked, oldset;
 	int error, ret;
@@ -74,7 +75,7 @@ static int ocfs2_fault(struct vm_area_struct *area, struct vm_fault *vmf)
 		goto out;
 	}
 
-	ret = filemap_fault(area, vmf);
+	ret = filemap_fault(area, vmf, file);
 
 	error = ocfs2_vm_op_unblock_sigs(&oldset);
 	if (error < 0)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3f3ccfe..2e32ed1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -163,7 +163,8 @@ struct vm_fault {
 struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
-	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf,
+		     struct file *file);
 	struct page *(*nopage)(struct vm_area_struct *area,
 			unsigned long address, int *type);
 	unsigned long (*nopfn)(struct vm_area_struct *area,
@@ -1077,7 +1078,8 @@ extern void truncate_inode_pages_range(struct address_space *,
 				       loff_t lstart, loff_t lend);
 
 /* generic vm_area_ops exported for stackable file systems */
-extern int filemap_fault(struct vm_area_struct *, struct vm_fault *);
+extern int filemap_fault(struct vm_area_struct *, struct vm_fault *,
+			 struct file *file);
 
 /* mm/page-writeback.c */
 int write_one_page(struct page *page, int wait);
diff --git a/ipc/shm.c b/ipc/shm.c
index c47e872..eb25f50 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -243,12 +243,12 @@ static void shm_close(struct vm_area_struct *vma)
 	up_write(&shm_ids(ns).rw_mutex);
 }
 
-static int shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		     struct file *file)
 {
-	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 
-	return sfd->vm_ops->fault(vma, vmf);
+	return sfd->vm_ops->fault(vma, vmf, file);
 }
 
 #ifdef CONFIG_NUMA
diff --git a/kernel/relay.c b/kernel/relay.c
index d080b9d..83b92fa 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -39,7 +39,8 @@ static void relay_file_mmap_close(struct vm_area_struct *vma)
 /*
  * fault() vm_op implementation for relay file mapping.
  */
-static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int relay_buf_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			   struct file *file)
 {
 	struct page *page;
 	struct rchan_buf *buf = vma->vm_private_data;
diff --git a/mm/filemap.c b/mm/filemap.c
index 5c74b68..482d579 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1308,6 +1308,7 @@ static int page_cache_read(struct file *file, pgoff_t offset)
  * filemap_fault - read in file data for page fault handling
  * @vma:	vma in which the fault was taken
  * @vmf:	struct vm_fault containing details of the fault
+ * @file:	struct file to use in function (not vma->vm_file)
  *
  * filemap_fault() is invoked via the vma operations vector for a
  * mapped memory region to read in file data during a page fault.
@@ -1316,10 +1317,10 @@ static int page_cache_read(struct file *file, pgoff_t offset)
  * it in the page cache, and handles the special cases reasonably without
  * having a lot of duplicated code.
  */
-int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+int filemap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		  struct file *file)
 {
 	int error;
-	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	struct file_ra_state *ra = &file->f_ra;
 	struct inode *inode = mapping->host;
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 5e598c4..ee68482 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -211,9 +211,9 @@ __xip_unmap (struct address_space * mapping,
  *
  * This function is derived from filemap_fault, but used for execute in place
  */
-static int xip_file_fault(struct vm_area_struct *area, struct vm_fault *vmf)
+static int xip_file_fault(struct vm_area_struct *area, struct vm_fault *vmf,
+			  struct file *file)
 {
-	struct file *file = area->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
 	struct page *page;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 89e6286..e62fab6 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -655,7 +655,8 @@ unsigned long hugetlb_total_pages(void)
  * hugegpage VMA.  do_page_fault() is supposed to trap this, so BUG is we get
  * this far.
  */
-static int hugetlb_vm_op_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int hugetlb_vm_op_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			       struct file *file)
 {
 	BUG();
 	return 0;
diff --git a/mm/memory.c b/mm/memory.c
index ce3c9e4..0e3b2e5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2203,7 +2203,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	BUG_ON(vma->vm_flags & VM_PFNMAP);
 
 	if (likely(vma->vm_ops->fault)) {
-		ret = vma->vm_ops->fault(vma, &vmf);
+		ret = vma->vm_ops->fault(vma, &vmf, vma->vm_file);
 		if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE)))
 			return ret;
 	} else {
diff --git a/mm/mmap.c b/mm/mmap.c
index a32d28c..7b75e0e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -2166,7 +2166,7 @@ int may_expand_vm(struct mm_struct *mm, unsigned long npages)
 
 
 static int special_mapping_fault(struct vm_area_struct *vma,
-				struct vm_fault *vmf)
+				 struct vm_fault *vmf, struct file *file)
 {
 	pgoff_t pgoff;
 	struct page **pages;
diff --git a/mm/shmem.c b/mm/shmem.c
index 90b576c..d32765d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1478,9 +1478,10 @@ failed:
 	return error;
 }
 
-static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+		       struct file *file)
 {
-	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
+	struct inode *inode = file->f_path.dentry->d_inode;
 	int error;
 	int ret;
 
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 61f5d42..cd3e30f 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -2996,7 +2996,7 @@ static unsigned int snd_pcm_capture_poll(struct file *file, poll_table * wait)
  * mmap status record
  */
 static int snd_pcm_mmap_status_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+				     struct vm_fault *vmf, struct file *file)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
@@ -3036,7 +3036,7 @@ static int snd_pcm_mmap_status(struct snd_pcm_substream *substream, struct file
  * mmap control record
  */
 static int snd_pcm_mmap_control_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+				      struct vm_fault *vmf, struct file *file)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
@@ -3091,7 +3091,7 @@ static int snd_pcm_mmap_control(struct snd_pcm_substream *substream, struct file
  * fault callback for mmapping a RAM page
  */
 static int snd_pcm_mmap_data_fault(struct vm_area_struct *area,
-						struct vm_fault *vmf)
+				   struct vm_fault *vmf, struct file *file)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 	struct snd_pcm_runtime *runtime;
diff --git a/sound/usb/usx2y/usX2Yhwdep.c b/sound/usb/usx2y/usX2Yhwdep.c
index 1558a5c..ea69517 100644
--- a/sound/usb/usx2y/usX2Yhwdep.c
+++ b/sound/usb/usx2y/usX2Yhwdep.c
@@ -34,7 +34,7 @@ int usX2Y_hwdep_pcm_new(struct snd_card *card);
 
 
 static int snd_us428ctls_vm_fault(struct vm_area_struct *area,
-				  struct vm_fault *vmf)
+				  struct vm_fault *vmf, struct file *file)
 {
 	unsigned long offset;
 	struct page * page;
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index 117946f..8809275 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -684,7 +684,7 @@ static void snd_usX2Y_hwdep_pcm_vm_close(struct vm_area_struct *area)
 
 
 static int snd_usX2Y_hwdep_pcm_vm_fault(struct vm_area_struct *area,
-					struct vm_fault *vmf)
+					struct vm_fault *vmf, struct file *file)
 {
 	unsigned long offset;
 	void *vaddr;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 32fbf80..89d463a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -670,9 +670,10 @@ void kvm_resched(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_resched);
 
-static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kvm_vcpu_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			  struct file *file)
 {
-	struct kvm_vcpu *vcpu = vma->vm_file->private_data;
+	struct kvm_vcpu *vcpu = file->private_data;
 	struct page *page;
 
 	if (vmf->pgoff == 0)
@@ -978,9 +979,10 @@ out:
 	return r;
 }
 
-static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int kvm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			struct file *file)
 {
-	struct kvm *kvm = vma->vm_file->private_data;
+	struct kvm *kvm = file->private_data;
 	struct page *page;
 
 	if (!kvm_is_visible_gfn(kvm, vmf->pgoff))
