Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbYGaKad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbYGaKad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYGaKaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:30:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753529AbYGaKaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:30:24 -0400
Date: Thu, 31 Jul 2008 12:30:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>
Subject: Re: [git pull] cpus4096 fixes
Message-ID: <20080731103002.GE488@elte.hu>
References: <20080727190601.GA764@elte.hu> <200807281053.58267.rusty@rustcorp.com.au> <20080728081639.GA27708@elte.hu> <200807282321.53892.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807282321.53892.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Monday 28 July 2008 18:16:39 Ingo Molnar wrote:
> > * Rusty Russell <rusty@rustcorp.com.au> wrote:
> > > Mike: I now think the right long-term answer is Linus' dense cpumap
> > > idea + a convenience allocator for cpumasks.  We sweep the kernel for
> > > all on-stack vars and replace them with one or the other.  Thoughts?
> >
> > The dense cpumap for constant cpumasks is OK as it's clever, compact and
> > static.
> >
> > All-dynamic allocator for on-stack cpumasks ... is a less obvious
> > choice.
> 
> Sorry, I was unclear.  "long-term" == "more than 4096 CPUs", since I 
> thought that was Mike's aim.  If we only want to hack up 4k CPUS and 
> stop, then I understand the current approach.
> 
> If we want huge cpu numbers, I think cpumask_alloc/free gives the 
> clearest code.  So our approach is backwards: let's do that *then* put 
> ugly hacks in if it's really too slow.

My only worry with that principle is that the "does it really hurt" fact 
is seldom really provable on a standalone basis.

Creeping bloat and creeping slowdowns are the hardest to catch. A cycle 
here, a byte there, and it mounts up quickly. Coupled with faster but 
less deterministic CPUs it's pretty hard to prove a slowdown even with 
very careful profiling. We only catch the truly egregious cases that 
manage to shine through the general haze of other changes - and the haze 
is thickening every year.

I dont fundamentally disagree with turning cpumask into standalone 
objects on large machines though. I just think that our profiling 
methods are simply not good enough at the moment to truly trace small 
slowdowns back to their source commits fast enough. So the "we wont do 
it if it hurts" notion, while i agree with it, does not fulfill its 
promise in practice.

[ We might need something like a simulated reference CPU where various 
  "reference" performance tests are 100% repeatable and slowdowns are 
  thus 100% provable and bisectable. That CPU would simulate a cache and 
  would be modern in most aspects, etc. - just that the results it 
  produces would be fully deterministic in virtual time.

  Problem is, hw is not fast enough for that kind of simulation yet IMO
  (tools exist but it would not be fun at all to work in such a
  simulated environment in practice - hence kernel developers would
  generally ignore it) - so there will be a few years of uncertainty
  still. ]

	Ingo
