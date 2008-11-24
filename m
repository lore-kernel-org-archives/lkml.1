Return-Path: <linux-kernel-owner+w=401wt.eu-S1753330AbYKXMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbYKXMdV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 07:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYKXMcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:32:51 -0500
Received: from styx.suse.cz ([82.119.242.94]:41023 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752276AbYKXMcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:32:50 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Petr Tesarik <ptesarik@suse.cz>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Mayhar <fmayhar@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1227519208.7685.21951.camel@twins>
References: <1224694989.8431.23.camel@oberon>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>  <200811211942.43848.ptesarik@suse.cz>
	 <1227450296.7685.20759.camel@twins>
	 <1227516403.4487.20.camel@nathan.suse.cz>
	 <1227519208.7685.21951.camel@twins>
Content-Type: text/plain; charset=utf-8
Organization: SUSE LINUX
Date: Mon, 24 Nov 2008 13:32:48 +0100
Message-Id: <1227529968.4487.45.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra píše v Po 24. 11. 2008 v 10:33 +0100:
> On Mon, 2008-11-24 at 09:46 +0100, Petr Tesarik wrote:
> > Peter Zijlstra píše v Ne 23. 11. 2008 v 15:24 +0100:
> > >[...]
> > > The current (per-cpu) code is utterly broken on large machines too, I've
> > > asked SGI to run some tests on real numa machines (something multi-brick
> > > altix) and even moderately small machines with 256 cpus in them grind to
> > > a halt (or make progress at a snails pace) when the itimer stuff is
> > > enabled.
> > > 
> > > Furthermore, I really dislike the per-process-per-cpu memory cost, it
> > > bloats applications and makes the new per-cpu alloc work rather more
> > > difficult than it already is.
> > > 
> > > I basically think the whole process wide itimer stuff is broken by
> > > design, there is no way to make it work on reasonably large machines,
> > > the whole problem space just doesn't scale. You simply cannot maintain a
> > > global count without bouncing cachelines like mad, so you might as well
> > > accept it and do the process wide counter and bounce only a single line,
> > > instead of bouncing a line per-cpu.
> > 
> > Very true. Unfortunately per-process itimers are prescribed by the
> > Single Unix Specification, so we have to cope with them in some way,
> > while not permitting a non-privileged process a DoS attack. This is
> > going to be hard, and we'll probably have to twist the specification a
> > bit to still conform to its wording. :((
> 
> Feel like reading the actual spec and trying to come up with a creative
> interpretation? :-)

Yes, I've just spent a few hours doing that... And I feel very
depressed, as expected.

> > I really don't think it's a good idea to set a per-process ITIMER_PROF
> > to one timer tick on a large machine, but the kernel does allow any
> > process to do it, and then it can even cause hard freeze on some
> > hardware. This is _not_ acceptable.
> > 
> > What is worse, we can't just limit the granularity of itimers, because
> > threads can come into being _after_ the itimer was set.
> 
> Currently it has jiffy granularity, right? And jiffies are different
> depending on some compile time constant (HZ), so can't we, for the sake
> of per-process itimers, pretend to have a 1 minute jiffie?
> 
> That should be as compliant as we are now, and utterly useless for
> everybody, thereby discouraging its use, hmm? :-)
﻿
I've got a copy of IEEE Std 10003.1-2004 here, and it suggests that this
should be generally possible. In particular, the description for
itimer_set says:

Implementations may place limitations on the granularity of timer values. For
each interval timer, if the requested timer value requires a finer granularity
than the implementation supports, the actual timer value shall be rounded up
to the next supported value.

However, it seems to be vaguely linked to CLOCK_PROCESS_CPUTIME_ID,
which is defined as:

The identifier of the CPU-time clock associated with the process making a
clock ( ) or timer*( ) function call.

POSIX does not specify whether this clock is identical to the one used
for setitimer et al., or not, but it seems logical that it should. Then,
the kernel should probably return the coarse granularity in
clock_getres(), too.

I tried to find out how this is currently implemented in Linux, and it's
broken. How else. :-/

1. clock_getres() always returns a resolution of 1ns

This is actually good news, because it means that nobody really cares
whether the actual granularity is greater, so I guess we can safely
return any bogus number in clock_getres().

What about using an actual granularity of NR_CPUS*HZ, which should be
safe for any (at least remotely) sane usage?

2. clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts) returns -EINVAL

Should not happen. Looking further into it, I think this line in
cpu_clock_sample_group():

	switch (which_clock) {

should look like a similar line in cpu_clock_sample(), ie:

	switch (CPUCLOCK_WHICH(which_clock)) {

Shall I send a patch?

Petr Tesarik

