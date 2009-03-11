Return-Path: <linux-kernel-owner+w=401wt.eu-S1754749AbZCKIyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749AbZCKIyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 04:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbZCKIyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 04:54:17 -0400
Received: from mga05.intel.com ([192.55.52.89]:60823 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752174AbZCKIyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 04:54:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,341,1233561600"; 
   d="scan'208";a="672027516"
Subject: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to submit
	to upper layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: herbert@gondor.apana.org.au, jesse.brandeburg@intel.com,
       shemminger@vyatta.com, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 11 Mar 2009 16:53:44 +0800
Message-Id: <1236761624.2567.442.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got some comments. Special thanks to ﻿Stephen Hemminger for teaching me on
what reorder is and some other comments. Also thank other guys who raised comments.

v2 has some improvements.
1) Add new sysfs interface /sys/class/net/ethXXX/rx_queueXXX/processing_cpu. Admin
could use it to configure the binding between RX and cpu number. So it's convenient
for drivers to use the new capability.
2) Delete function netif_rx_queue;
3) Optimize ipi notification. There is no new notification when destination's
input_pkt_alien_queue isn't empty.
4) Did lots of testing, mostly focusing on slab allocator (slab/slub/slqb) and use
SLUB with big slub_max_order currently.

---

﻿﻿Subject: net: hand off skb list to other cpu to submit to upper layer
From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

﻿Recently, I am investigating an ip_forward performance issue with 10G IXGBE NIC.
I start the testing on 2 machines. Every machine has 2 10G NICs. The 1st one seconds
packets by pktgen. The 2nd receives the packets from one NIC and forwards them out
from the 2nd NIC. 

Initial testing showed cpu cache sharing has impact on speed. As NICs supports
multi-queue, I bind the queues to different logical cpu of different physical cpu
while considering cache sharing carefully. I could get about 30~40% improvement;

Comparing with sending speed on the 1st machine, the forward speed is still not good,
only about 60% of sending speed. As a matter of fact, IXGBE driver starts NAPI when
interrupt arrives. When ip_forward=1, receiver collects a packet and forwards it out
immediately. So although IXGBE collects packets with NAPI, the forwarding really has
much impact on collection. As IXGBE runs very fast, it drops packets quickly. The better
way for receiving cpu is doing nothing than just collecting packets.

Currently kernel has backlog to support a similar capability, but process_backlog still
runs on the receiving cpu. I enhance backlog by adding a new input_pkt_alien_queue to
softnet_data. Receving cpu collects packets and link them into skb list, then delivers
the list to the ﻿input_pkt_alien_queue of other cpu. process_backlog picks up the skb list
from ﻿input_pkt_alien_queue when ﻿input_pkt_queue is empty.

﻿
I tested my patch on top of 2.6.28.5. The improvement is about 43%.

Some questions:

1) Reorder: My method wouldn't introduce reorder issue, because we use N:1 mapping between
RX queue and cpu number.
2) If there is no free cpu to work on packet collection: It depends on cpu resource
allocation. We could allocate more RX queue to the same cpu. With my new testing, the
forwarding speed could be at about 4.8M pps (packets per second and packet size is 60Byte)
on Nehalem machine, and 8 packet processing cpus almost have no idle time while receiving cpu
idle is about 50%. I just have 4 old NIC and couldn't test more on this question.
3) packet delaying: I didn't calculate it or measure it and might measure it later. The
forwarding speed is close to 270M bytes/s. At least sar shows mostly receiving matches
forwarding. But at sending side, the sending speed is bigger than forwarding speed, although
my method decreases the difference largely.
4) 10G NICs other than IXGBE: I have no other 10G NICs now.
5) Other kinds of machines working as forwarder: I test it between 1 2*4 stoakley and
2*4*2 Nehalem. I reversed the testing and found the improvement on stoakley is less than 30%,
not so big as on Nehalem.
﻿6) Memory utilization: ﻿My nehalem machine has 12GB memory. To reach the maximum speed,
I tried netdev_max_backlog=400000. That consumes 10GB memory sometimes.
7) Any impact if driver enables the new capability but admin doesn't configure it: I didn't
measure the speed difference now.
8) If receiving cpu collects packets very fast and processing cpu is slow: We can start many
RX queues on the receiving cpu and bind them to different processing cpu.


