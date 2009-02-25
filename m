Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbZBYB2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbZBYB2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 20:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZBYB2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 20:28:12 -0500
Received: from mga10.intel.com ([192.55.52.92]:44712 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752782AbZBYB2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 20:28:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,262,1233561600"; 
   d="scan'208";a="433899286"
Subject: [RFC v1] hand off skb list to other cpu to submit to upper layer
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, jesse.brandeburg@intel.com
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2009 09:27:49 +0800
Message-Id: <1235525270.2604.483.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Subject: hand off skb list to other cpu to submit to upper layer
From: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

Recently, I am investigating an ip_forward performance issue with 10G IXGBE NIC.
I start the testing on 2 machines. Every machine has 2 10G NICs. The 1st one seconds
packets by pktgen. The 2nd receives the packets from one NIC and forwards them out
from the 2nd NIC. As NICs supports multi-queue, I bind the queues to different logical
cpu of different physical cpu while considering cache sharing carefully.

Comparing with sending speed on the 1st machine, the forward speed is not good, only
about 60% of sending speed. As a matter of fact, IXGBE driver starts NAPI when interrupt
arrives. When ip_forward=1, receiver collects a packet and forwards it out immediately.
So although IXGBE collects packets with NAPI, the forwarding really has much impact on
collection. As IXGBE runs very fast, it drops packets quickly. The better way for
receiving cpu is doing nothing than just collecting packets.

Currently kernel has backlog to support a similar capability, but process_backlog still
runs on the receiving cpu. I enhance backlog by adding a new input_pkt_alien_queue to
softnet_data. Receving cpu collects packets and link them into skb list, then delivers
the list to the ﻿input_pkt_alien_queue of other cpu. process_backlog picks up the skb list
from ﻿input_pkt_alien_queue when ﻿input_pkt_queue is empty.

NIC driver could use this capability like below step in NAPI RX cleanup function.
1) Initiate a local var struct sk_buff_head skb_head;
2) In the packet collection loop, just calls netif_rx_queue or __skb_queue_tail(skb_head, skb)
to add skb to the list;
3) Before exiting, calls raise_netif_irq to submit the skb list to specific cpu.

Enlarge /proc/sys/net/core/netdev_max_backlog and netdev_budget before testing.

I tested my patch on top of 2.6.28.5. The improvement is about 43%.

Signed-off-by: ﻿Zhang Yanmin <yanmin.zhang@linux.intel.com>

---

--- linux-2.6.29-rc2/include/linux/netdevice.h	2009-01-20 14:20:45.000000000 +0800
+++ linux-2.6.29-rc2_napi_rcv/include/linux/netdevice.h	2009-02-23 13:32:48.000000000 +0800
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
 
