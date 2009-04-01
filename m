Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbZDATIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbZDATIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932204AbZDATId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:08:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42073 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbZDATIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:08:32 -0400
Date: Wed, 1 Apr 2009 21:04:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Message-ID: <20090401190445.GA16033@redhat.com>
References: <20090331145947.A12565@sedona.ch.intel.com> <20090401001729.GC28228@redhat.com> <928CFBE8E7CB0040959E56B4EA41A77E926D5093@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E926D5093@irsmsx504.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01, Metzger, Markus T wrote:
>
> >-----Original Message-----
> >From: Oleg Nesterov [mailto:oleg@redhat.com]
> >Sent: Wednesday, April 01, 2009 2:17 AM
> >To: Metzger, Markus T
>
> >> +static void wait_to_unschedule(struct task_struct *task)
> >> +{
> >> +	unsigned long nvcsw;
> >> +	unsigned long nivcsw;
> >> +
> >> +	if (!task)
> >> +		return;
> >> +
> >> +	if (task == current)
> >> +		return;
> >> +
> >> +	nvcsw  = task->nvcsw;
> >> +	nivcsw = task->nivcsw;
> >> +	for (;;) {
> >> +		if (!task_is_running(task))
> >> +			break;
> >> +		/*
> >> +		 * The switch count is incremented before the actual
> >> +		 * context switch. We thus wait for two switches to be
> >> +		 * sure at least one completed.
> >> +		 */
> >> +		if ((task->nvcsw - nvcsw) > 1)
> >> +			break;
> >> +		if ((task->nivcsw - nivcsw) > 1)
> >> +			break;
> >> +
> >> +		schedule();
> >
> >schedule() is a nop here. We can wait unpredictably long...
>
> Hmmm, As far as I understand the code, rt-workqueues use a higher sched_class
> and can thus not be preempted by normal threads. Non-rt workqueues
> use the fair_sched_class. And schedule_work() uses a non-rt workqueue.

I was unclear, sorry.

I meant, in this case

	while (!CONDITION)
		schedule();

is not better compared to

	while (!CONDITION)
		; /* do nothing */

(OK, schedule() is better without CONFIG_PREEMPT, but this doesn't matter).
wait_to_unschedule() just spins waiting for ->nXvcsw, this is not optimal.

And another problem, we can wait unpredictably long, because

> In practice, task is ptraced. It is either stopped or exiting.
> I don't expect to loop very often.

No. The task _was_ ptraced when we called (say) ptrace_detach(). But when
work->func() runs, the tracee is not traced, it is running (not necessary
of course, the tracer _can_ leave it in TASK_STOPPED).

Now, again, suppose that this task does "for (;;) ;" in user-space.
If CPU is "free", it can spin "forever" without re-scheduling. Yes sure,
this case is not likely in practice, but still.

Oleg.

