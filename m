Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYDDO3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYDDO3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 10:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbYDDO27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 10:28:59 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408AbYDDO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 10:28:58 -0400
Subject: cpu_clock confusion (was: printk time confusion?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Herrenschmidt <benh@ozlabs.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Arnd Bergmann <arndb@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <1207219724.10388.319.camel@pasglop>
References: <1207146186.3957.11.camel@johannes.berg>
	 <1207219724.10388.319.camel@pasglop>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cVHlm+Z9SnEgTxO7aMHo"
Date: Thu, 03 Apr 2008 18:34:10 +0200
Message-Id: <1207240450.3797.22.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cVHlm+Z9SnEgTxO7aMHo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> > Not sure whether the lockdep patches or something else is causing this
> > as I haven't checked w/o the patches yet, but I seem to be having some
> > confusion of printk timestamps:
>=20
> Tried reverting the patches ?

That didn't help, so it's not the lockdep patches causing it. I'm still
seeing printk timestamps like this:

[    2.764009 (3/3)]
[    4.272241 (2/2)]
[    4.272322 (2/2)]
[    4.272375 (2/2)]
[    2.948002 (3/3)]

As you can see, I added printk_cpu and smp_processor_id() to the printk
timestamp output and thus it is obvious that the different times come
from different CPUs.

I have to admit that I do not understand the cpu_clock() implementation,
but I can only point out that the bug seems to be there since our
sched_clock() uses the timebase which is certainly synchronized. For the
fun of it, here's another output, with get_tb() thrown in:

[   15.285317 (0/0,1734086151)]
[   13.563845 (3/3,1757040324)]
[   13.700157 (3/3,1773150788)]
[   15.181275 (1/1,1829646200)]
[   15.181343 (1/1,1829648488)]
[   16.987944 (0/0,1829664311)]
[   16.988485 (0/0,1829682407)]
[   12.047482 (2/2,1829690681)]

As expected, the timebase is perfectly fine, it's monotonously
increasing over all the processors, but cpu_clock() doesn't seem to
notice. Not sure what to make of it. It seems just using the timebase
(in form of sched_clock()) ought to be perfectly fine and even have less
overhead than all this cpu_clock() business.

johannes

--=-cVHlm+Z9SnEgTxO7aMHo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/UHAaVg1VMiehFYAQIooBAAxGLMxo2IcXhp3bKZ7whnCaaaRgnWvcIy
tyc1iRMiBuiw4+a5IZjRdJKr4IV642uqsb4duTCbpIrVzu7u+/J86ZiP9LvynsOi
2eN57nAL9KosPkGVXAcQiVkc3dq+IiYlbsSRFjx5Uvf+Jaguv3k5g783ge4PwgBH
6Z0z2HQRgJn9VSuaww2KrVzqlrpNkbfBuL0vfRgixrxlvVsiNMrh8XM1Ym0KBcBZ
fL9l9fQUDjTzJW7JnDJUCcUfBp/q4nl8Zs8wJtsCfbJhoao+XkzufomWiBl1vfAY
3AK1lUlpU2S67FUirfgddbxsX0GZqKCu3M4Aj5VrLwWgy/Q0rrCAq4AL05MFA2zf
lrwhPS2SdzfJrTr9xjNJVLDoiLiBC5kLImZTJ4vpMxKLDyghfvJWwao3hgd9vPrj
2w00wG9aFjS8W3gOJTzIIEJVafgr8ClG7F+GymD2QYtrY592Fwa7DRVg33aw7gj4
eoLWG+h5IRd5PWa9LxsxK09xi4ifNXr7FMl7qSyZnRLFJWR3YsBaamHJGxyfpAlI
b2UttnmADvmDqxWOhbXpGVAHugMcbMokre0n5itR9Sm0e+4P2ETrDkOzoZjzeUFe
vL0RHxNvVuJly1tIbVnhS98RnUoEofEfe06ngYAkkBYpvVyEWPlVjBPWiSCUxZUs
Mmw8ItahqBQ=
=A38F
-----END PGP SIGNATURE-----

--=-cVHlm+Z9SnEgTxO7aMHo--

