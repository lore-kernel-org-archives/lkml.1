Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965953Ab0BZUCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:02:52 -0500
Received: from mailgw9.se.ericsson.net ([193.180.251.57]:63224 "EHLO
	mailgw9.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965906Ab0BZUCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:02:51 -0500
X-Greylist: delayed 901 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2010 15:02:50 EST
X-AuditID: c1b4fb39-b7c2dae000007b99-61-4b882563a2c7
From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
To: Avi Kivity <avi@redhat.com>, Thomas Renninger <trenn@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jbohac@novell.com" <jbohac@novell.com>,
       Yinghai Lu <yinghai@kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "mingo@elte.hu" <mingo@elte.hu>
Date: Fri, 26 Feb 2010 20:47:47 +0100
Subject: RE: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Thread-Topic: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Thread-Index: Acq0gGDko/GUgFYTS0uD5OQBsj8WdgCbzF9g
Message-ID: <C64F1A8E3F9E3C409DFC005F502C40D0020D8F00@ESESSCMS0359.eemea.ericsson.se>
References: <1266925885-17616-1-git-send-email-trenn@suse.de>,<4B83C411.9050308@redhat.com>
In-Reply-To: <4B83C411.9050308@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ________________________________________
> From: Avi Kivity [avi@redhat.com]
> Sent: Tuesday, February 23, 2010 1:03 PM
> To: Thomas Renninger
> Cc: linux-kernel@vger.kernel.org; Kerstin Jonsson; jbohac@novell.com; Yinghai Lu; akpm@linux-foundation.org; mingo@elte.hu
> Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
>
> On 02/23/2010 01:51 PM, Thomas Renninger wrote:
>  
>> From: Kerstin Jonsson<kerstin.jonsson@ericsson.com>
>>
>> When the SMP kernel decides to crash_kexec() the local APICs may have
>> pending interrupts in their vector tables.
>> The setup routine for the local APIC has a deficient mechanism for
>> clearing these interrupts, it only handles interrupts that has already
>> been dispatched to the local core for servicing (the ISR register)
>> safely, it doesn't consider lower prioritized queued interrupts stored
>> in the IRR register.
>>
>> If you have more than one pending interrupt within the same 32 bit word
>> in the LAPIC vector table registers you may find yourself entering the
>> IO APIC setup with pending interrupts left in the LAPIC. This is a
>> situation for wich the IO APIC setup is not prepared. Depending of
>> what/which interrupt vector/vectors are stuck in the APIC tables your
>> system may show various degrees of malfunctioning.
>> That was the reason why the check_timer() failed in our system, the
>> timer interrupts was blocked by pending interrupts from the old kernel
>> when routed trough the IO APIC.
>>
>> Additional comment from Jiri Bohac:
>> ==============
>> If this should go into stable release,
>> I'd add some kind of limit on the number of iterations, just to be safe from
>> hard to debug lock-ups:
>>
>> +if (loops++>  MAX_LOOPS) {
>> +        printk("LAPIC pending clean-up")
>> +        break;
>> +}
>>   while (queued);
>>
>> with MAX_LOOPS something like 1E9 this would leave plenty of time for the
>> pending IRQs to be cleared and would and still cause at most a second of delay
>> if the loop were to lock-up for whatever reason.
>> ==============
>>
>>  From trenn@suse.de:
>> Merged Jiri suggestion into the patch.
>> Also made the max_loops depend on cpu_khz. Not sure how long an apic_read
>> takes, as it is on the CPU it may only be one cycle and we now wait 1 sec
>> in WARN_ON(..) case?
>>
>>
>>    
>
> An apic_read() can take a couple of microseconds when running
> virtualized, so this loop may run for hours.  On the other hand,
> virtualized hardware is unlikely to misbehave.
>
> Still I recommend using a clocksource (tsc would do) and not a loop count.
>
> --
> error compiling committee.c: too many arguments to function
>
>
>  
Is it possible/thinkable to distinguish between real and virtual targets?
I.e. to somehow detect that the target is a virtual machine and adapt accordingly.
There may be other cases as well, in which one would benefit from taking
target type into consideration when e.g. estimating the reasonable number of cycles 
for a specific operation.

