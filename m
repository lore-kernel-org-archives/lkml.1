Return-Path: <linux-kernel-owner+w=401wt.eu-S1757760AbYLPPsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760AbYLPPsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYLPPrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:47:55 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:61334 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756331AbYLPPry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:47:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av8EABxXR0lMROB9/2dsb2JhbACBbLtyV5ECgn8
Date: Tue, 16 Dec 2008 10:47:48 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Baron <jbaron@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: sched: trace: update trace_sched_wakeup()
Message-ID: <20081216154748.GC6231@Krystal>
References: <1229411223.14605.48.camel@twins> <1229414244.14605.50.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1229414244.14605.50.camel@twins>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:47:07 up 29 days, 16:27,  3 users,  load average: 0.20, 0.50,
	0.88
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Tue, 2008-12-16 at 08:07 +0100, Peter Zijlstra wrote:
> > Add the information needed to distinguish 'real' wakeups from 'false'
> > wakeups.
> 
> I don't seem to be doing so well this morning...
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Thanks Dhaval!
> 

Applied a modified version into the 2.6.27.9 LTTng tree. Thanks!
(remembering that I should really move to 2.6.28-rc!)

Mathieu

> > ---
> >  include/trace/sched.h             |    4 ++--
> >  kernel/sched.c                    |    2 +-
> >  kernel/trace/trace_sched_switch.c |    2 +-
> >  kernel/trace/trace_sched_wakeup.c |    2 +-
> >  4 files changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/include/trace/sched.h b/include/trace/sched.h
> > index 9b2854a..a0861d2 100644
> > --- a/include/trace/sched.h
> > +++ b/include/trace/sched.h
> > @@ -17,8 +17,8 @@ DECLARE_TRACE(sched_wait_task,
> >  		TPARGS(rq, p));
> >  
> >  DECLARE_TRACE(sched_wakeup,
> > -	TPPROTO(struct rq *rq, struct task_struct *p),
> > -		TPARGS(rq, p));
> > +	TPPROTO(struct rq *rq, struct task_struct *p, int success),
> > +		TPARGS(rq, p, success));
> >  
> >  DECLARE_TRACE(sched_wakeup_new,
> >  	TPPROTO(struct rq *rq, struct task_struct *p),
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 0eff15b..953ded9 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2329,7 +2329,7 @@ out_activate:
> >  	success = 1;
> >  
> >  out_running:
> > -	trace_sched_wakeup(rq, p);
> > +	trace_sched_wakeup(rq, p, success);
> >  	check_preempt_curr(rq, p, sync);
> >  
> >  	p->state = TASK_RUNNING;
> > diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
> > index 8633905..d4db564 100644
> > --- a/kernel/trace/trace_sched_switch.c
> > +++ b/kernel/trace/trace_sched_switch.c
> > @@ -49,7 +49,7 @@ probe_sched_switch(struct rq *__rq, struct task_struct *prev,
> >  }
> >  
> >  static void
> > -probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee)
> > +probe_sched_wakeup(struct rq *__rq, struct task_struct *wakee, int success)
> >  {
> >  	struct trace_array_cpu *data;
> >  	unsigned long flags;
> > diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
> > index 0067b49..43586b6 100644
> > --- a/kernel/trace/trace_sched_wakeup.c
> > +++ b/kernel/trace/trace_sched_wakeup.c
> > @@ -211,7 +211,7 @@ static void wakeup_reset(struct trace_array *tr)
> >  }
> >  
> >  static void
> > -probe_wakeup(struct rq *rq, struct task_struct *p)
> > +probe_wakeup(struct rq *rq, struct task_struct *p, int success)
> >  {
> >  	int cpu = smp_processor_id();
> >  	unsigned long flags;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
