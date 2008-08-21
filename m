Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbYHUM2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbYHUM2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:28:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYHUM21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:28:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:55406 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbYHUM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:28:26 -0400
Message-ID: <48AD5EE0.8070407@novell.com>
Date: Thu, 21 Aug 2008 08:26:08 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "D. Bahi" <dbahi@novell.com>
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
 load balancing
References: <1219310330.8651.93.camel@twins> <48AD534A.9080807@novell.com> <20080821114126.GB30667@elte.hu>
In-Reply-To: <20080821114126.GB30667@elte.hu>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig43CABFB192A22E95E7E195D3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig43CABFB192A22E95E7E195D3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> I haven't had a chance to review the code thoroughly yet, but I had=20
>> been working on a similar fix and know that this is sorely needed. =20
>> So...
>>    =20
>
> btw., why exactly does this patch speed up certain workloads? I'm not=20
> quite sure about the exact reasons of that.
>
> 	Ingo
>  =20

I used to have a great demo for the prototype I was working on, but id=20
have to dig it up.  The gist of it is that the pre-patched scheduler=20
basically gets thrown for a completely loop in the presence of a mixed=20
CFS/RT environment.  This isn't a PREEMPT_RT specific problem per se,=20
though PREEMPT_RT does bring the problem to the forefront since it has=20
so many active RT tasks by default (for the IRQs, etc) which make it=20
more evident.

Since an RT tasks previous usage of declaring "load" did not actually=20
express the true nature of the RQ load, CFS tasks would have a few=20
really nasty things happen to them while trying to run on the system=20
simultaneously.  One of them was that you could starve out CFS tasks=20
from certain cores (even though there was plenty of CPU bandwidth=20
available elsewhere) and the load-balancer would think everything is=20
fine and thus fail to make adjustments.

Say you have a 4 core system.  You could, for instance, get into a=20
situation where the softirq-net-rx thread was consuming 80% of core 0,=20
yet the load balancer would still spread, say, a 40 thread CFS load=20
evenly across all cores (approximately 10 per core, though you would=20
account for the "load" that the softirq thread contributed too).  The=20
threads on the other cores would of course enjoy 100% bandwidth, while=20
the ~10 threads on core 0 would only see 1/5th of that bandwidth.

What it comes down to is that the CFS load should have been evenly=20
distributed across the available bandwidth of 3*100% + 1*20%, not 4*100% =

as it does today.  The net result is that the application performs in a=20
very lopsided manner, with some threads getting significantly less (or=20
sometimes zero!) cpu time compared to their peers.  You can make this=20
more obvious by nice'ing the CFS load up as high as it will go, which=20
will approximate 1/2 of the load of the softirq (since RT tasks=20
previously enjoyed a 2*MAX_SCHED_OTHER_LOAD rating.

I have observed this phenomenon (and its fix) while looking at things=20
like network intensive workloads.  I'm sure there are plenty of others=20
that could cause similar ripples.

The fact is, the scheduler treats "load" to mean certain things which=20
simply did not apply to RT tasks.  As you know very well im sure ;),=20
"load" is a metric which expresses the share of the cpu that will be=20
consumed and this is used by the load balancer to make its decisions. =20
However, you can put whatever rating you want on an RT task and it would =

always be irrelevant.  RT tasks run as frequently and as long as they=20
want (w.r.t. SCHED_OTHER) independent of what their load rating implies=20
to the balancer, so you cannot make an accurate assessment of the true=20
"available shares".  This is why the load-balancer would become confused =

and fail to see true imbalance in a mixed environment.  Fixing this, as=20
Peter has attempted to do, will result in a much better distribution of=20
SCHED_OTHER tasks across the true available bandwidth, and thus improve=20
overall performance.

In previous discussions with people, I had always used a metaphor of a=20
stream.  A system running SCHED_OTHER tasks is like a smooth running=20
stream, but  dispatching an RT task (or an IRQ, even) is like throwing a =

boulder into the water.  It makes a big disruptive splash and causes=20
turbulent white water behind it.  And the stream has no influence over=20
the size of the boulder, its placement in the stream, nor how long it=20
will be staying.

This fix (at least in concept) allows it to become more like gently=20
slipping a streamlined aerodynamic object into the water.  The stream=20
still cannot do anything about the size or placement of the object, but=20
it can at least flow around it and smoothly adapt to the reduced volume=20
of water that the stream can carry. :)

HTH
-Greg


--------------enig43CABFB192A22E95E7E195D3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkitXuAACgkQlOSOBdgZUxmx/wCfQ98iNzwq94VxxVSwXyFXtanB
Z00AnjfHWBQXi1Ge48PgpIGcCovh9b3P
=JxzU
-----END PGP SIGNATURE-----

--------------enig43CABFB192A22E95E7E195D3--
