Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXDUQO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXDUQO6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 12:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752573AbXDUQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 12:14:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:45068 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXDUQO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 12:14:57 -0400
Message-ID: <462A3871.3060104@suse.com>
Date: Sat, 21 Apr 2007 12:14:41 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, reiserfs-list@namesys.com,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Mason <chris.mason@oracle.com>,
       Nikita Danilov <nikita@clusterfs.com>
Subject: Re: [RFC][PATCH] reiserfs vs BKL
References: <1177170364.7316.17.camel@twins>
In-Reply-To: <1177170364.7316.17.camel@twins>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter Zijlstra wrote:
> Replace all the lock_kernel() instances with reiserfs_write_lock(sb),
> and make that use an actual per super-block mutex instead of
> lock_kernel().
> 
> This should make reiserfs safe from PREEMPT_BKL=n, since it seems to
> rely on being able to schedule. Also, it removes the dependency on the
> BKL, and thereby is not prone to cause prio inversion with remaining BKL
> users (notably tty).
> 
> Compile tested only, since I didn't dare boot it.

NACK.

Believe me, I would *love* to nuke the BKL from reiserfs, but a search
and replace of this nature is just wrong. reiserfs_write_lock() using
the BKL isn't an accident - it depends on its nesting properties. If you
did try to boot this kernel, you'd deadlock pretty quickly.

This one has been on my TODO list for a long time. Interestingly, I've
been doing reiserfs xattr development recently using 2.6.21-rc7-git2,
and I'm not seeing any of these messages.

# CONFIG_PREEMPT_NONE is not set
CONFIG_PREEMPT_VOLUNTARY=y
# CONFIG_PREEMPT is not set
# CONFIG_PREEMPT_BKL is not set

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGKjhxLPWxlyuTD7IRAgCkAJ95MUehySJUUjBzl1ldr7BxESmQQACgjnkw
73KpJaH2G725AMJeWD02Arg=
=PaIV
-----END PGP SIGNATURE-----
