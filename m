Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZIBFqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZIBFqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 01:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755776AbZIBFqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 01:46:00 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45007 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZIBFqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 01:46:00 -0400
Date: Wed, 2 Sep 2009 11:15:52 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Joel Schopp <jschopp@austin.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       aun@linux.vnet.ibm.com
Subject: Re: [v4 PATCH 1/5]: cpuidle: Cleanup drivers/cpuidle/cpuidle.c
Message-ID: <20090902054552.GC5431@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090901113704.GG7599@linux.vnet.ibm.com> <20090901113840.GH7599@linux.vnet.ibm.com> <20090901172825.GA6780@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090901172825.GA6780@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2009-09-01 22:58:25]:

> * Arun R B <arun@linux.vnet.ibm.com> [2009-09-01 17:08:40]:
> 
> > * Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-09-01 17:07:04]:
> > 
> > Cleanup drivers/cpuidle/cpuidle.c
> > 
> > Cpuidle maintains a pm_idle_old void pointer because, currently in x86
> > there is no clean way of registering and unregistering a idle function.
> >
> > So remove pm_idle_old and leave the responsibility of maintaining the
> > list of registered idle loops to the architecture specific code. If the
> > architecture registers cpuidle_idle_call as its idle loop, only then
> > this loop is called.
> > 
> 
> It sounds as if there is a side-effect of this
> patch on x86 (am I reading it incorrectly), which can be fixed, but
> it will need a patch or so to get back the old behaviour on x86.
> 
> > Also remove unwanted functions cpuidle_[un]install_idle_handler,
> > cpuidle_kick_cpus()
> >
> > Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
> > ---
> >  drivers/cpuidle/cpuidle.c  |   51 +++++++++++++++------------------------------
> >  drivers/cpuidle/governor.c |    3 --
> >  2 files changed, 17 insertions(+), 37 deletions(-)
> > 
> > Index: linux.trees.git/drivers/cpuidle/cpuidle.c
> > ===================================================================
> > --- linux.trees.git.orig/drivers/cpuidle/cpuidle.c
> > +++ linux.trees.git/drivers/cpuidle/cpuidle.c
> > @@ -24,9 +24,14 @@ DEFINE_PER_CPU(struct cpuidle_device *, 
> > 
> >  DEFINE_MUTEX(cpuidle_lock);
> >  LIST_HEAD(cpuidle_detected_devices);
> > -static void (*pm_idle_old)(void);
> > 
> >  static int enabled_devices;
> > +static int idle_function_registered;
> > +
> > +struct idle_function_desc cpuidle_idle_desc = {
> > +	.name           =       "cpuidle_loop",
> > +	.idle_func      =       cpuidle_idle_call,
> > +};
> > 
> >  #if defined(CONFIG_ARCH_HAS_CPU_IDLE_WAIT)
> >  static void cpuidle_kick_cpus(void)
> > @@ -54,13 +59,10 @@ static void cpuidle_idle_call(void)
> > 
> >  	/* check if the device is ready */
> >  	if (!dev || !dev->enabled) {
> > -		if (pm_idle_old)
> > -			pm_idle_old();
> > -		else
> >  #if defined(CONFIG_ARCH_HAS_DEFAULT_IDLE)
> > -			default_idle();
> > +		default_idle();
> >  #else
> > -			local_irq_enable();
> > +		local_irq_enable();
> >  #endif
> >  		return;
> >  	}
> > @@ -94,35 +96,11 @@ static void cpuidle_idle_call(void)
> >  }
> > 
> >  /**
> > - * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
> > - */
> > -void cpuidle_install_idle_handler(void)
> > -{
> > -	if (enabled_devices && (pm_idle != cpuidle_idle_call)) {
> > -		/* Make sure all changes finished before we switch to new idle */
> > -		smp_wmb();
> > -		pm_idle = cpuidle_idle_call;
> > -	}
> > -}
> > -
> > -/**
> > - * cpuidle_uninstall_idle_handler - uninstalls the cpuidle idle loop handler
> > - */
> > -void cpuidle_uninstall_idle_handler(void)
> > -{
> > -	if (enabled_devices && pm_idle_old && (pm_idle != pm_idle_old)) {
> > -		pm_idle = pm_idle_old;
> > -		cpuidle_kick_cpus();
> > -	}
> > -}
> > -
> > -/**
> >   * cpuidle_pause_and_lock - temporarily disables CPUIDLE
> >   */
> >  void cpuidle_pause_and_lock(void)
> >  {
> >  	mutex_lock(&cpuidle_lock);
> > -	cpuidle_uninstall_idle_handler();
> >  }
> > 
> >  EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock);
> > @@ -132,7 +110,6 @@ EXPORT_SYMBOL_GPL(cpuidle_pause_and_lock
> >   */
> >  void cpuidle_resume_and_unlock(void)
> >  {
> > -	cpuidle_install_idle_handler();
> >  	mutex_unlock(&cpuidle_lock);
> >  }
> > 
> 
> What does this mean for users of cpuidle_pause_and_lock/unlock?
> Should we be calling register/unregister_idle_function here?
> 

Just observed the use case for cpuidle_pause_and_lock/unlock.
It is not clear as to why we need to switch back to the old idle
handler and then again back to cpuidle's idle handler. Wouldn't it
make more sense to just register the idle handler when the first
cpuidle device is being registered and unregister the idle handler
when the last cpuidle device is unregistered?

--arun

> 
> > @@ -287,6 +264,12 @@ static int __cpuidle_register_device(str
> >  	return 0;
> >  }
> > 
> > +static void register_cpuidle_idle_function(void)
> > +{
> > +	register_idle_function(&cpuidle_idle_desc);
> > +
> > +	idle_function_registered = 1;
> 
> Use booleans if possible, unless you intend to extend the meaning of
> registered someday.
> 
> > +}
> >  /**
> >   * cpuidle_register_device - registers a CPU's idle PM feature
> >   * @dev: the cpu
> > @@ -303,7 +286,9 @@ int cpuidle_register_device(struct cpuid
> >  	}
> > 
> >  	cpuidle_enable_device(dev);
> > -	cpuidle_install_idle_handler();
> > +
> > +	if (!idle_function_registered)
> > +		register_cpuidle_idle_function();
> > 
> >  	mutex_unlock(&cpuidle_lock);
> > 
> > @@ -382,8 +367,6 @@ static int __init cpuidle_init(void)
> >  {
> >  	int ret;
> > 
> > -	pm_idle_old = pm_idle;
> > -
> >  	ret = cpuidle_add_class_sysfs(&cpu_sysdev_class);
> >  	if (ret)
> >  		return ret;
> > Index: linux.trees.git/drivers/cpuidle/governor.c
> > ===================================================================
> > --- linux.trees.git.orig/drivers/cpuidle/governor.c
> > +++ linux.trees.git/drivers/cpuidle/governor.c
> > @@ -48,8 +48,6 @@ int cpuidle_switch_governor(struct cpuid
> >  	if (gov == cpuidle_curr_governor)
> >  		return 0;
> > 
> > -	cpuidle_uninstall_idle_handler();
> > -
> >  	if (cpuidle_curr_governor) {
> >  		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
> >  			cpuidle_disable_device(dev);
> > @@ -63,7 +61,6 @@ int cpuidle_switch_governor(struct cpuid
> >  			return -EINVAL;
> >  		list_for_each_entry(dev, &cpuidle_detected_devices, device_list)
> >  			cpuidle_enable_device(dev);
> > -		cpuidle_install_idle_handler();
> >  		printk(KERN_INFO "cpuidle: using governor %s\n", gov->name);
> >  	}
> > 
> 
> -- 
> 	Balbir
