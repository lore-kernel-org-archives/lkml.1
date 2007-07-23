Return-Path: <linux-kernel-owner+w=401wt.eu-S932802AbXGWHBK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932802AbXGWHBK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 03:01:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764245AbXGWG5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:57:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:55412 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763463AbXGWG5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="271462947"
Subject: [RFC 7/8]KVM: swap out guest pages
From: Shaohua Li <shaohua.li@intel.com>
To: kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Avi Kivity <avi@qumranet.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 14:51:45 +0800
Message-Id: <1185173505.2645.71.camel@sli10-conroe.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make KVM guest pages be allocated dynamically and able to be swaped out.

One issue: all inodes returned from anon_inode_getfd are shared,
if one module changes field of the inode, other moduels might break.
Should we introduce a new API to not share inode?

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/kvm/kvm.h      |    8 +
 drivers/kvm/kvm_main.c |  220 +++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 211 insertions(+), 17 deletions(-)

Index: linux/drivers/kvm/kvm.h
===================================================================
--- linux.orig/drivers/kvm/kvm.h	2007-07-20 14:26:10.000000000 +0800
+++ linux/drivers/kvm/kvm.h	2007-07-20 14:29:46.000000000 +0800
@@ -13,6 +13,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
+#include <linux/swap.h>
 #include <asm/signal.h>
 
 #include "vmx.h"
@@ -428,11 +429,15 @@ struct kvm_mem_alias {
 	gfn_t target_gfn;
 };
 
+struct kvm_page_info {
+	swp_entry_t entry;
+};
+
 struct kvm_memory_slot {
 	gfn_t base_gfn;
 	unsigned long npages;
 	unsigned long flags;
-	struct page **phys_mem;
+	struct kvm_page_info *phys_mem;
 	unsigned long *dirty_bitmap;
 };
 
@@ -458,6 +463,7 @@ struct kvm {
 	struct kvm_io_bus mmio_bus;
 	struct kvm_io_bus pio_bus;
 };
