Return-Path: <linux-kernel-owner+w=401wt.eu-S941164AbXGaEdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941164AbXGaEdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967457AbXGaEbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:31:20 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49105 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967359AbXGaEbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:31:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Huang, Ying" <ying.huang@intel.com>
Cc: ak@suse.de, akpm@linux-foundation.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] x86_64 EFI support -v3: EFI runtime support
References: <1185851579.23149.28.camel@caritas-dev.intel.com>
Date: Mon, 30 Jul 2007 22:30:00 -0600
In-Reply-To: <1185851579.23149.28.camel@caritas-dev.intel.com> (Ying Huang's
	message of "Tue, 31 Jul 2007 11:12:59 +0800")
Message-ID: <m14pjluref.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Huang, Ying" <ying.huang@intel.com> writes:

> This patch adds runtime service support for EFI x86_64 system.
>
> The EFI support for emergency_restart and RTC clock is added. The EFI
> based implementation and legacy BIOS or CMOS based implementation are
> put in separate functions and are chosen based on the value of
> efi_enabled.

The patches to the reboot path are wrong (see below).

Why do we need to do this anyway?  Why do we need any EFI runtime
support?  We already have ACPI.  Isn't that good enough to abstract
out the runtime parts of the hardware?

Why do we need to replace working code that directly talks to the
architecturally defined hardware, with firmware calls?

What is the point?  What is the advantage?

The disadvantage of having more code to maintain and having
to deal with more BIOS bugs should be obvious.

> Signed-off-by: Chandramouli Narayanan <mouli@linux.intel.com>
> Signed-off-by: Huang Ying <ying.huang@intel.com>
>
> ---
>
>  reboot.c |   11 ++++++++++-
>  time.c   |   47 +++++++++++++++++++++++++++++++----------------
>  2 files changed, 41 insertions(+), 17 deletions(-)
>
> Index: linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c
> ===================================================================
> --- linux-2.6.23-rc1.orig/arch/x86_64/kernel/reboot.c 2007-07-23
> 04:41:00.000000000 +0800
> +++ linux-2.6.23-rc1/arch/x86_64/kernel/reboot.c 2007-07-30 09:26:56.000000000
> +0800
> @@ -9,6 +9,7 @@
>  #include <linux/pm.h>
>  #include <linux/kdebug.h>
>  #include <linux/sched.h>
> +#include <linux/efi.h>
>  #include <asm/io.h>
>  #include <asm/delay.h>
>  #include <asm/hw_irq.h>
> @@ -117,7 +118,7 @@
>  	pci_iommu_shutdown();
>  }
>  
> -void machine_emergency_restart(void)
> +static inline void bios_emergency_restart(void)
>  {
>  	int i;
>  
> @@ -145,6 +146,14 @@
>  	}      
>  }
>  
> +void machine_emergency_restart(void)
> +{
> +	if (efi_enabled)
> +		efi_emergency_restart();
> +	else
> +		bios_emergency_restart();
> +}
> +

A EFI is a bios so naming the current machine_emergency_restart bios_emergency_restart is
a misnomer, especially since pounds the hardware not the firmware.
Second we already have a perfectly capable mechanism in the
reboot_type variable so you should just need to add one more type and
handle this properly. 


>  void machine_restart(char * __unused)
>  {
>  	printk("machine restart\n");
> Index: linux-2.6.23-rc1/arch/x86_64/kernel/time.c
> ===================================================================
> --- linux-2.6.23-rc1.orig/arch/x86_64/kernel/time.c 2007-07-23
> 04:41:00.000000000 +0800
> +++ linux-2.6.23-rc1/arch/x86_64/kernel/time.c 2007-07-30 09:42:12.000000000
> +0800
> @@ -27,6 +27,7 @@
>  #include <linux/notifier.h>
>  #include <linux/cpu.h>
>  #include <linux/kallsyms.h>
> +#include <linux/efi.h>
>  #include <linux/acpi.h>
>  #ifdef CONFIG_ACPI
>  #include <acpi/achware.h>	/* for PM timer frequency */
> @@ -89,13 +90,6 @@
>  	unsigned char control, freq_select;
>  
>  /*
> - * IRQs are disabled when we're called from the timer interrupt,
> - * no need for spin_lock_irqsave()
> - */
> -
> -	spin_lock(&rtc_lock);
> -
> -/*
>   * Tell the clock it's being set and stop it.
>   */
>  
> @@ -143,14 +137,26 @@
>  	CMOS_WRITE(control, RTC_CONTROL);
>  	CMOS_WRITE(freq_select, RTC_FREQ_SELECT);
>  
> -	spin_unlock(&rtc_lock);
> -
>  	return retval;
>  }
>  
>  int update_persistent_clock(struct timespec now)
>  {
> -	return set_rtc_mmss(now.tv_sec);
> +	int retval;
> +
> +/*
> + * IRQs are disabled when we're called from the timer interrupt,
> + * no need for spin_lock_irqsave()
> + */
> +
> +	spin_lock(&rtc_lock);
> +	if (efi_enabled)
> +		retval = efi_set_rtc_mmss(now.tv_sec);
> +	else
> +		retval = set_rtc_mmss(now.tv_sec);
> +	spin_unlock(&rtc_lock);
> +
> +	return retval;
>  }
>  
>  void main_timer_handler(void)
> @@ -195,14 +201,11 @@
>  	return IRQ_HANDLED;
>  }
>  
> -unsigned long read_persistent_clock(void)
> +unsigned long read_cmos_clock(void)
>  {
>  	unsigned int year, mon, day, hour, min, sec;
> -	unsigned long flags;
>  	unsigned century = 0;
>  
> -	spin_lock_irqsave(&rtc_lock, flags);
> -
>  	do {
>  		sec = CMOS_READ(RTC_SECONDS);
>  		min = CMOS_READ(RTC_MINUTES);
> @@ -217,8 +220,6 @@
>  #endif
>  	} while (sec != CMOS_READ(RTC_SECONDS));
>  
> -	spin_unlock_irqrestore(&rtc_lock, flags);
> -
>  	/*
>  	 * We know that x86-64 always uses BCD format, no need to check the
>  	 * config register.
> @@ -246,6 +247,20 @@
>  	return mktime(year, mon, day, hour, min, sec);
>  }
>  
> +unsigned long read_persistent_clock(void)
> +{
> +	unsigned long flags, retval;
> +
> +	spin_lock_irqsave(&rtc_lock, flags);
> +	if (efi_enabled)
> +		retval = efi_get_time();
> +	else
> +		retval = read_cmos_clock();
> +	spin_unlock_irqrestore(&rtc_lock, flags);
> +
> +	return retval;
> +}
> +
>  /* calibrate_cpu is used on systems with fixed rate TSCs to determine
>   * processor frequency */
>  #define TICK_COUNT 100000000
