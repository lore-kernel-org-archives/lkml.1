Return-Path: <linux-kernel-owner+w=401wt.eu-S1757253AbZDXMAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757253AbZDXMAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 08:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbZDXL7P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 07:59:15 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:23816
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755013AbZDXL7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 07:59:04 -0400
X-BigFish: VPS9(zz8b9dnzz1202hzzz32i43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KILTA2-01-ALW-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.or>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/7] kvm: change memslot data structures for multiple hugepage sizes
Date: Fri, 24 Apr 2009 13:58:42 +0200
Message-ID: <1240574327-21575-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
References: <1240574327-21575-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 24 Apr 2009 11:58:48.0112 (UTC) FILETIME=[06B0A300:01C9C4D4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/ia64/include/asm/kvm_host.h    |    3 +-
 arch/powerpc/include/asm/kvm_host.h |    3 +-
 arch/x86/include/asm/kvm_host.h     |   12 ++++----
 arch/x86/kvm/mmu.c                  |   30 ++++++++++++----------
 arch/x86/kvm/paging_tmpl.h          |    3 +-
 include/linux/kvm_host.h            |    2 +-
 virt/kvm/kvm_main.c                 |   46 ++++++++++++++++++++++++----------
 7 files changed, 61 insertions(+), 38 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 589536f..8add554 100644
--- a/arch/ia64/include/asm/kvm_host.h
+++ b/arch/ia64/include/asm/kvm_host.h
@@ -235,7 +235,8 @@ struct kvm_vm_data {
 #define KVM_REQ_PTC_G		32
 #define KVM_REQ_RESUME		33
 
-#define KVM_PAGES_PER_HPAGE	1
+#define KVM_NR_PAGE_SIZES	1
+#define KVM_PAGES_PER_HPAGE(x)	1
 
 struct kvm;
 struct kvm_vcpu;
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index dfdf13c..fad04c2 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -34,7 +34,8 @@
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
 /* We don't currently support large pages. */
-#define KVM_PAGES_PER_HPAGE (1<<31)
+#define KVM_NR_PAGE_SIZES	1
+#define KVM_PAGES_PER_HPAGE(x)	(1<<31)
 
 struct kvm;
 struct kvm_run;
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index cb306cf..e0ddbdb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -51,12 +51,12 @@
 #define INVALID_PAGE (~(hpa_t)0)
 #define UNMAPPED_GVA (~(gpa_t)0)
 
-/* shadow tables are PAE even on non-PAE hosts */
-#define KVM_HPAGE_SHIFT 21
-#define KVM_HPAGE_SIZE (1UL << KVM_HPAGE_SHIFT)
-#define KVM_HPAGE_MASK (~(KVM_HPAGE_SIZE - 1))
-
-#define KVM_PAGES_PER_HPAGE (KVM_HPAGE_SIZE / PAGE_SIZE)
+/* KVM Hugepage definitions for x86 */
+#define KVM_NR_PAGE_SIZES	2
+#define KVM_HPAGE_SHIFT(x)	(PAGE_SHIFT + (((x) - 1) * 9))
+#define KVM_HPAGE_SIZE(x)	(1UL << KVM_HPAGE_SHIFT(x))
+#define KVM_HPAGE_MASK(x)	(~(KVM_HPAGE_SIZE(x) - 1))
+#define KVM_PAGES_PER_HPAGE(x)	(KVM_HPAGE_SIZE(x) / PAGE_SIZE)
 
 #define DE_VECTOR 0
 #define DB_VECTOR 1
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 5b79afa..e3421d8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -386,9 +386,9 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
 {
 	unsigned long idx;
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE);
-	return &slot->lpage_info[idx].write_count;
+	idx = (gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL)) -
+	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL));
+	return &slot->lpage_info[0][idx].write_count;
 }
 
 static void account_shadowed(struct kvm *kvm, gfn_t gfn)
@@ -477,10 +477,10 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
 	if (!lpage)
 		return &slot->rmap[gfn - slot->base_gfn];
 
-	idx = (gfn / KVM_PAGES_PER_HPAGE) -
-	      (slot->base_gfn / KVM_PAGES_PER_HPAGE);
+	idx = (gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL)) -
+	      (slot->base_gfn / KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL));
 
