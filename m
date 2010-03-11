Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0CKEM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 23:12:57 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:33842 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab0CKEMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 23:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BrO7yR6RFTZtqDD2x5FQ2HcTPqdrLNESwOOPqOe99jUm5u5LoMIRjovPOuSavIhnxC
         ED+28gt1tOZcsW3EAjHazImTaJEIvLSxrVnp6jQnzREDPzxo6Cqjtb9EQLDmBn7c3LDG
         UIoIV7gUkPh4JuQk3tvdWB2vFKFnlEDy4b9Vc=
MIME-Version: 1.0
In-Reply-To: <1268274775.4996.16.camel@minggr.sh.intel.com>
References: <20100310183102.GC8070@lenovo>
	 <1268274775.4996.16.camel@minggr.sh.intel.com>
Date: Thu, 11 Mar 2010 07:12:52 +0300
X-Google-Sender-Auth: a9a76fe23b9b7798
Message-ID: <aa79d98a1003102012i6709e5c5vf2be45dbab2ded2@mail.gmail.com>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/10, Lin Ming <ming.m.lin@intel.com> wrote:
> On Thu, 2010-03-11 at 02:31 +0800, Cyrill Gorcunov wrote:
>> +static __initconst struct x86_pmu p4_pmu = {
>> +       .name                   = "Netburst P4/Xeon",
>> +       .handle_irq             = p4_pmu_handle_irq,
>> +       .disable_all            = p4_pmu_disable_all,
>> +       .enable_all             = p4_pmu_enable_all,
>> +       .enable                 = p4_pmu_enable_event,
>> +       .disable                = p4_pmu_disable_event,
>> +       .eventsel               = MSR_P4_BPU_CCCR0,
>> +       .perfctr                = MSR_P4_BPU_PERFCTR0,
>> +       .event_map              = p4_pmu_event_map,
>> +       .raw_event              = p4_pmu_raw_event,
>> +       .max_events             = ARRAY_SIZE(p4_event_map),
>> +       /*
>> +        * IF HT disabled we may need to use all
>> +        * ARCH_P4_MAX_CCCR counters simulaneously
>> +        * though leave it restricted at moment assuming
>> +        * HT is on
>> +        */
>> +       .num_events             = ARCH_P4_MAX_CCCR,
>> +       .apic                   = 1,
>> +       .event_bits             = 40,
>> +       .event_mask             = (1ULL << 40) - 1,
>> +       .max_period             = (1ULL << 39) - 1,
>> +       .hw_config              = p4_hw_config,
>> +       .schedule_events        = p4_pmu_schedule_events,
>> +};
>
> commit ca03770(perf, x86: Add PEBS infrastructure) introduces a new
> function validate_event that calls x86_pmu.get_event_constraints.
>
> static int validate_event(struct perf_event *event)
> {
> 	...
> 	c = x86_pmu.get_event_constraints(fake_cpuc, event);
> 	...
> }
>
> So we need to add .get_event_constraints to p4_pmu.
>
> diff --git a/arch/x86/kernel/cpu/perf_event_p4.c
> b/arch/x86/kernel/cpu/perf_event_p4.c
> index 4eb79b1..99a2a7c 100644
> --- a/arch/x86/kernel/cpu/perf_event_p4.c
> +++ b/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -586,6 +586,7 @@ static __initconst struct x86_pmu p4_pmu = {
>  	.max_period		= (1ULL << 39) - 1,
>  	.hw_config		= p4_hw_config,
>  	.schedule_events	= p4_pmu_schedule_events,
> +	.get_event_constraints  = x86_get_event_constraints,
>  };
>
>  static __init int p4_pmu_init(void)
>
> ---
> Lin Ming
>
>
>
Thanks, Ming! This snippet somehow escaped me. Will update.
