Return-Path: <linux-kernel-owner+w=401wt.eu-S1752447AbYKRIuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752447AbYKRIuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbYKRIuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:50:02 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:39410 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbYKRIuA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:50:00 -0500
Message-ID: <4922818B.1020303@cosmosbay.com>
Date: Tue, 18 Nov 2008 09:49:15 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, shemminger@vyatta.com
Subject: Re: eth_type_trans(): Re: [Bug #11308] tbench regression on each
 kernel release from 2.6.22 -&gt; 2.6.28
References: <20081117182320.GA26844@elte.hu> <20081117184951.GA5585@elte.hu> <20081117212657.GH12020@elte.hu> <20081117.211645.193706814.davem@davemloft.net> <20081118083018.GI17838@elte.hu>
In-Reply-To: <20081118083018.GI17838@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 18 Nov 2008 09:49:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * David Miller <davem@davemloft.net> wrote:
> 
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Mon, 17 Nov 2008 22:26:57 +0100
>>
>>> eth->h_proto access.
>> Yes, this is the first time a packet is touched on receive.
>>
>>> Given that this workload does localhost networking, my guess would be 
>>> that eth->h_proto is bouncing around between 16 CPUs? At minimum this 
>>> read-mostly field should be separated from the bouncing bits.
>> It's the packet contents, there is no way to "seperate it".
>>
>> And it should be unlikely bouncing on your system under tbench, the 
>> senders and receivers should hang out on the same cpu unless the 
>> something completely stupid is happening.
>>
>> That's why I like running tbench with a num_threads command line 
>> argument equal to the number of cpus, every cpu gets the two thread 
>> talking to eachother over the TCP socket.
> 
> yeah - and i posted the numbers for that too - it's the same 
> throughput, within ~1% of noise.

Thinking once again about loopback driver, I recall a previous attempt
to call netif_receive_skb() instead of netif_rx() and pay the price
of cache line ping-pongs between cpus.

http://kerneltrap.org/mailarchive/linux-netdev/2008/2/21/939644

Maybe we could do that, with a temporary percpu stack, like we do in softirq
when CONFIG_4KSTACKS=y

(arch/x86/kernel/irq_32.c  : call_on_stack(func, stack)

And do this only if the current cpu doesnt already use its softirq_stack
(think about loopback re-entering loopback xmit because of TCP ACK for example)

Oh well... black magic, you are going to kill me :)


