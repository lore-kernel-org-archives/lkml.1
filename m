Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab0CCVuj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:50:39 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53219 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719Ab0CCVu3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:50:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=KLTvQSvhMh+YkbyUsW+pQiJMgWZhtk2Kq1m45JLNouM7goA62rLwlOMRNjv3iOTpp
	dHL5CifOh8AryvvkUUAmQ==
MIME-Version: 1.0
In-Reply-To: <4B8ED097.6090006@redhat.com>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.602529559@chello.nl> <4B8EA4D9.6000505@redhat.com>
	 <1267645029.25158.106.camel@laptop> <4B8ED097.6090006@redhat.com>
Date: Wed, 3 Mar 2010 22:50:21 +0100
Message-ID: <bd4cb8901003031350v274ca388v48ad61d7baa87d90@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/11] perf, x86: use LBR for PEBS IP+1 fixup
From: Stephane Eranian <eranian@google.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, paulus@samba.org, robert.richter@amd.com,
       fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think systematically and transparently using LBR to correct PEBS off-by-one
problem is not such a good idea. You've basically highjacked LBR and user
cannot use it in a different way.

There are PEBS+LBR measurements where you care about extracting the LBR data.
There are PEBS measurements where you don't care about getting the correct IP.
I don't necessarily want to pay the price, especially when this could
be done offline
in the tool.


On Wed, Mar 3, 2010 at 10:11 PM, Masami Hiramatsu <mhiramat@redhat.com> wrote:
> Peter Zijlstra wrote:
>> On Wed, 2010-03-03 at 13:05 -0500, Masami Hiramatsu wrote:
>>> Peter Zijlstra wrote:
>>>> PEBS always reports the IP+1, that is the instruction after the one
>>>> that got sampled, cure this by using the LBR to reliably rewind the
>>>> instruction stream.
>>>
>>> Hmm, does PEBS always report one byte after the end address of the
>>> sampled instruction? Or the instruction which will be executed next
>>> step?
>>
>> The next instruction, its trap like.
>>
>>> [...]
>>>> +#include <asm/insn.h>
>>>> +
>>>> +#define MAX_INSN_SIZE      16
>>>
>>> Hmm, we'd better integrate these kinds of definitions into
>>> asm/insn.h... (several features define it)
>>
>> Agreed, I'll look at doing a patch to collect them all into asm/insn.h
>> if nobody beats me to it :-)
>
> At least kprobes doesn't :)
>
>>>> +
>>>> +static void intel_pmu_pebs_fixup_ip(struct pt_regs *regs)
>>>> +{
>>>> +#if 0
>>>> +   /*
>>>> +    * Borken, makes the machine expode at times trying to
>>>> +    * derefence funny userspace addresses.
>>>> +    *
>>>> +    * Should we always fwd decode from @to, instead of trying
>>>> +    * to rewind as implemented?
>>>> +    */
>>>> +
>>>> +   struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>>> +   unsigned long from = cpuc->lbr_entries[0].from;
>>>> +   unsigned long to = cpuc->lbr_entries[0].to;
>>>
>>> Ah, I see. For branch instruction case, we can use LBR to
>>> find previous IP...
>>
>> Right, we use the LBR to find the basic block.
>
> Hm, that's a good idea :)
>
>>>> +   unsigned long ip = regs->ip;
>>>> +   u8 buf[2*MAX_INSN_SIZE];
>>>> +   u8 *kaddr;
>>>> +   int i;
>>>> +
>>>> +   if (from && to) {
>>>> +           /*
>>>> +            * We sampled a branch insn, rewind using the LBR stack
>>>> +            */
>>>> +           if (ip == to) {
>>>> +                   regs->ip = from;
>>>> +                   return;
>>>> +           }
>>>> +   }
>>>> +
>>>> +   if (user_mode(regs)) {
>>>> +           int bytes = copy_from_user_nmi(buf,
>>>> +                           (void __user *)(ip - MAX_INSN_SIZE),
>>>> +                           2*MAX_INSN_SIZE);
>>>> +
>>>
>>> maybe, you'd better check the source address range is within
>>> the user address range. e.g. ip < MAX_INSN_SIZE.
>>
>> Not only that, I realized user_mode() checks regs->cs, which is not set
>> by the PEBS code, so I added some helpers.
>>
>>>> +
>>>> +   /*
>>>> +    * Try to find the longest insn ending up at the given IP
>>>> +    */
>>>> +   for (i = MAX_INSN_SIZE; i > 0; i--) {
>>>> +           struct insn insn;
>>>> +
>>>> +           kernel_insn_init(&insn, kaddr + MAX_INSN_SIZE - i);
>>>> +           insn_get_length(&insn);
>>>> +           if (insn.length == i) {
>>>> +                   regs->ip -= i;
>>>> +                   return;
>>>> +           }
>>>> +   }
>>>
>>> Hmm, this will not work correctly on x86, since the decoder can
>>> miss-decode the tail bytes of previous instruction as prefix bytes. :(
>>>
>>> Thus, if you want to rewind instruction stream, you need to decode
>>> a function (or basic block) entirely.
>>
>> Something like the below?
>
> Great! it looks good to me.
> Yeah, LBR.to may always smaller than current ip (if no one disabled LBR).
>
> Thank you,
>
>>
>> #ifdef CONFIG_X86_32
>> static bool kernel_ip(unsigned long ip)
>> {
>>         return ip > TASK_SIZE;
>> }
>> #else
>> static bool kernel_ip(unsigned long ip)
>> {
>>         return (long)ip < 0;
>> }
>> #endif
>>
>> static int intel_pmu_pebs_fixup_ip(unsigned long *ipp)
>> {
>>         struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>>         unsigned long from = cpuc->lbr_entries[0].from;
>>         unsigned long old_to, to = cpuc->lbr_entries[0].to;
>>         unsigned long ip = *ipp;
>>         int i;
>>
>>         /*
>>          * We don't need to fixup if the PEBS assist is fault like
>>          */
>>         if (!x86_pmu.intel_perf_capabilities.pebs_trap)
>>                 return 0;
>>
>>         if (!cpuc->lbr_stack.nr || !from || !to)
>>                 return 0;
>>
>>         if (ip < to)
>>                 return 0;
>>
>>         /*
>>          * We sampled a branch insn, rewind using the LBR stack
>>          */
>>         if (ip == to) {
>>                 *ipp = from;
>>                 return 1;
>>         }
>>
>>         do {
>>                 struct insn insn;
>>                 u8 buf[MAX_INSN_SIZE];
>>                 void *kaddr;
>>
>>                 old_to = to;
>>                 if (!kernel_ip(ip)) {
>>                         int bytes = copy_from_user_nmi(buf, (void __user *)to,
>>                                         MAX_INSN_SIZE);
>>
>>                         if (bytes != MAX_INSN_SIZE)
>>                                 return 0;
>>
>>                         kaddr = buf;
>>                 } else kaddr = (void *)to;
>>
>>                 kernel_insn_init(&insn, kaddr);
>>                 insn_get_length(&insn);
>>                 to += insn.length;
>>         } while (to < ip);
>>
>>         if (to == ip) {
>>                 *ipp = old_to;
>>                 return 1;
>>         }
>>
>>         return 0;
>> }
>>
>> I thought about exposing the success of this fixup as a PERF_RECORD_MISC
>> bit.
>>
>
> --
> Masami Hiramatsu
> e-mail: mhiramat@redhat.com
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
