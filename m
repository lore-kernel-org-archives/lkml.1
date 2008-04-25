Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbYDYLHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbYDYLHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 07:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYDYLHm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 07:07:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:59321 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbYDYLHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 07:07:41 -0400
Date: Fri, 25 Apr 2008 13:08:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Lord <lkml@rtr.ca>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080425110822.GH14903@elf.ucw.cz>
References: <1208851058-8500-1-git-send-email-jens.axboe@oracle.com> <1208851058-8500-2-git-send-email-jens.axboe@oracle.com> <480E70ED.3030701@rtr.ca> <20080423072432.GX12774@kernel.dk> <480F3CBC.60305@rtr.ca> <20080423135110.GO12774@kernel.dk> <480F4BD9.8090003@rtr.ca> <20080424105908.GW12774@kernel.dk> <481080A0.9050804@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481080A0.9050804@rtr.ca>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> Something like this will close the window to right up until the point
>> where the other CPUs have 'almost' called halt().
>>
>> diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
>> index 5398385..94ec9bf 100644
>> --- a/arch/x86/kernel/smp.c
>> +++ b/arch/x86/kernel/smp.c
>> @@ -155,8 +155,9 @@ static void stop_this_cpu(void *dummy)
>>  	/*
>>  	 * Remove this CPU:
>>  	 */
>> -	cpu_clear(smp_processor_id(), cpu_online_map);
>>  	disable_local_APIC();
>> +	cpu_clear(smp_processor_id(), cpu_online_map);
>> +	smp_wmb();
>>  	if (hlt_works(smp_processor_id()))
>>  		for (;;) halt();
>>  	for (;;);
>> @@ -175,6 +176,12 @@ static void native_smp_send_stop(void)
>>   	local_irq_save(flags);
>>  	smp_call_function(stop_this_cpu, NULL, 0, 0);
>> +
>> +	while (cpus_weight(cpu_online_map) > 1) {
>> +		cpu_relax();
>> +		smp_rmb();
>> +	}
>> +
>>  	disable_local_APIC();
>>  	local_irq_restore(flags);
>>  }
> ..
>
> Yup, that looks like it oughta work consistently.
> Now we just need to hear from some of the folks who
> have danced around this code in the past.
>
> (added Pavel & Rafael to Cc:).

I can't  see anything wrong with this one, but I'm not smp expert...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
