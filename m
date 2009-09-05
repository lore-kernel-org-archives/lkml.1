Return-Path: <linux-kernel-owner+w=401wt.eu-S964998AbZIEAbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998AbZIEAbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 20:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934620AbZIEAU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 20:20:59 -0400
Received: from kroah.org ([198.145.64.141]:42116 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934526AbZIEAUp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 20:20:45 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Sep  4 17:14:50 2009
Message-Id: <20090905001450.371736811@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 04 Sep 2009 17:13:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Marcelo Tosatti <mtosatti@redhat.com>, avi@redhat.com
Subject: [patch 19/71] KVM: take mmu_lock when updating a deleted slot
References: <20090905001335.106974681@mini.kroah.org>
Content-Disposition: inline; filename=kvm-take-mmu_lock-when-updating-a-deleted-slot.patch
In-Reply-To: <20090905001824.GA18171@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Marcelo Tosatti <mtosatti@redhat.com>

(cherry picked from commit b43b1901ad282aeb74161837fb403927102687a1)

kvm_handle_hva relies on mmu_lock protection to safely access
the memslot structures.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/kvm_main.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1055,8 +1055,10 @@ int __kvm_set_memory_region(struct kvm *
 
 	kvm_free_physmem_slot(&old, npages ? &new : NULL);
 	/* Slot deletion case: we have to update the current slot */
+	spin_lock(&kvm->mmu_lock);
 	if (!npages)
 		*memslot = old;
+	spin_unlock(&kvm->mmu_lock);
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
 	r = kvm_iommu_map_pages(kvm, base_gfn, npages);


