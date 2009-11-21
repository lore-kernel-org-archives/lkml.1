Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZKUQVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZKUQVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZKUQVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:21:41 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:44788 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbZKUQVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:21:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EALeeB0tGGN1W/2dsb2JhbACBTNF/hDwEgXA
Date: Sat, 21 Nov 2009 11:21:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/6] jump label v3 - x86: Introduce generic jump
	patching without stop_machine
Message-ID: <20091121162145.GE12100@Krystal>
References: <cover.1258580048.git.jbaron@redhat.com> <37e397b27509c378f93b9a30f1158791d1b99be7.1258580048.git.jbaron@redhat.com> <4B071000.9080408@zytor.com> <4B072EF5.2090402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4B072EF5.2090402@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:16:30 up 95 days,  3:06,  3 users,  load average: 0.11, 0.17,
	0.11
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Masami Hiramatsu (mhiramat@redhat.com) wrote:
> Hi Peter,
>
> H. Peter Anvin wrote:
>> On 11/18/2009 02:43 PM, Jason Baron wrote:
>>> Add text_poke_fixup() which takes a fixup address to where a processor
>>> jumps if it hits the modifying address while code modifying.
>>> text_poke_fixup() does following steps for this purpose.
>>>
>>>   1. Setup int3 handler for fixup.
>>>   2. Put a breakpoint (int3) on the first byte of modifying region,
>>>      and synchronize code on all CPUs.
>>>   3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>>   4. Modify the first byte of modifying region, and synchronize code
>>>      on all CPUs.
>>>   5. Clear int3 handler.
>>>
>>> Thus, if some other processor execute modifying address when step2 to step4,
>>> it will be jumped to fixup code.
>>>
>>> This still has many limitations for modifying multi-instructions at once.
>>> However, it is enough for 'a 5 bytes nop replacing with a jump' patching,
>>> because;
>>>   - Replaced instruction is just one instruction, which is executed atomically.
>>>   - Replacing instruction is a jump, so we can set fixup address where the jump
>>>     goes to.
>>>
>>
>> I just had a thought about this... regardless of if this is safe or not
>> (which still remains to be determined)... I have a bit more of a
>> fundamental question about it:
>>
>> This code ends up taking *two* global IPIs for each instruction
>> modification.  Each of those requires whole-system synchronization.
>
> As Mathieu and I talked, first IPI is for synchronizing code, and
> second is for waiting for all int3 handling is done.
>
>>  How
>> is this better than taking one IPI and having the other CPUs wait until
>> the modification is complete before returning?
>
> Would you mean using stop_machine()? :-)
>
> If we don't care about NMI, we can use stop_machine() (for
> this reason, kprobe-jump-optimization can use stop_machine(),
> because kprobes can't probe NMI code), but tracepoint has
> to support NMI.
>
> Actually, it might be possible, even it will be complicated.
> If one-byte modifying(int3 injection/removing) is always
> synchronized, I assume below timechart can work
> (and it can support NMI/SMI too).
>
> ----
>        <CPU0>                  <CPU1>
> flag = 0
> setup int3 handler
> int3 injection[sync]
> other-bytes modifying
> smp_call_function(func)    func()
> wait_until(flag==1)        irq_disable()
>                            sync_core() for other-bytes modifying
>                            flag = 1
> first-byte modifying[sync] wait_until(flag==2)

Hrm, I don't like this too much. In terms of latency, we can get:

CPU 0:                       CPU 1
                             interrupts off
                             * wait_util(flag == 2)
interrupted
softirq runs...                            
(we have a drink, network bh
processing, etc etc)
back to standard execution
flag = 2

So, as you see, we increase the interrupt latency on all other CPUs of
the duration of a softirq. This is, I think, an unwanted side-effect.

We should really do performance benchmarks comparing stop_machine() and
the int3-based approach rather than to try to come up with tricky
schemes. It's not a real problem until we prove there is indeed a
performance regression. I suspect that the combined effect of cache-line
bouncing, worker thread overhead and the IPI of stop_machine is probably
comparable to the two IPIs we propose for int3.

Thanks,

Mathieu


> flag = 2
> wait_until(flag==3)        irq_enable()
>                            flag = 3
> cleanup int3 handler       return
> return
> ----
>
> I'm not so sure that this flag-based step-by-step code can
> work faster than 2 IPIs :-(
>
> Any comments are welcome! :-)
>
> Thank you,
>
> -- 
> Masami Hiramatsu
>
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
>
> e-mail: mhiramat@redhat.com
>

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
