Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXGWRXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXGWRXv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 13:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757984AbXGWRXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 13:23:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758746AbXGWRXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 13:23:43 -0400
Message-ID: <46A4E3F1.7050602@redhat.com>
Date: Mon, 23 Jul 2007 10:22:57 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: fallocate syscall interface defficiency
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The fallocate syscall returns ENOSYS in case the filesystem does not
support the operation and expects the userlevel code to fill in.  This
is good in concept.

The problem is that the libc code for old kernels should be able to
distinguish the case where the syscall is not at all available vs not
functioning for a specific mount point.  As is this is not possible and
we always have to invoke the syscall even if the kernel doesn't support it.

I suggest the following patch (and yes, Al, you need a mailer which
automatically removes "- " before leading dashes).  Using EOPNOTSUPP is
IMO the right thing to do.

- --- fs/open.c	2007-07-18 20:25:41.000000000 -0700
+++ fs/open.c-new	2007-07-23 10:17:17.000000000 -0700
@@ -403,7 +403,7 @@
 	if (inode->i_op && inode->i_op->fallocate)
 		ret = inode->i_op->fallocate(inode, mode, offset, len);
 	else
- -		ret = -ENOSYS;
+		ret = -EOPNOTSUPP;

 out_fput:
 	fput(file);


- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGpOPx2ijCOnn/RHQRAl4aAKC0TtQ65aBGhORbnniQg9lJwoWiQgCfT2B7
BGgDLLcTgGsd1I9HMRo/+z4=
=G5y6
-----END PGP SIGNATURE-----
