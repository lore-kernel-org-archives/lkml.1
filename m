Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbYIWN7b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbYIWN7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 09:59:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYIWNs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 09:48:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492AbYIWNs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 09:48:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Ben-Ami Yassour <benami@il.ibm.com>
Subject: [PATCH 35/40] KVM: direct mmio pfn check
Date: Tue, 23 Sep 2008 16:46:49 +0300
Message-Id: <1222177614-26669-36-git-send-email-avi@redhat.com>
In-Reply-To: <1222177614-26669-1-git-send-email-avi@redhat.com>
References: <1222177614-26669-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben-Ami Yassour <benami@il.ibm.com>

Userspace may specify memory slots that are backed by mmio pages rather than
normal RAM.  In some cases it is not enough to identify these mmio pages
by pfn_valid().  This patch adds checking the PageReserved as well.

Signed-off-by: Ben-Ami Yassour <benami@il.ibm.com>
Signed-off-by: Muli Ben-Yehuda <muli@il.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 virt/kvm/kvm_main.c |   22 +++++++++++++++-------
 1 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7dd9b0b..5eb96c7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -76,6 +76,14 @@ static inline int valid_vcpu(int n)
 	return likely(n >= 0 && n < KVM_MAX_VCPUS);
 }
 
+static inline int is_mmio_pfn(pfn_t pfn)
+{
+	if (pfn_valid(pfn))
+		return PageReserved(pfn_to_page(pfn));
+
+	return true;
+}
+
 /*
  * Switches to specified vcpu, until a matching vcpu_put()
  */
@@ -740,7 +748,7 @@ pfn_t gfn_to_pfn(struct kvm *kvm, gfn_t gfn)
 		}
 
 		pfn = ((addr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
-		BUG_ON(pfn_valid(pfn));
+		BUG_ON(!is_mmio_pfn(pfn));
 	} else
 		pfn = page_to_pfn(page[0]);
 
@@ -754,10 +762,10 @@ struct page *gfn_to_page(struct kvm *kvm, gfn_t gfn)
 	pfn_t pfn;
 
 	pfn = gfn_to_pfn(kvm, gfn);
-	if (pfn_valid(pfn))
+	if (!is_mmio_pfn(pfn))
 		return pfn_to_page(pfn);
 
-	WARN_ON(!pfn_valid(pfn));
+	WARN_ON(is_mmio_pfn(pfn));
 
 	get_page(bad_page);
 	return bad_page;
@@ -773,7 +781,7 @@ EXPORT_SYMBOL_GPL(kvm_release_page_clean);
 
 void kvm_release_pfn_clean(pfn_t pfn)
 {
-	if (pfn_valid(pfn))
+	if (!is_mmio_pfn(pfn))
 		put_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_release_pfn_clean);
@@ -799,7 +807,7 @@ EXPORT_SYMBOL_GPL(kvm_set_page_dirty);
 
 void kvm_set_pfn_dirty(pfn_t pfn)
 {
-	if (pfn_valid(pfn)) {
+	if (!is_mmio_pfn(pfn)) {
 		struct page *page = pfn_to_page(pfn);
 		if (!PageReserved(page))
 			SetPageDirty(page);
@@ -809,14 +817,14 @@ EXPORT_SYMBOL_GPL(kvm_set_pfn_dirty);
 
 void kvm_set_pfn_accessed(pfn_t pfn)
 {
-	if (pfn_valid(pfn))
+	if (!is_mmio_pfn(pfn))
 		mark_page_accessed(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_set_pfn_accessed);
 
 void kvm_get_pfn(pfn_t pfn)
 {
-	if (pfn_valid(pfn))
+	if (!is_mmio_pfn(pfn))
 		get_page(pfn_to_page(pfn));
 }
 EXPORT_SYMBOL_GPL(kvm_get_pfn);
-- 
1.6.0.1

