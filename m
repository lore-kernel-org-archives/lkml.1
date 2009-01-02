Return-Path: <linux-kernel-owner+w=401wt.eu-S1757594AbZABP74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594AbZABP74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 10:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZABP7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 10:59:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48474 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbZABP7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 10:59:46 -0500
Date: Fri, 2 Jan 2009 16:59:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
Subject: Re: random.c changes for sparse irq_desc are crap
Message-ID: <20090102155922.GD1180@elte.hu>
References: <1230748169.19620.132.camel@calx> <495BFB48.8080506@kernel.org> <1230766826.19620.150.camel@calx> <86802c440812311614n4a0ef459u4bb8be65d33994a@mail.gmail.com> <1230802316.3204.4.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230802316.3204.4.camel@calx>
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


* Matt Mackall <mpm@selenic.com> wrote:

> On Wed, 2008-12-31 at 16:14 -0800, Yinghai Lu wrote:
> > On Wed, Dec 31, 2008 at 3:40 PM, Matt Mackall <mpm@selenic.com> wrote:
> > > On Wed, 2008-12-31 at 15:07 -0800, Yinghai Lu wrote:
> > >> Matt Mackall wrote:
> > >> > I just noticed you merged a change that pointlessly converts two
> > >> > random.c functions into ugly random.h inlines without going through the
> > >> > maintainer.
> > >> >
> > >> > I also don't like the look of the newly-introduced sparse variants of
> > >> > these functions. Failure to find an irq descriptor in
> > >> > get_timer_rand_state is a BUG_ON should-never-happen sort of condition,
> > >> > not something to silently ignore. Letting the code try to dereference
> > >> > NULL is preferred here: we'll actually be able to find and fix the
> > >> > broken driver that's throwing around meaningless irq vectors.
> > >> >
> > >> > Throwing away the timer_state pointer in the set_timer_rand_state
> > >> > function is similarly bogus in addition to being a memory leak.
> > >> >
> > >> > Please fix this up.
> > >> >
> > >>
> > >> want something like this?
> > >
> > > Not quite.
> > >
> > > First, please turn these back into normal functions in random.c.
> > > Inlining functions is generally discouraged these days unless you have a
> > > good reason and numbers to back it up.
> > 
> > Ingo wanted to hide that #ifdef to .h
> 
> Ahh. I think that makes sense in some situations, but I'd prefer not to 
> do that here. Some headers are actually meant to be more readable than 
> the corresponding .c file. Also, we still end up with an ifdef in the .c 
> file so we're not actually winning.

Yinghai - i think Matt is right and there are a number of things we could 
do to improve cleanliness here. (Matt, sorry about this - we'll quickly 
fix it.)

The most important thing to observe is that the irq_desc->timer_rand_state 
cleanup you did should be made unconditional, and should not depend on 
SPARSE_IRQ. That will eliminate most of the #ifdefs, and it makes the 
random.c and random.h impact rather straightforward.

Another cleanliness detail is that these types of checks:

#ifndef CONFIG_SPARSE_IRQ
        if (irq >= nr_irqs)
                return;
#endif

can go away completely. They were needed from the sparseirq data model 
that had a dynamic array size - but that is not so anymore, so we can 
remove these complications.

Agreed?

	Ingo
