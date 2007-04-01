Return-Path: <linux-kernel-owner+w=401wt.eu-S933367AbXDAOgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbXDAOgu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 10:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933331AbXDAOgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 10:36:16 -0400
Received: from il.qumranet.com ([82.166.9.18]:47561 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933313AbXDAOfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 10:35:46 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 38/41] KVM: Simply gfn_to_page()
Date: Sun,  1 Apr 2007 17:35:35 +0300
Message-Id: <117543813933-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.5
In-Reply-To: <1175438139458-git-send-email-avi@qumranet.com>
References: <1175438138288-git-send-email-avi@qumranet.com> <11754381381990-git-send-email-avi@qumranet.com> <11754381384009-git-send-email-avi@qumranet.com> <1175438138805-git-send-email-avi@qumranet.com> <11754381382515-git-send-email-avi@qumranet.com> <11754381383730-git-send-email-avi@qumranet.com> <11754381383144-git-send-email-avi@qumranet.com> <11754381381597-git-send-email-avi@qumranet.com> <1175438139242-git-send-email-avi@qumranet.com> <1175438139494-git-send-email-avi@qumranet.com> <11754381392046-git-send-email-avi@qumranet.com> <1175438139795-git-send-email-avi@qumranet.com> <1175438139430-git-send-email-avi@qumranet.com> <11754381393496-git-send-email-avi@qumranet.com> <11754381391514-git-send-email-avi@qumranet.com> <11754381392382-git-send-email-avi@qumranet.com> <11754381392358-git-send-email-avi@qumranet.com> <1175438139872-git-send-email-avi@qumranet.com> <11754381392921-git-send-email-avi@qumranet.com> <117543813978-git-send-email-avi@qumranet.com> <117543
 81393061-git-send-email-avi@qumranet.com> <11754381392186-git-send-email-avi@qumranet.com> <117543813916-git-send-email-avi@qumranet.com> <1175438139530-git-send-email-avi@qumranet.com> <1175438139960-git-send-email-avi@qumranet.com> <1175438139816-git-send-email-avi@qumranet.com> <1175438139141-git-send-email-avi@qumranet.com> <11754381391993-git-send-email-avi@qumranet.com> <1175438139877-git-send-email-avi@qumranet.com> <11754381391119-git-send-email-avi@qumranet.com> <1175438139312-git-send-email-avi@qumranet.com> <11754381392527-git-send-email-avi@qumranet.com> <11754381393184-git-send-email-avi@qumranet.com> <1175438139249-git-send-email-avi@qumranet.com> <11754381391161-git-send-email-avi@qumranet.com> <11754381393714-git-send-email-avi@qumranet.com> <11754381392948-git-send-email-avi@qumranet.com> <1175438139458-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mapping a guest page to a host page is a common operation.  Currently,
one has first to find the memory slot where the page belongs (gfn_to_memslot),
then locate the page itself (gfn_to_page()).

This is clumsy, and also won't work well with memory aliases.  So simplify
gfn_to_page() not to require memory slot translation first, and instead do it
internally.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |   12 +-----------
 drivers/kvm/kvm_main.c |   45 +++++++++++++++++++++++++--------------------
 drivers/kvm/mmu.c      |   12 ++++--------
 drivers/kvm/vmx.c      |    6 +++---
 4 files changed, 33 insertions(+), 42 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 59357be..d19985a 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -443,11 +443,7 @@ void kvm_emulator_want_group7_invlpg(void);
 
 extern hpa_t bad_page_address;
 
-static inline struct page *gfn_to_page(struct kvm_memory_slot *slot, gfn_t gfn)
-{
-	return slot->phys_mem[gfn - slot->base_gfn];
-}
-
+struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
 struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn);
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
 
@@ -523,12 +519,6 @@ static inline int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	return vcpu->mmu.page_fault(vcpu, gva, error_code);
 }
 
