Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZGJSIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZGJSIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZGJSIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:08:10 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:49621 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbZGJSIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mecJwTcfcRCBr0g1iM8zLyJGgcFEV/wQN12i6NvMQDC5TxmwOSV3SUNGQ6/NyWy1b0
         m+15czJSno5Erb1d8Y27a3Oi0wkkkD3tCPNwWCrtjVCVcBklM4i2gMRN5IsRtNNi+qe5
         IwTAIjGze7wCqtL3v6f0pYHHNMvODdae2HLiE=
Date: Fri, 10 Jul 2009 20:08:03 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Move the sleeping while atomic checks early in
	cond_resched()
Message-ID: <20090710180801.GA5271@nowhere>
References: <20090710161034.GB22049@elte.hu> <1247246098-5627-1-git-send-email-fweisbec@gmail.com> <1247247810.6042.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247247810.6042.5.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 07:43:30PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-10 at 19:14 +0200, Frederic Weisbecker wrote:
> > might_sleep() is called lately in cond_resched(), after the
> > need_resched()/preempt enabled/system running tests are checked.
> > 
> > It's better to check the sleeps while atomic earlier and not depend
> > on some environment datas that reduce the chances to detect a
> > problem.
> > 
> > Changes in v2:
> > - call __might_sleep() directly instead of might_sleep() which may call
> >   cond_resched()
> > - turn cond_resched() into a macro so that the file:line couple reported
> >   refers to the caller of cond_resched() and not __cond_resched() itself.
> > - drop the obsolete CONFIG_PREEMPT_BKL related zones
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  include/linux/sched.h |   22 +++++++---------------
> >  kernel/sched.c        |    5 ++---
> >  2 files changed, 9 insertions(+), 18 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 0cb0d8d..737f569 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2276,23 +2276,15 @@ static inline int need_resched(void)
> >   * cond_resched_softirq() will enable bhs before scheduling.
> >   */
> >  extern int _cond_resched(void);
> > -#ifdef CONFIG_PREEMPT_BKL
> > -static inline int cond_resched(void)
> > -{
> > -	return 0;
> > -}
> > -#else
> > -static inline int cond_resched(void)
> > -{
> > -	return _cond_resched();
> > -}
> > -#endif
> > +#define cond_resched() ({			\
> > +	__might_sleep(__FILE__, __LINE__);	\
> > +	_cond_resched();			\
> > +})
> 
> I don't think this will compile for !CONFIG_DEBUG_SPINLOCK_SLEEP.


Ahh, right.

 
> >  extern int cond_resched_lock(spinlock_t * lock);
> >  extern int cond_resched_softirq(void);
> > -static inline int cond_resched_bkl(void)
> > -{
> > -	return _cond_resched();
> > -}
> > +
> > +#define cond_resched_bkl()	cond_resched();
> 
> We might as well convert the one user of this ;-)


Ok :)


> >  /*
> >   * Does a critical section need to be broken due to another
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 87ecac1..649ec92 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -6605,9 +6605,6 @@ SYSCALL_DEFINE0(sched_yield)
> >  
> >  static void __cond_resched(void)
> >  {
> > -#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
> > -	__might_sleep(__FILE__, __LINE__);
> > -#endif
> >  	/*
> >  	 * The BKS might be reacquired before we have dropped
> >  	 * PREEMPT_ACTIVE, which could trigger a second
> > @@ -6644,6 +6641,7 @@ int cond_resched_lock(spinlock_t *lock)
> >  
> >  	if (spin_needbreak(lock) || resched) {
> >  		spin_unlock(lock);
> > +		__might_sleep(__FILE__, __LINE__);
> >  		if (resched && need_resched())
> >  			__cond_resched();
> >  		else
> > @@ -6661,6 +6659,7 @@ int __sched cond_resched_softirq(void)
> >  
> >  	if (need_resched() && system_state == SYSTEM_RUNNING) {
> >  		local_bh_enable();
> > +		__might_sleep(__FILE__, __LINE__);
> >  		__cond_resched();
> >  		local_bh_disable();
> >  		return 1;
> 
> Right, how about renaming these to _cond_resched_{lock,softirq}, and
> added a __might_sleep() definition for !DEBUG_SPINLOCK_SLEEP and add
> macro wrappers to sched.c for these two as well?

I did that first but thought that might_sleep() would fail in a spinlock
held or softirq context, right?

