Return-Path: <linux-kernel-owner+w=401wt.eu-S1759765AbZE1L7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759765AbZE1L7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 07:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbZE1L7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 07:59:31 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:59858 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbZE1L7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 07:59:30 -0400
Message-ID: <4A1E7C9A.7020206@novell.com>
Date: Thu, 28 May 2009 07:59:22 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v2 2/3] kvm: cleanup io_device code
References: <20090527213535.24324.62362.stgit@dev.haskins.net> <20090527213744.24324.82745.stgit@dev.haskins.net> <20090528054904.GK20823@sequoia.sous-sol.org>
In-Reply-To: <20090528054904.GK20823@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB3225CF20EC1833EF816B2B8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB3225CF20EC1833EF816B2B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Gregory Haskins (ghaskins@novell.com) wrote:
>  =20
>> We modernize the io_device code so that we use container_of() instead =
of
>> dev->private, and move the vtable to a separate ops structure
>> (theoretically allows better caching for multiple instances of the sam=
e
>> ops structure)
>>    =20
>
> Looks like a nice cleanup.  Couple minor nits.
>
>  =20
>> +static struct kvm_io_device_ops pit_dev_ops =3D {
>> +	.read     =3D pit_ioport_read,
>> +	.write    =3D pit_ioport_write,
>> +	.in_range =3D pit_in_range,
>> +};
>> +
>> +static struct kvm_io_device_ops speaker_dev_ops =3D {
>> +	.read     =3D speaker_ioport_read,
>> +	.write    =3D speaker_ioport_write,
>> +	.in_range =3D speaker_in_range,
>> +};
>>    =20
>
> kvm_io_device_ops instances could be made const.
>  =20

Ack

>  =20
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2227,7 +2227,7 @@ static struct kvm_io_device *vcpu_find_pervcpu_d=
ev(struct kvm_vcpu *vcpu,
>> =20
>>  	if (vcpu->arch.apic) {
>>  		dev =3D &vcpu->arch.apic->dev;
>> -		if (dev->in_range(dev, addr, len, is_write))
>> +		if (dev->ops->in_range(dev, addr, len, is_write))
>>  			return dev;
>>    =20
>
>  =20
>> --- a/virt/kvm/iodev.h
>> +++ b/virt/kvm/iodev.h
>> @@ -18,7 +18,9 @@
>> =20
>>  #include <linux/kvm_types.h>
>> =20
>> -struct kvm_io_device {
>> +struct kvm_io_device;
>> +
>> +struct kvm_io_device_ops {
>>  	void (*read)(struct kvm_io_device *this,
>>  		     gpa_t addr,
>>  		     int len,
>> @@ -30,16 +32,25 @@ struct kvm_io_device {
>>  	int (*in_range)(struct kvm_io_device *this, gpa_t addr, int len,
>>  			int is_write);
>>  	void (*destructor)(struct kvm_io_device *this);
>> +};
>> +
>> =20
>> -	void             *private;
>> +struct kvm_io_device {
>> +	struct kvm_io_device_ops *ops;
>>  };
>>    =20
>
> Did you plan to extend kvm_io_device struct?
>
>  =20
>> +static inline void kvm_iodevice_init(struct kvm_io_device *dev,
>> +				     struct kvm_io_device_ops *ops)
>> +{
>> +	dev->ops =3D ops;
>> +}
>>    =20
>
> And similarly, did you have a plan to do more with kvm_iodevice_init()?=

> Otherwise looking a bit like overkill to me.
>  =20

Yeah.  As of right now my plan is to wait for Marcelo's lock cleanup to
go in and integrate with that, and then convert the MMIO/PIO code to use
RCU to acquire a reference to the io_device (so we run as fine-graned
and lockless as possible).  When that happens, you will see an atomic_t
in the struct/init as well.

Even if that doesn't make the cut after review, I am thinking that we
may be making the structure more complex in the future (for instance, to
use a rbtree/hlist instead of the array, or to do tricks with caching
the MRU device, etc.) and this will simplify that effort by already
having all users call the abstracted init.=20

That said, we could just defer these hunks until needed.  I just figured
"while Im in here" but its nbd either way.

>  =20
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -2456,7 +2456,7 @@ struct kvm_io_device *kvm_io_bus_find_dev(struct=
 kvm_io_bus *bus,
>>  	for (i =3D 0; i < bus->dev_count; i++) {
>>  		struct kvm_io_device *pos =3D bus->devs[i];
>> =20
>> -		if (pos->in_range(pos, addr, len, is_write))
>> +		if (kvm_iodevice_inrange(pos, addr, len, is_write))
>>  			return pos;
>>  	}
>>    =20
>
> You converted this to the helper but not vcpu_find_pervcpu_dev() (not
> convinced it actually helps readability, but consistency is good).

Oops..oversight.  Will fix.

>   BTW,
> while there, s/kvm_iodevice_inrange/kvm_iodevice_in_range/ would be nic=
e.
>  =20

Yeah, good idea.  Will fix.

Thanks Chris,
-Greg



--------------enigB3225CF20EC1833EF816B2B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoefJ8ACgkQlOSOBdgZUxk9kQCgjlPIJ6oCUHU/s3ESxIhFwbxh
SicAnjK0C8Sco/zu3TdxMeJzYycGk+Sd
=fbcg
-----END PGP SIGNATURE-----

--------------enigB3225CF20EC1833EF816B2B8--
