Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbZDHOno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbZDHOno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 10:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZDHOnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 10:43:35 -0400
Received: from mx0.hoeg.nl ([87.251.61.211]:57843 "EHLO palm.hoeg.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752493AbZDHOne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 10:43:34 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Apr 2009 10:43:34 EDT
Date: Wed, 8 Apr 2009 16:36:31 +0200
From: Ed Schouten <ed@FreeBSD.org>
To: linux-kernel@vger.kernel.org
Subject: Inconsistency between PTY read() return values
Message-ID: <20090408143631.GH32098@hoeg.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="it/zdz3K1bH9Y8/E"
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--it/zdz3K1bH9Y8/E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Some time ago I noticed this small inconsistency between the return
values of read() calls on pseudo-terminal master devices while working
on the FreeBSD TTY code.

Consider the following example:

| #include <fcntl.h>
| #include <stdio.h>
| #include <stdlib.h>
| #include <unistd.h>
|=20
| int
| main(int argc, char *argv[])
| {
| 	int f1, f2;
| 	char buf[20];
| 	ssize_t r;
|=20
| 	f1 =3D posix_openpt(O_RDWR|O_NOCTTY);
| 	grantpt(f1);
| 	unlockpt(f1);
|=20
| 	f2 =3D open(ptsname(f1), O_RDWR);
| 	close(f2);
|=20
| 	r =3D read(f1, buf, sizeof buf);
| 	printf("%zd\n", r);
| 	if (r =3D=3D -1)
| 		perror("read");
|=20
| 	return (0);
| }

The code is very simple. It acquires a pseudo-terminal, opens the slave
device and closes it. After that it tries to perform a read() on the
pseudo-terminal master device. On at least Solaris 7 to 10, Mac OS X
10.5 and FreeBSD 6 to HEAD, this code just prints 0. On Linux
(at least 2.6.22-2.6.28) I see the following:

	-1
	read: Input/output error

I looked through the standards and it seems the POSIX onlinepubs don't
mention the behaviour of pseudo-terminal master file descriptors at all.
This means it would even be valid of we return 0x1337 or something.

But still, I think it's a little inconsistent. Most programmers would
expect pseudo-terminal master file descriptors to behave somewhat
similar to TTYs, even though they don't need to be. When you try to
perform a read() on the TTY after the master file descriptor gets
closed, you get an end-of-file. You only get an EIO when trying to write
to this descriptor.

Would it be hard to change the Linux TTY code to behave the same?

--=20
 Ed Schouten <ed@FreeBSD.org>

--it/zdz3K1bH9Y8/E
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (FreeBSD)

iEYEARECAAYFAknctm4ACgkQ52SDGA2eCwWQUACeMTft7z3y4FnW6h1b6Gfjd7z5
PX0Ani82jJvSFws6NijyzAqSPFBwc32D
=fR0x
-----END PGP SIGNATURE-----

--it/zdz3K1bH9Y8/E--