+#define kvm_to_address_space(kvm) (kvm->filp->f_mapping)
 
 struct descriptor_table {
 	u16 limit;
Index: linux/drivers/kvm/kvm_main.c
===================================================================
--- linux.orig/drivers/kvm/kvm_main.c	2007-07-20 14:19:14.000000000 +0800
+++ linux/drivers/kvm/kvm_main.c	2007-07-20 14:45:40.000000000 +0800
@@ -26,6 +26,7 @@
 #include <linux/gfp.h>
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
+#include <linux/pagemap.h>
 #include <linux/vmalloc.h>
 #include <linux/reboot.h>
 #include <linux/debugfs.h>
@@ -354,13 +355,14 @@ static void kvm_free_physmem_slot(struct
 {
 	int i;
 
-	if (!dont || free->phys_mem != dont->phys_mem)
-		if (free->phys_mem) {
-			for (i = 0; i < free->npages; ++i)
-				if (free->phys_mem[i])
-					__free_page(free->phys_mem[i]);
-			vfree(free->phys_mem);
+	if ((!dont || free->phys_mem != dont->phys_mem) && free->phys_mem) {
+		for (i = 0; i < free->npages; ++i) {
+			if (free->phys_mem[i].entry.val) {
+				swap_free(free->phys_mem[i].entry);
+			}
 		}
+		vfree(free->phys_mem);
+	}
 
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		vfree(free->dirty_bitmap);
@@ -435,12 +437,19 @@ static int kvm_dev_release(struct inode 
 
 static void kvm_destroy_vm(struct kvm *kvm)
 {
+	struct inode *inode = kvm_to_address_space(kvm)->host;
+
 	spin_lock(&kvm_lock);
 	list_del(&kvm->vm_list);
 	spin_unlock(&kvm_lock);
 	kvm_io_bus_destroy(&kvm->pio_bus);
 	kvm_io_bus_destroy(&kvm->mmio_bus);
 	kvm_free_vcpus(kvm);
+
+	mutex_lock(&inode->i_mutex);
+	truncate_inode_pages(inode->i_mapping, 0);
+	mutex_unlock(&inode->i_mutex);
+
 	kvm_free_physmem(kvm);
 	kfree(kvm);
 }
@@ -761,19 +770,12 @@ raced:
 
 	/* Allocate if a slot is being created */
 	if (npages && !new.phys_mem) {
-		new.phys_mem = vmalloc(npages * sizeof(struct page *));
+		new.phys_mem = vmalloc(npages * sizeof(struct kvm_page_info));
 
 		if (!new.phys_mem)
 			goto out_free;
 
-		memset(new.phys_mem, 0, npages * sizeof(struct page *));
-		for (i = 0; i < npages; ++i) {
-			new.phys_mem[i] = alloc_page(GFP_HIGHUSER
-						     | __GFP_ZERO);
-			if (!new.phys_mem[i])
-				goto out_free;
-			set_page_private(new.phys_mem[i],0);
-		}
+		memset(new.phys_mem, 0, npages * sizeof(struct kvm_page_info));
 	}
 
 	/* Allocate page dirty bitmap if needed */
@@ -980,15 +982,119 @@ struct kvm_memory_slot *gfn_to_memslot(s
 	return __gfn_to_memslot(kvm, gfn);
 }
 
+static struct page *kvm_swapin_page(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_page_info *info;
+	struct address_space *mapping = kvm_to_address_space(kvm);
+	struct page *page;
+
+	slot = __gfn_to_memslot(kvm, gfn);
+	/*
+	 * locking:
+	 * .writepage --- page_lock, kvm->lock
+	 * gfn_to_page --- kvm->lock, page_lock
+	 * but the two locks can't be applied in the same time, as page_lock is
+	 * only required when page is in swap cache. In that time, .writepage
+	 * is finished
+	 */
+	info = &slot->phys_mem[gfn - slot->base_gfn];
+	if (info->entry.val) {
+		/* page is in swap, read page from swap */
+repeat:
+		page = lookup_swap_cache(info->entry);
+		if (!page) {
+			page = read_swap_cache_async(info->entry, NULL, 0);
+			if (!page)
+				return NULL;
+			wait_on_page_locked(page);
+		}
+
+		lock_page(page);
+
+		if (PageWriteback(page)) {
+			wait_on_page_writeback(page);
+			unlock_page(page);
+			page_cache_release(page);
+			goto repeat;
+		}
+
+		if (!PageUptodate(page)) {
+			unlock_page(page);
+			page_cache_release(page);
+			return NULL;
+		}
+
+		delete_from_swap_cache(page);
+		unlock_page(page);
+		swap_free(info->entry);
+		info->entry.val = 0;
+		if (add_to_page_cache(page, mapping, gfn, GFP_KERNEL))
+			return NULL;
+		ClearPageDirty(page);
+	} else {
+		/* allocate new page */
+		page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
+		if (!page)
+			return NULL;
+		if (add_to_page_cache_lru(page, mapping, gfn, GFP_KERNEL)) {
+			page_cache_release(page);
+			return NULL;
+		}
+		SetPageUptodate(page);
+		set_page_private(page, 0);
+	}
+	return page;
+}
+
+#define address_space_to_kvm(m) (m->host->i_private)
+static int kvm_move_to_swap(struct page *page)
+{
+	struct address_space *mapping = page->mapping;
+	struct kvm *kvm = address_space_to_kvm(mapping);
+	struct kvm_memory_slot *slot;
+	gfn_t gfn = page->index;
+	swp_entry_t swap;
+
+	swap = get_swap_page();
+	if (!swap.val)
+		goto redirty;
+
+	if (move_to_swap_cache(page, swap) == 0) {
+		slot = __gfn_to_memslot(kvm, gfn);
+		slot->phys_mem[gfn - slot->base_gfn].entry = swap;
+		return 0;
+	}
+	swap_free(swlock to a mutex.

TBD: after this change, a lot of logic in kvm can be simplified, eg, we
don't need release lock and then do operation blocking. 

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---ap);
+redirty:
+	return AOP_WRITEPAGE_ACTIVATE;
+}
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
+	struct address_space *mapping = kvm_to_address_space(kvm);
+	struct page *page;
 	struct kvm_memory_slot *slot;
 
 	gfn = unalias_gfn(kvm, gfn);
+
 	slot = __gfn_to_memslot(kvm, gfn);
 	if (!slot)
 		return NULL;
-	return slot->phys_mem[gfn - slot->base_gfn];
+
+	page = find_get_page(mapping, gfn);
+	if (page)
+		goto out;
+	page = kvm_swapin_page(kvm, gfn);
+	if (!page)
+		return NULL;
+	set_page_dirty(page);
+	/* page's ref cnt is 2 */
+	unlock_page(page);
+out:
+	mark_page_accessed(page);
+	page_cache_release(page);
+	return page;
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
@@ -2832,6 +2938,7 @@ static struct vm_operations_struct kvm_v
 
 static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	file_accessed(file);
 	vma->vm_ops = &kvm_vm_vm_ops;
 	return 0;
 }
@@ -2843,6 +2950,79 @@ static struct file_operations kvm_vm_fop
 	.mmap           = kvm_vm_mmap,
 };
 
+static int kvm_set_page_dirty(struct page *page)
+{
+	if (!PageDirty(page))
+		SetPageDirty(page);
+	return 0;
+}
+
+static int kvm_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct address_space *mapping = page->mapping;
+	struct kvm *kvm = address_space_to_kvm(mapping);
+	int ret = 0;
+
+	/*
+	 * gfn_to_page is called with kvm->lock hold, which might invoke page
+	 * reclaim. So the .writepage should check if we already hold the lock
+	 * to avoid deadlock.
+	 */
+	if (!mutex_trylock(&kvm->lock)) {
+		set_page_dirty(page);
+		return AOP_WRITEPAGE_ACTIVATE;
+	}
+
+	/*
+	 * We just zap vcpu 0's page table. For a SMP guest, we should zap all
+ 	 * vcpus'. It's better shadow page table is per-vm.
+	 */
+	if (PagePrivate(page))
+		kvm_mmu_zap_pagetbl(&kvm->vcpus[0], page->index);
+
+	ret = kvm_move_to_swap(page);
+	if (ret) {
+		set_page_dirty(page);
+		goto out;
+	}
+	unlock_page(page);
+out:
+	mutex_unlock(&kvm->lock);
+
+	return ret;
+}
+
+static int kvm_releasepage(struct page *page, gfp_t gfp)
+{
+	/*
+	 * should not go here
+	 */
+	BUG();
+	return 0;
+}
+
+static void kvm_invalidatepage(struct page *page, unsigned long offset)
+{
+	/*
+	 * truncate_page is done after vcpu_free, that means all shadow page
+	 * table should be freed already, we should never get here
+	 */
+	BUG();
+}
+
+static struct address_space_operations kvm_aops = {
+	.releasepage = kvm_releasepage,
+	.invalidatepage = kvm_invalidatepage,
+	.writepage = kvm_writepage,
+	.set_page_dirty = kvm_set_page_dirty,
+};
+
+static struct backing_dev_info kvm_backing_dev_info  __read_mostly = {
+	.ra_pages	= 0,	/* No readahead */
+	.capabilities	= BDI_CAP_NO_ACCT_DIRTY|BDI_CAP_NO_WRITEBACK,
+	.unplug_io_fn	= default_unplug_io_fn,
+};
+
 static int kvm_dev_ioctl_create_vm(void)
 {
 	int fd, r;
@@ -2853,12 +3033,20 @@ static int kvm_dev_ioctl_create_vm(void)
 	kvm = kvm_create_vm();
 	if (IS_ERR(kvm))
 		return PTR_ERR(kvm);
+	/*
+	 * Note: all anon inode share an inode, if a module changes the inode's
+	 * field, other modules using anon_inode might break
+	 */
 	r = anon_inode_getfd(&fd, &inode, &file, "kvm-vm", &kvm_vm_fops, kvm);
 	if (r) {
 		kvm_destroy_vm(kvm);
 		return r;
 	}
 
+	inode->i_mapping->a_ops = &kvm_aops;
+	inode->i_mapping->backing_dev_info = &kvm_backing_dev_info;
+	inode->i_private = kvm;
+
 	kvm->filp = file;
 
 	return fd;
