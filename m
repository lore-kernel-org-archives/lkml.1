Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbZCLBo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbZCLBo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZCLBor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:44:47 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:58981
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752054AbZCLBoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:44:46 -0400
X-BigFish: VPS-40(zz1432R62a3L98dR936eQ1805M936fKzz1202hzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KGDE5Z-03-3ZA-01
Date: Thu, 12 Mar 2009 02:44:16 +0100
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perfcounters: IRQ and NMI support on
	AMD CPUs
Message-ID: <20090312014415.GD10105@erda.amd.com>
References: <1236273633.5187.286.camel@laptop> <tip-b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <tip-b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b@git.kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 12 Mar 2009 01:44:16.0181 (UTC) FILETIME=[0D8B3650:01C9A2B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.03.09 17:27:29, Peter Zijlstra wrote:
> Commit-ID:  b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
> Gitweb:     http://git.kernel.org/tip/b0f3f28e0f14eb335f67bfaae33ce8b8d74fd58b
> Author:     "Peter Zijlstra" <a.p.zijlstra@chello.nl>
> AuthorDate: Thu, 5 Mar 2009 18:08:27 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 5 Mar 2009 18:25:16 +0100
> 
> perfcounters: IRQ and NMI support on AMD CPUs
> 
> The below completes the K7+ performance counter support:
> 
>  - IRQ support
>  - NMI support
> 
> KernelTop output works now as well.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> LKML-Reference: <1236273633.5187.286.camel@laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/kernel/cpu/perf_counter.c |  272 ++++++++++++++++++++++++++++++------
>  1 files changed, 228 insertions(+), 44 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index 3b65f19..6ebe9ab 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c

[...]

> @@ -205,18 +243,24 @@ static u64 pmc_intel_save_disable_all(void)
>  
>  static u64 pmc_amd_save_disable_all(void)
>  {
> -	int idx;
> -	u64 val, ctrl = 0;
> +	struct cpu_hw_counters *cpuc = &__get_cpu_var(cpu_hw_counters);
> +	int enabled, idx;
> +
> +	enabled = cpuc->enabled;
> +	cpuc->enabled = 0;
> +	barrier();

Peter,

please add comments to all barrier()s you added to this file. Is it
sufficient in hw_perf_save_disable() to stop NMI's only on the current
core?

-Robert

>  
>  	for (idx = 0; idx < nr_counters_generic; idx++) {
> +		u64 val;
> +
>  		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
> -		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
> -			ctrl |= (1 << idx);
> -		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
> -		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
> +		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
> +			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
> +			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
> +		}
>  	}
>  
> -	return ctrl;
> +	return enabled;
>  }
>  
>  u64 hw_perf_save_disable(void)

[...]

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

