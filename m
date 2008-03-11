Return-Path: <linux-kernel-owner+w=401wt.eu-S1756897AbYCKWAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbYCKWAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 18:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbYCKWAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 18:00:47 -0400
Received: from www.tglx.de ([62.245.132.106]:33717 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982AbYCKWAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 18:00:47 -0400
Date: Tue, 11 Mar 2008 22:59:45 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: [PATCH REPOST for 2.6.25] Use an own random generator for
 pageattr-test.c
In-Reply-To: <20080311214925.GA428@one.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803112248550.3781@apollo.tec.linutronix.de>
References: <20080311013014.GA28682@basil.nowhere.org> <alpine.LFD.1.00.0803110922430.3781@apollo.tec.linutronix.de> <20080311104531.GB18917@one.firstfloor.org> <alpine.LFD.1.00.0803111233440.3781@apollo.tec.linutronix.de> <20080311114832.GE18917@one.firstfloor.org>
 <alpine.LFD.1.00.0803112128190.3781@apollo.tec.linutronix.de> <20080311214925.GA428@one.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2008, Andi Kleen wrote:
> > It's a question of how you write such test code to achieve
> > reproducability. It's not rocket science to track the variables of a
> > test run and print them along with the printk, when a wrong state is
> > detected. 
> 
> If you wanted to do that you would need some variant of my patch too --
> to do it with random32() you would first need to print all NR_CPUS
> state (and implement "kernel less" first for NR_CPUS > 128 kernels :),
> then keep track of all CPUs the test thread ran on and print that
> out too and also disable the regular timer reseeder to avoid races.
> Clearly doesn't make sense.
> 
> random32() in lib/ is simply unusable as a deterministic RND,
> it's more like super weak strange /dev/random variant which
> probably should be never put into lib/ anyways because it's unlikely
> to be generally useful.
> 
> So for a random but repeatable sequence like you describe you could keep the 
> patch, replace the static int next = 1; with static int next and add a 
> get_random_bytes(&next, sizeof(next)); and then print out the next value

Oh well. Randomized test code is there to catch bugs by statistical
spreading. Having a pseudo randomized scenario which is repeatable per
machine is defeating the randomized approach. Repeating a test with a
stale pattern is pretty useless unless you catch a bug right in the
first run.

The only bug that code ever caught aside of tons of false positives
was when we increased the runtime length and added the thread which
repeated the test.

Finding a bug, when it was exposed by a static pattern, is trivial,
but the challenge is to make such tests useful enough with random
patterns. And there are ways to do that, e.g. by making the debug
output informative enough to provide information about the problem in
detail instead of printing some useless info "a != b".

Thanks,

	tglx
