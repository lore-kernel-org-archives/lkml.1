Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYLCNo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYLCNo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbYLCNor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:44:47 -0500
Received: from mx2.redhat.com ([66.187.237.31]:41071 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbYLCNoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:44:46 -0500
From: Glauber Costa <glommer@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com
Subject: [PATCH] really remove a slow when a user ask us so
Date: Wed,  3 Dec 2008 13:40:51 -0200
Message-Id: <1228318851-16344-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Right now, KVM does not remove a slot when we do a
register ioctl for size 0 (would be the expected behaviour).

Instead, we only mark it as empty, but keep all bitmaps
and allocated data structures present. It completely
nullifies our chances of reusing that same slot again
for mapping a different piece of memory.

In this patch, we destroy rmaps, and vfree() the
pointers that used to hold the dirty bitmap, rmap
and lpage_info structures.

qemu's VGA optimization won't work without this patch

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 virt/kvm/kvm_main.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e41d39d..fd9cc79 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1020,7 +1020,10 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out_free;
 	}
 
-	kvm_free_physmem_slot(&old, &new);
+	kvm_free_physmem_slot(&old, npages ? &new : NULL);
+	/* Slot deletion case: we have to update the current slot */
+	if (!npages)
+		*memslot = old;
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
 	r = kvm_iommu_map_pages(kvm, base_gfn, npages);
-- 
1.5.6.5

