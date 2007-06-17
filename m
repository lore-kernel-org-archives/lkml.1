Return-Path: <linux-kernel-owner+w=401wt.eu-S1762191AbXFQKBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762191AbXFQKBW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759015AbXFQJpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:45:46 -0400
Received: from il.qumranet.com ([82.166.9.18]:55175 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759016AbXFQJos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:48 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 39/58] KVM: Make shadow pte updates atomic
Date: Sun, 17 Jun 2007 12:44:20 +0300
Message-Id: <11820734812186-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With guest smp, a second vcpu might see partial updates when the first
vcpu services a page fault.  So delay all updates until we have figured
out what the pte should look like.

Note that on i386, this is still not completely atomic as a 64-bit write
will be split into two on a 32-bit machine.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/paging_tmpl.h |   37 ++++++++++++++++++++-----------------
 1 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/kvm/paging_tmpl.h b/drivers/kvm/paging_tmpl.h
index 35f264f..397a403 100644
--- a/drivers/kvm/paging_tmpl.h
+++ b/drivers/kvm/paging_tmpl.h
@@ -205,11 +205,12 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 {
 	hpa_t paddr;
 	int dirty = *gpte & PT_DIRTY_MASK;
-	int was_rmapped = is_rmap_pte(*shadow_pte);
+	u64 spte = *shadow_pte;
+	int was_rmapped = is_rmap_pte(spte);
 
 	pgprintk("%s: spte %llx gpte %llx access %llx write_fault %d"
 		 " user_fault %d gfn %lx\n",
-		 __FUNCTION__, *shadow_pte, (u64)*gpte, access_bits,
+		 __FUNCTION__, spte, (u64)*gpte, access_bits,
 		 write_fault, user_fault, gfn);
 
 	if (write_fault && !dirty) {
@@ -218,34 +219,35 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 		FNAME(mark_pagetable_dirty)(vcpu->kvm, walker);
 	}
 
-	*shadow_pte |= *gpte & PT_PTE_COPY_MASK;
-	*shadow_pte |= access_bits << PT_SHADOW_BITS_OFFSET;
+	spte |= *gpte & PT_PTE_COPY_MASK;
+	spte |= access_bits << PT_SHADOW_BITS_OFFSET;
 	if (!dirty)
 		access_bits &= ~PT_WRITABLE_MASK;
 
 	paddr = gpa_to_hpa(vcpu, gaddr & PT64_BASE_ADDR_MASK);
 
-	*shadow_pte |= PT_PRESENT_MASK;
+	spte |= PT_PRESENT_MASK;
 	if (access_bits & PT_USER_MASK)
-		*shadow_pte |= PT_USER_MASK;
+		spte |= PT_USER_MASK;
 
 	if (is_error_hpa(paddr)) {
-		*shadow_pte |= gaddr;
-		*shadow_pte |= PT_SHADOW_IO_MARK;
-		*shadow_pte &= ~PT_PRESENT_MASK;
+		spte |= gaddr;
+		spte |= PT_SHADOW_IO_MARK;
+		spte &= ~PT_PRESENT_MASK;
+		*shadow_pte = spte;
 		return;
 	}
 
-	*shadow_pte |= paddr;
+	spte |= paddr;
 
-	if (!write_fault && (*shadow_pte & PT_SHADOW_USER_MASK) &&
-	    !(*shadow_pte & PT_USER_MASK)) {
+	if (!write_fault && (spte & PT_SHADOW_USER_MASK) &&
+	    !(spte & PT_USER_MASK)) {
 		/*
 		 * If supervisor write protect is disabled, we shadow kernel
 		 * pages as user pages so we can trap the write access.
 		 */
-		*shadow_pte |= PT_USER_MASK;
-		*shadow_pte &= ~PT_WRITABLE_MASK;
+		spte |= PT_USER_MASK;
+		spte &= ~PT_WRITABLE_MASK;
 		access_bits &= ~PT_WRITABLE_MASK;
 	}
 
@@ -253,7 +255,7 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 	    || (write_fault && !is_write_protection(vcpu) && !user_fault)) {
 		struct kvm_mmu_page *shadow;
 
-		*shadow_pte |= PT_WRITABLE_MASK;
+		spte |= PT_WRITABLE_MASK;
 		if (user_fault) {
 			mmu_unshadow(vcpu, gfn);
 			goto unshadowed;
@@ -264,8 +266,8 @@ static void FNAME(set_pte_common)(struct kvm_vcpu *vcpu,
 			pgprintk("%s: found shadow page for %lx, marking ro\n",
 				 __FUNCTION__, gfn);
 			access_bits &= ~PT_WRITABLE_MASK;
-			if (is_writeble_pte(*shadow_pte)) {
-				*shadow_pte &= ~PT_WRITABLE_MASK;
+			if (is_writeble_pte(spte)) {
+				spte &= ~PT_WRITABLE_MASK;
 				kvm_arch_ops->tlb_flush(vcpu);
 			}
 			if (write_fault)
@@ -278,6 +280,7 @@ unshadowed:
 	if (access_bits & PT_WRITABLE_MASK)
 		mark_page_dirty(vcpu->kvm, gaddr >> PAGE_SHIFT);
 
+	*shadow_pte = spte;
 	page_header_update_slot(vcpu->kvm, shadow_pte, gaddr);
 	if (!was_rmapped)
 		rmap_add(vcpu, shadow_pte);
-- 
1.5.0.6

