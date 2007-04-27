Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbXD0AyN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbXD0AyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:54:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755289AbXD0AyN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:54:13 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287AbXD0AyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:54:12 -0400
Message-ID: <463149A8.6070408@redhat.com>
Date: Thu, 26 Apr 2007 17:54:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org>
In-Reply-To: <20070426162530.bc30a1bb.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8D10859D7858A541C5B086CC"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8D10859D7858A541C5B086CC
Content-Type: multipart/mixed;
 boundary="------------060008070902060509050208"

This is a multi-part message in MIME format.
--------------060008070902060509050208
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Does the spec say what the OS should do if (ts_nsec =3D> 1e9)?

Yes, return EINVAL.  We already do this.  It's just that now we have to
recognize two special values.


> OK, so there's no collision on ts_nsec if unnormalised timespecs are
> disallowed.

Indeed, that's the basis of using the special values.

I chose the values of the constants so that they are a) out of the way
of valid values and b) don't have to be adjusted for 32-bit compat code.


> But there's a potential collision on ts_sec?  Do we know what date that=

> corresponds to?

No, there is no collision.  The tv_sec value is relevant.  The
UTIME_OMIT and UTIME_NOW value refers to the atime/mtime respectively,
not just the tv_nsec field of either.  It makes no sense to just set
tv_sec, the tv_nsec value would be basically random.

In my patch I'm testing that tv_sec is zero in case any of the special
values is used in the corresponding tv_nsec field.  That's more than the
standard currently requires but I think it's better and I try to get the
standard proposal changed.  If this doesn't happen I'll make appropriate
changes at userlevel for the "strictly POSIX" mode.


> Do you have a testcase app which can be used by arch maintainers?

Attached here.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96

--------------060008070902060509050208
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
  if (syscall(280, AT_FDCWD, "ttt", t) !=3D 0)
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
  if (syscall(280, AT_FDCWD, "ttt", t) !=3D 0)
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
  if (syscall(280, AT_FDCWD, "ttt", t) !=3D 0)
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
  if (syscall(280, AT_FDCWD, "ttt", t) !=3D 0)
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

  if (status =3D=3D 0)
     puts ("all OK");

 out:
  close (fd);
  unlink ("ttt");

  return status;
}

--------------060008070902060509050208--

--------------enig8D10859D7858A541C5B086CC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMUmo2ijCOnn/RHQRAqOeAKC8oWi7agKswsW4ebX0PZ6kcUuTLgCaA8wY
8yEnSc3ObnDnD0N/3PsSX0s=
=vCnr
-----END PGP SIGNATURE-----

--------------enig8D10859D7858A541C5B086CC--
