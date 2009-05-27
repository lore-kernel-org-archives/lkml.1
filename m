Return-Path: <linux-kernel-owner+w=401wt.eu-S1756128AbZE0Ucx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128AbZE0Ucx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbZE0Ucl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:32:41 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:47070 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZE0Uck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=Sa/+dAn//jBJFBniTX+LusEi4wsMTWJk4uUnCvlHnNgYKtRYLKTpuMSCfpCPZZO2Ho
         EBk1XSiZwzPhQecJejRpNjocjjIiTJ9416xHG3qHk5k4TBPiPa/hsf5Hyi2e/ENkZBbw
         Y7hbdvOEAo5sr2pSqzcADFnlXDkrjUaRc8qkE=
Message-ID: <4A1DA361.6050303@gmail.com>
Date: Wed, 27 May 2009 16:32:33 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: Gregory Haskins <ghaskins@novell.com>, avi@redhat.com, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix coalesced_mmio leak on shutdown
References: <20090527164059.23966.75880.stgit@dev.haskins.net> <20090527202932.GI20823@sequoia.sous-sol.org>
In-Reply-To: <20090527202932.GI20823@sequoia.sous-sol.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig95C7059E41369ACC8285FEB9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig95C7059E41369ACC8285FEB9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Chris Wright wrote:
> * Gregory Haskins (ghaskins@novell.com) wrote:
>  =20
>> It would appear that we are invoking kfree() on the wrong pointer in t=
he
>> destructor for the coalesced_mmio device.  This would result in a pote=
ntial
>> leak during shutdown.
>>    =20
>
> Happens to work and not leak:
>
> struct kvm_coalesced_mmio_dev {=20
>         struct kvm_io_device dev;
>         struct kvm *kvm;
>         int nb_zones;
>         struct kvm_coalesced_mmio_zone zone[KVM_COALESCED_MMIO_ZONE_MAX=
];
> };
>
>  =20
Ah, yes.  That explains it.  Still sloppy, tho.

>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> ---
>>
>>  virt/kvm/coalesced_mmio.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
>> index 5ae620d..03ea280 100644
>> --- a/virt/kvm/coalesced_mmio.c
>> +++ b/virt/kvm/coalesced_mmio.c
>> @@ -80,7 +80,10 @@ static void coalesced_mmio_write(struct kvm_io_devi=
ce *this,
>> =20
>>  static void coalesced_mmio_destructor(struct kvm_io_device *this)
>>  {
>> -	kfree(this);
>> +	struct kvm_coalesced_mmio_dev *dev =3D
>> +		(struct kvm_coalesced_mmio_dev *)this->private;
>>    =20
>
> I think container_of() makes more sense here.
>  =20

I was working on that patch when I noticed the "leak" above.  Figured I
should send the fix out first, in case my container_of patch is shot down=
=2E

Just polishing it up now.  Will send out soon.

-Greg


--------------enig95C7059E41369ACC8285FEB9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkodo2UACgkQP5K2CMvXmqGG5wCeL+jDLYgWyEBEn97niW5bu6kt
JnEAn2pqNscKSB+uJ2jO96rmSfcNRJkv
=tjio
-----END PGP SIGNATURE-----

--------------enig95C7059E41369ACC8285FEB9--
