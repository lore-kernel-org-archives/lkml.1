Return-Path: <linux-kernel-owner+w=401wt.eu-S1755087AbXD2I7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbXD2I7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 04:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbXD2I7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 04:59:40 -0400
Received: from holomorphy.com ([66.93.40.71]:34791 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755086AbXD2I7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 04:59:38 -0400
Date: Sun, 29 Apr 2007 01:58:58 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Ingo Molnar <mingo@elte.hu>, Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070429085858.GA31925@holomorphy.com>
References: <1177618164.14496.5.camel@localhost> <20070427115344.GA30706@elte.hu> <20070427115526.GA7699@elte.hu> <1177774551.21279.8.camel@localhost> <1177809512.9756.10.camel@localhost> <20070429053022.GB23638@1wt.eu> <20070429065900.GB32281@elte.hu> <20070429071627.GC23638@1wt.eu> <20070429075436.GZ31925@holomorphy.com> <20070429081317.GG23638@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429081317.GG23638@1wt.eu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:54:36AM -0700, William Lee Irwin III wrote:
>> Common code for rbtree-based priority queues can be factored out of
>> cfq, cfs, and hrtimers.

On Sun, Apr 29, 2007 at 10:13:17AM +0200, Willy Tarreau wrote:
> In my experience, rbtrees are painfully slow. Yesterday, I spent the
> day replacing them in haproxy with other trees I developped a few
> years ago, which look like radix trees. They are about 2-3 times as
> fast to insert 64-bit data, and you walk through them in O(1). I have
> many changes to apply to them before they could be used in kernel, but
> at least I think we already have code available for other types of trees.

Dynamic allocation of auxiliary indexing structures is problematic for
the scheduler, which significantly constrains the algorithms one may
use for this purpose.

rbtrees are not my favorite either. Faster alternatives to rbtrees
exist even among binary trees; for instance, it's not so difficult to
implement a heap-ordered tree maintaining the red-black invariant with
looser constraints on the tree structure and hence less rebalancing.
One could always try implementing a van Emde Boas queue, if he felt
particularly brave.

Some explanation of the structure may be found at:
http://courses.csail.mit.edu/6.897/spring03/scribe_notes/L1/lecture1.pdf

According to that, y-trees use less space, and exponential trees are
asymptotically faster with a worst-case asymptotic running time of

	O(min(lg(lg(u))*lg(lg(n))/lg(lg(lg(u))), sqrt(lg(n)/lg(lg(n)))))

for all operations, so van Emde Boas is not the ultimate algorithm by
any means at O(lg(lg(u))); in these estimates, u is the size of the
"universe," or otherwise the range of the key data type. Not to say
that any of those are appropriate for the kernel; it's rather likely
we'll have to settle for something less interesting, if we bother
ditching rbtrees at all, on account of the constraints of the kernel
environment.

I'll see what I can do about a userspace test harness for priority
queues more comprehensive than smart-queue.c. I have in mind the
ability to replay traces obtained from queues in the kernel and loading
priority queue implementations via dlopen()/dlsym() et al. valgrind can
do most of the dirty work. Otherwise running a trace for some period of
time and emitting the number of operations it got through should serve
as a benchmark. With that in hand, people can grind out priority queue
implementations and see how they compare on real operation sequences
logged from live kernels.


-- wli
