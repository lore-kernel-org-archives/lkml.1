Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZCJNkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZCJNkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 09:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbZCJNk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 09:40:29 -0400
Received: from www.tglx.de ([62.245.132.106]:33005 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753699AbZCJNk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 09:40:27 -0400
Date: Tue, 10 Mar 2009 14:39:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
In-Reply-To: <49B5F17C.8020100@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903101242580.29264@localhost.localdomain>
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <alpine.LFD.2.00.0903071652350.29264@localhost.localdomain> <49B5F17C.8020100@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Mar 2009, Darren Hart wrote:
> Thomas Gleixner wrote:
> > > +			int has_timeout;
> > 
> > Hmm. time == 0 perhaps or just add another flag bit to the flags field ?
> 
> I've created FLAGS_HAS_TIMEOUT and use that instead.  I opted for this
> approach instead of using time==0 as that seemed like it could be confused for
> an expired timer.

Yup. Preferred solution.
 
> > > +	/*
> > > +	 * The pifutex has an owner, make sure it's us, if not complain
> > > +	 * to userspace.
> > > +	 * FIXME_LATER: handle this gracefully
> > 
> > We should do this right now. It's not that hard.
> 
> Hrm. So if another task owns the futex then POSIX says undefined scheduling be
> should be expected.  So failing here seems like a good way to encourage proper
> usage of the cond vars. 

Non predicatable != invalid usage

> Or can you think of a sane scenario in which the
> outer mutex should not be held prior to the call to cond_signal() or
> cond_broadcast()?  If you are thinking outside of glibc cond vars, then there
> are likely other gaps with this patch, such as only being able to requeue from
> non-pi to pi futexes.

No, I think about glibc and the madness of existing code. Code just
relies on that and it works with the current glibc implementation so
making the enhanced requeue_pi behave different will break existing
applications and has to be considered as a regression.
 
> That being said... now that this is more or less implemented, I'm not sure
> there is really anything I'd need to do different to support this.  I'll pour
> over this for a while and see if there are any gotchas that I'm missing right
> now.

I think you have everything what you need already except of some minor
tweaks.
 
> > 
> > > +	 */
> > > +	pid = curval & FUTEX_TID_MASK;
> > > +	if (pid && pid != task_pid_vnr(current))
> > > +		return -EMORON;
> > 
> > Though it's a pity that we lose EMORON :)
> 
> 
> Does that mean I'll have to forfeit the nickname bestowed upon me by LWN?
> I've received numerous comments on this line - all of them in favor.
> Apparently lots of kernel developers are eager for a way to slyly mock users
> from within the context of the kernel.  ;-)

Send a separate patch then. You have my Acked-by :)
 
