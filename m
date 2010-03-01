Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab0CAIBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:01:11 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60998 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab0CAIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:01:08 -0500
Date: Mon, 1 Mar 2010 09:00:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
Message-ID: <20100301080058.GA8049@elte.hu>
References: <20100227150942.GA6394@elte.hu>
 <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
 <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sun, 28 Feb 2010, Linus Torvalds wrote:
> > 
> > I haven't bisected this, but something slowed down in bootup on my machine 
> > recently.
> 
> Hmm. I take that back. It's not consistent, and it's not recent after all. 
> 
> It comes and goes:
> 
> 	[torvalds@nehalem linux]$ grep "CPU 7 MCA" /var/log/messages-* /var/log/messages | cut -d: -f5-
> 	 [    0.898396] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898400] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    1.596240] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898394] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    1.600229] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.901211] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    2.633298] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.901210] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898393] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898402] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.901213] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898392] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    1.601467] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898401] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898395] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 	 [    0.898397] CPU 7 MCA banks SHD:2 SHD:3 SHD:5 SHD:6 SHD:8
> 
> note how it's pretty consistently at about the 0.89s mark, but then there's 
> a _couple_ of times when it's taken rather longer to boot. But the delay is 
> always in that CPU bringup phase, because doing the same grep for "CPU 0 
> MCA" gives consistently low numbers (0.0005s).

Weird. It seems to be around multiples of .8: 0.8, 1.6, 2.4, with some extra 
overhead.

Almost as if some calibration routine or some other busy-loop misses the train 
occasionally.

The way i'd go about debugging this is to narrow down the approximate place 
the slowdown happens, then enable CONFIG_FUNCTION_TRACER (and disable 
CONFIG_DYNAMIC_FTRACE=y, to not have to deal with the dynamic patching 
aspects), and do a single-shot tracing session of only that section, on only 
one CPU:

	if (smp_processor_id() == 7)
		ftrace_enabled = 1;

	... bootup sequence ...

	if (smp_processor_id() == 7)
		ftrace_enabled = 0;

And recover the resulting trace from /debug/tracing/trace - it should have the reason
in it plain and simple.

( Unfortunately i'm not 100% sure that setting ftrace_enabled to 1 is enough. 
  I asked for a simple ad-hoc enable/disable function tracing mechanism _ages_ 
  ago - Steve, Frederic, what happened to that? ftrace_start()/stop() does not 
  seem to allow that. )

Or you could sprinkle the code with printk's, and see where the overhead 
concentrates into. (But printks ca change timings - etc. So can the function 
tracer as well ...)

	Ingo

