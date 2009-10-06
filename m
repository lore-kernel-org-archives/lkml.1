Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbZJFNcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbZJFNcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 09:32:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbZJFNcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 09:32:51 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:19897 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZJFNch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 09:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=tZIoJFstvOzRiHPSOuGZenR+Hb8OMnjyYV+jHppq3euZurMVwyC6QqfrhEZJl+EEQQ
         pWHLz0DoCCLnvH7kAvt2kyZ/zGvf36AA/OagJxwVcdrdLgzy66CH6cByY1gZFzD9NXCR
         lgaOKIOug6nQvgOsuuBXBpXITKBTeOVFv9oMg=
Message-ID: <4ACB46AD.8010405@gmail.com>
Date: Tue, 06 Oct 2009 09:31:25 -0400
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
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com> <4ACA87D7.1080206@gmail.com> <4ACB0F3C.1000705@redhat.com>
In-Reply-To: <4ACB0F3C.1000705@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC0C0AA8B4FF43A1CB1B5C749"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC0C0AA8B4FF43A1CB1B5C749
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/06/2009 01:57 AM, Gregory Haskins wrote:
>> Avi Kivity wrote:
>>  =20
>>> On 10/02/2009 10:19 PM, Gregory Haskins wrote:
>>>    =20
>>>> What: xinterface is a mechanism that allows kernel modules external =
to
>>>> the kvm.ko proper to interface with a running guest.  It accomplishe=
s
>>>> this by creating an abstracted interface which does not expose any
>>>> private details of the guest or its related KVM structures, and
>>>> provides
>>>> a mechanism to find and bind to this interface at run-time.
>>>>
>>>>       =20
>>> If this is needed, it should be done as a virt_address_space to which=

>>> kvm and other modules bind, instead of as something that kvm exports =
and
>>> other modules import.  The virt_address_space can be identified by an=
 fd
>>> and passed around to kvm and other modules.
>>>     =20
>> IIUC, what you are proposing is something similar to generalizing the
>> vbus::memctx object.  I had considered doing something like that in th=
e
>> early design phase of vbus, but then decided it would be a hard-sell t=
o
>> the mm crowd, and difficult to generalize.
>>
>> What do you propose as the interface to program the object?
>>   =20
>=20
> Something like the current kvm interfaces, de-warted.  It will be a har=
d
> sell indeed, for good reasons.

I am not convinced generalizing this at this point is the best step
forward, since we only have a KVM client.  Let me put some more thought
into it.


>=20
>>> So, under my suggestion above, you'd call
>>> sys_create_virt_address_space(), populate it, and pass the result to =
kvm
>>> and to foo.  This allows the use of virt_address_space without kvm an=
d
>>> doesn't require foo to interact with kvm.
>>>     =20
>> The problem I see here is that the only way I can think to implement
>> this generally is something that looks very kvm-esque (slots-to-pages
>> kind of translation).  Is there a way you can think of that does not
>> involve a kvm.ko originated vtable that is also not kvm centric?
>>   =20
>=20
> slots would be one implementation, if you can think of others then you'=
d
> add them.

I'm more interested in *how* you'd add them more than "if" we would add
them.  What I am getting at are the logistics of such a beast.

For instance, would I have /dev/slots-vas with ioctls for adding slots,
and /dev/foo-vas for adding foos?  And each one would instantiate a
different vas_struct object with its own vas_struct->ops?  Or were you
thinking of something different.

>=20
> If you can't, I think it indicates that the whole thing isn't necessary=

> and we're better off with slots and virtual memory.

