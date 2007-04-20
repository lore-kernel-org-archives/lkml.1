Return-Path: <linux-kernel-owner+w=401wt.eu-S1767056AbXDTKq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767056AbXDTKq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 06:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767058AbXDTKq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 06:46:57 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37346 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767056AbXDTKq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 06:46:56 -0400
Date: Fri, 20 Apr 2007 16:16:47 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, vatsa@in.ibm.com,
       paulmck@us.ibm.com, pavel@ucw.cz
Subject: Re: [RFC PATCH(experimental) 2/2] Fix freezer-kthread_stop race
Message-ID: <20070420104647.GA11290@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com> <20070419120419.GB17069@in.ibm.com> <20070419143133.a6c82ef8.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419143133.a6c82ef8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 02:31:33PM -0700, Andrew Morton wrote:
> On Thu, 19 Apr 2007 17:34:19 +0530
> Gautham R Shenoy <ego@in.ibm.com> wrote:
> 
> 
> flush_workqueue() just needs to die.  I think there are (almost) no
> legitimate users of it once cancel_work_sync() is merged.
> 
> > This patch attempts to address such a situation with a fix for kthread_stop.
> 
> Via wholly undescribed means :(

Sorry. I will document stuff better next time.
> 
> > Strictly experimental. Compile tested on i386.
> 
> Rather than doing <whatever you did>, perhaps we could make the freezing
> process a dual-pass thing.  On pass 1, mark all the threads as "we'll be
> freezing you soon" and on the second pass, do the actual freezing.  Then,
> in problematic places such as kthread_stop() we can look to see if we'll
> soon be asked to freeze and if so, run try_to_freeze().

We can do that. Just that the freezer will now have to wait for 2 sets
of ack's instead of 1 set before declaring the system as frozen.

But the whole point of the patch was so that a thread A can tell
a thread B that it's dependent on the latter, and hence would like
to postpone B's freezing for some time. So I am thinking if we can
achieve this through the scheme you described.

> 
> Of course, running try_to_freeze() in kthread_stop() would be very wrong,
> so we'd actually need to do it in callers, preferably via a new
> kthread_stop_freezeable() wrapper.
> 

Well, even then we'll need to ensure that a thread would not call
kthread_stop_freezeable() with any locks held. That would mean more
audits :)

> And the two-pass-freeze thing is of course racy.  It's also unnecessary:
> setting a flag on every task in the machine is equivalent to setting a
> global variable.  So perhaps just use a global variable?
> 
> int kthread_stop_freezeable(struct task_struct *k)
> {
> 	if (freeze_state == ABOUT_TO_START) {
> 		wait_for(freeze_state == STARTED);
> 		try_to_freeze();
> 	}
> 	kthread_stop(k);
> }
> 
> which is theoretically racy if another freeze_processes() starts
> immediately.  Anyway - please have a think about it ;)
> 

Sure, am already thinking about it :)

> > +static struct freezer_status_struct freezer_status = {
> > +				.lock = SPIN_LOCK_UNLOCKED,
> > +				.count = 0,
> > +			};
> 
> SPIN_LOCK_UNLOCKED is deprecated (it subverts lockdep)
> 

Ok, will change it to __SPIN_LOCK_UNLOCKED(freezer_status.lock)

> >  static inline int freezeable(struct task_struct * p)
> >  {
> >  	if ((p == current) ||
> > @@ -45,7 +55,8 @@ void refrigerator(void)
> >  		 * *after* the freezer did the freezeable() check
> >  		 * on us.
> >  		 */
> > -		if (current->flags & PF_NOFREEZE) {
> > +		if ((current->flags & PF_NOFREEZE) ||
> > +		    test_tsk_thread_flag(current, TIF_FREEZER_HELD)) {
> >  			clear_tsk_thread_flag(current, TIF_FREEZE);
> >  			task_unlock(current);
> >  			return;
> > @@ -63,12 +74,16 @@ void refrigerator(void)
> >  	recalc_sigpending(); /* We sent fake signal, clean it up */
> >  	spin_unlock_irq(&current->sighand->siglock);
> >  
> > +	task_lock(current);
> >  	for (;;) {
> >  		set_current_state(TASK_UNINTERRUPTIBLE);
> >  		if (!frozen(current))
> >  			break;
> > +		task_unlock(current);
> >  		schedule();
> > +		task_lock(current);
> >  	}
> > +	task_unlock(current);
> >  	pr_debug("%s left refrigerator\n", current->comm);
> >  	current->state = save;
> 
> I guess we should use set_current_state() here.
> 
> > +
> > +	if (thaw_user_space) {
> > +		spin_lock(&freezer_status.lock);
> > +			if (freezer_status.count < 0)
> > +				freezer_status.count++;
> > +		spin_unlock(&freezer_status.lock);
> > +	}
> >  }
> 
> whitespace went wrong
>

Huh! yeah, dunno how though.

> > +#define TIF_FREEZER_HELD	21	/* is temporarily holding up the
> > +					 * process freezer
> > +					 */
> >  
> >  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> >  #define _TIF_SYSCALL_AUDIT	(1 << TIF_SYSCALL_AUDIT)
> > @@ -102,6 +105,7 @@ struct thread_info {
> >  #define _TIF_MCA_INIT		(1 << TIF_MCA_INIT)
> >  #define _TIF_DB_DISABLED	(1 << TIF_DB_DISABLED)
> >  #define _TIF_FREEZE		(1 << TIF_FREEZE)
> > +#define _TIF_FREEZER_HELD	(1 << TIF_FREEZER_HELD)
> >  
> >  /* "work to do on user-return" bits */
> >  #define TIF_ALLWORK_MASK	(_TIF_NOTIFY_RESUME|_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
> > Index: linux-2.6.21-rc6/include/asm-mips/thread_info.h
> > ===================================================================
> > --- linux-2.6.21-rc6.orig/include/asm-mips/thread_info.h
> > +++ linux-2.6.21-rc6/include/asm-mips/thread_info.h
> > @@ -120,6 +120,7 @@ register struct thread_info *__current_t
> >  #define TIF_MEMDIE		18
> >  #define TIF_FREEZE		19
> >  #define TIF_ALLOW_FP_IN_KERNEL	20
> > +#define TIF_FREEZER_HELD	21
> >  #define TIF_SYSCALL_TRACE	31	/* syscall trace active */
> >  
> >  #define _TIF_SYSCALL_TRACE	(1<<TIF_SYSCALL_TRACE)
> > @@ -132,6 +133,7 @@ register struct thread_info *__current_t
> >  #define _TIF_USEDFPU		(1<<TIF_USEDFPU)
> >  #define _TIF_POLLING_NRFLAG	(1<<TIF_POLLING_NRFLAG)
> >  #define _TIF_FREEZE		(1<<TIF_FREEZE)
> > +#define _TIF_FREEZER_HELD	(1<<TIF_FREEZER_HELD)
> 
> hm, all this duplication is unpleasing.  We could do something similar to
> include/linux/buffer_head.h:BH_PrivateStart here: get all architectures to
> define a TIF_COMMON_STUFF_STARTS_HERE then include asm-generic/whatever.h
> which defines all the flags which every architecture must define, as
> TIF_COMMON_STUFF_STARTS_HERE+0, TIF_COMMON_STUFF_STARTS_HERE+1, etc.
> 

Ok.

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
