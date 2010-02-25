Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab0BYSVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:21:55 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:26904 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933070Ab0BYSVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:21:53 -0500
X-SpamScore: -27
X-BigFish: VPS-27(zz542N1432R62a3L9371Pab9bhzz1202hzzz32i6bh43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KYETO1-02-RXQ-02
X-M-MSG: 
From: "Langsdorf, Mark" <mark.langsdorf@amd.com>
To: =?iso-8859-1?Q?=27Robert_Sch=F6ne=27?= 
	<robert.schoene@tu-dresden.de>
CC: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 25 Feb 2010 12:21:41 -0600
Subject: RE: [PATCH] tracing: add event power_frequency to powernow-k8 driver
Thread-Topic: [PATCH] tracing: add event power_frequency to powernow-k8
 driver
Thread-Index: Acq2A9B89jTZX9ruTr+HyiDfrjWr6QAQ4i/A
Message-ID: <DDE95BDD51FB774B804A9C029E735EE103DCE25576@sausexmbp02.amd.com>
References: <1267093075.3369.5.camel@localhost>
In-Reply-To: <1267093075.3369.5.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Mark Langsdorf <mark.langsdorf@amd.com> 

> -----Original Message-----
> From: Robert Schöne [mailto:robert.schoene@tu-dresden.de] 
> Sent: Thursday, February 25, 2010 4:18 AM
> To: Langsdorf, Mark
> Cc: cpufreq@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] tracing: add event power_frequency to 
> powernow-k8 driver
> 
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
> \
> +        for_each_cpu(i,avail_cores)
> \
> +               smp_call_function_single(i, trace_power_event,
> &frequency, 1);
> +
> +#else /* !CONFIG_POWER_TRACER */
> +
> +       #define TRACE_POWER_FREQUENCY_EVENT(i,avail_cores, 
> frequency) ;
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
> +       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, 
> freqs.new);
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
> +       TRACE_POWER_FREQUENCY_EVENT(i,data->available_cores, 
> freqs.new);
> +
>         for_each_cpu(i, data->available_cores) {
>                 freqs.cpu = i;
>                 cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
> 
> 
> 
> 
> -- 
> Robert Schoene
> Technische Universitaet Dresden
> Zentrum fuer Informationsdienste und Hochleistungsrechnen
> 01062 Dresden
> 
> Tel.: (0351) 463-42483, Fax: (0351) 463-37773
> E-Mail: Robert.Schoene@tu-dresden.de
> 
> 
> 
