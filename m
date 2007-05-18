Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbXERXlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbXERXlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 19:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbXERXlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 19:41:07 -0400
Received: from mail-in-06.arcor-online.net ([151.189.21.46]:51344 "EHLO
	mail-in-06.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755094AbXERXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 19:41:04 -0400
In-Reply-To: <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
References: <200705181941.l4IJfOtf018049@fire-2.osdl.org> <20070518152935.b5a4b3bf.akpm@linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <57324fd6fd39b00a9eb1889343fa0330@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: malitzke@metronets.com, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [Bug 8501] udivdi3  absence with gcc-4.3.0 on kernels 2.6.20.11 & 2.6.22.-rc1
Date: Sat, 19 May 2007 01:39:43 +0200
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> gcc-4.3 appears to have cunningly converted this:
>
> static inline void timespec_add_ns(struct timespec *a, u64 ns)
> {
> 	ns += a->tv_nsec;
> 	while(unlikely(ns >= NSEC_PER_SEC)) {
> 		ns -= NSEC_PER_SEC;
> 		a->tv_sec++;
> 	}
> 	a->tv_nsec = ns;
> }
>
> into a divide-by-1000000000 operation, so it emits a call to udivdi3 
> and we
> don't link.

Exactly.  It obviously is a bug in the kernel that it depends
on certain compiler optimisations that it doesn't have direct
control over to happen or not.  OTOH, GCC's behaviour here is
probably a non-optimal code issue; it doesn't seem to take the
unlikely() into account when doing the loop transform.

> I expect that this optimisation will remain in gcc-4.3

If someone files a *useable* problem report it most likely
will be taken care of, actually.

> and we'll end up
> having major kernel releases which don't build on i386 with major gcc
> releases, which isn't altogether desirable.

Yeah, like 4.2.0 with powerpc.  Seems like no one tested it :-(

> I suspect we'll need to fix this
> fairly urgently, and to backport the fix into a number of kernel 
> releases.

If it is 4.3 only, you could instead try to work *with* the GCC
people.  It _is_ very fragile code of course, it wouldn't hurt
to replace it with something better.

> We use the above idiom in several places.  A suitable fix might be to 
> hunt
> down those various sites and then make them call a helper function 
> which
> does
>
> 	if (unlikely(ns >= NSEC_PER_SEC)) {
> 		do_div(...)
> 	}
>
> (Better would be to inline the comparison and to uninline the do_div(),
> if it's a 32-bit arch.  Doing all this in a backportable fashion may
> prove tricky)

Perhaps putting a compiler barrier in there would be enough -- like
an empty asm() that takes the loop variable as input.


Segher

