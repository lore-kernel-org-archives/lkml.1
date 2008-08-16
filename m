Return-Path: <linux-kernel-owner+w=401wt.eu-S1753284AbYHPKAM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284AbYHPKAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:00:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752452AbYHPJ76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 05:59:58 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:36743 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbYHPJ75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 05:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Q0ZeymuGGC89hZ15PSlr/oys/oHTdxXZsUSqU2l7MxS5jBfFatW6kE1JTHmiwqeD8d
         WhxCx/G3lic63zKjC9+a6D5EpFoeCXWeUv0/Nq82S0nOl2hFcMsDQT6m7jV21vDIA8jE
         wtj415kuiAAlWLBqKT7bg/v+cakjzBXjjaw5w=
Date: Sat, 16 Aug 2008 13:59:51 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: torvalds@osdl.org, akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] De-macro spin_trylock_irq, spin_trylock_irqsave,
	write_trylock_irqsave
Message-ID: <20080816095951.GA19926@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) de-macro, remove ({ usages as side-effect,
2) change calling convention to not accept "flags" by value -- trylock
   functions can modify them, so by-value is misleading, and number of users
   is relatively low.
3) de-macro spin_trylock_irq() for a change.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/infiniband/ulp/ipoib/ipoib_main.c |    2 -
 drivers/net/atl1e/atl1e_main.c            |    2 -
 drivers/net/atlx/atl1.c                   |    2 -
 drivers/net/e1000/e1000_main.c            |    2 -
 drivers/net/e1000e/netdev.c               |    2 -
 drivers/net/gianfar.c                     |    2 -
 drivers/net/s2io.c                        |    4 +-
 drivers/net/spider_net.c                  |    2 -
 drivers/scsi/aacraid/commsup.c            |    4 +-
 drivers/serial/uartlite.c                 |    2 -
 include/linux/spinlock.h                  |   52 ++++++++++++++++++------------
 kernel/ptrace.c                           |    4 +-
 kernel/rcupreempt.c                       |    2 -
 kernel/sched.c                            |    2 -
 security/selinux/avc.c                    |    2 -
 15 files changed, 49 insertions(+), 37 deletions(-)

--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -711,7 +711,7 @@ static int ipoib_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	struct ipoib_neigh *neigh;
 	unsigned long flags;
 
-	if (unlikely(!spin_trylock_irqsave(&priv->tx_lock, flags)))
+	if (unlikely(!spin_trylock_irqsave(&priv->tx_lock, &flags)))
 		return NETDEV_TX_LOCKED;
 
 	if (likely(skb->dst && skb->dst->neighbour)) {
--- a/drivers/net/atl1e/atl1e_main.c
+++ b/drivers/net/atl1e/atl1e_main.c
@@ -1858,7 +1858,7 @@ static int atl1e_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 	tpd_req = atl1e_cal_tdp_req(skb);
-	if (!spin_trylock_irqsave(&adapter->tx_lock, flags))
+	if (!spin_trylock_irqsave(&adapter->tx_lock, &flags))
 		return NETDEV_TX_LOCKED;
 
 	if (atl1e_tpd_avail(adapter) < tpd_req) {
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2399,7 +2399,7 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 		}
 	}
 
