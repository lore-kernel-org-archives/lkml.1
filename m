Return-Path: <linux-kernel-owner+w=401wt.eu-S1752811AbYKRBIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbYKRBIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 20:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbYKRBIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 20:08:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58187 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbYKRBIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 20:08:13 -0500
From: Glauber Costa <glommer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, avi@redhat.com
Subject: [PATCH] always assign userspace_addr
Date: Tue, 18 Nov 2008 01:04:22 -0200
Message-Id: <1226977462-8086-1-git-send-email-glommer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kvm only sets new.userspace_addr in slots
that were just allocated. This is not the intended behaviour,
and actually breaks when we try to use the slots to implement
aliases, for example.

Cirrus VGA aliases maps and address to a userspace address, and
then keep mapping this same address to different locations
until the whole screen is filled.

The solution is to assign new.userspace_addr no matter what,
so we can be sure that whenever the guest changes this field,
it sees the change being reflected in the code.

Signed-off-by: Glauber Costa <glommer@redhat.com>
---
 virt/kvm/kvm_main.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a87f45e..fc3abf0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -762,15 +762,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 
 		new.user_alloc = user_alloc;
-		/*
-		 * hva_to_rmmap() serialzies with the mmu_lock and to be
-		 * safe it has to ignore memslots with !user_alloc &&
-		 * !userspace_addr.
-		 */
-		if (user_alloc)
-			new.userspace_addr = mem->userspace_addr;
-		else
-			new.userspace_addr = 0;
 	}
 	if (npages && !new.lpage_info) {
 		int largepages = npages / KVM_PAGES_PER_HPAGE;
@@ -791,6 +782,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE)
 			new.lpage_info[largepages-1].write_count = 1;
 	}
+	/*
+	 * hva_to_rmmap() serialzies with the mmu_lock and to be
+	 * safe it has to ignore memslots with !user_alloc &&
+	 * !userspace_addr.
+	 */
+	if (npages && user_alloc)
+		new.userspace_addr = mem->userspace_addr;
+	else
+		new.userspace_addr = 0;
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
-- 
1.5.6.5

