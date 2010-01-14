Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917Ab0ANGyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0ANGyx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 01:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356Ab0ANGyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 01:54:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab0ANGyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 01:54:52 -0500
Message-ID: <4B4EC048.4090107@redhat.com>
Date: Thu, 14 Jan 2010 01:57:12 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       rostedt@goodmis.org, andi@firstfloor.org, roland@redhat.com,
       rth@redhat.com
Subject: Re: [RFC PATCH 2/8] jump label v4 - x86: Introduce generic jump	patching
 without stop_machine
References: <cover.1263247113.git.jbaron@redhat.com> <a4aa5bbcf5e62eaa5dd156d318a370236f28be09.1263247114.git.jbaron@redhat.com> <4B4D02B8.5020801@zytor.com> <20100113020610.GB29314@Krystal> <4B4D525A.5020101@zytor.com> <20100113143050.GB30875@Krystal>
In-Reply-To: <20100113143050.GB30875@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * H. Peter Anvin (hpa@zytor.com) wrote:
>> On 01/12/2010 06:06 PM, Mathieu Desnoyers wrote:
>>> * H. Peter Anvin (hpa@zytor.com) wrote:
>>>> On 01/12/2010 08:26 AM, Jason Baron wrote:
>>>>> Add text_poke_fixup() which takes a fixup address to where a processor
>>>>> jumps if it hits the modifying address while code modifying.
>>>>> text_poke_fixup() does following steps for this purpose.
>>>>>
>>>>>  1. Setup int3 handler for fixup.
>>>>>  2. Put a breakpoint (int3) on the first byte of modifying region,
>>>>>     and synchronize code on all CPUs.
>>>>>  3. Modify other bytes of modifying region, and synchronize code on all CPUs.
>>>>>  4. Modify the first byte of modifying region, and synchronize code
>>>>>     on all CPUs.
>>>>>  5. Clear int3 handler.
>>>>>
>>>>
>>>> We (Intel OTC) have been able to get an *unofficial* answer as to the
>>>> validity of this procedure; specifically as it applies to Intel hardware
>>>> (obviously).  We are working on getting an officially approved answer,
>>>> but as far as we currently know, the procedure as outlined above should
>>>> work on all Intel hardware.  In fact, we believe the synchronization in
>>>> step 3 is in fact unnecessary (as the synchronization in step 4 provides
>>>> sufficient guard.)
>>>
>>> Hi Peter,
>>>
>>> This is great news! Thanks to Intel OTC and yourself for looking into
>>> this. In the immediate values patches, I am doing the synchronization at
>>> the end of step (3) to ensure that all remote CPUs issue read memory
>>> barriers, so the stores to the instruction are done in this order:
>>>
>>> spin lock
>>> store int3 to 1st byte
>>> smp_wmb()
>>> sync all cores
>>> store new instruction in all but 1st byte
>>> smp_wmb()
>>> issue smp_rmb() on all cores (a sync all cores has this effect)
>>> store new instruction to 1st byte
>>> send IPI to all cores (or call synchronize_sched()) to wait for all
>>>   breakpoint handlers to complete.
>>> spin unlock
>>>
>>> So the question is: are these wmb/rmb pairs actually needed ?  As the
>>> instruction fetch is not performed by instructions per se, I doubt a
>>> rmb() will have any effect on them. I always prefer to stay on the safe
>>> side, but it wouldn't hurt to know.
>>>
>>
>> I don't think the smp_rmb() has any function.
> 
> OK, that's good to know.
> 
>>
>> However, you're being quite inconsistent in your terminology here.  The
>> assumption above is that the "synchronize code on all CPU" step is
>> sending an IPI to all cores and waiting for it to return, so that each
>> core has executed IPI/IRET before continuation.
> 
> To be strictly correct, we cannot assume that the IPI handler issues IRET
> before signaling its completion. It's rather the other way around.
> This is why I add a smp_mb() in the IPI handler for the "synchronize
> code on all CPUs" step.
> 
>>
>> It is *not* necessary to wait for the breakpoint handlers to return, as
>> long as they will get to IRET eventually, since IRET is a jump and a
>> serializing instruction.
> 
> Ah, I see. So the added smp_mb() would not be needed then, as long as we
> know that the other CPUs either are currently running the IPI handler or
> have executed it. IOW: they will execute IRET very soon or they just
> executed it since the int3 have been written. I am a bit concerned about
> NMIs coming in this race window, but as they need to have started after
> we have put the breakpoint, that should be OK. (note: entry_*.S
> modifications are needed to support nesting breakpoint handlers in NMIs)
> 
>>
>>> Hrm. Assuming we have a spinlock protecting all this, given that we
>>> synchronize all cores at step (4) _after_ removing the breakpoint, and
>>> given that the breakpoint handler is an interrupt gate (thus executes
>>> with interrupts off), I am inclined to think that sending the IPIs at
>>> the end of step (4) (and waiting for them to complete) should be enough
>>> to ensure that all in-flight breakpoint handlers for this site have
>>> completed their execution. This would mean that we only have to keep
>>> track of a single site at a time. Or am I missing something ?
>>
>> Yes: the whole point was that you can omit the synchronization in step 4
>> if you leave the breakpoint handler in place (I said "omit step 5", but
>> that wasn't really what I meant.)

Hmm, in that case, how can we reuse the breakpoint handler for another
text poke site? Even if we leave the handler, I think we need to clear
fixup information for next poking...

>>
>> That means that at the cost of two compares in the standard #BP handler,
>> we can get away with only one IPI per atomic instruction poke.
> 
> OK. That makes sense now.

So, let me check the actual replacement steps.

(1) lock text_mutex
(2) setup breakpoint fixup addresses (source and destination)
(3) store int3 to 1st byte, and smp_wmb()
(4) send IPI and issue smp_mb() (or cpuid) with for sync all cores.
(5) store new instruction except 1st byte, and smp_wmb()
(6) store 1st byte of new instruction
(7) send IPI to all cores for waiting for all running breakpoint handlers.
(8) clear fixup addresses
(9) unlock text_mutex

Is this correct?

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

