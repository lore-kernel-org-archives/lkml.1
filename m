Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0BPNDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 08:03:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308Ab0BPNDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 08:03:09 -0500
Message-ID: <4B7A9852.5020105@redhat.com>
Date: Tue, 16 Feb 2010 21:06:26 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Octavian Purdila <opurdila@ixiacom.com>
CC: David Miller <davem@davemloft.net>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [net-next PATCH v4 3/3] net: reserve ports for applications using
 fixed port numbers
References: <1266271241-6293-1-git-send-email-opurdila@ixiacom.com> <1266271241-6293-4-git-send-email-opurdila@ixiacom.com> <4B7A6740.1000701@redhat.com> <201002161306.29708.opurdila@ixiacom.com>
In-Reply-To: <201002161306.29708.opurdila@ixiacom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Octavian Purdila wrote:
> On Tuesday 16 February 2010 11:37:04 you wrote:
>>>  	BUILD_BUG_ON(sizeof(struct inet_skb_parm) > sizeof(dummy_skb->cb));
>>>
>>> +	sysctl_local_reserved_ports = kzalloc(65536 / 8, GFP_KERNEL);
>>> +	if (!sysctl_local_reserved_ports)
>>> +		goto out;
>>> +
>> I think we should also consider the ports in ip_local_port_range,
>> since we can only reserve the ports in that range.
>>
> 
> That is subject to changes at runtime, which means we will have to readjust 
> the bitmap at runtime which introduces the need for additional synchronization 
> operations which I would rather avoid. 

Why? As long as the bitmap is global, this will not be hard.

Consider that if one user writes a port number which is beyond
the ip_local_port_range into ip_local_reserved_ports, we should
not accept this, because it doesn't make any sense. But with your
patch, we do.


> 
>>> +	{
>>> +		.procname	= "ip_local_reserved_ports",
>>> +		.data		= NULL, /* initialized in sysctl_ipv4_init */
>>> +		.maxlen		= 65536,
>>> +		.mode		= 0644,
>>> +		.proc_handler	= proc_dobitmap,
>>> +	},
>> Isn't there an off-by-one here?
>>
>> In patch 2/3, you use 0 to set the fist bit, then how about 65535 which
>> writes 65536th bit? This is beyond the range of port number.
>>
> 
> This seems fine to me, 65535 is the value used by both the port checking 
> function and the proc read/write function. And it translates indeed to  
> 65536th bit, but that is also bit 65535 if you start counting bits from 0 
> instead of 1. The usual computing/natural arithmetic confusion for the meaning 
> of first :)
> 

Oh, I see.

Thanks.

