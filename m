Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbYHDUQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbYHDUQT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbYHDUPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:15:21 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:51228
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058AbYHDUPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:15:20 -0400
Date: Mon, 4 Aug 2008 22:15:14 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Dave Jones <davej@redhat.com>, Roland Dreier <rdreier@cisco.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, jeremy@goop.org, hugh@veritas.com,
       mingo@elte.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] workaround minor lockdep bug triggered by
	mm_take_all_locks
Message-ID: <20080804201514.GB12464@duo.random>
References: <aday73cua99.fsf@cisco.com> <1217860332.3589.11.camel@twins> <20080804145318.GA17867@redhat.com> <1217861763.3589.13.camel@twins> <20080804162657.GI11476@duo.random> <1217867935.3589.35.camel@twins> <20080804172728.GJ11476@duo.random> <20080804174659.GK11476@duo.random> <20080804175730.GL11476@duo.random> <1217875739.3589.56.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217875739.3589.56.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 08:48:59PM +0200, Peter Zijlstra wrote:
> On Mon, 2008-08-04 at 19:57 +0200, Andrea Arcangeli wrote:
> > From: Andrea Arcangeli <andrea@qumranet.com>
> > 
> > Lockdep can't recognize if spinlocks are at a different address. So
> > using trylock in a loop is one way to avoid lockdep to generate false
> > positives. After lockdep will be fixed this change can and should be
> > reverted.
> > 
> > Signed-off-by: Andrea Arcangeli <andrea@qumranet.com>
> 
> NAK, come-on, you didn't even bother to look at the available
> annotations..

Let's say when I hear prove-locking my instinct tells me to walk away
as fast as I can. I'll try to explain why I prefer the trylock loop
(which btw is the only one that will hide the lockdep false positives
here and I welcome you to fix it in another way, well another way that
comes to mind is to call __raw_spin_lock which I didn't do because I
don't like those lowlevel details in common code).

So about prove-locking:

1) in production is disabled so when I get bugreports I've to grab
   locking deadlock information as usual (sysrq+t/p or preferably
   lkcd/kdump)

2) while coding it's useless as well because I don't need this thing
   to debug and fix any deadlocks

3) this only finds bugs after the system is hung and I can fix it by
   other means then

Despite having used this for a while, it never happened to me that
this has been useful as single time, I only run into false positives
and systems grinding to an halt so not allowing debug kernels to run
which reduced even more the ability to debug the kernel. I'm not aware
of anybody else who was debugging that fixed bugs thanks to this
code. So in my experience this only has hurt me and I don't want it
ever enabled in anything I deal with.

If only this had a slight chance to find bugs that don't easily
trigger at runtime it'd be an entirely different matter.

To be clear: my criticism is only to prove-locking, for example I find
very useful that there are other things like spinlock debug options
that warns if you call GFP with GFP_KERNEL while you're in atomic
context (which unfortunately only works with preempt enabled for no
good reason because the atomic context is maintained by non-preempt
too but anyway). The spinlock sleep debug effectively find bugs that
would otherwise go unnoticed. Let's say I'm only interested in stuff
that shows bugs that would otherwise go unnoticed, everything else I
can debug it by myself without prove-locking printk in the logs.

So this can only help if you aren't capable of running and decoding
sysrq+p/t. And it can't help in production either because it has to be
disabled there (and production would be the only place where
explaining how to grab a sysrq+p/t is a problem, and normally it's
simpler to grab kdump/lkcd).

Furthermore I don't like to slowdown (up to grinding system to an halt
before these fixes, but still not so fast) for this so unnecessary
feature while debugging. This also explains why after checking that
the patch was ok when Andrew asked it, I disabled prove-locking pretty
quickly.

So perhaps I misunderstand how lockdep works, in which case you're
welcome to correct me, otherwise I'd really like to know if anybody
really felt some bug couldn't be fixed in equal time without it (and I
mean excluding production where obviously this is useless as it can't
be possibly enabled). Understanding what are the implications of the
deadlock is sure slower than comparing the disassembly of the
sysrq+p/t (which 99% of has to be done anyway because the report comes
from a production system, if the bug was reproducible it would have
been tripped before it hit production).

I see it as a didactical theoretical exercise, and I hope this
explains why I prefer the trylock loop any day compared to any more
complex prove-locking specific API polluting the common code.  And if
it was for me I'd remove prove-locking from the kernel the moment it
started to pollute the common code for zero debugging advantages.
