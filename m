Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbYACD5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbYACD5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 22:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbYACD5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 22:57:35 -0500
Received: from eastrmpop107.cox.net ([68.230.240.49]:54148 "EHLO
	eastrmpop107.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbYACD5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 22:57:35 -0500
Subject: FW: [PATCH -rt] Preemption problem in kernel RT Patch
From: mbeauch <mbeauch@cox.net>
Reply-To: mbeauch@cox.net
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de
Content-Type: text/plain
Date: Wed, 02 Jan 2008 22:56:24 -0500
Message-Id: <1199332584.6276.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's the updated patch:

Changed the real-time patch code to detect recursive calls 
to dev_queue_xmit and drop the packet when detected. 


Signed-off-by: Mark Beauchemin <mark.beauchemin@sycamorenet.com> 

diff -ru linux-2.6.24-rc5-rt1/include/linux/netdevice.h linux-2.6.24-rc5-rt1-mark/include/linux/netdevice.h
--- linux-2.6.24-rc5-rt1/include/linux/netdevice.h	2007-12-28 09:34:02.000000000 -0500
+++ linux-2.6.24-rc5-rt1-mark/include/linux/netdevice.h	2008-01-01 18:49:49.000000000 -0500
@@ -619,7 +619,7 @@
 	/* cpu id of processor entered to hard_start_xmit or -1,
 	   if nobody entered there.
 	 */
-	int			xmit_lock_owner;
+	void			*xmit_lock_owner;
 	void			*priv;	/* pointer to private data	*/
 	int			(*hard_start_xmit) (struct sk_buff *skb,
 						    struct net_device *dev);
@@ -1333,46 +1333,46 @@
  *
  * Get network device transmit lock
  */
-static inline void __netif_tx_lock(struct net_device *dev, int cpu)
+static inline void __netif_tx_lock(struct net_device *dev)
 {
 	spin_lock(&dev->_xmit_lock);
-	dev->xmit_lock_owner = cpu;
+	dev->xmit_lock_owner = (void *)current;
 }
 
 static inline void netif_tx_lock(struct net_device *dev)
 {
-	__netif_tx_lock(dev, raw_smp_processor_id());
+	__netif_tx_lock(dev);
 }
 
 static inline void netif_tx_lock_bh(struct net_device *dev)
 {
 	spin_lock_bh(&dev->_xmit_lock);
-	dev->xmit_lock_owner = raw_smp_processor_id();
+	dev->xmit_lock_owner = (void *)current;
 }
 
 static inline int netif_tx_trylock(struct net_device *dev)
 {
 	int ok = spin_trylock(&dev->_xmit_lock);
 	if (likely(ok))
-		dev->xmit_lock_owner = raw_smp_processor_id();
+		dev->xmit_lock_owner = (void *)current;
 	return ok;
 }
 
 static inline void netif_tx_unlock(struct net_device *dev)
 {
-	dev->xmit_lock_owner = -1;
+	dev->xmit_lock_owner = (void *)-1;
 	spin_unlock(&dev->_xmit_lock);
 }
 
 static inline void netif_tx_unlock_bh(struct net_device *dev)
 {
-	dev->xmit_lock_owner = -1;
+	dev->xmit_lock_owner = (void *)-1;
 	spin_unlock_bh(&dev->_xmit_lock);
 }
 
-#define HARD_TX_LOCK(dev, cpu) {			\
+#define HARD_TX_LOCK(dev) {			\
 	if ((dev->features & NETIF_F_LLTX) == 0) {	\
-		__netif_tx_lock(dev, cpu);			\
+		__netif_tx_lock(dev);			\
 	}						\
 }
 
diff -ru linux-2.6.24-rc5-rt1/net/core/dev.c linux-2.6.24-rc5-rt1-mark/net/core/dev.c
--- linux-2.6.24-rc5-rt1/net/core/dev.c	2007-12-28 09:34:01.000000000 -0500
+++ linux-2.6.24-rc5-rt1-mark/net/core/dev.c	2008-01-01 18:48:33.000000000 -0500
@@ -1692,18 +1692,10 @@
 	   Either shot noqueue qdisc, it is even simpler 8)
 	 */
 	if (dev->flags & IFF_UP) {
-		int cpu = raw_smp_processor_id(); /* ok because BHs are off */
 
-		/*
-		 * No need to check for recursion with threaded interrupts:
-		 */
-#ifdef CONFIG_PREEMPT_RT
-		if (1) {
-#else
-		if (dev->xmit_lock_owner != cpu) {
-#endif
+		if (dev->xmit_lock_owner != (void *)current) {
 
-			HARD_TX_LOCK(dev, cpu);
+			HARD_TX_LOCK(dev);
 
 			if (!netif_queue_stopped(dev) &&
 			    !netif_subqueue_stopped(dev, skb)) {
@@ -3630,7 +3622,7 @@
 	spin_lock_init(&dev->queue_lock);
 	spin_lock_init(&dev->_xmit_lock);
 	netdev_set_lockdep_class(&dev->_xmit_lock, dev->type);
-	dev->xmit_lock_owner = -1;
+	dev->xmit_lock_owner = (void *)-1;
 	spin_lock_init(&dev->ingress_lock);
 
 	dev->iflink = -1;
diff -ru linux-2.6.24-rc5-rt1/net/sched/sch_generic.c linux-2.6.24-rc5-rt1-mark/net/sched/sch_generic.c
--- linux-2.6.24-rc5-rt1/net/sched/sch_generic.c	2007-12-28 09:34:02.000000000 -0500
+++ linux-2.6.24-rc5-rt1-mark/net/sched/sch_generic.c	2008-01-01 18:52:33.000000000 -0500
@@ -89,7 +89,7 @@
 {
 	int ret;
 
-	if (unlikely(dev->xmit_lock_owner == raw_smp_processor_id())) {
+	if (unlikely(dev->xmit_lock_owner == (void *)current)) {
 		/*
 		 * Same CPU holding the lock. It may be a transient
 		 * configuration error, when hard_start_xmit() recurses. We
@@ -146,7 +146,7 @@
 	/* And release queue */
 	spin_unlock(&dev->queue_lock);
 
-	HARD_TX_LOCK(dev, raw_smp_processor_id());
+	HARD_TX_LOCK(dev);
 	if (!netif_subqueue_stopped(dev, skb))
 		ret = dev_hard_start_xmit(skb, dev);
 	HARD_TX_UNLOCK(dev);


