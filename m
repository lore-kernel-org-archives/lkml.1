Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbZCRUSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbZCRUSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZCRURu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:17:50 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:58967 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCRURs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:17:48 -0400
Message-ID: <49C156E8.1090306@us.ibm.com>
Date: Wed, 18 Mar 2009 13:17:44 -0700
From: Vernon Mauery <vernux@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: High contention on the sk_buff_head.lock
References: <49C12E64.1000301@us.ibm.com> <49C14667.2040806@cosmosbay.com>
In-Reply-To: <49C14667.2040806@cosmosbay.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Vernon Mauery a écrit :
>> I have been beating on network throughput in the -rt kernel for some time
>> now.  After digging down through the send path of UDP packets, I found
>> that the sk_buff_head.lock is under some very high contention.  This lock
>> is acquired each time a packet is enqueued on a qdisc and then acquired
>> again to dequeue the packet.  Under high networking loads, the enqueueing
>> processes are not only contending among each other for the lock, but also
>> with the net-tx soft irq.  This makes for some very high contention on this
>> one lock.  My testcase is running varying numbers of concurrent netperf
>> instances pushing UDP traffic to another machine.  As the count goes from
>> 1 to 2, the network performance increases.  But from 2 to 4 and from 4
>> to 8,
>> we see a big decline, with 8 instances pushing about half of what a single
>> thread can do.
>>
>> Running 2.6.29-rc6-rt3 on an 8-way machine with a 10GbE card (I have tried
>> both NetXen and Broadcom, with very similar results), I can only push about
>> 1200 Mb/s.  Whereas with the mainline 2.6.29-rc8 kernel, I can push nearly
>> 6000 Mb/s. But still not as much as I think is possible.  I was curious and
>> decided to see if the mainline kernel was hitting the same lock, and using
>> /proc/lock_stat, it is hitting the sk_buff_head.lock as well (it was the
>> number one contended lock).
>>
>> So while this issue really hits -rt kernels hard, it has a real effect on
>> mainline kernels as well.  The contention of the spinlocks is amplified
>> when they get turned into rt-mutexes, which causes a double context switch.
>>
>> Below is the top of the lock_stat for 2.6.29-rc8.  This was captured from
>> a 1 minute network stress test.  The next high contender had 2 orders of
>> magnitude fewer contentions.  Think of the throughput increase if we could
>> ease this contention a bit.  We might even be able to saturate a 10GbE
>> link.
>>
>> lock_stat version 0.3
>> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>>       class name    con-bounces    contentions   waittime-min  
>> waittime-max   waittime-total    acq-bounces   acquisitions  
>> holdtime-min  holdtime-max holdtime-total
>> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>>
>>    &list->lock#3:      24517307       24643791           0.71       
>> 1286.62      56516392.42       34834296       44904018          
>> 0.60        164.79    31314786.02
>>     -------------
>>    &list->lock#3       15596927    [<ffffffff812474da>]
>> dev_queue_xmit+0x2ea/0x468
>>    &list->lock#3        9046864    [<ffffffff812546e9>]
>> __qdisc_run+0x11b/0x1ef
>>     -------------
>>    &list->lock#3        6525300    [<ffffffff812546e9>]
>> __qdisc_run+0x11b/0x1ef
>>    &list->lock#3       18118491    [<ffffffff812474da>]
>> dev_queue_xmit+0x2ea/0x468
>>
>>
>> The story is the same for -rt kernels, only the waittime and holdtime
>> are both
>> orders of magnitude greater.
>>
>> I am not exactly clear on the solution, but if I understand correctly,
>> in the
>> past there has been some discussion of batched enqueueing and
>> dequeueing.  Is
>> anyone else working on this problem right now who has just not yet posted
>> anything for review?  Questions, comments, flames?
>>
> 
> Yes we have a known contention point here, but before adding more complex code,
> could you try following patch please ?

This patch does seem to reduce the number of contentions by about 10%.  That is
a good start (and a good catch on the cacheline bounces).  But, like I mentioned
above, this lock still has 2 orders of magnitude greater contention than the
next lock, so even a large decrease like 10% makes little difference in the
overall contention characteristics.

So we will have to do something more.  Whether it needs to be more complex or
not is still up in the air.  Batched enqueueing/dequeueing are just two options
and the former would be a *lot* less complex than the latter.

If anyone else has any ideas they have been holding back, now would be a great
time to get them out in the open.

--Vernon

> [PATCH] net: Reorder fields of struct Qdisc
> 
> dev_queue_xmit() needs to dirty fields "state" and "q"
> 
> On x86_64 arch, they currently span two cache lines, involving more
> cache line ping pongs than necessary.
> 
> Before patch :
> 
> offsetof(struct Qdisc, state)=0x38
> offsetof(struct Qdisc, q)=0x48
> offsetof(struct Qdisc, dev_queue)=0x60
> 
> After patch :
> 
> offsetof(struct Qdisc, dev_queue)=0x38
> offsetof(struct Qdisc, state)=0x48
> offsetof(struct Qdisc, q)=0x50
> 
> 
> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
> 
> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
> index f8c4742..e24feeb 100644
> --- a/include/net/sch_generic.h
> +++ b/include/net/sch_generic.h
> @@ -51,10 +51,11 @@ struct Qdisc
>  	u32			handle;
>  	u32			parent;
>  	atomic_t		refcnt;
> -	unsigned long		state;
> +	struct netdev_queue	*dev_queue;
> +
>  	struct sk_buff		*gso_skb;
> +	unsigned long		state;
>  	struct sk_buff_head	q;
> -	struct netdev_queue	*dev_queue;
>  	struct Qdisc		*next_sched;
>  	struct list_head	list;
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

