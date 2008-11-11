Return-Path: <linux-kernel-owner+w=401wt.eu-S1756463AbYKKMsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463AbYKKMsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 07:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755585AbYKKMs2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 07:48:28 -0500
Received: from mx2.redhat.com ([66.187.237.31]:54436 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403AbYKKMs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 07:48:27 -0500
Message-ID: <49197F0B.8060509@redhat.com>
Date: Tue, 11 Nov 2008 13:48:11 +0100
From: Ivan Vecera <ivecera@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, nhorman@redhat.com,
       jmarchan@redhat.com
Subject: Re: [PATCH] x86: call machine_shutdown and stop all CPUs in	native_machine_halt
References: <1224504787-11403-1-git-send-email-ivecera@redhat.com> <20081020160058.GB22779@elte.hu> <48FDCCCB.2080103@redhat.com> <491316D9.20206@redhat.com> <20081110224934.GA2069@ucw.cz>
In-Reply-To: <20081110224934.GA2069@ucw.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Thu 2008-11-06 17:10:01, Ivan Vecera wrote:
>> Any comments?
>>
>> Ivan
>>
>> ---
>> Ivan Vecera wrote:
>>> Ingo Molnar wrote:
>>>> the code in arch/x86/kernel/smp.c::stop_this_cpu() is very similar to 
>>>> this and could be shared. You could move the stop_this_cpu() function to 
>>>> arch/x86/kernel/process.c (out of smp.c), so that it can be used by 
>>>> reboot.c.
>>>>
>>> Yes, this make sense. Here is the patch.
>>>
>>> Ivan
>>>
>>> ---
>>>  arch/x86/kernel/process.c |   16 ++++++++++++++++
>>>  arch/x86/kernel/reboot.c  |    5 +++++
>>>  arch/x86/kernel/smp.c     |   13 -------------
>>>  include/asm-x86/system.h  |    2 ++
>>>  4 files changed, 23 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>>> index c622772..af6904e 100644
>>> --- a/arch/x86/kernel/process.c
>>> +++ b/arch/x86/kernel/process.c
>>> @@ -8,6 +8,7 @@
>>>  #include <linux/pm.h>
>>>  #include <linux/clockchips.h>
>>>  #include <asm/system.h>
>>> +#include <asm/apic.h>
>>>  
>>>  unsigned long idle_halt;
>>>  EXPORT_SYMBOL(idle_halt);
>>> @@ -122,6 +123,21 @@ void default_idle(void)
>>>  EXPORT_SYMBOL(default_idle);
>>>  #endif
>>>  
>>> +void stop_this_cpu(void *dummy)
>>> +{
>>> +	local_irq_disable();
>>> +	/*
>>> +	 * Remove this CPU:
>>> +	 */
>>> +	cpu_clear(smp_processor_id(), cpu_online_map);
>>> +#ifdef CONFIG_X86_LOCAL_APIC
>>> +	disable_local_APIC();
>>> +#endif
>>> +	if (hlt_works(smp_processor_id()))
>>> +		for (;;) halt();
>>> +	for (;;);
>>> +}
> 
> Why the new ifdef? And while we are at it, why is it neccessary to
> disable APIC for stopping CPU? (comment in code would be nice)
Because stop_this_cpu is shared between native_machine_halt and
native_smp_send_stop. It was only moved from smp.c to process.c.
native_machine_halt doesn't require disable APIC for stopping the
current CPU because at this time is already disabled.
The ifdef is another thing and I sent already corrected patch.
> 
>>> -static void stop_this_cpu(void *dummy)
>>> -{
>>> -	local_irq_disable();
>>> -	/*
>>> -	 * Remove this CPU:
>>> -	 */
>>> -	cpu_clear(smp_processor_id(), cpu_online_map);
>>> -	disable_local_APIC();
>>> -	if (hlt_works(smp_processor_id()))
>>> -		for (;;) halt();
>>> -	for (;;);
>>> -}
>>> -
>>>  /*
>>>   * this function calls the 'stop' function on all other CPUs in the system.
>>>   */
> 