-static inline struct page *_gfn_to_page(struct kvm *kvm, gfn_t gfn)
-{
-	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
-	return (slot) ? slot->phys_mem[gfn - slot->base_gfn] : NULL;
-}
-
 static inline int is_long_mode(struct kvm_vcpu *vcpu)
 {
 #ifdef CONFIG_X86_64
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 1ef5e9a..aaaf306 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -420,12 +420,12 @@ static int load_pdptrs(struct kvm_vcpu *vcpu, unsigned long cr3)
 	u64 pdpte;
 	u64 *pdpt;
 	int ret;
-	struct kvm_memory_slot *memslot;
+	struct page *page;
 
 	spin_lock(&vcpu->kvm->lock);
-	memslot = gfn_to_memslot(vcpu->kvm, pdpt_gfn);
-	/* FIXME: !memslot - emulate? 0xff? */
-	pdpt = kmap_atomic(gfn_to_page(memslot, pdpt_gfn), KM_USER0);
+	page = gfn_to_page(vcpu->kvm, pdpt_gfn);
+	/* FIXME: !page - emulate? 0xff? */
+	pdpt = kmap_atomic(page, KM_USER0);
 
 	ret = 1;
 	for (i = 0; i < 4; ++i) {
@@ -861,6 +861,17 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_memslot);
 
+struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
+{
+	struct kvm_memory_slot *slot;
+
+	slot = gfn_to_memslot(kvm, gfn);
+	if (!slot)
+		return NULL;
+	return slot->phys_mem[gfn - slot->base_gfn];
+}
+EXPORT_SYMBOL_GPL(gfn_to_page);
+
 void mark_page_dirty(struct kvm *kvm, gfn_t gfn)
 {
 	int i;
@@ -899,20 +910,20 @@ static int emulator_read_std(unsigned long addr,
 		unsigned offset = addr & (PAGE_SIZE-1);
 		unsigned tocopy = min(bytes, (unsigned)PAGE_SIZE - offset);
 		unsigned long pfn;
-		struct kvm_memory_slot *memslot;
-		void *page;
+		struct page *page;
+		void *page_virt;
 
 		if (gpa == UNMAPPED_GVA)
 			return X86EMUL_PROPAGATE_FAULT;
 		pfn = gpa >> PAGE_SHIFT;
-		memslot = gfn_to_memslot(vcpu->kvm, pfn);
-		if (!memslot)
+		page = gfn_to_page(vcpu->kvm, pfn);
+		if (!page)
 			return X86EMUL_UNHANDLEABLE;
-		page = kmap_atomic(gfn_to_page(memslot, pfn), KM_USER0);
+		page_virt = kmap_atomic(page, KM_USER0);
 
-		memcpy(data, page + offset, tocopy);
+		memcpy(data, page_virt + offset, tocopy);
 
-		kunmap_atomic(page, KM_USER0);
+		kunmap_atomic(page_virt, KM_USER0);
 
 		bytes -= tocopy;
 		data += tocopy;
@@ -963,16 +974,14 @@ static int emulator_read_emulated(unsigned long addr,
 static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 			       unsigned long val, int bytes)
 {
-	struct kvm_memory_slot *m;
 	struct page *page;
 	void *virt;
 
 	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
 		return 0;
-	m = gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (!m)
+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (!page)
 		return 0;
-	page = gfn_to_page(m, gpa >> PAGE_SHIFT);
 	kvm_mmu_pre_write(vcpu, gpa, bytes);
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
@@ -2507,15 +2516,11 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 {
 	struct kvm *kvm = vma->vm_file->private_data;
 	unsigned long pgoff;
-	struct kvm_memory_slot *slot;
 	struct page *page;
 
 	*type = VM_FAULT_MINOR;
 	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-	slot = gfn_to_memslot(kvm, pgoff);
-	if (!slot)
-		return NOPAGE_SIGBUS;
-	page = gfn_to_page(slot, pgoff);
+	page = gfn_to_page(kvm, pgoff);
 	if (!page)
 		return NOPAGE_SIGBUS;
 	get_page(page);
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 707f63c..35135ec 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -390,13 +390,11 @@ static void rmap_write_protect(struct kvm_vcpu *vcpu, u64 gfn)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct page *page;
-	struct kvm_memory_slot *slot;
 	struct kvm_rmap_desc *desc;
 	u64 *spte;
 
-	slot = gfn_to_memslot(kvm, gfn);
-	BUG_ON(!slot);
-	page = gfn_to_page(slot, gfn);
+	page = gfn_to_page(kvm, gfn);
+	BUG_ON(!page);
 
 	while (page_private(page)) {
 		if (!(page_private(page) & 1))
@@ -711,14 +709,12 @@ hpa_t safe_gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 
 hpa_t gpa_to_hpa(struct kvm_vcpu *vcpu, gpa_t gpa)
 {
-	struct kvm_memory_slot *slot;
 	struct page *page;
 
 	ASSERT((gpa & HPA_ERR_MASK) == 0);
-	slot = gfn_to_memslot(vcpu->kvm, gpa >> PAGE_SHIFT);
-	if (!slot)
+	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+	if (!page)
 		return gpa | HPA_ERR_MASK;
-	page = gfn_to_page(slot, gpa >> PAGE_SHIFT);
 	return ((hpa_t)page_to_pfn(page) << PAGE_SHIFT)
 		| (gpa & (PAGE_SIZE-1));
 }
diff --git a/drivers/kvm/vmx.c b/drivers/kvm/vmx.c
index b64b7b7..61a6116 100644
--- a/drivers/kvm/vmx.c
+++ b/drivers/kvm/vmx.c
@@ -926,9 +926,9 @@ static int init_rmode_tss(struct kvm* kvm)
 	gfn_t fn = rmode_tss_base(kvm) >> PAGE_SHIFT;
 	char *page;
 
-	p1 = _gfn_to_page(kvm, fn++);
-	p2 = _gfn_to_page(kvm, fn++);
-	p3 = _gfn_to_page(kvm, fn);
+	p1 = gfn_to_page(kvm, fn++);
+	p2 = gfn_to_page(kvm, fn++);
+	p3 = gfn_to_page(kvm, fn);
 
 	if (!p1 || !p2 || !p3) {
 		kvm_printf(kvm,"%s: gfn_to_page failed\n", __FUNCTION__);
-- 
1.5.0.5

