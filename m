Return-Path: <linux-kernel-owner+w=401wt.eu-S1765636AbXFRSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765636AbXFRSp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763034AbXFRSpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 14:45:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763467AbXFRSpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 14:45:12 -0400
Message-ID: <4676D2A9.6090403@redhat.com>
Date: Mon, 18 Jun 2007 14:44:57 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com
Subject: Re: [patch 4/8] Immediate Value - i386 Optimization; kprobes
References: <20070615202310.178466032@polymtl.ca> <20070615202926.152087904@polymtl.ca> <46730C5A.7080401@redhat.com> <20070618145702.GA5254@Krystal>
In-Reply-To: <20070618145702.GA5254@Krystal>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2007 10:57 AM, Mathieu Desnoyers wrote:
> * Chuck Ebbert (cebbert@redhat.com) wrote:
>>> +		return NOTIFY_STOP;
>>> +	}
>>> +	return NOTIFY_DONE;
>>> +}
>>> +
>>> +static struct notifier_block immediate_notify = {
>>> +	.notifier_call = immediate_notifier,
>>> +	.priority = 0x7fffffff,	/* we need to be notified first */
>>> +};
>>> +
>>> +/*
>>> + * The address is not aligned. We can only change 1 byte of the value
>>> + * atomically.
>>> + * Must be called with immediate_mutex held.
>>> + */
>>> +int immediate_optimized_set_enable(void *address, char enable)
>>> +{
>>> +	char saved_byte;
>>> +	int ret;
>>> +	char *dest = address;
>>> +
>>> +	if (!(enable ^ dest[1])) /* Must be a state change 0<->1 to execute */
>>> +		return 0;
>>> +
>>> +#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_PAGEALLOC)
>>> +	/* Make sure this page is writable */
>>> +	change_page_attr(virt_to_page(address), 1, PAGE_KERNEL_EXEC);
>>> +	global_flush_tlb();
>>> +#endif
>> Can't we have a macro or inline to do this, and the setting back
>> to read-only? kprobes also has the same ugly #if blocks...
>>
>> Hmm, what happens if you race with kprobes setting a probe on
>> the same page? Couldn't it unexpectedly become read-only?
>>
> 
> Hi Chuck,
> 
> I am looking more closely at kprobes; a few comments while we are here:
> 
> 1 - Why is kprobe_count an atomic_t variable instead of a simple
> integer? It is always protected by the kprobe_mutex anyway. All this
> synchronization seems redundant.
> 
> 2 - I wonder where is the equivalent of my snippet in kprobes code:
>>> +#if defined(CONFIG_DEBUG_RODATA) || defined(CONFIG_DEBUG_PAGEALLOC)
>>> + /* Make sure this page is writable */
>>> + change_page_attr(virt_to_page(address), 1, PAGE_KERNEL_EXEC);
>>> + global_flush_tlb();
>>> +#endif
> 
> I fancy it's done by the kprobe_page_fault handler, but I do not see
> clearly how writing the breakpoint from arch_arm_kprobe() in
> non-writeable memory is done.

Looks like it's not merged yet:

http://lkml.org/lkml/2007/6/7/2

This needs to go in before 2.6.22-final

> 
> In any case, I would like not to use that kind of approach; I prefer to
> set the memory page to RWX before doing the memory write so I do not
> depend on the page fault handler (remember that I instrument the page
> fault handler itself...).
> 
> Maybe we could use a shared "text_mutex" between kprobes and
> immediate values to insure mutual exclusion for .text modification.
> However, we would still have the following coherency issue when an
> immediate value and a kprobe share the same address:
> 
> 1- enable immediate value
> 2- put a kprobe at the immediate value load instruction address
> 3- disable immediate value
> 4- remove kprobe
> 
> The kprobe removal would put back the load immediate instruction and
> would not touch the loaded value (which is ok). However, the instruction
> copy kept by kprobes would not be in sync with the immediate value
> state:
> 
> Scenario 1: kprobes int3 handler first:
> 
> 1- enable immediate value
> 2- put a kprobe at the immediate value load instruction address
> 
> -> int3 triggered
> kprobe handler runs. Single-steps the "enabled" state.
> 
> 3- disable immediate value
> 
> -> int3 triggered
> kprobe handler runs. Single-steps the "enabled" state. This state is
> wrong.
> 
> 4- remove kprobe
> 
> 
> Scenario 2: immediate value int3 handler first:
> 
> 1- enable immediate value
> 2- put a kprobe at the immediate value load instruction address
> 
> -> int3 triggered
> kprobe handler runs. Single-steps the "enabled" state.
> 
> 3- disable immediate value
>   -> int3 triggered (while we disable)
>   While we disable, the immediate value int3 handler is executed first. It
>   would cause the kprobe handler not to be called, and no "missing"
>   counter would be incremented.
> 
> kprobe handler runs. Single-steps the "enabled" state. This state is
> wrong.
> 
> 4- remove kprobe
> 
> 
> Since I don't want to depend on kprobes to put the breakpoint, because
> of its reentrancy limitations (see all the __probes functions), It would
> be good to figure out a mutual exclusion mechanism between immediate
> values and kprobes. Maybe we could forbid kprobes to insert probes on
> addresses present in the immediate values tables ? Or better: if we
> detect this scenario, we could put the kprobe breakpoint at the
> instruction following the "movl".
> 

That's up to you and the kprobes people, I guess...


