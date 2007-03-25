Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbXCYAk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbXCYAk4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 20:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXCYAk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 20:40:56 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:51547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbXCYAky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 20:40:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Uayi4vSEUZD09k/syeZfYNuWP1seHYxGbHyIF3fUMbfpQh9kVwgjHKUf7aHi6UZgIzLy65Ihl6PtKCVvGjTIaiS+8DrPpE6zgfiHrGYeUa6AJEJ5bszngxBKYTY5ir/tJYno2L+toTY9s10lNJ5Bp8MeOCtIciRjXR1zSEuZXjI=
From: Maxim <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Sun, 25 Mar 2007 02:40:39 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703230030.28746.rjw@sisk.pl> <200703231542.45459.rjw@sisk.pl>
In-Reply-To: <200703231542.45459.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703250240.39457.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 March 2007 16:42:44 Rafael J. Wysocki wrote:
> On Friday, 23 March 2007 00:30, Rafael J. Wysocki wrote:
> > On Thursday, 22 March 2007 00:53, Rafael J. Wysocki wrote:
> > > On Thursday, 22 March 2007 00:39, Maxim wrote:
> > > > On Thursday 22 March 2007 01:24:25 Rafael J. Wysocki wrote:
> > > > > On Thursday, 22 March 2007 00:09, Maxim wrote:
> > > > > > On Thursday 22 March 2007 00:39:02 you wrote:
> > > > > > > On Wednesday, 21 March 2007 23:21, Pavel Machek wrote:
> > > > > > > > Hi!
> > > > > > > > 
> > > > > > > > > Starting with 2.6.21-rc1 suspend to ram and disk doesn't work anymore on my system.
> > > > > > > > > 
> > > > > > > > > I did a git-bisect and found that those commits break it:
> > > > > > > > > 
> > > > > > > > > e3c7db621bed4afb8e231cb005057f2feb5db557 - [PATCH] [PATCH] PM: Change code ordering in main.c
> > > > > > > > > ed746e3b18f4df18afa3763155972c5835f284c5 - [PATCH] [PATCH] swsusp: Change code ordering in disk.c
> > > > > > > > > 259130526c267550bc365d3015917d90667732f1 - [PATCH] [PATCH] swsusp: Change code ordering in user.c
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > (Yep, it was in my "to analyze" queue).
> > > > > > > > 
> > > > > > > > > I already reported about it, but now i know the reason why suspend breaks.
> > > > > > > > > 
> > > > > > > > > The problem is that both cpu_up/cpu_down were allowed to sleep until now, 
> > > > > > > > > and it did work because those functions could be called only in process context
> > > > > > > > > (the one that writes to /sys/devices/system/cpu/cpu*/online) or  idle thread  that does smp_init()).
> > > > > > > > > 
> > > > > > > > > But now they are called _after_ all tasks were suspended, so if cpu_down tries for example to take a lock
> > > > > > > > > that is taken by different process, it can't since the different proccess is frozen and can't release the lock.
> > > > > > > > > 
> > > > > > > > 
> > > > > > > > Thanks for detailed explanation.
> > > > > > > > 
> > > > > > > > ...but, on my machine suspend works ok in -rc4. I'm not seeing this.
> > > > > > > > 
> > > > > > > > ...by design, "frozen" tasks must not hold any locks. If frozen task
> > > > > > > > holds a lock, that's a bug.
> > > > > > > > 
> > > > > > > > > Or, it is also possible to revert this change.
> > > > > > > > 
> > > > > > > > Are you using xfs?
> > > > > > > 
> > > > > > > Well, this is the only case that can trigger it.  There are no other freezable
> > > > > > > workqueues.
> > > > > > > 
> > > > > > > Greetings,
> > > > > > > Rafael
> > > > > > > 
> > > > > > 
> > > > > > Hello,
> > > > > > 
> > > > > > 	Yes, you are right and it is XFS
> > > > > > 
> > > > > > 	System suspends and resumes with xfs and your patch correctly,
> > > > > 
> > > > > Could you please sent this information to the list?  I'd like it to reach all
> > > > > of the CCed parites. ;-)
> > > > 
> > > > I did now ( sorry I just keep using this Answer command, instead of Answer to everybody)
> > > > I didn't intend to send private email.
> > > > > 
> > > > > > 	Of course I need to mention that I had to unload microcode update driver because it prevented resume,
> > > > > > 	because it calls firmware loader helper, and again sleeps on lock
> > > > > 
> > > > > This is interesting.  Did it happen before or is it a regression?
> > > > 
> > > > It is from the same group of bugs , I mean hang because cpu_up/down is called with frozen tasks
> > > > Of course it didn't happen before those reordering commits were introduced
> > > 
> > > Well, we want cpu_up/down to be called after processes have been frozen, for
> > > various reasons (one of them being that applications shouldn't see us playing
> > > with the CPUs).
> > > 
> > > Thanks for reporting this, I'll have a look at the microcode update driver.
> > 
> > Well, I have invented the appended workaround, but I'm not sure how much
> > sense it makes with respect to the microcode driver.  At least, it doesn't
> > break my AMD64 SMP setup. ;-)
> 
> Modified version of the patch is appended.  Unfortunately I have no hardware
> supporting the microcode updates.
> 
> Greetings,
> Rafael
> 
> 
> ---
>  arch/i386/kernel/microcode.c |   28 +++++++++++++++++++++++++---
>  include/linux/cpu.h          |    2 ++
>  kernel/cpu.c                 |   32 ++++++++++++++++----------------
>  3 files changed, 43 insertions(+), 19 deletions(-)
> 
> Index: linux-2.6.21-rc4/arch/i386/kernel/microcode.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/arch/i386/kernel/microcode.c
> +++ linux-2.6.21-rc4/arch/i386/kernel/microcode.c
> @@ -567,6 +567,16 @@ static int cpu_request_microcode(int cpu
>  	return error;
>  }
>  
> +static void apply_microcode_on_cpu(int cpu)
> +{
> +	cpumask_t old;
> +
> +	old = current->cpus_allowed;
> +	set_cpus_allowed(current, cpumask_of_cpu(cpu));
> +	apply_microcode(cpu);
> +	set_cpus_allowed(current, old);
> +}
> +
>  static void microcode_init_cpu(int cpu)
>  {
>  	cpumask_t old;
> @@ -663,13 +673,21 @@ static int mc_sysdev_add(struct sys_devi
>  		return 0;
>  
>  	pr_debug("Microcode:CPU %d added\n", cpu);
> -	memset(uci, 0, sizeof(*uci));
> +	/* If suspend_cpu_hotplug is set, the system is resuming and we should
> +	 * use the data from before the suspend.
> +	 */
> +	if (!suspend_cpu_hotplug)
> +		memset(uci, 0, sizeof(*uci));
>  
>  	err = sysfs_create_group(&sys_dev->kobj, &mc_attr_group);
>  	if (err)
>  		return err;
>  
> -	microcode_init_cpu(cpu);
> +	if (suspend_cpu_hotplug && uci->valid)
> +		apply_microcode_on_cpu(cpu);
> +	else
> +		microcode_init_cpu(cpu);
> +
>  	return 0;
>  }
>  
> @@ -680,7 +698,11 @@ static int mc_sysdev_remove(struct sys_d
>  	if (!cpu_online(cpu))
>  		return 0;
>  	pr_debug("Microcode:CPU %d removed\n", cpu);
> -	microcode_fini_cpu(cpu);
> +	/* If suspend_cpu_hotplug is set, the system is suspending and we should
> +	 * keep the microcode in memory for the resume.
> +	 */
> +	if (!suspend_cpu_hotplug)
> +		microcode_fini_cpu(cpu);
>  	sysfs_remove_group(&sys_dev->kobj, &mc_attr_group);
>  	return 0;
>  }
> Index: linux-2.6.21-rc4/include/linux/cpu.h
> ===================================================================
> --- linux-2.6.21-rc4.orig/include/linux/cpu.h
> +++ linux-2.6.21-rc4/include/linux/cpu.h
> @@ -127,6 +127,8 @@ static inline int cpu_is_offline(int cpu
>  #endif		/* CONFIG_HOTPLUG_CPU */
>  
>  #ifdef CONFIG_SUSPEND_SMP
> +extern int suspend_cpu_hotplug;
> +
>  extern int disable_nonboot_cpus(void);
>  extern void enable_nonboot_cpus(void);
>  #else
> Index: linux-2.6.21-rc4/kernel/cpu.c
> ===================================================================
> --- linux-2.6.21-rc4.orig/kernel/cpu.c
> +++ linux-2.6.21-rc4/kernel/cpu.c
> @@ -254,6 +254,12 @@ int __cpuinit cpu_up(unsigned int cpu)
>  }
>  
>  #ifdef CONFIG_SUSPEND_SMP
> +/* Needed to prevent the microcode driver from requesting firmware in its CPU
> + * hotplug notifier during the suspend/resume.
> + */
> +int suspend_cpu_hotplug;
> +EXPORT_SYMBOL(suspend_cpu_hotplug);
> +
>  static cpumask_t frozen_cpus;
>  
>  int disable_nonboot_cpus(void)
> @@ -261,16 +267,8 @@ int disable_nonboot_cpus(void)
>  	int cpu, first_cpu, error = 0;
>  
>  	mutex_lock(&cpu_add_remove_lock);
> -	first_cpu = first_cpu(cpu_present_map);
> -	if (!cpu_online(first_cpu)) {
> -		error = _cpu_up(first_cpu);
> -		if (error) {
> -			printk(KERN_ERR "Could not bring CPU%d up.\n",
> -				first_cpu);
> -			goto out;
> -		}
> -	}
> -
> +	suspend_cpu_hotplug = 1;
> +	first_cpu = first_cpu(cpu_online_map);
>  	/* We take down all of the non-boot CPUs in one shot to avoid races
>  	 * with the userspace trying to use the CPU hotplug at the same time
>  	 */
> @@ -296,7 +294,7 @@ int disable_nonboot_cpus(void)
>  	} else {
>  		printk(KERN_ERR "Non-boot CPUs are not disabled\n");
>  	}
> -out:
> +	suspend_cpu_hotplug = 0;
>  	mutex_unlock(&cpu_add_remove_lock);
>  	return error;
>  }
> @@ -308,20 +306,22 @@ void enable_nonboot_cpus(void)
>  	/* Allow everyone to use the CPU hotplug again */
>  	mutex_lock(&cpu_add_remove_lock);
>  	cpu_hotplug_disabled = 0;
> -	mutex_unlock(&cpu_add_remove_lock);
>  	if (cpus_empty(frozen_cpus))
> -		return;
> +		goto out;
>  
> +	suspend_cpu_hotplug = 1;
>  	printk("Enabling non-boot CPUs ...\n");
>  	for_each_cpu_mask(cpu, frozen_cpus) {
> -		error = cpu_up(cpu);
> +		error = _cpu_up(cpu);
>  		if (!error) {
>  			printk("CPU%d is up\n", cpu);
>  			continue;
>  		}
> -		printk(KERN_WARNING "Error taking CPU%d up: %d\n",
> -			cpu, error);
> +		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
>  	}
>  	cpus_clear(frozen_cpus);
> +	suspend_cpu_hotplug = 0;
> +out:
> +	mutex_unlock(&cpu_add_remove_lock);
>  }
>  #endif
> 

Hi,
	I confirm that the above patch works,

	At least system didn't hang on resume with microcode driver loaded,

	I can't really test whenever it did update microcode because I almost sure there is nothing to update
	(I use core 2 duo that I bought a month ago, and an intel motherboard with latest bios ( updated yesterday) )
	I selected this driver just in case when I compiled kernel.

	Regards,
		Maxim Levitsky
