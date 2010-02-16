Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932997Ab0BPKol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:44:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932782Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/38] KVM: Fix kvm_coalesced_mmio_ring duplicate allocation
Date: Tue, 16 Feb 2010 12:35:09 +0200
Message-Id: <1266316536-28936-12-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

The commit 0953ca73 "KVM: Simplify coalesced mmio initialization"
allocate kvm_coalesced_mmio_ring in the kvm_coalesced_mmio_init(), but
didn't discard the original allocation...

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 virt/kvm/kvm_main.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 7c5c873..2b0974a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -371,9 +371,6 @@ static struct kvm *kvm_create_vm(void)
 {
 	int r = 0, i;
 	struct kvm *kvm = kvm_arch_create_vm();
-#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-	struct page *page;
-#endif
 
 	if (IS_ERR(kvm))
 		goto out;
@@ -402,23 +399,9 @@ static struct kvm *kvm_create_vm(void)
 		}
 	}
 
-#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
-	if (!page) {
-		cleanup_srcu_struct(&kvm->srcu);
-		goto out_err;
-	}
-
-	kvm->coalesced_mmio_ring =
-			(struct kvm_coalesced_mmio_ring *)page_address(page);
-#endif
-
 	r = kvm_init_mmu_notifier(kvm);
 	if (r) {
 		cleanup_srcu_struct(&kvm->srcu);
-#ifdef KVM_COALESCED_MMIO_PAGE_OFFSET
-		put_page(page);
-#endif
 		goto out_err;
 	}
 
-- 
1.6.5.3

