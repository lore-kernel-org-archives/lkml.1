Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZD2TqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZD2TqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbZD2TqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:46:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49936 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbZD2TqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:46:05 -0400
Date: Wed, 29 Apr 2009 21:45:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/5] ring-buffer: fix printk output
Message-ID: <20090429194546.GA17021@elte.hu>
References: <20090429045908.394874083@goodmis.org> <20090428222024.8db50539.akpm@linux-foundation.org> <20090429054359.GA6148@elte.hu> <20090428225541.9ca61a12.akpm@linux-foundation.org> <20090429060955.GD6148@elte.hu> <20090428232000.6c3d4ce1.akpm@linux-foundation.org> <20090429072208.GA22129@elte.hu> <20090429004141.5f0565c9.akpm@linux-foundation.org> <20090429095625.GE31185@elte.hu> <20090429080907.efb8ba2f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429080907.efb8ba2f.akpm@linux-foundation.org>
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


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 11:56:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > > > My larger point remains, about possibly embedding linux-next 
> > > > into lkml. I couldnt think of a single linux-next mail that isnt 
> > > > relevant to lkml. It's all about commits that are destined for 
> > > > upstream in 0-2.5 months.
> > > 
> > > Sure, I'd be OK with zapping the linux-next list.
> > 
> > Another, less drastic solution would be to keep it as an _alias_ 
> > list. All mails posted to it also go to lkml, but it would still be 
> > subscribe-able separately.
> 
> That would work, although I wonder about the potential for 
> duplicates turning up somewhere.

The potential for duplicates is inherent in Cc: lines to begin with.

> > ( This has come up before and this would be useful for a number of 
> >   other things - such as tracing/instrumentation. Someone who is 
> >   only interested in instrumentation related discussions could 
> >   subscribe to that list. )
> > 
> > > > > printk_once() is racy on smp and preempt btw ;)
> > > > 
> > > > Like WARN_ONCE() and WARN_ON_ONCE(). It's really an "oh crap" 
> > > > facility, not for normal kernel messages.
> > > > 
> > > > Do we want to complicate them with locking and preemption - or 
> > > > should we just concentrate on getting the "oh crap" message out 
> > > > to the syslog (before it's possibly too late to get anything 
> > > > out)?
> > > > 
> > > > I have no strong opinion about it - but i tend to like the 
> > > > simpler method most. printk + stack dumps themselves arent 
> > > > atomic to begin with.
> > > 
> > > Well, it's hardly likely to be a problem.  otoh, if two CPUs _do_ 
> > > hit the thing at the same time, the resulting output will be all 
> > > messed up and we'd really like to see it.
> > > 
> > > Easily fixed with test_and_set_bit()?
> > 
> > but if two CPUs hit it at once then the printk+stack-dump itself is 
> > already mixed up. So if we do any atomicity it should be done for 
> > all the print-once APIs. (note, lockdep does such message-atomicity 
> > already, in its own facility)
> 
> Confused.
> 
> <gets distracted by FW_BUG and friends.  ytf are they in kernel.h?>
> 
> #define printk_once(x...) ({				\
> 	static unsigned long __print_once;		\
> 							\

hm, this doubles the flag size on 32-bit kernels.

> 	if (!test_and_set_bit(0, &__print_once))	\
> 		printk(x);				\
> })
> 
> How can	two CPUs do the printk(x)?

they cannot. Did i say they do? What i said (or thought to have said 
;-) was that all the print-once APIs need similar treatment - or 
neither should.

	Ingo
