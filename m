Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbYEaEEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbYEaEEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYEaEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:04:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34205 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbYEaEEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:04:45 -0400
Message-ID: <4840CE51.9060109@redhat.com>
Date: Fri, 30 May 2008 21:04:33 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com> <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> The kernel calls reader-writer locks rwsemaphores.

Well, then you don't understand the complexity of the required interface
together with the performance implications.  Take your proposed allocation:

 - 29 bits of reader counts
 - 1 bit of uncontended writer
 - 1 bit of "contention" (ie a mark for requiring fairness)
 - 1 bit for a spinlock so that you can do all the fairness without
   doing any extra locked ops


Ask yourself this:

- - How do you know when there is no more writer waiting?  You cannot
  reset a "writer waiting" bit after you wake up one writer without
  waking every single thread waiting for the rwlock and letting them
  fight for it

- - How do you handle the difference between reader-preferred rwlocks
  and writer-preferred rwlocks?  In the latter, if a rwlock is locked
  for reading, future readers must be delayed until all writers are
  gone

- - How do you do the accounting for the *timedlock variants?  In the
  case of those a functions, if the threads wake due to a timeout,
  you have the decrement the waiter count.  But you have only one bit...


I don't say you cannot implement rwlocks this way.  Sure, it definitely
is possible.  But this implementation would in the contended case like
10x as slow as the current code because you constantly have to wake up
every single thread.

If you want, I'll give you a libpthread.so with the new code.  Then you
can test your code.  I bet you whatever you want that you cannot achieve
the performance with your puny 32-bit futex without limiting the number
of threads to a ridiculously low number.  The implementation I have
allows for 2^23 (possibly recursively locked) readers, 2^18 readers or
writers waiting.

When I was writing "you need more than 32 bits" I didn't even imagine
that somebody would suggest using such a primitive scheme which cannot
possibly work efficiently in a userlevel implementation.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhAzlEACgkQ2ijCOnn/RHQ+bgCcDDmhSvbKdboyqa21smzlSt75
zHUAn2rr3NKns4Kb78Woas3NP5hbwkOU
=p6z6
-----END PGP SIGNATURE-----
