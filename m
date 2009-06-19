Return-Path: <linux-kernel-owner+w=401wt.eu-S1759495AbZFSNSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759495AbZFSNSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 09:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757806AbZFSNQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 09:16:56 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:9345 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbZFSNQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 09:16:49 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KLHM7O-01-2N9-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <marcelo@kvack.org>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 2/8] kvm: change memslot data structures for multiple hugepage sizes
Date: Fri, 19 Jun 2009 15:16:23 +0200
Message-ID: <1245417389-5527-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
References: <1245417389-5527-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 19 Jun 2009 13:16:38.0475 (UTC) FILETIME=[2D9379B0:01C9F0E0]
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
 arch/x86/kvm/mmu.c                  |   30 ++++++++++---------
 arch/x86/kvm/paging_tmpl.h          |    3 +-
 include/linux/kvm_host.h            |    2 +-
 virt/kvm/kvm_main.c                 |   53 +++++++++++++++++++++++-----------
 7 files changed, 65 insertions(+), 41 deletions(-)

diff --git a/arch/ia64/include/asm/kvm_host.h b/arch/ia64/include/asm/kvm_host.h
index 9cf1c4b..d9b6325 100644
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
index 3625424..10e884e 100644
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
index c7b0cc2..930bac2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -53,12 +53,12 @@
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
index edf3dea..1f24d88 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -394,9 +394,9 @@ static int *slot_largepage_idx(gfn_t gfn, struct kvm_memory_slot *slot)
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
@@ -485,10 +485,10 @@ static unsigned long *gfn_to_rmap(struct kvm *kvm, gfn_t gfn, int lpage)
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
@@ -724,11 +724,11 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
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
 
@@ -1852,8 +1852,9 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
 	pfn_t pfn;
 	unsigned long mmu_seq;
 
-	if (is_largepage_backed(vcpu, gfn & ~(KVM_PAGES_PER_HPAGE-1))) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
+	if (is_largepage_backed(vcpu, gfn &
+			~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1))) {
+		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		largepage = 1;
 	}
 
@@ -2058,8 +2059,9 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa,
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
@@ -2461,7 +2463,7 @@ static void mmu_guess_page_from_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
 	gfn = (gpte & PT64_BASE_ADDR_MASK) >> PAGE_SHIFT;
 
 	if (is_large_pte(gpte) && is_largepage_backed(vcpu, gfn)) {
-		gfn &= ~(KVM_PAGES_PER_HPAGE-1);
+		gfn &= ~(KVM_PAGES_PER_HPAGE(PT_DIRECTORY_LEVEL) - 1);
 		vcpu->arch.update_pte.largepage = 1;
 	}
 	vcpu->arch.update_pte.mmu_seq = vcpu->kvm->mmu_notifier_seq;
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 322e811..53e129c 100644
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
index 1b48092..b3fa28f 100644
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
index 8939ffa..c5e6d13 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -995,19 +995,25 @@ out:
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
@@ -1081,7 +1087,8 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	int r;
 	gfn_t base_gfn;
 	unsigned long npages, ugfn;
-	unsigned long largepages, i;
+	int lpages;
+	unsigned long i, j;
 	struct kvm_memory_slot *memslot;
 	struct kvm_memory_slot old, new;
 
@@ -1155,33 +1162,45 @@ int __kvm_set_memory_region(struct kvm *kvm,
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
+			new.lpage_info[i][lpages - 1].write_count = 1;
 		ugfn = new.userspace_addr >> PAGE_SHIFT;
 		/*
 		 * If the gfn and userspace address are not aligned wrt each
 		 * other, or if explicitly asked to, disable large page
 		 * support for this slot
 		 */
-		if ((base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE - 1) ||
+		if ((base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1) ||
 		    !largepages_enabled)
-			for (i = 0; i < largepages; ++i)
-				new.lpage_info[i].write_count = 1;
+			for (j = 0; j < lpages; ++j)
+				new.lpage_info[i][j].write_count = 1;
 	}
 
+skip_lpage:
+
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
 		unsigned dirty_bytes = ALIGN(npages, BITS_PER_LONG) / 8;
-- 
1.6.3.1


