Return-Path: <linux-kernel-owner+w=401wt.eu-S1752275AbZEJFEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbZEJFEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 01:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbZEJFEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 01:04:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:55805 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZEJFEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 01:04:21 -0400
Subject: Re: [tip:perfcounters/core] perf_counter, x86: remove
 X86_FEATURE_ARCH_PERFMON flag for AMD cpus
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
References: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
	 <tip-da1a776be1ac7f78bb30ececbec4c1383163b079@git.kernel.org>
Content-Type: text/plain
Date: Sun, 10 May 2009 10:32:33 +0530
Message-Id: <1241931753.4796.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Robert,

On Wed, 2009-04-29 at 13:03 +0000, tip-bot for Robert Richter wrote:
> Commit-ID:  da1a776be1ac7f78bb30ececbec4c1383163b079
> Gitweb:     http://git.kernel.org/tip/da1a776be1ac7f78bb30ececbec4c1383163b079
> Author:     Robert Richter <robert.richter@amd.com>
> AuthorDate: Wed, 29 Apr 2009 12:46:58 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 29 Apr 2009 14:51:00 +0200
> 
> perf_counter, x86: remove X86_FEATURE_ARCH_PERFMON flag for AMD cpus
> 
> X86_FEATURE_ARCH_PERFMON is an Intel hardware feature that does not
> work on AMD CPUs. The flag is now only used in Intel specific code
> (especially initialization).
> 

I think X86_FEATURE_ARCH_PERFMON should be for all x86 cpus which
support performance monitor.

#define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Intel Architectural PerfMon */
should be replaced by
#define X86_FEATURE_ARCH_PERFMON (3*32+11) /* Performace Monitor */

All x86 cpus which support performance monitor should set this feature.

> [ Impact: refactor code ]
> 
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

ack by Peter ;-)

> Cc: Paul Mackerras <paulus@samba.org>
> LKML-Reference: <1241002046-8832-2-git-send-email-robert.richter@amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/amd.c          |    4 ----
>  arch/x86/kernel/cpu/perf_counter.c |    6 +++---
>  2 files changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index fd69c51..7e4a459 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -420,10 +420,6 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
>  	if (c->x86 >= 6)
>  		set_cpu_cap(c, X86_FEATURE_FXSAVE_LEAK);
>  
> -	/* Enable Performance counter for K7 and later */
> -	if (c->x86 > 6 && c->x86 <= 0x11)
> -		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);
> -


This should not be removed. This checks whether performance monitor
support is enable for AMD or not.

I think AMD will also support performance monitor for future models so:

	/* Enable Performance counter for K7 and later */
	if (c->x86 > 6)
		set_cpu_cap(c, X86_FEATURE_ARCH_PERFMON);


> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 0fcbaab..7d0f81d 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -949,6 +949,9 @@ static struct pmc_x86_ops *pmc_intel_init(void)
>  	unsigned int unused;
>  	unsigned int ebx;
>  
> +	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
> +		return NULL;
> +
>  	/*
>  	 * Check whether the Architectural PerfMon supports
>  	 * Branch Misses Retired Event or not.
> @@ -987,9 +990,6 @@ static struct pmc_x86_ops *pmc_amd_init(void)
>  
>  void __init init_hw_perf_counters(void)
>  {
> -	if (!cpu_has(&boot_cpu_data, X86_FEATURE_ARCH_PERFMON))
> -		return;
> -

This is not safe for AMD. why you move this to intel only ? this checks
whether performance monitor is enable or disable.

For AMD, Is performance monitor is supported for < K7. where are you
checking it.

--
JSR

