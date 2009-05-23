Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZEWMix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZEWMix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 08:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZEWMiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 08:38:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41571 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011AbZEWMip (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 08:38:45 -0400
Date: Sat, 23 May 2009 14:38:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
	identical inherited contexts
Message-ID: <20090523123828.GA13878@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com> <18966.10666.517218.332164@cargo.ozlabs.ibm.com> <1242980169.26820.617.camel@twins> <18966.30400.611789.434936@cargo.ozlabs.ibm.com> <1242986897.26820.638.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1242986897.26820.638.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2009-05-22 at 19:56 +1000, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> > > > Since we don't have individual fds for the counters in a cloned
> > > > context, the only thing that can make two clones of a given parent
> > > > different after they have been cloned is enabling or disabling all
> > > > counters with prctl.  To account for this, we keep a count of the
> > > > number of enabled counters in each context.  Two contexts must have
> > > > the same number of enabled counters to be considered equivalent.
> > > 
> > > Curious point that.. so prctl() can disable counters it doesn't own.
> > > 
> > > Shouldn't we instead fix that?
> > 
> > Well, prctl enables/disables the counters that are counting on the
> > current process, regardless of who or what created them.  I always
> > thought that was a little strange; maybe it is useful to be able to
> > disable all the counters that any other process might have put on to
> > you, but I can't think of a scenario where you'd really need to do
> > that, particularly since the disable is a one-shot operation, and
> > doesn't prevent new (enabled) counters being attached to you.
> > 
> > On the other hand, what does "all the counters I own" mean?  
> > Does it mean all the ones that I have fds open for?  Or does it 
> > mean all the ones that I created?  Either way we don't have a 
> > good way to enumerate them.
> 
> I'm for all counters you created (ie have a fd for). Being able to 
> disable counters others created on you just sounds wrong.
> 
> If we can settle on a semantic, I'm sure we can implement it :-)
> 
> Ingo, Corey, any opinions?

It indeed doesnt sound correct that we can disable counters others 
created on us - especially if they are in a different (higher 
privileged) security context than us.

OTOH, enabling/disabling counters in specific functions of a library 
might be a valid use-case. So perhaps make this an attribute: 
.transparent or so, with perf stat defaulting on it to be 
transparent (i.e. not child context disable-able).

	Ingo
