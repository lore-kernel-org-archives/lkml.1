Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0CCVMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:12:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab0CCVMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:12:10 -0500
Message-ID: <4B8ED097.6090006@redhat.com>
Date: Wed, 03 Mar 2010 16:11:51 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       eranian@google.com, robert.richter@amd.com, fweisbec@gmail.com
Subject: Re: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
References: <20100303163936.906011640@chello.nl>	 <20100303164306.602529559@chello.nl>  <4B8EA4D9.6000505@redhat.com> <1267645029.25158.106.camel@laptop>
In-Reply-To: <1267645029.25158.106.camel@laptop>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2010-03-03 at 13:05 -0500, Masami Hiramatsu wrote:
>> Peter Zijlstra wrote:
>>> PEBS always reports the IP+1, that is the instruction after the one
>>> that got sampled, cure this by using the LBR to reliably rewind the
>>> instruction stream.
>>
>> Hmm, does PEBS always report one byte after the end address of the
>> sampled instruction? Or the instruction which will be executed next
>> step?
> 
> The next instruction, its trap like.
> 
>> [...]
>>> +#include <asm/insn.h>
>>> +
>>> +#define MAX_INSN_SIZE	16
>>
>> Hmm, we'd better integrate these kinds of definitions into
>> asm/insn.h... (several features define it)
> 
> Agreed, I'll look at doing a patch to collect them all into asm/insn.h
> if nobody beats me to it :-)

At least kprobes doesn't :)

>>> +
>>> +static void intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>>> +{
>>> +#if 0
>>> +	/*
>>> +	 * Borken, makes the machine expode at times trying to
>>> +	 * derefence funny userspace addresses.
>>> +	 *
>>> +	 * Should we always fwd decode from @to, instead of trying
>>> +	 * to rewind as implemented?
>>> +	 */
>>> +
>>> +	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>> +	unsigned long from = cpuc->lbr_entries[0].from;
>>> +	unsigned long to = cpuc->lbr_entries[0].to;
>>
>> Ah, I see. For branch instruction case, we can use LBR to
>> find previous IP...
> 
> Right, we use the LBR to find the basic block.

Hm, that's a good idea :)

>>> +	unsigned long ip = regs->ip;
>>> +	u8 buf[2*MAX_INSN_SIZE];
>>> +	u8 *kaddr;
>>> +	int i;
>>> +
>>> +	if (from && to) {
>>> +		/*
>>> +		 * We sampled a branch insn, rewind using the LBR stack
>>> +		 */
>>> +		if (ip == to) {
>>> +			regs->ip = from;
>>> +			return;
>>> +		}
>>> +	}
>>> +
>>> +	if (user_mode(regs)) {
>>> +		int bytes = copy_from_user_nmi(buf,
>>> +				(void __user *)(ip - MAX_INSN_SIZE),
>>> +				2*MAX_INSN_SIZE);
>>> +
>>
>> maybe, you'd better check the source address range is within
>> the user address range. e.g. ip < MAX_INSN_SIZE. 
> 
> Not only that, I realized user_mode() checks regs->cs, which is not set
> by the PEBS code, so I added some helpers.
> 
>>> +
>>> +	/*
>>> +	 * Try to find the longest insn ending up at the given IP
>>> +	 */
>>> +	for (i = MAX_INSN_SIZE; i > 0; i--) {
>>> +		struct insn insn;
>>> +
>>> +		kernel_insn_init(&insn, kaddr + MAX_INSN_SIZE - i);
>>> +		insn_get_length(&insn);
>>> +		if (insn.length == i) {
>>> +			regs->ip -= i;
>>> +			return;
>>> +		}
>>> +	}
>>
>> Hmm, this will not work correctly on x86, since the decoder can
>> miss-decode the tail bytes of previous instruction as prefix bytes. :(
>>
>> Thus, if you want to rewind instruction stream, you need to decode
>> a function (or basic block) entirely.
> 
> Something like the below?

Great! it looks good to me.
Yeah, LBR.to may always smaller than current ip (if no one disabled LBR).

Thank you,

> 
> #ifdef CONFIG_X86_32
> static bool kernel_ip(unsigned long ip)
> {
>         return ip > TASK_SIZE;
> }
> #else
> static bool kernel_ip(unsigned long ip)
> {
>         return (long)ip < 0;
> }
> #endif
> 
> static int intel_pmu_pebs_fixup_ip(unsigned long *ipp)
> {
>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>         unsigned long from = cpuc->lbr_entries[0].from;
>         unsigned long old_to, to = cpuc->lbr_entries[0].to;
>         unsigned long ip = *ipp;
>         int i;
> 
>         /*
>          * We don't need to fixup if the PEBS assist is fault like
>          */
>         if (!x86_pmu.intel_perf_capabilities.pebs_trap)
>                 return 0;
> 
>         if (!cpuc->lbr_stack.nr || !from || !to)
>                 return 0;
> 
>         if (ip < to)
>                 return 0;
> 
>         /*
>          * We sampled a branch insn, rewind using the LBR stack
>          */
>         if (ip == to) {
>                 *ipp = from;
>                 return 1;
>         }
> 
>         do {
>                 struct insn insn;
>                 u8 buf[MAX_INSN_SIZE];
>                 void *kaddr;
> 
>                 old_to = to;
>                 if (!kernel_ip(ip)) {
>                         int bytes = copy_from_user_nmi(buf, (void __user *)to,
>                                         MAX_INSN_SIZE);
> 
>                         if (bytes != MAX_INSN_SIZE)
>                                 return 0;
> 
>                         kaddr = buf;
>                 } else kaddr = (void *)to;
> 
>                 kernel_insn_init(&insn, kaddr);
>                 insn_get_length(&insn);
>                 to += insn.length;
>         } while (to < ip);
> 
>         if (to == ip) {
>                 *ipp = old_to;
>                 return 1;
>         }
> 
>         return 0;
> }
> 
> I thought about exposing the success of this fixup as a PERF_RECORD_MISC
> bit.
> 

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
