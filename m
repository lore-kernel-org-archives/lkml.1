Return-Path: <linux-kernel-owner+w=401wt.eu-S965645AbXDBSRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbXDBSRH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 14:17:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965648AbXDBSRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 14:17:06 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:1674 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965645AbXDBSRD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 14:17:03 -0400
Date: Mon, 2 Apr 2007 13:56:32 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, Oleg Nesterov <oleg@tv-sign.ru>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@elte.hu, dipankar@in.ibm.com,
       dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH 1/8] Enhance process freezer interface for usage beyond software suspend
Message-ID: <20070402135632.GC6739@ucw.cz>
References: <20070402053457.GA9076@in.ibm.com> <20070402053705.GA12962@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402053705.GA12962@in.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>  This patch provides an interface to extend the use of the process
>  freezer beyond Suspend.
> 
> The tasks can selectively mark themselves to be exempted from specific
> freeze events like SUSPEND /KPROBES/CPU_HOTPLUG.
> 
> This patch however, *does not* sort non freezable threads into
> different categories based on the freeze events. Thus all 
> tasks which were previously marked PF_NOFREEZE are now
> exempted from freezer using 
> 	freezer_exempt(FE_ALL);
> which means exempt from all kinds of freezes.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Actually no, I was not in cc. 

> +/* Per process freezer specific flags */
> +#define PF_FE_SUSPEND	0x00008000	/* This thread should not be frozen
> +					 * for suspend
> +					 */
> +
> +#define PF_FE_KPROBES	0x00000010	/* This thread should not be frozen
> +					 * for Kprobes
> +					 */

Just put the comment before the define for long comments?


> -#ifdef CONFIG_PM
> +#if defined(CONFIG_PM) || defined(CONFIG_HOTPLUG_CPU) || \
> +					defined(CONFIG_KPROBES)

Should we create CONFIG_FREEZER?

> Index: linux-2.6.21-rc5/kernel/softlockup.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/softlockup.c
> +++ linux-2.6.21-rc5/kernel/softlockup.c
> @@ -96,7 +96,7 @@ static int watchdog(void * __bind_cpu)
>  	struct sched_param param = { .sched_priority = MAX_RT_PRIO-1 };
>  
>  	sched_setscheduler(current, SCHED_FIFO, &param);
> -	current->flags |= PF_NOFREEZE;
> +	freezer_exempt(FE_ALL);
>  
>  	/*
>  	 * Run briefly once per second to reset the softlockup timestamp.

Hmmm, I do not really like softlockup watchdog running during suspend.
Can we make this freezeable and make watchdog shut itself off while
suspending?

> Index: linux-2.6.21-rc5/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/kernel/rcutorture.c
> +++ linux-2.6.21-rc5/kernel/rcutorture.c
> @@ -559,7 +559,7 @@ rcu_torture_fakewriter(void *arg)
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task started");
>  	set_user_nice(current, 19);
> -	current->flags |= PF_NOFREEZE;
> +	freezer_exempt(FE_ALL);


Fix rcutorture instead. It has no business running while suspending.

>  
>  	do {
>  		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
> @@ -590,7 +590,7 @@ rcu_torture_reader(void *arg)
>  
>  	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
>  	set_user_nice(current, 19);
> -	current->flags |= PF_NOFREEZE;
> +	freezer_exempt(FE_ALL);
>  

Same here.

Eventually, we should fix apm, too.

> Index: linux-2.6.21-rc5/init/do_mounts_initrd.c
> ===================================================================
> --- linux-2.6.21-rc5.orig/init/do_mounts_initrd.c
> +++ linux-2.6.21-rc5/init/do_mounts_initrd.c
> @@ -55,7 +55,7 @@ static void __init handle_initrd(void)
>  	sys_mount(".", "/", NULL, MS_MOVE, NULL);
>  	sys_chroot(".");
>  
> -	current->flags |= PF_NOFREEZE;
> +	freezer_exempt(FE_ALL);
>  	pid = kernel_thread(do_linuxrc, "/linuxrc", SIGCHLD);
>  	if (pid > 0) {
>  		while (pid != sys_wait4(-1, NULL, 0, NULL))

Does this mean we have userland /linuxrc running with PF_NOFREEZE?
That would be very bad...

> --- linux-2.6.21-rc5.orig/kernel/kprobes.c
> +++ linux-2.6.21-rc5/kernel/kprobes.c
> @@ -104,7 +104,7 @@ static int __kprobes check_safety(void)
>  {
>  	int ret = 0;
>  #if defined(CONFIG_PREEMPT) && defined(CONFIG_PM)

Eh? Why does kprobes code depend on config_pm?

						Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
