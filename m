Return-Path: <linux-kernel-owner+w=401wt.eu-S1763295AbXFASU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763295AbXFASU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:20:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761591AbXFASUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:20:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37474 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760990AbXFASUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:20:12 -0400
Date: Fri, 1 Jun 2007 20:19:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070601181938.GA30526@elte.hu>
References: <20070529130107.112347096@chello.nl> <1180470525.32594.71.camel@imap.mvista.com> <20070530132431.GA23947@elte.hu> <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com> <20070530134907.GA27085@elte.hu> <1180544796.32594.184.camel@imap.mvista.com> <1180545380.2958.1.camel@lappy> <1180545913.32594.194.camel@imap.mvista.com> <20070601131249.GA17059@elte.hu> <1180711606.15884.32.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180711606.15884.32.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > > > I see sched_clock() as fast first, accurate second. Whereas the 
> > > > clocksource thing is accurate first, fast second.
> > > 
> > > This is true .. However, if there is a speed different it's small.
> > 
> > Ugh. Have you ever compared pmtimer (or even hpet) against TSC based 
> > sched_clock()? What you write is so wrong that it's not even funny. 
> > You keep repeating this nonsense despite having been told multiple 
> > times that you are dead wrong.
> 
> Yes I have, and your right there is a difference, and a big difference 
> .. Above I was referring only to the TSC clocksource, since that's an 
> apples to apples comparison .. I would never compare the TSC to the 
> acpi_pm, that's no contest ..

You still dont get it i think: in real life we end up using the TSC in 
sched_clock() _much more often_ than we end up using the TSC for 
clocksource! So your flawed suggestion does not fix anything, it in fact 
introduces a really bad regression: instead of using the TSC (or 
jiffies) we'd end up using the pmtimer or hpet for every lock operation 
when lockstat is enabled, bringing the box to a screeching halt in 
essence.

so what you suggest has a far worse effect on the _majority_ of systems 
that are even interested in running lockstat, than the case you 
mentioned that some seldom-used arch which is lazy about sched_clock() 
falls back to jiffies granularity. It's not a big deal: the stats will 
have the same granularity. (the op counts in lockstat will still be 
quite useful)

sched_clock() is a 'fast but occasionally inaccurate clock', while the 
GTOD clocksource is an accurate clock (but very often slow).

	Ingo
