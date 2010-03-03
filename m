Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0CCSHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 13:07:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9476 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383Ab0CCSHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 13:07:41 -0500
Message-ID: <4B8EA4D9.6000505@redhat.com>
Date: Wed, 03 Mar 2010 13:05:13 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
References: <20100303163936.906011640@chello.nl> <20100303164306.602529559@chello.nl>
In-Reply-To: <20100303164306.602529559@chello.nl>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> PEBS always reports the IP+1, that is the instruction after the one
> that got sampled, cure this by using the LBR to reliably rewind the
> instruction stream.

Hmm, does PEBS always report one byte after the end address of the
sampled instruction? Or the instruction which will be executed next
step?

[...]
> +#include <asm/insn.h>
> +
> +#define MAX_INSN_SIZE	16

Hmm, we'd better integrate these kinds of definitions into
asm/insn.h... (several features define it)

> +
> +static void intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
> +{
> +#if 0
> +	/*
> +	 * Borken, makes the machine expode at times trying to
> +	 * derefence funny userspace addresses.
> +	 *
> +	 * Should we always fwd decode from @to, instead of trying
> +	 * to rewind as implemented?
> +	 */
> +
> +	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +	unsigned long from = cpuc->lbr_entries[0].from;
> +	unsigned long to = cpuc->lbr_entries[0].to;

Ah, I see. For branch instruction case, we can use LBR to
find previous IP...

> +	unsigned long ip = regs->ip;
> +	u8 buf[2*MAX_INSN_SIZE];
> +	u8 *kaddr;
> +	int i;
> +
> +	if (from && to) {
> +		/*
> +		 * We sampled a branch insn, rewind using the LBR stack
> +		 */
> +		if (ip == to) {
> +			regs->ip = from;
> +			return;
> +		}
> +	}
> +
> +	if (user_mode(regs)) {
> +		int bytes = copy_from_user_nmi(buf,
> +				(void __user *)(ip - MAX_INSN_SIZE),
> +				2*MAX_INSN_SIZE);
> +

maybe, you'd better check the source address range is within
the user address range. e.g. ip < MAX_INSN_SIZE. 

> +		/*
> +		 * If we fail to copy the insn stream, give up
> +		 */
> +		if (bytes != 2*MAX_INSN_SIZE)
> +			return;
> +
> +		kaddr = buf;
> +	} else
> +		kaddr = (void *)(ip - MAX_INSN_SIZE);

It also needs to be checked this address within kernel text.

> +
> +	/*
> +	 * Try to find the longest insn ending up at the given IP
> +	 */
> +	for (i = MAX_INSN_SIZE; i > 0; i--) {
> +		struct insn insn;
> +
> +		kernel_insn_init(&insn, kaddr + MAX_INSN_SIZE - i);
> +		insn_get_length(&insn);
> +		if (insn.length == i) {
> +			regs->ip -= i;
> +			return;
> +		}
> +	}

Hmm, this will not work correctly on x86, since the decoder can
miss-decode the tail bytes of previous instruction as prefix bytes. :(

Thus, if you want to rewind instruction stream, you need to decode
a function (or basic block) entirely.

Thank you,

> +
> +	/*
> +	 * We failed to find a match for the previous insn.. give up
> +	 */
> +#endif
> +}
> +
>  static int intel_pmu_save_and_restart(struct perf_event *event);
>  static void intel_pmu_disable_event(struct perf_event *event);
>  
> @@ -458,6 +532,8 @@ static void intel_pmu_drain_pebs_core(st
>  
>  	PEBS_TO_REGS(at, &regs);
>  
> +	intel_pmu_pebs_fixup_ip(&regs);
> +
>  	if (perf_event_overflow(event, 1, data, &regs))
>  		intel_pmu_disable_event(event);
>  
> @@ -519,6 +595,7 @@ static void intel_pmu_drain_pebs_nhm(str
>  		data->period = event->hw.last_period;
>  
>  		PEBS_TO_REGS(at, &regs);
> +		intel_pmu_pebs_fixup_ip(&regs);
>  
>  		if (perf_event_overflow(event, 1, data, &regs))
>  			intel_pmu_disable_event(event);
> 
> -- 

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
