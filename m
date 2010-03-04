Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab0CDVXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 16:23:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756515Ab0CDVXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 16:23:34 -0500
Date: Thu, 4 Mar 2010 13:23:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: <linux-kernel@vger.kernel.org>, <cpufreq@vger.kernel.org>,
       <bhavna.sarathy@amd.com>, <joachim.deguara@amd.com>,
       <borislav.petkov@amd.com>
Subject: Re: [PATCH 2/3] [cpufreq] powernow-k8: add core performance boost
 support
Message-Id: <20100304132328.3391dba5.akpm@linux-foundation.org>
In-Reply-To: <201003031458.27538.mark.langsdorf@amd.com>
References: <201003031458.27538.mark.langsdorf@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Mar 2010 14:58:27 -0600
Mark Langsdorf <mark.langsdorf@amd.com> wrote:

> >From 7b1c9670d8f04d67cde9f810ef462ec8a8d3adbf Mon Sep 17 00:00:00 2001
> From: Mark Langsdorf <mark.langsdorf@amd.com>
> Date: Wed, 3 Mar 2010 14:33:43 -0600
> Subject: [PATCH 1/2] powernow-k8: add core performance boost support
> 
> Add CPUID check for hardware CPB support
> 
> Also, update copyright while at it.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
> ---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   41 ++++++++++++++++++++++++++---
>  arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
>  include/linux/cpufreq.h                   |    4 +++
>  3 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 07f18a4..0a6f1f8 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -1,6 +1,5 @@
> -
>  /*
> - *   (c) 2003-2006 Advanced Micro Devices, Inc.
> + *   (c) 2003-2009 Advanced Micro Devices, Inc.
>   *  Your use of this code is subject to the terms and conditions of the
>   *  GNU general public license version 2. See "COPYING" or
>   *  http://www.gnu.org/licenses/gpl.html
> @@ -57,6 +56,9 @@ static int cpu_family = CPU_OPTERON;
>  
>  static struct cpufreq_driver cpufreq_amd64_driver;
>  
> +/* core performance boost */
> +static bool cpb_capable;
> +
>  #ifndef CONFIG_SMP
>  static inline const struct cpumask *cpu_core_mask(int cpu)
>  {
> @@ -511,6 +513,24 @@ static int core_voltage_post_transition(struct powernow_k8_data *data,
>  	return 0;
>  }
>  
> +/* CPB 0=disable, 1=enable. */
> +static void cpb_toggle(u32 t)
> +{
> +	if (cpb_capable) {
> +		u32 lo, hi;
> +		rdmsr(MSR_K7_HWCR, lo, hi);
> +

The newline usually goes after end-of-locals, before start-of-code.

> +		if (t)
> +			lo &= ~(1 << 25);
> +		else
> +			lo |= (1 << 25);
> +
> +		wrmsr(MSR_K7_HWCR, lo, hi);
> +
> +		printk(KERN_ERR "CPB: %s.\n", (t ? "on" : "off"));

Why KERN_ERR?  It's not an error?

Do we want a printk here at all?  Under which circumstances will it come
out?  Does it have sufficient context for people to be able to
understand what it means, and which subsystem it's referring to?  If
you phone your Aunt Tillie and tell her "CPB: on", will she understand
what you mean?

> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -104,6 +104,10 @@ struct cpufreq_policy {
>  
>  	struct kobject		kobj;
>  	struct completion	kobj_unregister;
> +
> +	struct flags {
> +		unsigned long cpb:1;	/* toggle CPB on this cpu */
> +	} flags;
>  };

Bear in mind that the compiler provides no atomicity support for
bitfields.  So if someone later comes along and adds a new field to
`flags', they will need to provide external synchronisation (ie: a
lock) to protect that field during modifications to `cpb'.

IOW, this is a bit of a hand-grenade.