-	return &slot->lpage_info[idx].rmap_pde;
+	return &slot->lpage_info[0][idx].rmap_pde;
 }
 
 /*
@@ -716,11 +716,11 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 		end = start + (memslot->npages << PAGE_SHIFT);
 		if (hva >= start && hva < end) {
 			gfn_t gfn_offset = (hva - start) >> PAGE_SHIFT;
+			int idx = gfn_offset /
+			          KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL);
 			retval |= handler(kvm, &memslot->rmap[gfn_offset]);
 			retval |= handler(kvm,
-					  &memslot->lpage_info[
-						  gfn_offset /
-						  KVM_PAGES_PER_HPAGE].rmap_pde);
+					&memslot->lpage_info[0][idx].rmap_pde);
 		}
 	}
 
@@ -1854,8 +1854,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	pfn_t pfn;
 	unsigned long mmu_seq;
 
-	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
+	if (is_largepage_backed(vcpu, gfn &
+			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1))) {
+		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		largepage = 1;
 	}
 
@@ -2041,8 +2042,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
 	if (r)
 		return r;
 
-	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
+	if (is_largepage_backed(vcpu, gfn &
+			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1))) {
+		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		largepage = 1;
 	}
 	mmu_seq = vcpu->kvm->mmu_notifier_seq;
@@ -2443,7 +2445,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	if (is_large_pte(gpte) && is_largepage_backed(vcpu, gfn)) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
+		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		vcpu->arch.update_pte.largepage = 1;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 258e459..3b3ac39 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -401,7 +401,8 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr,
 
 	if (walker.level == PT_DIRECTORY_LEVEL) {
 		gfn_t large_gfn;
-		large_gfn = walker.gfn & ~(KVM_PAGES_PER_HPAGE-1);
+		large_gfn = walker.gfn &
+			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		if (is_largepage_backed(vcpu, large_gfn)) {
 			walker.gfn = large_gfn;
 			largepage = 1;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 095ebb6..0b3cdcf 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -103,7 +103,7 @@ struct kvm_memory_slot {
 	struct {
 		unsigned long rmap_pde;
 		int write_count;
-	} *lpage_info;
+	} *lpage_info[KVM_NR_PAGE_SIZES - 1];
 	unsigned long userspace_addr;
 	int user_alloc;
 };
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3265566..ac5e2f7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -992,19 +992,25 @@ out:
 static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
 				  struct kvm_memory_slot *dont)
 {
+	int i;
+
 	if (!dont || free->rmap != dont->rmap)
 		vfree(free->rmap);
 
 	if (!dont || free->dirty_bitmap != dont->dirty_bitmap)
 		vfree(free->dirty_bitmap);
 
-	if (!dont || free->lpage_info != dont->lpage_info)
-		vfree(free->lpage_info);
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i) {
+		if (!dont || free->lpage_info[i] != dont->lpage_info[i]) {
+			vfree(free->lpage_info[i]);
+			free->lpage_info[i] = NULL;
+		}
+	}
 
 	free->npages = 0;
 	free->dirty_bitmap = NULL;
 	free->rmap = NULL;
-	free->lpage_info = NULL;
 }
 
 void kvm_free_physmem(struct kvm *kvm)
@@ -1076,7 +1082,7 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages;
-	int largepages;
+	int lpages;
 	unsigned long i;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
@@ -1151,23 +1157,35 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		else
 			new.userspace_addr = 0;
 	}
-	if (npages && !new.lpage_info) {
-		largepages = 1 + (base_gfn + npages - 1) / KVM_PAGES_PER_HPAGE;
-		largepages -= base_gfn / KVM_PAGES_PER_HPAGE;
+	if (!npages)
+		goto skip_lpage;
 
-		new.lpage_info = vmalloc(largepages * sizeof(*new.lpage_info));
+	for (i = 0; i < KVM_NR_PAGE_SIZES - 1; ++i) {
+		int level = i + 2;
 
-		if (!new.lpage_info)
+		if (new.lpage_info[i])
+			continue;
+
+		lpages = 1 + (base_gfn + npages - 1) /
+			     KVM_PAGES_PER_HPAGE(level);
+		lpages -= base_gfn / KVM_PAGES_PER_HPAGE(level);
+
+		new.lpage_info[i] = vmalloc(lpages * sizeof(*new.lpage_info[i]));
+
+		if (!new.lpage_info[i])
 			goto out_free;
 
-		memset(new.lpage_info, 0, largepages * sizeof(*new.lpage_info));
+		memset(new.lpage_info[i], 0,
+		       lpages * sizeof(*new.lpage_info[i]));
 
-		if (base_gfn % KVM_PAGES_PER_HPAGE)
-			new.lpage_info[0].write_count = 1;
-		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE)
-			new.lpage_info[largepages-1].write_count = 1;
+		if (base_gfn % KVM_PAGES_PER_HPAGE(level))
+			new.lpage_info[i][0].write_count = 1;
+		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE(level))
+			new.lpage_info[i][lpages-1].write_count = 1;
 	}
 
+skip_lpage:
+
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		unsigned dirty_bytes = ALIGN(npages, BITS_PER_LONG) / 8;
-- 
1.6.2.3


