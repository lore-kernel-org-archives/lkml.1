Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZKTBC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZKTBC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 20:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756888AbZKTBC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 20:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756856AbZKTBC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 20:02:28 -0500
Message-ID: <4B05EA1C.9000805@redhat.com>
Date: Thu, 19 Nov 2009 20:00:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Jason Baron <jbaron@redhat.com>, mingo@elte.hu,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <20091119002826.GB28962@Krystal> <4B055082.50401@redhat.com> <20091119160336.GA16094@Krystal>
In-Reply-To: <20091119160336.GA16094@Krystal>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
[...]
>>>> +	if (unlikely(len<= 1))
>>>> +		return text_poke(addr, opcode, len);
>>>> +
>>>> +	/* Preparing */
>>>> +	patch_fixup_addr = fixup;
>>>> +	wmb();
>>>
>>> hrm, missing comment ?
>>
>> Ah, it's a barrier between patch_fixup_addr and patch_fixup_from.
>> int3 trap handler checks patch_fixup_from first and refers patch_fixup_addr.
>
> When a smp_wmb() is probably enough, and the matching smp_rmb() is
> missing in the int3 handler.

OK, thank you.

> But why to you care about the order of these two ? I agree that an
> unrelated int3 handler (from kprobes ?) could be running concurrently at
> that point, but it clearly cannot be called for this specific address
> until the int3 is written by text_poke.

Ah, it's my fault. I fixed that a month ago, and forgot to push it...
Actually, we don't need to care the order of those two. Instead,
we have to update the patch_fixup_* before int3 embedding.

>
> What I am pretty much certain is missing would be a smp_wmb()...

Agreed.

>
>>
>>>
>>>> +	patch_fixup_from = (u8 *)addr + int3_size; /* IP address after int3 */
>
> ..right here, between where you write to the data used by the int3
> handler and where you write the actual breakpoint. On the read-side,
> this might be a problem with architectures like alpha needing
> smp_read_barrier_depends(), but not for Intel. However, in a spirit to
> make this code solid, what I did in the immed. val. is:
>
>
>                  target_after_int3 = insn + BREAKPOINT_INS_LEN;
>                  /* register_die_notifier has memory barriers */
>                  register_die_notifier(&imv_notify);
>                  /* The breakpoint will single-step the bypass */
>                  text_poke((void *)insn,
>                          ((unsigned char[]){BREAKPOINT_INSTRUCTION}), 1);

Hmm, it strongly depends on arch. Is smp_wmb() right after setting
patch_fixup_from enough on x86?

> And I unregister the die notifier at the end after having reached
> quiescent state. At least we know that the die notifier chain read-side
> has the proper memory barriers, which is not the case for the breakpoint
> instruction itself.
>
>
>>>> +
>>>> +	/* Cap by an int3 */
>>>> +	text_poke(addr,&int3_insn, int3_size);
>>>> +	sync_core_all();
>>>> +
>>>> +	/* Replace tail bytes */
>>>> +	text_poke((char *)addr + int3_size, (const char *)opcode + int3_size,
>>>> +		  len - int3_size);
>>>> +	sync_core_all();
>>>> +
>>>> +	/* Replace int3 with head byte */
>>>> +	text_poke(addr, opcode, int3_size);
>>>> +	sync_core_all();
>>>> +
>>>> +	/* Cleanup */
>>>> +	patch_fixup_from = NULL;
>>>> +	wmb();
>>>
>>> missing comment here too.
>>>
>>>> +	return addr;
>>>
>>> Little quiz question:
>>>
>>> When patch_fixup_from is set to NULL, what ensures that the int3
>>> handlers have completed their execution ?
>>>
>>> I think it's probably OK, because the int3 is an interrupt gate, which
>>> therefore disables interrupts as soon as it runs, and executes the
>>> notifier while irqs are off. When we run sync_core_all() after replacing
>>> the int3 by the new 1st byte, we only return when all other cores have
>>> executed an interrupt, which implies that all int3 handlers previously
>>> running should have ended. Is it right ? It looks to me as if this 3rd
>>> sync_core_all() is only needed because of that. Probably that adding a
>>> comment would be good.
>>
>> Thanks, it's a good point and that's more what I've thought.
>> As you said, it is probably safe. Even if it's not safe,
>> we can add some int3 fixup handler (with lowest priority)
>> which set regs->ip-1 if there is no int3 anymore, for safety.
>
> Well, just ensuring that the we reaches a "disabled IRQ code quiescent
> state" should be enough. Another way would be to use
> synchronize_sched(), but it might take longer. Actively poking the other
> CPUs with IPIs seems quicker. So I would be tempted to leave your code
> as is in this respect, but to add a comment.

Agreed. synchronize_sched() waits too long for this purpose.
OK, I'll add a comment for that "waiting for disabled IRQ code quiescent state" :-)
Thanks for the good advice!

>>> Another thing: I've recently noticed that the following locking seems to
>>> hang the system with doing stress-testing concurrently with cpu
>>> hotplug/hotunplug:
>>>
>>> mutex_lock(&text_mutex);
>>>    on_each_cpu(something, NULL, 1);
>>>
>>> The hang seems to be caused by the fact that alternative.c has:
>>>
>>> within cpu hotplug (cpu hotplug lock held)
>>>    mutex_lock(&text_mutex);
>>>
>>> It might also be caused by the interaction with the stop_machine()
>>> performed within the cpu hotplug lock. I did not find the root cause of
>>> the problem, but this probably calls for lockdep improvements.
>>
>> Hmm, would you mean it will happen even if we use stop_machine()
>> under text_mutex locking?
>> It seems that bigger problem of cpu-hotplug and on_each_cpu() etc.
>
> Yes, but, again.. this calls for more testing. Hopefully it's not
> something else in my own code I haven't seen. For not I can just say
> that I've been noticing hangs involving cpu hotplug and text mutex, and
> taking the cpu hotplug mutex around text mutex (in my immediate values
> code) fixed the problem.

Hmm, I guess that we'd better merge those two mutexes since
text modification always requires disabling cpu-hotplug...

Thank you,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

