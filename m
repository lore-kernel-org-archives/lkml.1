Return-Path: <linux-kernel-owner+w=401wt.eu-S1760598AbXFQJtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598AbXFQJtv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 05:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbXFQJot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 05:44:49 -0400
Received: from il.qumranet.com ([82.166.9.18]:55161 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758010AbXFQJom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 05:44:42 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 08/58] KVM: Unify kvm_mmu_pre_write() and kvm_mmu_post_write()
Date: Sun, 17 Jun 2007 12:43:49 +0300
Message-Id: <11820734802694-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <1182073479890-git-send-email-avi@qumranet.com>
References: <1182073479890-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling two functions and repeating expensive checks, call one
function and provide it with before/after information.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm.h      |    4 ++--
 drivers/kvm/kvm_main.c |    4 ++--
 drivers/kvm/mmu.c      |   11 ++++-------
 3 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/kvm/kvm.h b/drivers/kvm/kvm.h
index 7facebd..11c519e 100644
--- a/drivers/kvm/kvm.h
+++ b/drivers/kvm/kvm.h
@@ -525,8 +525,8 @@ int kvm_write_guest(struct kvm_vcpu *vcpu,
 
 unsigned long segment_base(u16 selector);
 
-void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
-void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes);
+void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+		       const u8 *old, const u8 *new, int bytes);
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_free_some_pages(struct kvm_vcpu *vcpu);
 
diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 7d68258..b6ad9c6 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -1071,18 +1071,18 @@ static int emulator_write_phys(struct kvm_vcpu *vcpu, gpa_t gpa,
 {
 	struct page *page;
 	void *virt;
+	unsigned offset = offset_in_page(gpa);
 
 	if (((gpa + bytes - 1) >> PAGE_SHIFT) != (gpa >> PAGE_SHIFT))
 		return 0;
 	page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
 	if (!page)
 		return 0;
-	kvm_mmu_pre_write(vcpu, gpa, bytes);
 	mark_page_dirty(vcpu->kvm, gpa >> PAGE_SHIFT);
 	virt = kmap_atomic(page, KM_USER0);
+	kvm_mmu_pte_write(vcpu, gpa, virt + offset, val, bytes);
 	memcpy(virt + offset_in_page(gpa), val, bytes);
 	kunmap_atomic(virt, KM_USER0);
-	kvm_mmu_post_write(vcpu, gpa, bytes);
 	return 1;
 }
 
diff --git a/drivers/kvm/mmu.c b/drivers/kvm/mmu.c
index 2277b7c..b3a83ef 100644
--- a/drivers/kvm/mmu.c
+++ b/drivers/kvm/mmu.c
@@ -1118,7 +1118,7 @@ out:
 	return r;
 }
 
-static void mmu_pre_write_zap_pte(struct kvm_vcpu *vcpu,
+static void mmu_pte_write_zap_pte(struct kvm_vcpu *vcpu,
 				  struct kvm_mmu_page *page,
 				  u64 *spte)
 {
@@ -1137,7 +1137,8 @@ static void mmu_pre_write_zap_pte(struct kvm_vcpu *vcpu,
 	*spte = 0;
 }
 
-void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
+void kvm_mmu_pte_write(struct kvm_vcpu *vcpu, gpa_t gpa,
+		       const u8 *old, const u8 *new, int bytes)
 {
 	gfn_t gfn = gpa >> PAGE_SHIFT;
 	struct kvm_mmu_page *page;
@@ -1206,16 +1207,12 @@ void kvm_mmu_pre_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
 		spte = __va(page->page_hpa);
 		spte += page_offset / sizeof(*spte);
 		while (npte--) {
-			mmu_pre_write_zap_pte(vcpu, page, spte);
+			mmu_pte_write_zap_pte(vcpu, page, spte);
 			++spte;
 		}
 	}
 }
 
-void kvm_mmu_post_write(struct kvm_vcpu *vcpu, gpa_t gpa, int bytes)
-{
-}
-
 int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 {
 	gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, gva);
-- 
1.5.0.6

