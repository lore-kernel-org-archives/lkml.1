Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbZJFQ6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbZJFQ6u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755400AbZJFQ6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:58:50 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:44331 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbZJFQ6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:58:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=iLX0mVGqUE52zw2rbQZjHVSgwII8qd3XPmQntONDo/TBDXvwBMJrcZwkaUDOQivVxO
         feyh3vfR1OaGA0SNrXNwbLy3v8+u/Y7Foiw1SWdJFwoi4RV2sYyUzEqW2YaTpGYTyPHy
         /ddRLNXhb519Ezx0nXwketF1Sv5GPlGu5PkHM=
Message-ID: <4ACB771E.8050404@gmail.com>
Date: Tue, 06 Oct 2009 12:58:06 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com> <4ACB46AD.8010405@gmail.com> <4ACB6E21.8010109@redhat.com>
In-Reply-To: <4ACB6E21.8010109@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2C22DE1F3DD63183201231A4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C22DE1F3DD63183201231A4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/06/2009 03:31 PM, Gregory Haskins wrote:
>>
>>> slots would be one implementation, if you can think of others then yo=
u'd
>>> add them.
>>>     =20
>> I'm more interested in *how* you'd add them more than "if" we would ad=
d
>> them.  What I am getting at are the logistics of such a beast.
>>   =20
>=20
> Add alternative ioctls, or have one ioctl with a 'type' field.
>=20
>> For instance, would I have /dev/slots-vas with ioctls for adding slots=
,
>> and /dev/foo-vas for adding foos?  And each one would instantiate a
>> different vas_struct object with its own vas_struct->ops?  Or were you=

