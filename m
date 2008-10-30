Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJ3Kgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJ3Kgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 06:36:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752807AbYJ3Kgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 06:36:44 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48857 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbYJ3Kgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 06:36:44 -0400
Subject: Re: [PATCH 1/2] lockdep: implement full check without irq checking
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1225293796.9315.4.camel@lappy.programming.kicks-ass.net>
References: <1224790541.6002.53.camel@johannes.berg>
	 <1224791072.6002.63.camel@johannes.berg>
	 <1225293796.9315.4.camel@lappy.programming.kicks-ass.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ndIDpRqgSFFzywf/9D5w"
Date: Thu, 30 Oct 2008 11:36:35 +0100
Message-Id: <1225362995.3690.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ndIDpRqgSFFzywf/9D5w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-29 at 16:23 +0100, Peter Zijlstra wrote:

> This thing worries me, can you help my exhausted brain a long a little..
>=20
> So I take it the idea is to couple the lock chains of the site calling
> del_timer_sync and the actual timer.
>=20
> We do this by holding a fake lock while executing the timer, so that its
> lock chain starts with that lock.
>=20
> We then acquire the fake lock on del_timer_sync so as to establish a
> relation.

Right. Same way as the workqueue code. Mind you, I'm not sure this is
even worth it, in running it I haven't found a bug and I because timer
code may not sleep you can only take spinlocks in them, and I suspect
that it's unlikely somebody will try to cancel_sync a timer under a
spinlock, though it is of course possible.

> Now you get warnings about using a lock in hardirq context that was
> previously used !irq-safe, right?
>=20
> So why not simply write something like:
>=20
>=20
> del_timer_sync():
>=20
>   local_irq_save(flags);
>   lock_aquire(my fake timer lock);
>   lock_release(...);
>   local_irq_restore(flags);
>=20
> and make that conditional CONFIG_PROVE_LOCKING and or wrap it up
> somewhere..

Yeah, that is possible, but it seemed to me that would affect the
performance of del_timer_sync() quite a bit. Not sure it matters. And on
powerpc (which I care about) it won't actually affect performance much
because we lazily disable IRQs, but still. The >=3D 2 change also seemed
to generate smaller code?

johannes

--=-ndIDpRqgSFFzywf/9D5w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCY4vAAoJEKVg1VMiehFYmuYP/RM2SKJa24dMSQhjMQG77p06
lujYuaHJbOhLMBePOknVFz2YecqAurpL/HgrK38i/qgnkxIisensbWU4RMpEBkNy
JWxV7ulALV8kPIbj1/2ibmROBXyJ5AIC+Z3BeIpNbgLUWY/MA1fMwhj9E53yxzP2
nNOSqDdUPUW/07Ii+R0bsWdA+D6l8X5X73JPKMJ1kP9Cao5MafFodNew1XJ5DOS7
+LOZEuwBJ5NVTPEoh+7MSkoWVPJHdgcVl0doMrDmHvE5q5RBr8j9Tu8e/rkrf5jK
c/bIUMBTEnEfh0xvLeT93JbTA4o0eElZT/SBhKTmRWyJy3USRuh9mrjiWH1kAG1O
8gS0qC6oXXDBbURB5yQVDt2PlrPOFJo/viX4gMwioLfFIQ22u8QuYUyZSZL8e6db
WN4cGho02RekvKpMoQvJklrRdbzHkMC0zujCSSb7EZZvBusPhSO0c6av9e8na4gJ
nM8LGm5KmGV+tQBtF4gs909CVOE2KU+OrrpSYp9cmtmB9rdDTJ22CiERLcIbZUdx
DTtDi/mdJ0V2MvcNnXljyfwZcvPW+fU2yZeesBMoi7Q/RFgdLI0JIzWI5IHdHOmU
gpFSDvsKmDzcEeSN40cxALAXzg9jZZHxBEHwCW/SPDsSkai0o76UIP/JpH0GJEi5
e/g2BIEPy9ThTLnhOGC3
=3Jm2
-----END PGP SIGNATURE-----

--=-ndIDpRqgSFFzywf/9D5w--

