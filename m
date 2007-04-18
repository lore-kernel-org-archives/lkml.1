Return-Path: <linux-kernel-owner+w=401wt.eu-S1422740AbXDRJyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422740AbXDRJyV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:54:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422759AbXDRJyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:54:21 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51933 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740AbXDRJyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:54:20 -0400
Date: Wed, 18 Apr 2007 11:53:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Steve Fox <drfickle@us.ibm.com>,
       Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418095334.GA26525@elte.hu>
References: <20070413202100.GA9957@elte.hu> <46247DAB.1060808@shadowen.org> <20070417093257.GA9267@wotan.suse.de> <20070417095900.GB25553@elte.hu> <20070418085525.GA21194@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418085525.GA21194@wotan.suse.de>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <npiggin@suse.de> wrote:

> > > 535.43user 30.62system 2:23.72elapsed 393%CPU
> > 
> > Thanks for testing this! Could you please try this also with:
> > 
> >    echo 100000000 > /proc/sys/kernel/sched_granularity
> 
> 507.68user 31.87system 2:18.05elapsed 390%CPU
> 507.99user 31.93system 2:18.09elapsed 390%CPU

> > could you maybe even try a more extreme setting of:
> > 
> >    echo 500000000 > /proc/sys/kernel/sched_granularity

> 506.69user 31.96system 2:17.82elapsed 390%CPU
> 505.70user 31.84system 2:17.90elapsed 389%CPU

> Again, for comparison 2.6.21-rc7 mainline:
> 
> 508.87user 32.47system 2:17.82elapsed 392%CPU
> 509.05user 32.25system 2:17.84elapsed 392%CPU

thanks for testing this!

> So looking at elapsed time, a granularity of 100ms is just behind the 
> mainline score. However it is using slightly less user time and 
> slightly more idle time, which indicates that balancing might have got 
> a bit less aggressive.
> 
> But anyway, it conclusively shows the efficiency impact of such tiny 
> timeslices.

yeah, the 4% drop in a CPU-cache-sensitive workload like kernbench is 
not unexpected when going to really frequent preemption. Clearly, the 
default preemption granularity needs to be tuned up.

I think you said you measured ~3msec average preemption rate per CPU? 
That would suggest the average cache-trashing cost was 120 usecs per 
every 3 msec window. Taking that as a ballpark figure, to get the 
difference back into the noise range we'd have to either use ~5 msec:

    echo 5000000 > /proc/sys/kernel/sched_granularity

or 15 msec:

    echo 15000000 > /proc/sys/kernel/sched_granularity

(depending on whether it's 5x 3msec or 5x 1msec - i'm still not sure i 
correctly understood your 3msec value. I'd have to know your kernbench 
workload's approximate 'steady state' context-switch rate to do a more 
accurate calculation.)

	Ingo
