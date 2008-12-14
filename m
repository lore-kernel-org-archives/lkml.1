Return-Path: <linux-kernel-owner+w=401wt.eu-S1756842AbYLNIPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842AbYLNIPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 03:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbYLNIHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 03:07:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:59926 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753760AbYLNIHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 03:07:16 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Glauber Costa <glommer@redhat.com>
Subject: [PATCH 25/36] KVM: Really remove a slot when a user ask us so
Date: Sun, 14 Dec 2008 10:06:58 +0200
Message-Id: <1229242029-13410-26-git-send-email-avi@redhat.com>
In-Reply-To: <1229242029-13410-1-git-send-email-avi@redhat.com>
References: <1229242029-13410-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Glauber Costa <glommer@redhat.com>

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
Signed-off-by: Avi Kivity <avi@redhat.com>
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
1.6.0.3

