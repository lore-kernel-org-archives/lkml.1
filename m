Return-Path: <linux-kernel-owner+w=401wt.eu-S1756610AbXIRDPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbXIRDPT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 23:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXIRDPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 23:15:05 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59848
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXIRDPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 23:15:03 -0400
Date: Mon, 17 Sep 2007 20:14:56 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
cc: ytht.net@gmail.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       davem@davemloft.net
Subject: Re: [PATCH] 2.6.22.6 NETWORKING [IPV4]: Always use source addr in
 skb to reply packet
In-Reply-To: <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
Message-ID: <Pine.LNX.4.64.0709172000430.24221@asgard.lang.hm>
References: <20070918021617.GA15540@router.lepton.home>
 <20070917.192044.48396034.davem@davemloft.net> <20070918.112644.28694997.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007, YOSHIFUJI Hideaki / ^[$B5HF#1QL@^[(B wrote:

> In article <20070917.192044.48396034.davem@davemloft.net> (at Mon, 17 Sep 2007 19:20:44 -0700 (PDT)), David Miller <davem@davemloft.net> says:
>
>> From: lepton <ytht.net@gmail.com>
>> Date: Tue, 18 Sep 2007 10:16:17 +0800
>>
>>> Hi,
>>>   In some situation, icmp_reply and ip_send_reply will send
>>>   out packet with the wrong source addr, the following patch
>>>   will fix this.
>>>
>>>   I don't understand why we must use rt->rt_src in the current
>>>   code, if this is a wrong fix, please correct me.
>>>
>>> Signed-off-by: Lepton Wu <ytht.net@gmail.com>
>>
>> That the address is wrong is your opinion only :-)
>>
>> Source address selection is a rather complex topic, and
>> here we are definitely purposefully using the source
>> address selected by the routing lookup for the reply.
>
> And, if you do think something is "wrong", you need to describe it
> in detail, at least.

I missed the beginning of the discussion, so apologies if I'm way off 
base.

it sounds like the question is, when a packet hits the box that causes a 
icmp_reply (or other packet) to be generated, which IP address should be 
used as the source

1. the destination address of the packet that generated the message

or.

2. the IP address that the machine would use by default if the machine 
were to generate a new connection to the destination.

I understand that in many cases the historical approach has been #2, but 
as more machines get multiple IP addresses on each interface, I believe 
that it's less of a surprise to other systems if the default is #1. most 
of the time the other systems don't care (and useusally don't want to 
know) if the service they are contacting is on a dedicated machine or is 
just one IP among many sharing a box.

it gets especially bad when you have load balancing going on and the 
results could come from multiple boxes.

yes, sysadmins deal with this today, but it's a pain to do so and is a 
continuing dribble of suprises when things don't quite work the way you 
expect them to as you consoldate things onto more powerful systems (or 
distribute them among multiple systems).

if the packet got to the machine and the machine is accepting it, replying 
back from the destination IP of that packet should be legitimate (it's 
what you would do if there was a full connection after all) and greatly 
reduces the cases where things change.

David Lang
