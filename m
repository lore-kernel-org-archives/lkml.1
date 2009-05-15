Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbZEODgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbZEODgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 23:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754459AbZEODgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 23:36:08 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:56806 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbZEODgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 23:36:06 -0400
Message-ID: <4A0CE318.1020303@novell.com>
Date: Thu, 14 May 2009 23:35:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org, viro@ZenIV.linux.org.uk,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v7 2/3] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090512181134.26131.10023.stgit@dev.haskins.net> <20090512182655.26131.53824.stgit@dev.haskins.net> <4A0BFF13.9090802@redhat.com> <4A0C3E54.1090109@novell.com> <alpine.DEB.1.10.0905142016590.7574@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0905142016590.7574@makko.or.mcafeemobile.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0D63848B37975D2CFFB418DF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0D63848B37975D2CFFB418DF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Davide Libenzi wrote:
> On Thu, 14 May 2009, Gregory Haskins wrote:
>
>  =20
>> Avi Kivity wrote:
>>    =20
>>> Gregory Haskins wrote:
>>>      =20
>>>> KVM provides a complete virtual system environment for guests, inclu=
ding
>>>> support for injecting interrupts modeled after the real
>>>> exception/interrupt
>>>> facilities present on the native platform (such as the IDT on x86).
>>>> Virtual interrupts can come from a variety of sources (emulated devi=
ces,
>>>> pass-through devices, etc) but all must be injected to the guest via=

>>>> the KVM infrastructure.  This patch adds a new mechanism to inject a=

>>>> specific
>>>> interrupt to a guest using a decoupled eventfd mechnanism:  Any lega=
l
>>>> signal
>>>> on the irqfd (using eventfd semantics from either userspace or
>>>> kernel) will
>>>> translate into an injected interrupt in the guest at the next availa=
ble
>>>> interrupt window.
>>>>
>>>> +
>>>> +static void
>>>> +irqfd_inject(struct work_struct *work)
>>>> +{
>>>> +    struct _irqfd *irqfd =3D container_of(work, struct _irqfd, work=
);
>>>> +    struct kvm *kvm =3D irqfd->kvm;
>>>> +
>>>>  =20
>>>>        =20
>>> I think you need to ->read() from the irqfd, otherwise the count will=

>>> never clear.
>>>      =20
>> Yeah, and this is a disavantage to using eventfd vs a custom anon-fd
>> implementation.
>>
>> However, the count is really only there for deciding whether to sleep =
a
>> traditional eventfd recipient which doesn't really apply in this
>> application.  I suppose we could try to invoke the read method (or add=
 a
>> new method to eventfd to allow it to be cleared independent of the
>> f_ops->read() (ala eventfd_signal() vs f_ops->write()).  I'm not
>> convinced we really need to worry about it, though.  IMO we can just l=
et
>> the count accumulate.
>>
>> But if you insist this loose end should be addressed, perhaps Davide h=
as
>> some thoughts on how to best do this?
>>    =20
>
> The counter is 64bit, so at 1M IRQ/s will take about 585K years to=20
> saturate. But from a symmetry POV, it may be better to clear it. Maybe =

> with a kernel-side eventfd_read()?
>  =20
Hi Davide,

I think ultimately that would be the direction to go.  I will defer to
Avi, but I think we have reached consensus that while its perhaps sloppy
to leave the counter untouched, we can back-burner this issue for now
and just let it accumulate indefinately.  If it becomes an issue down
the road we can always fix it then.

Thanks,
-Greg



--------------enig0D63848B37975D2CFFB418DF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoM4xgACgkQlOSOBdgZUxmZnACghQM+fSCmJSaFH/h3NvkKMTrY
0qcAn2hon6cdmJ3tUU/mearvwLDtwifb
=RgUw
-----END PGP SIGNATURE-----

--------------enig0D63848B37975D2CFFB418DF--
