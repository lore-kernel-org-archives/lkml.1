Return-Path: <linux-kernel-owner+w=401wt.eu-S1754516AbYKJQTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbYKJQTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 11:19:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbYKJQTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 11:19:43 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:42196 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbYKJQTm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 11:19:42 -0500
Message-ID: <49185F08.9030705@cosmosbay.com>
Date: Mon, 10 Nov 2008 17:19:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110161133.GB16522@localhost>
In-Reply-To: <20081110161133.GB16522@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 10 Nov 2008 17:19:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov a écrit :
> [Eric Dumazet - Mon, Nov 10, 2008 at 03:23:00PM +0100]
>> Andi Kleen a écrit :
>>> Eric Dumazet <dada1@cosmosbay.com> writes:
>>>
>>>> diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
>>>> index 3f1b81a..716d26f 100644
>>>> --- a/arch/x86/oprofile/op_model_ppro.c
>>>> +++ b/arch/x86/oprofile/op_model_ppro.c
>>>> @@ -69,7 +69,7 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
>>>>  	int i;
>>>>   	if (!reset_value) {
>>>> -		reset_value = kmalloc(sizeof(unsigned) * num_counters,
>>>> +		reset_value = kmalloc(sizeof(reset_value[0]) * num_counters,
>>> Thanks for tracking this down.
>>>
>>> But that still doesn't explain why 2.6.27 fails too?
>> Desesperatly Seeking Oprofile, next round.
>>
>> I know *nothing* about APIC but spent few hours to try several tricks
>> and finally found something.
>>
>> It solved my problem : oprofile can run several hours without
>> any freeze of NMI on any core.
>>
>> # grep NMI /proc/interrupts
>> NMI:   10902884    9635871   10333815    8372989    7971483    8298373    8877495   10206963   Non-maskable interrupts
>> ...
>> # grep NMI /proc/interrupts
>> NMI:   15518834   14340713   15038694   13078235   12676585   13003394   13582115   14912146   Non-maskable interrupts
>>
>>
>> Can anybody understand and explain what is happening ?
>>
>> Is it a software or hardware problem ?
>>
>> [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
>>
>> While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),
>> I noticed that one CPU after the other could not get anymore NMI.
>>
>> After a while, all cores where blocked (ie not generating events for oprofile)
>> I tried all major linux versions and all where affected by this freeze.
>>
>> I found that we have to re-arm APIC_DM_NMI *before* writing to MSR counter
>> when we get event notification.
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>> arch/x86/oprofile/op_model_ppro.c |    8 +++++---
>> 1 files changed, 5 insertions(+), 3 deletions(-)
> 
> | diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
> | index 3f1b81a..7b142da 100644
> | --- a/arch/x86/oprofile/op_model_ppro.c
> | +++ b/arch/x86/oprofile/op_model_ppro.c
> | @@ -132,13 +132,15 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
> |  		rdmsrl(msrs->counters[i].addr, val);
> |  		if (CTR_OVERFLOWED(val)) {
> |  			oprofile_add_sample(regs, i);
> | +			/*
> | +			 * We need to unmask the apic vector *before*
> | +			 * writing reset_value to msr counter
> | +			 */
> | +			apic_write(APIC_LVTPC, APIC_DM_NMI);
> |  			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
> |  		}
> |  	}
> |  
> | -	/* Only P6 based Pentium M need to re-unmask the apic vector but it
> | -	 * doesn't hurt other P6 variant */
> | -	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> |  
> |  	/* We can't work out if we really handled an interrupt. We
> |  	 * might have caught a *second* counter just after overflowing
> 
> Hi Eric,
> 
> for the record
> 
> 	apic_write(APIC_LVTPC, APIC_DM_NMI);
> 
> is not just 'unmask' but also *zeroify* (not sure if I wrote this
> word right :) all fields when the origianl code was just 'unmasking'
> TPC register
> 
> 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
> 
> that is why apic_read() was in former.
> 

Well, given that APIC_LVTPC is initialized by oprofile init to value APIC_DM_NMI,
I avoid an apic_read() and just write APIC_DM_NMI again...

Presumably, apic_read(APIC_LVTPC) should return APIC_DM_NMI or APIC_DM_NMI|APIC_LVT_MASKED

Thanks

