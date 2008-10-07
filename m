Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYJGM7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYJGM7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 08:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYJGM7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 08:59:32 -0400
Received: from smtp23.orange.fr ([193.252.22.30]:30835 "EHLO smtp23.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbYJGM7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 08:59:31 -0400
X-ME-UUID: 20081007125928838.CC96D1C0008F@mwinf2334.orange.fr
Message-ID: <48EB5D28.7000503@cosmosbay.com>
Date: Tue, 07 Oct 2008 14:59:20 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: David Miller <davem@davemloft.net>, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com, paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local>	<48EA8197.6080502@cosmosbay.com>	<20081006.144002.56418911.davem@davemloft.net>	<48EAF29D.8050203@cosmosbay.com> <m37i8k3hv1.fsf@ursa.amorsen.dk>
In-Reply-To: <m37i8k3hv1.fsf@ursa.amorsen.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Amorsen a écrit :
> Eric Dumazet <dada1@cosmosbay.com> writes:
> 
>> Most UDP sockets are setup for long periods (RTP trafic), or if an application really
>> wants to {open/send or receive one UDP frame/close} many sockets, it already hits
>> RCU handling of its file structures and should not be slowed down that much.
>>

I should have say 'Many' instead of 'Most' :)

>> By 'long period' I mean thousand of packets sent/received by each RTP session, being
>> voice (50 packets/second) or even worse video...
> 
> Does DNS with port randomization need short lived sockets?
> 

Yes very true, but current allocation of a random port can be very expensive, 
since we scan all the UDP hash table to select the smaller hash chain.

We stop the scan if we find an empty slot, but on machines with say more than 200
bound UDP sockets, they are probably no empty slots. (UDP_HTABLE_SIZE is 128)

bind(NULL port) algo is then O(N), N being number of bound UDP sockets.

So heavy DNS servers/proxies probably use a pool/range of pre-allocated sockets
to avoid costs of allocating/freeing them ? If they dont care about that cost,
the extra call_rcu() will be unnoticed.

For pathological (yet very common :) ) cases like single DNS query/answer, RCU
would mean :

Pros :
- one few rwlock hit when receiving the answer (if any)
Cons :
- one call_rcu() to delay socket freeing/reuse after RCU period.

So it might be a litle bit more expensive than without RCU

I agree I am more interested in optimizing UDP stack for heavy users like RTP 
servers/proxies handling xxx.000 packets/second than DNS users/servers.
Shame on me :)

(2 weeks ago, Corey mentioned a 10x increase on UDP throughput on a 16-way machine,
that sounds promising)





