Return-Path: <linux-kernel-owner+w=401wt.eu-S1757227AbXEQNFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbXEQNFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754797AbXEQNFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:05:36 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.31.125]:54881 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbXEQNFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:05:35 -0400
Date: Thu, 17 May 2007 15:05:34 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] NOHZ: local_softirq_pending with tickless plip
In-Reply-To: <1179399131.3764.50.camel@chaos>
Message-ID: <Pine.LNX.4.64.0705171453580.31321@artax.karlin.mff.cuni.cz>
References: <Pine.LNX.4.64.0705161415350.10041@artax.karlin.mff.cuni.cz>
 <1179399131.3764.50.camel@chaos>
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Hi
>>
>> On one of my machines with tickless kernel and plip I get messages :
>
> I bet this is a machine a P4 with Hyperthreading enabled ?

No, it's single Pentium 2. I have other Pentium MMX using plip, where I 
don't get these error messages, I don't know why.

Mikulas

>> NOHZ: local_softirq_pending 08
>>
>> always when using plip (on other machine with tickless kernel and plip I
>> get no errors). Thebug happens both on 2.6.21 and 2.6.22-rc1
>>
>> This patch fixes that. Note that plip calls netif_rx neither from hardware
>> interrupt nor from ksoftirqd, so there is no one who would wake
>> ksoftirqd then. netif_tx calls only
>> __raise_softirq_irqoff(NET_RX_SOFTIRQ), which sets softirq bit, but
>> doesn't wake ksoftirqd.
>
> Dave,
>
> can we please get rid of __raise_softirq_irqoff() at all ? These micro
> optimizations are causing more trouble than they are worth.
>
> 	tglx
>
>> Mikulas
>>
>> Signed-off-by: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz
>>
>> --- linux-2.6.22-rc1/net/core/dev.c_	Fri May 18 07:51:01 2007
>> +++ linux-2.6.22-rc1/net/core/dev.c	Fri May 18 07:51:06 2007
>> @@ -1117,7 +1117,7 @@
>>   		dev->quota += dev->weight;
>>   	else
>>   		dev->quota = dev->weight;
>> -	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
>> +	raise_softirq_irqoff(NET_RX_SOFTIRQ);
>>   	local_irq_restore(flags);
>>   }
>>   EXPORT_SYMBOL(__netif_rx_schedule);
>
>
