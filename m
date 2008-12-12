Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYLMC6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYLMC6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 21:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbYLMC55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 21:57:57 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:57856 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbYLMC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 21:57:56 -0500
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
From: Scott James Remnant <scott@netsplit.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
References: <493EA441.1070706@redhat.com>
	 <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cQFE/AFXgFrdet9NvwN/"
Date: Fri, 12 Dec 2008 15:28:11 -0800
Message-Id: <1229124491.12618.5.camel@warcraft>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cQFE/AFXgFrdet9NvwN/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 11:41 -0800, Davide Libenzi wrote:

> On Tue, 9 Dec 2008, Casey Dahlin wrote:
>=20
> > Linux already has signalfd, timerfd, and eventfd to expose signals, tim=
ers,
> > and events via a file descriptor. This patch is a working prototype for=
 a
> > fourth: waitfd. It pretty much does what the name suggests: reading fro=
m it
> > yields a series of status ints (as would be written into the second arg=
ument
> > of waitpid) for child processes that have changed state. It takes essen=
tially
> > the same arguments as waitpid (for now) and supports the same set of fe=
atures.
> >=20
> What's wrong in having a signalfd on SIGCHLD, than doing waitpid() once=20
> you get the signal?
>=20
Because SIGCHLD isn't a POSIX realtime signal, only one copy of it will
be queued at any one time -- even with signalfd(), and even though they
have different (useful) siginfo_t.

So if you have three children die in rapid succession, you only get the
siginfo for the first one.  Thus you still have to call
waitid()/waitpid() in a loop, and wait on everything.

Could the fact that you don't get signalfd notification of the
additional signals be considered a bug?  Or possibly a useful additional
feature?

If we were able to read all the queued SIGCHLD signals with signalfd
(preserving the one pending only behaviour of ordinary delivery), then a
loop like the following would be possible:

  sigemptyset (&mask);
  sigaddset (&mask, SIGCHLD);

  sfd =3D signalfd (-1, &mask, 0);

  for (;;) {
    read (sfd, &fdsi, sizeof (struct signalfd_siginfo));

    waitpid (fdsi.ssi_pid, 0, 0);
  }

So you only need to wait for each one individually.

Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-cQFE/AFXgFrdet9NvwN/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklC84YACgkQIexP3IStZ2xI4wCdElldbsEFviVrM7hVgZhZRil/
BkwAnjB16bgIDCPAULAlfIkq37Dh1/3v
=F4E6
-----END PGP SIGNATURE-----

--=-cQFE/AFXgFrdet9NvwN/--

