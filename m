Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZEHS4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZEHS4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 14:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbZEHSzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 14:55:52 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47365 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755577AbZEHSzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 14:55:51 -0400
Message-ID: <4A04802B.9000003@novell.com>
Date: Fri, 08 May 2009 14:55:39 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com> <4A046519.30604@redhat.com>
In-Reply-To: <4A046519.30604@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31B9C578B73E91F1382D18C2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31B9C578B73E91F1382D18C2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>> Consider nested virtualization where the host (H) runs a guest (G1)
>>> which is itself a hypervisor, running a guest (G2).  The host exposes=

>>> a set of virtio (V1..Vn) devices for guest G1.  Guest G1, rather than=

>>> creating a new virtio devices and bridging it to one of V1..Vn,
>>> assigns virtio device V1 to guest G2, and prays.
>>>
>>> Now guest G2 issues a hypercall.  Host H traps the hypercall, sees it=

>>> originated in G1 while in guest mode, so it injects it into G1.  G1
>>> examines the parameters but can't make any sense of them, so it
>>> returns an error to G2.
>>>
>>> If this were done using mmio or pio, it would have just worked.  With=

>>> pio, H would have reflected the pio into G1, G1 would have done the
>>> conversion from G2's port number into G1's port number and reissued
>>> the pio, finally trapped by H and used to issue the I/O.    =20
>>
>> I might be missing something, but I am not seeing the difference
>> here. We have an "address" (in this case the HC-id) and a context (in
>> this
>> case G1 running in non-root mode).   Whether the  trap to H is a HC or=
 a
>> PIO, the context tells us that it needs to re-inject the same trap to =
G1
>> for proper handling.  So the "address" is re-injected from H to G1 as =
an
>> emulated trap to G1s root-mode, and we continue (just like the PIO).
>>  =20
>
> So far, so good (though in fact mmio can short-circuit G2->H directly).=


Yeah, that is a nice trick.  Despite the fact that MMIOs have about 50%
degradation over an equivalent PIO/HC trap, you would be hard-pressed to
make that up again with all the nested reinjection going on on the
PIO/HC side of the coin.  I think MMIO would be a fairly easy win with
one level of nesting, and absolutely trounce anything that happens to be
deeper.

>
>> And likewise, in both cases, G1 would (should?) know what to do with
>> that "address" as it relates to G2, just as it would need to know what=

>> the PIO address is for.  Typically this would result in some kind of
>> translation of that "address", but I suppose even this is completely
>> arbitrary and only G1 knows for sure.  E.g. it might translate from
>> hypercall vector X to Y similar to your PIO example, it might complete=
ly
>> change transports, or it might terminate locally (e.g. emulated device=

>> in G1).   IOW: G2 might be using hypercalls to talk to G1, and G1 migh=
t
>> be using MMIO to talk to H.  I don't think it matters from a topology
>> perspective (though it might from a performance perspective).
>>  =20
>
> How can you translate a hypercall?  G1's and H's hypercall mechanisms
> can be completely different.

Well, what I mean is that the hypercall ABI is specific to G2->G1, but
the path really looks like G2->(H)->G1 transparently since H gets all
the initial exits coming from G2.  But all H has to do is blindly
reinject the exit with all the same parameters (e.g. registers,
primarily) to the G1-root context.

So when the trap is injected to G1, G1 sees it as a normal HC-VMEXIT,
and does its thing according to the ABI.  Perhaps the ABI for that
particular HC-id is a PIOoHC, so it turns around and does a
ioread/iowrite PIO, trapping us back to H.

So this transform of the HC-id "X" to PIO("Y") is the translation I was
referring to.  It could really be anything, though (e.g. HC "X" to HC
"Z", if thats what G1s handler for X told it to do)

>
>
>
>>> So the upshoot is that hypercalls for devices must not be the primary=

>>> method of communications; they're fine as an optimization, but we
>>> should always be able to fall back on something else.  We also need t=
o
>>> figure out how G1 can stop V1 from advertising hypercall support.
>>>    =20
>> I agree it would be desirable to be able to control this exposure.
>> However, I am not currently convinced its strictly necessary because o=
f
>> the reason you mentioned above.  And also note that I am not currently=

>> convinced its even possible to control it.
>>
>> For instance, what if G1 is an old KVM, or (dare I say) a completely
>> different hypervisor?  You could control things like whether G1 can se=
e
>> the VMX/SVM option at a coarse level, but once you expose VMX/SVM, who=

>> is to say what G1 will expose to G2?  G1 may very well advertise a HC
>> feature bit to G2 which may allow G2 to try to make a VMCALL.  How do
>> you stop that?
>>  =20
>
> I don't see any way.
>
> If, instead of a hypercall we go through the pio hypercall route, then
> it all resolves itself.  G2 issues a pio hypercall, H bounces it to
> G1, G1 either issues a pio or a pio hypercall depending on what the H
> and G1 negotiated.

Actually I don't even think it matters what the HC payload is.  Its
governed by the ABI between G1 and G2. H will simply reflect the trap,
so the HC could be of any type, really.

>   Of course mmio is faster in this case since it traps directly.
>
> btw, what's the hypercall rate you're seeing? at 10K hypercalls/sec, a
> 0.4us difference will buy us 0.4% reduction in cpu load, so let's see
> what's the potential gain here.

Its more of an issue of execution latency (which translates to IO
latency, since "execution" is usually for the specific goal of doing
some IO).  In fact, per my own design claims, I try to avoid exits like
the plague and generally succeed at making very few of them. ;)

So its not really the .4% reduction of cpu use that allures me.  Its the
16% reduction in latency.  Time/discussion will tell if its worth the
trouble to use HC or just try to shave more off of PIO.  If we went that
route, I am concerned about falling back to MMIO, but Anthony seems to
think this is not a real issue.

=46rom what we've discussed here, it seems the best case scenario would b=
e
if the Intel/AMD folks came up with some really good hardware
accelerated MMIO-EXIT so we could avoid all the decode/walk crap in the
first place.  ;)

-Greg



--------------enig31B9C578B73E91F1382D18C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEgCsACgkQlOSOBdgZUxm3YACeIxwMgCuBdNYcNkf/Wm3P+dYr
wtQAnjzj1B0NsSWpjtTGOcBbtJhQ2UI1
=DhiM
-----END PGP SIGNATURE-----

--------------enig31B9C578B73E91F1382D18C2--
