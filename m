Return-Path: <linux-kernel-owner+w=401wt.eu-S965115AbXIBP33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965115AbXIBP33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755673AbXIBP3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:29:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756090AbXIBP3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:29:16 -0400
Date: Sun, 2 Sep 2007 17:29:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070902152900.GA23642@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu> <Pine.LNX.4.64.0709021655340.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709021655340.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.0.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.2956]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > And if you look at the resulting code size/complexity, it actually 
> > increases with Roman's patch (UP, nodebug, x86):
> > 
> >      text    data     bss     dec     hex filename
> >     13420     228    1204   14852    3a04 sched.o.rc5
> >     13554     228    1228   15010    3aa2 sched.o.rc5-roman
> 
> That's pretty easy to explain due to differences in inlining:
> 
>    text    data     bss     dec     hex filename
>   15092     228    1204   16524    408c kernel/sched.o
>   15444     224    1228   16896    4200 kernel/sched.o.rfs
>   14708     224    1228   16160    3f20 kernel/sched.o.rfs.noinline

no, when generating those numbers i used:

  CONFIG_CC_OPTIMIZE_FOR_SIZE=y
  # CONFIG_FORCED_INLINING is not set

(but i also re-did it for all the other combinations of these build 
flags and similar results can be seen - your patch, despite removing 
lots of source code, produces a larger sched.o.)

> Sorry, but I didn't spend as much time as you on tuning these numbers.

some changes did slip into your patch that have no other purpose but to 
reduce code size:

  +#ifdef CONFIG_SMP
          unsigned long cpu_load[CPU_LOAD_IDX_MAX];
  +#endif
  [...]
  +#ifdef CONFIG_SMP
   /* Used instead of source_load when we know the type == 0 */
   unsigned long weighted_cpuload(const int cpu)
   {
          return cpu_rq(cpu)->ls.load.weight;
   }
  +#endif
  [...]

so i thought you must be aware of the problem - at least considering how 
much you've criticised CFS's "complexity" both in your initial review of 
CFS (which included object size comparisons) and in this patch 
submission of yours (which did not include object size comparisons
though).

> > so unmodified CFS is 4.6% faster on this box than with Roman's patch 
> > and it's also more consistent/stable (10 times lower fluctuations).
> 
> Was SCHED_DEBUG enabled or disabled for these runs?

debugging disabled of course. (your patch has a self-validity checking 
function [verify_queue()] that is called on SCHED_DEBUG=y, it would have 
been unfair to test your patch with that included.)

	Ingo
