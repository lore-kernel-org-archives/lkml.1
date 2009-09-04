Return-Path: <linux-kernel-owner+w=401wt.eu-S933314AbZIDJTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933314AbZIDJTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:19:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbZIDJTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:19:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933271AbZIDJTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:19:07 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][PATCH 10/14] x86: generic aperf/mperf code.
Date: Fri, 4 Sep 2009 11:19:05 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>, Dave Jones <davej@redhat.com>,
       Len Brown <len.brown@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       cpufreq@vger.kernel.org
References: <20090903132145.482814810@chello.nl> <20090903132213.006719409@chello.nl>
In-Reply-To: <20090903132213.006719409@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909041119.06979.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 September 2009 15:21:55 Peter Zijlstra wrote:
> Move some of the aperf/mperf code out from the cpufreq driver thingy
> so that other people can enjoy it too.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> Cc: Yanmin <yanmin_zhang@linux.intel.com>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Yinghai Lu <yhlu.kernel@gmail.com>
> Cc: cpufreq@vger.kernel.org
> ---
>  arch/x86/include/asm/processor.h           |   12 ++++++++
>  arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   41 
+++++++++--------------------
>  2 files changed, 26 insertions(+), 27 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/processor.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/processor.h
> +++ linux-2.6/arch/x86/include/asm/processor.h
> @@ -1000,4 +1000,16 @@ extern void start_thread(struct pt_regs 
>  extern int get_tsc_mode(unsigned long adr);
>  extern int set_tsc_mode(unsigned int val);
>  
> +struct aperfmperf {
> +	u64 aperf, mperf;
> +};
> +
> +static inline void get_aperfmperf(struct aperfmperf *am)
> +{
> +	WARN_ON_ONCE(!boot_cpu_has(X86_FEATURE_APERFMPERF));
> +
> +	rdmsrl(MSR_IA32_APERF, am->aperf);
> +	rdmsrl(MSR_IA32_MPERF, am->mperf);
> +}
> +
>  #endif /* _ASM_X86_PROCESSOR_H */
> Index: linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ linux-2.6/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -243,23 +243,12 @@ static u32 get_cur_val(const struct cpum
>  	return cmd.val;
>  }
>  
> -struct perf_pair {
> -	union {
> -		struct {
> -			u32 lo;
> -			u32 hi;
> -		} split;
> -		u64 whole;
> -	} aperf, mperf;
> -};
> -
>  /* Called via smp_call_function_single(), on the target CPU */
>  static void read_measured_perf_ctrs(void *_cur)
>  {
> -	struct perf_pair *cur = _cur;
> +	struct aperfmperf *am = _cur;
>  
> -	rdmsr(MSR_IA32_APERF, cur->aperf.split.lo, cur->aperf.split.hi);
> -	rdmsr(MSR_IA32_MPERF, cur->mperf.split.lo, cur->mperf.split.hi);
> +	get_aperfmperf(am);
>  }
>  
>  /*
> @@ -278,19 +267,17 @@ static void read_measured_perf_ctrs(void
>  static unsigned int get_measured_perf(struct cpufreq_policy *policy,
>  				      unsigned int cpu)
>  {
> -	struct perf_pair readin, cur;
> +	struct aperfmperf readin, cur;
>  	unsigned int perf_percent;
>  	unsigned int retval;
>  
>  	if (smp_call_function_single(cpu, read_measured_perf_ctrs, &readin, 
1))
>  		return 0;
>  
> -	cur.aperf.whole = readin.aperf.whole -
> -				per_cpu(msr_data, cpu).saved_aperf;
> -	cur.mperf.whole = readin.mperf.whole -
> -				per_cpu(msr_data, cpu).saved_mperf;
> -	per_cpu(msr_data, cpu).saved_aperf = readin.aperf.whole;
> -	per_cpu(msr_data, cpu).saved_mperf = readin.mperf.whole;
> +	cur.aperf = readin.aperf - per_cpu(msr_data, cpu).saved_aperf;
> +	cur.mperf = readin.mperf - per_cpu(msr_data, cpu).saved_mperf;
> +	per_cpu(msr_data, cpu).saved_aperf = readin.aperf;
> +	per_cpu(msr_data, cpu).saved_mperf = readin.mperf;
>  
>  #ifdef __i386__
>  	/*
> @@ -305,8 +292,8 @@ static unsigned int get_measured_perf(st
>  		h = max_t(u32, cur.aperf.split.hi, cur.mperf.split.hi);
You still use struct perf_pair split/hi/lo members in #ifdef __i386__ 
case which you deleted above.
>  		shift_count = fls(h);
>  
> -		cur.aperf.whole >>= shift_count;
> -		cur.mperf.whole >>= shift_count;
> +		cur.aperf >>= shift_count;
> +		cur.mperf >>= shift_count;
>  	}
>  
>  	if (((unsigned long)(-1) / 100) < cur.aperf.split.lo) {
Same here, possibly still elsewhere.
Is this only x86_64 compile tested?

     Thomas

> @@ -321,14 +308,14 @@ static unsigned int get_measured_perf(st
>  		perf_percent = 0;
>  
>  #else
> -	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf.whole)) {
> +	if (unlikely(((unsigned long)(-1) / 100) < cur.aperf)) {
>  		int shift_count = 7;
> -		cur.aperf.whole >>= shift_count;
> -		cur.mperf.whole >>= shift_count;
> +		cur.aperf >>= shift_count;
> +		cur.mperf >>= shift_count;
>  	}
>  
> -	if (cur.aperf.whole && cur.mperf.whole)
> -		perf_percent = (cur.aperf.whole * 100) / cur.mperf.whole;
> +	if (cur.aperf && cur.mperf)
> +		perf_percent = (cur.aperf * 100) / cur.mperf;
>  	else
>  		perf_percent = 0;
>  
> 
> -- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


