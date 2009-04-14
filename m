Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZDNLkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZDNLkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZDNLkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:40:42 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:17712 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbZDNLkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:40:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OaiqDBhZ8U0NNwaXJRqdQjCcjkDsP+DiQoOQtiyPJCFAWfFATaNFw7kRmMPegq60fO
         lnaTGjxljFob0ZN6qctCHRqKNUp1Zm1x7T+wf6F5/E4jPtEdz7SWC6bUd3j2tR7x+QWO
         3l5AWGCiENsavkKjNrvkFS7sFINX8Ul9EcWEY=
Date: Tue, 14 Apr 2009 13:40:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/4] ftrace: add max execution time mesurement to
	workqueue tracer
Message-ID: <20090414114032.GA5994@nowhere>
References: <20090413145254.6E0D.A69D9226@jp.fujitsu.com> <20090413161649.GH5977@nowhere> <20090414102802.C637.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414102802.C637.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 10:43:21AM +0900, KOSAKI Motohiro wrote:
> Hi Frederic,
> 
> very thanks for good reviewing.
> 
> 
> > > @@ -85,6 +90,29 @@ found:
> > >  	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> > >  }
> > >  
> > > +static void probe_workqueue_exit(struct task_struct *wq_thread,
> > > +				 struct work_struct *work)
> > > +{
> > > +	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> > > +	struct cpu_workqueue_stats *node, *next;
> > > +	unsigned long flags;
> > > +
> > > +	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> > > +	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> > > +							list) {
> > 
> > 
> > Do you need the safe version here? You don't seem to remove any entry.
> 
> Yes, this is just stupid cut&paste mistake ;)
> Will fix.
> 
> > Sidenote: only the workqueue destruction handler might need it if I'm
> > not wrong.
> > I placed some of them in other places in this file because I misunderstood the
> > kernel list concepts in the past :)
> > (Heh, and probably still today).
> > 
> > 
> > 
> > > +		if (node->pid == wq_thread->pid) {
> > > +			u64 start = node->handler_start_time;
> > > +			u64 executed_time = trace_clock_global() - start;
> > > +
> > > +			if (node->max_executed_time < executed_time)
> > > +				node->max_executed_time = executed_time;
> > > +			goto found;
> > > +		}
> > > +	}
> > > +found:
> > > +	spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
> > > +}
> > > +
> > >  /* Creation of a cpu workqueue thread */
> > >  static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
> > >  {
> > > @@ -195,6 +223,9 @@ static int workqueue_stat_show(struct se
> > >  	int cpu = cws->cpu;
> > >  	struct pid *pid;
> > >  	struct task_struct *tsk;
> > > +	unsigned long long exec_time = ns2usecs(cws->max_executed_time);
> > > +	unsigned long exec_usec_rem = do_div(exec_time, USEC_PER_SEC);
> > > +	unsigned long exec_secs = (unsigned long)exec_time;
> > >  
> > >  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> > >  	if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
> > > @@ -205,8 +236,11 @@ static int workqueue_stat_show(struct se
> > >  	if (pid) {
> > >  		tsk = get_pid_task(pid, PIDTYPE_PID);
> > >  		if (tsk) {
> > > -			seq_printf(s, "%3d %6d     %6u       %s\n", cws->cpu,
> > > +			seq_printf(s, "%3d %6d     %6u     %5lu.%06lu"
> > > +				   "  %s\n",
> > > +				   cws->cpu,
> > >  				   atomic_read(&cws->inserted), cws->executed,
> > > +				   exec_secs, exec_usec_rem,
> > 
> > You are measuring the latency from a workqueue thread point of view.
> > While I find the work latency measurement very interesting,
> > I think this patch does it in the wrong place. The _work_ latency point of view
> > seems to me much more rich as an information source.
> > 
> > There are several reasons for that.
> > 
> > Indeed this patch is useful for workqueues that receive always the same work
> > to perform so that you can find very easily the guilty worklet.
> > But the sense of this design is lost once we consider the workqueue threads
> > that receive random works. Of course the best example is events/%d
> > One will observe the max latency that happened on event/0 as an exemple but
> > he will only be able to feel a silent FUD because he has no way to find
> > which work caused this max latency.
> 
> May I explain my expected usage scenario?
> 
> firstly, the developer check this stastics and nortice strage result. secondly
> the developer monitor workqueue activety by event-tracer.
> (it provide per work activety, maybe event filter feature is useful)
> 
> Yes, I have to agree my last patch description is too poor.
> but I think my expected scenario is't so insane.
> 
> Next, I hope to explain why I don't choice adding per work stastics.
> struct work can put in stack and it's short lived object.
> then, it isn't proper "stastics" target.
> 
> I like my approach or histogram approach (suggested by ingo).
> 
> 
> May I ask your feeling to my usage scenario?



Ok, I understand. This is a coupling of statistical tracing
and batch raw event tracing.
But a statistical view for every work per workqueue would
be definetly more helpful.
Beeing forced to look at the raw batch of work events involves
more searching in the traces and more headaches.

With your patch, we only see the worst time case on a workqueue while
it would be better to find all the works which are encumbering
a workqueue, sorted by latency importance.

I agree with the fact that it's not so easy though, because the works
can be allocated on the stack as you said.

Thanks,
Frederic.


> 
> > 
> > 
> > Especially the events/%d latency measurement seems to me very important
> > because a single work from a random driver can propagate its latency
> > all over the system.
> > 
> > A single work that consumes too much cpu time, waits for long coming
> > events, sleeps too much, tries to take too often contended locks, or
> > whatever... such single work may delay all pending works in the queue
> > and the only max latency for a given workqueue is not helpful to find
> > these culprits.
> > 
> > Having this max latency snapshot per work and not per workqueue thread
> > would be useful for every kind of workqueue latency instrumentation:
> > 
> > - workqueues with single works
> > - workqueue with random works
> > 
> > A developer will also be able to measure its own worklet action and
> > find if it takes too much time, even if it isn't the worst worklet in
> > the workqueue to cause latencies.
> > 
> > The end result would be to have a descending latency sort of works
> > per cpu workqueue threads (or better: per workqueue group).
> > 
> > What do you think?
> 
> 
> 
> 
> 

