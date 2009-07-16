Return-Path: <linux-kernel-owner+w=401wt.eu-S932543AbZGPPsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbZGPPsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932514AbZGPPsC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:48:02 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35921 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbZGPPsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:48:00 -0400
Message-ID: <4A5F4B96.6050409@novell.com>
Date: Thu, 16 Jul 2009 11:47:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.22 (Macintosh/20090605)
MIME-Version: 1.0
To: Anthony Liguori <aliguori@us.ibm.com>
CC: Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, avi@redhat.com, glommer@redhat.com
Subject: Re: [KVM PATCH] KVM: introduce "xinterface" API for external interaction
 with guests
References: <20090716150323.29318.17714.stgit@dev.haskins.net> <20090716151945.29318.10882.stgit@dev.haskins.net> <4A5F4945.3080202@us.ibm.com>
In-Reply-To: <4A5F4945.3080202@us.ibm.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF6C6D4F7816A0EC2C29DF380"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF6C6D4F7816A0EC2C29DF380
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Anthony Liguori wrote:
> Gregory Haskins wrote:
>> +/*
>> + * ------------
>> + * XINTERFACE (External Interface)
>> + * -------------
>> + */
>> +
>> +static struct kvm *
>> +intf_to_kvm(struct kvm_xinterface *intf)
>> +{
>> +    return container_of(intf, struct kvm, xinterface);
>> +}
>> +
>> +static unsigned long
>> +xinterface_gpa_to_hva(struct kvm_xinterface *intf, unsigned long gpa)=

>> +{
>> +    struct kvm *kvm =3D intf_to_kvm(intf);
>> +    unsigned long addr;
>> +
>> +    addr =3D gfn_to_hva(kvm, gpa >> PAGE_SHIFT);
>> +    if (kvm_is_error_hva(addr))
>> +        return 0;
>> +
>> +    return addr + offset_in_page(gpa);
>> +}
>> +
>> +static struct page *
>> +xinterface_gpa_to_page(struct kvm_xinterface *intf, unsigned long gpa=
)
>> +{
>> +    struct kvm *kvm =3D intf_to_kvm(intf);
>> +    struct page *page;
>> +
>> +    page =3D gfn_to_page(kvm, gpa >> PAGE_SHIFT);
>> +    if (page =3D=3D bad_page)
>> +        return ERR_PTR(-EINVAL);
>> +
>> +    return page;
>> +}
>> +
>> +static void
>> +xinterface_release(struct kvm_xinterface *intf)
>> +{
>> +    struct kvm *kvm =3D intf_to_kvm(intf);
>> +
>> +    kvm_put_kvm(kvm);
>> +}
>> +
>> +struct kvm_xinterface_ops _kvm_xinterface_ops =3D {
>> +    .gpa_to_hva  =3D xinterface_gpa_to_hva,
>> +    .gpa_to_page =3D xinterface_gpa_to_page,
>> +    .release     =3D xinterface_release,
>> +};
>>  =20
>
> How do you deal with locking?
>
> The mappings (gpa_to_page) are not fixed.  They can and do change very
> often.  The interface doesn't seem to attempt to cope with this.

Hmm, well I used to need gpa_to_page() in the older version of vbus that
did explicit hypercalls, but I don't actually use it today in v4.  I
left it in because it seems like it might be useful in general (perhaps
for Michael).  However, if this ends up being a real problem I suppose
we can just drop that vtable entry and let the guy that actually needs
it deal with the issues ;)  I really only require gpa_to_hva() in the
short-term.

That said, I think the assumption that was made when I was using this
was that a proper ref for the page was acquired by the gfn_to_page() and
dropped by the caller.  This was always used in the context of a
hypercall/vmexit so presumably the gpa should be considered stable
across that call.  Is that not true?

Regards,
-Greg



--------------enigF6C6D4F7816A0EC2C29DF380
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkpfS6MACgkQlOSOBdgZUxkmwwCfVfJ9PxGnhruogNyQ+PmTnGF2
fogAoIaVATy9iKIT/ipvpx4rFZ5ub3RT
=lHok
-----END PGP SIGNATURE-----

--------------enigF6C6D4F7816A0EC2C29DF380--
