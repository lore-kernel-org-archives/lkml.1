Return-Path: <linux-kernel-owner+w=401wt.eu-S1760368AbZD2LIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368AbZD2LIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 07:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760245AbZD2LHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 07:07:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58309 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684AbZD2LHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 07:07:45 -0400
Subject: Re: [PATCH 04/29] x86/perfcounters: rework
 pmc_amd_save_disable_all() and pmc_amd_restore_all()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1241002046-8832-5-git-send-email-robert.richter@amd.com>
References: <1241002046-8832-1-git-send-email-robert.richter@amd.com>
	 <1241002046-8832-5-git-send-email-robert.richter@amd.com>
Content-Type: text/plain
Date: Wed, 29 Apr 2009 13:07:40 +0200
Message-Id: <1241003260.8021.236.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-29 at 12:47 +0200, Robert Richter wrote:
> MSR reads and writes are expensive. This patch adds checks to avoid
> its usage where possible.

save_disable_all()
enable(1)
restore_all()

would not correctly enable 1 with the below modification as we do not
write the configuration into the msr, on which restore relies, as it
only toggles the _ENABLE bit.

That said, I'm not sure if that's really an issue, but its why the does
does as it does.

A better abstraction could perhaps avoid this issue all-together.

> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/kernel/cpu/perf_counter.c |   24 ++++++++++++++----------
>  1 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
> index d6d6529..75a0903 100644
> --- a/arch/x86/kernel/cpu/perf_counter.c
> +++ b/arch/x86/kernel/cpu/perf_counter.c
> @@ -334,11 +334,13 @@ static u64 pmc_amd_save_disable_all(void)
>  	for (idx = 0; idx < nr_counters_generic; idx++) {
>  		u64 val;
>  
> +		if (!test_bit(idx, cpuc->active_mask))
> +			continue;
>  		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
> -		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE) {
> -			val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
> -			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
> -		}
> +		if (!(val & ARCH_PERFMON_EVENTSEL0_ENABLE))
> +			continue;
> +		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
> +		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
>  	}
>  
>  	return enabled;
> @@ -372,13 +374,15 @@ static void pmc_amd_restore_all(u64 ctrl)
>  		return;
>  
>  	for (idx = 0; idx < nr_counters_generic; idx++) {
> -		if (test_bit(idx, cpuc->active_mask)) {
> -			u64 val;
> +		u64 val;
>  
> -			rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
> -			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
> -			wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
> -		}
> +		if (!test_bit(idx, cpuc->active_mask))
> +			continue;
> +		rdmsrl(MSR_K7_EVNTSEL0 + idx, val);
> +		if (val & ARCH_PERFMON_EVENTSEL0_ENABLE)
> +			continue;
> +		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
> +		wrmsrl(MSR_K7_EVNTSEL0 + idx, val);
>  	}
>  }
>  

