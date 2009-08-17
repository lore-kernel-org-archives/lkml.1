Return-Path: <linux-kernel-owner+w=401wt.eu-S1758340AbZHQXCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340AbZHQXCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 19:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758313AbZHQXCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 19:02:18 -0400
Received: from mail.vyatta.com ([76.74.103.46]:54712 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbZHQXCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 19:02:18 -0400
Date: Mon, 17 Aug 2009 16:02:12 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: clocksource changes in 2.6.31 - possible regression
Message-ID: <20090817160212.029b3e42@nehalam>
In-Reply-To: <1250547802.7212.82.camel@localhost.localdomain>
References: <20090817090319.20979986@nehalam>
	<1250531337.26171.12.camel@work-vm>
	<20090817110127.40ee5c29@nehalam>
	<1250532954.26171.35.camel@work-vm>
	<20090817112704.2b4b2987@nehalam>
	<1250543459.7212.41.camel@localhost.localdomain>
	<1250545077.7212.49.camel@localhost.localdomain>
	<20090817144546.7f1d6572@nehalam>
	<1250547802.7212.82.camel@localhost.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 15:23:22 -0700
john stultz <johnstul@us.ibm.com> wrote:

> On Mon, 2009-08-17 at 14:45 -0700, Stephen Hemminger wrote:
> > On Mon, 17 Aug 2009 14:37:57 -0700
> > john stultz <johnstul@us.ibm.com> wrote:
> > > However, I think its fair, that as your TSC is being disqualified for
> > > being an old AMD SMP box, and there is a *possibility* that if you don't
> > > run with cpufreq and the SUMA-ness of the box didn't get in the way of
> > > TSC synchronization, you might have an argument for overriding the
> > > unsynchronized_tsc() heuristics.
> > > 
> > > Luckily the option is already there. :)
> > > 
> > > So try booting with "tsc=reliable" to override those checks, and I think
> > > you'll be able to do what you want to do.
> > > 
> > 
> > Good idea, doesn't work.
> > 
> > vyatta@amd1:~$ cat /proc/cmdline 
> > BOOT_IMAGE=/boot/vmlinuz-2.6.31-rc6 root=/dev/sda1 ro tsc=reliable
> > vyatta@amd1:~$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
> > acpi_pm 
> 
> Bah! My apologies for half-assing this. 
> 
> How about with the following *tested* patch (includes a variant of
> Thomas' fix). 
> 
> thanks
> -john
> 
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 71f4368..648fb26 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -825,6 +825,9 @@ __cpuinit int unsynchronized_tsc(void)
>  
>  	if (boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
>  		return 0;
> +
> +	if (tsc_clocksource_reliable)
> +		return 0;
>  	/*
>  	 * Intel systems are normally all synchronized.
>  	 * Exceptions must mark TSC as unstable:
> @@ -832,10 +835,10 @@ __cpuinit int unsynchronized_tsc(void)
>  	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL) {
>  		/* assume multi socket systems are not synchronized: */
>  		if (num_possible_cpus() > 1)
> -			tsc_unstable = 1;
> +			return 1;
>  	}
>  
> -	return tsc_unstable;
> +	return 0;
>  }
>  
>  static void __init init_tsc_clocksource(void)
> 
> 

This adds tsc, but makes it first?  it is reliable, but do I want
to make it most important?

$ cat /sys/devices/system/clocksource/clocksource0/available_clocksource
tsc acpi_pm

-- 