> > > +/*
> > > + * Requeue all waiters hashed on one physical page to another physical
> > > page.
> > > + * In the requeue_pi case, either takeover uaddr2 or set FUTEX_WAITERS
> > > and
> > > + * setup the pistate.  FUTEX_REQUEUE_PI only supports requeueing from a
> > > non-pi
> > > + * futex to a pi futex.
> > >  */
> > > static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user
> > > *uaddr2,
> > > -			 int nr_wake, int nr_requeue, u32 *cmpval)
> > > +			 int nr_wake, int nr_requeue, u32 *cmpval,
> > > +			 int requeue_pi)
> > > {
> > > 	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
> > > 	struct futex_hash_bucket *hb1, *hb2;
> > > 	struct plist_head *head1;
> > > 	struct futex_q *this, *next;
> > > -	int ret, drop_count = 0;
> > > +	u32 curval2;
> > > +	struct futex_pi_state *pi_state = NULL;
> > > +	int drop_count = 0, attempt = 0, task_count = 0, ret;
> > > +
> > > +	if (requeue_pi && refill_pi_state_cache())
> > > +		return -ENOMEM;
> > 
> >   Why do you want to refill the pi_state_cache of current ? current is
> >   not going to wait for the pi_futex.
> 
> 
> I may need to allocate a pi_state during
> futex_requeue_pi_init()->futex_lock_pi_atomic()->lookup_pi_state(). Making use
> of this current->pi_cache seemed like the best way to do it.  Is there a more
> appropriate place to store a preallocated pi_state?

Hmm. You are right. That's the best way to have one handy.
 
> > > +		if (requeue_pi &&
> > > +		    ((curval2 & FUTEX_TID_MASK) != task_pid_vnr(this->task)))
> > > {
> > 
> >   Why don't you check the owner of the rtmutex, which we installed
> >   already ? Then we can drop this curval2 business altogether.
> 
> 
> Because we can own the futex without an rt_mutex existing.  The first time
> through this loop we consider the top_waiter of uaddr1.  If uaddr2 had no
> owner, then it is now owned by the top_waiter, but since there are still no
> waiters on uaddr2, the rt_mutex has not been initialized. Once we know we are
> not the owner, then we also know the pi_state->pi_mutex exists.
> 
> Hrm.... I suppose a test for "!this->pi_state" is equivalent to
> "(curval2 & FUTEX_TID_MASK) != task_pid_vnr(this->task)" then isn't it...?
> Seems like a rather fragile test though doesn't it?
> 
> We wouldn't save much by eliminating the curval2 here though since
> futex_requeue_pi_init needs it for the atomic_lock, so we still need the fault
> logic... unfortunatley.
> 
> Thoughts?

In futex_requeue_pi_init() we figure already out who owns the
futex, right ? So why don't we capture that information ?

> > > +	if (abs_time) {
> > > +		unsigned long slack;
> > 
> >   Missing new line. Also this is nonsense. A rt task should have set
> >   its timer_slack_ns to 0, so we can just use current->timer_slack_ns
> >   in the hrtimer_set_expires_range_ns(). If the timer_slack_ns is
> >   random for rt_tasks then we need to fix this in general.
> > 
> 
> 
> Added a WARN_ON(!current->timer_slack_ns) to my debug patch and used that
> value here.  I'll create a patch to futex-fixes to address the existing calls
> that I copied this approach from.

Thanks.

> >   Also the logic is completely backwards here. It has to be the same
> >   as in futex_wait()
> 
> 
> Is it broken?  I believe the reason I wrote it as I did was because the ret ==
> 0 case should be very rare here.  Infact, it is an error.  The only reason we
> should wake on the first futex (uaddr) is on a signal or a timeout, otherwise
> the user most likely paired a FUTEX_WAKE_REQUEUE_PI  with FUTEX_WAKE, instead
> of FUTEX_REQUEUE_PI.
> 
> I can change it around if you have a strong preference though (or if it's
> broken in some way I'm missing of course).

The 0 case might be rare, but it is definitely not an error.

    futex_wait_queue_me(hb, &q, to);
    	queue_me();
	    drops hb->lock;

    unqueue_me() is called w/o the hb->lock held, so we can race here
    against a requeue_pi wakeup.

    So we need to check the unqueue_me() == 0 case first and check
    whether we got requeued.

    The requeue check is done unlocked, so the requeue and wakeup
    might happen between the check and unqueue_me().

But this needs more thoughts about locking and possible races. The
whole code sequence here screams "can you debug the nasty races here ?"

> > > +	/* FIXME: this test is REALLY scary... gotta be a better way...
> > > +	 * If the pi futex was uncontended, futex_requeue_pi_init() gave us
> > > +	 * the lock.
> > > +	 */
> > 
> >   Didn't we take the rtmutex as well ??
> 
> 
> Not necessarily.  If the pi futex was ownerless and there was only one task
> requeued, then there is no rtmutex as it is created by the first waiter.
> 
> It is possible that other tasks have since tried to take this mutex and now
> there is an rtmutex, but we have to catch the case where there might not be
> one.

Fair enough.

> > 
> > > +	if (!q.pi_state) {

Again. This check might be racy.

> > > +		ret = 0;
> > > +		goto out;
> > > +	}
> > > +	pi_mutex = &q.pi_state->pi_mutex;
> > > +
> > > +	ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
> > 
> > 
> >   Eeek. We got a wakeup _after_ we have been requeued. So now you go
> >   back to sleep on the pi_mutex ?
> 
> 
> Yes.  The futex_requeue() calls wake_up() which allows the waiter here to wake
> and continue processing it's half of the rt_mutex acquisition loop that I
> split out of rt_mutex_slowlock() in rt_mutex_finish_proxy_lock().
 
Ah, ok. We try to get the rt_mutex there as we are only the designated
owner. If we fail, then we go back to sleep.
 
Thanks,

	tglx
