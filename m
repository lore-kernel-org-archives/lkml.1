Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYEaEZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYEaEZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 00:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750914AbYEaEZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 00:25:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbYEaEZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 00:25:36 -0400
Message-ID: <4840D335.6040406@redhat.com>
Date: Fri, 30 May 2008 21:25:25 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301923020.3141@woody.linux-foundation.org> <4840C394.2080807@redhat.com> <alpine.LFD.1.10.0805302056170.3141@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0805302056170.3141@woody.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> I'm suggesting that there are better approaches than forcing yet another 
> new interface onto this thing. As mentioned, the kernel has had 32-bit 
> rwsemaphores for a long time. Yes, there is "extra information" outside 
> the 32-bit field, but I suspect you simply haven't looked hard enough at 
> just using the existing futex code.

I guess have to expect to expect to be insulted by you.  What else is
new?  I think it's safe to say that nobody has looked more deeply at the
implementation possibilities with futexes.  I don't know how many
different primitives I've written over the years.  If you think you can
do it better, well, that's then a challenge to you.  Come up with
something better.

  The rwlocks cannot be handled as efficiently with 32-bit futexes.

I stand by that.  Proof me wrong.  You don't have to write code, just
describe it.  But don't publish it if

- - the uncontended reader *unconditionally* uses more than one memory
  access (atomic of course)

- - the contended readers uses the one access above plus one or two
  compare-and-exchange depending on the rwlock preferring readers or
  writers.  The last compare-and-exchange has to be repeated for
  spurious wakeups which are highly unlikely since we only wake what
  is ready to use.

- - the uncontended writer needs more than one single compare-and-exchange
  plus one memory read plus one write (both not atomic)

- - the contended writer needs more than the above plus one additional
  compare-and-exchange for every time we delay in futex_wait (again,
  highly unlikely to have spurious wakeups)

- - the unlock operation needs more than one read plus either one
  (repeated) compare-and-exchange or another atomic operation plus one
  memory write for writer locks

- - you can handle timedlock variants which don't manage to get the lock
  efficiently without waking up anyone else

That's it.

And just to point out some more fun: in a highly contended case this is
a performance killer (MESI protocol states):

               core #1                           core #2

         instr     cache state               instr    cache state

         load      -> S

         store     -> M

                   -> S                       load    -> S

                                              store   -> M


I.e., of the cache line with the rwlock is in one core's cache and you
first load a value from that cache line just to modify it right after
that, you're paying a terrible price.


Have fun coming up with something which is as good or better.  But shall
we say there is a deadline?  Otherwise we'd wait too long.

- --
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhA0zUACgkQ2ijCOnn/RHRI2QCbBGCcjES6qMJYay1WRVLdSAAk
lHEAnA754SGDsjuzvCYg2ZBrEUIktxYV
=NYYc
-----END PGP SIGNATURE-----
