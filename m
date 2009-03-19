Return-Path: <linux-kernel-owner+w=401wt.eu-S1758698AbZCSF6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698AbZCSF6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 01:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754032AbZCSF6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 01:58:36 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45066
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751851AbZCSF6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 01:58:35 -0400
Date: Wed, 18 Mar 2009 22:58:22 -0700 (PDT)
Message-Id: <20090318.225822.179893347.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: sven@thebigcorporation.com, ghaskins@novell.com, vernux@us.ibm.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: Re: High contention on the sk_buff_head.lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <49C1DCDF.6050300@cosmosbay.com>
References: <1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>
	<20090318.185441.138157931.davem@davemloft.net>
	<49C1DCDF.6050300@cosmosbay.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Thu, 19 Mar 2009 06:49:19 +0100

> Still, there is room for improvements, since :
> 
> 1) default qdisc is pfifo_fast. This beast uses three sk_buff_head (96 bytes)
>   where it could use 3 smaller list_head (3 * 16 = 48 bytes on x86_64)
> 
>  (assuming sizeof(spinlock_t) is only 4 bytes, but it's more than that
>  on various situations (LOCKDEP, ...)

I already plan on doing this, skb->{next,prev} will be replaced with a
list_head and nearly all of the sk_buff_head usage will simply
disappear.  It's a lot of work because every piece of SKB queue
handling code has to be sanitized to only use the interfaces in
linux/skbuff.h and lots of extremely ugly code like the PPP
defragmenter make many non-trivial direct skb->{next,prev}
manipulations.

> 2) struct Qdisc layout could be better, letting read mostly fields
>    at beginning of structure. (ie move 'dev_queue', 'next_sched', reshape_fail,
>    u32_node, __parent, ...)

I have no problem with your struct layout changes, submit it formally.

> 3) In stress situation a CPU A queues a skb to a sk_buff_head, but a CPU B
>    dequeues it to feed device, involving an expensive cache line miss
>    on the skb.{next|prev} (to set them to NULL)
> 
>    We could:
>       Use a special dequeue op that doesnt touch skb.{next|prev}
>    Eventually set next/prev to NULL after q.lock is released

You absolutely can't do this, as it would break GSO/GRO.  The whole
transmit path is littered with checks of skb->next being NULL for the
purposes of segmentation handling.
