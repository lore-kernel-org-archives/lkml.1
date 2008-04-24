Return-Path: <linux-kernel-owner+w=401wt.eu-S1758844AbYDXMo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbYDXMo2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 08:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756107AbYDXMoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 08:44:18 -0400
Received: from rtr.ca ([76.10.145.34]:1221 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbYDXMoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 08:44:17 -0400
Message-ID: <481080A0.9050804@rtr.ca>
Date: Thu, 24 Apr 2008 08:44:16 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, pavel@ucw.cz,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <480E70ED.3030701@rtr.ca> <20080423072432.GX12774@kernel.dk> <480F3CBC.60305@rtr.ca> <20080423135110.GO12774@kernel.dk> <480F4BD9.8090003@rtr.ca> <20080424105908.GW12774@kernel.dk>
In-Reply-To: <20080424105908.GW12774@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 23 2008, Mark Lord wrote:
>> Jens Axboe wrote:
>>> On Wed, Apr 23 2008, Mark Lord wrote:
>>> ..
>>>> The second bug, is that for the halt case at least,
>>>> nobody waits for the other CPU to actually halt
>>>> before continuing.. so we sometimes enter the shutdown
>>>> code while other CPUs are still active.
>>>>
>>>> This causes some machines to hang at shutdown,
>>>> unless CPU_HOTPLUG is configured and takes them offline
>>>> before we get here.
>>> I'm guessing there's a reason it doesn't pass '1' as the last argument,
>>> because that would fix that issue?
>> ..
>>
>> Undoubtedly -- perhaps the called CPU halts, and therefore cannot reply.  :)
> 
> Uhm yes, I guess stop_this_cpu() does exactly what the name implies :-)
> 
>> But some kind of pre-halt ack, perhaps plus a short delay by the caller
>> after receipt of the ack, would probably suffice to kill that bug.
>>
>> But I really haven't studied this code enough to know,
>> other than that it historically has been a sticky area
>> to poke around in.
> 
> Something like this will close the window to right up until the point
> where the other CPUs have 'almost' called halt().
> 
> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
> index 5398385..94ec9bf 100644
> --- a/arch/x86/kernel/smp.c
> +++ b/arch/x86/kernel/smp.c
> @@ -155,8 +155,9 @@ static void stop_this_cpu(void *dummy)
>  	/*
>  	 * Remove this CPU:
>  	 */
> -	cpu_clear(smp_processor_id(), cpu_online_map);
>  	disable_local_APIC();
> +	cpu_clear(smp_processor_id(), cpu_online_map);
> +	smp_wmb();
>  	if (hlt_works(smp_processor_id()))
>  		for (;;) halt();
>  	for (;;);
> @@ -175,6 +176,12 @@ static void native_smp_send_stop(void)
>  
>  	local_irq_save(flags);
>  	smp_call_function(stop_this_cpu, NULL, 0, 0);
> +
> +	while (cpus_weight(cpu_online_map) > 1) {
> +		cpu_relax();
> +		smp_rmb();
> +	}
> +
>  	disable_local_APIC();
>  	local_irq_restore(flags);
>  }
..

Yup, that looks like it oughta work consistently.
Now we just need to hear from some of the folks who
have danced around this code in the past.

(added Pavel & Rafael to Cc:).
