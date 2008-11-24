Return-Path: <linux-kernel-owner+w=401wt.eu-S1753771AbYKXPs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbYKXPs1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:48:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYKXPsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:48:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54520 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbYKXPsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:48:18 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com
Subject: [PATCH] really remove a slow when a user ask us so
Date: Mon, 24 Nov 2008 15:44:24 -0200
Message-Id: <1227548664-18047-1-git-send-email-glommer@redhat.com>
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

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 virt/kvm/kvm_main.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b1953ee..f605bba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -735,11 +735,17 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
-	if (!npages)
-		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
-
 	new = old = *memslot;
 
+        if (!npages) {
+                mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+                kvm_arch_flush_shadow(kvm);
+                kvm_free_physmem_slot(memslot, NULL);
+                kvm_arch_set_memory_region(kvm, mem, old, user_alloc);
+                goto out;
+        }
+
+
 	new.base_gfn = base_gfn;
 	new.npages = npages;
 	new.flags = mem->flags;
@@ -812,9 +818,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	}
 #endif /* not defined CONFIG_S390 */
 
-	if (!npages)
-		kvm_arch_flush_shadow(kvm);
-
 	spin_lock(&kvm->mmu_lock);
 	if (mem->slot >= kvm->nmemslots)
 		kvm->nmemslots = mem->slot + 1;
-- 
1.5.6.5

