Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYFXNH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYFXNH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 09:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbYFXNHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 09:07:15 -0400
Received: from saeurebad.de ([85.214.36.134]:53684 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYFXNHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 09:07:14 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: a.p.zijlstra@chello.nl, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] softirq softlockup debugging
References: <20080622122845.GA10133@damson.getinternet.no>
	<87prq79kty.fsf@skyscraper.fehenstaub.lan>
	<19f34abd0806240445i6282c49cia22a700140dd27eb@mail.gmail.com>
Date: Tue, 24 Jun 2008 15:06:56 +0200
In-Reply-To: <19f34abd0806240445i6282c49cia22a700140dd27eb@mail.gmail.com>
	(Vegard Nossum's message of "Tue, 24 Jun 2008 13:45:27 +0200")
Message-ID: <87lk0v9e33.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Vegard Nossum" <vegard.nossum@gmail.com> writes:

> On 6/24/08, Johannes Weiner <hannes@saeurebad.de> wrote:
>> After more staring at the code in question, I think that the approach is
>> not correct (or I didn't understand it, which is not unlikely).
>>
>> I hunted down the address of the traces from kerneloops.org
>> (__do_softirq+0x6d) on a kernel image with a fedora config and it's at
>> the local_irq_enable() right after the restart:label in __do_softirq().
>>
>
> Are you quite sure? I didn't use the fedora image, but I compiled with
> the fedora config and got a function size for __do_softirq that was
> exactly equal to some of the reports. And there, the EIP pointed to
> the second "pop" instruction after calling... oh, true.
> local_irq_enable(). And those pops come from calling into paravirt
> ops.
>
> Right, I fully agree.
>
>> So if the softirq handler had disabled interrupts, the softlockup would
>> have been detected still within the handler (when it reenables irqs and
>> the timer irq runs) and the stackframe should be there.
>>
>> do_softirq()
>>  local_irq_save()                      1)
>>  local_softirq_pending()
>>  __do_softirq()
>>   restart:                             2)
>>    local_irq_enable()                  3)
>>    run a handler
>>    local_irq_disable()                 4)
>>    jnz restart
>>
>> So the lockup must be caused somewhere
>>  between 1) and 3)
>> or
>>  between 4) and 3) [when we jump back]
>>
>> These functions are in the path and possible candidates for causing it:
>>
>> - local_softirq_pending()
>> - account_system_vtime()
>> - __local_bh_disable()
>> - trace_softirq_enter()
>> - smp_processor_id()
>> - set_softirq_pending()
>>
>> What do you think?  You said you actually used your patch already for
>> debugging lockups in softirq handlers, so it confuses me why the
>> stackframe of the handler was no longer present.
>
> What didn't make sense to me when first looking at the oops reports
> was that there was nowhere inside __do_softirq() that could actually
> lock up. As far as I can see, there is no infinite (or very
> long-running) loop in there, so I concluded (probably wrongly) that it
> must be the handler; it was the only logical explanation I could find.
> I believe that the functions you listed all run in constant time, but
> maybe we should check it.
>
> It also seems that the timer interrupt (where softlockup detection
> kicks in) has a small delay after irqs are re-enabled before it
> actually interrupts the CPU. Can you post a disassembly of
> __do_softirq() where you pinpoint the exact instruction that was
> interrupted, e.g. in this case __do_softirq+0x6d? Again, for me, this
> was a pop %ebx or so, which doesn't change interruptibility, so maybe
> I simply had the wrong disassembly.

gdb associated the line to be the asm statement in
include/asm-x86/paravirt.h::raw_local_irq_enable().

And looking by hand with objdump got the second pop, too, just like you,
IIRC (dropped the object file, will have another look at it later).

	Hannes
