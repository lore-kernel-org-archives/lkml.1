Return-Path: <linux-kernel-owner+w=401wt.eu-S1751739AbZH1EtI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbZH1EtI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:49:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbZH1EtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:49:07 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:34696 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbZH1EtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:49:06 -0400
Date: Fri, 28 Aug 2009 10:19:01 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
	cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
Message-ID: <20090828044901.GA10283@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090827114908.GA24986@linux.vnet.ibm.com> <20090827115354.GC24986@linux.vnet.ibm.com> <1251377607.18584.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251377607.18584.96.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-08-27 14:53:27]:

> On Thu, 2009-08-27 at 17:23 +0530, Arun R Bharadwaj wrote:
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-08-27 17:19:08]:
> > 
> > Cpuidle infrastructure assumes pm_idle as the default idle routine.
> > But, ppc_md.power_save is the default idle callback in case of pSeries.
> > 
> > So, create a more generic, architecture independent cpuidle_pm_idle
> > function pointer in driver/cpuidle/cpuidle.c and allow the idle routines
> > of architectures to be set to cpuidle_pm_idle.
> > 
> > Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> > ---
> >  drivers/cpuidle/cpuidle.c |   12 +++++++-----
> >  include/linux/cpuidle.h   |    7 +++++++
> >  2 files changed, 14 insertions(+), 5 deletions(-)
> > 
> > Index: linux.trees.git/drivers/cpuidle/cpuidle.c
> > ===================================================================
> > --- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
> > +++ linux.trees.git/drivers/cpuidle/cpuidle.c
> > @@ -25,6 +25,7 @@ DEFINE_PER_CPU(struct cpuidle_device *, 
> >  DEFINE_MUTEX(cpuidle_lock);
> >  LIST_HEAD(cpuidle_detected_devices);
> >  static void (*pm_idle_old)(void);
> > +void (*cpuidle_pm_idle)(void);
> >  
> >  static int enabled_devices;
> >  
> > @@ -98,10 +99,10 @@ static void cpuidle_idle_call(void)
> >   */
> >  void cpuidle_install_idle_handler(void)
> >  {
> > -	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
> > +	if (enabled_devices && (cpuidle_pm_idle != cpuidle_idle_call)) {
> >  		/* Make sure all changes finished before we switch to new idle */
> >  		smp_wmb();
> > -		pm_idle = cpuidle_idle_call;
> > +		cpuidle_pm_idle = cpuidle_idle_call;
> >  	}
> >  }
> >  
> > @@ -110,8 +111,9 @@ void cpuidle_install_idle_handler(void)
> >   */
> >  void cpuidle_uninstall_idle_handler(void)
> >  {
> > -	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
> > -		pm_idle = pm_idle_old;
> > +	if (enabled_devices && pm_idle_old &&
> > +			(cpuidle_pm_idle != pm_idle_old)) {
> > +		cpuidle_pm_idle = pm_idle_old;
> >  		cpuidle_kick_cpus();
> >  	}
> >  }
> > @@ -382,7 +384,7 @@ static int __init cpuidle_init(void)
> >  {
> >  	int ret;
> >  
> > -	pm_idle_old = pm_idle;
> > +	pm_idle_old = cpuidle_pm_idle;
> >  
> >  	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
> >  	if (ret)
> > Index: linux.trees.git/include/linux/cpuidle.h
> > ===================================================================
> > --- linux.trees.git.orig/include/linux/cpuidle.h
> > +++ linux.trees.git/include/linux/cpuidle.h
> > @@ -188,4 +188,11 @@ static inline void cpuidle_unregister_go
> >  #define CPUIDLE_DRIVER_STATE_START	0
> >  #endif
> >  
> > +/*
> > + * Idle callback used by cpuidle to call the cpuidle_idle_call().
> > + * Platform drivers can use this to register to cpuidle's idle loop.
> > + */
> > +
> > +extern void (*cpuidle_pm_idle)(void);
> > +
> >  #endif /* _LINUX_CPUIDLE_H */
> 
> 
> I'm not quite seeing how this makes anything any better. Not we have 3
> function pointers, where 1 should suffice.
> 

Not really. We already do have pm_idle in case of x86 and
ppc_md.power_save in case of POWER. So here I'm only introducing
cpuidle_pm_idle which can be used by doing a

ppc_md.power_save = cpuidle_pm_idle;


> /me wonders what's wrong with something like:
> 
> struct idle_func_desc {
> 	int		 power;
> 	int		 latency;
> 	void		 (*idle)(void);
> 	struct list_head list;
> };
> 
> static void spin_idle(void)
> {
> 	for (;;)
> 		cpu_relax();
> }
> 
> static idle_func_desc default_idle_func = {
> 	power = 0, 	   /* doesn't safe any power */
> 	latency = INT_MAX, /* has max latency */
> 	idle = spin_idle,
> 	list = INIT_LIST_HEAD(default_idle_func.list),
> };
> 
> void (*idle_func)(void);
> static struct list_head idle_func_list;
> 
> static void pick_idle_func(void)
> {
> 	struct idle_func_desc *desc, *idle = &default_idle_desc;
> 
> 	list_for_each_entry(desc, &idle_func_list, list) {
> 		if (desc->power < idle->power)
> 			continue;
> 		if (desc->latency > target_latency);
> 			continue;
> 		idle = desc;
> 	}
> 
> 	pm_idle = idle->idle;
> }
>

This only does the job of picking the right idle loop for current
latency and power requirement. This is already done in ladder/menu
governors under the routines menu_select()/ladder_select().
I'm not sure whats the purpose of it here.

Here we are only concerned about the main idle loop, which is
pm_idle/ppc_md.power_save. After setting the main idle loop to
cpuidle_pm_idle, that would call cpuidle_idle_call() which would do
the job of picking the right low level idle loop based on latency and
other requirements.


> void register_idle_func(struct idle_func_desc *desc)
> {
> 	WARN_ON_ONCE(!list_empty(&desc->list));
> 
> 	list_add_tail(&idle_func_list, &desc->list);
> 	pick_idle_func();
> }
> 
> void unregister_idle_func(struct idle_func_desc *desc)
> {
> 	WARN_ON_ONCE(list_empty(&desc->list));
> 
> 	list_del_init(&desc->list);
> 	if (idle_func == desc->idle) 
> 		pick_idle_func();
> }
> 
