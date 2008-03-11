Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYCKVrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYCKVrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYCKVrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:47:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48980 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYCKVrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:47:32 -0400
Date: Tue, 11 Mar 2008 22:49:26 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for pageattr-test.c
Message-ID: <20080311214925.GA428@one.firstfloor.org>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org> <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de> <20080311114832.GE18917@one.firstfloor.org> <alpine.LFD.1.00.0803112128190.3781@apollo.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0803112128190.3781@apollo.tec.linutronix.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 10:08:07PM +0100, Thomas Gleixner wrote:
> On Tue, 11 Mar 2008, Andi Kleen wrote:
> > > > > > Use an own random generator for pageattr-test.c
> > > > > > 
> > > > > > [Repost. Please ack/nack. This is a bug fix and imho a .25 late merge 
> > > > > > candidate because it fixes a subtle bug]
> > > > > 
> > > > > Care to point out which "subtle bug" is fixed ? 
> > > > > 
> > > > > You replace a random generator by another to get repeateable
> > > > > sequences. The non repeatability of the cpa test patterns is hardly a
> > > > > "subtle bug".
> > > > 
> > > > The subtle bug(s) are first that it is not repeatable (it really should),
> > > 
> > > As I said before. It's hardly a bug. In fact it is questionable
> > > whether fully reproducible test patterns are desired.
> > 
> > Ok then you won't be able to repeat the test ever.
> > 
> > I consider this bad practice in test code because it makes it impossible
> > to stabilize bugs
> 
> Test code with constant test patterns tend to miss the corner case
> bugs, while random pattern test cases hit them assumed that there is a
> broad enough tester base. 

The original idea was that there is enough variability in memory
maps that you still get the various scenarios tested, but that
a boot on a single machine stays deterministic in its behaviour.

> 
> It's a question of how you write such test code to achieve
> reproducability. It's not rocket science to track the variables of a
> test run and print them along with the printk, when a wrong state is
> detected. 

If you wanted to do that you would need some variant of my patch too --
to do it with random32() you would first need to print all NR_CPUS
state (and implement "kernel less" first for NR_CPUS > 128 kernels :),
then keep track of all CPUs the test thread ran on and print that
out too and also disable the regular timer reseeder to avoid races.
Clearly doesn't make sense.

random32() in lib/ is simply unusable as a deterministic RND,
it's more like super weak strange /dev/random variant which
probably should be never put into lib/ anyways because it's unlikely
to be generally useful.

So for a random but repeatable sequence like you describe you could keep the 
patch, replace the static int next = 1; with static int next and add a 
get_random_bytes(&next, sizeof(next)); and then print out the next value

-andi

