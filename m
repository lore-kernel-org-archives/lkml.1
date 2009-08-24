Return-Path: <linux-kernel-owner+w=401wt.eu-S1751902AbZHXHht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751902AbZHXHht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbZHXHht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:37:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36088 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751692AbZHXHhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:37:48 -0400
Date: Mon, 24 Aug 2009 09:37:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, James Morris <jmorris@namei.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/4] perf_counter: Default to higher paranoia level
Message-ID: <20090824073711.GA26637@elte.hu>
References: <20090819091823.916851355@chello.nl> <20090819092023.728070630@chello.nl> <1250690853.8282.59.camel@twins> <1250769606.8282.181.camel@twins> <20090821142151.GC11098@elte.hu> <1251098962.7538.143.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251098962.7538.143.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, 2009-08-21 at 16:21 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
> > > index 9ba1822..2b0528f 100644
> > > --- a/include/linux/perf_counter.h
> > > +++ b/include/linux/perf_counter.h
> > > @@ -439,6 +439,7 @@ enum perf_callchain_context {
> > >  struct perf_callchain_entry {
> > >  	__u64				nr;
> > >  	__u64				ip[PERF_MAX_STACK_DEPTH];
> > > +	int				restricted;
> > >  };
> > 
> > i'd love to have something more specific here - i.e. a context type 
> > ID that identifies these basic types:
> > 
> >  - process
> >  - softirq
> >  - hardirq
> >  - NMI
> > 
> > and then let it be up to upper layers to decide what they do with a 
> > restricted entry, and how to further process this information.
> > 
> > And it's not just security: for example it would be interesting to 
> > sample pure, non-irq overhead - as IRQ overhead is often unrelated 
> > to the process being measured.
> 
> Yes it is, this is purely about not showing some data. If you 
> don't want to sample IRQ stuff that's something else, we'd have to 
> grow that capability in hardware (like the OS/USR bits) or put 
> perf enable/disable hooks into the irq entry/exit hooks (which 
> doesn't sound all too hot an idea to me).
> 
> Simply not showing the call-trace is something all-together 
> different from not profiling it.

Well, it's not about not profiling it - it's about being able to 
_separate out_ the samples from the various contexts.

Right now we already have context separators for call-chains:

        PERF_CONTEXT_HV                 = (__u64)-32,
        PERF_CONTEXT_KERNEL             = (__u64)-128,
        PERF_CONTEXT_USER               = (__u64)-512,

        PERF_CONTEXT_GUEST              = (__u64)-2048,
        PERF_CONTEXT_GUEST_KERNEL       = (__u64)-2176,
        PERF_CONTEXT_GUEST_USER         = (__u64)-2560,

All i'm suggesting is to also have these context separators:

	PERF_CONTEXT_KERNEL_HARDIRQ
	PERF_CONTEXT_KERNEL_SOFTIRQ
	PERF_CONTEXT_KERNEL              /* syscall level */

So that if user-space wants to visualize just a portion of it, it 
can do it.

	Ingo
