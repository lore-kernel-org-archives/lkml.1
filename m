Return-Path: <linux-kernel-owner+w=401wt.eu-S1760209AbZEGIes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209AbZEGIes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbZEGIej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:34:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47886 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754057AbZEGIei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:34:38 -0400
Date: Thu, 7 May 2009 10:34:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4/7] ring-buffer: change test to be more latency
	friendly
Message-ID: <20090507083423.GA18360@elte.hu>
References: <20090507031335.815354104@goodmis.org> <20090507031434.214633851@goodmis.org> <20090507083147.GG12285@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507083147.GG12285@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The ring buffer benchmark/test runs a producer for 10 seconds. 
> > This is done with preemption and interrupts enabled. But if the 
> > kernel is not compiled with CONFIG_PREEMPT, it basically stops 
> > everything but interrupts for 10 seconds.
> > 
> > Although this is just a test and is not for production, this attribute
> > can be quite annoying. It can also spawn badness elsewhere.
> 
> Yep, this probably explains that lockdep splat i got in a networking 
> driver. Some functionality (a workqueue iirc) of the driver got 
> starved and a time-out timer triggered - where lockdep caught 
> locking badness.
> 
> > This patch solves the issues by calling "cond_resched" when the 
> > system is not compiled with CONFIG_PREEMPT. It also keeps track of 
> > the time spent to call cond_resched such that it does not go 
> > against the time calculations. That is, if the task schedules 
> > away, the time scheduled out is removed from the test data. Note, 
> > this only works for non PREEMPT because we do not know when the 
> > task is scheduled out if we have PREEMPT enabled.
> > 
> > [ Impact: prevent test from stopping the world for 10 seconds ]
> > 
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/trace/ring_buffer_benchmark.c |   31 +++++++++++++++++++++++++++++++
> >  1 files changed, 31 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
> > index dcd75e9..a26fc67 100644
> > --- a/kernel/trace/ring_buffer_benchmark.c
> > +++ b/kernel/trace/ring_buffer_benchmark.c
> > @@ -185,6 +185,35 @@ static void ring_buffer_consumer(void)
> >  	complete(&read_done);
> >  }
> >  
> > +/*
> > + * If we are a non preempt kernel, the 10 second run will
> > + * stop everything while it runs. Instead, we will call cond_resched
> > + * and also add any time that was lost by a rescedule.
> > + */
> > +#ifdef CONFIG_PREEMPT
> > +static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
> > +{
> > +}
> > +#else
> > +static void sched_if_needed(struct timeval *start_tv, struct timeval *end_tv)
> > +{
> > +	struct timeval tv;
> > +
> > +	cond_resched();
> > +	do_gettimeofday(&tv);
> > +	if (tv.tv_usec < end_tv->tv_usec) {
> > +		tv.tv_usec += 1000000;
> > +		tv.tv_sec--;
> > +	}
> > +	start_tv->tv_sec += tv.tv_sec - end_tv->tv_sec;
> > +	start_tv->tv_usec += tv.tv_usec - end_tv->tv_usec;
> > +	if (start_tv->tv_usec > 1000000) {
> > +		start_tv->tv_usec -= 1000000;
> > +		start_tv->tv_sec++;
> > +	}
> > +}
> > +#endif
> 
> This is _way_ too ugly. Why not just add a cond_resched() to the 
> inner loop and be done with it? cond_resched() is conditional 
> already, so it will only schedule 'if needed'.
> 
> If the test's timing gets skewed, what's the big deal? If its 
> being preempted there will be impact _anyway_. (due to cache 
> footprint elimination, etc.) People obviously should only rely on 
> the numbers if the system is idle.

Note, i pulled, because the other bits are really nice - but it 
would be good to eliminate the code above in a followup patch.

	Ingo
