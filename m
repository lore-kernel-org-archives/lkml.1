Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZCSFtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZCSFtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:49:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbZCSFtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:49:36 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:33230 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbZCSFtf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:49:35 -0400
Message-ID: <49C1DCDF.6050300@cosmosbay.com>
Date: Thu, 19 Mar 2009 06:49:19 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sven@thebigcorporation.com, ghaskins@novell.com, vernux@us.ibm.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
References: <1237425191.8204.41.camel@quadrophenia.thebigcorporation.com>	<20090318.181713.62394874.davem@davemloft.net>	<1237427007.8204.55.camel@quadrophenia.thebigcorporation.com> <20090318.185441.138157931.davem@davemloft.net>
In-Reply-To: <20090318.185441.138157931.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 19 Mar 2009 06:49:20 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
> Date: Wed, 18 Mar 2009 18:43:27 -0700
> 
>> Do we have to rule-out per-CPU queues, that aggregate into a master
>> queue in a batch-wise manner? 
> 
> That would violate the properties and characteristics expected by
> the packet scheduler, wrt. to fair based fairness, rate limiting,
> etc.
> 
> The only legal situation where we can parallelize to single device
> is where only the most trivial packet scheduler is attached to
> the device and the device is multiqueue, and that is exactly what
> we do right now.

I agree with you David.

Still, there is room for improvements, since :

1) default qdisc is pfifo_fast. This beast uses three sk_buff_head (96 bytes)
  where it could use 3 smaller list_head (3 * 16 = 48 bytes on x86_64)

 (assuming sizeof(spinlock_t) is only 4 bytes, but it's more than that
 on various situations (LOCKDEP, ...)

2) struct Qdisc layout could be better, letting read mostly fields
   at beginning of structure. (ie move 'dev_queue', 'next_sched', reshape_fail,
   u32_node, __parent, ...)

  'struct gnet_stats_basic' has a 32 bits hole

   'gnet_stats_queue' could be split, at least in Qdisc, so that three
   seldom use fields (drops, requeues, overlimits) go in a different cache line.

   gnet_stats_rate_est might be also moved in a 'not very used' cache line, if
   I am not mistaken ?

3) In stress situation a CPU A queues a skb to a sk_buff_head, but a CPU B
   dequeues it to feed device, involving an expensive cache line miss
   on the skb.{next|prev} (to set them to NULL)

   We could:
      Use a special dequeue op that doesnt touch skb.{next|prev}
   Eventually set next/prev to NULL after q.lock is released



