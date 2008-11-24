Return-Path: <linux-kernel-owner+w=401wt.eu-S1752772AbYKXJdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbYKXJdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbYKXJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:33:42 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48448 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbYKXJdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:33:41 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Frank Mayhar <fmayhar@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1227516403.4487.20.camel@nathan.suse.cz>
References: <1224694989.8431.23.camel@oberon>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>  <200811211942.43848.ptesarik@suse.cz>
	 <1227450296.7685.20759.camel@twins>
	 <1227516403.4487.20.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Nov 2008 10:33:28 +0100
Message-Id: <1227519208.7685.21951.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 09:46 +0100, Petr Tesarik wrote:
> Peter Zijlstra píše v Ne 23. 11. 2008 v 15:24 +0100:
> > On Fri, 2008-11-21 at 19:42 +0100, Petr Tesarik wrote:
> > 
> > > > > In any event, while this particular implementation may not be optimal,
> > > > > at least it's _right_.  Whatever happened to "make it right, then make
> > > > > it fast?"
> > > >
> > > > Well, I'm not thinking you did it right ;-)
> > > >
> > > > While I agree that the linear loop is sub-optimal, but it only really
> > > > becomes a problem when you have hundreds or thousands of threads in your
> > > > application, which I'll argue to be insane anyway.
> > > 
> > > This is just not true. I've seen a very real example of a lockup with a very 
> > > sane number of threads (one per CPU), but on a very large machine (1024 CPUs 
> > > IIRC). The application set per-process CPU profiling with an interval of 1 
> > > tick, which translates to 1024 timers firing off with each tick...
> > > 
> > > Well, yes, that was broken, too, but that's the way one quite popular FORTRAN 
> > > compiler works...
> > 
> > I'm not sure what side you're arguing...
> 
> In this particular case I'm arguing against both, it seems. The old
> behaviour is broken and the new one is not better. :(

OK, then we agree ;-)

> > The current (per-cpu) code is utterly broken on large machines too, I've
> > asked SGI to run some tests on real numa machines (something multi-brick
> > altix) and even moderately small machines with 256 cpus in them grind to
> > a halt (or make progress at a snails pace) when the itimer stuff is
> > enabled.
> > 
> > Furthermore, I really dislike the per-process-per-cpu memory cost, it
> > bloats applications and makes the new per-cpu alloc work rather more
> > difficult than it already is.
> > 
> > I basically think the whole process wide itimer stuff is broken by
> > design, there is no way to make it work on reasonably large machines,
> > the whole problem space just doesn't scale. You simply cannot maintain a
> > global count without bouncing cachelines like mad, so you might as well
> > accept it and do the process wide counter and bounce only a single line,
> > instead of bouncing a line per-cpu.
> 
> Very true. Unfortunately per-process itimers are prescribed by the
> Single Unix Specification, so we have to cope with them in some way,
> while not permitting a non-privileged process a DoS attack. This is
> going to be hard, and we'll probably have to twist the specification a
> bit to still conform to its wording. :((

Feel like reading the actual spec and trying to come up with a creative
interpretation? :-)

> I really don't think it's a good idea to set a per-process ITIMER_PROF
> to one timer tick on a large machine, but the kernel does allow any
> process to do it, and then it can even cause hard freeze on some
> hardware. This is _not_ acceptable.
> 
> What is worse, we can't just limit the granularity of itimers, because
> threads can come into being _after_ the itimer was set.

Currently it has jiffy granularity, right? And jiffies are different
depending on some compile time constant (HZ), so can't we, for the sake
of per-process itimers, pretend to have a 1 minute jiffie?

That should be as compliant as we are now, and utterly useless for
everybody, thereby discouraging its use, hmm? :-)
