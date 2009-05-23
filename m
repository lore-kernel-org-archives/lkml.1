Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbZEWKpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbZEWKpb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 06:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752401AbZEWKpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 06:45:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:44488 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZEWKpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 06:45:16 -0400
Subject: Re: [patch 1/2] x86: Add pm_play_dead funcptr to power-efficiently
 offline CPUs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: venkatesh.pallipadi@intel.com
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, lenb@kernel.org, shaohua.li@intel.com,
       svaidy@linux.vnet.ibm.com
In-Reply-To: <20090522232230.020301000@intel.com>
References: <20090522231940.553094000@intel.com>
	 <20090522232230.020301000@intel.com>
Content-Type: text/plain
Date: Sat, 23 May 2009 12:44:58 +0200
Message-Id: <1243075498.6582.1049.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 16:19 -0700, venkatesh.pallipadi@intel.com wrote:
> plain text document attachment
> (0001-x86-Add-pm_play_dead-funcptr-to-power-efficiently-o.patch)
> Add a funcptr pm_play_dead (similar to pm_idle) that can take
> the offline CPUs to the most power efficient idle state.
> 
> This patch just adds the func pointer. The pointer will get initialized
> by patch that follows.

Since the pm_idle function pointer has given us so much grief, I don't
think its wise to repeat that particular disaster.

I'd much rather see a framework where idle functions can be registered,
and selected from based on criteria such as wakeup latency as provided
by the pm_qos stuff, and power saving.

This framework should be shared between hotplug-idle and the regular
idle routines. Hotplug would of course not care about things like wakeup
latency and might therefore pick another idle routine.

> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> ---
>  arch/x86/include/asm/smp.h |    2 ++
>  arch/x86/kernel/smpboot.c  |    7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> index 19e0d88..0388b81 100644
> --- a/arch/x86/include/asm/smp.h
> +++ b/arch/x86/include/asm/smp.h
> @@ -148,6 +148,8 @@ static inline int num_booting_cpus(void)
>  {
>  	return cpumask_weight(cpu_callout_mask);
>  }
> +
> +extern void (*pm_play_dead)(void);
>  #endif /* CONFIG_SMP */
>  
>  extern unsigned disabled_cpus __cpuinitdata;
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 58d24ef..4f8af6a 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1195,6 +1195,8 @@ __init void prefill_possible_map(void)
>  	nr_cpu_ids = possible;
>  }
>  
> +void (*pm_play_dead)(void) = NULL;
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  
>  static void remove_siblinginfo(int cpu)
> @@ -1313,7 +1315,10 @@ void play_dead_common(void)
>  void native_play_dead(void)
>  {
>  	play_dead_common();
> -	wbinvd_halt();
> +	if (pm_play_dead)
> +		pm_play_dead();
> +	else
> +		wbinvd_halt();
>  }
>  
>  #else /* ... !CONFIG_HOTPLUG_CPU */
> -- 
> 1.6.0.6
> 

