Return-Path: <linux-kernel-owner+w=401wt.eu-S1759705AbYAHLce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759705AbYAHLce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbYAHLc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:32:26 -0500
Received: from ns2.suse.de ([195.135.220.15]:35664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYAHLcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:32:24 -0500
Date: Tue, 8 Jan 2008 12:32:21 +0100
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Jes Sorensen <jes@sgi.com>, Cliff Wickman <cpw@sgi.com>, airlied@linux.ie,
       benh@kernel.crashing.org, michael@ellerman.id.au, jk@ozlabs.org,
       Cedric Le Goater <clg@fr.ibm.com>
Subject: [rfc][patch] reimplement nopfn callers with fault
Message-ID: <20080108113221.GA460@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

I'd like to finally remove nopfn from the tree. So I would really like to get
this patch into -mm soon (or broken out patches into appropriate trees).

Anyway, I don't have a good way to compile mspec or cell changes very easily.
Hopefully if there are any silly typos, they will be easier to fix. More problematic
is actually testing the things; I'm not even sure I'm covering all bases with
drm testing.

So, if I could trouble you for a quick review and/or test at some time.... the
patch is against latest -mm.

Thanks,
Nick

---

From: Nick Piggin <npiggin@suse.de>

Reimplement the existing nopfn handlers with ->fault so we can subsequently remove
nopfn.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Jes Sorensen <jes@sgi.com>
Cc: Cliff Wickman <cpw@sgi.com>
Cc: airlied@linux.ie
Cc: benh@kernel.crashing.org
Cc: michael@ellerman.id.au
Cc: jk@ozlabs.org
Cc: Cedric Le Goater <clg@fr.ibm.com>
---

 arch/powerpc/platforms/cell/spufs/file.c |   85 ++++++++++++++-----------------
 drivers/char/drm/drm_vm.c                |   33 +++++-------
 drivers/char/mspec.c                     |   23 +++++---
 3 files changed, 68 insertions(+), 73 deletions(-)

Index: linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/cell/spufs/file.c
+++ linux-2.6/arch/powerpc/platforms/cell/spufs/file.c
@@ -237,11 +237,10 @@ spufs_mem_write(struct file *file, const
 	return size;
 }
 
-static unsigned long spufs_mem_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int spufs_mem_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct spu_context *ctx	= vma->vm_file->private_data;
-	unsigned long pfn, offset, addr0 = address;
+	unsigned long pfn, offset, address = (unsigned long)vmf->virtual_address;
 #ifdef CONFIG_SPU_FS_64K_LS
 	struct spu_state *csa = &ctx->csa;
 	int psize;
@@ -259,15 +258,14 @@ static unsigned long spufs_mem_mmap_nopf
 	}
 #endif /* CONFIG_SPU_FS_64K_LS */
 
-	offset = (address - vma->vm_start) + (vma->vm_pgoff << PAGE_SHIFT);
+	offset = vmf->pgoff << PAGE_SHIFT;
 	if (offset >= LS_SIZE)
-		return NOPFN_SIGBUS;
+		return VM_FAULT_SIGBUS;
 
-	pr_debug("spufs_mem_mmap_nopfn address=0x%lx -> 0x%lx, offset=0x%lx\n",
-		 addr0, address, offset);
+	pr_debug("spufs_mem_mmap_fault address=0x%lx, offset=0x%lx\n", address, offset);
 
 	if (spu_acquire(ctx))
-		return NOPFN_REFAULT;
+		return VM_FAULT_NOPAGE;
 
 	if (ctx->state == SPU_STATE_SAVED) {
 		vma->vm_page_prot = __pgprot(pgprot_val(vma->vm_page_prot)
@@ -278,16 +276,16 @@ static unsigned long spufs_mem_mmap_nopf
 					     | _PAGE_NO_CACHE);
 		pfn = (ctx->spu->local_store_phys + offset) >> PAGE_SHIFT;
 	}
-	vm_insert_pfn(vma, address, pfn);
+	vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
 	spu_release(ctx);
 
-	return NOPFN_REFAULT;
+	return VM_FAULT_NOPAGE;
 }
 
 
 static struct vm_operations_struct spufs_mem_mmap_vmops = {
-	.nopfn = spufs_mem_mmap_nopfn,
+	.fault = spufs_mem_mmap_fault,
 };
 
 static int spufs_mem_mmap(struct file *file, struct vm_area_struct *vma)
