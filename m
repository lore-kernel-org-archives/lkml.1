Return-Path: <linux-kernel-owner+w=401wt.eu-S1763101AbXGPVTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763101AbXGPVTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758011AbXGPVTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 17:19:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45874 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756985AbXGPVTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 17:19:19 -0400
Date: Mon, 16 Jul 2007 23:18:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Roman Zippel <zippel@linux-m68k.org>, James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070716211851.GB18661@elte.hu>
References: <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <20070716121246.GA17880@elte.hu> <Pine.LNX.4.64.0707161427100.1817@scrub.home> <20070716134036.GA1533@elte.hu> <Pine.LNX.4.64.0707161548000.1817@scrub.home> <20070716203117.GC11166@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070716203117.GC11166@waste.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> More dynamic range is better? If you actually want a task to get 20x 
> the CPU time of another, the older scheduler doesn't really allow it.
> 
> Getting 1/69th of a modern CPU is still a fair number of cycles. 
> Nevermind 1/69th of a machine with > 64 cores.

yeah. furthermore, nice -20 is only admin-selectable.

Here are the current CPU-use values for positive nice levels:

 nice  0: 100.00%
 nice  1: 80.00%
 nice  2: 64.10%
 nice  3: 51.28%
 nice  4: 40.98%
 nice  5: 32.78%
 nice  6: 26.24%
 nice  7: 21.00%
 nice  8: 16.77%
 nice  9: 13.42%
 nice 10: 10.74%
 nice 11: 8.59%
 nice 12: 6.87%
 nice 13: 5.50%
 nice 14: 4.39%
 nice 15: 3.51%
 nice 16: 2.81%
 nice 17: 2.25%
 nice 18: 1.80%
 nice 19: 1.44%

here's the CPU utilization table for negative nice levels (relative to a 
nice -20 task):

 nice  0: 1.15%
 nice -1: 1.44%
 nice -2: 1.80%
 nice -3: 2.25%
 nice -4: 2.81%
 nice -5: 3.51%
 nice -6: 4.39%
 nice -7: 5.50%
 nice -8: 6.87%
 nice -9: 8.59%
 nice -10: 10.74%
 nice -11: 13.42%
 nice -12: 16.77%
 nice -13: 21.00%
 nice -14: 26.24%
 nice -15: 32.78%
 nice -16: 40.98%
 nice -17: 51.28%
 nice -18: 64.10%
 nice -19: 80.00%
 nice -20: 100.00%

these are pretty sane, and symmetric across the origo. Nice -20 is the 
odd one out, because there is no nice +20. But its value is still 
logical, it's the mirror image of an imaginery nice +20.

and note that even on the old scheduler, nice-0 was "3200% more 
powerful" than nice +19 (with CONFIG_HZ=300), and nice -19 was only 700% 
more powerful than nice-0. So not only was it inconsistent (and i can 
create scary numbers too ;), it gave the admin-controlled negative nice 
levels less of a punch than to user-controlled nice +19. A number of 
people complainted about that, and CFS addresses this.

in fact i like it that nice -20 has a slightly bigger punch than it used 
to have before: it might remove the need to run audio apps (and other 
multimedia apps) under SCHED_FIFO. (SCHED_FIFO is unprotected against 
lockups, while under CFS a nice 0 task is still starvation protected 
against a nice -20 task.)

furthermore, there is a quality of implementation issue as well, look at 
the definition of the nice system call:

   asmlinkage long sys_nice(int increment)

the "increment" is relative. So nice(1) has the same behavioral effect 
under CFS, regardless of which nice level you start out from. Under the 
old scheduler, the result depended on which nice level you started out 
from.

	Ingo
