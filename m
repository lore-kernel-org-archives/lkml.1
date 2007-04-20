Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXDTGrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXDTGrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 02:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbXDTGrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 02:47:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57486 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbXDTGrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 02:47:12 -0400
Date: Fri, 20 Apr 2007 08:46:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, v3
Message-ID: <20070420064600.GA24614@elte.hu>
References: <20070418175017.GA5250@elte.hu> <46280505.4020605@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46280505.4020605@bigpond.net.au>
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


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> > - bugfix: use constant offset factor for nice levels instead of
> >   sched_granularity_ns. Thus nice levels work even if someone sets 
> >   sched_granularity_ns to 0. NOTE: nice support is still naive, i'll 
> >   address the many nice level related suggestions in -v4.
> 
> I have a suggestion I'd like to make that addresses both nice and 
> fairness at the same time.  As I understand the basic principle behind 
> this scheduler it to work out a time by which a task should make it 
> onto the CPU and then place it into an ordered list (based on this 
> value) of tasks waiting for the CPU. I think that this is a great idea 
> [...]

yes, that's exactly the main idea behind CFS, and thanks for the 
compliment :)

Under this concept the scheduler never really has to guess: every 
scheduler decision derives straight from the relatively simple 
one-sentence (!) scheduling concept outlined above. Everything that 
tasks 'get' is something they 'earned' before and all the scheduler does 
are micro-decisions based on math with the nanosec-granularity values. 
Both the rbtree and nanosec accounting are a straight consequence of 
this too: they are the tools that allow the implementation of this 
concept in the highest-quality way. It's certainly a very exciting 
experiment to me and the feedback 'from the field' is very promising so 
far.

> [...] and my suggestion is with regard to a method for working out 
> this time that takes into account both fairness and nice.
> 
> First suppose we have the following metrics available in addition to 
> what's already provided.
> 
> rq->avg_weight_load /* a running average of the weighted load on the 
> CPU */ p->avg_cpu_per_cycle /* the average time in nsecs that p spends 
> on the CPU each scheduling cycle */

yes. rq->nr_running is really just a first-level approximation of 
rq->raw_weighted_load. I concentrated on the 'nice 0' case initially.

> I appreciate that the notion of basing the expected wait on the task's 
> average cpu use per scheduling cycle is counter intuitive but I 
> believe that (if you think about it) you'll see that it actually makes 
> sense.

hm. So far i tried to not do any statistical approach anywhere: the 
p->wait_runtime metric (which drives the task ordering) is in essence an 
absolutely precise 'integral' of the 'expected runtimes' that the task 
observes and hence is a precise "load-average as observed by the task" 
in itself. Every time we base some metric on an average value we 
introduce noise into the system.

i definitely agree with your suggestion that CFS should use a 
nice-scaled metric for 'load' instead of the current rq->nr_running, but 
regarding the basic calculations i'd rather lean towards using 
rq->raw_weighted_load. Hm?

your suggestion concentrates on the following scenario: if a task 
happens to schedule in an 'unlucky' way and happens to hit a busy period 
while there are many idle periods. Unless i misunderstood your 
suggestion, that is the main intention behind it, correct?

	Ingo
