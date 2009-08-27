Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZH0Myo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZH0Myo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 08:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbZH0Myo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 08:54:44 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:8708 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbZH0Myn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 08:54:43 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
 cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090827115354.GC24986@linux.vnet.ibm.com>
References: <20090827114908.GA24986@linux.vnet.ibm.com>
	 <20090827115354.GC24986@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 27 Aug 2009 14:53:27 +0200
Message-Id: <1251377607.18584.96.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-27 at 17:23 +0530, Arun R Bharadwaj wrote:
> * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-08-27 17:19:08]:
> 
> Cpuidle infrastructure assumes pm_idle as the default idle routine.
> But, ppc_md.power_save is the default idle callback in case of pSeries.
> 
> So, create a more generic, architecture independent cpuidle_pm_idle
> function pointer in driver/cpuidle/cpuidle.c and allow the idle routines
> of architectures to be set to cpuidle_pm_idle.
> 
> Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> ---
>  drivers/cpuidle/cpuidle.c |   12 +++++++-----
>  include/linux/cpuidle.h   |    7 +++++++
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> Index: linux.trees.git/drivers/cpuidle/cpuidle.c
> ===================================================================
> --- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
> +++ linux.trees.git/drivers/cpuidle/cpuidle.c
> @@ -25,6 +25,7 @@ DEFINE_PER_CPU(struct cpuidle_device *, 
>  DEFINE_MUTEX(cpuidle_lock);
>  LIST_HEAD(cpuidle_detected_devices);
>  static void (*pm_idle_old)(void);
> +void (*cpuidle_pm_idle)(void);
>  
>  static int enabled_devices;
>  
> @@ -98,10 +99,10 @@ static void cpuidle_idle_call(void)
>   */
>  void cpuidle_install_idle_handler(void)
>  {
> -	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
> +	if (enabled_devices && (cpuidle_pm_idle != cpuidle_idle_call)) {
>  		/* Make sure all changes finished before we switch to new idle */
>  		smp_wmb();
> -		pm_idle = cpuidle_idle_call;
> +		cpuidle_pm_idle = cpuidle_idle_call;
>  	}
>  }
>  
> @@ -110,8 +111,9 @@ void cpuidle_install_idle_handler(void)
>   */
>  void cpuidle_uninstall_idle_handler(void)
>  {
> -	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
> -		pm_idle = pm_idle_old;
> +	if (enabled_devices && pm_idle_old &&
> +			(cpuidle_pm_idle != pm_idle_old)) {
> +		cpuidle_pm_idle = pm_idle_old;
>  		cpuidle_kick_cpus();
>  	}
>  }
> @@ -382,7 +384,7 @@ static int __init cpuidle_init(void)
>  {
>  	int ret;
>  
> -	pm_idle_old = pm_idle;
> +	pm_idle_old = cpuidle_pm_idle;
>  
>  	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
>  	if (ret)
> Index: linux.trees.git/include/linux/cpuidle.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/cpuidle.h
> +++ linux.trees.git/include/linux/cpuidle.h
> @@ -188,4 +188,11 @@ static inline void cpuidle_unregister_go
>  #define CPUIDLE_DRIVER_STATE_START	0
>  #endif
>  
> +/*
> + * Idle callback used by cpuidle to call the cpuidle_idle_call().
> + * Platform drivers can use this to register to cpuidle's idle loop.
> + */
> +
> +extern void (*cpuidle_pm_idle)(void);
> +
>  #endif /* _LINUX_CPUIDLE_H */


I'm not quite seeing how this makes anything any better. Not we have 3
function pointers, where 1 should suffice.

/me wonders what's wrong with something like:

struct idle_func_desc {
	int		 power;
	int		 latency;
	void		 (*idle)(void);
	struct list_head list;
};

static void spin_idle(void)
{
	for (;;)
		cpu_relax();
}

static idle_func_desc default_idle_func = {
	power = 0, 	   /* doesn't safe any power */
	latency = INT_MAX, /* has max latency */
	idle = spin_idle,
	list = INIT_LIST_HEAD(default_idle_func.list),
};

void (*idle_func)(void);
static struct list_head idle_func_list;

static void pick_idle_func(void)
{
	struct idle_func_desc *desc, *idle = &default_idle_desc;

	list_for_each_entry(desc, &idle_func_list, list) {
		if (desc->power < idle->power)
			continue;
		if (desc->latency > target_latency);
			continue;
		idle = desc;
	}

	pm_idle = idle->idle;
}

void register_idle_func(struct idle_func_desc *desc)
{
	WARN_ON_ONCE(!list_empty(&desc->list));

	list_add_tail(&idle_func_list, &desc->list);
	pick_idle_func();
}

void unregister_idle_func(struct idle_func_desc *desc)
{
	WARN_ON_ONCE(list_empty(&desc->list));

	list_del_init(&desc->list);
	if (idle_func == desc->idle) 
		pick_idle_func();
}

