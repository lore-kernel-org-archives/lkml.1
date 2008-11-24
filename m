Return-Path: <linux-kernel-owner+w=401wt.eu-S1752969AbYKXNAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbYKXNAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 08:00:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbYKXM76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 07:59:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbYKXM76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 07:59:58 -0500
Subject: Re: regression introduced by - timers: fix itimer/many thread hang
From: Peter Zijlstra <peterz@infradead.org>
To: Petr Tesarik <ptesarik@suse.cz>
Cc: Frank Mayhar <fmayhar@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Doug Chapman <doug.chapman@hp.com>, mingo@elte.hu, roland@redhat.com,
       adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1227529968.4487.45.camel@nathan.suse.cz>
References: <1224694989.8431.23.camel@oberon>
	 <1226015568.2186.20.camel@bobble.smo.corp.google.com>
	 <1226053744.7803.5851.camel@twins>  <200811211942.43848.ptesarik@suse.cz>
	 <1227450296.7685.20759.camel@twins>
	 <1227516403.4487.20.camel@nathan.suse.cz>
	 <1227519208.7685.21951.camel@twins>
	 <1227529968.4487.45.camel@nathan.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Nov 2008 13:59:49 +0100
Message-Id: <1227531589.4259.117.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 13:32 +0100, Petr Tesarik wrote:

> > Feel like reading the actual spec and trying to come up with a creative
> > interpretation? :-)
> 
> Yes, I've just spent a few hours doing that... And I feel very
> depressed, as expected.

Thanks for doing that though!

> > > I really don't think it's a good idea to set a per-process ITIMER_PROF
> > > to one timer tick on a large machine, but the kernel does allow any
> > > process to do it, and then it can even cause hard freeze on some
> > > hardware. This is _not_ acceptable.
> > > 
> > > What is worse, we can't just limit the granularity of itimers, because
> > > threads can come into being _after_ the itimer was set.
> > 
> > Currently it has jiffy granularity, right? And jiffies are different
> > depending on some compile time constant (HZ), so can't we, for the sake
> > of per-process itimers, pretend to have a 1 minute jiffie?
> > 
> > That should be as compliant as we are now, and utterly useless for
> > everybody, thereby discouraging its use, hmm? :-)
> ﻿
> I've got a copy of IEEE Std 10003.1-2004 here, and it suggests that this
> should be generally possible. In particular, the description for
> itimer_set says:
> 
> Implementations may place limitations on the granularity of timer values. For
> each interval timer, if the requested timer value requires a finer granularity
> than the implementation supports, the actual timer value shall be rounded up
> to the next supported value.
> 
> However, it seems to be vaguely linked to CLOCK_PROCESS_CPUTIME_ID,
> which is defined as:
> 
> The identifier of the CPU-time clock associated with the process making a
> clock ( ) or timer*( ) function call.
> 
> POSIX does not specify whether this clock is identical to the one used
> for setitimer et al., or not, but it seems logical that it should. Then,
> the kernel should probably return the coarse granularity in
> clock_getres(), too.
> 
> I tried to find out how this is currently implemented in Linux, and it's
> broken. How else. :-/
> 
> 1. clock_getres() always returns a resolution of 1ns
> 
> This is actually good news, because it means that nobody really cares
> whether the actual granularity is greater, so I guess we can safely
> return any bogus number in clock_getres().
> 
> What about using an actual granularity of NR_CPUS*HZ, which should be
> safe for any (at least remotely) sane usage?

nr_cpu_ids * 1/HZ should do I guess, although a cubic function would buy
us even more slack.

> 2. clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts) returns -EINVAL
> 
> Should not happen. Looking further into it, I think this line in
> cpu_clock_sample_group():
> 
> 	switch (which_clock) {
> 
> should look like a similar line in cpu_clock_sample(), ie:
> 
> 	switch (CPUCLOCK_WHICH(which_clock)) {
> 
> Shall I send a patch?

Feel free - its not an area I'm intimately familiar with, I'll look into
whipping up a patch removing all the per-cpu crap from there.


