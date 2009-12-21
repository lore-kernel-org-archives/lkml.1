Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZLUSqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZLUSqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 13:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbZLUSqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 13:46:43 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38785 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbZLUSql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 13:46:41 -0500
Date: Tue, 22 Dec 2009 00:16:31 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Patch 1/1] Introduce register_user_hbp_by_pid() and
	unregister_user_hbp_by_pid()
Message-ID: <20091221184631.GB24535@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091217172010.GB5457@in.ibm.com> <20091217172253.GC5457@in.ibm.com> <20091218204744.GC5004@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218204744.GC5004@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 09:47:48PM +0100, Frederic Weisbecker wrote:
> On Thu, Dec 17, 2009 at 10:52:53PM +0530, K.Prasad wrote:
> > Provide an interface to (un)register user-space breakpoints using a
> > process' pid.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  include/linux/hw_breakpoint.h |    8 +++
> >  kernel/hw_breakpoint.c        |   92 ++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 100 insertions(+)
> > 
<snipped>
> >  
> > +/*
> > + * Unregister breakpoints thread-by-thread, for all threads ranging from
> > + * @start to @end.
> > + */
> > +static inline void __unregister_user_hbp_for_threads(struct task_struct *start,
> > +						struct task_struct *end)
> 
> I'm not sure this wants to be inlined. The function is not not
> that tiny. May be let the compiler choose?

Okay...will make it just static.

> > +{
> > +	struct perf_event *bp, *temp_bp;
> > +
> > +	do {
> > +		mutex_lock(&start->perf_event_mutex);
> > +		list_for_each_entry_safe(bp, temp_bp, &start->perf_event_list,
> > +					 owner_entry) {
> > +			if (bp->attr.type != PERF_TYPE_BREAKPOINT)
> > +				continue;
> > +			unregister_hw_breakpoint(bp);
> > +			break;
> 
> Do you really want to unregister all of them? What about those
> that may have been registered using perf syscall?
> 

Seems that I got influenced heavily by the PPC64 design (was coding
simultaneously for it :-)...will accept a "struct perf_event_attr *" and
use that to identify appropriate breakpoint.

> > +/**
> > + * register_user_hbp_by_pid - register a hardware breakpoint for user space using pid
> > + * @attr: breakpoint attributes
> > + * @triggered: callback to trigger when we hit the breakpoint
> > + * @pid: pid of the thread group for which breakpoints must be registered
> > + */
> > +int register_user_hbp_by_pid(struct perf_event_attr *attr,
> > +			 perf_overflow_handler_t triggered,
> > +			 pid_t pid)
> > +{
> > +	int ret;
> > +	struct task_struct *t1, *t2;
> 
> This needs rcu_read_lock()
> 

Ok.

> > +	t1 = t2 = find_task_by_vpid(pid);
> > +	if (t1 == NULL)
> > +		return -ESRCH;
> > +
> > +	/*
> > +	 * Ensure that the breakpoint propogates to every new thread created in
> > +	 * this thread_group.
> > +	 */
> > +	attr->inherit = 1;
> > +	/*
> > +	 * Register a breakpoint individually for every thread of the
> > +	 * thread_group using register_user_hw_breakpoint() interface.
> > +	 * Warning: Involves redundant validation checks using
> > +	 * arch_validate_hwbkpt_settings().
> > +	 */
> > +	do {
> > +		ret = IS_ERR(register_user_hw_breakpoint(attr, triggered, t1));
> > +		if (ret)
> > +			goto fail;
> > +		t1 = next_thread(t1);
> > +	} while (t1 != t2);
> 
> And this needs rcu_read_unlock()
> 

Okay.

> > +	return 0;
> > +fail:
> > +	/*
> > +	 * Check if the very first register_user_hw_breakpoint() request
> > +	 * failed. If then, do nothing but return the error value.
> > +	 */
> > +	if (t1 == t2)
> > +		return ret;
> > +	/*
> > +	 * Since there exists a thread where the breakpoint request was not
> > +	 * successful, we are unable to provide a process-wide breakpoint. Hence
> > +	 * cleanup the breakpoints from the previously registered threads.
> > +	 */
> > +	__unregister_user_hbp_for_threads(t2, t1);
> 
> 
> There too.
> 
> Once you play with tasks (if it's not current), and iterate
> through these, you need to protect either by read-lock
> tasklist_lock or using rcu.
> 
> Rcu is the much prefered way here.
> 

Okay. I wasn't sure if I had taken sufficient locks....thanks for
pointing it out.

> > +/**
> > + * unregister_hbp_by_pid - unregister a user-space hardware breakpoint previously registered using a pid
> > + * @pid: pid of the process for which breakpoint must be unregistered
> > + */
> > +void unregister_user_hbp_by_pid(pid_t pid)
> > +{
> > +	struct task_struct *t1, *t2;
> > +
> > +	t1 = t2 = find_task_by_vpid(pid);
> > +	if (t1 == NULL)
> > +		return;
> > +
> > +	__unregister_user_hbp_for_threads(t1, t2);
> 
> 
> 
> And this function needs rcu too.
> 
> I don't see any in-kernel user for this new feature.
> That would be required to integrate it.
>

The proposed interfaces, as obvious, are mere wrappers over existing
(un)register_user_* interfaces, and don't do anything vastly different
in order to demonstrate them separately.

I can get a sample kernel module ready - that consumes pid and user-space
address to track write accesses, if you prefer it.

Thanks for reviewing the code!

-- K.Prasad

