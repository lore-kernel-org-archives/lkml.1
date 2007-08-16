Return-Path: <linux-kernel-owner+w=401wt.eu-S1763083AbXHPXsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763083AbXHPXsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 19:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757685AbXHPXsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 19:48:31 -0400
Received: from ozlabs.org ([203.10.76.45]:42450 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbXHPXsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 19:48:30 -0400
From: Michael Neuling <mikey@neuling.org>
To: balbir@linux.vnet.ibm.com
cc: Paul Mackerras <paulus@samba.org>, Andrew Morton <akpm@osdl.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 2/2] [POWERPC] Add scaled time accounting 
In-reply-to: <46C41C76.1020109@linux.vnet.ibm.com> 
References: <20070816070922.6642E70073@localhost.localdomain> <46C41C76.1020109@linux.vnet.ibm.com>
Comments: In-reply-to Balbir Singh <balbir@linux.vnet.ibm.com>
   message dated "Thu, 16 Aug 2007 15:14:22 +0530."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Fri, 17 Aug 2007 09:48:26 +1000
Message-ID: <9426.1187308106@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



In message <46C41C76.1020109@linux.vnet.ibm.com> you wrote:
> Michael Neuling wrote:
> > This adds POWERPC specific hooks for scaled time accounting.
> > 
> > POWER6 includes a SPURR register.  The SPURR is based off the PURR
> > register but is scaled based on CPU frequency and issue rates.  This
> > gives a more accurate account of the instructions used per task.  The
> > PURR and timebase will be constant relative to the wall clock,
> > irrespective of the CPU frequency.  
> > 
> > This implementation reads the SPURR register in account_system_vtime
> > which is only call called on context witch and hard and soft irq entry
> > and exit.  The percentage of user and system time is then estimated
> > using the ratio of these accounted by the PURR.  If the SPURR is not
> > present, the PURR read.
> > 
> > An earlier implementation of this patch read the SPURR whenever the
> > PURR was read, which included the system call entry and exit path.
> > Unfortunately this showed a performance regression on lmbench runs, so
> > was re-implemented.
> > 
> > I've included the lmbench results here when run bare metal on POWER6.
> > 1st column is the unpatch results.  2nd column is the results using the
> > below patch and the 3rd is the % diff of these results from the base.
> > 4th and 5th columns are the results and % differnce from the base
> > using the older patch (SPURR read in syscall entry/exit path).
> > 
> >                               Base        Scaled-Acct     SPURR-in-syscall 
> >                              Result      Result  % diff    Result % diff  
> > Simple syscall:              0.3086      0.3086  0.0000    0.3452 11.8600 
> > Simple read:                 0.4591      0.4671  1.7425    0.5044 9.86713 
> > Simple write:                0.4364      0.4366  0.0458    0.4731 8.40971 
> > Simple stat:                 2.0055      2.0295  1.1967    2.0669 3.06158 
> > Simple fstat:                0.5962      0.5876  -1.442    0.6368 6.80979 
> > Simple open/close:           3.1283      3.1009  -0.875    3.2088 2.57328 
> > Select on 10 fd's:           0.8554      0.8457  -1.133    0.8667 1.32101 
> > Select on 100 fd's:          3.5292      3.6329  2.9383    3.6664 3.88756 
> > Select on 250 fd's:          7.9097      8.1881  3.5197    8.2242 3.97613 
> > Select on 500 fd's:          15.2659     15.836  3.7357    15.873 3.97814 
> > Select on 10 tcp fd's:       0.9576      0.9416  -1.670    0.9752 1.83792 
> > Select on 100 tcp fd's:      7.248       7.2254  -0.311    7.2685 0.28283 
> > Select on 250 tcp fd's:      17.7742     17.707  -0.375    17.749 -0.1406 
> > Select on 500 tcp fd's:      35.4258     35.25   -0.496    35.286 -0.3929 
> > Signal handler installation: 0.6131      0.6075  -0.913    0.647  5.52927 
> > Signal handler overhead:     2.0919      2.1078  0.7600    2.1831 4.35967 
> > Protection fault:            0.7345      0.7478  1.8107    0.8031 9.33968 
> > Pipe latency:                33.006      16.398  -50.31    33.475 1.42368 
> > AF_UNIX sock stream latency: 14.5093     30.910  113.03    30.715 111.692 
> > Process fork+exit:           219.8       222.8   1.3648    229.37 4.35623 
> > Process fork+execve:         876.14      873.28  -0.32     868.66 -0.8533 
> > Process fork+/bin/sh -c:     2830        2876.5  1.6431    2958   4.52296 
> > File /var/tmp/XXX write bw:  1193497     1195536 0.1708    118657 -0.5799 
> > Pagefaults on /var/tmp/XXX:  3.1272      3.2117  2.7020    3.2521 3.99398 
> > 
> > Also, kernel compile times show no difference with this patch applied.
> > 
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > 
> > ---
> > 
> >  arch/powerpc/kernel/asm-offsets.c |    1 +
> >  arch/powerpc/kernel/time.c        |   32 ++++++++++++++++++++++++++++++--
> >  include/asm-powerpc/paca.h        |    3 +++
> >  3 files changed, 34 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6-ozlabs/arch/powerpc/kernel/asm-offsets.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/arch/powerpc/kernel/asm-offsets.c
> > +++ linux-2.6-ozlabs/arch/powerpc/kernel/asm-offsets.c
> > @@ -141,6 +141,7 @@ int main(void)
> >  	DEFINE(PACALPPACAPTR, offsetof(struct paca_struct, lppaca_ptr));
> >  	DEFINE(PACAHWCPUID, offsetof(struct paca_struct, hw_cpu_id));
> >  	DEFINE(PACA_STARTPURR, offsetof(struct paca_struct, startpurr));
> > +	DEFINE(PACA_STARTSPURR, offsetof(struct paca_struct, startspurr));
> >  	DEFINE(PACA_USER_TIME, offsetof(struct paca_struct, user_time));
> >  	DEFINE(PACA_SYSTEM_TIME, offsetof(struct paca_struct, system_time));
> >  	DEFINE(PACA_SLBSHADOWPTR, offsetof(struct paca_struct, slb_shadow_ptr))
;
> > Index: linux-2.6-ozlabs/arch/powerpc/kernel/time.c
> > ===================================================================
> > --- linux-2.6-ozlabs.orig/arch/powerpc/kernel/time.c
> > +++ linux-2.6-ozlabs/arch/powerpc/kernel/time.c
> > @@ -168,23 +168,44 @@ static u64 read_purr(void)
> >  }
> > 
> >  /*
> > + * Read the SPURR on systems that have it, otherwise the purr
> > + */
> > +static u64 read_spurr(void)
> > +{
> > +	if (cpu_has_feature(CPU_FTR_SPURR))
> > +		return mfspr(SPRN_SPURR);
> > +	return read_purr();
> > +}
> > +
> > +/*
> >   * Account time for a transition between system, hard irq
> >   * or soft irq state.
> >   */
> >  void account_system_vtime(struct task_struct *tsk)
> >  {
> > -	u64 now, delta;
> > +	u64 now, nowscaled, delta, deltascaled;
> >  	unsigned long flags;
> > 
> >  	local_irq_save(flags);
> >  	now = read_purr();
> >  	delta = now - get_paca()->startpurr;
> >  	get_paca()->startpurr = now;
> > +	nowscaled = read_spurr();
> > +	deltascaled = nowscaled - get_paca()->startspurr;
> > +	get_paca()->startspurr = nowscaled;
> >  	if (!in_interrupt()) {
> > +		/* deltascaled includes both user and system time.
> > +		 * Hence scale it based on the purr ratio to estimate
> > +		 * the system time */
> > +		deltascaled = deltascaled * get_paca()->system_time /
> > +			(get_paca()->system_time + get_paca()->user_time);
> >  		delta += get_paca()->system_time;
> >  		get_paca()->system_time = 0;
> >  	}
> >  	account_system_time(tsk, 0, delta);
> > +	get_paca()->purrdelta = delta;
> > +	account_system_time_scaled(tsk, deltascaled);
> > +	get_paca()->spurrdelta = deltascaled;
> >  	local_irq_restore(flags);
> >  }
> > 
> > @@ -196,11 +217,17 @@ void account_system_vtime(struct task_st
> >   */
> >  void account_process_vtime(struct task_struct *tsk)
> >  {
> > -	cputime_t utime;
> > +	cputime_t utime, utimescaled;
> > 
> >  	utime = get_paca()->user_time;
> >  	get_paca()->user_time = 0;
> >  	account_user_time(tsk, utime);
> > +
> > +	/* Estimate the scaled utime by scaling the real utime based
> > +	 * on the last spurr to purr ratio */
> > +	utimescaled = utime * get_paca()->spurrdelta / get_paca()->purrdelta;
> 
> 
> The assumption is account_process_vtime() is always called after
> account_system_vtime(), is my understanding correct?

Yes, we use last spurr/purr ratio grabbed in account_system_vtime to
scale utime appropriately.

Mikey
