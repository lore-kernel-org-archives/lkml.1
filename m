Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab0BCFMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:12:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab0BCFM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:12:29 -0500
Message-ID: <4B690681.6070908@redhat.com>
Date: Wed, 03 Feb 2010 13:15:45 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
       linux-sctp@vger.kernel.org, David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch] net: reserve ports for applications using fixed port
 numbers
References: <20100203043332.3817.27932.sendpatchset@localhost.localdomain> <1265171993.3274.3.camel@edumazet-laptop>
In-Reply-To: <1265171993.3274.3.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le mardi 02 février 2010 à 23:30 -0500, Amerigo Wang a écrit :
>> This patch introduces /proc/sys/net/ipv4/ip_local_reserved_ports,
>> it can be used like ip_local_port_range, but this is used to
>> reserve ports for third-party applications which use fixed
>> port numbers within ip_local_port_range.
>>
>> This only affects the applications which call socket functions
>> like bind(2) with port number 0, to prevent the kernel getting the ports
>> within the specified range for them. For applications which use fixed
>> port number, it will have no effects.
>>
>> Any comments are welcome.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: David Miller <davem@davemloft.net>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> 
>>  		.procname	= "igmp_max_memberships",
>> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
>> index f0126fd..83045ca 100644
>> --- a/net/ipv4/udp.c
>> +++ b/net/ipv4/udp.c
>> @@ -210,8 +210,11 @@ int udp_lib_get_port(struct sock *sk, unsigned short snum,
>>  		inet_get_local_port_range(&low, &high);
>>  		remaining = (high - low) + 1;
>>  
>> +again:
>>  		rand = net_random();
>>  		first = (((u64)rand * remaining) >> 32) + low;
>> +		if (inet_is_reserved_local_port(first))
>> +			goto again;
>>  		/*
>>  		 * force rand to be an odd multiple of UDP_HTABLE_SIZE
>>  		 */
> 
> Unless I misread the patch, you are checking only the 'first' port that
> udp_lib_get_port() chose.
> 
> I would use inet_get_local_reserved_ports(&min_res, &max_res);
> and check every port that we chose in the loop to avoid it if necessary.
> 

Hmm, right, 'first' is used to do iteration, but I did missed 'last'.
Thanks! I will fix this in the next update.

