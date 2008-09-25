Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbYIYTWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbYIYTWd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 15:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbYIYTWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 15:22:22 -0400
Received: from vms173003pub.verizon.net ([206.46.173.3]:64851 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819AbYIYTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 15:22:21 -0400
Date: Thu, 25 Sep 2008 14:14:47 -0500
From: Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH 1/1] Use RCU for the UDP hash lock
In-reply-to: <20080925084509.GA5090@ff.dom.local>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Message-id: <48DBE327.8010709@acm.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <48DB2925.2070908@poczta.onet.pl>
 <20080925084509.GA5090@ff.dom.local>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
>
> ...
>   
>> @@ -1094,7 +1103,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
>>  	struct sock *sk;
>>  	int dif;
>>  
>> -	read_lock(&udp_hash_lock);
>> +	rcu_read_lock();
>>  	sk = sk_head(&udptable[udp_hashfn(net, ntohs(uh->dest))]);
>>     
>
> Probably sk_head_rcu() is needed too.
>   
Yes, it is.
>   
>>  	dif = skb->dev->ifindex;
>>  	sk = udp_v4_mcast_next(sk, uh->dest, daddr, uh->source, saddr, dif);
>> @@ -1120,7 +1129,7 @@ static int __udp4_lib_mcast_deliver(struct net *net, struct sk_buff *skb,
>>  		} while (sknext);
>>  	} else
>>  		kfree_skb(skb);
>> -	read_unlock(&udp_hash_lock);
>> +	rcu_read_unlock();
>>  	return 0;
>>  }
>>     
> ...
>
> Aren't other functions like sk_next() or sk_unhashed() used on the
> read side and need _rcu versions?
>   
It also needs sk_next_rcu().  sk_unhashed() is only used on the update 
side, so an rcu version is not needed there.

Thanks for pointing this out.

-corey

