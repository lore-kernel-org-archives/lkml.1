Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbXDMJsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbXDMJsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 05:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbXDMJsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 05:48:10 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34524 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbXDMJsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 05:48:08 -0400
Date: Fri, 13 Apr 2007 15:16:42 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, akpm@linux-foundation.org,
       paulmck@us.ibm.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mingo@elte.hu, dipankar@in.ibm.com, dino@in.ibm.com,
       masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 7/8] Clean up workqueue.c with respect to the freezer based cpu-hotplug
Message-ID: <20070413094642.GA9992@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402054206.GG12962@in.ibm.com> <20070403114729.GA776@tv-sign.ru> <20070403135919.GB32444@in.ibm.com> <20070403150336.GA850@tv-sign.ru> <20070403171820.GA8646@in.ibm.com> <20070412022220.GA10176@in.ibm.com> <20070412160004.GA4183@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412160004.GA4183@tv-sign.ru>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 08:00:04PM +0400, Oleg Nesterov wrote:
> On 04/12, Srivatsa Vaddagiri wrote:
> >
> > On Tue, Apr 03, 2007 at 10:48:20PM +0530, Srivatsa Vaddagiri wrote:
> > > > Actually, we should do this before destroy_workqueue() calls flush_workqueue().
> > > > Otherwise flush_cpu_workqueue() can hang forever in a similar manner.
> > > 
> > > Yep. I guess these are a class of freezer deadlocks very similar to vfork
> > > parent waiting on child case. I get a feeling these should become common
> > > outside of kthread too (A waits on B for something, B gets frozen, which
> > > means A won't freeze causing freezer to fail). Can freezer detect this
> > > dependency somehow and thaw B automatically? Probably not that easy ..
> > 
> > I wonder if there is some value in "enforcing" an order in which
> > processes get frozen i.e freeze A first before B. That may solve the
> > deadlocks we have been discussing wrt kthread_stop and flush_workqueue
> > as well.
> 
> Perhaps we can add "atomic_t xxx" to task_struct.
> 
> 	int freezing(struct task_struct *p)
> 	{
> 		return test_tsk_thread_flag(p, TIF_FREEZE)
> 			&& atomic_read(&p->xxx) == 0;
> 	}
> 
> 	void xxx_start(struct task_struct *p)
> 	{
> 		atomic_inc(p->xxx);
> 		thaw_process(p);
> 	}
> 
> 	xxx_end(struct task_struct *p)
> 	{
> 		atomic_dec(p->xxx);
> 	}
> 
> Now,
> 
> 	xxx_start(p);
> 	... wait for something which depends on p...
> 	xxx_end(p);
> 
> Of course we need other changes, freeze_process() should check ->xxx, etc.
> I am not sure this makes sense.

I think this is racy.
Say, if the task which does xxx_start(p) [let's call it task q] is not freezeable, and task p is
already frozen when q  calls xxx_start, then we might be in a situation
where 

- Freezer has declared the whole system to be frozen. Hence the thread
  issuing the 'freeze'(suspend/hotplug) can go ahead and do whatever it wants to.

- Task 'p' which was supposed to be frozen , is now running and
  *surprise* We have a thread running on a cpu which ain't there any more!

I feel we need some kind of a global rwlock. 


DEFINE_RWLOCK(freezer_status_lock);
int  xxx_start(struct task_struct *p)
{
	int ret = 0;
	ret = read_trylock(&freezer_status_lock);
	if(ret) 
	 /* We've succeeded. So lets thaw the chap */
	 thaw_process(p);
	/* If we've failed to acquire trylock, that means freezer doesn't 
	 * depend on us.
	 * So lets simply wait without thawing p
	 */
	
	return ret;

}


void xxx_end(int state)
{
	if(state)
		read_unlock(&freezer_status_lock);
}


int try_to_freeze_tasks()
{
	do {
		/* The regular freezer code */

		if (!todo && !write_trylock(&freezer_status_lock));
			continue;
		/* When the freezer goes back, it will find task 'p'
		 * woken up and hence wait for it to get frozen
		 */
	}while(todo);
}

void try_to_thaw_tasks()
{
	.
	.
	.
	write_unlock(&freezer_status_lock);
}


	int state = xxx_start(p);
	... wait for something which depends on p...
 	xxx_end(state);

However, now that I look at it again, I see that it will fail in our case
where we might need to nest the try_to_freeze_tasks call.

Hmm, we don't have a rwlock variant that allows multiple writers, now do
we?!


> 
> Oleg.
> 

Thanks and Regards
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
