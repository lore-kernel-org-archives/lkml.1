Return-Path: <linux-kernel-owner+w=401wt.eu-S1758127AbZCWIdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127AbZCWIdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757782AbZCWIc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:32:56 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38764 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757996AbZCWIcy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:32:54 -0400
Message-ID: <49C74927.7020008@cosmosbay.com>
Date: Mon, 23 Mar 2009 09:32:39 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Vernon Mauery <vernux@us.ibm.com>, netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
References: <20090320232943.GA3024@ami.dom.local>
In-Reply-To: <20090320232943.GA3024@ami.dom.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 23 Mar 2009 09:32:39 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski a écrit :
> Vernon Mauery wrote, On 03/18/2009 09:17 PM:
> ...
>> This patch does seem to reduce the number of contentions by about 10%.  That is
>> a good start (and a good catch on the cacheline bounces).  But, like I mentioned
>> above, this lock still has 2 orders of magnitude greater contention than the
>> next lock, so even a large decrease like 10% makes little difference in the
>> overall contention characteristics.
>>
>> So we will have to do something more.  Whether it needs to be more complex or
>> not is still up in the air.  Batched enqueueing/dequeueing are just two options
>> and the former would be a *lot* less complex than the latter.
>>
>> If anyone else has any ideas they have been holding back, now would be a great
>> time to get them out in the open.
> 
> I think there would be interesting to check another idea around this
> contention: not all contenders are equal here. One thread is doing
> qdisc_run() and owning the transmit queue (even after releasing the TX
> lock). So if it waits for the qdisc lock the NIC, if not multiqueue,
> is idle. Probably some handicap like in the patch below could make
> some difference in throughput; alas I didn't test it.
> 
> Jarek P.
> ---
> 
>  net/core/dev.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index f112970..d5ad808 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1852,7 +1852,11 @@ gso:
>  	if (q->enqueue) {
>  		spinlock_t *root_lock = qdisc_lock(q);
>  
> -		spin_lock(root_lock);
> +		while (!spin_trylock(root_lock)) {
> +			do {
> +				cpu_relax();
> +			} while (spin_is_locked(root_lock));
> +		}
>  
>  		if (unlikely(test_bit(__QDISC_STATE_DEACTIVATED, &q->state))) {
>  			kfree_skb(skb);
> 
> 

I dont understand, doesnt it defeat the ticket spinlock thing and fairness ?

Thread doing __qdisc_run() already owns the __QDISC_STATE_RUNNING bit.

trying or taking spinlock has same effect, since it force a cache line ping pong,
and this is the real problem.

