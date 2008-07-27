Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYG0CX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYG0CX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 22:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbYG0CXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 22:23:21 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:36904 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbYG0CXV (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 22:23:21 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-mmotm-0724 - linux-next.git loses /proc/sys/fs/quota, breaks disk quotas
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1217125366_3032P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 26 Jul 2008 22:22:46 -0400
Message-ID: <14615.1217125366@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1217125366_3032P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <14588.1217125342.1@turing-police.cc.vt.edu>

I bisected the problem to somewhere in here:

repeatable-slab-corruption-with-ltp-msgctl08.patch GOOD
#
linux-next.patch
linux-next-git-rejects.patch
linux-next-fixup.patch BAD

I have no idea how to go bisecting through linux-next.patch

It works in 26-mmotm-0715, but is broken in -0724, so that will hopefully
narrow the suspect commits down a *little* bit...

The problem is that the userspace does this:

        /* Detect new kernel interface; Assume generic interface unless we can p
rove there is not one... */
        if (!stat("/proc/sys/fs/quota", &st) || errno != ENOENT) {
                kernel_iface = IFACE_GENERIC;
                kernel_formats |= (1 << QF_VFSOLD) | (1 << QF_VFSV0);
        }
        else {
                struct v2_dqstats v2_stats;

and /proc/sys/fs/quota has mysteriously vanished in -0724. As a result,
the userspace code goes looking for the quotav1 files and doesn't find them,
since the actual files on disk are quotav2 (with a different name).

fs/dquot.c, which contains the code for that, appears to be identical in -0715
and -0724, so something *else* is breaking it.

Anybody know where /proc/sys/fs/quota went?

--==_Exmh_1217125366_3032P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFIi9v2cC3lWbTT17ARAnUHAKDovOBddsgE1iG2ZERkP+xbn4rzLgCXTLtq
wo5qWv83MGXnQiZB79FV+Q==
=bxsr
-----END PGP SIGNATURE-----

--==_Exmh_1217125366_3032P--
