Return-Path: <linux-kernel-owner+w=401wt.eu-S1758132AbZEXP7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758132AbZEXP7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 11:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbZEXPyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 11:54:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41838 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350AbZEXPud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 11:50:33 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 27/45] KVM: take mmu_lock when updating a deleted slot
Date: Sun, 24 May 2009 18:50:12 +0300
Message-Id: <1243180230-2480-28-git-send-email-avi@redhat.com>
In-Reply-To: <1243180230-2480-1-git-send-email-avi@redhat.com>
References: <1243180230-2480-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <mtosatti@redhat.com>

kvm_handle_hva relies on mmu_lock protection to safely access
the memslot structures.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 virt/kvm/kvm_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4d00942..bebfe59 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1210,8 +1210,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 
 	kvm_free_physmem_slot(&old, npages ? &new : NULL);
 	/* Slot deletion case: we have to update the current slot */
+	spin_lock(&kvm->mmu_lock);
 	if (!npages)
 		*memslot = old;
+	spin_unlock(&kvm->mmu_lock);
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
 	r = kvm_iommu_map_pages(kvm, base_gfn, npages);
-- 
1.6.0.6

