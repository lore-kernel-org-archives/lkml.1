Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbXLWPFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbXLWPFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 10:05:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756150AbXLWOw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 09:52:28 -0500
Received: from il.qumranet.com ([82.166.9.18]:35909 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164AbXLWOvr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 09:51:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <avi@qumranet.com>
Subject: [PATCH 47/50] KVM: MMU: Make gfn_to_page() always safe
Date: Sun, 23 Dec 2007 16:51:32 +0200
Message-Id: <1198421495-31481-48-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198421495-31481-1-git-send-email-avi@qumranet.com>
References: <1198421495-31481-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <avi@qumranet.com>

In case the page is not present in the guest memory map, return a dummy
page the guest can scribble on.

This simplifies error checking in its users.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    3 ++-
 drivers/kvm/kvm_main.c    |   26 ++++++++++++++------------
 drivers/kvm/mmu.c         |   16 +++++-----------
 drivers/kvm/paging_tmpl.h |    7 ++-----
 4 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 6ae7b63..0c17c76 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -565,8 +565,9 @@ static inline int is_error_hpa(hpa_t hpa) { return hpa >> HPA_MSB; }
 hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva);
 struct page *gva_to_page(struct kvm_vcpu *vcpu, gva_t gva);
 
-extern hpa_t bad_page_address;
+extern struct page *bad_page;
 
+int is_error_page(struct page *page);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index a1a3be9..ebfb967 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -993,6 +993,12 @@ static int kvm_vm_ioctl_set_irqchip(struct kvm *kvm, struct kvm_irqchip *chip)
 	return r;
 }
 
+int is_error_page(struct page *page)
+{
+	return page == bad_page;
+}
+EXPORT_SYMBOL_GPL(is_error_page);
+
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
@@ -1034,7 +1040,7 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	gfn = unalias_gfn(kvm, gfn);
 	slot = __gfn_to_memslot(kvm, gfn);
 	if (!slot)
-		return NULL;
+		return bad_page;
 	return slot->phys_mem[gfn - slot->base_gfn];
 }
 EXPORT_SYMBOL_GPL(gfn_to_page);
@@ -1054,7 +1060,7 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (!page)
+	if (is_error_page(page))
 		return -EFAULT;
 	page_virt = kmap_atomic(page, KM_USER0);
 
@@ -1092,7 +1098,7 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (!page)
+	if (is_error_page(page))
 		return -EFAULT;
 	page_virt = kmap_atomic(page, KM_USER0);
 
@@ -1130,7 +1136,7 @@ int kvm_clear_guest_page(struct kvm *kvm, gfn_t gfn, int offset, int len)
 	struct page *page;
 
 	page = gfn_to_page(kvm, gfn);
-	if (!page)
+	if (is_error_page(page))
 		return -EFAULT;
 	page_virt = kmap_atomic(page, KM_USER0);
 
@@ -3068,7 +3074,7 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	page = gfn_to_page(kvm, pgoff);
-	if (!page)
+	if (is_error_page(page))
 		return NOPAGE_SIGBUS;
 	get_page(page);
 	if (type != NULL)
@@ -3383,7 +3389,7 @@ static struct sys_device kvm_sysdev = {
 	.cls = &kvm_sysdev_class,
 };
 
-hpa_t bad_page_address;
+struct page *bad_page;
 
 static inline
 struct kvm_vcpu *preempt_notifier_to_vcpu(struct preempt_notifier *pn)
@@ -3512,7 +3518,6 @@ EXPORT_SYMBOL_GPL(kvm_exit_x86);
 
 static __init int kvm_init(void)
 {
-	static struct page *bad_page;
 	int r;
 
 	r = kvm_mmu_module_init();
@@ -3523,16 +3528,13 @@ static __init int kvm_init(void)
 
 	kvm_arch_init();
 
-	bad_page = alloc_page(GFP_KERNEL);
+	bad_page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 
 	if (bad_page == NULL) {
 		r = -ENOMEM;
 		goto out;
 	}
 
-	bad_page_address = page_to_pfn(bad_page) << PAGE_SHIFT;
-	memset(__va(bad_page_address), 0, PAGE_SIZE);
-
 	return 0;
 
 out:
@@ -3545,7 +3547,7 @@ out4:
 static __exit void kvm_exit(void)
 {
 	kvm_exit_debug();
-	__free_page(pfn_to_page(bad_page_address >> PAGE_SHIFT));
+	__free_page(bad_page);
 	kvm_mmu_module_exit();
 }
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index bbf5eb4..2ad14fb 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -850,23 +850,17 @@ static void page_header_update_slot(struct kvm *kvm, void *pte, gpa_t gpa)
 	__set_bit(slot, &page_head->slot_bitmap);
 }
 
-hpa_t safe_gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
-{
-	hpa_t hpa = gpa_to_hpa(kvm, gpa);
-
-	return is_error_hpa(hpa) ? bad_page_address | (gpa & ~PAGE_MASK): hpa;
-}
-
 hpa_t gpa_to_hpa(struct kvm *kvm, gpa_t gpa)
 {
 	struct page *page;
+	hpa_t hpa;
 
 	ASSERT((gpa & HPA_ERR_MASK) == 0);
 	page = gfn_to_page(kvm, gpa >> PAGE_SHIFT);
-	if (!page)
-		return gpa | HPA_ERR_MASK;
-	return ((hpa_t)page_to_pfn(page) << PAGE_SHIFT)
-		| (gpa & (PAGE_SIZE-1));
+	hpa = ((hpa_t)page_to_pfn(page) << PAGE_SHIFT) | (gpa & (PAGE_SIZE-1));
+	if (is_error_page(page))
+		return hpa | HPA_ERR_MASK;
+	return hpa;
 }
 
 hpa_t gva_to_hpa(struct kvm_vcpu *vcpu, gva_t gva)
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index bab1b7f..572e5b6 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -72,8 +72,6 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 			    struct kvm_vcpu *vcpu, gva_t addr,
 			    int write_fault, int user_fault, int fetch_fault)
 {
-	hpa_t hpa;
-	struct kvm_memory_slot *slot;
 	struct page *page;
 	pt_element_t *table;
 	pt_element_t pte;
@@ -105,9 +103,8 @@ static int FNAME(walk_addr)(struct guest_walker *walker,
 		pgprintk("%s: table_gfn[%d] %lx\n", __FUNCTION__,
 			 walker->level - 1, table_gfn);
 
-		slot = gfn_to_memslot(vcpu->kvm, table_gfn);
-		hpa = safe_gpa_to_hpa(vcpu->kvm, pte & PT64_BASE_ADDR_MASK);
-		page = pfn_to_page(hpa >> PAGE_SHIFT);
+		page = gfn_to_page(vcpu->kvm, (pte & PT64_BASE_ADDR_MASK)
+				   >> PAGE_SHIFT);
 
 		table = kmap_atomic(page, KM_USER0);
 		pte = table[index];
-- 
1.5.3.7