@@ -350,28 +348,27 @@ static const struct file_operations spuf
 #endif
 };
 
-static unsigned long spufs_ps_nopfn(struct vm_area_struct *vma,
-				    unsigned long address,
+static int spufs_ps_fault(struct vm_area_struct *vma,
+				    struct vm_fault *vmf,
 				    unsigned long ps_offs,
 				    unsigned long ps_size)
 {
 	struct spu_context *ctx = vma->vm_file->private_data;
-	unsigned long area, offset = address - vma->vm_start;
+	unsigned long area, offset = vmf->pgoff << PAGE_SHIFT;
 
-	offset += vma->vm_pgoff << PAGE_SHIFT;
 	if (offset >= ps_size)
-		return NOPFN_SIGBUS;
+		return VM_FAULT_SIGBUS;
 
 	/*
 	 * We have to wait for context to be loaded before we have
 	 * pages to hand out to the user, but we don't want to wait
 	 * with the mmap_sem held.
 	 * It is possible to drop the mmap_sem here, but then we need
-	 * to return NOPFN_REFAULT because the mappings may have
+	 * to return VM_FAULT_NOPAGE because the mappings may have
 	 * hanged.
 	 */
 	if (spu_acquire(ctx))
-		return NOPFN_REFAULT;
+		return VM_FAULT_NOPAGE;
 
 	if (ctx->state == SPU_STATE_SAVED) {
 		up_read(&current->mm->mmap_sem);
@@ -379,22 +376,23 @@ static unsigned long spufs_ps_nopfn(stru
 		down_read(&current->mm->mmap_sem);
 	} else {
 		area = ctx->spu->problem_phys + ps_offs;
-		vm_insert_pfn(vma, address, (area + offset) >> PAGE_SHIFT);
+		vm_insert_pfn(vma, (unsigned long)vmf->virtual_address,
+				(area + offset) >> PAGE_SHIFT);
 	}
 
 	spu_release(ctx);
-	return NOPFN_REFAULT;
+	return VM_FAULT_NOPAGE;
 }
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_cntl_mmap_nopfn(struct vm_area_struct *vma,
-					   unsigned long address)
+static int spufs_cntl_mmap_fault(struct vm_area_struct *vma,
+					   struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x4000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x4000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_cntl_mmap_vmops = {
-	.nopfn = spufs_cntl_mmap_nopfn,
+	.fault = spufs_cntl_mmap_fault,
 };
 
 /*
@@ -1074,23 +1072,22 @@ static ssize_t spufs_signal1_write(struc
 	return 4;
 }
 
-static unsigned long spufs_signal1_mmap_nopfn(struct vm_area_struct *vma,
-					      unsigned long address)
+static int spufs_signal1_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 #if PAGE_SIZE == 0x1000
-	return spufs_ps_nopfn(vma, address, 0x14000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x14000, 0x1000);
 #elif PAGE_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_nopfn(vma, address, 0x10000, 0x10000);
+	return spufs_ps_fault(vma, vmf, 0x10000, 0x10000);
 #else
 #error unsupported page size
 #endif
 }
 
 static struct vm_operations_struct spufs_signal1_mmap_vmops = {
-	.nopfn = spufs_signal1_mmap_nopfn,
+	.fault = spufs_signal1_mmap_fault,
 };
 
 static int spufs_signal1_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1211,23 +1208,22 @@ static ssize_t spufs_signal2_write(struc
 }
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_signal2_mmap_nopfn(struct vm_area_struct *vma,
-					      unsigned long address)
+static int spufs_signal2_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 #if PAGE_SIZE == 0x1000
-	return spufs_ps_nopfn(vma, address, 0x1c000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x1c000, 0x1000);
 #elif PAGE_SIZE == 0x10000
 	/* For 64k pages, both signal1 and signal2 can be used to mmap the whole
 	 * signal 1 and 2 area
 	 */
-	return spufs_ps_nopfn(vma, address, 0x10000, 0x10000);
+	return spufs_ps_fault(vma, vmf, 0x10000, 0x10000);
 #else
 #error unsupported page size
 #endif
 }
 
 static struct vm_operations_struct spufs_signal2_mmap_vmops = {
-	.nopfn = spufs_signal2_mmap_nopfn,
+	.fault = spufs_signal2_mmap_fault,
 };
 
 static int spufs_signal2_mmap(struct file *file, struct vm_area_struct *vma)
@@ -1339,14 +1335,13 @@ DEFINE_SPUFS_ATTRIBUTE(spufs_signal2_typ
 		       spufs_signal2_type_set, "%llu", SPU_ATTR_ACQUIRE);
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_mss_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int spufs_mss_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x0000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x0000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_mss_mmap_vmops = {
-	.nopfn = spufs_mss_mmap_nopfn,
+	.fault = spufs_mss_mmap_fault,
 };
 
 /*
@@ -1401,14 +1396,13 @@ static const struct file_operations spuf
 	.mmap	 = spufs_mss_mmap,
 };
 
-static unsigned long spufs_psmap_mmap_nopfn(struct vm_area_struct *vma,
-					    unsigned long address)
+static int spufs_psmap_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x0000, 0x20000);
+	return spufs_ps_fault(vma, vmf, 0x0000, 0x20000);
 }
 
 static struct vm_operations_struct spufs_psmap_mmap_vmops = {
-	.nopfn = spufs_psmap_mmap_nopfn,
+	.fault = spufs_psmap_mmap_fault,
 };
 
 /*
@@ -1461,14 +1455,13 @@ static const struct file_operations spuf
 
 
 #if SPUFS_MMAP_4K
-static unsigned long spufs_mfc_mmap_nopfn(struct vm_area_struct *vma,
-					  unsigned long address)
+static int spufs_mfc_mmap_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	return spufs_ps_nopfn(vma, address, 0x3000, 0x1000);
+	return spufs_ps_fault(vma, vmf, 0x3000, 0x1000);
 }
 
 static struct vm_operations_struct spufs_mfc_mmap_vmops = {
-	.nopfn = spufs_mfc_mmap_nopfn,
+	.fault = spufs_mfc_mmap_fault,
 };
 
 /*
Index: linux-2.6/drivers/char/mspec.c
===================================================================
--- linux-2.6.orig/drivers/char/mspec.c
+++ linux-2.6/drivers/char/mspec.c
@@ -193,25 +193,23 @@ mspec_close(struct vm_area_struct *vma)
 }
 
 /*
- * mspec_nopfn
+ * mspec_fault
  *
  * Creates a mspec page and maps it to user space.
  */
-static unsigned long
-mspec_nopfn(struct vm_area_struct *vma, unsigned long address)
+static int
+mspec_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	unsigned long paddr, maddr;
 	unsigned long pfn;
-	int index;
+	pgoff_t index = vmf->pgoff;
 	struct vma_data *vdata = vma->vm_private_data;
 
-	BUG_ON(address < vdata->vm_start || address >= vdata->vm_end);
-	index = (address - vdata->vm_start) >> PAGE_SHIFT;
 	maddr = (volatile unsigned long) vdata->maddr[index];
 	if (maddr == 0) {
 		maddr = uncached_alloc_page(numa_node_id());
 		if (maddr == 0)
-			return NOPFN_OOM;
+			return VM_FAULT_OOM;
 
 		spin_lock(&vdata->lock);
 		if (vdata->maddr[index] == 0) {
@@ -231,13 +229,20 @@ mspec_nopfn(struct vm_area_struct *vma, 
 
 	pfn = paddr >> PAGE_SHIFT;
 
-	return pfn;
+	/*
+	 * vm_insert_pfn can fail with -EBUSY, but in that case it will
+	 * be because another thread has installed the pte first, so it
+	 * is no problem.
+	 */
+	vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+
+	return VM_FAULT_NOPAGE;
 }
 
 static struct vm_operations_struct mspec_vm_ops = {
 	.open = mspec_open,
 	.close = mspec_close,
-	.nopfn = mspec_nopfn
+	.fault = mspec_fault,
 };
 
 /*
Index: linux-2.6/drivers/char/drm/drm_vm.c
===================================================================
--- linux-2.6.orig/drivers/char/drm/drm_vm.c
+++ linux-2.6/drivers/char/drm/drm_vm.c
@@ -683,8 +683,8 @@ EXPORT_SYMBOL(drm_mmap);
  * \c Pagefault method for buffer objects.
  *
  * \param vma Virtual memory area.
- * \param address File offset.
- * \return Error or refault. The pfn is manually inserted.
+ * \param vmf vm fault data.
+ * \return Error or VM_FAULT_NOPAGE: the pfn is manually inserted.
  *
  * It's important that pfns are inserted while holding the bo->mutex lock.
  * otherwise we might race with unmap_mapping_range() which is always
@@ -696,8 +696,7 @@ EXPORT_SYMBOL(drm_mmap);
  * protected by the bo->mutex lock.
  */
 
-static unsigned long drm_bo_vm_nopfn(struct vm_area_struct *vma,
-				     unsigned long address)
+static int drm_bo_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct drm_buffer_object *bo = (struct drm_buffer_object *) vma->vm_private_data;
 	unsigned long page_offset;
@@ -709,25 +708,22 @@ static unsigned long drm_bo_vm_nopfn(str
 	unsigned long bus_base;
 	unsigned long bus_offset;
 	unsigned long bus_size;
-	unsigned long ret = NOPFN_REFAULT;
-
-	if (address > vma->vm_end)
-		return NOPFN_SIGBUS;
+	unsigned long ret = VM_FAULT_NOPAGE;
 
 	dev = bo->dev;
 	err = drm_bo_read_lock(&dev->bm.bm_lock);
 	if (err)
-		return NOPFN_REFAULT;
+		return VM_FAULT_NOPAGE;
 
 	err = mutex_lock_interruptible(&bo->mutex);
 	if (err) {
 		drm_bo_read_unlock(&dev->bm.bm_lock);
-		return NOPFN_REFAULT;
+		return VM_FAULT_NOPAGE;
 	}
 
 	err = drm_bo_wait(bo, 0, 0, 0);
 	if (err) {
-		ret = (err != -EAGAIN) ? NOPFN_SIGBUS : NOPFN_REFAULT;
+		ret = (err != -EAGAIN) ? VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
 		goto out_unlock;
 	}
 
@@ -742,7 +738,7 @@ static unsigned long drm_bo_vm_nopfn(str
 			DRM_BO_FLAG_FORCE_MAPPABLE;
 		err = drm_bo_move_buffer(bo, new_mask, 0, 0);
 		if (err) {
-			ret = (err != -EAGAIN) ? NOPFN_SIGBUS : NOPFN_REFAULT;
+			ret = (err != -EAGAIN) ? VM_FAULT_SIGBUS : VM_FAULT_NOPAGE;
 			goto out_unlock;
 		}
 	}
@@ -751,11 +747,12 @@ static unsigned long drm_bo_vm_nopfn(str
 				&bus_size);
 
 	if (err) {
-		ret = NOPFN_SIGBUS;
+		ret = VM_FAULT_SIGBUS;
 		goto out_unlock;
 	}
 
-	page_offset = (address - vma->vm_start) >> PAGE_SHIFT;
+	/* XXX: vmf->pgoff may work here, but it adds on vma->vm_pgoff */
+	page_offset = ((unsigned long)vmf->virtual_address - vma->vm_start) >> PAGE_SHIFT;
 
 	if (bus_size) {
 		struct drm_mem_type_manager *man = &dev->bm.man[bo->mem.mem_type];
@@ -768,7 +765,7 @@ static unsigned long drm_bo_vm_nopfn(str
 		drm_ttm_fixup_caching(ttm);
 		page = drm_ttm_get_page(ttm, page_offset);
 		if (!page) {
-			ret = NOPFN_OOM;
+			ret = VM_FAULT_OOM;
 			goto out_unlock;
 		}
 		pfn = page_to_pfn(page);
@@ -777,9 +774,9 @@ static unsigned long drm_bo_vm_nopfn(str
 			drm_io_prot(_DRM_TTM, vma);
 	}
 
-	err = vm_insert_pfn(vma, address, pfn);
+	err = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 	if (err) {
-		ret = (err != -EAGAIN) ? NOPFN_OOM : NOPFN_REFAULT;
+		ret = (err != -EAGAIN) ? VM_FAULT_OOM : VM_FAULT_NOPAGE;
 		goto out_unlock;
 	}
 out_unlock:
@@ -834,7 +831,7 @@ static void drm_bo_vm_close(struct vm_ar
 }
 
 static struct vm_operations_struct drm_bo_vm_ops = {
-	.nopfn = drm_bo_vm_nopfn,
+	.fault = drm_bo_vm_fault,
 	.open = drm_bo_vm_open,
 	.close = drm_bo_vm_close,
 };
