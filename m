Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZEXDgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZEXDgp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 23:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZEXDgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 23:36:36 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:32930 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZEXDgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 23:36:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=qE15SlsHgS051PgUpFUEXMoGtQVyeJjDyTcjOlsf9DU8e5WqUildVzW3QxSg53Q2La
         cIvJO0igp20t8QMdB6lBiMmXs4XTGEHv9nWw+2jUMXq9V6g/90XCfX4KH713w5p8aElo
         HImwE+UynXwxTb08WBB1E101hlEzfa+MjJJfk=
Date: Sun, 24 May 2009 11:29:43 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Alan Stern <stern@rowland.harvard.edu>, Oleg Nesterov <oleg@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
Message-ID: <20090524112943.041935da@linux-lm>
In-Reply-To: <200905240120.30336.rjw@sisk.pl>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	<200905230023.16377.rjw@sisk.pl>
	<1243066902.4606.42.camel@johannes.local>
	<200905240120.30336.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ÓÚ Sun, 24 May 2009 01:20:29 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> Ð´µÀ:

> On Saturday 23 May 2009, Johannes Berg wrote:
> > On Sat, 2009-05-23 at 00:23 +0200, Rafael J. Wysocki wrote:
> > 
> > > > I just arrived at the same conclusion, heh. I can't say I
> > > > understand these changes though, the part about calling the
> > > > platform differently may make sense, but calling why disable
> > > > non-boot CPUs at a different place?
> > > 
> > > Because the ordering of platform callbacks and cpu[_up()|_down()]
> > > is also important, at least on resume.
> > > 
> > > In principle we can call device_pm_unlock() right before calling
> > > disable_nonboot_cpus() and take the lock again right after calling
> > > enable_nonboot_cpus(), if that helps.
> > 
> > Probably, unless the cpu_add_remove_lock wasn't a red herring after
> > all. I'd test, but I don't have much time today, will be travelling
> > tomorrow and be at UDS all week next week so I don't know when I'll
> > get to it -- could you provide a patch and also attach it to
> > http://bugzilla.kernel.org/show_bug.cgi?id=13245 please? Miles (the
> > reporter of that bug) has been very helpful in testing before.
> 
> OK
> 
> The patch is appended for reference (Alan, please have a look; I
> can't recall why exactly we have called device_pm_lock() from the
> core suspend/hibernation code instead of acquiring the lock locally
> in drivers/base/power/main.c) and I'll attach it to the bug entry too.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Do not hold dpm_list_mtx while disabling/enabling
> nonboot CPUs
> 
> We shouldn't hold dpm_list_mtx while executing
> [disable|enable]_nonboot_cpus(), because theoretically this may lead
> to a deadlock as shown by the following example (provided by Johannes
> Berg):
> 
> CPU 3       CPU 2                     CPU 1
>                                       suspend/hibernate
>             something:
>             rtnl_lock()               device_pm_lock()
>                                        -> mutex_lock(&dpm_list_mtx)
> 
>             mutex_lock(&dpm_list_mtx)
> 
> linkwatch_work
>  -> rtnl_lock()
>                                       disable_nonboot_cpus()
>                                        -> flush CPU 3 workqueue
> 
> Fortunately, device drivers are supposed to stop any activities that
> might lead to the registration of new device objects and/or to the
> removal of the existing ones way before disable_nonboot_cpus() is
> called, so it shouldn't be necessary to hold dpm_list_mtx over the
> entire late part of device suspend and early part of device resume.
> 
> Thus, during the late suspend and the early resume of devices acquire
> dpm_list_mtx only when dpm_list is going to be traversed and release
> it right after that.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/main.c |    4 ++++
>  kernel/kexec.c            |    2 --
>  kernel/power/disk.c       |   21 +++------------------
>  kernel/power/main.c       |    7 +------
>  4 files changed, 8 insertions(+), 26 deletions(-)
> 

I try to apply the patch against lastest next tree(2009-05-22), but
"patch -p1" is failured:


[lm@linux-lm linux-2.6]$ patch -p1 <  ../patch_rx/INFO_possible_circular_locking_dependency_at_cleanup_workqueue_thread.patch 
patching file kernel/power/disk.c
Hunk #1 succeeded at 215 with fuzz 2.
Hunk #3 succeeded at 278 with fuzz 1.
Hunk #4 FAILED at 343.
Hunk #5 succeeded at 396 with fuzz 2 (offset -4 lines).
Hunk #6 FAILED at 454.
Hunk #7 succeeded at 485 with fuzz 2.
2 out of 7 hunks FAILED -- saving rejects to file kernel/power/disk.c.rej
patching file kernel/power/main.c
Hunk #1 succeeded at 289 with fuzz 1 (offset 18 lines).
patching file drivers/base/power/main.c
Hunk #3 succeeded at 616 with fuzz 2.
Hunk #4 succeeded at 625 with fuzz 2.
patching file kernel/kexec.c
Hunk #1 succeeded at 1451 with fuzz 2.
Hunk #2 succeeded at 1488 with fuzz 2.