>> thinking of something different.
>>   =20
>=20
> I think a single /dev/foo is sufficient, unless some of those address
> spaces are backed by real devices.
>=20
>>> If you can't, I think it indicates that the whole thing isn't necessa=
ry
>>> and we're better off with slots and virtual memory.
>>>     =20
>> I'm not sure if we are talking about the same thing yet, but if we are=
,
>> there are uses of a generalized interface outside of slots/virtual
>> memory (Ira's physical box being a good example).
>>   =20
>=20
> I'm not sure Ira's case is not best supported by virtual memory.

Perhaps, but there are surely some cases where the memory is not
pageable, but is accessible indirectly through some DMA controller.  So
if we require it to be pagable we will limit the utility of the
interface, though admittedly it will probably cover most cases.

>=20
>> In any case, I think the best approach is what I already proposed.
>> KVM's arrangement of memory is going to tend to be KVM specific, and
>> what better place to implement the interface than close to the kvm.ko
>> core.
>>
>>  =20
>>> The only thing missing is dma, which you don't deal with anyway.
>>>
>>>     =20
>> Afaict I do support dma in the generalized vbus::memctx, though I do n=
ot
>> use it on anything related to KVM or xinterface.  Can you elaborate on=

>> the problem here?  Does the SG interface in 4/4 help get us closer to
>> what you envision?
>>   =20
>=20
> There's no dma method in there.  Mapping to physical addresses is
> equivalent to get_user_pages(), so it doesn't add anything over virtual=

> memory slots.

I am not following you at all.  What kind of interface do we need for
DMA?  Since the KVM guest is pagable, the support for DMA would come
from building a scatterlist (patch 4/4) and passing the resulting pages
out using standard sg mechanisms, like sg_dma_address().  This is what I
do today to support zero-copy in AlacrityVM.

What more do we need?

>=20
>>> You'd have to copy the entire range since you don't know what the gue=
st
>>> might put there.  I guess it's acceptable for small areas.
>>>     =20
>> ?  The vmap is presumably part of an ABI between guest and host, so th=
e
>> host should always know what structure is present within the region, a=
nd
>> what is relevant from within that structure to migrate once that state=

>> is "frozen".
>>   =20
>=20
> I was thinking of the case where the page is shared with some other
> (guest-private) data.  But dirtying that data would be tracked by kvm,
> so it isn't a problem.

Ok.

>=20
>> These regions (for vbus, anyway) equate to things like virtqueue
>> metadata, and presumably the same problem exists for virtio-net in
>> userspace as it does here, since that is another form of a "vmap".  So=

>> whatever solution works for virtio-net migrating its virtqueues in
>> userspace should be close to what will work here.  The primary
>> difference is the location of the serializer.
>>   =20
>=20
> Actually, virtio doesn't serialize this data, instead it marks the page=

> dirty and lets normal RAM migration move it.

Ok, so its effectively serializing the entire region indirectly.  That
works too.

>=20
>=20
>>> rmb()s are only needed if an external agent can issue writes, otherwi=
se
>>> you'd need one after every statement.
>>>     =20
>> I was following lessons learned here:
>>
>> http://lkml.org/lkml/2009/7/7/175
>>
>> Perhaps mb() or barrier() are more appropriate than rmb()?  I'm CC'ing=

>> David Howells in case he has more insight.
>>   =20
>=20
> I'm not sure I understand the reference.  Callers and callees don't nee=
d
> memory barriers since they're guaranteed program order.  You only need
> memory barriers when you have an external agent (a device, or another
> cpu).  What external agent can touch things during ->release()?

We already have a different subthread started on this, so I'll pick this
up there.

>=20
>>>>> A simple per-vcpu cache (in struct kvm_vcpu) is likely to give bett=
er
>>>>> results.
>>>>>
>>>>>         =20
>>>> per-vcpu will not work well here, unfortunately, since this is an
>>>> external interface mechanism.  The callers will generally be from a
>>>> kthread or some other non-vcpu related context.  Even if we could
>>>> figure
>>>> out a vcpu to use as a basis, we would require some kind of
>>>> heavier-weight synchronization which would not be as desirable.
>>>>
>>>> Therefore, I opted to go per-cpu and use the presumably lighterweigh=
t
>>>> get_cpu/put_cpu() instead.
>>>>
>>>>       =20
>>> This just assumes a low context switch rate.
>>>     =20
>> It primarily assumes a low _migration_ rate, since you do not typicall=
y
>> have two contexts on the same cpu pounding on the memslots.
>=20
> Why not?  If you're overcommitted, you will, especially if you have
> multiple guests doing request/reply interaction (perhaps with each othe=
r).

Right, but you can probably do a *lot* of gfn_to_memslot() calls within
your timeslice to still make it highly worthwhile.  We are talking
microseconds per lookup vs milliseconds per context switch.

>=20
>> And even if
>> you did, there's a good chance for locality between the threads, since=

>> the IO activity is likely related.  For the odd times where locality
>> fails to yield a hit, the time-slice or migration rate should be
>> sufficiently infrequent enough to still yield high 90s hit rates for
>> when it matters.  For low-volume, the lookup is in the noise so I am n=
ot
>> as concerned.
>>
>> IOW: Where the lookup hurts the most is trying to walk an SG list, sin=
ce
>> each pointer is usually within the same slot.  For this case, at least=
,
>> this cache helps immensely, at least according to profiles.
>>   =20
>=20
> I'm wary of adding per-cpu data where it's easier to have a per-caller
> or per-vcpu cache.

I like your per-caller suggestion.  That makes the most sense to me.

>=20
>>> How about a gfn_to_pfn_cached(..., struct gfn_to_pfn_cache *cache)?
>>> Each user can place it in a natural place.
>>>     =20
>> Sounds good.  I will incorporate this into the split patch.
>>   =20
>=20
> Note that for slots, typically most accesses hit just one slot (the
> largest).  For guests below 4G, there's only one large slot, for guests=

> above 4G there are two.

Right, I find that the cache misses are pretty infrequent so that jives
with your statement.

>=20
>>>>>> +static unsigned long
>>>>>> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa=
,
>>>>>> +           const void *src, unsigned long n)
>>>>>> +{
>>>>>> +    struct _xinterface *_intf =3D to_intf(intf);
>>>>>> +    unsigned long dst;
>>>>>> +    bool kthread =3D !current->mm;
>>>>>> +
>>>>>> +    down_read(&_intf->kvm->slots_lock);
>>>>>> +
>>>>>> +    dst =3D gpa_to_hva(_intf, gpa);
>>>>>> +    if (!dst)
>>>>>> +        goto out;
>>>>>> +
>>>>>> +    if (kthread)
>>>>>> +        use_mm(_intf->mm);
>>>>>> +
>>>>>> +    if (kthread || _intf->mm =3D=3D current->mm)
>>>>>> +        n =3D copy_to_user((void *)dst, src, n);
>>>>>> +    else
>>>>>> +        n =3D _slow_copy_to_user(_intf, dst, src, n);
>>>>>>
>>>>>>
>>>>>>           =20
>>>>> Can't you switch the mm temporarily instead of this?
>>>>>
>>>>>         =20
>>>> Thats actually what I do for the fast-path (use_mm() does a switch_t=
o()
>>>> internally).
>>>>
>>>> The slow-path is only there for completeness for when switching is n=
ot
>>>> possible (such as if called with an mm already active i.e.
>>>> process-context).
>>>>       =20
>>> Still, why can't you switch temporarily?
>>>     =20
>> I am not an mm expert, but iiuc you cannot call switch_to() from
>> anything other than kthread context.  Thats what the doc says, anyway.=

>>   =20
>=20
> Can you provide a pointer?  I don't see why this limitation exists.

See the comments for "use_mm()"

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dbl=
ob;f=3Dmm/mmu_context.c;h=3Dded9081f40219d888e48e41d4b665a712a188d28;hb=3D=
HEAD

>=20
>>>> In practice, however, this doesnt happen.  Virtually
>>>> 100% of the calls in vbus hit the fast-path here, and I suspect most=

>>>> xinterface clients would find the same conditions as well.
>>>>
>>>>       =20
>>> So you have 100% untested code here.
>>>
>>>     =20
>> Actually, no.  Before Michael enlightened me recently regarding
>> switch_to/use_mm, the '_slow_xx' functions were my _only_ path.  So th=
ey
>> have indeed multiple months (and multiple GB) of testing, as it turns
>> out.  I only recently optimized them away to "backup" duty.
>>   =20
>=20
> I meant, unexercised.  This will bitrot quickly.
>=20

Ok, since I don't need it, should I just fail the cases that do not
qualify to use switch_to() (if any)?


--------------enig2C22DE1F3DD63183201231A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrLdx4ACgkQP5K2CMvXmqEFDACfeuW6pCh3F4dpapxTzv4HmsQs
HogAnjZYbDNqW5FzIRMgmZuOqTylC4bV
=PYtV
-----END PGP SIGNATURE-----

--------------enig2C22DE1F3DD63183201231A4--
