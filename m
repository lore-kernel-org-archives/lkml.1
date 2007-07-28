Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXG1QRi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXG1QRi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:17:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbXG1QR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:17:29 -0400
Received: from piware.de ([213.9.79.162]:53798 "EHLO box79162.elkhouse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbXG1QR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:17:28 -0400
Date: Sat, 28 Jul 2007 18:17:25 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, wwoods@redhat.com,
       Ben Collins <ben.collins@ubuntu.com>
Subject: Re: [PATCH 2/3] core_pattern: allow passing of arguments to user
	mode helper when core_pattern is a pipe
Message-ID: <20070728161725.GA5836@piware.de>
References: <20070727200746.GC18946@hmsreliant.homelinux.net> <20070728092355.GA5808@piware.de> <20070728134627.GA10006@hmsreliant.homelinux.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20070728134627.GA10006@hmsreliant.homelinux.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

Neil Horman [2007-07-28  9:46 -0400]:
> > I just want to mention a potential problem with this: If you first
> > expand the macros (from pattern to corename) and then split
> > corename into an argv, then this breaks macro expansions
> > containing spaces.  This mostly affects the executable name, of
> > course.
> >=20
> I never intended for this core_pattern argument passing to be able
> to expand macros, other than the macros specified by the
> core_pattern code.  If you want it to do that, we can address that
> with a later patch.

No, I specifically mean the standard ones provided by
format_corename(), such as %p (pid), %s (signal), or %e (executable
name). I don't see a reason to provide additional functionality.

> > In fact we considered this macro approach when doing the original
> > patches in the Ubuntu kernel, but we eventually used environment
> > variables because they are much easier and more robust to
> > implement than doing a robust macro expansion (i. e. first split
> > core_pattern into an argv and then call the macro expansion for
> > each element).
> >=20
> I disagree. While it might be nice to be able to specify environment
> variables as command line arguments, it would be much easier to just
> let the core_pattern executable inherit the crashing processes
> environment.  we don't do that currently, but we easily could.  That
> way any information that the crashing process wants the dying
> process to know can be inherited and vetted easily by apport (or
> whatever the core_pattern points to).  I'll do a patch later for
> that if you don't like it.

I don't think that this will be necessary. After all, the crash
handler can read all the environment from /proc/<pid>/ (and that's
indeed what apport does to figure out relevant parts from the
environment like the locale).

It seems we misunderstood each other, I don't expect or want any new
functionality in core_pattern. AN example might make it more clear:

The original problem that we are trying to solve is the current
behaviour of core_pattern expansion with pipes:

  |/bin/crash --pid %p

would try to execute the program '/bin/crash --pid 1234' instead of
calling /bin/crash with ['--pid', '1234'] as argv, right? Your patch
achieves the latter by splitting the formatted core dump string into
an array (at spaces).

I pointed out that this leads to problems when macro values contain
spaces. This currently affects hostname (%h) (although this really
should not happen in practice) and executable name (%e) (rare, but at
least valid).  I. e. for an executable name "foo bar" your patch would
expand

  |/bin/crash %e

to ['/bin/crash', 'foo', 'bar'] instead of ['/bin/crash', 'foo bar'].

Of course this is a corner case, and personally I don't really care.
I strive to keep the assumptions about the interface at a minimum, so
right now Apport's only required input is the core dump itself (over
stdin); signal and pid can be read from the environment, and if not
present, they are read from the core dump.

I did not defend Ubuntu's usage of environment variables, on the
contrary. Using the standard macros is more explicit and elegant, and
I welcome that change. I just pointed out the reason why we chose the
environment variable approach initially.

I just wanted to mention this little problem for the sake of
correctness.

Thank you, and have a nice weekend!

Martin

--=20
Martin Pitt        http://www.piware.de
Ubuntu Developer   http://www.ubuntu.com
Debian Developer   http://www.debian.org

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGq2wVDecnbV4Fd/IRAnTWAKCnUmvnHJ9rLs4giGA7ftMolB4lqACeP5Y2
NXW60ZuLLgGcE87ar4Te74U=
=9APC
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
