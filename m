Return-Path: <linux-kernel-owner+w=401wt.eu-S1752834AbYKYVJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbYKYVJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:09:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752121AbYKYVJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:09:03 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60171 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYKYVJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:09:01 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 25 Nov 2008 13:08:58 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Tejun Heo <tj@kernel.org>, Eric Van Hensbergen <ericvh@gmail.com>,
       Ron Minnich <rminnich@sandia.gov>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Brad Boyer <flar@allandria.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Roland McGrath <roland@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: + poll-allow-f_op-poll-to-sleep-take-4.patch added to -mm tree
In-Reply-To: <20081125173032.GA21539@redhat.com>
Message-ID: <alpine.DEB.1.10.0811251151540.32523@alien.or.mcafeemobile.com>
References: <20081125173032.GA21539@redhat.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2008, Oleg Nesterov wrote:

> > +static int pollwake(wait_queue_t *wait, unsigned mode, int sync, void *key)
> > +{
> > +	struct poll_wqueues *pwq = wait->private;
> > +	DECLARE_WAITQUEUE(dummy_wait, pwq->polling_task);
> > +
> > +	set_mb(pwq->triggered, 1);
> > +
> > +	/*
> > +	 * Perform the default wake up operation using a dummy
> > +	 * waitqueue.
> > +	 *
> > +	 * TODO: This is hacky but there currently is no interface to
> > +	 * pass in @sync.  @sync is scheduled to be removed and once
> > +	 * that happens, wake_up_process() can be used directly.
> > +	 */
> > +	return default_wake_function(&dummy_wait, mode, sync, key);
> > +}
> > +
> > +int poll_schedule_timeout(struct poll_wqueues *pwq, int state,
> > +			  ktime_t *expires, unsigned long slack)
> > +{
> > +	int rc = -EINTR;
> > +
> > +	set_current_state(state);
> > +	if (!pwq->triggered)
> > +		rc = schedule_hrtimeout_range(expires, slack, HRTIMER_MODE_ABS);
> > +	__set_current_state(TASK_RUNNING);
> 
> So, why do we need this mb() in pollwake() ?
> 
> try_to_wake_up() has a full barrier semantics, note the wmb() before
> task_rq_lock(). Since spin_lock() itself is STORE, the setting of
> pwq->triggered can't be further re-ordered with the reading of p->state.

Agreed.



> > +	/* clear triggered for the next iteration */
> > +	pwq->triggered = 0;
> 
> And don't we (in theory) actually need the mb() here instead?
> 
> Let's suppose do_poll() starts the next iteration, so we are doing
> 
> 	pwq->triggered = 0;
> 
> 	->poll(file)
> 		if (!check_file(file))
> 			return 0;
> 
> 		return POLLXXX;
> 
> We don't have any barriers in between (unless fget_light bumps
> ->f_count), so this can be reordered as
> 
> 	->poll(file)
> 		if (!check_file(file))
> 			return 0;
> 
> 		pwq->triggered = 0;
> 
> And, if pollwake() happens in between we can miss the event, no?

About ->triggered, on the sys_poll() side we have:

do_pollfd()
	file->f_op->poll()
		poll_wait(file, QUEUE, WAIT);
			add_wait_queue(QUEUE, WAIT);
				spin_lock(QUEUE->lock);
				...
				spin_unlock(QUEUE->lock);
		return dev->events;
...
set_current_state(TASK_INTERRUPTIBLE);
if (!got_events && !triggered)
	schedule();

Device side:

dev->events = XXXX;
__wake_up(QUEUE);
	spin_lock(QUEUE->lock);
	pollwake(WAIT);
		triggered = 1;
		default_wake_function();
			__try_to_wake_up();
	spin_unlock(QUEUE->lock);

AFAICS,  because of  the  lock taken,  and  because of the 
set_current_state()/schedule() logic, there's no need on any ->triggered 
synchronization.
Either we're on the device QUEUE, or we see the new dev->events, so no 
wakeup or events can be lost.
The only thing that can happen, is that a device before this reported 
events ready, so we're following up the loop with WAIT==NULL and 
poll_wait() not dropping into the QUEUE (hence not grabbing the QUEUE 
lock). But at that point it doesn't matter because got_events!=0.
IMO there's no need for any mb() on ->triggered. Check?



- Davide


