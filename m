Return-Path: <linux-kernel-owner+w=401wt.eu-S1757741AbXL3HU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741AbXL3HU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 02:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756421AbXL3HLV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 02:11:21 -0500
Received: from il.qumranet.com ([82.166.9.18]:59500 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbXL3HKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 02:10:48 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 34/52] KVM: MMU: Selectively set PageDirty when releasing guest memory
Date: Sun, 30 Dec 2007 09:10:20 +0200
Message-Id: <1198998638-22713-35-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198998638-22713-1-git-send-email-avi@qumranet.com>
References: <1198998638-22713-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@localhost.localdomain>

Improve dirty bit setting for pages that kvm release, until now every page
that we released we marked dirty, from now only pages that have potential
to get dirty we mark dirty.

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h         |    3 ++-
 drivers/kvm/kvm_main.c    |   12 +++++++++---
 drivers/kvm/mmu.c         |   23 +++++++++++++++--------
 drivers/kvm/paging_tmpl.h |   12 ++++++------
 drivers/kvm/x86.c         |    2 +-
 5 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 52e8018..c2acd74 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -393,7 +393,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 			    int user_alloc);
 gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn);
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn);
-void kvm_release_page(struct page *page);
+void kvm_release_page_clean(struct page *page);
+void kvm_release_page_dirty(struct page *page);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 9c94491..f06fa3a 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -543,13 +543,19 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 
 EXPORT_SYMBOL_GPL(gfn_to_page);
 
-void kvm_release_page(struct page *page)
+void kvm_release_page_clean(struct page *page)
+{
+	put_page(page);
+}
+EXPORT_SYMBOL_GPL(kvm_release_page_clean);
+
+void kvm_release_page_dirty(struct page *page)
 {
 	if (!PageReserved(page))
 		SetPageDirty(page);
 	put_page(page);
 }
-EXPORT_SYMBOL_GPL(kvm_release_page);
+EXPORT_SYMBOL_GPL(kvm_release_page_dirty);
 
 static int next_segment(unsigned long len, int offset)
 {
@@ -1055,7 +1061,7 @@ static struct page *kvm_vm_nopage(struct vm_area_struct *vma,
 	/* current->mm->mmap_sem is already held so call lockless version */
 	page = __gfn_to_page(kvm, pgoff);
 	if (is_error_page(page)) {
-		kvm_release_page(page);
+		kvm_release_page_clean(page);
 		return NOPAGE_SIGBUS;
 	}
 	if (type != NULL)
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 8add4d5..4624f37 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -420,14 +420,18 @@ static void rmap_remove(struct kvm *kvm, u64 *spte)
 	struct kvm_rmap_desc *desc;
 	struct kvm_rmap_desc *prev_desc;
 	struct kvm_mmu_page *page;
+	struct page *release_page;
 	unsigned long *rmapp;
 	int i;
 
 	if (!is_rmap_pte(*spte))
 		return;
 	page = page_header(__pa(spte));
-	kvm_release_page(pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >>
-			 PAGE_SHIFT));
+	release_page = pfn_to_page((*spte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT);
+	if (is_writeble_pte(*spte))
+		kvm_release_page_dirty(release_page);
+	else
+		kvm_release_page_clean(release_page);
 	rmapp = gfn_to_rmap(kvm, page->gfns[spte - page->spt]);
 	if (!*rmapp) {
 		printk(KERN_ERR "rmap_remove: %p %llx 0->BUG\n", spte, *spte);
@@ -893,7 +897,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 {
 	int level = PT32E_ROOT_LEVEL;
 	hpa_t table_addr = vcpu->mmu.root_hpa;
+	struct page *page;
 
+	page = pfn_to_page(p >> PAGE_SHIFT);
 	for (; ; level--) {
 		u32 index = PT64_INDEX(v, level);
 		u64 *table;
@@ -908,7 +914,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 			pte = table[index];
 			was_rmapped = is_rmap_pte(pte);
 			if (is_shadow_present_pte(pte) && is_writeble_pte(pte)) {
-				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
+				kvm_release_page_clean(page);
 				return 0;
 			}
 			mark_page_dirty(vcpu->kvm, v >> PAGE_SHIFT);
@@ -918,7 +924,8 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 			if (!was_rmapped)
 				rmap_add(vcpu, &table[index], v >> PAGE_SHIFT);
 			else
-				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
+				kvm_release_page_clean(page);
+
 			return 0;
 		}
 
@@ -933,7 +940,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, hpa_t p)
 						     1, 3, &table[index]);
 			if (!new_table) {
 				pgprintk("nonpaging_map: ENOMEM\n");
-				kvm_release_page(pfn_to_page(p >> PAGE_SHIFT));
+				kvm_release_page_clean(page);
 				return -ENOMEM;
 			}
 
@@ -1049,8 +1056,8 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gva_t gva,
 	paddr = gpa_to_hpa(vcpu->kvm, addr & PT64_BASE_ADDR_MASK);
 
 	if (is_error_hpa(paddr)) {
-		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-				 >> PAGE_SHIFT));
+		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+				       >> PAGE_SHIFT));
 		return 1;
 	}
 
@@ -1580,7 +1587,7 @@ static void audit_mappings_page(struct kvm_vcpu *vcpu, u64 page_pte,
 				       " valid guest gva %lx\n", audit_msg, va);
 			page = pfn_to_page((gpa & PT64_BASE_ADDR_MASK)
 					   >> PAGE_SHIFT);
-			kvm_release_page(page);
+			kvm_release_page_clean(page);
 
 		}
 	}
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 77a2b22..bf15d12 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -212,8 +212,8 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	if (is_error_hpa(paddr)) {
 		set_shadow_pte(shadow_pte,
 			       shadow_trap_nonpresent_pte | PT_SHADOW_IO_MARK);
-		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-					     >> PAGE_SHIFT));
+		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+				       >> PAGE_SHIFT));
 		return;
 	}
 
@@ -259,12 +259,12 @@ unshadowed:
 
 			page = pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
 					   >> PAGE_SHIFT);
-			kvm_release_page(page);
+			kvm_release_page_clean(page);
 		}
 	}
 	else
-		kvm_release_page(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
-				 >> PAGE_SHIFT));
+		kvm_release_page_clean(pfn_to_page((paddr & PT64_BASE_ADDR_MASK)
+				       >> PAGE_SHIFT));
 	if (!ptwrite || !*ptwrite)
 		vcpu->last_pte_updated = shadow_pte;
 }
@@ -503,7 +503,7 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 		else
 			sp->spt[i] = shadow_notrap_nonpresent_pte;
 	kunmap_atomic(gpt, KM_USER0);
-	kvm_release_page(page);
+	kvm_release_page_clean(page);
 }
 
 #undef pt_element_t
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 5a1b72f..6212984 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -1472,7 +1472,7 @@ static void free_pio_guest_pages(struct kvm_vcpu *vcpu)
 
 	for (i = 0; i < ARRAY_SIZE(vcpu->pio.guest_pages); ++i)
 		if (vcpu->pio.guest_pages[i]) {
-			kvm_release_page(vcpu->pio.guest_pages[i]);
+			kvm_release_page_dirty(vcpu->pio.guest_pages[i]);
 			vcpu->pio.guest_pages[i] = NULL;
 		}
 }
-- 
1.5.3.7

