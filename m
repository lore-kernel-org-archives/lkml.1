Return-Path: <linux-kernel-owner+w=401wt.eu-S1756233AbZCSOEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756233AbZCSOEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 10:04:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755514AbZCSOEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 10:04:24 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48468 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273AbZCSOEX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 10:04:23 -0400
Message-ID: <49C250DB.3050707@cosmosbay.com>
Date: Thu, 19 Mar 2009 15:04:11 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sven@thebigcorporation.com, ghaskins@novell.com, vernux@us.ibm.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       pmullaney@novell.com
Subject: [PATCH] net: reorder struct Qdisc for better SMP performance
References: <1237427007.8204.55.camel@quadrophenia.thebigcorporation.com>	<20090318.185441.138157931.davem@davemloft.net>	<49C1DCDF.6050300@cosmosbay.com> <20090318.225822.179893347.davem@davemloft.net>
In-Reply-To: <20090318.225822.179893347.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 19 Mar 2009 15:04:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller a écrit :
> From: Eric Dumazet <dada1@cosmosbay.com>
> Date: Thu, 19 Mar 2009 06:49:19 +0100
> 
>> Still, there is room for improvements, since :
>>
>> 1) default qdisc is pfifo_fast. This beast uses three sk_buff_head (96 bytes)
>>   where it could use 3 smaller list_head (3 * 16 = 48 bytes on x86_64)
>>
>>  (assuming sizeof(spinlock_t) is only 4 bytes, but it's more than that
>>  on various situations (LOCKDEP, ...)
> 
> I already plan on doing this, skb->{next,prev} will be replaced with a
> list_head and nearly all of the sk_buff_head usage will simply
> disappear.  It's a lot of work because every piece of SKB queue
> handling code has to be sanitized to only use the interfaces in
> linux/skbuff.h and lots of extremely ugly code like the PPP
> defragmenter make many non-trivial direct skb->{next,prev}
> manipulations.
> 
>> 2) struct Qdisc layout could be better, letting read mostly fields
>>    at beginning of structure. (ie move 'dev_queue', 'next_sched', reshape_fail,
>>    u32_node, __parent, ...)
> 
> I have no problem with your struct layout changes, submit it formally.

OK here is the layout change then ;)

Thank you

[PATCH] net: reorder struct Qdisc for better SMP performance

dev_queue_xmit() needs to dirty fields "state", "q", "bstats" and "qstats"

On x86_64 arch, they currently span three cache lines, involving more
cache line ping pongs than necessary, making longer holding of queue spinlock.

We can reduce this to one cache line, by grouping all read-mostly fields
at the beginning of structure. (Or should I say, all highly modified fields
at the end :) )

Before patch :

offsetof(struct Qdisc, state)=0x38
offsetof(struct Qdisc, q)=0x48
offsetof(struct Qdisc, bstats)=0x80
offsetof(struct Qdisc, qstats)=0x90
sizeof(struct Qdisc)=0xc8

After patch :

offsetof(struct Qdisc, state)=0x80
offsetof(struct Qdisc, q)=0x88
offsetof(struct Qdisc, bstats)=0xa0
offsetof(struct Qdisc, qstats)=0xac
sizeof(struct Qdisc)=0xc0

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---
 include/linux/gen_stats.h |    2 +-
 include/net/sch_generic.h |   21 ++++++++++++---------
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/gen_stats.h b/include/linux/gen_stats.h
index 13f4e74..0ffa41d 100644
--- a/include/linux/gen_stats.h
+++ b/include/linux/gen_stats.h
@@ -22,7 +22,7 @@ struct gnet_stats_basic
 {
 	__u64	bytes;
 	__u32	packets;
-};
+} __attribute__ ((packed));
 
 /**
  * struct gnet_stats_rate_est - rate estimator
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index f8c4742..b0ae100 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -48,18 +48,10 @@ struct Qdisc
 	int			padded;
 	struct Qdisc_ops	*ops;
 	struct qdisc_size_table	*stab;
+	struct list_head	list;
 	u32			handle;
 	u32			parent;
 	atomic_t		refcnt;
-	unsigned long		state;
-	struct sk_buff		*gso_skb;
-	struct sk_buff_head	q;
-	struct netdev_queue	*dev_queue;
-	struct Qdisc		*next_sched;
-	struct list_head	list;
-
-	struct gnet_stats_basic	bstats;
-	struct gnet_stats_queue	qstats;
 	struct gnet_stats_rate_est	rate_est;
 	int			(*reshape_fail)(struct sk_buff *skb,
 					struct Qdisc *q);
@@ -70,6 +62,17 @@ struct Qdisc
 	 * and it will live until better solution will be invented.
 	 */
 	struct Qdisc		*__parent;
+	struct netdev_queue	*dev_queue;
+	struct Qdisc		*next_sched;
+
+	struct sk_buff		*gso_skb;
+	/*
+	 * For performance sake on SMP, we put highly modified fields at the end
+	 */
+	unsigned long		state;
+	struct sk_buff_head	q;
+	struct gnet_stats_basic bstats;
+	struct gnet_stats_queue	qstats;
 };
 
 struct Qdisc_class_ops

