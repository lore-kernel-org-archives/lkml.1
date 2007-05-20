Return-Path: <linux-kernel-owner+w=401wt.eu-S1759788AbXETSlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788AbXETSlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 14:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbXETSli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 14:41:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757786AbXETSlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 14:41:37 -0400
Message-ID: <465095E5.4050508@redhat.com>
Date: Sun, 20 May 2007 11:39:33 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: first little problem with private futexes
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Here's a first little issue with private futex I came across.  But a
real bug but a hole.

When we use clone() with CLONE_CHILD_CLEARTID possible waiters are woken
upon termination of the thread.  This operation uses FUTEX_WAKE so far.
 But it in almost all cases local memory and I would even be in favor of
setting this into stone.   It wouldn't break anything I know of.

The problem is we cannot just go over to using
FUTEX_WAIT|FUTEX_PRIVATE_FLAG since this would break binaries using any
glibc out there so far.

There are three ways out of this I can see:

1.  do nothing, always use the shared futexes.  Not very attractive IMO

2.  try private futexes first, then shared one.  This is even less
    attractive since in the many cases there is no waiter and we cannot
    determine whether the private futex notification succeeded and we're
    doing the expensive work as well

3.  tell the kernel whether we want the new or the old notification.
    This can be done using a number of ways

    a) using some prctl().  Another unconditional syscall, not nice.

    b) using a new CLONE_* flag.  We have currently 5 bits left and can
       recover two more (CLONE_DETACHED, CLONE_STOPPED).  And we can
       invent ways to add more bits.


I'm in favor of 3b but if somebody argues the costs are not justified
because the effects of using the shared futex notification isn't high
enough I can accept that, too.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGUJXl2ijCOnn/RHQRAvkOAJsEmm+TiWlWRJvT5nbk0lXrpvpTaQCgo/5j
FPWYxtgUIZwrdFk/K79dIi8=
=kbfx
-----END PGP SIGNATURE-----
