Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYKSSmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYKSSmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:42:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYKSSl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:41:56 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58488 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbYKSSly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:41:54 -0500
Date: Wed, 19 Nov 2008 16:43:57 -0200
From: Glauber Costa <glommer@redhat.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] always assign userspace_addr
Message-ID: <20081119184357.GB25917@poweredge.glommer>
References: <1226977462-8086-1-git-send-email-glommer@redhat.com> <492436DE.2080906@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492436DE.2080906@codemonkey.ws>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 09:55:10AM -0600, Anthony Liguori wrote:
> Glauber Costa wrote:
>> Currently, kvm only sets new.userspace_addr in slots
>> that were just allocated. This is not the intended behaviour,
>> and actually breaks when we try to use the slots to implement
>> aliases, for example.
>>
>> Cirrus VGA aliases maps and address to a userspace address, and
>> then keep mapping this same address to different locations
>> until the whole screen is filled.
>>
>> The solution is to assign new.userspace_addr no matter what,
>> so we can be sure that whenever the guest changes this field,
>> it sees the change being reflected in the code.
>>
>> Signed-off-by: Glauber Costa <glommer@redhat.com>
>>   
>
> I think this is masking a much bigger problem.
>
>
>> ---
>>  virt/kvm/kvm_main.c |   18 +++++++++---------
>>  1 files changed, 9 insertions(+), 9 deletions(-)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index a87f45e..fc3abf0 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -762,15 +762,6 @@ int __kvm_set_memory_region(struct kvm *kvm,
>>  		memset(new.rmap, 0, npages * sizeof(*new.rmap));
>>   		new.user_alloc = user_alloc;
>> -		/*
>> -		 * hva_to_rmmap() serialzies with the mmu_lock and to be
>> -		 * safe it has to ignore memslots with !user_alloc &&
>> -		 * !userspace_addr.
>> -		 */
>> -		if (user_alloc)
>> -			new.userspace_addr = mem->userspace_addr;
>> -		else
>> -			new.userspace_addr = 0;
>>   
>
> This is guarded in:
>
>>     if (npages && !new.rmap) {
>
> In this case, npages > 0 but !new.rmap is already allocated.  But this  
> is a new slot?  The problem is that when we delete the slot, the rmap  
> never gets freed.  This means that if we delete a slot, then create a  
> new slot which happens to be a different size, we use the old rmap and  
> potentially overrun that buffer.

Oh yeah, it does get freed.

The delete path ends up in a kvm_free_physmem_slot, which will effectively
vfree() the rmap structure. In fact, my userspace use case worked totally
properly when I deleted the slot prior to re-registering it.

The problem here is when there is an already existant slot, and we are
trying to change some information about it. The problem you are concerned
basically does not exist, because it would raise only if we are changing
the slot size. The code says:

        /* Disallow changing a memory slot's size. */
        r = -EINVAL;
        if (npages && old.npages && npages != old.npages)
                goto out_free;

And this seem pretty much as the expected behaviour to me. (At least, it 
is a reasonable behaviour, although one could argue that it could easily
be different)

