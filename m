Return-Path: <linux-kernel-owner+w=401wt.eu-S1752647AbZDOLqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbZDOLqW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754513AbZDOLqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:46:14 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51657 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZDOLqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:46:13 -0400
Date: Wed, 15 Apr 2009 13:45:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ftrace: introduce workqueue_handler_exit
	tracepoint and rename workqueue_execution to workqueue_handler_entry
Message-ID: <20090415114549.GA17775@elte.hu>
References: <20090413125653.6E01.A69D9226@jp.fujitsu.com> <20090413145105.6E07.A69D9226@jp.fujitsu.com> <20090413145159.6E0A.A69D9226@jp.fujitsu.com> <20090413162534.GI5977@nowhere> <20090415102257.GA2617@redhat.com> <20090415110937.GA27727@elte.hu> <20090415113359.GA5118@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415113359.GA5118@redhat.com>
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


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 04/15, Ingo Molnar wrote:
> >
> > * Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > > > >  		lock_map_acquire(&lockdep_map);
> > > > > +		trace_workqueue_handler_entry(cwq->thread, work);
> > > > >  		f(work);
> > > > > +		trace_workqueue_handler_exit(cwq->thread, work);
> > >
> > > This doesn't look right. We must not use "work" after f(work).
> > > work->func() can kfree its work.
> >
> > We can use it as long as we use it as a 'cookie' - i.e. an
> > identifier for visualization/statistics, but dont actually
> > dereference it, right?
> 
> Yes sure.
> 
> I do not know whether this matters or not, but just in case... Of 
> course it is possible that, when trace_workqueue_handler_exit() 
> runs, this memory was already reused for another work even without 
> kfree. For example,
> 
> 	void my_work_func(struct work_struct *work)
> 	{
> 		INIT_WORK(work, another_work_func);
> 		queue_work(another_workqueue, work);
> 	}
> 
> In this case another_workqueue can report 
> trace_workqueue_handler_entry() before my_work_func() returns.
> 
> This means that trace_workqueue_handler_exit() can't use the 
> address of work as a "key" to find some data recorded by _entry(). 
> Unless this data lives in cpu_workqueue_struct.
> 
> Not sure why I am trying to explain the things which are very 
> obvious to all ;) Just because I don't really understand what 
> these patches do.

The patches try to map and instrument the life cycle of a worklet, 
and the main actions that occur in the workqueue subsystem in 
general.

The purpose is instrumentation: for debugging purposes, for 
improving kernel code and for just understanding how the system 
functions and what its dynamic actions are.

In that sense the worklet 'key' possibly getting reallocated and 
reused before the 'completed' action was traced is probably not a 
big deal - but tools have to be aware of it possibly happening (and 
most not hard-code any assumption to the contrary).

Plus the exit handler must not dereference the worklet either. 
Safest would be to make this sure in the prototype already: pass in 
a void * key, not a work structure.

Thanks,

	Ingo
