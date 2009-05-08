Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZEHPUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZEHPUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753206AbZEHPUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:20:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34354 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZEHPUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:20:33 -0400
Message-ID: <4A044DB5.7050304@novell.com>
Date: Fri, 08 May 2009 11:20:21 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com>
In-Reply-To: <4A03EA83.6040907@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6B92333EF09FAE6F72FD30C4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6B92333EF09FAE6F72FD30C4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>> Anthony Liguori wrote:
>> =20
>>> Gregory Haskins wrote:
>>>   =20
>>>> Today, there is no equivelent of a platform agnostic "iowrite32()" f=
or
>>>> hypercalls so the driver would look like the pseudocode above except=

>>>> substitute with kvm_hypercall(), lguest_hypercall(), etc.  The
>>>> proposal
>>>> is to allow the hypervisor to assign a dynamic vector to resources i=
n
>>>> the backend and convey this vector to the guest (such as in PCI
>>>> config-space as mentioned in my example use-case).  The provides the=

>>>> "address negotiation" function that would normally be done for
>>>> something
>>>> like a pio port-address.   The hypervisor agnostic driver can then u=
se
>>>> this globally recognized address-token coupled with other
>>>> device-private
>>>> ABI parameters to communicate with the device.  This can all occur
>>>> without the core hypervisor needing to understand the details
>>>> beyond the
>>>> addressing.
>>>>        =20
>>> PCI already provide a hypervisor agnostic interface (via IO
>>> regions). You have a mechanism for devices to discover which regions
>>> they have
>>> allocated and to request remappings.  It's supported by Linux and
>>> Windows.  It works on the vast majority of architectures out there
>>> today.
>>>
>>> Why reinvent the wheel?
>>>    =20
>>
>> I suspect the current wheel is square.  And the air is out.  Plus its
>> pulling to the left when I accelerate, but to be fair that may be my
>> alignment....
>
> No, your wheel is slightly faster on the highway, but doesn't work at
> all off-road.

Heh..

>
> Consider nested virtualization where the host (H) runs a guest (G1)
> which is itself a hypervisor, running a guest (G2).  The host exposes
> a set of virtio (V1..Vn) devices for guest G1.  Guest G1, rather than
> creating a new virtio devices and bridging it to one of V1..Vn,
> assigns virtio device V1 to guest G2, and prays.
>
> Now guest G2 issues a hypercall.  Host H traps the hypercall, sees it
> originated in G1 while in guest mode, so it injects it into G1.  G1
> examines the parameters but can't make any sense of them, so it
> returns an error to G2.
>
> If this were done using mmio or pio, it would have just worked.  With
> pio, H would have reflected the pio into G1, G1 would have done the
> conversion from G2's port number into G1's port number and reissued
> the pio, finally trapped by H and used to issue the I/O.=20

I might be missing something, but I am not seeing the difference here.=20
We have an "address" (in this case the HC-id) and a context (in this
case G1 running in non-root mode).   Whether the  trap to H is a HC or a
PIO, the context tells us that it needs to re-inject the same trap to G1
for proper handling.  So the "address" is re-injected from H to G1 as an
emulated trap to G1s root-mode, and we continue (just like the PIO).

And likewise, in both cases, G1 would (should?) know what to do with
that "address" as it relates to G2, just as it would need to know what
the PIO address is for.  Typically this would result in some kind of
translation of that "address", but I suppose even this is completely
arbitrary and only G1 knows for sure.  E.g. it might translate from
hypercall vector X to Y similar to your PIO example, it might completely
change transports, or it might terminate locally (e.g. emulated device
in G1).   IOW: G2 might be using hypercalls to talk to G1, and G1 might
be using MMIO to talk to H.  I don't think it matters from a topology
perspective (though it might from a performance perspective).

> With mmio, G1 would have set up G2's page tables to point directly at
> the addresses set up by H, so we would actually have a direct G2->H
> path.  Of course we'd need an emulated iommu so all the memory
> references actually resolve to G2's context.

/me head explodes

>
> So the upshoot is that hypercalls for devices must not be the primary
> method of communications; they're fine as an optimization, but we
> should always be able to fall back on something else.  We also need to
> figure out how G1 can stop V1 from advertising hypercall support.
I agree it would be desirable to be able to control this exposure.=20
However, I am not currently convinced its strictly necessary because of
the reason you mentioned above.  And also note that I am not currently
convinced its even possible to control it.

For instance, what if G1 is an old KVM, or (dare I say) a completely
different hypervisor?  You could control things like whether G1 can see
the VMX/SVM option at a coarse level, but once you expose VMX/SVM, who
is to say what G1 will expose to G2?  G1 may very well advertise a HC
feature bit to G2 which may allow G2 to try to make a VMCALL.  How do
you stop that?

-Greg



--------------enig6B92333EF09FAE6F72FD30C4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoETbUACgkQlOSOBdgZUxmiAgCdH1ijKlEChW1AW4+qGrFhuxvn
wqIAni7n3hGs0s9nPPdB4F9u68+WoShp
=kTw2
-----END PGP SIGNATURE-----

--------------enig6B92333EF09FAE6F72FD30C4--
