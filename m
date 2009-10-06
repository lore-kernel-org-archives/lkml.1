Return-Path: <linux-kernel-owner+w=401wt.eu-S1756792AbZJFJfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792AbZJFJfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756742AbZJFJfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756689AbZJFJfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:35:44 -0400
Message-ID: <4ACB0F3C.1000705@redhat.com>
Date: Tue, 06 Oct 2009 11:34:52 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com>
In-Reply-To: <4ACA87D7.1080206@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 01:57 AM, Gregory Haskins wrote:
> Avi Kivity wrote:
>    
>> On 10/02/2009 10:19 PM, Gregory Haskins wrote:
>>      
>>> What: xinterface is a mechanism that allows kernel modules external to
>>> the kvm.ko proper to interface with a running guest.  It accomplishes
>>> this by creating an abstracted interface which does not expose any
>>> private details of the guest or its related KVM structures, and provides
>>> a mechanism to find and bind to this interface at run-time.
>>>
>>>        
>> If this is needed, it should be done as a virt_address_space to which
>> kvm and other modules bind, instead of as something that kvm exports and
>> other modules import.  The virt_address_space can be identified by an fd
>> and passed around to kvm and other modules.
>>      
> IIUC, what you are proposing is something similar to generalizing the
> vbus::memctx object.  I had considered doing something like that in the
> early design phase of vbus, but then decided it would be a hard-sell to
> the mm crowd, and difficult to generalize.
>
> What do you propose as the interface to program the object?
>    

Something like the current kvm interfaces, de-warted.  It will be a hard 
sell indeed, for good reasons.

>> So, under my suggestion above, you'd call
>> sys_create_virt_address_space(), populate it, and pass the result to kvm
>> and to foo.  This allows the use of virt_address_space without kvm and
>> doesn't require foo to interact with kvm.
>>      
> The problem I see here is that the only way I can think to implement
> this generally is something that looks very kvm-esque (slots-to-pages
> kind of translation).  Is there a way you can think of that does not
> involve a kvm.ko originated vtable that is also not kvm centric?
>    

slots would be one implementation, if you can think of others then you'd 
add them.

If you can't, I think it indicates that the whole thing isn't necessary 
and we're better off with slots and virtual memory.  The only thing 
missing is dma, which you don't deal with anyway.

>>> +struct kvm_xinterface_ops {
>>> +    unsigned long (*copy_to)(struct kvm_xinterface *intf,
>>> +                 unsigned long gpa, const void *src,
>>> +                 unsigned long len);
>>> +    unsigned long (*copy_from)(struct kvm_xinterface *intf, void *dst,
>>> +                   unsigned long gpa, unsigned long len);
>>> +    struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
>>> +                  unsigned long gpa,
>>> +                  unsigned long len);
>>>
>>>        
>> How would vmap() work with live migration?
>>      
> vmap represents shmem regions, and is a per-guest-instance resource.  So
> my plan there is that the new and old guest instance would each have the
> vmap region instated at the same GPA location (assumption: gpas are
> stable across migration), and any state relevant data local to the shmem
> (like ring head/tail position) is conveyed in the serialized stream for
> the device model.
>    

You'd have to copy the entire range since you don't know what the guest 
might put there.  I guess it's acceptable for small areas.

>>> +
>>> +static inline void
>>> +_kvm_xinterface_release(struct kref *kref)
>>> +{
>>> +    struct kvm_xinterface *intf;
>>> +    struct module *owner;
>>> +
>>> +    intf = container_of(kref, struct kvm_xinterface, kref);
>>> +
>>> +    owner = intf->owner;
>>> +    rmb();
>>>
>>>        
>> Why rmb?
>>      
> the intf->ops->release() line may invalidate the intf pointer, so we
> want to ensure that the read completes before the release() is called.
>
> TBH: I'm not 100% its needed, but I was being conservative.
>    

rmb()s are only needed if an external agent can issue writes, otherwise 
you'd need one after every statement.




>>
>> A simple per-vcpu cache (in struct kvm_vcpu) is likely to give better
>> results.
>>      
> per-vcpu will not work well here, unfortunately, since this is an
> external interface mechanism.  The callers will generally be from a
> kthread or some other non-vcpu related context.  Even if we could figure
> out a vcpu to use as a basis, we would require some kind of
> heavier-weight synchronization which would not be as desirable.
>
> Therefore, I opted to go per-cpu and use the presumably lighterweight
> get_cpu/put_cpu() instead.
>    

This just assumes a low context switch rate.

How about a gfn_to_pfn_cached(..., struct gfn_to_pfn_cache *cache)?  
Each user can place it in a natural place.

>>> +static unsigned long
>>> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
>>> +           const void *src, unsigned long n)
>>> +{
>>> +    struct _xinterface *_intf = to_intf(intf);
>>> +    unsigned long dst;
>>> +    bool kthread = !current->mm;
>>> +
>>> +    down_read(&_intf->kvm->slots_lock);
>>> +
>>> +    dst = gpa_to_hva(_intf, gpa);
>>> +    if (!dst)
>>> +        goto out;
>>> +
>>> +    if (kthread)
>>> +        use_mm(_intf->mm);
>>> +
>>> +    if (kthread || _intf->mm == current->mm)
>>> +        n = copy_to_user((void *)dst, src, n);
>>> +    else
>>> +        n = _slow_copy_to_user(_intf, dst, src, n);
>>>
>>>        
>> Can't you switch the mm temporarily instead of this?
>>      
> Thats actually what I do for the fast-path (use_mm() does a switch_to()
> internally).
>
> The slow-path is only there for completeness for when switching is not
> possible (such as if called with an mm already active i.e.
> process-context).

Still, why can't you switch temporarily?

> In practice, however, this doesnt happen.  Virtually
> 100% of the calls in vbus hit the fast-path here, and I suspect most
> xinterface clients would find the same conditions as well.
>    

So you have 100% untested code here.

-- 
error compiling committee.c: too many arguments to function

