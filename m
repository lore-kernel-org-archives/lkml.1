Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZCGPyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZCGPyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbZCGPyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:54:10 -0500
Received: from www.tglx.de ([62.245.132.106]:41818 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754937AbZCGPyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:54:09 -0500
Date: Sat, 7 Mar 2009 16:50:56 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Darren Hart <dvhltc@us.ibm.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       "lkml, " <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [TIP][RFC 6/7] futex: add requeue_pi calls
In-Reply-To: <49B0B43D.2030907@us.ibm.com>
Message-ID: <alpine.LFD.2.00.0903071645480.29264@localhost.localdomain>
References: <49AC73A9.4040804@us.ibm.com> <49AC77D1.6090106@us.ibm.com> <49AE3386.1070604@us.ibm.com> <49B00302.5000607@us.ibm.com> <49B07F87.2020808@us.ibm.com> <alpine.DEB.2.00.0903052119300.14535@gandalf.stny.rr.com> <49B0B43D.2030907@us.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Darren Hart wrote:
> int rt_mutex_start_proxy_lock(struct rt_mutex *lock,
> 			      struct rt_mutex_waiter *waiter,
> 			      struct task_struct *task, int detect_deadlock)
> {
> 	int ret;
> 
> 	spin_lock(&lock->wait_lock);
> 	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
> 
> 
> I add the following line to fix the bug.  Question is, should I use this
> atomic
> optimization here (under the lock->wait_lock) or should I just do "lock->owner
> |= RT_MUTEX_HAS_WAITERS" ?
> 
> =====>	mark_rt_mutex_waiters(lock);

This is still not enough as I explained in the review of the original
patch. What you need to do is:

	if (try_to_take_rt_mutex(lock, task)) {
	   	spin_unlock(&lock->wait_lock);
		/* The caller needs to wake up task, as it is now the owner */
		return WAKEIT;
	}

	ret = task_blocks_on_rt_mutex(lock, waiter, task, detect_deadlock);
 
> 	if (ret && !waiter->task) {
> 		/*
> 		 * Reset the return value. We might have
> 		 * returned with -EDEADLK and the owner
> 		 * released the lock while we were walking the
> 		 * pi chain.  Let the waiter sort it out.
> 		 */
> 		ret = 0;
> 	}
> 	spin_unlock(&lock->wait_lock);
> 
> 	debug_rt_mutex_print_deadlock(waiter);
> 
> 	return ret;
> }

Thanks,

	tglx