@@ -1368,6 +1372,10 @@ extern void dev_kfree_skb_irq(struct sk_
 extern void dev_kfree_skb_any(struct sk_buff *skb);
 
 #define HAVE_NETIF_RX 1
+extern int		netif_rx_queue(struct sk_buff *skb,
+					struct sk_buff_head *skb_queue);
+extern int		raise_netif_irq(int cpu,
+					struct sk_buff_head *skb_queue);
 extern int		netif_rx(struct sk_buff *skb);
 extern int		netif_rx_ni(struct sk_buff *skb);
 #define HAVE_NETIF_RECEIVE_SKB 1
--- linux-2.6.29-rc2/net/core/dev.c	2009-01-20 14:20:45.000000000 +0800
+++ linux-2.6.29-rc2_napi_rcv/net/core/dev.c	2009-02-24 13:53:02.000000000 +0800
@@ -1917,8 +1917,10 @@ DEFINE_PER_CPU(struct netif_rx_stats, ne
 
 
 /**
- *	netif_rx	-	post buffer to the network code
+ *	netif_rx_queue	-	post buffer to the network code
  *	@skb: buffer to post
+ *	@sk_buff_head: the queue to keep skb. It could be NULL or point
+ *		to a local variable.
  *
  *	This function receives a packet from a device driver and queues it for
  *	the upper (protocol) levels to process.  It always succeeds. The buffer
@@ -1931,10 +1933,11 @@ DEFINE_PER_CPU(struct netif_rx_stats, ne
  *
  */
 
-int netif_rx(struct sk_buff *skb)
+int netif_rx_queue(struct sk_buff *skb, struct sk_buff_head *skb_queue)
 {
 	struct softnet_data *queue;
 	unsigned long flags;
+	int this_cpu;
 
 	/* if netpoll wants it, pretend we never saw it */
 	if (netpoll_rx(skb))
@@ -1943,24 +1946,31 @@ int netif_rx(struct sk_buff *skb)
 	if (!skb->tstamp.tv64)
 		net_timestamp(skb);
 
+	if (skb_queue)
+		this_cpu = 0;
+	else
+		this_cpu = 1;
+
 	/*
 	 * The code is rearranged so that the path is the most
 	 * short when CPU is congested, but is still operating.
 	 */
 	local_irq_save(flags);
+
 	queue = &__get_cpu_var(softnet_data);
+	if (!skb_queue)
+		skb_queue = &queue->input_pkt_queue;
 
 	__get_cpu_var(netdev_rx_stat).total++;
-	if (queue->input_pkt_queue.qlen <= netdev_max_backlog) {
-		if (queue->input_pkt_queue.qlen) {
-enqueue:
-			__skb_queue_tail(&queue->input_pkt_queue, skb);
-			local_irq_restore(flags);
-			return NET_RX_SUCCESS;
+
+	if (skb_queue->qlen <= netdev_max_backlog) {
+		if (!skb_queue->qlen && this_cpu) {
+			napi_schedule(&queue->backlog);
 		}
 
-		napi_schedule(&queue->backlog);
-		goto enqueue;
+		__skb_queue_tail(skb_queue, skb);
+		local_irq_restore(flags);
+		return NET_RX_SUCCESS;
 	}
 
 	__get_cpu_var(netdev_rx_stat).dropped++;
@@ -1970,6 +1980,11 @@ enqueue:
 	return NET_RX_DROP;
 }
 
+int netif_rx(struct sk_buff *skb)
+{
+	return netif_rx_queue(skb, NULL);
+}
+
 int netif_rx_ni(struct sk_buff *skb)
 {
 	int err;
@@ -1985,6 +2000,79 @@ int netif_rx_ni(struct sk_buff *skb)
 
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
+static void net_napi_backlog(void *data)
+{
+	struct softnet_data *queue = &__get_cpu_var(softnet_data);
+
+	napi_schedule(&queue->backlog);
+	kfree(data);
+}
+
+int raise_netif_irq(int cpu, struct sk_buff_head *skb_queue)
+{
+	unsigned long flags;
+	struct softnet_data *queue;
+
+	if (skb_queue_empty(skb_queue))
+		return 0;
+
+	if ((unsigned)cpu < nr_cpu_ids &&
+		cpu_online(cpu) &&
+		cpu != smp_processor_id()) {
+
+		struct call_single_data *data;
+
+		queue = &per_cpu(softnet_data, cpu);
+
+		if (queue->input_pkt_alien_queue.qlen > netdev_max_backlog)
+			goto failover;
+
+		data = kmalloc(sizeof(struct call_single_data), GFP_ATOMIC);
+		if (!data)
+			goto failover;
+
+		spin_lock_irqsave(&queue->input_pkt_alien_queue.lock, flags);
+		skb_queue_splice_tail_init(skb_queue,
+				&queue->input_pkt_alien_queue);
+		spin_unlock_irqrestore(&queue->input_pkt_alien_queue.lock,
+					flags);
+
+		data->func = net_napi_backlog;
+		data->info = data;
+		data->flags = 0;
+
+		__smp_call_function_single(cpu, data);
+
+		return 0;
+	}
+
+failover:
+	/* If cpu is offline, we queue skb back to the queue on current cpu*/
+	queue = &__get_cpu_var(softnet_data);
+	if (queue->input_pkt_queue.qlen + skb_queue->qlen <=
+		netdev_max_backlog) {
+		local_irq_save(flags);
+		skb_queue_splice_tail_init(skb_queue, &queue->input_pkt_queue);
+		napi_schedule(&queue->backlog);
+		local_irq_restore(flags);
+	} else {
+		net_drop_skb(skb_queue);
+	}
+
+	return 1;
+}
+
 static void net_tx_action(struct softirq_action *h)
 {
 	struct softnet_data *sd = &__get_cpu_var(softnet_data);
@@ -2324,6 +2412,13 @@ static void flush_backlog(void *arg)
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
@@ -2575,9 +2670,19 @@ static int process_backlog(struct napi_s
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
 
@@ -4966,6 +5071,11 @@ static int dev_cpu_callback(struct notif
 	local_irq_enable();
 
 	/* Process offline CPU's input_pkt_queue */
+	spin_lock(&oldsd->input_pkt_alien_queue.lock);
+	skb_queue_splice_tail_init(&oldsd->input_pkt_alien_queue,
+			&oldsd->input_pkt_queue);
+	spin_unlock(&oldsd->input_pkt_alien_queue.lock);
+
 	while ((skb = __skb_dequeue(&oldsd->input_pkt_queue)))
 		netif_rx(skb);
 
@@ -5165,10 +5275,13 @@ static int __init net_dev_init(void)
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
@@ -5227,7 +5340,9 @@ EXPORT_SYMBOL(netdev_boot_setup_check);
 EXPORT_SYMBOL(netdev_set_master);
 EXPORT_SYMBOL(netdev_state_change);
 EXPORT_SYMBOL(netif_receive_skb);
+EXPORT_SYMBOL(netif_rx_queue);
 EXPORT_SYMBOL(netif_rx);
+EXPORT_SYMBOL(raise_netif_irq);
 EXPORT_SYMBOL(register_gifconf);
 EXPORT_SYMBOL(register_netdevice);
 EXPORT_SYMBOL(register_netdevice_notifier);


