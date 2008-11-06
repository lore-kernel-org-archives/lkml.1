Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbYKFNoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbYKFNoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 08:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbYKFNnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 08:43:21 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754583AbYKFNnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 08:43:20 -0500
Message-ID: <4912F45A.9000505@redhat.com>
Date: Thu, 06 Nov 2008 08:42:50 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mark.langsdorf@amd.com
Subject: Re: [PATCH] Warn of incorrect cpu_khz on AMD systems
References: <20081104152720.9964.71959.sendpatchset@prarit.bos.redhat.com> <20081106090118.GC4890@elte.hu>
In-Reply-To: <20081106090118.GC4890@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Cannot we avoid this situation somehow? The calibrate_cpu() function 
> is quite ugly and does a dangerous thing by ignoring the reservation. 
>
>   

Yes, I noticed that too -- it's really the crux of the problem.  If 
no_ctr_free is a last resort boot option.  But I wonder if it should 
exist at all.

I was originally thinking the system should just stop booting if 
no_ctr_free and panic() ... and I'm willing to make that patch.

The likelihood of hitting this is low, below .0125% of the time.  But 
when it does hit, it is nasty and difficult to diagnose.
The last thing that I thought could be wrong was that cpu_khz was busted.

> This whole sequence is sloppy:
>
>         for (i = 0; i < 4; i++)
>                 if (avail_to_resrv_perfctr_nmi_bit(i))
>                         break;
>         no_ctr_free = (i == 4);
>         if (no_ctr_free) {
>                 i = 3;
>                 rdmsrl(MSR_K7_EVNTSEL3, evntsel3);
>                 wrmsrl(MSR_K7_EVNTSEL3, 0);
>                 rdmsrl(MSR_K7_PERFCTR3, pmc3);
>         } else {
>                 reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i);
>                 reserve_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
>         }
>
>   
>>  	no_ctr_free = (i == 4);
>>  	if (no_ctr_free) {
>> +		printk(KERN_WARN "Warning: AMD perfctrs busy ... "
>> +		       "cpu_khz value may be incorrect.\n");
>>     
>
> also, please use a WARN() instead so that kerneloops.org picks it up.
>
>   

Will do -- but do you think a panic() is more appropriate?

P.

> 	Ingo
>   
