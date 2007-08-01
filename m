Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbXHARli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbXHARli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757953AbXHARla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:41:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293AbXHARl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:41:29 -0400
Date: Wed, 1 Aug 2007 19:41:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Mike Galbraith <efault@gmx.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CFS review
Message-ID: <20070801174119.GA9152@elte.hu>
References: <alpine.LFD.0.999.0707111500210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707130415520.1818@scrub.home> <1184302024.6709.11.camel@Homer.simpson.net> <Pine.LNX.4.64.0707131728070.1817@scrub.home> <1184389456.6632.13.camel@Homer.simpson.net> <Pine.LNX.4.64.0708010439050.1817@scrub.home> <20070801112229.GA11710@elte.hu> <Pine.LNX.4.64.0708011346510.1817@scrub.home> <20070801135949.GA10839@elte.hu> <Pine.LNX.4.64.0708011622400.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708011622400.1817@scrub.home>
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


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > i tried your fl.c and if sched_clock() is high-resolution it's scheduled 
> > _perfectly_ by CFS:
> > 
> >    PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >   5906 mingo     20   0  1576  244  196 R 71.2  0.0   0:30.11 l
> >   5909 mingo     20   0  1844  344  260 S  9.6  0.0   0:04.02 lt
> >   5907 mingo     20   0  1844  508  424 S  9.5  0.0   0:04.01 lt
> >   5908 mingo     20   0  1844  344  260 S  9.5  0.0   0:04.02 lt
> > 
> > if sched_clock() is low-resolution then indeed the 'lt' tasks will 
> > "hide":
> > 
> >   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> >  2366 mingo     20   0  1576  248  196 R 99.9  0.0   0:07.95 loop_silent
> >     1 root      20   0  2132  636  548 S  0.0  0.0   0:04.64 init
> > 
> > but that's nothing new. CFS cannot conjure up time measurement 
> > methods that do not exist. If you have a low-res clock and if you 
> > create an app that syncs precisely to the tick of that clock via 
> > timers that run off that exact tick then there's nothing the 
> > scheduler can do about it. It is false to charachterise this as 
> > 'sleeper starvation' or 'rounding error' like you did. No amount of 
> > rounding logic can create a high-resolution clock out of thin air.
> 
> [...] I didn't say 'sleeper starvation' or 'rounding error', these are 
> your words and it's your perception of what I said.

Oh dear :-) It was indeed my preception that yesterday you said:

| A problem here is that this can be exploited, if a job is spread over 
|                        ^^^^^^^^^^^^^^^^^^^^^
| a few threads, they can get more time relativ to other tasks, e.g. in 
|                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| this example there are three tasks that run only for about 1ms every 
| 3ms, but they get far more time than should have gotten fairly:
|          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
|
| 4544 roman     20   0  1796  520  432 S 32.1  0.4   0:21.08 lt
| 4545 roman     20   0  1796  344  256 R 32.1  0.3   0:21.07 lt
| 4546 roman     20   0  1796  344  256 R 31.7  0.3   0:21.07 lt
| 4547 roman     20   0  1532  272  216 R  3.3  0.2   0:01.94 l

 [ http://lkml.org/lkml/2007/7/31/668 ]

( the underlined portion, in other words, is called 'starvation'.)

And again today, i clearly perceived you to say:

| > in that case 'top' accounting symptoms similar to the above are not 
| > due to the scheduler starvation you suspected, but due the effect of 
| > a low-resolution scheduler clock and a tightly coupled 
| > timer/scheduler tick to it.
|
| Well, it magnifies the rounding problems in CFS.

 [ http://lkml.org/lkml/2007/8/1/153 ]

But you are right, that must be my perception alone, you couldnt 
possibly have said any of that =B-)

Or are you perhaps one of those who claims that saying something 
analogous to sleeper starvation does not equal to talking about 'sleeper 
starvation' and saying something about 'rounding problems in CFS' does 
in no way mean you were talking about rounding errors? :-)

	Ingo
