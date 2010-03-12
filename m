Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265Ab0CLOwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 09:52:32 -0500
Received: from mga05.intel.com ([192.55.52.89]:2860 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758040Ab0CLOwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 09:52:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,626,1262592000"; 
   d="scan'208";a="548494695"
Message-ID: <4B9A552D.6080103@linux.intel.com>
Date: Fri, 12 Mar 2010 06:52:29 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Robert_Sch=F6ne?= <robert.schoene@tu-dresden.de>
CC: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       cpufreq <cpufreq@vger.kernel.org>, x86@kernel.org
Subject: Re: [PATCH] trace power_frequency events on the correct cpu  (for
 Intel x86 CPUs)
References: <1268399863.3407.15.camel@localhost>
In-Reply-To: <1268399863.3407.15.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2010 5:17, Robert Schöne wrote:
> This patch fixes the following behaviour:
> Currently, the power_frequency event is reported for the cpu (core) which initiated the frequency change.
> It should be reported for the cpu that actually changes its frequency.
>
> Example: when using
>   taskset -c 0 echo<new_frequency>  >  /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed
> cpu 0 is traced, instead of cpu 1
>
> Signed of by Robert Schoene<robert.schoene@tu-dresden.de>
>
>
> diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> index 1b1920f..0a47f10 100644
> --- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> +++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
> @@ -174,6 +174,7 @@ static void do_drv_write(void *_cmd)
>
>          switch (cmd->type) {
>          case SYSTEM_INTEL_MSR_CAPABLE:
> +               trace_power_frequency(POWER_PSTATE, cmd->val);
>                  rdmsr(cmd->addr.msr.reg, lo, hi);
>                  lo = (lo&  ~INTEL_MSR_RANGE) | (cmd->val&  INTEL_MSR_RANGE);
>                  wrmsr(cmd->addr.msr.reg, lo, hi);
> @@ -363,7 +364,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
>                  }
>          }
>
> -       trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
>
>          switch (data->cpu_feature) {
>          case SYSTEM_INTEL_MSR_CAPABLE:
>
>

are you sure this is right?
it's moving something from outside a switch statement to inside only one prong of a switch statement...

