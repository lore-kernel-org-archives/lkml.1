Return-Path: <linux-kernel-owner+w=401wt.eu-S1753371AbYGZJTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbYGZJTA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbYGZJSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:18:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36097
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751486AbYGZJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:18:48 -0400
Date: Sat, 26 Jul 2008 02:18:46 -0700 (PDT)
Message-Id: <20080726.021846.236624483.davem@davemloft.net>
To: jarkao2@gmail.com
Cc: johannes@sipsolutions.net, netdev@axxeo.de, peterz@infradead.org,
       Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
 __netif_schedule+0x2c/0x98()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080725200137.GC3107@ami.dom.local>
References: <20080725193416.GB3107@ami.dom.local>
	<1217014575.4758.7.camel@johannes.berg>
	<20080725200137.GC3107@ami.dom.local>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jarek Poplawski <jarkao2@gmail.com>
Date: Fri, 25 Jul 2008 22:01:37 +0200

> On Fri, Jul 25, 2008 at 09:36:15PM +0200, Johannes Berg wrote:
> > On Fri, 2008-07-25 at 21:34 +0200, Jarek Poplawski wrote:
> > 
> > No, we need to be able to lock out multiple TX paths at once.
> 
> IMHO, it can do the same. We could e.g. insert a locked spinlock into
> this noop_tx_handler(), to give everyone some waiting.

I think there might be an easier way, but we may have
to modify the state bits a little.

Every call into ->hard_start_xmit() is made like this:

1. lock TX queue
2. check TX queue stopped
3. call ->hard_start_xmit() if not stopped

This means that we can in fact do something like:

	unsigned int i;

	for (i = 0; i < dev->num_tx_queues; i++) {
		struct netdev_queue *txq;

		txq = netdev_get_tx_queue(dev, i);
		spin_lock_bh(&txq->_xmit_lock);
		netif_tx_freeze_queue(txq);
		spin_unlock_bh(&txq->_xmit_lock);
	}

netif_tx_freeze_queue() just sets a new bit we add.

Then we go to the ->hard_start_xmit() call sites and check this new
"frozen" bit as well as the existing "stopped" bit.

When we unfreeze each queue later, we see if it is stopped, and if not
we schedule it's qdisc for packet processing.

A patch below shows how the guarding would work.  It doesn't implement
the actual freeze/unfreeze.

We need to use a side-state bit to do this because we don't
want this operation to get all mixed up with the queue waking
operations that the driver TX reclaim code will be doing
asynchronously.

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b4d056c..cba98fb 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -440,6 +440,7 @@ static inline void napi_synchronize(const struct napi_struct *n)
 enum netdev_queue_state_t
 {
 	__QUEUE_STATE_XOFF,
+	__QUEUE_STATE_FROZEN,
 };
 
 struct netdev_queue {
@@ -1099,6 +1100,11 @@ static inline int netif_queue_stopped(const struct net_device *dev)
 	return netif_tx_queue_stopped(netdev_get_tx_queue(dev, 0));
 }
 
+static inline int netif_tx_queue_frozen(const struct netdev_queue *dev_queue)
+{
+	return test_bit(__QUEUE_STATE_FROZEN, &dev_queue->state);
+}
+
 /**
  *	netif_running - test if up
  *	@dev: network device
diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index c127208..6c7af39 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -70,6 +70,7 @@ static void queue_process(struct work_struct *work)
 		local_irq_save(flags);
 		__netif_tx_lock(txq, smp_processor_id());
 		if (netif_tx_queue_stopped(txq) ||
+		    netif_tx_queue_frozen(txq) ||
 		    dev->hard_start_xmit(skb, dev) != NETDEV_TX_OK) {
 			skb_queue_head(&npinfo->txq, skb);
 			__netif_tx_unlock(txq);
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index c7d484f..3284605 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -3305,6 +3305,7 @@ static __inline__ void pktgen_xmit(struct pktgen_dev *pkt_dev)
 
 	txq = netdev_get_tx_queue(odev, queue_map);
 	if (netif_tx_queue_stopped(txq) ||
+	    netif_tx_queue_frozen(txq) ||
 	    need_resched()) {
 		idle_start = getCurUs();
 
@@ -3320,7 +3321,8 @@ static __inline__ void pktgen_xmit(struct pktgen_dev *pkt_dev)
 
 		pkt_dev->idle_acc += getCurUs() - idle_start;
 
-		if (netif_tx_queue_stopped(txq)) {
+		if (netif_tx_queue_stopped(txq) ||
+		    netif_tx_queue_frozen(txq)) {
 			pkt_dev->next_tx_us = getCurUs();	/* TODO */
 			pkt_dev->next_tx_ns = 0;
 			goto out;	/* Try the next interface */
@@ -3352,7 +3354,8 @@ static __inline__ void pktgen_xmit(struct pktgen_dev *pkt_dev)
 	txq = netdev_get_tx_queue(odev, queue_map);
 
 	__netif_tx_lock_bh(txq);
-	if (!netif_tx_queue_stopped(txq)) {
+	if (!netif_tx_queue_stopped(txq) &&
+	    !netif_tx_queue_frozen(txq)) {
 
 		atomic_inc(&(pkt_dev->skb->users));
 	      retry_now:
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index fd2a6ca..f17551a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -135,7 +135,8 @@ static inline int qdisc_restart(struct Qdisc *q)
 	txq = netdev_get_tx_queue(dev, skb_get_queue_mapping(skb));
 
 	HARD_TX_LOCK(dev, txq, smp_processor_id());
-	if (!netif_subqueue_stopped(dev, skb))
+	if (!netif_tx_queue_stopped(txq) &&
+	    !netif_tx_queue_frozen(txq))
 		ret = dev_hard_start_xmit(skb, dev, txq);
 	HARD_TX_UNLOCK(dev, txq);
 
@@ -162,7 +163,8 @@ static inline int qdisc_restart(struct Qdisc *q)
 		break;
 	}
 
-	if (ret && netif_tx_queue_stopped(txq))
+	if (ret && (netif_tx_queue_stopped(txq) ||
+		    netif_tx_queue_frozen(txq)))
 		ret = 0;
 
 	return ret;
