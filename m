Return-Path: <linux-kernel-owner+w=401wt.eu-S932301AbZEGOCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301AbZEGOCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762809AbZEGOBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:01:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33914 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762819AbZEGOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:01:49 -0400
Message-ID: <4A02E9C5.7020704@novell.com>
Date: Thu, 07 May 2009 10:01:41 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: Avi Kivity <avi@redhat.com>, Davide Libenzi <davidel@xmailserver.org>,
       Gregory Haskins <ghaskins@novell.com>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <20090507134607.GA25311@amt.cnet>
In-Reply-To: <20090507134607.GA25311@amt.cnet>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD7AB3D18DF30DF587ACF2DD3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD7AB3D18DF30DF587ACF2DD3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Marcelo Tosatti wrote:
> On Thu, May 07, 2009 at 12:48:21PM +0300, Avi Kivity wrote:
>  =20
>> Davide Libenzi wrote:
>>    =20
>>> On Wed, 6 May 2009, Gregory Haskins wrote:
>>>
>>>  =20
>>>      =20
>>>> I think we are ok in this regard (at least in v5) without the=20
>>>> callback. kvm holds irqfd, which holds eventfd.  In a normal=20
>>>> situation, we will
>>>> have eventfd with 2 references.  If userspace closes the eventfd, it=

>>>> will drop 1 of the 2 eventfd file references, but the object should
>>>> remain intact as long as kvm still holds it as well.  When the kvm-f=
d is
>>>> released, we will then decouple from the eventfd->wqh and drop the l=
ast
>>>> fput(), officially freeing it.
>>>>
>>>> Likewise, if kvm is closed before the eventfd, we will simply decoup=
le
>>>> from the wqh and fput(eventfd), leaving the last reference held by
>>>> userspace until it closes as well.
>>>>
>>>> Let me know if you see any holes in that.
>>>>    =20
>>>>        =20
>>> Looks OK, modulo my knowledge of KVM internals.
>>>  =20
>>>      =20
>> What's your take on adding irq context safe callbacks to irqfd?
>>
>> To give some background here, we would like to use eventfd as a generi=
c =20
>> connector between components, so the components do not know about each=
 =20
>> other.  So far eventfd successfully abstracts among components in the =
=20
>> same process, in different processes, and in the kernel.
>>
>> eventfd_signal() can be safely called from irq context, and will wake =
up =20
>> a waiting task.  But in some cases, if the consumer is in the kernel, =
it =20
>> may be able to consume the event from irq context, saving a context=20
>> switch.
>>
>> So, will you consider patches adding this capability to eventfd?
>>    =20
>
> (pasting from a separate thread)
>
>  =20
>> That's my thinking.  PCI interrupts don't work because we need to do  =

>> some hacky stuff in there, but MSI should.  Oh, and we could improve
>> UIO =20
>> support for interrupts when using MSI, since there's no need to =20
>> acknowledge the interrupt.
>>    =20
>
> Ok, so for INTx assigned devices all you need to do on the ACK handler
> is to re-enable the host interrupt (and set the guest interrupt line to=

> low).
>
> Right now the ack comes through a kvm internal irq ack callback.
>
> AFAICS there is no mechanism in irqfd for ACK notification, and
> interrupt injection is edge triggered.
>
> So for PCI INTx assigned devices (or any INTx level), you'd want to kee=
p
> the guest interrupt high, with some way to notify the ACK.
>
> Avi mentioned a separate irqfd to notify the ACK. For assigned devices,=

> you could register a fd wakeup function in that fd, which replaces the
> current irq ACK callback?
>  =20

One thing I was thinking here was that I could create a flag for the
kvm_irqfd() function for something like "KVM_IRQFD_MODE_CLEAR".  This
flag when specified at creation time will cause the event to execute a
clear operation instead of a set when triggered.  That way, the default
mode is an edge-triggered set.  The non-default mode is to trigger a
clear.  Level-triggered ints could therefore create two irqfds, one for
raising, the other for clearing.

An alternative is to abandon the use of eventfd, and allow the irqfd to
be a first-class anon-fd.  The parameters passed to the write/signal()
function could then indicate the desired level.  The disadvantage would
be that it would not be compatible with eventfd, so we would need to
decide if the tradeoff is worth it.

OTOH, I suspect level triggered interrupts will be primarily in the
legacy domain, so perhaps we do not need to worry about it too much.=20
Therefore, another option is that we *could* simply set the stake in the
ground that legacy/level cannot use irqfd.

Thoughts?

-Greg



--------------enigD7AB3D18DF30DF587ACF2DD3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoC6cUACgkQlOSOBdgZUxnvcgCfbvU/41uvkOEneoVoJiMFNtAS
m/IAoIcATVaIkEp6i/iyyd+MNTsldu9h
=wlyK
-----END PGP SIGNATURE-----

--------------enigD7AB3D18DF30DF587ACF2DD3--
