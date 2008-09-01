Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbYIAQft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbYIAQft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757319AbYIAQfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:35:13 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:25971 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757230AbYIAQfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:35:11 -0400
X-BigFish: VPS-64(z6f5iz1418M1432R98dR936eQ4015M62a3L1805M179dR936fQzz10d3izzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K6IZE1-01-KJE-01
Date: Mon, 1 Sep 2008 18:34:52 +0200
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>, Pavel Machek <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080901163452.GD6588@erda.amd.com>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48AA1E42.6070802@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 01 Sep 2008 16:34:54.0410 (UTC) FILETIME=[A9E5DAA0:01C90C50]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

this fix (commit id 1404e403) is not yet upstream for v2.6.27. Could
this be added to the next pull request?

Thanks,

-Robert

On 19.08.08 03:13:38, Andi Kleen wrote:
>
>> These keep on coming all through the suspend/shutdown sequence, also
>> intermixing with other messages. I'm guessing oprofile is trying to
>> NMI CPUs that have been brought down?
>
> That should actually work in theory. Linux CPU offlining puts CPUs in a 
> state where
> they can still process NMIs. Hmm actually there was a change recently to 
> free
> their exception stacks. Maybe it's broken now.
>
> Also oprofile has a suspend method that disables NMIs.
>
>> Now I get some ACPI Exceptions, but I think that these are unrelated
>> to starting oprofile, because I have seen them on regular shutdowns as
>> well:
>> PM: Syncing filesystems ... done.
>> Freezing user space processes ... (elapsed 0.00 seconds) done.
>> Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
>> PM: Shrinking memory... done (0 pages freed)
>> PM: Freed 0 kbytes in 0.44 seconds (0.00 MB/s)
>> Suspending console(s) (use no_console_suspend to debug)
>> ACPI Exception (exoparg2-0444): AE_AML_PACKAGE_LIMIT, Index
>> (000000007) is beyond end of object [20080609]
>> ACPI Error (psparse-0530): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.GTM_] (Node f783bfc0), AE_AML_PACKAGE_LIMIT
>> ACPI Error (psparse-0530): Method parse/execution failed
>> [\_SB_.PCI0.IDE0.CHN0._GTM] (Node f783bb40), AE_AML_PACKAGE_LIMIT
>> ACPI handle has no context!
>> serial 00:0d: disabled
>> serial 00:06: disabled
>> ehci_hcd 0000:00:1d.7: PCI INT A disabled
>> uhci_hcd 0000:00:1d.3: PCI INT D disabled
>> uhci_hcd 0000:00:1d.2: PCI INT C disabled
>> uhci_hcd 0000:00:1d.1: PCI INT B disabled
>> uhci_hcd 0000:00:1d.0: PCI INT A disabled
>> ACPI: Preparing to enter system sleep state S4
>> After that, I see the message "WQ on CPU0, prefer CPU1" a few times.
>> This must also be bad.
>> Now some warnings:
>> ------------[ cut here ]------------
>> WARNING: at 
>> /uio/arkimedes/s29/vegardno/git-working/linux-2.6/kernel/smp.c:328 s
>> mp_call_function_mask+0x194/0x1a0()
>
> The usual problem: the suspend function when interrupts are
> already disabled calls smp_call_function which is not allowed with
> interrupt off. But at this point all the other CPUs should be already
> down anyways, so it should be enough to just drop that.
>
> This patch should fix that problem at least by fixing cpu hotplug&
> suspend support. Untested.
>
> -Andi
>

> From 3967a8b03a30f26a6a5f41b4cc6a6772b5d0ce4f Mon Sep 17 00:00:00 2001
> From: Andi Kleen <ak@linux.intel.com>
> Date: Tue, 19 Aug 2008 03:10:03 +0200
> Subject: [PATCH] oprofile: fix cpu hotcplug
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/oprofile/nmi_int.c |   40 +++++++++++++++++++++++++++++++++++++---
>  1 files changed, 37 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index 529d625..6438c32 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -15,6 +15,7 @@
>  #include <linux/slab.h>
>  #include <linux/moduleparam.h>
>  #include <linux/kdebug.h>
> +#include <linux/cpu.h>
>  #include <asm/nmi.h>
>  #include <asm/msr.h>
>  #include <asm/apic.h>
> @@ -28,23 +29,48 @@ static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
>  
>  static int nmi_start(void);
>  static void nmi_stop(void);
> +static void nmi_cpu_start(void *dummy);
> +static void nmi_cpu_stop(void *dummy);
>  
>  /* 0 == registered but off, 1 == registered and on */
>  static int nmi_enabled = 0;
>  
> +#ifdef CONFIG_SMP
> +static int oprofile_cpu_notifier(struct notifier_block *b, unsigned long action,
> +				 void *data)
> +{
> +	int cpu = (unsigned long)data;
> +	switch (action) { 
> +	case CPU_DOWN_FAILED:
> +	case CPU_ONLINE:
> +		smp_call_function_single(cpu, nmi_cpu_start, NULL, 0);
> +		break;
> +	case CPU_DOWN_PREPARE:
> +		smp_call_function_single(cpu, nmi_cpu_stop, NULL, 1);
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block oprofile_cpu_nb = { 
> +	.notifier_call = oprofile_cpu_notifier
> +};	
> +#endif
> +
>  #ifdef CONFIG_PM
>  
>  static int nmi_suspend(struct sys_device *dev, pm_message_t state)
>  {
> +	/* Only one CPU left, just stop that one */
>  	if (nmi_enabled == 1)
> -		nmi_stop();
> +		nmi_cpu_stop(NULL);
>  	return 0;
>  }
>  
>  static int nmi_resume(struct sys_device *dev)
>  {
>  	if (nmi_enabled == 1)
> -		nmi_start();
> +		nmi_cpu_start(NULL);
>  	return 0;
>  }
>  
> @@ -66,6 +92,7 @@ static int __init init_sysfs(void)
>  	error = sysdev_class_register(&oprofile_sysclass);
>  	if (!error)
>  		error = sysdev_register(&device_oprofile);
> +	
>  	return error;
>  }
>  
> @@ -483,6 +510,9 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  	}
>  
>  	init_sysfs();
> +#ifdef CONFIG_SMP
> +	register_cpu_notifier(&oprofile_cpu_nb);
> +#endif
>  	using_nmi = 1;
>  	ops->create_files = nmi_create_files;
>  	ops->setup = nmi_setup;
> @@ -496,6 +526,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  
>  void op_nmi_exit(void)
>  {
> -	if (using_nmi)
> +	if (using_nmi) { 
>  		exit_sysfs();
> +#ifdef CONFIG_SMP
> +		unregister_cpu_notifier(&oprofile_cpu_nb);
> +#endif
> +	}
>  }
> -- 
> 1.5.6
> 


-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

