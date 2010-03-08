Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab0CHKTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 05:19:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261Ab0CHKTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 05:19:07 -0500
Message-ID: <4B94CEFC.40405@redhat.com>
Date: Mon, 08 Mar 2010 12:18:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
CC: Thomas Renninger <trenn@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
References: <1266925885-17616-1-git-send-email-trenn@suse.de>,<4B83C411.9050308@redhat.com> <C64F1A8E3F9E3C409DFC005F502C40D0020D8F00@ESESSCMS0359.eemea.ericsson.se>
In-Reply-To: <C64F1A8E3F9E3C409DFC005F502C40D0020D8F00@ESESSCMS0359.eemea.ericsson.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2010 09:47 PM, Kerstin Jonsson wrote:
>>
>>      
>>> From: Kerstin Jonsson<kerstin.jonsson@ericsson.com>
>>>
>>> When the SMP kernel decides to crash_kexec() the local APICs may have
>>> pending interrupts in their vector tables.
>>> The setup routine for the local APIC has a deficient mechanism for
>>> clearing these interrupts, it only handles interrupts that has already
>>> been dispatched to the local core for servicing (the ISR register)
>>> safely, it doesn't consider lower prioritized queued interrupts stored
>>> in the IRR register.
>>>
>>> If you have more than one pending interrupt within the same 32 bit word
>>> in the LAPIC vector table registers you may find yourself entering the
>>> IO APIC setup with pending interrupts left in the LAPIC. This is a
>>> situation for wich the IO APIC setup is not prepared. Depending of
>>> what/which interrupt vector/vectors are stuck in the APIC tables your
>>> system may show various degrees of malfunctioning.
>>> That was the reason why the check_timer() failed in our system, the
>>> timer interrupts was blocked by pending interrupts from the old kernel
>>> when routed trough the IO APIC.
>>>
>>> Additional comment from Jiri Bohac:
>>> ==============
>>> If this should go into stable release,
>>> I'd add some kind of limit on the number of iterations, just to be safe from
>>> hard to debug lock-ups:
>>>
>>> +if (loops++>   MAX_LOOPS) {
>>> +        printk("LAPIC pending clean-up")
>>> +        break;
>>> +}
>>>    while (queued);
>>>
>>> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
>>> pending IRQs to be cleared and would and still cause at most a second of delay
>>> if the loop were to lock-up for whatever reason.
>>> ==============
>>>
>>>   From trenn@suse.de:
>>> Merged Jiri suggestion into the patch.
>>> Also made the max_loops depend on cpu_khz. Not sure how long an apic_read
>>> takes, as it is on the CPU it may only be one cycle and we now wait 1 sec
>>> in WARN_ON(..) case?
>>>
>>>
>>>
>>>        
>> An apic_read() can take a couple of microseconds when running
>> virtualized, so this loop may run for hours.  On the other hand,
>> virtualized hardware is unlikely to misbehave.
>>
>> Still I recommend using a clocksource (tsc would do) and not a loop count.
>>
>> --
>> error compiling committee.c: too many arguments to function
>>
>>
>>
>>      
> Is it possible/thinkable to distinguish between real and virtual targets?
> I.e. to somehow detect that the target is a virtual machine and adapt accordingly.
> There may be other cases as well, in which one would benefit from taking
> target type into consideration when e.g. estimating the reasonable number of cycles
> for a specific operation

It's possible (cpuid hypervisor bit), but I don't think it's a good 
idea.  Splitting up code paths doubles the chance of bugs.  Much better 
to find something that works both ways.

-- 
error compiling committee.c: too many arguments to function

