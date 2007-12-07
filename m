Return-Path: <linux-kernel-owner+w=401wt.eu-S1755429AbXLGMdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbXLGMdw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 07:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753061AbXLGMdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 07:33:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35039 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbXLGMdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 07:33:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 3/4 -mm] kexec based hibernation -v7 : kexec hibernate/resume
Date: Fri, 7 Dec 2007 13:52:33 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1197042820.24045.63.camel@caritas-dev.intel.com>
In-Reply-To: <1197042820.24045.63.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712071352.34475.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 7 of December 2007, Huang, Ying wrote:
> This patch implements kexec based hibernate/resume. This is based on
> the facility provided by kexec_jump. The states save/restore code of
> ordinary kexec_jump is overridden by hibernate/resume specific
> code.

Can you explain in more details how this works?

> The ACPI methods are called at specified environment to conform 
> the ACPI specification. A new reboot command is added to go to ACPI S4
> state from user space.

Well, I still don't like the amount of duplicated code introduced by this patch.

Also, IMO it should be using the mutual exclusion mechanisms used by the
existing hibernation code, ie. pm_mutex and the snapshot_device_available
atomic variable.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ---
>  include/linux/kexec.h   |    4 
>  include/linux/reboot.h  |    1 
>  include/linux/suspend.h |    1 
>  kernel/power/disk.c     |  244 +++++++++++++++++++++++++++++++++++++++++++++++-
>  kernel/sys.c            |    5 
>  5 files changed, 251 insertions(+), 4 deletions(-)
> 
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -21,6 +21,7 @@
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/freezer.h>
> +#include <linux/kexec.h>
>  
>  #include "power.h"
>  
> @@ -365,13 +366,13 @@ int hibernation_platform_enter(void)
>  }
>  
>  /**
> - *	power_down - Shut the machine down for hibernation.
> + *	hibernate_power_down - Shut the machine down for hibernation.
>   *
>   *	Use the platform driver, if configured so; otherwise try
>   *	to power off or reboot.
>   */
>  
> -static void power_down(void)
> +void hibernate_power_down(void)
>  {
>  	switch (hibernation_mode) {
>  	case HIBERNATION_TEST:
> @@ -461,7 +462,7 @@ int hibernate(void)
>  		error = swsusp_write(flags);
>  		swsusp_free();
>  		if (!error)
> -			power_down();
> +			hibernate_power_down();
>  	} else {
>  		pr_debug("PM: Image restored successfully.\n");
>  		swsusp_free();
> @@ -478,6 +479,243 @@ int hibernate(void)
>  	return error;
>  }
>  
> +#ifdef CONFIG_KEXEC
> +static int kexec_snapshot(struct notifier_block *nb,
> +			  unsigned long cmd, void *arg)
> +{
> +	int error;
> +	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
> +
> +	if (cmd != KJUMP_CMD_HIBERNATE_WRITE_IMAGE)
> +		return NOTIFY_DONE;
> +
> +	pm_prepare_console();
> +
> +	error = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
> +	if (error)
> +		goto Exit;
> +
> +	error = freeze_processes();
> +	if (error) {
> +		error = -EBUSY;
> +		goto Exit;
> +	}
> +
> +	if (hibernation_test(TEST_FREEZER) ||
> +	    hibernation_testmode(HIBERNATION_TESTPROC)) {
> +		error = -EAGAIN;
> +		goto Resume_process;
> +	}
> +
> +	error = platform_start(platform_mode);
> +	if (error)
> +		goto Resume_process;
> +
> +	suspend_console();
> +	error = device_suspend(PMSG_FREEZE);
> +	if (error)
> +		goto Resume_console;
> +
> +	if (hibernation_test(TEST_DEVICES)) {
> +		error = -EAGAIN;
> +		goto Resume_devices;
> +	}
> +
> +	error = platform_pre_snapshot(platform_mode);
> +	if (error)
> +		goto Resume_devices;
> +
> +	if (hibernation_test(TEST_PLATFORM)) {
> +		error = -EAGAIN;
> +		goto Resume_devices;
> +	}
> +
> +	error = disable_nonboot_cpus();
> +	if (error)
> +		goto Resume_devices;
> +
> +	if (hibernation_test(TEST_CPUS) ||
> +	    hibernation_testmode(HIBERNATION_TEST)) {
> +		error = -EAGAIN;
> +		goto Enable_cpus;
> +	}
> +
> +	local_irq_disable();
> +	/* At this point, device_suspend() has been called, but *not*
> +	 * device_power_down(). We *must* device_power_down() now.
> +	 * Otherwise, drivers for some devices (e.g. interrupt
> +	 * controllers) become desynchronized with the actual state of
> +	 * the hardware at resume time, and evil weirdness ensues.
> +	 */
> +	error = device_power_down(PMSG_FREEZE);
> +	if (error)
> +		goto Enable_irqs;
> +
> +	if (hibernation_test(TEST_CORE)) {
> +		error = -EAGAIN;
> +		goto Power_up;
> +	}
> +
> +	return NOTIFY_STOP;
> +
> + Power_up:
> +	device_power_up();
> + Enable_irqs:
> +	local_irq_enable();
> + Enable_cpus:
> +	enable_nonboot_cpus();
> + Resume_devices:
> +	platform_finish(platform_mode);
> +	device_resume();
> + Resume_console:
> +	resume_console();
> + Resume_process:
> +	thaw_processes();
> + Exit:
> +	pm_notifier_call_chain(PM_POST_HIBERNATION);
> +	pm_restore_console();
> +	return notifier_from_errno(error);
> +}
> +
> +static int kexec_prepare_write_image(struct notifier_block *nb,
> +				     unsigned long cmd, void *arg)
> +{
> +	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
> +
> +	if (cmd != KJUMP_CMD_HIBERNATE_WRITE_IMAGE)
> +		return NOTIFY_DONE;
> +
> +	device_power_up();
> +	local_irq_enable();
> +	enable_nonboot_cpus();
> +	platform_finish(platform_mode);
> +	device_resume();
> +	resume_console();
> +	thaw_processes();
> +	pm_restore_console();
> +	return NOTIFY_STOP;
> +}
> +
> +static int kexec_prepare_resume(struct notifier_block *nb,
> +				unsigned long cmd, void *arg)
> +{
> +	int error;
> +	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
> +
> +	if (cmd != KJUMP_CMD_HIBERNATE_RESUME)
> +		return NOTIFY_DONE;
> +
> +	pm_prepare_console();
> +	error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
> +	if (error)
> +		goto Exit;
> +
> +	error = freeze_processes();
> +	if (error) {
> +		error = -EBUSY;
> +		goto Exit;
> +	}
> +
> +	suspend_console();
> +	error = device_suspend(PMSG_PRETHAW);
> +	if (error)
> +		goto Resume_console;
> +
> +	error = platform_pre_restore(platform_mode);
> +	if (error)
> +		goto Resume_devices;
> +
> +	error = disable_nonboot_cpus();
> +	if (error)
> +		goto Resume_devices;
> +	local_irq_disable();
> +	/* At this point, device_suspend() has been called, but *not*
> +	 * device_power_down(). We *must* device_power_down() now.
> +	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
> +	 * become desynchronized with the actual state of the hardware
> +	 * at resume time, and evil weirdness ensues.
> +	 */
> +	error = device_power_down(PMSG_PRETHAW);
> +	if (error)
> +		goto Enable_irqs;
> +
> +	return NOTIFY_STOP;
> +
> + Enable_irqs:
> +	local_irq_enable();
> +	enable_nonboot_cpus();
> + Resume_devices:
> +	platform_restore_cleanup(platform_mode);
> +	device_resume();
> + Resume_console:
> +	resume_console();
> +	thaw_processes();
> + Exit:
> +	pm_notifier_call_chain(PM_POST_RESTORE);
> +	pm_restore_console();
> +	return notifier_from_errno(error);
> +}
> +
> +static int kexec_resume(struct notifier_block *nb,
> +			unsigned long cmd, void *arg)
> +{
> +	int platform_mode = (hibernation_mode == HIBERNATION_PLATFORM);
> +
> +	if (cmd != KJUMP_CMD_HIBERNATE_RESUME)
> +		return NOTIFY_DONE;
> +
> +	platform_leave(platform_mode);
> +	device_power_up();
> +	local_irq_enable();
> +	enable_nonboot_cpus();
> +	platform_finish(platform_mode);
> +	device_resume();
> +	resume_console();
> +	thaw_processes();
> +	pm_notifier_call_chain(PM_POST_HIBERNATION);
> +	pm_restore_console();
> +	return NOTIFY_STOP;
> +}
> +
> +static struct notifier_block nb_kexec_snapshot = {
> +	.notifier_call = kexec_snapshot,
> +};
> +
> +static struct notifier_block nb_kexec_prepare_write_image = {
> +	.notifier_call = kexec_prepare_write_image,
> +};
> +
> +static struct notifier_block nb_kexec_prepare_resume = {
> +	.notifier_call = kexec_prepare_resume,
> +};
> +
> +static struct notifier_block nb_kexec_resume = {
> +	.notifier_call = kexec_resume,
> +};
> +
> +static int kexec_hibernation_register(void)
> +{
> +	int ret;
> +
> +	ret = blocking_notifier_chain_register(&kjump_chain_pre,
> +					       &nb_kexec_snapshot);
> +	if (ret)
> +		return ret;
> +	ret = blocking_notifier_chain_register(&kjump_chain_post,
> +					       &nb_kexec_prepare_write_image);
> +	if (ret)
> +		return ret;
> +	ret = blocking_notifier_chain_register(&kjump_chain_pre,
> +					       &nb_kexec_prepare_resume);
> +	if (ret)
> +		return ret;
> +	ret = blocking_notifier_chain_register(&kjump_chain_post,
> +					       &nb_kexec_resume);
> +	return ret;
> +}
> +
> +late_initcall(kexec_hibernation_register);
> +#endif
>  
>  /**
>   *	software_resume - Resume from a saved image.
> --- a/include/linux/suspend.h
> +++ b/include/linux/suspend.h
> @@ -198,6 +198,7 @@ extern unsigned long get_safe_page(gfp_t
>  
>  extern void hibernation_set_ops(struct platform_hibernation_ops *ops);
>  extern int hibernate(void);
> +extern void hibernate_power_down(void);
>  #else /* CONFIG_HIBERNATION */
>  static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
>  static inline void swsusp_set_page_free(struct page *p) {}
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -442,6 +442,11 @@ asmlinkage long sys_reboot(int magic1, i
>  			unlock_kernel();
>  			return ret;
>  		}
> +
> +	case LINUX_REBOOT_CMD_HIBERNATE_POWER_DOWN:
> +		hibernate_power_down();
> +		unlock_kernel();
> +		return -EINVAL;
>  #endif
>  
>  	default:
> --- a/include/linux/reboot.h
> +++ b/include/linux/reboot.h
> @@ -33,6 +33,7 @@
>  #define	LINUX_REBOOT_CMD_RESTART2	0xA1B2C3D4
>  #define	LINUX_REBOOT_CMD_SW_SUSPEND	0xD000FCE2
>  #define	LINUX_REBOOT_CMD_KEXEC		0x45584543
> +#define LINUX_REBOOT_CMD_HIBERNATE_POWER_DOWN 0xE4390DF3
>  
>  
>  #ifdef __KERNEL__
> --- a/include/linux/kexec.h
> +++ b/include/linux/kexec.h
> @@ -127,7 +127,9 @@ extern int kexec_vcall(struct kimage *im
>  		       unsigned int argc, va_list args);
>  extern int kexec_jump(struct kimage *image, unsigned long *cmd_ret,
>  		      unsigned long cmd);
> -#define KJUMP_CMD_NONE 0
> +#define KJUMP_CMD_NONE			0x0
> +#define KJUMP_CMD_HIBERNATE_WRITE_IMAGE	0x6b630001
> +#define KJUMP_CMD_HIBERNATE_RESUME	0x6b630002
>  #ifdef CONFIG_COMPAT
>  extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
>  				unsigned long nr_segments,
> 
> 
