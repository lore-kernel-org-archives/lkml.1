Return-Path: <linux-kernel-owner+w=401wt.eu-S1759923AbXGRMJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759923AbXGRMJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 08:09:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756370AbXGRMJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 08:09:20 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:11087 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904AbXGRMJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 08:09:19 -0400
From: Olaf Kirch <olaf.kirch@oracle.com>
Organization: Oracle
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Date: Wed, 18 Jul 2007 14:04:19 +0200
User-Agent: KMail/1.9.1
Cc: Jarek Poplawski <jarkao2@o2.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
References: <20070716091236.GA10718@elte.hu> <200707172034.20581.olaf.kirch@oracle.com> <20070717185602.GA25271@elte.hu>
In-Reply-To: <20070717185602.GA25271@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707181404.20458.olaf.kirch@oracle.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 20:56, Ingo Molnar wrote:
> i logged these not via netconsole but via logging on over the console 
> and using dmesg, so it should include everything. in the 100hz case the 
> following seems to show the anomaly:
> 
>   NETDEV WATCHDOG: eth0: transmit timed out

So, it seems as if for some reason, dev->poll isn't called frequently
enough.

Here's a debugging patch that tries to locate the problem - can you give it
a try, please?

Olaf
-- 
Olaf Kirch  |  --- o --- Nous sommes du soleil we love when we play
okir@lst.de |    / | \   sol.dhoop.naytheet.ah kin.ir.samse.qurax
--------
patching file drivers/net/e1000/e1000_main.c
---
 include/linux/netdevice.h |    1 +
 net/core/dev.c            |    7 +++++++
 net/core/netpoll.c        |    2 ++
 3 files changed, 10 insertions(+)

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
Index: build-2.6/net/core/dev.c
===================================================================
--- build-2.6.orig/net/core/dev.c
+++ build-2.6/net/core/dev.c
@@ -1199,6 +1199,7 @@ void __netif_rx_schedule(struct net_devi
 		dev->quota += dev->weight;
 	else
 		dev->quota = dev->weight;
+	__get_cpu_var(softnet_data).scheduled = jiffies;
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 	local_irq_restore(flags);
 }
@@ -2028,6 +2029,9 @@ static void net_rx_action(struct softirq
 
 	local_irq_disable();
 
+	/* Complain if we're scheduled way too late. */
+	WARN_ON(time_after(jiffies, __get_cpu_var(softnet_data).scheduled + HZ));
+
 	while (!list_empty(&queue->poll_list)) {
 		struct net_device *dev;
 
@@ -2038,8 +2042,10 @@ static void net_rx_action(struct softirq
 
 		dev = list_entry(queue->poll_list.next,
 				 struct net_device, poll_list);
+
 		have = netpoll_poll_lock(dev);
 
+		BUG_ON(test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state));
 		if (dev->quota <= 0 || dev->poll(dev, &budget)) {
 			netpoll_poll_unlock(have);
 			local_irq_disable();
@@ -2074,6 +2080,7 @@ out:
 
 softnet_break:
 	__get_cpu_var(netdev_rx_stat).time_squeeze++;
+	__get_cpu_var(softnet_data).scheduled = jiffies;
 	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 	goto out;
 }
Index: build-2.6/net/core/netpoll.c
===================================================================
--- build-2.6.orig/net/core/netpoll.c
+++ build-2.6/net/core/netpoll.c
@@ -130,6 +130,7 @@ static void poll_napi(struct netpoll *np
 		 * Setting POLL_LIST_FROZEN tells netif_rx_complete
 		 * to leave the NAPI state alone.
 		 */
+		local_bh_disable();
 		set_bit(__LINK_STATE_POLL_LIST_FROZEN, &np->dev->state);
 		npinfo->rx_flags |= NETPOLL_RX_DROP;
 		atomic_inc(&trapped);
@@ -140,6 +141,7 @@ static void poll_napi(struct netpoll *np
 		npinfo->rx_flags &= ~NETPOLL_RX_DROP;
 		clear_bit(__LINK_STATE_POLL_LIST_FROZEN, &np->dev->state);
 		spin_unlock(&npinfo->poll_lock);
+		local_bh_enable();
 	}
 }
 

