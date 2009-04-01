Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbZDATxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbZDATxR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 15:53:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755163AbZDATxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 15:53:00 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:48975 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbZDATw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 15:52:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=FruhgSMyBOLaXfjSig/2xVbyMlsFfTpdHMC16POAqcNNavB8LClNmqzFd0K5pHycr4
         lHrVwkxeS+TVzvQsALsZvtoiAAelaeZCZBZCM9Z5aFaYy9z5DO7W0t84jLW/gbEqLP12
         Je3xK8SHBuz59xPc/fYzBuoATptQdwizhb29A=
Subject: Re: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Metzger, Markus T" <markus.t.metzger@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
In-Reply-To: <20090401190445.GA16033@redhat.com>
References: <20090331145947.A12565@sedona.ch.intel.com>
	 <20090401001729.GC28228@redhat.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E926D5093@irsmsx504.ger.corp.intel.com>
	 <20090401190445.GA16033@redhat.com>
Content-Type: text/plain
Date: Wed, 01 Apr 2009 21:52:47 +0200
Message-Id: <1238615567.18200.5.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 21:04 +0200, Oleg Nesterov wrote:
> On 04/01, Metzger, Markus T wrote:
> >
> > >-----Original Message-----
> > >From: Oleg Nesterov [mailto:oleg@redhat.com]
> > >Sent: Wednesday, April 01, 2009 2:17 AM
> > >To: Metzger, Markus T
> >
> > >> +static void wait_to_unschedule(struct task_struct *task)
> > >> +{
> > >> +	unsigned long nvcsw;
> > >> +	unsigned long nivcsw;
> > >> +
> > >> +	if (!task)
> > >> +		return;
> > >> +
> > >> +	if (task == current)
> > >> +		return;
> > >> +
> > >> +	nvcsw  = task->nvcsw;
> > >> +	nivcsw = task->nivcsw;
> > >> +	for (;;) {
> > >> +		if (!task_is_running(task))
> > >> +			break;
> > >> +		/*
> > >> +		 * The switch count is incremented before the actual
> > >> +		 * context switch. We thus wait for two switches to be
> > >> +		 * sure at least one completed.
> > >> +		 */
> > >> +		if ((task->nvcsw - nvcsw) > 1)
> > >> +			break;
> > >> +		if ((task->nivcsw - nivcsw) > 1)
> > >> +			break;
> > >> +
> > >> +		schedule();
> > >
> > >schedule() is a nop here. We can wait unpredictably long...
> >
> > Hmmm, As far as I understand the code, rt-workqueues use a higher sched_class
> > and can thus not be preempted by normal threads. Non-rt workqueues
> > use the fair_sched_class. And schedule_work() uses a non-rt workqueue.
> 
> I was unclear, sorry.
> 
> I meant, in this case
> 
> 	while (!CONDITION)
> 		schedule();
> 
> is not better compared to
> 
> 	while (!CONDITION)
> 		; /* do nothing */
> 
> (OK, schedule() is better without CONFIG_PREEMPT, but this doesn't matter).
> wait_to_unschedule() just spins waiting for ->nXvcsw, this is not optimal.
> 
> And another problem, we can wait unpredictably long, because
> 
> > In practice, task is ptraced. It is either stopped or exiting.
> > I don't expect to loop very often.
> 
> No. The task _was_ ptraced when we called (say) ptrace_detach(). But when
> work->func() runs, the tracee is not traced, it is running (not necessary
> of course, the tracer _can_ leave it in TASK_STOPPED).
> 
> Now, again, suppose that this task does "for (;;) ;" in user-space.
> If CPU is "free", it can spin "forever" without re-scheduling. Yes sure,
> this case is not likely in practice, but still.

So I should rather not call schedule()?

I thought it's better to yield the cpu than to spin.


I will resend a bisect-friendly version of the series (using quilt mail,
this time) tomorrow.

I will remove schedule() in the wait_to_unschedule() loop and also
address the minor nitpicks you mentioned in your other reviews.

thanks,
markus.


