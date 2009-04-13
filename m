Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZDMVWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZDMVWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZDMVWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:22:40 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46721 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZDMVWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:22:40 -0400
Date: Mon, 13 Apr 2009 23:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] ftrace: add max execution time mesurement to
	workqueue tracer
Message-ID: <20090413212159.GA8514@elte.hu>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145254.6E0D.A69D9226@jp.fujitsu.com> <20090413161649.GH5977@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090413161649.GH5977@nowhere>
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


(Oleg, Andrew: it's about workqueue tracing design.)

* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >  		if (tsk) {
> > -			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
> > +			seq_printf(s, "%3d %6d     %6u     %5lu.%06lu"
> > +				   "  %s\n",
> > +				   cws->cpu,
> >  				   atomic_read(&cws->inserted), cws->executed,
> > +				   exec_secs, exec_usec_rem,
> 
> 
> You are measuring the latency from a workqueue thread point of 
> view. While I find the work latency measurement very interesting, 
> I think this patch does it in the wrong place. The _work_ latency 
> point of view seems to me much more rich as an information source.
> 
> There are several reasons for that.
> 
> Indeed this patch is useful for workqueues that receive always the 
> same work to perform so that you can find very easily the guilty 
> worklet. But the sense of this design is lost once we consider the 
> workqueue threads that receive random works. Of course the best 
> example is events/%d One will observe the max latency that 
> happened on event/0 as an exemple but he will only be able to feel 
> a silent FUD because he has no way to find which work caused this 
> max latency.

Expanding the trace view in a per worklet fashion is also useful for 
debugging: sometimes inefficiencies (or hangs) are related to the 
mixing of high-speed worklets with blocking worklets. This is not 
exposed if we stay at the workqueue level only.

> Especially the events/%d latency measurement seems to me very 
> important because a single work from a random driver can propagate 
> its latency all over the system.
> 
> A single work that consumes too much cpu time, waits for long 
> coming events, sleeps too much, tries to take too often contended 
> locks, or whatever... such single work may delay all pending works 
> in the queue and the only max latency for a given workqueue is not 
> helpful to find these culprits.
> 
> Having this max latency snapshot per work and not per workqueue 
> thread would be useful for every kind of workqueue latency 
> instrumentation:
> 
> - workqueues with single works
> - workqueue with random works
> 
> A developer will also be able to measure its own worklet action 
> and find if it takes too much time, even if it isn't the worst 
> worklet in the workqueue to cause latencies.
> 
> The end result would be to have a descending latency sort of works 
> per cpu workqueue threads (or better: per workqueue group).
> 
> What do you think?

Sounds like a good idea to me. It would also allow histograms based 
on worklet identity, etc. Often the most active kevents worklet 
should be considered to be split out as a new workqueue.

And if we have a per worklet tracepoint it would also allow a trace 
filter to only trace a given type of worklet.

	Ingo
