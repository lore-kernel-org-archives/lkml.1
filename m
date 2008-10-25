Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbYJYSuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbYJYSuv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbYJYSun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:50:43 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:39821 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbYJYSun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:50:43 -0400
Date: Sat, 25 Oct 2008 19:48:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: walt <w41ter@gmail.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: commit a802dd0e breaks console keyboard input
In-Reply-To: <20081025141622.GA4397@osiris.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.64.0810251931080.24534@blonde.site>
References: <49011234.7090902@gmail.com> <20081024110742.GD4620@osiris.boeblingen.de.ibm.com>
 <alpine.LNX.2.00.0810240552320.2613@x9.ybpnyarg>
 <20081024194414.GB4155@osiris.boeblingen.de.ibm.com> <490256B7.1050906@gmail.com>
 <20081025141622.GA4397@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008, Heiko Carstens wrote:
> On Fri, Oct 24, 2008 at 04:13:59PM -0700, walt wrote:
> >> Please try the patch below. It basically reverts the whole stop_machine
> >> patches. That way we should know if it really comes from the moved init
> >> call or if it is some other weird bug. I would have expected more bug
> >> reports if the stop_machine patches would be broken. Hmmm...
> >
> > <second patch snipped for brevity>
> >
> > Yes your second patch fixes the keyboard problem, thanks.  The lack of
> > other complainers is what made me think of a BIOS bug, but that's just
> > wild guesswork on my part.  I'm happy to keep trying patches if you can
> > keep making them :-)
> 
> Thanks a lot for testing and your patience!
> The patch below moves the init call to its old place but makes the
> stop_machine initialization happen later. I added a BUG_ON to catch possible
> early calls, but there shouldn't be any. I think the patch should solve
> the regression you are seeing. Could you give it a try please?
> The patch applies on top of latest Linus' git tree.

Thanks, Heiko: this patch, or the revert before it, gets my PowerMac G5
working with 2.6.28-rc1.  I had the same console keyboard issue as Walt
(though USB not PS/2 here), and also the Broadcom tg3 appeared not to
be initializing (to judge by bootup messages - but without a keyboard
I didn't investigate, and forgot to try pinging from elsewhere).
Either of your patches fix both issues (but I've not reviewed them
or tried them on other machines which were having no problem).

Hugh

> 
> Thanks,
> Heiko
> 
> ---
>  include/linux/stop_machine.h |    6 ++++++
>  init/main.c                  |    5 +++--
>  kernel/stop_machine.c        |    9 ++++++---
>  3 files changed, 15 insertions(+), 5 deletions(-)
> 
> Index: linux-2.6/include/linux/stop_machine.h
> ===================================================================
> --- linux-2.6.orig/include/linux/stop_machine.h
> +++ linux-2.6/include/linux/stop_machine.h
> @@ -35,6 +35,9 @@ int stop_machine(int (*fn)(void *), void
>   * won't come or go while it's being called.  Used by hotplug cpu.
>   */
>  int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
> +
> +void stop_machine_init(void);
> +
>  #else
>  
>  static inline int stop_machine(int (*fn)(void *), void *data,
> @@ -46,5 +49,8 @@ static inline int stop_machine(int (*fn)
>  	local_irq_enable();
>  	return ret;
>  }
> +
> +static inline void stop_machine_init(void) { }
> +
>  #endif /* CONFIG_SMP */
>  #endif /* _LINUX_STOP_MACHINE */
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -38,6 +38,7 @@
>  #include <linux/moduleparam.h>
>  #include <linux/kallsyms.h>
>  #include <linux/writeback.h>
> +#include <linux/stop_machine.h>
>  #include <linux/cpu.h>
>  #include <linux/cpuset.h>
>  #include <linux/cgroup.h>
> @@ -768,6 +769,8 @@ static void __init do_initcalls(void)
>  static void __init do_basic_setup(void)
>  {
>  	rcu_init_sched(); /* needed by module_init stage. */
> +	init_workqueues();
> +	stop_machine_init();
>  	usermodehelper_init();
>  	driver_init();
>  	init_irq_proc();
> @@ -851,8 +854,6 @@ static int __init kernel_init(void * unu
>  
>  	cad_pid = task_pid(current);
>  
> -	init_workqueues();
> -
>  	smp_prepare_cpus(setup_max_cpus);
>  
>  	do_pre_smp_initcalls();
> Index: linux-2.6/kernel/stop_machine.c
> ===================================================================
> --- linux-2.6.orig/kernel/stop_machine.c
> +++ linux-2.6/kernel/stop_machine.c
> @@ -43,6 +43,7 @@ static struct workqueue_struct *stop_mac
>  static struct stop_machine_data active, idle;
>  static const cpumask_t *active_cpus;
>  static void *stop_machine_work;
> +static int stop_machine_initialized;
>  
>  static void set_state(enum stopmachine_state newstate)
>  {
> @@ -114,6 +115,7 @@ int __stop_machine(int (*fn)(void *), vo
>  	struct work_struct *sm_work;
>  	int i;
>  
> +	BUG_ON(!stop_machine_initialized);
>  	/* Set up initial state. */
>  	mutex_lock(&lock);
>  	num_threads = num_online_cpus();
> @@ -154,10 +156,11 @@ int stop_machine(int (*fn)(void *), void
>  }
>  EXPORT_SYMBOL_GPL(stop_machine);
>  
> -static int __init stop_machine_init(void)
> +void __init stop_machine_init(void)
>  {
>  	stop_machine_wq = create_rt_workqueue("kstop");
> +	BUG_ON(!stop_machine_wq);
>  	stop_machine_work = alloc_percpu(struct work_struct);
> -	return 0;
> +	BUG_ON(!stop_machine_work);
> +	stop_machine_initialized = 1;
>  }
> -early_initcall(stop_machine_init);
