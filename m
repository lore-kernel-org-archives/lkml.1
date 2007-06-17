Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXFQKBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXFQKBj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759689AbXFQJps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:48 -0400
Received: from il.qumranet.com ([82.166.9.18]:55212 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759263AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 34/58] KVM: MMU: Move set_pte_common() to pte width dependent code
Date: Sun, 17 Jun 2007 12:44:15 +0300
Message-Id: <1182073480677-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of some modifications.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/mmu.c         |   48 --------------------------------------
 drivers/kvm/paging_tmpl.h |   56 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 52 insertions(+), 52 deletions(-)

diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 46491b4..a763150 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -965,54 +965,6 @@ static void paging_new_cr3(struct kvm_vcpu *vcpu)
 	kvm_arch_ops->set_cr3(vcpu, vcpu->mmu.root_hpa);
 }
 
-static inline void set_pte_common(struct kvm_vcpu *vcpu,
-			     u64 *shadow_pte,
-			     gpa_t gaddr,
-			     int dirty,
-			     u64 access_bits,
-			     gfn_t gfn)
-{
-	hpa_t paddr;
-
-	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
-	if (!dirty)
-		access_bits &= ~PT_WRITABLE_MASK;
-
-	paddr = gpa_to_hpa(vcpu, gaddr & PT64_BASE_ADDR_MASK);
-
-	*shadow_pte |= access_bits;
-
-	if (is_error_hpa(paddr)) {
-		*shadow_pte |= gaddr;
-		*shadow_pte |= PT_SHADOW_IO_MARK;
-		*shadow_pte &= ~PT_PRESENT_MASK;
-		return;
-	}
-
-	*shadow_pte |= paddr;
-
-	if (access_bits & PT_WRITABLE_MASK) {
-		struct kvm_mmu_page *shadow;
-
-		shadow = kvm_mmu_lookup_page(vcpu, gfn);
-		if (shadow) {
-			pgprintk("%s: found shadow page for %lx, marking ro\n",
-				 __FUNCTION__, gfn);
-			access_bits &= ~PT_WRITABLE_MASK;
-			if (is_writeble_pte(*shadow_pte)) {
-				    *shadow_pte &= ~PT_WRITABLE_MASK;
-				    kvm_arch_ops->tlb_flush(vcpu);
-			}
-		}
-	}
-
-	if (access_bits & PT_WRITABLE_MASK)
-		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
-
-	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
-	rmap_add(vcpu, shadow_pte);
-}
-
 static void inject_page_fault(struct kvm_vcpu *vcpu,
 			      u64 addr,
 			      u32 err_code)
diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index e094a8b..6576300 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -192,14 +192,62 @@ static void FNAME(mark_pagetable_dirty)(struct kvm *kvm,
 	mark_page_dirty(kvm, walker->table_gfn[walker->level - 1]);
 }
 
+static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
+				  u64 *shadow_pte,
+				  gpa_t gaddr,
+				  int dirty,
+				  u64 access_bits,
+				  gfn_t gfn)
+{
+	hpa_t paddr;
+
+	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
+	if (!dirty)
+		access_bits &= ~PT_WRITABLE_MASK;
+
+	paddr = gpa_to_hpa(vcpu, gaddr & PT64_BASE_ADDR_MASK);
+
+	*shadow_pte |= access_bits;
+
+	if (is_error_hpa(paddr)) {
+		*shadow_pte |= gaddr;
+		*shadow_pte |= PT_SHADOW_IO_MARK;
+		*shadow_pte &= ~PT_PRESENT_MASK;
+		return;
+	}
+
+	*shadow_pte |= paddr;
+
+	if (access_bits & PT_WRITABLE_MASK) {
+		struct kvm_mmu_page *shadow;
+
+		shadow = kvm_mmu_lookup_page(vcpu, gfn);
+		if (shadow) {
+			pgprintk("%s: found shadow page for %lx, marking ro\n",
+				 __FUNCTION__, gfn);
+			access_bits &= ~PT_WRITABLE_MASK;
+			if (is_writeble_pte(*shadow_pte)) {
+				    *shadow_pte &= ~PT_WRITABLE_MASK;
+				    kvm_arch_ops->tlb_flush(vcpu);
+			}
+		}
+	}
+
+	if (access_bits & PT_WRITABLE_MASK)
+		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
+
+	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
+	rmap_add(vcpu, shadow_pte);
+}
+
 static void FNAME(set_pte)(struct kvm_vcpu *vcpu, u64 guest_pte,
 			   u64 *shadow_pte, u64 access_bits, gfn_t gfn)
 {
 	ASSERT(*shadow_pte == 0);
 	access_bits &= guest_pte;
 	*shadow_pte = (guest_pte & PT_PTE_COPY_MASK);
-	set_pte_common(vcpu, shadow_pte, guest_pte & PT_BASE_ADDR_MASK,
-		       guest_pte & PT_DIRTY_MASK, access_bits, gfn);
+	FNAME(set_pte_common)(vcpu, shadow_pte, guest_pte & PT_BASE_ADDR_MASK,
+			      guest_pte & PT_DIRTY_MASK, access_bits, gfn);
 }
 
 static void FNAME(update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *page,
@@ -229,8 +277,8 @@ static void FNAME(set_pde)(struct kvm_vcpu *vcpu, u64 guest_pde,
 		gaddr |= (guest_pde & PT32_DIR_PSE36_MASK) <<
 			(32 - PT32_DIR_PSE36_SHIFT);
 	*shadow_pte = guest_pde & PT_PTE_COPY_MASK;
-	set_pte_common(vcpu, shadow_pte, gaddr,
-		       guest_pde & PT_DIRTY_MASK, access_bits, gfn);
+	FNAME(set_pte_common)(vcpu, shadow_pte, gaddr,
+			      guest_pde & PT_DIRTY_MASK, access_bits, gfn);
 }
 
 /*
-- 
1.5.0.6

