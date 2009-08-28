Return-Path: <linux-kernel-owner+w=401wt.eu-S1753113AbZH1U1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbZH1U1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZH1U1L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:27:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63283 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbZH1U1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:27:10 -0400
X-IronPort-AV: E=McAfee;i="5300,2777,5723"; a="22808379"
Message-ID: <4A983DA0.9000507@codeaurora.org>
Date: Fri, 28 Aug 2009 16:27:12 -0400
From: Ashwin Chaugule <ashwinc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [RFC] [PATCH 1/1] hrtimers: Cache next hrtimer
References: <4A96FFE9.6060105@codeaurora.org> <4A970103.7010804@codeaurora.org> <alpine.LFD.2.00.0908280045200.2888@localhost.localdomain> <4A971245.5070507@codeaurora.org> <alpine.LFD.2.00.0908280111260.2888@localhost.localdomain> <4A9771AA.2090004@codeaurora.org> <alpine.LFD.2.00.0908281308380.2888@localhost.localdomain> <4A98070D.1050308@codeaurora.org> <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0908282005410.19335@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Fri, 28 Aug 2009, Ashwin Chaugule wrote:
>   
>> Thomas Gleixner wrote:
>> Avg startup time 26.4 (10 runs) same as last run.
>>
>> total_calls is again equal to cache_hits ... Its been a while since I wrote my
>> patch. I'll need to look deeper to see if I've done something more. B)
>> Just to make sure, I ran my patch again, I clearly see cache_hits is always
>> less than total_calls.
>>     
>
> Hmm. I'd really like to know why that's behaving different. 
>
> Usually there are only timers in the CLOCK_MONOTONIC base during
> boot. CLOCK_REALTIME base should be empty most of the time. If my
> theory is correct then the number of reprogram events is correct as
> well because base[MONOTONIC]->first is always the one which armed the
> timer.
>
> Can you add some debug which tells us to which base the removed timer
> belongs ?
>   

You're right about that. I confirmed that its MONOTONIC all the way. (I didn't think it'd be like that)
However, the reason for different results, *I think* is coming from hrtimer_reprogram,
where we check if the newly enqueued timer is going to expire before the currently armed timer.
Thats where I change /next_hrtimer/ as well.

So, if the expires_next value is changed as a result of hrtimer_enqueue_reprogram, we just raise HRTIMER_SOFTIRQ (rightfully),
but the latest patch doesn't do those checks in this path, coz, we don't call force_reprogram. 


Cheers,
Ashwin


