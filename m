Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYKSUvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYKSUvt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754101AbYKSUvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:51:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47698 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542AbYKSUv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:51:29 -0500
Date: Wed, 19 Nov 2008 18:53:32 -0200
From: Glauber Costa <glommer@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] always assign userspace_addr
Message-ID: <20081119205332.GA27378@poweredge.glommer>
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer> <49246014.5000001@codemonkey.ws>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <49246014.5000001@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 19, 2008 at 12:51:00PM -0600, Anthony Liguori wrote:
>
> But the problem still exists even with this code.  I checked.
>
> So if you have something working without modifying the kernel, can you  
> post it?
>
> Regards,
>
> Anthony Liguori

Ok, how do you feel about this one?

My proposal is to always delete a memslot before reusing the space,
but controlling this behaviour by a flag, so we can maintain backwards
compatibility with people using older versions of the interface.



--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="interface.patch"

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index f18b86f..66ee286 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -39,6 +39,7 @@ struct kvm_userspace_memory_region {
 
 /* for kvm_memory_region::flags */
 #define KVM_MEM_LOG_DIRTY_PAGES  1UL
+#define KVM_MEM_FREE_BEFORE_ALLOC 2UL
 
 
 /* for KVM_IRQ_LINE */
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c39d4f..41f5666 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -735,24 +735,31 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	base_gfn = mem->guest_phys_addr >> PAGE_SHIFT;
 	npages = mem->memory_size >> PAGE_SHIFT;
 
-	if (!npages)
-		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
+
+	r = kvm_check_overlap(kvm, base_gfn, npages, memslot);
+	if (r)
+		goto out_free;
+
 
 	new = old = *memslot;
 
-	new.base_gfn = base_gfn;
-	new.npages = npages;
-	new.flags = mem->flags;
+	if (!npages)
+		mem->flags &= ~KVM_MEM_LOG_DIRTY_PAGES;
 
-	/* Disallow changing a memory slot's size. */
-	r = -EINVAL;
-	if (npages && old.npages && npages != old.npages)
-		goto out_free;
 
-	r = kvm_check_overlap(kvm, base_gfn, npages, memslot);
-	if (r)
+	if (mem->flags & KVM_MEM_FREE_BEFORE_ALLOC)
+		kvm_free_physmem_slot(&new, NULL);
+
+	else {
+		/* Disallow changing a memory slot's size. */
+		r = -EINVAL;
+		if (npages && old.npages && npages != old.npages)
 		goto out_free;
+	}
 
+	new.base_gfn = base_gfn;
+	new.flags = mem->flags;
+	new.npages = npages;
 
 	/* Free page dirty bitmap if unneeded */
 	if (!(new.flags & KVM_MEM_LOG_DIRTY_PAGES))
@@ -771,6 +778,15 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		memset(new.rmap, 0, npages * sizeof(*new.rmap));
 
 		new.user_alloc = user_alloc;
+		/*
+		 * hva_to_rmmap() serialzies with the mmu_lock and to be
+		 * safe it has to ignore memslots with !user_alloc &&
+		 * !userspace_addr.
+		 */
+		if (user_alloc)
+			new.userspace_addr = mem->userspace_addr;
+		else
+			new.userspace_addr = 0;
 	}
 	if (npages && !new.lpage_info) {
 		int largepages = npages / KVM_PAGES_PER_HPAGE;
@@ -791,15 +807,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		if ((base_gfn+npages) % KVM_PAGES_PER_HPAGE)
 			new.lpage_info[largepages-1].write_count = 1;
 	}
-	/*
-	 * hva_to_rmmap() serialzies with the mmu_lock and to be
-	 * safe it has to ignore memslots with !user_alloc &&
-	 * !userspace_addr.
-	 */
-	if (npages && user_alloc)
-		new.userspace_addr = mem->userspace_addr;
-	else
-		new.userspace_addr = 0;
 
 	/* Allocate page dirty bitmap if needed */
 	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
@@ -830,7 +837,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 		goto out_free;
 	}
 
-	kvm_free_physmem_slot(&old, &new);
+	
+	if (!(mem->flags & KVM_MEM_FREE_BEFORE_ALLOC)) 
+		kvm_free_physmem_slot(&old, &new);
 #ifdef CONFIG_DMAR
 	/* map the pages in iommu page table */
 	r = kvm_iommu_map_pages(kvm, base_gfn, npages);
@@ -840,7 +849,9 @@ int __kvm_set_memory_region(struct kvm *kvm,
 	return 0;
 
 out_free:
-	kvm_free_physmem_slot(&new, &old);
+
+	if (!(mem->flags & KVM_MEM_FREE_BEFORE_ALLOC)) 
+		kvm_free_physmem_slot(&new, &old);
 out:
 	return r;
 

--7AUc2qLy4jB3hD7Z--
