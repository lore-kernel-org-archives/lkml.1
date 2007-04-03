Return-Path: <linux-kernel-owner+w=401wt.eu-S932759AbXDCIAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbXDCIAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 04:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbXDCIAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 04:00:25 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:49282 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932759AbXDCIAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 04:00:24 -0400
Date: Tue, 3 Apr 2007 13:29:39 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>, mingo@elte.hu,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070403075939.GA29308@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com> <20070402135632.GC6739@ucw.cz> <200704022248.25948.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704022248.25948.rjw@sisk.pl>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 10:48:24PM +0200, Rafael J. Wysocki wrote:
> On Monday, 2 April 2007 15:56, Pavel Machek wrote:
> > Hi!
> > 
> > >  This patch provides an interface to extend the use of the process
> > >  freezer beyond Suspend.
> > > 
> > > The tasks can selectively mark themselves to be exempted from specific
> > > freeze events like SUSPEND /KPROBES/CPU_HOTPLUG.
> > > 
> > > This patch however, *does not* sort non freezable threads into
> > > different categories based on the freeze events. Thus all 
> > > tasks which were previously marked PF_NOFREEZE are now
> > > exempted from freezer using 
> > > 	freezer_exempt(FE_ALL);
> > > which means exempt from all kinds of freezes.
> > > 
> > > Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> > > Cc: Pavel Machek <pavel@ucw.cz>
> > > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > > Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> > 
> > Actually no, I was not in cc. 

Oops! Sorry. I knew I had missed something.

> > 
> > > +/* Per process freezer specific flags */
> > > +#define PF_FE_SUSPEND	0x00008000	/* This thread should not be frozen
> > > +					 * for suspend
> > > +					 */
> > > +
> > > +#define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
> > > +					 * for Kprobes
> > > +					 */
> > 
> > Just put the comment before the define for long comments?
> 
> Agreed.

ok, Will do.

> 
> > > -#ifdef CONFIG_PM
> > > +#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU) || \
> > > +					defined(CONFIG_KPROBES)
> > 
> > Should we create CONFIG_FREEZER?
> 
> Why do you think so?  I think the freezer should be compiled automatically
> if any of the above is set, which is what this directive really means.
> 
> > > Index: linux-2.6.21-rc5/kernel/softlockup.c
> > > ===================================================================
> > > --- linux-2.6.21-rc5.orig/kernel/softlockup.c
> > > +++ linux-2.6.21-rc5/kernel/softlockup.c
> > > @@ -96,7 +96,7 @@ static int watchdog(void * __bind_cpu)
> > >  	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
> > >  
> > >  	sched_setscheduler(current, SCHED_FIFO, &param);
> > > -	current->flags |= PF_NOFREEZE;
> > > +	freezer_exempt(FE_ALL);
> > >  
> > >  	/*
> > >  	 * Run briefly once per second to reset the softlockup timestamp.
> > 
> > Hmmm, I do not really like softlockup watchdog running during suspend.
> > Can we make this freezeable and make watchdog shut itself off while
> > suspending?
> 
> Generally, I agree, but this patch only replaces the existing instances
> of PF_NOFREEZE with the new mechanism.  The changes you're talking about
> require a separate patch series (or at least one separate patch), I think, and
> they need not be so simple to make.

Yes.

> 
> > > Index: linux-2.6.21-rc5/kernel/rcutorture.c
> > > ===================================================================
> > > --- linux-2.6.21-rc5.orig/kernel/rcutorture.c
> > > +++ linux-2.6.21-rc5/kernel/rcutorture.c
> > > @@ -559,7 +559,7 @@ rcu_torture_fakewriter(void *arg)
> > >  
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
> > >  	set_user_nice(current, 19);
> > > -	current->flags |= PF_NOFREEZE;
> > > +	freezer_exempt(FE_ALL);
> > 
> > 
> > Fix rcutorture instead. It has no business running while suspending.
> > 
> > >  
> > >  	do {
> > >  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> > > @@ -590,7 +590,7 @@ rcu_torture_reader(void *arg)
> > >  
> > >  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
> > >  	set_user_nice(current, 19);
> > > -	current->flags |= PF_NOFREEZE;
> > > +	freezer_exempt(FE_ALL);
> > >  
> > 
> > Same here.
> > 
> > Eventually, we should fix apm, too.
> > 
> > > Index: linux-2.6.21-rc5/init/do_mounts_initrd.c
> > > ===================================================================
> > > --- linux-2.6.21-rc5.orig/init/do_mounts_initrd.c
> > > +++ linux-2.6.21-rc5/init/do_mounts_initrd.c
> > > @@ -55,7 +55,7 @@ static void __init handle_initrd(void)
> > >  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
> > >  	sys_chroot(".");
> > >  
> > > -	current->flags |= PF_NOFREEZE;
> > > +	freezer_exempt(FE_ALL);
> > >  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
> > >  	if (pid > 0) {
> > >  		while (pid != sys_wait4(-1, NULL, 0, NULL))
> > 
> > Does this mean we have userland /linuxrc running with PF_NOFREEZE?
> > That would be very bad...
> 
> No, actually it is _required_ for the userland resume to work.  Well, perhaps
> I should place a comment in there so that I don't have to explain this again
> and again. :-)
> 
> > > --- linux-2.6.21-rc5.orig/kernel/kprobes.c
> > > +++ linux-2.6.21-rc5/kernel/kprobes.c
> > > @@ -104,7 +104,7 @@ static int __kprobes check_safety(void)
> > >  {
> > >  	int ret = 0;
> > >  #if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)
> > 
> > Eh? Why does kprobes code depend on config_pm?
> 
> Because it uses the freezer? ;-)

Is that why?! Then I guess we can remove it. Because the freezer is
going to be compiled in if CONFIG_KPROBES is set.

> 
> Greetings,
> Rafael

thanks
gautham.
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
