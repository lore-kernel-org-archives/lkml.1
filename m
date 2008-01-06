Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYAFOt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYAFOt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758568AbYAFOkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:24 -0500
Received: from il.qumranet.com ([82.166.9.18]:46653 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757505AbYAFOjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:49 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 28/33] KVM: Add kvm_read_guest_atomic()
Date: Sun,  6 Jan 2008 16:39:34 +0200
Message-Id: <1199630379-28638-29-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

In preparation for a mmu spinlock, add kvm_read_guest_atomic()
and use it in fetch() and prefetch_page().

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/paging_tmpl.h |   28 ++++++++++++++++------------
 include/linux/kvm_host.h   |    2 ++
 virt/kvm/kvm_main.c        |   20 ++++++++++++++++++++
 3 files changed, 38 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 7f83f55..136a65d 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -316,10 +316,12 @@ static u64 *FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 					       metaphysical, access,
 					       shadow_ent, &new_page);
 		if (new_page && !metaphysical) {
+			int r;
 			pt_element_t curr_pte;
-			kvm_read_guest(vcpu->kvm, walker->pte_gpa[level - 2],
-				       &curr_pte, sizeof(curr_pte));
-			if (curr_pte != walker->ptes[level - 2])
+			r = kvm_read_guest_atomic(vcpu->kvm,
+						  walker->pte_gpa[level - 2],
+						  &curr_pte, sizeof(curr_pte));
+			if (r || curr_pte != walker->ptes[level - 2])
 				return NULL;
 		}
 		shadow_addr = __pa(shadow_page->spt);
@@ -429,9 +431,8 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, gva_t vaddr)
 static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 				 struct kvm_mmu_page *sp)
 {
-	int i, offset = 0;
-	pt_element_t *gpt;
-	struct page *page;
+	int i, offset = 0, r = 0;
+	pt_element_t pt;
 
 	if (sp->role.metaphysical
 	    || (PTTYPE == 32 && sp->role.level > PT_PAGE_TABLE_LEVEL)) {
@@ -441,15 +442,18 @@ static void FNAME(prefetch_page)(struct kvm_vcpu *vcpu,
 
 	if (PTTYPE == 32)
 		offset = sp->role.quadrant << PT64_LEVEL_BITS;
-	page = gfn_to_page(vcpu->kvm, sp->gfn);
-	gpt = kmap_atomic(page, KM_USER0);
-	for (i = 0; i < PT64_ENT_PER_PAGE; ++i)
-		if (is_present_pte(gpt[offset + i]))
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; ++i) {
+		gpa_t pte_gpa = gfn_to_gpa(sp->gfn);
+		pte_gpa += (i+offset) * sizeof(pt_element_t);
+
+		r = kvm_read_guest_atomic(vcpu->kvm, pte_gpa, &pt,
+					  sizeof(pt_element_t));
+		if (r || is_present_pte(pt))
 			sp->spt[i] = shadow_trap_nonpresent_pte;
 		else
 			sp->spt[i] = shadow_notrap_nonpresent_pte;
-	kunmap_atomic(gpt, KM_USER0);
-	kvm_release_page_clean(page);
+	}
 }
 
 #undef pt_element_t
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9ff5904..a020fb2 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -167,6 +167,8 @@ void kvm_release_page_clean(struct page *page);
 void kvm_release_page_dirty(struct page *page);
 int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
 			int len);
+int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
+			  unsigned long len);
 int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len);
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 			 int offset, int len);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 396c619..c462d7e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -541,6 +541,26 @@ int kvm_read_guest(struct kvm *kvm, gpa_t gpa, void *data, unsigned long len)
 }
 EXPORT_SYMBOL_GPL(kvm_read_guest);
 
+int kvm_read_guest_atomic(struct kvm *kvm, gpa_t gpa, void *data,
+			  unsigned long len)
+{
+	int r;
+	unsigned long addr;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	int offset = offset_in_page(gpa);
+
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr))
+		return -EFAULT;
+	pagefault_disable();
+	r = __copy_from_user_inatomic(data, (void __user *)addr + offset, len);
+	pagefault_enable();
+	if (r)
+		return -EFAULT;
+	return 0;
+}
+EXPORT_SYMBOL(kvm_read_guest_atomic);
+
 int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn, const void *data,
 			 int offset, int len)
 {
-- 
1.5.3.7

