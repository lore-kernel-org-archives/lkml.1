Return-Path: <linux-kernel-owner+w=401wt.eu-S1755115AbZJEX5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115AbZJEX5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 19:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754566AbZJEX5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 19:57:52 -0400
Received: from mail-qy0-f173.google.com ([209.85.221.173]:55165 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZJEX5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 19:57:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UzY5kdDj/RlQ6Q5XZ0ZfTQgKuOImgblTf6HOoh/4s569ivVkWaTDjCNWrGv1dkzYd9
         XXm+gtS4JYgrnDkq8niwYDfwFul68xXSqL5DZD5pO/V/i+F/b6KcR9vSaz0S30KnGd95
         TVNgU36T9QHyTBy255hV15JSREYtK3Onyv5MA=
Message-ID: <4ACA87D7.1080206@gmail.com>
Date: Mon, 05 Oct 2009 19:57:11 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [PATCH v2 2/4] KVM: introduce "xinterface" API for external	interaction
 with guests
References: <20091002201159.4014.33268.stgit@dev.haskins.net> <20091002201927.4014.29432.stgit@dev.haskins.net> <4AC8780D.1060800@redhat.com>
In-Reply-To: <4AC8780D.1060800@redhat.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB860718829569959BA8465A1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB860718829569959BA8465A1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> On 10/02/2009 10:19 PM, Gregory Haskins wrote:
>> What: xinterface is a mechanism that allows kernel modules external to=

>> the kvm.ko proper to interface with a running guest.  It accomplishes
>> this by creating an abstracted interface which does not expose any
>> private details of the guest or its related KVM structures, and provid=
es
>> a mechanism to find and bind to this interface at run-time.
>>   =20
>=20
> If this is needed, it should be done as a virt_address_space to which
> kvm and other modules bind, instead of as something that kvm exports an=
d
> other modules import.  The virt_address_space can be identified by an f=
d
> and passed around to kvm and other modules.

IIUC, what you are proposing is something similar to generalizing the
vbus::memctx object.  I had considered doing something like that in the
early design phase of vbus, but then decided it would be a hard-sell to
the mm crowd, and difficult to generalize.

What do you propose as the interface to program the object?

>=20
>> Why: There are various subsystems that would like to interact with a K=
VM
>> guest which are ideally suited to exist outside the domain of the kvm.=
ko
>> core logic. For instance, external pci-passthrough, virtual-bus, and
>> virtio-net modules are currently under development.  In order for thes=
e
>> modules to successfully interact with the guest, they need, at the ver=
y
>> least, various interfaces for signaling IO events, pointer translation=
,
>> and possibly memory mapping.
>>
>> The signaling case is covered by the recent introduction of the
>> irqfd/ioeventfd mechanisms.  This patch provides a mechanism to cover =
the
>> other cases.  Note that today we only expose pointer-translation relat=
ed
>> functions, but more could be added at a future date as needs arise.
>>
>> Example usage: QEMU instantiates a guest, and an external module "foo"=

>> that desires the ability to interface with the guest (say via
>> open("/dev/foo")).  QEMU may then pass the kvmfd to foo via an
>> ioctl, such as: ioctl(foofd, FOO_SET_VMID,&kvmfd).  Upon receipt, the
>> foo module can issue kvm_xinterface_bind(kvmfd) to acquire
>> the proper context.  Internally, the struct kvm* and associated
>> struct module* will remain pinned at least until the foo module calls
>> kvm_xinterface_put().
>>
>>   =20
>=20
> So, under my suggestion above, you'd call
> sys_create_virt_address_space(), populate it, and pass the result to kv=
m
> and to foo.  This allows the use of virt_address_space without kvm and
> doesn't require foo to interact with kvm.

The problem I see here is that the only way I can think to implement
this generally is something that looks very kvm-esque (slots-to-pages
kind of translation).  Is there a way you can think of that does not
involve a kvm.ko originated vtable that is also not kvm centric?

>=20
>> +struct kvm_xinterface_ops {
>> +    unsigned long (*copy_to)(struct kvm_xinterface *intf,
>> +                 unsigned long gpa, const void *src,
>> +                 unsigned long len);
>> +    unsigned long (*copy_from)(struct kvm_xinterface *intf, void *dst=
,
>> +                   unsigned long gpa, unsigned long len);
>> +    struct kvm_xvmap* (*vmap)(struct kvm_xinterface *intf,
>> +                  unsigned long gpa,
>> +                  unsigned long len);
>>   =20
>=20
> How would vmap() work with live migration?

vmap represents shmem regions, and is a per-guest-instance resource.  So
my plan there is that the new and old guest instance would each have the
vmap region instated at the same GPA location (assumption: gpas are
stable across migration), and any state relevant data local to the shmem
(like ring head/tail position) is conveyed in the serialized stream for
the device model.

>=20
>> +
>> +static inline void
>> +_kvm_xinterface_release(struct kref *kref)
>> +{
>> +    struct kvm_xinterface *intf;
>> +    struct module *owner;
>> +
>> +    intf =3D container_of(kref, struct kvm_xinterface, kref);
>> +
>> +    owner =3D intf->owner;
>> +    rmb();
>>   =20
>=20
> Why rmb?

the intf->ops->release() line may invalidate the intf pointer, so we
want to ensure that the read completes before the release() is called.

TBH: I'm not 100% its needed, but I was being conservative.

>=20
>> +
>> +    intf->ops->release(intf);
>> +    module_put(owner);
>> +}
>> +
>>
>> +
>> +/*
>> + * gpa_to_hva() - translate a guest-physical to host-virtual using
>> + * a per-cpu cache of the memslot.
>> + *
>> + * The gfn_to_memslot() call is relatively expensive, and the gpa acc=
ess
>> + * patterns exhibit a high degree of locality.  Therefore, lets cache=

>> + * the last slot used on a per-cpu basis to optimize the lookup
>> + *
>> + * assumes slots_lock held for read
>> + */
>> +static unsigned long
>> +gpa_to_hva(struct _xinterface *_intf, unsigned long gpa)
>> +{
>> +    int                     cpu     =3D get_cpu();
>> +    unsigned long           gfn     =3D gpa>>  PAGE_SHIFT;
>> +    struct kvm_memory_slot *memslot =3D _intf->slotcache[cpu];
>> +    unsigned long           addr    =3D 0;
>> +
>> +    if (!memslot
>> +        || gfn<  memslot->base_gfn
>> +        || gfn>=3D memslot->base_gfn + memslot->npages) {
>> +
>> +        memslot =3D gfn_to_memslot(_intf->kvm, gfn);
>> +        if (!memslot)
>> +            goto out;
>> +
>> +        _intf->slotcache[cpu] =3D memslot;
>> +    }
>> +
>> +    addr =3D _gfn_to_hva(gfn, memslot) + offset_in_page(gpa);
>> +
>> +out:
>> +    put_cpu();
>> +
>> +    return addr;
>> +}
>>   =20
>=20
>=20
> A simple per-vcpu cache (in struct kvm_vcpu) is likely to give better
> results.

per-vcpu will not work well here, unfortunately, since this is an
external interface mechanism.  The callers will generally be from a
kthread or some other non-vcpu related context.  Even if we could figure
out a vcpu to use as a basis, we would require some kind of
heavier-weight synchronization which would not be as desirable.

Therefore, I opted to go per-cpu and use the presumably lighterweight
get_cpu/put_cpu() instead.


>=20
>> +static unsigned long
>> +xinterface_copy_to(struct kvm_xinterface *intf, unsigned long gpa,
>> +           const void *src, unsigned long n)
>> +{
>> +    struct _xinterface *_intf =3D to_intf(intf);
>> +    unsigned long dst;
>> +    bool kthread =3D !current->mm;
>> +
>> +    down_read(&_intf->kvm->slots_lock);
>> +
>> +    dst =3D gpa_to_hva(_intf, gpa);
>> +    if (!dst)
>> +        goto out;
>> +
>> +    if (kthread)
>> +        use_mm(_intf->mm);
>> +
>> +    if (kthread || _intf->mm =3D=3D current->mm)
>> +        n =3D copy_to_user((void *)dst, src, n);
>> +    else
>> +        n =3D _slow_copy_to_user(_intf, dst, src, n);
>>   =20
>=20
> Can't you switch the mm temporarily instead of this?

Thats actually what I do for the fast-path (use_mm() does a switch_to()
internally).

The slow-path is only there for completeness for when switching is not
possible (such as if called with an mm already active i.e.
process-context).  In practice, however, this doesnt happen.  Virtually
100% of the calls in vbus hit the fast-path here, and I suspect most
xinterface clients would find the same conditions as well.

Thanks Avi,
-Greg


--------------enigB860718829569959BA8465A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrKh9cACgkQP5K2CMvXmqFcZACfbzKFrBmkNXWX8SSYkgjO8GQx
hxUAn1Abfd12phaR85+jL7P4tAh5Kw1s
=50VJ
-----END PGP SIGNATURE-----

--------------enigB860718829569959BA8465A1--
