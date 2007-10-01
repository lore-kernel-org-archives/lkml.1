Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbXJAIXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbXJAIXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 04:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751629AbXJAIXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 04:23:25 -0400
Received: from smtp23.orange.fr ([80.12.242.97]:57608 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbXJAIXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 04:23:24 -0400
X-ME-UUID: 20071001082020828.CA5481C0009A@mwinf2303.orange.fr
Message-ID: <4700ADB7.7050102@cosmosbay.com>
Date: Mon, 01 Oct 2007 10:20:07 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.7 (Windows/20060909)
MIME-Version: 1.0
To: Denys <nuclearcat@nuclearcat.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
References: <200709301425.37564.nickpiggin@yahoo.com.au> <20070930223503.M8966@nuclearcat.com> <47008CB0.7010808@cosmosbay.com> <20071001.001259.28812610.davem@davemloft.net> <20071001080339.M21850@nuclearcat.com>
In-Reply-To: <20071001080339.M21850@nuclearcat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Denys a écrit :
> Well, i can play a bit more on "live" servers. I have now hot-swap server with
> full gentoo,  where i can rebuild any kernel you want, with any applied patch.
> But it looks more like not overhead, load becoming high too "spiky", and it is
> not just permantenly higher. Also it is not normal that all system becoming
> unresposive (for example ping 127.0.0.1 becoming 300ms for period, when usage
> softirq jumps to 100%).
>
>   
Could you try a pristine 2.6.22.9 and some patch in 
secure_tcp_sequence_number() like :

--- drivers/char/random.c.orig 2007-10-01 10:18:42.000000000 +0200
+++ drivers/char/random.c 2007-10-01 10:19:58.000000000 +0200
@@ -1554,7 +1554,7 @@
* That's funny, Linux has one built in! Use it!
* (Networks are faster now - should this be increased?)
*/
- seq += ktime_get_real().tv64;
+ seq += ktime_get_real().tv64 / 1000;
#if 0
printk("init_seq(%lx, %lx, %d, %d) = %d\n",
saddr, daddr, sport, dport, seq);

Thank you


> On Mon, 01 Oct 2007 00:12:59 -0700 (PDT), David Miller wrote
>   
>> From: Eric Dumazet <dada1@cosmosbay.com>
>> Date: Mon, 01 Oct 2007 07:59:12 +0200
>>
>>     
>>> No problem here on bigger servers, so I CC David Miller and netdev
>>> on this one.  AFAIK do_gettimeofday() and ktime_get_real() should
>>> use the same underlying hardware functions on PC and no performance
>>> problem should happen here.
>>>       
>> One thing that jumps out at me is that on 32-bit (and to a certain
>> extent on 64-bit) there is a lot of stack accesses and missed
>> optimizations because all of the work occurs, and gets expanded,
>> inside of ktime_get_real().
>>
>> The timespec_to_ktime() inside of there constructs the ktime_t return
>> value on the stack, then returns that as an aggregate to the caller.
>>
>> That cannot be without some cost.
>>
>> ktime_get_real() is definitely a candidate for inlining especially in
>> these kinds of cases where we'll happily get computations in local
>> registers instead of all of this on-stack nonsense.  And in several
>> cases (if the caller only needs the tv_sec value, for example)
>> computations can be elided entirely.
>>
>> It would be constructive to experiment and see if this is in fact 
>> part of the problem.
>>     
>
>
> --
> Denys Fedoryshchenko
> Technical Manager
> Virtual ISP S.A.L.
>
>
>   




