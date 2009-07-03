Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZGCI2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZGCI2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 04:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZGCI2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 04:28:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54200 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZGCI2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 04:28:00 -0400
Date: Fri, 3 Jul 2009 10:27:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/6 -tip] perf stat: treat same behaviour for all
	CYCLES and CLOCKS
Message-ID: <20090703082734.GE21833@elte.hu>
References: <1246440815.3403.3.camel@hpdv5.satnam> <1246440909.3403.5.camel@hpdv5.satnam> <1246440977.3403.7.camel@hpdv5.satnam> <20090701113915.GG15958@elte.hu> <19021.48828.428272.100850@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19021.48828.428272.100850@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > Other 'compound' events might be possible too: for example a new 
> > cache-hits field could be is cache-refs minus cache-misses.
> 
> Hmmm, on the MPC7450 family there are events for cache-hits and 
> cache-misses, so there it would be nice to be able to ask for 
> cache-refs and have it compute cache-hits plus cache-misses.

Yes. I think the API is structured enough so that user-space knows 
enough about the meaning of the events here. We can certainly 
stipulate this rule:

	refs == hits + misses

And if the kernel returns -ENODEV for a particular component 
user-space can fall back using the other two events.

I.e. this would allow transparent support for all 3 permutations:

	hw has refs and hits
	hw has refs and misses
	hw has hits and misses

For sampling it's a tiny bit tricky but still doable:j a compound 
counter could still sample because we handle weighted samples 
throughout the tools and negative weight can be subtraced.

Intuitive annotation output would have to be thought out for this as 
entries/function could go negative statistically.

> > I.e. the simplest model for 'compound' events would be:
> > 
> >   X = A / B
> >   X = A - B
> >   X = A + B
> > 
> > We could list them in the event table, with a flag that 
> > specifies which arithmetic operation connects two 'atomic' 
> > counters.
> > 
> > Then the adding of a new compound event would only be the matter 
> > of adding one more line to the event table.
> 
> Sounds nice.  If we do this we should ensure that the two events 
> get put into one group if possible.

Correct. Are you interested in adding this, so that it fits the 
MPC7450 family perfectly?

	Ingo
