Return-Path: <linux-kernel-owner+w=401wt.eu-S932411AbXGRLje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbXGRLje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbXGRLjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:39:25 -0400
Received: from mx12.go2.pl ([193.17.41.142]:40918 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753865AbXGRLjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:39:24 -0400
Date: Wed, 18 Jul 2007 13:48:20 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: Olaf Kirch <olaf.kirch@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, davem@davemloft.net
Subject: Re: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070718114820.GA1734@ff.dom.local>
References: <20070716091236.GA10718@elte.hu> <200707172006.11664.olaf.kirch@oracle.com> <20070717181857.GA16918@elte.hu> <200707172034.20581.olaf.kirch@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707172034.20581.olaf.kirch@oracle.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is my proposal of a solution based on dev->state flag,
but intended mainly to prevent poll_napi from disturbing
while net_rx_action is running and polling the device.

It doesn't look very nice or clean but I hope it could
guard net_rx_action enough with some room for netpoll too.

I'd be very glad if it could be verified and/or tested.

Regards,
Jarek P.

PS: not tested!

---

diff -Nurp 2.6.22-git9-/include/linux/netdevice.h 2.6.22-git9/include/linux/netdevice.h
--- 2.6.22-git9-/include/linux/netdevice.h	2007-07-18 07:50:56.000000000 +0200
+++ 2.6.22-git9/include/linux/netdevice.h	2007-07-18 13:21:12.000000000 +0200
@@ -262,6 +262,8 @@ enum netdev_state_t
 	__LINK_STATE_LINKWATCH_PENDING,
 	__LINK_STATE_DORMANT,
 	__LINK_STATE_QDISC_RUNNING,
+	/* Set by net_rx_action vs poll_napi */
+	__LINK_STATE_POLL_LIST_FROZEN,
 };
 
 
diff -Nurp 2.6.22-git9-/net/core/dev.c 2.6.22-git9/net/core/dev.c
--- 2.6.22-git9-/net/core/dev.c	2007-07-18 07:50:58.000000000 +0200
+++ 2.6.22-git9/net/core/dev.c	2007-07-18 13:18:23.000000000 +0200
@@ -2025,6 +2025,7 @@ static void net_rx_action(struct softirq
 	unsigned long start_time = jiffies;
 	int budget = netdev_budget;
 	void *have;
+	struct net_device *dev_frozen = NULL;
 
 	local_irq_disable();
 
@@ -2040,15 +2041,35 @@ static void net_rx_action(struct softirq
 				 struct net_device, poll_list);
 		have = netpoll_poll_lock(dev);
 
+#ifdef CONFIG_NETPOLL
+		/* prevent a race with poll_napi() */
+		if (dev_frozen && dev_frozen != dev) {
+                	clear_bit(__LINK_STATE_POLL_LIST_FROZEN,
+						&dev_frozen->state);
+                	set_bit(__LINK_STATE_POLL_LIST_FROZEN,
+							 &dev->state);
+			dev_frozen = dev;
+		} else if (!dev_frozen) {
+                	set_bit(__LINK_STATE_POLL_LIST_FROZEN,
+							 &dev->state);
+			dev_frozen = dev;
+		}
+#endif
 		if (dev->quota <= 0 || dev->poll(dev, &budget)) {
 			netpoll_poll_unlock(have);
 			local_irq_disable();
-			list_move_tail(&dev->poll_list, &queue->poll_list);
+			list_move_tail(&dev->poll_list,
+						 &queue->poll_list);
 			if (dev->quota < 0)
 				dev->quota += dev->weight;
 			else
 				dev->quota = dev->weight;
 		} else {
+#ifdef CONFIG_NETPOLL
+                	clear_bit(__LINK_STATE_POLL_LIST_FROZEN,
+							&dev->state);
+			dev_frozen = NULL;
+#endif
 			netpoll_poll_unlock(have);
 			dev_put(dev);
 			local_irq_disable();
@@ -2056,6 +2077,14 @@ static void net_rx_action(struct softirq
 	}
 out:
 	local_irq_enable();
+#ifdef CONFIG_NETPOLL
+	if (dev_frozen) {
+		have = netpoll_poll_lock(dev_frozen);
+		clear_bit(__LINK_STATE_POLL_LIST_FROZEN,
+						&dev_frozen->state);
+		netpoll_poll_unlock(have);
+	}
+#endif
 #ifdef CONFIG_NET_DMA
 	/*
 	 * There may not be any more sk_buffs coming right now, so push
diff -Nurp 2.6.22-git9-/net/core/netpoll.c 2.6.22-git9/net/core/netpoll.c
--- 2.6.22-git9-/net/core/netpoll.c	2007-07-18 07:50:58.000000000 +0200
+++ 2.6.22-git9/net/core/netpoll.c	2007-07-18 12:09:43.000000000 +0200
@@ -124,13 +124,20 @@ static void poll_napi(struct netpoll *np
 	if (test_bit(__LINK_STATE_RX_SCHED, &np->dev->state) &&
 	    npinfo->poll_owner != smp_processor_id() &&
 	    spin_trylock(&npinfo->poll_lock)) {
-		npinfo->rx_flags |= NETPOLL_RX_DROP;
-		atomic_inc(&trapped);
+		/*
+		 * If POLL_LIST_FROZEN is set net_rx_action
+		 * is working with this device.
+		 */
+		if (!test_bit(__LINK_STATE_POLL_LIST_FROZEN,
+						 &np->dev->state)) {
+			npinfo->rx_flags |= NETPOLL_RX_DROP;
+			atomic_inc(&trapped);
 
-		np->dev->poll(np->dev, &budget);
+			np->dev->poll(np->dev, &budget);
 
-		atomic_dec(&trapped);
-		npinfo->rx_flags &= ~NETPOLL_RX_DROP;
+			atomic_dec(&trapped);
+			npinfo->rx_flags &= ~NETPOLL_RX_DROP;
+		}
 		spin_unlock(&npinfo->poll_lock);
 	}
 }
