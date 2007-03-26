Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXCZIKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXCZIKX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 04:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbXCZIKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 04:10:22 -0400
Received: from mail.gmx.net ([213.165.64.20]:46724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932893AbXCZIKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 04:10:18 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HxKJ55/aHIHlP0z4CE+Sk2Tf7/IvWfJShk+bvev
	15hgsVLsgrzPrA
Subject: Re: rSDl cpu scheduler version 0.34-test patch
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: linux list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703261719.01444.kernel@kolivas.org>
References: <200703261100.22467.kernel@kolivas.org>
	 <1174885253.7040.57.camel@Homer.simpson.net>
	 <200703261719.01444.kernel@kolivas.org>
Content-Type: text/plain
Date: Mon, 26 Mar 2007 10:10:13 +0200
Message-Id: <1174896613.6664.30.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 17:19 +1000, Con Kolivas wrote:
> On Monday 26 March 2007 15:00, Mike Galbraith wrote:
> > On Mon, 2007-03-26 at 11:00 +1000, Con Kolivas wrote:
> > > This is just for testing at the moment! The reason is the size of this
> > > patch.
> >
> > (no testing done yet, but I have a couple comments)
> >
> > > In the interest of evolution, I've taken the RSDL cpu scheduler and
> > > increased the resolution of the task timekeeping to nanosecond
> > > resolution.
> >
> > +	/* All the userspace visible cpu accounting is done here */
> > +	time_diff = now - p->last_ran;
> > ...
> > +		/* cpu scheduler quota accounting is performed here */
> > +		if (p->policy != SCHED_FIFO)
> > +			p->time_slice -= time_diff;
> >
> > If we still have any jiffies resolution clocks out there, this could be
> > a bit problematic.
> 
> Works fine with jiffy only resolution. sched_clock just returns the change 
> when it happens. This leaves us with the accuracy of the previous code on 
> hardware that doesn't give higher resolution time from sched_clock.

I was thinking about how often you could zip through there with zero
change to time_slice.  Yeah, I suppose the net effect may be about the
same as dodged ticks.

> > +static inline void enqueue_pulled_task(struct rq *src_rq, struct rq *rq,
> > +				       struct task_struct *p)
> > +{
> > +	int queue_prio;
> > +
> > +	p->array = rq->active; <== set
> > +	if (!rt_task(p)) {
> > +		if (p->rotation == src_rq->prio_rotation) {
> > +			if (p->array == src_rq->expired) { <== evaluate
> 
> I don't see a problem.

p->array can be set to rq->active and evaluate to src_rq->expired?
 
> > +static void recalc_task_prio(struct task_struct *p, struct rq *rq)
> > +{
> > +	struct prio_array *array = rq->active;
> > +	int queue_prio;
> > +
> > +	if (p->rotation == rq->prio_rotation) {
> > +		if (p->array == array) {
> > +			if (p->time_slice > 0)
> > +				return;
> > +			p->time_slice = p->quota;
> > +		} else if (p->array == rq->expired) {
> > +			queue_expired(p, rq);
> > +			return;
> > +		} else
> > +			task_new_array(p, rq);
> > +	} else
> >
> > Dequeueing a task still leaves a stale p->array laying around to be
> > possibly evaluated later.
> 
> I don't see quite why that's a problem. If there's memory of the last dequeue 
> and it enqueues at a different rotation it gets ignored. If it enqueues 
> during the same rotation then that memory proves useful for ensuring it 
> doesn't get a new full quota. Either way the array is always updated on 
> enqueue so it wont be trying to add it to the wrong runlist.
> 
> > try_to_wake_up() doesn't currently evaluate 
> > and set p->rotation (but should per design doc),
> 
> try_to_wake_up->activate_task->enqueue_task->recalc_task_prio which updates 
> p->rotation

As I read it, it's task_new_array() which sets p->rotation, _after_
recalc_task_prio() has evaluated it to see if the task should continue
it's rotation or not.  The mechanism which ensures that sleeping tasks
can only get their fair share, as I understand it, is that they continue
their rotation on wakeup with their bitmap intact.  That appears to
indeed be the way same cpu wakeups are handled.  In the cross-cpu wakeup
case, it can't do anything but call task_new_array(), because the
chances that p->rotation being the same as the rotation number of the
new queue is practically nil, wherein the tasks bitmap is zeroed, ie it
starts over every time it changes cpu.  No?

	-Mike

