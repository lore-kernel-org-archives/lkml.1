Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXDCQy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXDCQy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 12:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965451AbXDCQy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 12:54:59 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965461AbXDCQy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 12:54:58 -0400
Message-ID: <461286D6.2040407@redhat.com>
Date: Tue, 03 Apr 2007 09:54:46 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: getting processor numbers
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCAF320E6E9326440F4A93997"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCAF320E6E9326440F4A93997
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

More and more code depends on knowing the number of processors in the
system to efficiently scale the code.  E.g., in OpenMP it is used by
default to determine how many threads to create.  Creating more threads
than there are processors/cores doesn't make sense.

glibc for a long time provides functionality to retrieve the number
through sysconf() and this is what fortunately most programs use.  The
problem is that we are currently using /proc/cpuinfo since this is all
there was available at that time.  Creating /proc/cpuinfo takes the
kernel quite a long time, unfortunately (I think Jakub said it is mainly
the interrupt information).

The alternative today is to use /sys/devices/system/cpu and count the
number of cpu* directories in it.  This is somewhat faster.  But there
would be another possibility: simply stat /sys/devices/system/cpu and
use st_nlink - 2.

This last step unfortunately it made impossible by recent changes:

  http://article.gmane.org/gmane.linux.kernel/413178

I would like to propose changing that patch, move the sched_*
pseudo-files in some other directly and permanently ban putting any new
file into /sys/devices/system/cpu.

To get some numbers, you can try

  http://people.redhat.com/drepper/nproc-timing.c

The numbers I see on x86-64:

cpuinfo 10145810 cycles for 100 accesses
readdir /sys 3113870 cycles for 100 accesses
stat /sys 741070 cycles for 100 accesses

Note that for the first two methods I skipped the actual parsing part.
This means in the real solution the gap between those two and the simple
stat() call is even bigger.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCAF320E6E9326440F4A93997
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEobW2ijCOnn/RHQRAjsPAKCbjZ2MUL/6SEC9SVCKws+tOYleMgCePJ7Q
c6PS6BNiyN/uGb7Qz1eNp0c=
=Byy/
-----END PGP SIGNATURE-----

--------------enigCAF320E6E9326440F4A93997--
