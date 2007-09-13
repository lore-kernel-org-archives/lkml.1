Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbXIMLfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbXIMLfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 07:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751379AbXIMLfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 07:35:24 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:16039 "EHLO
	viefep34-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751291AbXIMLfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 07:35:23 -0400
Subject: Re: [announce] CFS-devel, performance improvements
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Mike Galbraith <efault@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0709121405130.1817@scrub.home>
References: <20070911200459.GA6974@elte.hu>
	 <Pine.LNX.4.64.0709121405130.1817@scrub.home>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-0i8qvvwcp3GRjit+FS5O"
Date: Thu, 13 Sep 2007 13:35:20 +0200
Message-Id: <1189683320.21778.213.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-0i8qvvwcp3GRjit+FS5O
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-09-13 at 00:17 +0200, Roman Zippel wrote:

> The rest of the math is indeed different - it's simply missing. What is=20
> there is IMO not really adequate. I guess you will see the differences,=20
> once you test a bit more with different nice levels.

The rounding error we now still have is accumulative over the long time
but has no real effect. The only effect is that a nice level would be a
little different that it would have been had the division been perfect,
not dissimilar to having a small error in the divisor series to being
with. (note that in order to see this little fuzz you need amazingly
high context switch rates)

We've measured the effect with the strongest nice levels -20 and 19, a
normal loop against two yield loops (this generated 700.000 context
switches per second), and the effect is <1%. Not something worth fixing
IMHO (unless it comes for free).=20

At that high switching rates the overhead of scheduling itself and
caching causes more skew than this - the small error is totally swamped
by the time lost scheduling.

>  There's a good reason=20
> I put that much effort into maintaining a good, but still cheap average,=20
> it's needed for a good task placement.

While I agree that having this average is nice, your particular
implementation has the problem that it quickly overflows u64 at which
point it becomes a huge problem (a CPU hog could basically lock up your
box when that happens).

I solved the wrap around problem in cfs-devel, and from that base I
_could_ probably maintain the average without overflow problems, but
have yet to try.

>  There is of course more than one=20
> way to implement this, so you'll have good chances to simply reimplement=20
> it somewhat differently, but I'd be surprised if it would be something=20
> completely different.

Currently we have 2 approximations in place:

  (leftmost + rightmost) / 2

and

  leftmost + period/2   (where period should match the span of the tree)

neither are perfect but they seem to work quite well.

--=-0i8qvvwcp3GRjit+FS5O
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG6SB4XA2jU0ANEf4RAtNGAKCHMRHwo0nZAVF3QkQhx2IYvQ74IwCbBNb1
y9PyXzQp1J63G2HLtfGAu0s=
=uacJ
-----END PGP SIGNATURE-----

--=-0i8qvvwcp3GRjit+FS5O--

