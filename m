Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKSSvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKSSvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753080AbYKSSvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:51:12 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:12140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYKSSvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:51:11 -0500
Message-ID: <49246014.5000001@codemonkey.ws>
Date: Wed, 19 Nov 2008 12:51:00 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Glauber Costa <glommer@redhat.com>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] always assign userspace_addr
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws> <20081119184357.GB25917@poweredge.glommer>
In-Reply-To: <20081119184357.GB25917@poweredge.glommer>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa wrote:
> On Wed, Nov 19, 2008 at 09:55:10AM -0600, Anthony Liguori wrote:
>   
>> Glauber Costa wrote:
>>     
>>> Currently, kvm only sets new.userspace_addr in slots
>>> that were just allocated. This is not the intended behaviour,
>>> and actually breaks when we try to use the slots to implement
>>> aliases, for example.
>>>
>>> Cirrus VGA aliases maps and address to a userspace address, and
>>> then keep mapping this same address to different locations
>>> until the whole screen is filled.
>>>
>>> The solution is to assign new.userspace_addr no matter what,
>>> so we can be sure that whenever the guest changes this field,
>>> it sees the change being reflected in the code.
>>>
>>> Signed-off-by: Glauber Costa <glommer@redhat.com>
>>>   
>>>       
>> I think this is masking a much bigger problem.
>>
>>
>>     
>>> ---
>>>  virt/kvm/kvm_main.c |   18 +++++++++---------
>>>  1 files changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>> index a87f45e..fc3abf0 100644
>>> --- a/virt/kvm/kvm_main.c
>>> +++ b/virt/kvm/kvm_main.c
>>> @@ -762,15 +762,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>>>  		memset(new.rmap, 0, npages * sizeof(*new.rmap));
>>>   		new.user_alloc = user_alloc;
>>> -		/*
>>> -		 * hva_to_rmmap() serialzies with the mmu_lock and to be
>>> -		 * safe it has to ignore memslots with !user_alloc &&
>>> -		 * !userspace_addr.
>>> -		 */
>>> -		if (user_alloc)
>>> -			new.userspace_addr = mem->userspace_addr;
>>> -		else
>>> -			new.userspace_addr = 0;
>>>   
>>>       
>> This is guarded in:
>>
>>     
>>>     if (npages && !new.rmap) {
>>>       
>> In this case, npages > 0 but !new.rmap is already allocated.  But this  
>> is a new slot?  The problem is that when we delete the slot, the rmap  
>> never gets freed.  This means that if we delete a slot, then create a  
>> new slot which happens to be a different size, we use the old rmap and  
>> potentially overrun that buffer.
>>     
>
> Oh yeah, it does get freed.
>
> The delete path ends up in a kvm_free_physmem_slot, which will effectively
> vfree() the rmap structure. In fact, my userspace use case worked totally
> properly when I deleted the slot prior to re-registering it.
>   

That's not how I read the code.  I see:

>
> static void kvm_free_physmem_slot(struct kvm_memory_slot *free,
>                   struct kvm_memory_slot *dont)
> {
>     if (!dont || free->rmap != dont->rmap)
>         vfree(free->rmap);

And it's called as kvm_free_physmem_slot(&old, &new);

new is assigned to old to start out with so old.rmap will equal new.rmap.

> The problem here is when there is an already existant slot, and we are
> trying to change some information about it. The problem you are concerned
> basically does not exist, because it would raise only if we are changing
> the slot size. The code says:
>   

If a memory slot exists, the current code always deletes it and creates 
a new one so this problem shouldn't exist.  See

>
>             /* unregister whole slot */
>             memcpy(&slot, mem, sizeof(slot));
>             mem->memory_size = 0;
>             kvm_vm_ioctl(s, KVM_SET_USER_MEMORY_REGION, mem);

But the problem still exists even with this code.  I checked.

So if you have something working without modifying the kernel, can you 
post it?

Regards,

Anthony Liguori
