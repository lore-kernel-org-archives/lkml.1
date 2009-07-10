Return-Path: <linux-kernel-owner+w=401wt.eu-S1755236AbZGJPIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236AbZGJPIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 11:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZGJPIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 11:08:37 -0400
Received: from ey-out-1920.google.com ([74.125.78.148]:63681 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbZGJPIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 11:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BO0QbVsh+bBGaVm8XHDTBleG5dr/6bf6WOB/OWjukm4wJll9R6T6UocuJ1Tsa2bbrb
         urUu74uwRK4Wj7UX9eYgqQB3nakGu9kxgi7Zvh+PI1yEP/FepU77Mrxq8iawIJ8iQJHi
         ybk5mTra6m3EG+pF7xcuCqAJAgF4obmyolsLU=
Date: Fri, 10 Jul 2009 17:08:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] sched: Move the sleeping while atomic checks early
	in cond_resched()
Message-ID: <20090710150827.GA5318@nowhere>
References: <1247237391-5352-1-git-send-email-fweisbec@gmail.com> <1247237391-5352-2-git-send-email-fweisbec@gmail.com> <1247237995.7529.43.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247237995.7529.43.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 04:59:55PM +0200, Peter Zijlstra wrote:
> On Fri, 2009-07-10 at 16:49 +0200, Frederic Weisbecker wrote:
> 
> > index 0cb0d8d..e357dc7 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -2279,11 +2279,13 @@ extern int _cond_resched(void);
> >  #ifdef CONFIG_PREEMPT_BKL
> >  static inline int cond_resched(void)
> >  {
> > +	might_sleep();
> >  	return 0;
> >  }
> >  #else
> >  static inline int cond_resched(void)
> >  {
> > +	might_sleep();
> >  	return _cond_resched();
> >  }
> >  #endif
> 
> # define might_resched() _cond_resched()


Argh, indeed.
I thought might_sleep() only wrapped __might_sleep(__FILE__, __LINE__)

 
> # define might_sleep() \
> 	do { __might_sleep(__FILE__, __LINE__); might_resched(); } while (0)
> 
> 
> Doesn't seem to make it any better that, but yeah, moving that
> __might_sleep() did occur to me earlier today when I touched that code.


Ok.

Another idea: if cond_resched() was a macro and __might_sleep() was
called inside, the given __FILE__ __LINE__ would be much more useful.

Only the backtraces would be useful in the current state, __FILE__
and __LINE__ point to sched.h, which is not exactly what is needed,
right?

Thanks,
Frederic.


> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index 87ecac1..c22804b 100644
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
> 
> 
> 

