Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbYLNGTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbYLNGTM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 01:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750860AbYLNGS5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 01:18:57 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47885 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750699AbYLNGS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 01:18:56 -0500
Date: Sat, 13 Dec 2008 22:18:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] add command line init_start_cpus
Message-Id: <20081213221842.583f1e38.akpm@linux-foundation.org>
In-Reply-To: <4944A279.5020009@kernel.org>
References: <4944A279.5020009@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Dec 2008 22:06:49 -0800 Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: new command line
> 
> so could select cpus to be started during init stage
> 

Please always always always provide a description of the *reason* for
making a change to the kernel.  For patches other than bugfixes, this
is the most important part of the patch, because without a reason, why
should we even look at the code changes?

> 
> ---
>  Documentation/kernel-parameters.txt |   14 ++++++++++++++
>  init/main.c                         |   29 ++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/kernel-parameters.txt
> +++ linux-2.6/Documentation/kernel-parameters.txt
> @@ -918,6 +918,20 @@ and is between 256 and 4096 characters.
>  		forcesac
>  		soft
>  
> +	init_start_cpus=	[KNL,SMP] set CPUs that will be started during
> +			init stage.
> +			Format:
> +			<cpu number>,...,<cpu number>
> +			or
> +			<cpu number>-<cpu number>
> +			(must be a positive range in ascending order)
> +			or a mixture
> +			<cpu number>,...,<cpu number>-<cpu number>
> +
> +			This option can be used to specify one or more CPUs
> +			to be started during init stage.
> +			<cpu number> begins at 0 and the maximum value is
> +			"number of CPUs in system - 1".

I can't even begin to imagine why would we want this feature.

>  	intel_iommu=	[DMAR] Intel IOMMU driver (DMAR) option
>  		off
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c

Can we put this all somewhere else? init/main.c is a random dumping ground.

Perhaps kernel/cpu.c would be appropriate.  There's a bunch of other
cpumasky stuff in init/main.c which could also be moved into cpu.c
(and tidied up - it's a godawful ifdef mess).

> @@ -413,11 +413,35 @@ static void __init setup_per_cpu_areas(v
>  }
>  #endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
>  
> +static __initdata cpumask_var_t cpu_init_start_mask;
> +
> +/* Setup the mask of cpus configured for init start */
> +static int __init init_start_cpu_setup(char *str)
> +{
> +	cpulist_parse(str, *cpu_init_start_mask);
> +
> +	return 1;
> +}
> +
> +__setup("init_start_cpus=", init_start_cpu_setup);
> +
>  /* Called by boot processor to activate the rest. */
>  static void __init smp_init(void)
>  {
>  	unsigned int cpu;
> +	struct cpumask *start_mask;
> +
> +	if (cpumask_empty(cpu_init_start_mask))
> +		start_mask = &cpu_present_map;
> +	else {
> +		start_mask = kmalloc(cpumask_size(), GFP_KERNEL);

Why is this dynamically allocated?  I'd have though that a simple
__initdata static store would suit?


> +		if (!start_mask)
> +			start_mask = &cpu_present_map;
> +		else
> +			cpumask_and(start_mask, cpu_init_start_mask,
> +					 &cpu_present_map);
> +	}
>  	/*
>  	 * Set up the current CPU as possible to migrate to.
>  	 * The other ones will be done by cpu_up/cpu_down()
> @@ -426,13 +450,16 @@ static void __init smp_init(void)
>  	cpu_set(cpu, cpu_active_map);
>  
>  	/* FIXME: This should be done in userspace --RR */
> -	for_each_present_cpu(cpu) {
> +	for_each_cpu_mask_nr(cpu, *start_mask) {
>  		if (num_online_cpus() >= setup_max_cpus)
>  			break;
>  		if (!cpu_online(cpu))
>  			cpu_up(cpu);
>  	}
>  
> +	if (start_mask != &cpu_present_map)
> +		kfree(start_mask);
> +

