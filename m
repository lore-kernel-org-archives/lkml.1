Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbXLFHDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbXLFHDa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 02:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbXLFHDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 02:03:23 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:38626 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbXLFHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 02:03:22 -0500
Message-ID: <47579E89.6080802@cosmosbay.com>
Date: Thu, 06 Dec 2007 08:02:33 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
References: <20071204114125.GA17310@torres.zugschlus.de> <20071204161811.GB15974@stusta.de> <20071204164720.6e4dc2c4@the-village.bc.nu> <475599D6.4030008@cosmosbay.com> <20071205212646.GP17536@waste.org>
In-Reply-To: <20071205212646.GP17536@waste.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Thu, 06 Dec 2007 08:02:41 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall a écrit :
> On Tue, Dec 04, 2007 at 07:17:58PM +0100, Eric Dumazet wrote:
>> Alan Cox a ?crit :
>>>> No matter what you consider as being better, changing a 12 years old and 
>>>> widely used userspace interface like /dev/urandom is simply not an 
>>>> option.
>>>>    
>>> Fixing it to be more efficient in its use of entropy and also fixing the
>>> fact its not actually a good random number source would be worth looking
>>> at however.
>>>  
>> Yes, since current behavior on network irq is very pessimistic.
> 
> No, it's very optimistic. The network should not be trusted.

You keep saying that. I am refering to your previous attempts last year to 
remove net drivers from sources of entropy. No real changes were done.

If the network should not be trusted, then a patch should make sure network 
interrupts feed /dev/urandom but not /dev/random at all. (ie not calling 
credit_entropy_store() at all)

> 
> The distinction between /dev/random and /dev/urandom boils down to one
> word: paranoia. If you are not paranoid enough to mistrust your
> network, then /dev/random IS NOT FOR YOU. Use /dev/urandom. Do not
> send patches to make /dev/random less paranoid, kthxbye.

I have many tg3 adapters on my servers, receiving thousand of interrupts per 
second, and calling add_timer_randomness(). I would like to either :

- Make sure this stuff is doing usefull job.
- Make improvements to reduce cpu time used.

I do not use /dev/urandom or/and /dev/random, but I know David wont accept a 
patch to remove IRQF_SAMPLE_RANDOM from tg3.c

Currently, I see that current implementation is suboptimal because it calls 
credit_entropy_store( nbits=0) forever.

> 
>> If you have some trafic, (ie more than HZ/2  interrupts per second), 
>> then add_timer_randomness() feeds
>> some entropy but gives no credit (calling credit_entropy_store() with 
>> nbits=0)
>>
>> This is because we take into account only the jiffies difference, and 
>> not the get_cycles() that should give
>> us more entropy on most plaforms.
> 
> If we cannot measure a difference, we should nonetheless assume there
> is one?

There is a big difference on get_cycles() and jiffies. You should try to 
measure it on a typical x86_64 platform.

>  
>> In this patch, I suggest that we feed only one u32 word of entropy, 
>> combination of the previous distinct
>> words (with some of them being constant or so), so that the nbits 
>> estimation is less pessimistic, but also to
>> avoid injecting false entropy.
> 
> Umm.. no, that's not how it works at all.
> 
> Also, for future reference, patches for /dev/random go through me, not
> through Dave.
> 

Why ? David is the network maintainer, and he was the one who rejected your 
previous patches.
