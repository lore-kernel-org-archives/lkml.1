Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab0BQQKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:10:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109Ab0BQQKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:10:03 -0500
Message-ID: <4B7C159A.3060603@redhat.com>
Date: Thu, 18 Feb 2010 00:13:14 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Octavian Purdila <opurdila@ixiacom.com>,
       David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using
 fixed port numbers
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com>	 <1266271241-6293-4-git-send-email-opurdila@ixiacom.com>	 <4B7A6740.1000701@redhat.com> <201002161306.29708.opurdila@ixiacom.com>	 <4B7A9852.5020105@redhat.com> <1266326425.3045.53.camel@edumazet-laptop>
In-Reply-To: <1266326425.3045.53.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le mardi 16 février 2010 à 21:06 +0800, Cong Wang a écrit :
>> Octavian Purdila wrote:
>>> On Tuesday 16 February 2010 11:37:04 you wrote:
>>>>>  	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
>>>>>
>>>>> +	sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
>>>>> +	if (!sysctl_local_reserved_ports)
>>>>> +		goto out;
>>>>> +
>>>> I think we should also consider the ports in ip_local_port_range,
>>>> since we can only reserve the ports in that range.
>>>>
>>> That is subject to changes at runtime, which means we will have to readjust 
>>> the bitmap at runtime which introduces the need for additional synchronization 
>>> operations which I would rather avoid. 
>> Why? As long as the bitmap is global, this will not be hard.
>>
>> Consider that if one user writes a port number which is beyond
>> the ip_local_port_range into ip_local_reserved_ports, we should
>> not accept this, because it doesn't make any sense. But with your
>> patch, we do.
> 
> I disagree with you. This is perfectly OK.
> 
> A port not being flagged in ip_local_reserved_ports doesnt mean it can
> be used for allocation.
> 
> If you want to really block ports from being used at boot, you could for
> example :
> 
> # temporarly reduce the ip_local_port_range
> echo "61000 61001" >/proc/sys/net/ipv4/ip_local_port_range
> # Build our bitmap (could be slow, if a remote database is read)
> for port in $LIST_RESERVED_PORT
> do
>   echo $port >/proc/sys/net/ipv4/ip_local_reserved_ports
> done
> echo "10000 61000" >/proc/sys/net/ipv4/ip_local_port_range
> 
> 

I don't think so, if you want to avoid race condition, you just need to
write the reserved ports before any networking application starts, IOW,
as early as possible during boot.

Thanks.