Current patch is against 2.6.29-rc7.

Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.29-rc7/include/linux/netdevice.h	2009-03-09 15:20:49.000000000 +0800
+++ linux-2.6.29-rc7_backlog/include/linux/netdevice.h	2009-03-11 10:17:08.000000000 +0800
@@ -1119,6 +1119,9 @@ static inline int unregister_gifconf(uns
 /*
  * Incoming packets are placed on per-cpu queues so that
  * no locking is needed.
+ * To speed up fast network, sometimes place incoming packets
+ * to other cpu queues. Use input_pkt_alien_queue.lock to
+ * protect input_pkt_alien_queue.
  */
 struct softnet_data
 {
@@ -1127,6 +1130,7 @@ struct softnet_data
 	struct list_head	poll_list;
 	struct sk_buff		*completion_queue;
 
+	struct sk_buff_head	input_pkt_alien_queue;
 	struct napi_struct	backlog;
 };
 
@@ -1368,6 +1372,8 @@ extern void dev_kfree_skb_irq(struct sk_
 extern void dev_kfree_skb_any(struct sk_buff *skb);
 
 #define HAVE_NETIF_RX 1
+extern int		raise_netif_irq(int cpu,
+					struct sk_buff_head *skb_queue);
 extern int		netif_rx(struct sk_buff *skb);
 extern int		netif_rx_ni(struct sk_buff *skb);
 #define HAVE_NETIF_RECEIVE_SKB 1
--- linux-2.6.29-rc7/net/core/dev.c	2009-03-09 15:20:50.000000000 +0800
+++ linux-2.6.29-rc7_backlog/net/core/dev.c	2009-03-11 10:27:57.000000000 +0800
@@ -1997,6 +1997,114 @@ int netif_rx_ni(struct sk_buff *skb)
 
 EXPORT_SYMBOL(netif_rx_ni);
 
+static void net_drop_skb(struct sk_buff_head *skb_queue)
+{
+	struct sk_buff *skb = __skb_dequeue(skb_queue);
+
+	while (skb) {
+		__get_cpu_var(netdev_rx_stat).dropped++;
+		kfree_skb(skb);
+		skb = __skb_dequeue(skb_queue);
+	}
+}
+
+static int net_backlog_local_merge(struct sk_buff_head *skb_queue)
+{
+	struct softnet_data *queue;
+	unsigned long flags;
+
+	queue = &__get_cpu_var(softnet_data);
+	if (queue->input_pkt_queue.qlen + skb_queue->qlen <=
+		netdev_max_backlog) {
+
+		local_irq_save(flags);
+		if (!queue->input_pkt_queue.qlen)
+			napi_schedule(&queue->backlog);
+		skb_queue_splice_tail_init(skb_queue, &queue->input_pkt_queue);
+		local_irq_restore(flags);
+
+		return  0;
+	} else {
+		net_drop_skb(skb_queue);
+		return 1;
+	}
+}
+
+static void net_napi_backlog(void *data)
+{
+	struct softnet_data *queue = &__get_cpu_var(softnet_data);
+
+	napi_schedule(&queue->backlog);
+	kfree(data);
+}
+
+static int net_backlog_notify_cpu(int cpu)
+{
+	struct call_single_data *data;
+
+	data = kmalloc(sizeof(struct call_single_data), GFP_ATOMIC);
+	if (!data)
+		return -1;
+
+	data->func = net_napi_backlog;
+	data->info = data;
+	data->flags = 0;
+	__smp_call_function_single(cpu, data);
+
+	return 0;
+}
+
+int raise_netif_irq(int cpu, struct sk_buff_head *skb_queue)
+{
+	unsigned long flags;
+	struct softnet_data *queue;
+	int retval, need_notify=0;
+
+	if (!skb_queue || skb_queue_empty(skb_queue))
+		return 0;
+
+	/*
+	 * If cpu is offline, we queue skb back to
+	 * the queue on current cpu.
+	 */
+	if ((unsigned)cpu >= nr_cpu_ids ||
+		!cpu_online(cpu) ||
+		cpu == smp_processor_id()) {
+		net_backlog_local_merge(skb_queue);
+		return 0;
+	}
+
+	queue = &per_cpu(softnet_data, cpu);
+	if (queue->input_pkt_alien_queue.qlen > netdev_max_backlog)
+		goto failed1;
+
+	spin_lock_irqsave(&queue->input_pkt_alien_queue.lock, flags);
+	if (skb_queue_empty(&queue->input_pkt_alien_queue))
+		need_notify = 1;
+	skb_queue_splice_tail_init(skb_queue,
+			&queue->input_pkt_alien_queue);
+	spin_unlock_irqrestore(&queue->input_pkt_alien_queue.lock,
+			flags);
+
+	if (need_notify) {
+		retval = net_backlog_notify_cpu(cpu);
+		if (unlikely(retval))
+			goto failed2;
+	}
+
+	return 0;
+
+failed2:
+	spin_lock_irqsave(&queue->input_pkt_alien_queue.lock, flags);
+	skb_queue_splice_tail_init(&queue->input_pkt_alien_queue, skb_queue);
+	spin_unlock_irqrestore(&queue->input_pkt_alien_queue.lock,
+			flags);
+failed1:
+	net_drop_skb(skb_queue);
+
+	return 1;
+}
+
 static void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = &__get_cpu_var(softnet_data);
@@ -2336,6 +2444,13 @@ static void flush_backlog(void *arg)
 	struct net_device *dev = arg;
 	struct softnet_data *queue = &__get_cpu_var(softnet_data);
 	struct sk_buff *skb, *tmp;
+	unsigned long flags;
+
+	spin_lock_irqsave(&queue->input_pkt_alien_queue.lock, flags);
+	skb_queue_splice_tail_init(
+			&queue->input_pkt_alien_queue,
+			&queue->input_pkt_queue );
+	spin_unlock_irqrestore(&queue->input_pkt_alien_queue.lock, flags);
 
 	skb_queue_walk_safe(&queue->input_pkt_queue, skb, tmp)
 		if (skb->dev == dev) {
@@ -2594,9 +2709,19 @@ static int process_backlog(struct napi_s
 		local_irq_disable();
 		skb = __skb_dequeue(&queue->input_pkt_queue);
 		if (!skb) {
-			__napi_complete(napi);
-			local_irq_enable();
-			break;
+			if (!skb_queue_empty(&queue->input_pkt_alien_queue)) {
+				spin_lock(&queue->input_pkt_alien_queue.lock);
+				skb_queue_splice_tail_init(
+						&queue->input_pkt_alien_queue,
+						&queue->input_pkt_queue );
+				spin_unlock(&queue->input_pkt_alien_queue.lock);
+
+				skb = __skb_dequeue(&queue->input_pkt_queue);
+			} else {
+				__napi_complete(napi);
+				local_irq_enable();
+				break;
+			}
 		}
 		local_irq_enable();
 
@@ -4985,6 +5110,11 @@ static int dev_cpu_callback(struct notif
 	local_irq_enable();
 
 	/* Process offline CPU's input_pkt_queue */
+	spin_lock(&oldsd->input_pkt_alien_queue.lock);
+	skb_queue_splice_tail_init(&oldsd->input_pkt_alien_queue,
+			&oldsd->input_pkt_queue);
+	spin_unlock(&oldsd->input_pkt_alien_queue.lock);
+
 	while ((skb = __skb_dequeue(&oldsd->input_pkt_queue)))
 		netif_rx(skb);
 
@@ -5184,10 +5314,13 @@ static int __init net_dev_init(void)
 		struct softnet_data *queue;
 
 		queue = &per_cpu(softnet_data, i);
+
 		skb_queue_head_init(&queue->input_pkt_queue);
 		queue->completion_queue = NULL;
 		INIT_LIST_HEAD(&queue->poll_list);
 
+		skb_queue_head_init(&queue->input_pkt_alien_queue);
+
 		queue->backlog.poll = process_backlog;
 		queue->backlog.weight = weight_p;
 		queue->backlog.gro_list = NULL;
@@ -5247,6 +5380,7 @@ EXPORT_SYMBOL(netdev_set_master);
 EXPORT_SYMBOL(netdev_state_change);
 EXPORT_SYMBOL(netif_receive_skb);
 EXPORT_SYMBOL(netif_rx);
+EXPORT_SYMBOL(raise_netif_irq);
 EXPORT_SYMBOL(register_gifconf);
 EXPORT_SYMBOL(register_netdevice);
 EXPORT_SYMBOL(register_netdevice_notifier);


