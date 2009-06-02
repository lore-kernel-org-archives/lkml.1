Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbZFBOQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbZFBOQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 10:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754269AbZFBOQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 10:16:42 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:32797 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbZFBOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:16:41 -0400
Date: Tue, 2 Jun 2009 19:46:06 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: poornima nayak <mpnayak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       davej@redhat.com, ego@in.ibm.com
Subject: Re: Performance regression in 2.6.30-rc1
Message-ID: <20090602141606.GU5077@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1243940419.6885.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1243940419.6885.48.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Poornima Nayak <mpnayak@linux.vnet.ibm.com> [2009-06-02 16:30:19]:

> Hi 
> 
> By executing kernbench on 2.6.30-rc1 we observed there is a performance
> regression in 2.6.30-rc1. Then git-bisect was done between v2.6.29 and
> v2.6.30-rc5, after 13 iterations identified the attached patch is
> causing regression.
> 
> Performance data of 2.6.29 without applying the attached patch.
> param-version
> testname
> elapsed-avg
> elapsed-std
> 2.6.29'
> pm_kernbench.Version-none-threads=2-sched_mc=2
>              221.1
>               0.81
> 2.6.29'
> pm_kernbench.Version-none-threads=4-sched_mc=0
>             115.09
>                0.6
> 2.6.29'
> pm_kernbench.Version-none-threads=4-sched_mc=2
>             109.05
>               0.25
> 2.6.29'
> pm_kernbench.Version-none-threads=8-sched_mc=2
>               60.4
>               0.38
> 2.6.29'
> pm_kernbench.Version-none-threads=8-sched_mc=0
>              65.23
>               0.34
> 2.6.29'
> pm_kernbench.Version-none-threads=2-sched_mc=0
>             231.61
>               0.59
> 
> Performance data of 2.6.29 after applying the attached patch.
> param-version
> testname
> elapsed-avg
> elapsed-std
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=2-sched_mc=0
>             203.77
>               0.48
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=8-sched_mc=0
>              64.38
>               0.25
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=4-sched_mc=0
>             102.46
>                0.1
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=8-sched_mc=2
>              59.94
>               0.46
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=4-sched_mc=2
>             106.84
>               0.28
> 2.6.29'
> pm_kernbench.Version-thir-bisect-threads=2-sched_mc=2
>             199.44
>               0.44
> 
> Performance issue here is when sched_mc_power_savings is set 2 and
> kernbench is triggered with 4 threads the value of 'elapsed time' is
> more then sched_mc_power_savings is set to 0. Expectation is elapsed
> time should be less when sched_mc_power_savings set 2 compared to
> sched_mc_power_savings set to 0.

Hi Poornima,

The table seems to be mangled.  Can you please resend and also sort
the results so that sched_mc=0,2 for the same number of threads come
together.  It is difficult to follow the results.

Also there seem to be a 10% improvement at each run level with the
patch.  So why are you claiming this as a performance regression?

sched_mc 2 over 0 is 4 sec more only in the 4 threaded case, but
overall improvement in other scenarios.

I assume you have run this on a 8 core box.

Also did you see this code being invoked on the test machine.  Did you
see the "Capping off P-state tranision latency" print.  This patch may
be affecting the ondemand governor, but I an unable to related this to
performance impact.

--Vaidy


> 
> Regds
> Poornima

> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 4b1c319..89c676d 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -680,6 +680,18 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
>  			    perf->states[i].transition_latency * 1000;
>  	}
> 
> +	/* Check for high latency (>20uS) from buggy BIOSes, like on T42 */
> +	if (perf->control_register.space_id == ACPI_ADR_SPACE_FIXED_HARDWARE &&
> +	    policy->cpuinfo.transition_latency > 20 * 1000) {
> +		static int print_once;
> +		policy->cpuinfo.transition_latency = 20 * 1000;
> +		if (!print_once) {
> +			print_once = 1;
> +			printk(KERN_INFO "Capping off P-state tranision latency"
> +				" at 20 uS\n");
> +		}
> +	}
> +
>  	data->max_freq = perf->states[0].core_frequency * 1000;
>  	/* table init */
>  	for (i=0; i<perf->state_count; i++) {

