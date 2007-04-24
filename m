Return-Path: <linux-kernel-owner+w=401wt.eu-S1161527AbXDXIv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161527AbXDXIv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 04:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161531AbXDXIv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 04:51:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53883 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161527AbXDXIv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 04:51:27 -0400
Date: Tue, 24 Apr 2007 10:51:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Gerdau <mgd@technosis.de>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Gene Heskett <gene.heskett@gmail.com>,
       Juliusz Chroboczek <jch@pps.jussieu.fr>, Mike Galbraith <efault@gmx.de>,
       Peter Williams <pwil3058@bigpond.net.au>, ck list <ck@vds.kolivas.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bill Davidsen <davidsen@tmr.com>, Willy Tarreau <w@1wt.eu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [REPORT] cfs-v5 vs sd-0.46
Message-ID: <20070424085105.GA12329@elte.hu>
References: <200704240938.07482.mgd@technosis.de> <200704241017.10610.mgd@technosis.de> <20070424082305.GA6332@elte.hu> <200704241041.53762.mgd@technosis.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704241041.53762.mgd@technosis.de>
User-Agent: Mutt/1.4.2.2i
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


* Michael Gerdau <mgd@technosis.de> wrote:

> > Here i'm assuming that the vmstats are directly comparable: that 
> > your number-crunchers behave the same during the full runtime - is 
> > that correct?
> 
> Yes, basically it does (disregarding small fluctuations)

ok, good.

> I'll see whether I can produce some type of absolute performance 
> measure as well. Thinking about it I guess this should be fairly 
> simple to implement.

oh, you are writing the number-cruncher? In general the 'best' 
performance metrics for scheduler validation are the ones where you have 
immediate feedback: i.e. some ops/sec (or ops per minute) value in some 
readily accessible place, or some "milliseconds-per-100,000 ops" type of 
metric - whichever lends itself better to the workload at hand. If you 
measure time then the best is to use long long and nanoseconds and the 
monotonic clocksource:

 unsigned long long rdclock(void)
 {
	struct timespec ts;

	clock_gettime(CLOCK_MONOTONIC, &ts);

        return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
 }

(link to librt via -lrt to pick up clock_gettime())

The cost of a clock_gettime() (or of a gettimeofday()) can be a couple 
of microseconds on some systems, so it shouldnt be done too frequently.

Plus an absolute metric of "the whole workload took X.Y seconds" is 
useful too.

	Ingo
