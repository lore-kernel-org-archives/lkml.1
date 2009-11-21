Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbZKUVxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbZKUVxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 16:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756801AbZKUVxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 16:53:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756726AbZKUVxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 16:53:40 -0500
Message-ID: <4B0861D4.7030702@redhat.com>
Date: Sat, 21 Nov 2009 16:55:32 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com> <4B072EF5.2090402@redhat.com> <20091121162145.GE12100@Krystal>
In-Reply-To: <20091121162145.GE12100@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> > Hi Peter,
>> >
>> > H. Peter Anvin wrote:
>>> >> On 11/18/2009 02:43 PM, Jason Baron wrote:
>>>> >>> Add text_poke_fixup() which takes a fixup address to where a processor
>>>> >>> jumps if it hits the modifying address while code modifying.
>>>> >>> text_poke_fixup() does following steps for this purpose.
>>>> >>>
>>>> >>>   1. Setup int3 handler for fixup.
>>>> >>>   2. Put a breakpoint (int3) on the first byte of modifying region,
>>>> >>>      and synchronize code on all CPUs.
>>>> >>>   3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>>> >>>   4. Modify the first byte of modifying region, and synchronize code
>>>> >>>      on all CPUs.
>>>> >>>   5. Clear int3 handler.
>>>> >>>
>>>> >>> Thus, if some other processor execute modifying address when step2 to step4,
>>>> >>> it will be jumped to fixup code.
>>>> >>>
>>>> >>> This still has many limitations for modifying multi-instructions at once.
>>>> >>> However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
>>>> >>> because;
>>>> >>>   - Replaced instruction is just one instruction, which is executed atomically.
>>>> >>>   - Replacing instruction is a jump, so we can set fixup address where the jump
>>>> >>>     goes to.
>>>> >>>
>>> >>
>>> >> I just had a thought about this... regardless of if this is safe or not
>>> >> (which still remains to be determined)... I have a bit more of a
>>> >> fundamental question about it:
>>> >>
>>> >> This code ends up taking *two* global IPIs for each instruction
>>> >> modification.  Each of those requires whole-system synchronization.
>> >
>> > As Mathieu and I talked, first IPI is for synchronizing code, and
>> > second is for waiting for all int3 handling is done.
>> >
>>> >>  How
>>> >> is this better than taking one IPI and having the other CPUs wait until
>>> >> the modification is complete before returning?
>> >
>> > Would you mean using stop_machine()? :-)
>> >
>> > If we don't care about NMI, we can use stop_machine() (for
>> > this reason, kprobe-jump-optimization can use stop_machine(),
>> > because kprobes can't probe NMI code), but tracepoint has
>> > to support NMI.
>> >
>> > Actually, it might be possible, even it will be complicated.
>> > If one-byte modifying(int3 injection/removing) is always
>> > synchronized, I assume below timechart can work
>> > (and it can support NMI/SMI too).
>> >
>> > ----
>> >        <CPU0>                  <CPU1>
>> > flag = 0
>> > setup int3 handler
>> > int3 injection[sync]
>> > other-bytes modifying
>> > smp_call_function(func)    func()
>> > wait_until(flag==1)        irq_disable()
>> >                            sync_core() for other-bytes modifying
>> >                            flag = 1
>> > first-byte modifying[sync] wait_until(flag==2)
> Hrm, I don't like this too much. In terms of latency, we can get:
> 
> CPU 0:                       CPU 1
>                              interrupts off
>                              * wait_util(flag == 2)
> interrupted
> softirq runs...                            
> (we have a drink, network bh
> processing, etc etc)
> back to standard execution
> flag = 2
> 
> So, as you see, we increase the interrupt latency on all other CPUs of
> the duration of a softirq. This is, I think, an unwanted side-effect.
> 
> We should really do performance benchmarks comparing stop_machine() and
> the int3-based approach rather than to try to come up with tricky
> schemes. It's not a real problem until we prove there is indeed a
> performance regression. I suspect that the combined effect of cache-line
> bouncing, worker thread overhead and the IPI of stop_machine is probably
> comparable to the two IPIs we propose for int3.

I assume that total latency of XMC is almost same on normal-size SMP.
However,
- stop_machine() can't support NMI/SMI.
- stop_machine() stops all other processors while XMC.

Anyway, int3-based approach still needs to be ensured its safeness
by processor architects. So, until that, stop_machine() approach
also useful for some cases.

Thank you,
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

