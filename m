Return-Path: <linux-kernel-owner+w=401wt.eu-S1757402AbYKUSJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402AbYKUSJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbYKUSJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:09:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46389 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbYKUSJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:09:13 -0500
Date: Fri, 21 Nov 2008 16:11:11 -0200
From: Glauber Costa <glommer@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [PATCH] always assign userspace_addr
Message-ID: <20081121181111.GA3545@poweredge.glommer>
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer> <49246014.5000001@codemonkey.ws> <492543CF.6040507@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
In-Reply-To: <492543CF.6040507@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 20, 2008 at 01:02:39PM +0200, Avi Kivity wrote:
> Anthony Liguori wrote:
>>
>> That's not how I read the code.  I see:
>>
>>>
>>> static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
>>>                   struct kvm_memory_slot *dont)
>>> {
>>>     if (!dont || free->rmap != dont->rmap)
>>>         vfree(free->rmap);
>>
>> And it's called as kvm_free_physmem_slot(&old, &new);
>>
>> new is assigned to old to start out with so old.rmap will equal new.rmap.
>>
>
> Hm, if !npages we should just kvm_free_physmem_slot(&old, NULL).
Actually, I believe we need a little bit more than that, because we can
have valid rmaps in flight.

Tell me what you think about this.



--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="npages.patch"

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

--qDbXVdCdHGoSgWSk--
