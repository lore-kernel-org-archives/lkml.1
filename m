Return-Path: <linux-kernel-owner+w=401wt.eu-S1763186AbXGROoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763186AbXGROoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbXGROoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:44:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:52957 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbXGROoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:44:17 -0400
From: Olaf Kirch <olaf.kirch@ORACLE.COM>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Wed, 18 Jul 2007 16:41:43 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707181404.20458.olaf.kirch@oracle.com> <20070718124856.GB31215@elte.hu>
In-Reply-To: <20070718124856.GB31215@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181641.45338.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 July 2007 14:48, Ingo Molnar wrote:
> something i noticed: netconsole output seems to trickle through though, 
> but very, very slowly (a packet once every 4 seconds or so). TCP/IP is 
> not functional.
> 
> also, i'm using netconsole via the command line (both the network driver 
> and netconsole is built into the bzImage), maybe that makes a 
> difference?

Possibly - but so far there's nothing in the code that jumped at me.

Can you try the following please? I'm still pretty much in the dark;
so I'm adding a bunch of printks. Let's hope this doesn't change the
timing in a way that makes the bug disappear.

Thanks
Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
-----

---
 include/linux/netdevice.h |    4 ++++
 net/core/dev.c            |   14 ++++++++++++++
 2 files changed, 18 insertions(+)

Index: build-2.6/include/linux/netdevice.h
===================================================================
--- build-2.6.orig/include/linux/netdevice.h
+++ build-2.6/include/linux/netdevice.h
@@ -692,6 +692,7 @@ struct softnet_data
 #ifdef CONFIG_NET_DMA
 	struct dma_chan		*net_dma;
 #endif
+	unsigned long		scheduled;
 };
 
 DECLARE_PER_CPU(struct softnet_data,softnet_data);
@@ -1026,6 +1027,9 @@ static inline void netif_rx_complete(str
 	/* Prevent race with netpoll - yes, this is a kludge.
 	 * But at least it doesn't penalize the non-netpoll
 	 * code path. */
+	printk(KERN_DEBUG "netif_rx_complete(%s)%s\n", dev->name,
+			test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state)?
+			" - frozen" : "");
 	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state))
 		return;
 #endif
Index: build-2.6/net/core/dev.c
===================================================================
--- build-2.6.orig/net/core/dev.c
+++ build-2.6/net/core/dev.c
@@ -1192,6 +1192,7 @@ void __netif_rx_schedule(struct net_devi
 {
 	unsigned long flags;
 
+	printk(KERN_DEBUG "__netif_rx_schedule(%s)\n", dev->name);
 	local_irq_save(flags);
 	dev_hold(dev);
 	list_add_tail(&dev->poll_list, &__get_cpu_var(softnet_data).poll_list);
@@ -1199,6 +1200,7 @@ void __netif_rx_schedule(struct net_devi
 		dev->quota += dev->weight;
 	else
 		dev->quota = dev->weight;
+	__get_cpu_var(softnet_data).scheduled = jiffies;
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -2028,6 +2030,9 @@ static void net_rx_action(struct softirq
 
 	local_irq_disable();
 
+	/* Complain if we're scheduled way too late. */
+	WARN_ON(time_after(jiffies, __get_cpu_var(softnet_data).scheduled + HZ));
+
 	while (!list_empty(&queue->poll_list)) {
 		struct net_device *dev;
 
@@ -2038,9 +2043,13 @@ static void net_rx_action(struct softirq
 
 		dev = list_entry(queue->poll_list.next,
 				 struct net_device, poll_list);
+
 		have = netpoll_poll_lock(dev);
 
+		BUG_ON(test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state));
 		if (dev->quota <= 0 || dev->poll(dev, &budget)) {
+			printk(KERN_DEBUG "netif_rx_action(%s) - keep on polling\n",
+					dev->name);
 			netpoll_poll_unlock(have);
 			local_irq_disable();
 			list_move_tail(&dev->poll_list, &queue->poll_list);
@@ -2049,6 +2058,10 @@ static void net_rx_action(struct softirq
 			else
 				dev->quota = dev->weight;
 		} else {
+			printk(KERN_DEBUG "netif_rx_action(%s) - done%s\n",
+					dev->name,
+					test_bit(__LINK_STATE_RX_SCHED, &dev->state)?
+					 "; rx_sched set" : "");
 			netpoll_poll_unlock(have);
 			dev_put(dev);
 			local_irq_disable();
@@ -2074,6 +2087,7 @@ out:
 
 softnet_break:
 	__get_cpu_var(netdev_rx_stat).time_squeeze++;
+	__get_cpu_var(softnet_data).scheduled = jiffies;
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 	goto out;
 }

