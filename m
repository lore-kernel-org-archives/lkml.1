Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0BJR0y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:26:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 29/40] KVM: introduce gfn_to_pfn_memslot
Date: Wed, 10 Feb 2010 19:22:58 +0200
Message-Id: <1265822589-11155-30-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

Which takes a memslot pointer instead of using kvm->memslots.

To be used by SRCU convertion later.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 include/linux/kvm_host.h |    2 ++
 virt/kvm/kvm_main.c      |   33 +++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3c44687..f1f78de 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,6 +273,8 @@ void kvm_set_page_dirty(struct page *page);
 void kvm_set_page_accessed(struct page *page);
 
 pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn);
+pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
+			 struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_release_pfn_dirty(pfn_t);
 void kvm_release_pfn_clean(pfn_t pfn);
 void kvm_set_pfn_dirty(pfn_t pfn);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c9f6cfe..4e2321c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -835,21 +835,14 @@ unsigned long gfn_to_hva(struct kvm *kvm, gfn_t gfn)
 }
 EXPORT_SYMBOL_GPL(gfn_to_hva);
 
-pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+static pfn_t hva_to_pfn(struct kvm *kvm, unsigned long addr)
 {
 	struct page *page[1];
-	unsigned long addr;
 	int npages;
 	pfn_t pfn;
 
 	might_sleep();
 
-	addr = gfn_to_hva(kvm, gfn);
-	if (kvm_is_error_hva(addr)) {
-		get_page(bad_page);
-		return page_to_pfn(bad_page);
-	}
-
 	npages = get_user_pages_fast(addr, 1, 1, page);
 
 	if (unlikely(npages != 1)) {
@@ -874,8 +867,32 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 	return pfn;
 }
 
+pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
+{
+	unsigned long addr;
+
+	addr = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(addr)) {
+		get_page(bad_page);
+		return page_to_pfn(bad_page);
+	}
+
+	return hva_to_pfn(kvm, addr);
+}
 EXPORT_SYMBOL_GPL(gfn_to_pfn);
 
+static unsigned long gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	return (slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE);
+}
+
+pfn_t gfn_to_pfn_memslot(struct kvm *kvm,
+			 struct kvm_memory_slot *slot, gfn_t gfn)
+{
+	unsigned long addr = gfn_to_hva_memslot(slot, gfn);
+	return hva_to_pfn(kvm, addr);
+}
+
 struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 {
 	pfn_t pfn;
-- 
1.6.5.3

