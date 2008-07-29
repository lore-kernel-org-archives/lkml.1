Return-Path: <linux-kernel-owner+w=401wt.eu-S1757611AbYG2KNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757611AbYG2KNg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 06:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbYG2KN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 06:13:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:59264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881AbYG2KN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 06:13:26 -0400
Subject: Re: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200807290309.44869.yhlu.kernel@gmail.com>
References: <200807290308.35230.yhlu.kernel@gmail.com>
	 <200807290309.44869.yhlu.kernel@gmail.com>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 12:13:07 +0200
Message-Id: <1217326387.7563.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 03:09 -0700, Yinghai Lu wrote:
> so can get tsc value on printk
> 
> need to apply after
> 	[PATCH] printk_time: prepare stub for using other than cpu_clock


You failed to mention why we want this... ;-)


> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/cpu/common.c    |   11 +++++++++++
>  arch/x86/kernel/cpu/common_64.c |   12 ++++++++++++
>  2 files changed, 23 insertions(+)
> 
> Index: linux-2.6/arch/x86/kernel/cpu/common.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common.c
> +++ linux-2.6/arch/x86/kernel/cpu/common.c
> @@ -617,6 +617,15 @@ __setup("clearcpuid=", setup_disablecpui
>  
>  cpumask_t cpu_initialized __cpuinitdata = CPU_MASK_NONE;
>  
> +static unsigned long long tsc_clock(int cpu)
> +{
> +	unsigned long long t;
> +
> +	rdtscll(t);
> +
> +	return t;
> +}
> +
>  void __init early_cpu_init(void)
>  {
>  	struct cpu_vendor_dev *cvdev;
> @@ -627,6 +636,8 @@ void __init early_cpu_init(void)
>  		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
>  
>  	early_cpu_detect();
> +	if (cpu_has_tsc)
> +		set_printk_time_clock(tsc_clock);
>  	validate_pat_support(&boot_cpu_data);
>  }
>  
> Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
> +++ linux-2.6/arch/x86/kernel/cpu/common_64.c
> @@ -215,6 +215,15 @@ static void __init early_cpu_support_pri
>  	}
>  }
>  
> +static unsigned long long tsc_clock(int cpu)
> +{
> +	unsigned long long t;
> +
> +	rdtscll(t);
> +
> +	return t;
> +}
> +
>  static void __cpuinit early_identify_cpu(struct cpuinfo_x86 *c);
>  
>  void __init early_cpu_init(void)
> @@ -227,6 +236,9 @@ void __init early_cpu_init(void)
>                  cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
>  	early_cpu_support_print();
>  	early_identify_cpu(&boot_cpu_data);
> +
> +	if (cpu_has_tsc)
> +		set_printk_time_clock(tsc_clock);
>  }
>  
>  /* Do some early cpuid on the boot CPU to get some parameter that are
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

