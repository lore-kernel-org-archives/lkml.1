Return-Path: <linux-kernel-owner+w=401wt.eu-S1757798AbZEHUAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798AbZEHUAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754689AbZEHUAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:00:00 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33517 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbZEHT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 15:59:59 -0400
Message-ID: <4A048F2E.3080702@novell.com>
Date: Fri, 08 May 2009 15:59:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Anthony Liguori <anthony@codemonkey.ws>,
       Chris Wright <chrisw@sous-sol.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] generic hypercall support
References: <20090505132005.19891.78436.stgit@dev.haskins.net> <4A0040C0.1080102@redhat.com> <4A0041BA.6060106@novell.com> <4A004676.4050604@redhat.com> <4A0049CD.3080003@gmail.com> <20090505231718.GT3036@sequoia.sous-sol.org> <4A010927.6020207@novell.com> <4A019717.7070806@codemonkey.ws> <4A01B4CF.3080706@novell.com> <4A03EA83.6040907@redhat.com> <4A044DB5.7050304@novell.com> <4A046519.30604@redhat.com> <4A04802B.9000003@novell.com> <4A048413.4060406@redhat.com>
In-Reply-To: <4A048413.4060406@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE6F03CAA1C17129970E61DA4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE6F03CAA1C17129970E61DA4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Gregory Haskins wrote:
>>>> And likewise, in both cases, G1 would (should?) know what to do with=

>>>> that "address" as it relates to G2, just as it would need to know wh=
at
>>>> the PIO address is for.  Typically this would result in some kind of=

>>>> translation of that "address", but I suppose even this is completely=

>>>> arbitrary and only G1 knows for sure.  E.g. it might translate from
>>>> hypercall vector X to Y similar to your PIO example, it might
>>>> completely
>>>> change transports, or it might terminate locally (e.g. emulated devi=
ce
>>>> in G1).   IOW: G2 might be using hypercalls to talk to G1, and G1
>>>> might
>>>> be using MMIO to talk to H.  I don't think it matters from a topolog=
y
>>>> perspective (though it might from a performance perspective).
>>>>        =20
>>> How can you translate a hypercall?  G1's and H's hypercall mechanisms=

>>> can be completely different.
>>>    =20
>>
>> Well, what I mean is that the hypercall ABI is specific to G2->G1, but=

>> the path really looks like G2->(H)->G1 transparently since H gets all
>> the initial exits coming from G2.  But all H has to do is blindly
>> reinject the exit with all the same parameters (e.g. registers,
>> primarily) to the G1-root context.
>>
>> So when the trap is injected to G1, G1 sees it as a normal HC-VMEXIT,
>> and does its thing according to the ABI.  Perhaps the ABI for that
>> particular HC-id is a PIOoHC, so it turns around and does a
>> ioread/iowrite PIO, trapping us back to H.
>>
>> So this transform of the HC-id "X" to PIO("Y") is the translation I wa=
s
>> referring to.  It could really be anything, though (e.g. HC "X" to HC
>> "Z", if thats what G1s handler for X told it to do)
>>  =20
>
> That only works if the device exposes a pio port, and the hypervisor
> exposes HC_PIO.  If the device exposes the hypercall, things break
> once you assign it.

Well, true.  But normally I would think you would resurface the device
from G1 to G2 anyway, so any relevant transform would also be reflected
in the resurfaced device config.  I suppose if you had a hard
requirement that, say, even the pci-config space was pass-through, this
would be a problem.  I am not sure if that is a realistic environment,
though.=20
>
>>>   Of course mmio is faster in this case since it traps directly.
>>>
>>> btw, what's the hypercall rate you're seeing? at 10K hypercalls/sec, =
a
>>> 0.4us difference will buy us 0.4% reduction in cpu load, so let's see=

>>> what's the potential gain here.
>>>    =20
>>
>> Its more of an issue of execution latency (which translates to IO
>> latency, since "execution" is usually for the specific goal of doing
>> some IO).  In fact, per my own design claims, I try to avoid exits lik=
e
>> the plague and generally succeed at making very few of them. ;)
>>
>> So its not really the .4% reduction of cpu use that allures me.  Its t=
he
>> 16% reduction in latency.  Time/discussion will tell if its worth the
>> trouble to use HC or just try to shave more off of PIO.  If we went th=
at
>> route, I am concerned about falling back to MMIO, but Anthony seems to=

>> think this is not a real issue.
>>  =20
>
> You need to use absolute numbers, not percentages off the smallest
> component.  If you want to reduce latency, keep things on the same
> core (IPIs, cache bounces are more expensive than the 200ns we're
> seeing here).
>
>
Ok, so there are no shortages of IO cards that can perform operations in
the order of 10us-15us.  Therefore a 350ns latency (the delta between
PIO and HC) turns into a 2%-3.5% overhead when compared to bare-metal.=20
I am not really at liberty to talk about most of the kinds of
applications that might care.  A trivial example might be PTPd clock
distribution.

But this is going nowhere.  Based on Anthony's asserting that the MMIO
fallback worry is unfounded, and all the controversy this is causing,
perhaps we should just move on and just forget the whole thing.  If I
have to I will patch the HC code in my own tree.  For now, I will submit
a few patches to clean up the locking on the io_bus.  That may help
narrow the gap without all this stuff, anyway.

-Greg




--------------enigE6F03CAA1C17129970E61DA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkoEjy4ACgkQlOSOBdgZUxl0JACfdOnehAxCHRWaShBvph4iOeI0
PKkAn3ENHZ9Xd1LAgi/B46jZOEyC6ZiL
=PRz9
-----END PGP SIGNATURE-----

--------------enigE6F03CAA1C17129970E61DA4--
