Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbYJXRvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbYJXRvg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 13:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYJXRv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 13:51:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50242 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbYJXRv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 13:51:27 -0400
Message-ID: <49020B39.6080805@redhat.com>
Date: Fri, 24 Oct 2008 13:51:53 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: maxk@qualcomm.com, LinuxPPC-dev list <linuxppc-dev@ozlabs.org>,
       linux-kernel Kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC based systems)
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org> <4901E6FB.4070200@redhat.com> <36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org> <4901F31E.9040007@redhat.com> <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org>
In-Reply-To: <5967704E-0117-46B8-8505-6A002502C38C@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kumar Gala wrote:
> 
> On Oct 24, 2008, at 11:09 AM, Chris Snook wrote:
> 
>> Kumar Gala wrote:
>>> On Oct 24, 2008, at 10:17 AM, Chris Snook wrote:
>>>> Kumar Gala wrote:
>>>>> It appears the default IRQ affinity changes from being just cpu 0 
>>>>> to all cpu's.  This breaks several PPC SMP systems in which only a 
>>>>> single processor is allowed to be selected as the destination of 
>>>>> the IRQ.
>>>>> What is the right answer in fixing this?  Should we:
>>>>>   cpumask_t irq_default_affinity = 1;
>>>>> instead of
>>>>>   cpumask_t irq_default_affinity = CPU_MASK_ALL?
>>>>
>>>> On those systems, perhaps, but not universally.  There's plenty of 
>>>> hardware where the physical topology of the machine is abstracted 
>>>> away from the OS, and you need to leave the mask wide open and let 
>>>> the APIC figure out where to map the IRQs.  Ideally, we should 
>>>> probably make this decision based on the APIC, but if there's no PPC 
>>>> hardware that uses this technique, then it would suffice to make 
>>>> this arch-specific.
>>> What did those systems do before this patch?  Its one thing to expose 
>>> a mask in the ability to change the default mask in 
>>> /proc/irq/default_smp_affinity.  Its another (and a regression in my 
>>> opinion) to change the mask value itself.
>>
>> Before the patch they took an extremely long time to boot if they had 
>> storage attached to each node of a multi-chassis system, performed 
>> poorly unless special irqbalance hackery or manual assignment was 
>> used, and imposed artificial restrictions on the granularity of 
>> hardware partitioning to ensure that CPU 0 would always be a CPU that 
>> could service all interrupts necessary to boot the OS.
>>
>>> As for making it ARCH specific, that doesn't really help since not 
>>> all PPC hw has the limitation I spoke of.  Not even all MPIC (in our 
>>> cases) have the limitation.
>>
>> What did those systems do before this patch? :)
>>
>> Making it arch-specific is an extremely simple way to solve your 
>> problem without making trouble for the people who wanted this patch in 
>> the first place.  If PPC needs further refinement to handle particular 
>> *PICs, you can implement that without touching any arch-generic code.
> 
> 
> So why not just have x86 startup code set irq_default_affinity = 
> CPU_MASK_ALL than?

It's an issue on Itanium as well, and potentially any SMP architecture with a 
non-trivial interconnect.

-- Chris