I'm not sure if we are talking about the same thing yet, but if we are,
there are uses of a generalized interface outside of slots/virtual
memory (Ira's physical box being a good example).

In any case, I think the best approach is what I already proposed.
KVM's arrangement of memory is going to tend to be KVM specific, and
what better place to implement the interface than close to the kvm.ko cor=
e.

> The only thing missing is dma, which you don't deal with anyway.
>=20

Afaict I do support dma in the generalized vbus::memctx, though I do not
use it on anything related to KVM or xinterface.  Can you elaborate on
the problem here?  Does the SG interface in 4/4 help get us closer to
what you envision?

>>>> +struct kvm_xinterface_ops {
>>>> +    unsigned long (*copy_to)(struct kvm_xinterface *intf,
>>>> +                 unsigned long gpa, const void *src,
>>>> +                 unsigned long len);
>>>> +    unsigned long (*copy_from)(struct kvm_xinterface *intf, void *d=
st,
>>>> +                   unsigned long gpa, unsigned long len);
>>>> +    struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
>>>> +                  unsigned long gpa,
>>>> +                  unsigned long len);
>>>>
>>>>       =20
>>> How would vmap() work with live migration?
>>>     =20
>> vmap represents shmem regions, and is a per-guest-instance resource.  =
So
>> my plan there is that the new and old guest instance would each have t=
he
>> vmap region instated at the same GPA location (assumption: gpas are
>> stable across migration), and any state relevant data local to the shm=
em
>> (like ring head/tail position) is conveyed in the serialized stream fo=
r
>> the device model.
>>   =20
>=20
> You'd have to copy the entire range since you don't know what the guest=

> might put there.  I guess it's acceptable for small areas.

?  The vmap is presumably part of an ABI between guest and host, so the
host should always know what structure is present within the region, and
what is relevant from within that structure to migrate once that state
is "frozen".

These regions (for vbus, anyway) equate to things like virtqueue
metadata, and presumably the same problem exists for virtio-net in
userspace as it does here, since that is another form of a "vmap".  So
whatever solution works for virtio-net migrating its virtqueues in
userspace should be close to what will work here.  The primary
difference is the location of the serializer.

>=20
>>>> +
>>>> +static inline void
>>>> +_kvm_xinterface_release(struct kref *kref)
>>>> +{
>>>> +    struct kvm_xinterface *intf;
>>>> +    struct module *owner;
>>>> +
>>>> +    intf =3D container_of(kref, struct kvm_xinterface, kref);
>>>> +
>>>> +    owner =3D intf->owner;
>>>> +    rmb();
>>>>
>>>>       =20
>>> Why rmb?
>>>     =20
>> the intf->ops->release() line may invalidate the intf pointer, so we
>> want to ensure that the read completes before the release() is called.=

>>
>> TBH: I'm not 100% its needed, but I was being conservative.
>>   =20
>=20
> rmb()s are only needed if an external agent can issue writes, otherwise=

> you'd need one after every statement.

I was following lessons learned here:

http://lkml.org/lkml/2009/7/7/175

Perhaps mb() or barrier() are more appropriate than rmb()?  I'm CC'ing
David Howells in case he has more insight.

>=20
>=20
>=20
>=20
>>>
>>> A simple per-vcpu cache (in struct kvm_vcpu) is likely to give better=

>>> results.
>>>     =20
>> per-vcpu will not work well here, unfortunately, since this is an
>> external interface mechanism.  The callers will generally be from a
>> kthread or some other non-vcpu related context.  Even if we could figu=
re
>> out a vcpu to use as a basis, we would require some kind of
>> heavier-weight synchronization which would not be as desirable.
>>
>> Therefore, I opted to go per-cpu and use the presumably lighterweight
>> get_cpu/put_cpu() instead.
>>   =20
>=20
> This just assumes a low context switch rate.

It primarily assumes a low _migration_ rate, since you do not typically
have two contexts on the same cpu pounding on the memslots.  And even if
you did, there's a good chance for locality between the threads, since
the IO activity is likely related.  For the odd times where locality
fails to yield a hit, the time-slice or migration rate should be
sufficiently infrequent enough to still yield high 90s hit rates for
when it matters.  For low-volume, the lookup is in the noise so I am not
as concerned.

IOW: Where the lookup hurts the most is trying to walk an SG list, since
each pointer is usually within the same slot.  For this case, at least,
this cache helps immensely, at least according to profiles.

>=20
> How about a gfn_to_pfn_cached(..., struct gfn_to_pfn_cache *cache)?=20
> Each user can place it in a natural place.

Sounds good.  I will incorporate this into the split patch.

>=20
>>>> +static unsigned long
>>>> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
>>>> +           const void *src, unsigned long n)
>>>> +{
>>>> +    struct _xinterface *_intf =3D to_intf(intf);
>>>> +    unsigned long dst;
>>>> +    bool kthread =3D !current->mm;
>>>> +
>>>> +    down_read(&_intf->kvm->slots_lock);
>>>> +
>>>> +    dst =3D gpa_to_hva(_intf, gpa);
>>>> +    if (!dst)
>>>> +        goto out;
>>>> +
>>>> +    if (kthread)
>>>> +        use_mm(_intf->mm);
>>>> +
>>>> +    if (kthread || _intf->mm =3D=3D current->mm)
>>>> +        n =3D copy_to_user((void *)dst, src, n);
>>>> +    else
>>>> +        n =3D _slow_copy_to_user(_intf, dst, src, n);
>>>>
>>>>       =20
>>> Can't you switch the mm temporarily instead of this?
>>>     =20
>> Thats actually what I do for the fast-path (use_mm() does a switch_to(=
)
>> internally).
>>
>> The slow-path is only there for completeness for when switching is not=

>> possible (such as if called with an mm already active i.e.
>> process-context).
>=20
> Still, why can't you switch temporarily?

I am not an mm expert, but iiuc you cannot call switch_to() from
anything other than kthread context.  Thats what the doc says, anyway.

>=20
>> In practice, however, this doesnt happen.  Virtually
>> 100% of the calls in vbus hit the fast-path here, and I suspect most
>> xinterface clients would find the same conditions as well.
>>   =20
>=20
> So you have 100% untested code here.
>=20

Actually, no.  Before Michael enlightened me recently regarding
switch_to/use_mm, the '_slow_xx' functions were my _only_ path.  So they
have indeed multiple months (and multiple GB) of testing, as it turns
out.  I only recently optimized them away to "backup" duty.

Thanks Avi,
-Greg


--------------enigC0C0AA8B4FF43A1CB1B5C749
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrLRq0ACgkQP5K2CMvXmqGynwCfS24UHKkR/pBf/GrxN0bf6O2d
9mQAni2pQu8Cwohfcwq784msHEMcI6bi
=/cCb
-----END PGP SIGNATURE-----

--------------enigC0C0AA8B4FF43A1CB1B5C749--
