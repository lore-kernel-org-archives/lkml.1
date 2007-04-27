Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbXD0P1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbXD0P1Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:27:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755993AbXD0P1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:27:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbXD0P1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:27:14 -0400
Message-ID: <46321648.6090705@redhat.com>
Date: Fri, 27 Apr 2007 08:27:04 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Updated utimensat test program
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <463149A8.6070408@redhat.com>
In-Reply-To: <463149A8.6070408@redhat.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3CF96407ED7546EFA0522E4E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3CF96407ED7546EFA0522E4E
Content-Type: multipart/mixed;
 boundary="------------000207090607020901050700"

This is a multi-part message in MIME format.
--------------000207090607020901050700
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This is the updated test program for the utimensat syscall.  Cleaned up
a bit and extended to cover the lutimesat functionality.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96

--------------000207090607020901050700
Content-Type: text/x-csrc;
 name="utimensat-test.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="utimensat-test.c"

#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include <sys/time.h>
#include <stddef.h>
#include <syscall.h>

#define __NR_utimensat 280

#define UTIME_NOW       ((1l << 30) - 1l)
#define UTIME_OMIT      ((1l << 30) - 2l)


int
main(void)
{
  int status =3D 0;

  int fd =3D open("ttt", O_RDWR|O_CREAT|O_EXCL, 0666);
  if (fd =3D=3D -1)
    error (1, errno, "failed to create test file \"ttt\"");

  struct stat64 st1;
  if (fstat64 (fd, &st1) !=3D 0)
    error (1, errno, "fstat failed");

  struct timespec t[2];
  t[0].tv_sec =3D 0;
  t[0].tv_nsec =3D 0;
  t[1].tv_sec =3D 0;
  t[1].tv_nsec =3D 0;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) !=3D 0)
    error (1, errno, "utimensat failed");

  struct stat64 st2;
  if (fstat64 (fd, &st2) !=3D 0)
    error (1, errno, "fstat failed");
 =20
  if (st2.st_atim.tv_sec !=3D 0 || st2.st_atim.tv_nsec !=3D 0)
    {
      puts ("atim not reset to zero");
      status =3D 1;
    }
  if (st2.st_mtim.tv_sec !=3D 0 || st2.st_mtim.tv_nsec !=3D 0)
    {
      puts ("mtim not reset to zero");
      status =3D 1;
    }
  if (status !=3D 0)
    goto out;

  t[0] =3D st1.st_atim;
  t[1].tv_sec =3D 0;
  t[1].tv_nsec =3D UTIME_OMIT;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) !=3D 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) !=3D 0)
    error (1, errno, "fstat failed");
 =20
  if (st2.st_atim.tv_sec !=3D st1.st_atim.tv_sec
      || st2.st_atim.tv_nsec !=3D st1.st_atim.tv_nsec)
    {
      puts ("atim not set");
      status =3D 1;
    }
  if (st2.st_mtim.tv_sec !=3D 0 || st2.st_mtim.tv_nsec !=3D 0)
    {
      puts ("mtim changed from zero");
      status =3D 1;
    }
  if (status !=3D 0)
    goto out;

  t[0].tv_sec =3D 0;
  t[0].tv_nsec =3D UTIME_OMIT;
  t[1] =3D st1.st_mtim;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) !=3D 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) !=3D 0)
    error (1, errno, "fstat failed");
 =20
  if (st2.st_atim.tv_sec !=3D st1.st_atim.tv_sec
      || st2.st_atim.tv_nsec !=3D st1.st_atim.tv_nsec)
    {
      puts ("mtim changed from original time");
      status =3D 1;
    }
  if (st2.st_mtim.tv_sec !=3D st1.st_mtim.tv_sec
      || st2.st_mtim.tv_nsec !=3D st1.st_mtim.tv_nsec)
    {
      puts ("mtim not set");
      status =3D 1;
    }
  if (status !=3D 0)
    goto out;

  sleep (2);

  t[0].tv_sec =3D 0;
  t[0].tv_nsec =3D UTIME_NOW;
  t[1].tv_sec =3D 0;
  t[1].tv_nsec =3D UTIME_NOW;
  if (syscall(__NR_utimensat, AT_FDCWD, "ttt", t, 0) !=3D 0)
    error (1, errno, "utimensat failed");

  if (fstat64 (fd, &st2) !=3D 0)
    error (1, errno, "fstat failed");

  struct timeval tv;
  gettimeofday(&tv,NULL);

  if (st2.st_atim.tv_sec <=3D st1.st_atim.tv_sec
      || st2.st_atim.tv_sec > tv.tv_sec)
    {
      puts ("atim not set to NOW");
      status =3D 1;
    }
  if (st2.st_mtim.tv_sec <=3D st1.st_mtim.tv_sec
      || st2.st_mtim.tv_sec > tv.tv_sec)
    {
      puts ("mtim not set to NOW");
      status =3D 1;
    }

  if (symlink ("ttt", "tttsym") !=3D 0)
    error (1, errno, "cannot create symlink");

  t[0].tv_sec =3D 0;
  t[0].tv_nsec =3D 0;
  t[1].tv_sec =3D 0;
  t[1].tv_nsec =3D 0;
  if (syscall(__NR_utimensat, AT_FDCWD, "tttsym", t, AT_SYMLINK_NOFOLLOW)=
 !=3D 0)
    error (1, errno, "utimensat failed");

  if (lstat64 ("tttsym", &st2) !=3D 0)
    error (1, errno, "lstat failed");

  if (st2.st_atim.tv_sec !=3D 0 || st2.st_atim.tv_nsec !=3D 0)
    {
      puts ("symlink atim not reset to zero");
      status =3D 1;
    }
  if (st2.st_mtim.tv_sec !=3D 0 || st2.st_mtim.tv_nsec !=3D 0)
    {
      puts ("symlink mtim not reset to zero");
      status =3D 1;
    }

  if (status =3D=3D 0)
     puts ("all OK");

 out:
  close (fd);
  unlink ("ttt");
  unlink ("tttsym");

  return status;
}

--------------000207090607020901050700--

--------------enig3CF96407ED7546EFA0522E4E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMhZI2ijCOnn/RHQRAtnrAJ0e2x3bD0riL2A9DtypWdJ/wsMyHACgwXqn
t7Amf0i4Zb2qy9I2kD3Bvho=
=ORp0
-----END PGP SIGNATURE-----

--------------enig3CF96407ED7546EFA0522E4E--
