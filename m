Return-Path: <linux-kernel-owner+w=401wt.eu-S1760689AbZEGOzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760689AbZEGOzK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZEGOyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:54:55 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:52527 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbZEGOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:54:55 -0400
Message-ID: <4A02F63B.60104@novell.com>
Date: Thu, 07 May 2009 10:54:51 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>, viro@ZenIV.linux.org.uk,
       kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [KVM PATCH v4 2/2] kvm: add support for irqfd via eventfd-notification
 interface
References: <20090504175657.26758.12503.stgit@dev.haskins.net> <20090504175750.26758.7023.stgit@dev.haskins.net> <4A0175F0.1090705@novell.com> <alpine.DEB.1.10.0905060818000.32007@makko.or.mcafeemobile.com> <4A01AEC1.8020201@novell.com> <alpine.DEB.1.10.0905061834080.32606@makko.or.mcafeemobile.com> <4A02AE65.3000800@redhat.com> <20090507134607.GA25311@amt.cnet> <4A02E9C5.7020704@novell.com> <4A02F160.7080907@redhat.com>
In-Reply-To: <4A02F160.7080907@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9406DB23D9EC2EE661F9CCFE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9406DB23D9EC2EE661F9CCFE
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> One thing I was thinking here was that I could create a flag for the
>> kvm_irqfd() function for something like "KVM_IRQFD_MODE_CLEAR".  This
>> flag when specified at creation time will cause the event to execute a=

>> clear operation instead of a set when triggered.  That way, the defaul=
t
>> mode is an edge-triggered set.  The non-default mode is to trigger a
>> clear.  Level-triggered ints could therefore create two irqfds, one fo=
r
>> raising, the other for clearing.
>>  =20
>
> That's my second choice option.
>
>> An alternative is to abandon the use of eventfd, and allow the irqfd t=
o
>> be a first-class anon-fd.  The parameters passed to the write/signal()=

>> function could then indicate the desired level.  The disadvantage woul=
d
>> be that it would not be compatible with eventfd, so we would need to
>> decide if the tradeoff is worth it.
>>  =20
>
> I would really like to keep using eventfd.  Which is why I asked
> Davide about the prospects of direct callbacks (vs wakeups).

I saw that request.  That would be ideal.

>
>> OTOH, I suspect level triggered interrupts will be primarily in the
>> legacy domain, so perhaps we do not need to worry about it too much.
>> Therefore, another option is that we *could* simply set the stake in t=
he
>> ground that legacy/level cannot use irqfd.
>>  =20
>
> This is my preferred option.  For a virtio-net-server in the kernel,
> we'd service its eventfd in qemu, raising and lowering the pci
> interrupt in the traditional way.
>
> But we'd still need to know when to lower the interrupt.  How?

IIUC, isn't that  usually device/subsystem specific, and out of scope of
the GSI delivery vehicle?  For instance, most devices I have seen with
level ints have a register in their device register namespace for acking
the int.  As an aside, this is what causes some of the grief in dealing
with shared interrupts like KVM pass-through and/or threaded-isrs: =20
There isn't a standardized way to ACK them.

You may also see some generalization of masking/acking in things like
the MSI-X table.  But again, this would be out of scope of the general
GSI delivery path IIUC.

I understand that there is a feedback mechanism in the ioapic model for
calling back on acknowledgment of the interrupt.  But I am not sure what
is how the real hardware works normally, and therefore I am not
convinced that is something we need to feed all the way back (i.e. via
irqfd or whatever).  In the interest of full disclosure, its been a few
years since I studied the xAPIC docs, so I might be out to lunch on that
assertion. ;)

-Greg




--------------enig9406DB23D9EC2EE661F9CCFE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoC9jsACgkQlOSOBdgZUxkyDgCggbdz/ZPYzDdwWxiHnN0kU46s
/2AAn0RHMk/I5hik1ajMVbcdcOi8XtQr
=x7nZ
-----END PGP SIGNATURE-----

--------------enig9406DB23D9EC2EE661F9CCFE--
