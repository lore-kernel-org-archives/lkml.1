Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZAJOpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZAJOpZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZAJOpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:45:09 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:57298 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbZAJOpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:45:07 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Roland McGrath <roland@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Oleg Nesterov <oleg@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OFQSuZb3IEpd7OBqkb/b"
Date: Sat, 10 Jan 2009 14:45:14 +0000
Message-Id: <1231598714.11642.53.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OFQSuZb3IEpd7OBqkb/b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 12:53 -0800, Roland McGrath wrote:

> New syscall should have gone to linux-api, I think.
>=20
> Do we really need another one for this?  How about using signalfd plus
> setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead =
of
> SIGCHLD?  It's slightly more magical for the userland process to know to =
do
> that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> really have to add, maybe better.
>=20
This wouldn't help the init daemon case:

- the exit_signal is set on the child, not on the parent.

  While the init daemon could clone() every new process and set
  exit_signal, this would not be set for processes reparented to init.

  Even if we had a new syscall to change the exit_signal of a given
  process, *and* had the init reparent notification patch, this still
  wouldn't be sufficient; you'd have a race condition between the time
  you were notified of the reparent, and the time you set exit_signal,
  in which the child could die.

  Since exit_signal is always reset to SIGCHLD before reparenting, this
  could be done by resetting it to a different signal; but at this point
  we're getting into a rather twisty method full of traps.


- exit_signal is reset to SIGCHLD on exec().

  Pretty much a plan-killer ;) =20

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-OFQSuZb3IEpd7OBqkb/b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklotHoACgkQSnQiFMl4yK7UXACfV4z2MPhaOJF7+OFn6nJBsCaQ
4iUAn0As1c/Bu5S6lWoX5lA9EgDrtIto
=L5VN
-----END PGP SIGNATURE-----

--=-OFQSuZb3IEpd7OBqkb/b--

