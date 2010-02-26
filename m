Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935121Ab0BZDdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 22:33:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53555 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935056Ab0BZDdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 22:33:15 -0500
Message-ID: <4B874125.7040003@cn.fujitsu.com>
Date: Fri, 26 Feb 2010 11:33:57 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
CC: "Langsdorf, Mark" <mark.langsdorf@amd.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing: add event power_frequency to powernow-k8 driver
References: <1267093075.3369.5.camel@localhost>
In-Reply-To: <1267093075.3369.5.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schöne wrote:
> This patch adds frequency tracing to the powernow-k8 cpufreq driver
> 
> diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> index 6e44519..99034e7 100644
> --- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> +++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
> @@ -37,6 +37,10 @@
>  #include <linux/io.h>
>  #include <linux/delay.h>
>  
> +#ifdef CONFIG_POWER_TRACER
> +#include <trace/events/power.h> /* tracing power events */
> +# endif /* CONFIG_POWER_TRACER */
> +
>  #include <asm/msr.h>
>  
>  #include <linux/acpi.h>
> @@ -54,6 +58,25 @@ static DEFINE_PER_CPU(struct powernow_k8_data *,
> powernow_data);
>  
>  static int cpu_family = CPU_OPTERON;
>  
> +
> +/* only trace power if it is selected */
> +#ifdef CONFIG_POWER_TRACER
> +       /* trace power event on a specific cpu/core */
> +       static void trace_power_event(unsigned int *freq){
> +               trace_power_frequency(POWER_PSTATE, *freq);
> +       }
> +
> +       #define TRACE_POWER_FREQUENCY_EVENT(i,avail_cores, frequency)

ERROR: space required after that ','

> \
> +        for_each_cpu(i,avail_cores)
> \
> +               smp_call_function_single(i, trace_power_event,
> &frequency, 1);

CONFIG_POWER_TRACER has gone. I don't know if smp_call_function_single()
is necessary, if not necessary, those #ifs are not needed, otherwise
you can use CONFIG_TRACING instead of CONFIG_POWER_TRACER.

> +
> +#else /* !CONFIG_POWER_TRACER */
> +
> +       #define TRACE_POWER_FREQUENCY_EVENT(i,avail_cores, frequency) ;
> +
> +# endif /* end CONFIG_POWER_TRACER */
> +
> +
>  #ifndef CONFIG_SMP
>  static inline const struct cpumask *cpu_core_mask(int cpu)
>  {
> @@ -1074,6 +1097,8 @@ static int transition_frequency_fidvid(struct
> powernow_k8_data *data,
>         res = transition_fid_vid(data, fid, vid);
>         freqs.new = find_khz_freq_from_fid(data->currfid);
>  
> +       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
> +
>         for_each_cpu(i, data->available_cores) {
>                 freqs.cpu = i;
>                 cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> @@ -1107,6 +1132,8 @@ static int transition_frequency_pstate(struct
> powernow_k8_data *data,
>         res = transition_pstate(data, pstate);
>         freqs.new = find_khz_freq_from_pstate(data->powernow_table,
> pstate);
>  
> +       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, freqs.new);
> +
>         for_each_cpu(i, data->available_cores) {
>                 freqs.cpu = i;
>                 cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> 
> 
> 
> 
