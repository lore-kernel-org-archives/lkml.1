Return-Path: <linux-kernel-owner+w=401wt.eu-S1757237AbZJFQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237AbZJFQUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756644AbZJFQUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756441AbZJFQU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:20:29 -0400
Message-ID: <4ACB6E21.8010109@redhat.com>
Date: Tue, 06 Oct 2009 18:19:45 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com>
In-Reply-To: <4ACB46AD.8010405@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2009 03:31 PM, Gregory Haskins wrote:
>
>> slots would be one implementation, if you can think of others then you'd
>> add them.
>>      
> I'm more interested in *how* you'd add them more than "if" we would add
> them.  What I am getting at are the logistics of such a beast.
>    

Add alternative ioctls, or have one ioctl with a 'type' field.

> For instance, would I have /dev/slots-vas with ioctls for adding slots,
> and /dev/foo-vas for adding foos?  And each one would instantiate a
> different vas_struct object with its own vas_struct->ops?  Or were you
> thinking of something different.
>    

I think a single /dev/foo is sufficient, unless some of those address 
spaces are backed by real devices.

>> If you can't, I think it indicates that the whole thing isn't necessary
>> and we're better off with slots and virtual memory.
>>      
> I'm not sure if we are talking about the same thing yet, but if we are,
> there are uses of a generalized interface outside of slots/virtual
> memory (Ira's physical box being a good example).
>    

I'm not sure Ira's case is not best supported by virtual memory.

> In any case, I think the best approach is what I already proposed.
> KVM's arrangement of memory is going to tend to be KVM specific, and
> what better place to implement the interface than close to the kvm.ko core.
>
>    
>> The only thing missing is dma, which you don't deal with anyway.
>>
>>      
> Afaict I do support dma in the generalized vbus::memctx, though I do not
> use it on anything related to KVM or xinterface.  Can you elaborate on
> the problem here?  Does the SG interface in 4/4 help get us closer to
> what you envision?
>    

There's no dma method in there.  Mapping to physical addresses is 
equivalent to get_user_pages(), so it doesn't add anything over virtual 
memory slots.

>> You'd have to copy the entire range since you don't know what the guest
>> might put there.  I guess it's acceptable for small areas.
>>      
> ?  The vmap is presumably part of an ABI between guest and host, so the
> host should always know what structure is present within the region, and
> what is relevant from within that structure to migrate once that state
> is "frozen".
>    

I was thinking of the case where the page is shared with some other 
(guest-private) data.  But dirtying that data would be tracked by kvm, 
so it isn't a problem.

> These regions (for vbus, anyway) equate to things like virtqueue
> metadata, and presumably the same problem exists for virtio-net in
> userspace as it does here, since that is another form of a "vmap".  So
> whatever solution works for virtio-net migrating its virtqueues in
> userspace should be close to what will work here.  The primary
> difference is the location of the serializer.
>    

Actually, virtio doesn't serialize this data, instead it marks the page 
dirty and lets normal RAM migration move it.


>> rmb()s are only needed if an external agent can issue writes, otherwise
>> you'd need one after every statement.
>>      
> I was following lessons learned here:
>
> http://lkml.org/lkml/2009/7/7/175
>
> Perhaps mb() or barrier() are more appropriate than rmb()?  I'm CC'ing
> David Howells in case he has more insight.
>    

I'm not sure I understand the reference.  Callers and callees don't need 
memory barriers since they're guaranteed program order.  You only need 
memory barriers when you have an external agent (a device, or another 
cpu).  What external agent can touch things during ->release()?

>>>> A simple per-vcpu cache (in struct kvm_vcpu) is likely to give better
>>>> results.
>>>>
>>>>          
>>> per-vcpu will not work well here, unfortunately, since this is an
>>> external interface mechanism.  The callers will generally be from a
>>> kthread or some other non-vcpu related context.  Even if we could figure
>>> out a vcpu to use as a basis, we would require some kind of
>>> heavier-weight synchronization which would not be as desirable.
>>>
>>> Therefore, I opted to go per-cpu and use the presumably lighterweight
>>> get_cpu/put_cpu() instead.
>>>
>>>        
>> This just assumes a low context switch rate.
>>      
> It primarily assumes a low _migration_ rate, since you do not typically
> have two contexts on the same cpu pounding on the memslots.

Why not?  If you're overcommitted, you will, especially if you have 
multiple guests doing request/reply interaction (perhaps with each other).

> And even if
> you did, there's a good chance for locality between the threads, since
> the IO activity is likely related.  For the odd times where locality
> fails to yield a hit, the time-slice or migration rate should be
> sufficiently infrequent enough to still yield high 90s hit rates for
> when it matters.  For low-volume, the lookup is in the noise so I am not
> as concerned.
>
> IOW: Where the lookup hurts the most is trying to walk an SG list, since
> each pointer is usually within the same slot.  For this case, at least,
> this cache helps immensely, at least according to profiles.
>    

I'm wary of adding per-cpu data where it's easier to have a per-caller 
or per-vcpu cache.

>> How about a gfn_to_pfn_cached(..., struct gfn_to_pfn_cache *cache)?
>> Each user can place it in a natural place.
>>      
> Sounds good.  I will incorporate this into the split patch.
>    

Note that for slots, typically most accesses hit just one slot (the 
largest).  For guests below 4G, there's only one large slot, for guests 
above 4G there are two.

>>>>> +static unsigned long
>>>>> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
>>>>> +           const void *src, unsigned long n)
>>>>> +{
>>>>> +    struct _xinterface *_intf = to_intf(intf);
>>>>> +    unsigned long dst;
>>>>> +    bool kthread = !current->mm;
>>>>> +
>>>>> +    down_read(&_intf->kvm->slots_lock);
>>>>> +
>>>>> +    dst = gpa_to_hva(_intf, gpa);
>>>>> +    if (!dst)
>>>>> +        goto out;
>>>>> +
>>>>> +    if (kthread)
>>>>> +        use_mm(_intf->mm);
>>>>> +
>>>>> +    if (kthread || _intf->mm == current->mm)
>>>>> +        n = copy_to_user((void *)dst, src, n);
>>>>> +    else
>>>>> +        n = _slow_copy_to_user(_intf, dst, src, n);
>>>>>
>>>>>
>>>>>            
>>>> Can't you switch the mm temporarily instead of this?
>>>>
>>>>          
>>> Thats actually what I do for the fast-path (use_mm() does a switch_to()
>>> internally).
>>>
>>> The slow-path is only there for completeness for when switching is not
>>> possible (such as if called with an mm already active i.e.
>>> process-context).
>>>        
>> Still, why can't you switch temporarily?
>>      
> I am not an mm expert, but iiuc you cannot call switch_to() from
> anything other than kthread context.  Thats what the doc says, anyway.
>    

Can you provide a pointer?  I don't see why this limitation exists.

>>> In practice, however, this doesnt happen.  Virtually
>>> 100% of the calls in vbus hit the fast-path here, and I suspect most
>>> xinterface clients would find the same conditions as well.
>>>
>>>        
>> So you have 100% untested code here.
>>
>>      
> Actually, no.  Before Michael enlightened me recently regarding
> switch_to/use_mm, the '_slow_xx' functions were my _only_ path.  So they
> have indeed multiple months (and multiple GB) of testing, as it turns
> out.  I only recently optimized them away to "backup" duty.
>    

I meant, unexercised.  This will bitrot quickly.

-- 
error compiling committee.c: too many arguments to function