-	if (!spin_trylock_irqsave(&adapter->lock, flags)) {
+	if (!spin_trylock_irqsave(&adapter->lock, &flags)) {
 		/* Can't get lock - tell upper layer to requeue */
 		if (netif_msg_tx_queued(adapter))
 			dev_printk(KERN_DEBUG, &adapter->pdev->dev,
--- a/drivers/net/e1000/e1000_main.c
+++ b/drivers/net/e1000/e1000_main.c
@@ -3412,7 +3412,7 @@ static int e1000_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	    (hw->mac_type == e1000_82573))
 		e1000_transfer_dhcp_info(adapter, skb);
 
-	if (!spin_trylock_irqsave(&tx_ring->tx_lock, flags))
+	if (!spin_trylock_irqsave(&tx_ring->tx_lock, &flags))
 		/* Collision - tell upper layer to requeue */
 		return NETDEV_TX_LOCKED;
 
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -3614,7 +3614,7 @@ static int e1000_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
 	if (adapter->hw.mac.tx_pkt_filtering)
 		e1000_transfer_dhcp_info(adapter, skb);
 
-	if (!spin_trylock_irqsave(&adapter->tx_queue_lock, irq_flags))
+	if (!spin_trylock_irqsave(&adapter->tx_queue_lock, &irq_flags))
 		/* Collision - tell upper layer to requeue */
 		return NETDEV_TX_LOCKED;
 
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -1687,7 +1687,7 @@ static int gfar_poll(struct napi_struct *napi, int budget)
 	unsigned long flags;
 
 	/* If we fail to get the lock, don't bother with the TX BDs */
-	if (spin_trylock_irqsave(&priv->txlock, flags)) {
+	if (spin_trylock_irqsave(&priv->txlock, &flags)) {
 		gfar_clean_tx_ring(dev);
 		spin_unlock_irqrestore(&priv->txlock, flags);
 	}
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -3083,7 +3083,7 @@ static void tx_intr_handler(struct fifo_info *fifo_data)
 	unsigned long flags = 0;
 	u8 err_mask;
 
-	if (!spin_trylock_irqsave(&fifo_data->tx_lock, flags))
+	if (!spin_trylock_irqsave(&fifo_data->tx_lock, &flags))
 			return;
 
 	get_info = fifo_data->tx_curr_get_info;
@@ -4166,7 +4166,7 @@ static int s2io_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (do_spin_lock)
 		spin_lock_irqsave(&fifo->tx_lock, flags);
 	else {
-		if (unlikely(!spin_trylock_irqsave(&fifo->tx_lock, flags)))
+		if (unlikely(!spin_trylock_irqsave(&fifo->tx_lock, &flags)))
 			return NETDEV_TX_LOCKED;
 	}
 
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -530,7 +530,7 @@ spider_net_refill_rx_chain(struct spider_net_card *card)
 	 * and omitting it) is ok. If called by NAPI, we'll be called again
 	 * as spider_net_decode_one_descr is called several times. If some
 	 * interrupt calls us, the NAPI is about to clean up anyway. */
-	if (!spin_trylock_irqsave(&chain->lock, flags))
+	if (!spin_trylock_irqsave(&chain->lock, &flags))
 		return;
 
 	while (spider_net_get_descr_status(chain->head->hwdescr) ==
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1278,7 +1278,7 @@ int aac_reset_adapter(struct aac_dev * aac, int forced)
 	int retval;
 	struct Scsi_Host * host;
 
-	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
+	if (spin_trylock_irqsave(&aac->fib_lock, &flagv) == 0)
 		return -EBUSY;
 
 	if (aac->in_reset) {
@@ -1370,7 +1370,7 @@ int aac_check_health(struct aac_dev * aac)
 	struct Scsi_Host * host;
 
 	/* Extending the scope of fib_lock slightly to protect aac->in_reset */
-	if (spin_trylock_irqsave(&aac->fib_lock, flagv) == 0)
+	if (spin_trylock_irqsave(&aac->fib_lock, &flagv) == 0)
 		return 0;
 
 	if (aac->in_reset || !(BlinkLED = aac_adapter_check_health(aac))) {
--- a/drivers/serial/uartlite.c
+++ b/drivers/serial/uartlite.c
@@ -369,7 +369,7 @@ static void ulite_console_write(struct console *co, const char *s,
 	int locked = 1;
 
 	if (oops_in_progress) {
-		locked = spin_trylock_irqsave(&port->lock, flags);
+		locked = spin_trylock_irqsave(&port->lock, &flags);
 	} else
 		spin_lock_irqsave(&port->lock, flags);
 
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -320,26 +320,38 @@ do {						\
 
 #define spin_trylock_bh(lock)	__cond_lock(lock, _spin_trylock_bh(lock))
 
-#define spin_trylock_irq(lock) \
-({ \
-	local_irq_disable(); \
-	spin_trylock(lock) ? \
-	1 : ({ local_irq_enable(); 0;  }); \
-})
-
-#define spin_trylock_irqsave(lock, flags) \
-({ \
-	local_irq_save(flags); \
-	spin_trylock(lock) ? \
-	1 : ({ local_irq_restore(flags); 0; }); \
-})
-
-#define write_trylock_irqsave(lock, flags) \
-({ \
-	local_irq_save(flags); \
-	write_trylock(lock) ? \
-	1 : ({ local_irq_restore(flags); 0; }); \
-})
+static inline int spin_trylock_irq(spinlock_t *lock)
+{
+	local_irq_disable();
+	if (spin_trylock(lock))
+		return 1;
+	else {
+		local_irq_enable();
+		return 0;
+	}
+}
+
+static inline int spin_trylock_irqsave(spinlock_t *lock, unsigned long *flags)
+{
+	local_irq_save(*flags);
+	if (spin_trylock(lock))
+		return 1;
+	else {
+		local_irq_restore(*flags);
+		return 0;
+	}
+}
+
+static inline int write_trylock_irqsave(rwlock_t *lock, unsigned long *flags)
+{
+	local_irq_save(*flags);
+	if (write_trylock(lock))
+		return 1;
+	else {
+		local_irq_restore(*flags);
+		return 0;
+	}
+}
 
 /*
  * Pull the atomic_t declaration:
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -174,7 +174,7 @@ repeat:
 	 * cpu's that may have task_lock).
 	 */
 	task_lock(task);
-	if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+	if (!write_trylock_irqsave(&tasklist_lock, &flags)) {
 		task_unlock(task);
 		do {
 			cpu_relax();
@@ -491,7 +491,7 @@ repeat:
 		 * See ptrace_attach() comments about the locking here.
 		 */
 		unsigned long flags;
-		if (!write_trylock_irqsave(&tasklist_lock, flags)) {
+		if (!write_trylock_irqsave(&tasklist_lock, &flags)) {
 			task_unlock(current);
 			do {
 				cpu_relax();
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -867,7 +867,7 @@ static void rcu_try_flip(void)
 	unsigned long flags;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
-	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, flags))) {
+	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, &flags))) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
 		return;
 	}
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1174,7 +1174,7 @@ static void resched_cpu(int cpu)
 	struct rq *rq = cpu_rq(cpu);
 	unsigned long flags;
 
-	if (!spin_trylock_irqsave(&rq->lock, flags))
+	if (!spin_trylock_irqsave(&rq->lock, &flags))
 		return;
 	resched_task(cpu_curr(cpu));
 	spin_unlock_irqrestore(&rq->lock, flags);
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -309,7 +309,7 @@ static inline int avc_reclaim_node(void)
 	for (try = 0, ecx = 0; try < AVC_CACHE_SLOTS; try++) {
 		hvalue = atomic_inc_return(&avc_cache.lru_hint) & (AVC_CACHE_SLOTS - 1);
 
-		if (!spin_trylock_irqsave(&avc_cache.slots_lock[hvalue], flags))
+		if (!spin_trylock_irqsave(&avc_cache.slots_lock[hvalue], &flags))
 			continue;
 
 		rcu_read_lock();

