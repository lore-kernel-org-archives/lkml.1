Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbZBCRwL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbZBCRwL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 12:52:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbZBCRvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 12:51:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51362 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665AbZBCRvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 12:51:54 -0500
Subject: Re: [RFC] process wide itimer cruft
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090203172305.GA11285@redhat.com>
References: <1233473426.2604.13.camel@ymzhang>
	 <d3f22a0902010026q1db36381j36cb1c9803d48431@mail.gmail.com>
	 <1233476961.13659.12.camel@minggr.sh.intel.com>
	 <1233479836.4787.63.camel@laptop> <1233482239.4787.65.camel@laptop>
	 <1233537134.2604.24.camel@ymzhang> <1233564818.4787.107.camel@laptop>
	 <1233662165.10184.33.camel@laptop>  <20090203172305.GA11285@redhat.com>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 18:51:39 +0100
Message-Id: <1233683499.10184.45.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-03 at 18:23 +0100, Oleg Nesterov wrote:
> On 02/03, Peter Zijlstra wrote:
> >
> > On Mon, 2009-02-02 at 09:53 +0100, Peter Zijlstra wrote:
> >
> > I'm punting the sum-all-threads work off to a workqueue,
> 
> I don't really understand how this works, but I didn't try to read
> this part carefully. For example, when we call thread_group_cputime()
> we don't really get the "group" statistics immediately? But this looks
> very interesting anyway.

Because our thread group can be extremely large and take longer than a
jiffy to sum up -- this is the situation that started all this itimer
tinkering.

However, Ingo spoke to me on IRC and suggested another approach, which
I'm currently working on -- hopefully done tomorrow.

> > The remaining option is to make signal struct itself rcu freed, but
> > before I do that, I thought I'd run this code by some folks.
> 
> I think we should follow the Ingo's suggestion: we should make ->signal
> refcountable, we should never clear task->signal, it should be freed
> by __put_task_struct()'s path.

Right, that'd make a lot of sense.

> In fact I was going to make this patches the previous week, will try
> to do this week. But we need another counter for that, we can't use
> signal->count.

I'm not quite sure I understand all that code quite yet, although I've
been staring at it for the past day or so.

->live  -- the number of associated tasks,
->count -- not quite a refcount?

I can see adding a 3rd counter for reference counting could solve
things, but can we start by clarifying the exact semantics of these two?
If only for future readers..

> This blows signal_struct a bit, but otoh with this change we can
> move some fields (for example, ->group_leader) to signal_struct.
> And we can do many simplifications. Just for example, __sched_setscheduler()
> takes ->siglock just to read signal->rlim[].

Could you shed a bit of light on the distinction between sighand and
signal?

> > @@ -96,14 +105,16 @@ static void __exit_signal(struct task_struct *tsk)
> >  	spin_lock(&sighand->siglock);
> >
> >  	posix_cpu_timers_exit(tsk);
> > -	if (atomic_dec_and_test(&sig->count))
> > +	if (!atomic_read(&sig->live)) {
> >  		posix_cpu_timers_exit_group(tsk);
> 
> This doesn't look exactly right, but I don't see the "real" problems
> with this change.
> 
> We can have a lot of threads which didn't even pass exit_notify(),
> another process can attach the cpu timer to us once we drop the
> locks. OK, no real problems afaics, because each sub-thread will
> in turn do posix_cpu_timers_exit_group() later.

Yeah, you can get multiple invocations of the
posix_cpu_timers_exit_group() stuff, and less summing if dead tasks, the
latter might be an issue.

> But this looks a bit too early. It is better to continue to account
> these threads, they can consume a lot of cpu. Anyway, this very
> minor issue.

Agreed.

> > -	else {
> > +		sig->curr_target = NULL;
> 
> complete_signal() can crash if it hits ->curr_target = NULL, and
> we are still "visible" to signals even if sig->live == 0.

Ooh, missed that. Good catch indeed.

> > +	} else {
> >  		/*
> >  		 * If there is any task waiting for the group exit
> >  		 * then notify it:
> >  		 */
> > -		if (sig->group_exit_task && atomic_read(&sig->count) == sig->notify_count)
> > +		if (sig->group_exit_task &&
> > +				atomic_read(&sig->live) == sig->notify_count)
> 
> This looks wrong. de_thread() can hang forever, put_signal() doesn't
> wake up ->group_exit_task.
> 
> I think we really need another counter, at least for now.

Don't rush on my account, Ingo's proposed solution doesn't need this. 