> Index: linux-2.6/kernel/power/disk.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/disk.c
> +++ linux-2.6/kernel/power/disk.c
> @@ -215,8 +215,6 @@ static int create_image(int platform_mod
>  	if (error)
>  		return error;
>  
> -	device_pm_lock();
> -
>  	/* At this point, device_suspend() has been called, but *not*
>  	 * device_power_down(). We *must* call device_power_down()
> now.
>  	 * Otherwise, drivers for some devices (e.g. interrupt
> controllers) @@ -227,7 +225,7 @@ static int create_image(int
> platform_mod if (error) {
>  		printk(KERN_ERR "PM: Some devices failed to power
> down, " "aborting hibernation\n");
> -		goto Unlock;
> +		return error;
>  	}
>  
>  	error = platform_pre_snapshot(platform_mode);
> @@ -280,9 +278,6 @@ static int create_image(int platform_mod
>  	device_power_up(in_suspend ?
>  		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
>  
> - Unlock:
> -	device_pm_unlock();
> -
>  	return error;
>  }
>  
> @@ -348,13 +343,11 @@ static int resume_target_kernel(bool pla
>  {
>  	int error;
>  
> -	device_pm_lock();
> -
>  	error = device_power_down(PMSG_QUIESCE);
>  	if (error) {
>  		printk(KERN_ERR "PM: Some devices failed to power
> down, " "aborting resume\n");
> -		goto Unlock;
> +		return error;
>  	}
>  
>  	error = platform_pre_restore(platform_mode);
> @@ -407,9 +400,6 @@ static int resume_target_kernel(bool pla
>  
>  	device_power_up(PMSG_RECOVER);
>  
> - Unlock:
> -	device_pm_unlock();
> -
>  	return error;
>  }
>  
> @@ -468,11 +458,9 @@ int hibernation_platform_enter(void)
>  		goto Resume_devices;
>  	}
>  
> -	device_pm_lock();
> -
>  	error = device_power_down(PMSG_HIBERNATE);
>  	if (error)
> -		goto Unlock;
> +		goto Resume_devices;
>  
>  	error = hibernation_ops->prepare();
>  	if (error)
> @@ -497,9 +485,6 @@ int hibernation_platform_enter(void)
>  
>  	device_power_up(PMSG_RESTORE);
>  
> - Unlock:
> -	device_pm_unlock();
> -
>   Resume_devices:
>  	entering_platform_hibernation = false;
>  	device_resume(PMSG_RESTORE);
> Index: linux-2.6/kernel/power/main.c
> ===================================================================
> --- linux-2.6.orig/kernel/power/main.c
> +++ linux-2.6/kernel/power/main.c
> @@ -271,12 +271,10 @@ static int suspend_enter(suspend_state_t
>  {
>  	int error;
>  
> -	device_pm_lock();
> -
>  	if (suspend_ops->prepare) {
>  		error = suspend_ops->prepare();
>  		if (error)
> -			goto Done;
> +			return error;
>  	}
>  
>  	error = device_power_down(PMSG_SUSPEND);
> @@ -325,9 +323,6 @@ static int suspend_enter(suspend_state_t
>  	if (suspend_ops->finish)
>  		suspend_ops->finish();
>  
> - Done:
> -	device_pm_unlock();
> -
>  	return error;
>  }
>  
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -357,6 +357,7 @@ static void dpm_power_up(pm_message_t st
>  {
>  	struct device *dev;
>  
> +	mutex_lock(&dpm_list_mtx);
>  	list_for_each_entry(dev, &dpm_list, power.entry)
>  		if (dev->power.status > DPM_OFF) {
>  			int error;
> @@ -366,6 +367,7 @@ static void dpm_power_up(pm_message_t st
>  			if (error)
>  				pm_dev_err(dev, state, " early",
> error); }
> +	mutex_unlock(&dpm_list_mtx);
>  }
>  
>  /**
> @@ -614,6 +616,7 @@ int device_power_down(pm_message_t state
>  	int error = 0;
>  
>  	suspend_device_irqs();
> +	mutex_lock(&dpm_list_mtx);
>  	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
>  		error = suspend_device_noirq(dev, state);
>  		if (error) {
> @@ -622,6 +625,7 @@ int device_power_down(pm_message_t state
>  		}
>  		dev->power.status = DPM_OFF_IRQ;
>  	}
> +	mutex_unlock(&dpm_list_mtx);
>  	if (error)
>  		device_power_up(resume_event(state));
>  	return error;
> Index: linux-2.6/kernel/kexec.c
> ===================================================================
> --- linux-2.6.orig/kernel/kexec.c
> +++ linux-2.6/kernel/kexec.c
> @@ -1451,7 +1451,6 @@ int kernel_kexec(void)
>  		error = device_suspend(PMSG_FREEZE);
>  		if (error)
>  			goto Resume_console;
> -		device_pm_lock();
>  		/* At this point, device_suspend() has been called,
>  		 * but *not* device_power_down(). We *must*
>  		 * device_power_down() now.  Otherwise, drivers for
> @@ -1489,7 +1488,6 @@ int kernel_kexec(void)
>  		enable_nonboot_cpus();
>  		device_power_up(PMSG_RESTORE);
>   Resume_devices:
> -		device_pm_unlock();
>  		device_resume(PMSG_RESTORE);
>   Resume_console:
>  		resume_console();
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Lei Ming
