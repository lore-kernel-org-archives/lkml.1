Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbXHGTlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbXHGTlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 15:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754558AbXHGTkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 15:40:51 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:8119 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932239AbXHGTkt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 15:40:49 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Tue, 7 Aug 2007 15:41:40 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E93142E4@ranchero.sycamorenet.com>
In-Reply-To: <20070806071345.GD5359@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: AcfX+XleASU3upzMSLuzv4pVhx1e/wBLQRiw
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 07 Aug 2007 19:41:41.0634 (UTC) FILETIME=[FA684620:01C7D92A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



> could you please change this to use 'current' (instead of the CPU 
> number) as the xmit_lock_owner unconditionally? That results in much 
> fewer #ifdefs and far cleaner code.
> 
> 	Ingo

Ingo,

	Here's the new patch.  Please check me on the non-rt portion.  
I think the check is still functionally the same.  

Thanks,
	Mark  


diff -ur linux-2.6.23-rc1-rt0/include/linux/netdevice.h linux-2.6.23-rc1-rt0_new/include/linux/netdevice.h
--- linux-2.6.23-rc1-rt0/include/linux/netdevice.h	2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/include/linux/netdevice.h	2007-08-06 09:26:51.000000000 -0400
@@ -468,7 +468,7 @@
 	/* cpu id of processor entered to hard_start_xmit or -1,
 	   if nobody entered there.
 	 */
-	int			xmit_lock_owner;
+	void *			xmit_lock_owner;
 	void			*priv;	/* pointer to private data	*/
 	int			(*hard_start_xmit) (struct sk_buff *skb,
 						    struct net_device *dev);
@@ -1041,32 +1041,34 @@
 static inline void netif_tx_lock(struct net_device *dev)
 {
 	spin_lock(&dev->_xmit_lock);
-	dev->xmit_lock_owner = raw_smp_processor_id();
+ 	dev->xmit_lock_owner = (void *)current;
 }
 
 static inline void netif_tx_lock_bh(struct net_device *dev)
 {
 	spin_lock_bh(&dev->_xmit_lock);
-	dev->xmit_lock_owner = raw_smp_processor_id();
+ 	dev->xmit_lock_owner = (void *)current;
 }
 
 static inline int netif_tx_trylock(struct net_device *dev)
 {
 	int ok = spin_trylock(&dev->_xmit_lock);
 	if (likely(ok))
-		dev->xmit_lock_owner = raw_smp_processor_id();
+	{
+     	dev->xmit_lock_owner = (void *)current;
+    }
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
 
diff -ur linux-2.6.23-rc1-rt0/net/core/dev.c linux-2.6.23-rc1-rt0_new/net/core/dev.c
--- linux-2.6.23-rc1-rt0/net/core/dev.c	2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/net/core/dev.c	2007-08-07 15:22:31.000000000 -0400
@@ -1588,16 +1588,7 @@
 	   Either shot noqueue qdisc, it is even simpler 8)
 	 */
 	if (dev->flags & IFF_UP) {
-		/*
-		 * No need to check for recursion with threaded interrupts:
-		 */
-#ifdef CONFIG_PREEMPT_RT
-		if (1) {
-#else
-		int cpu = raw_smp_processor_id(); /* ok because BHs are off */
-
-		if (dev->xmit_lock_owner != cpu) {
-#endif
+		if (dev->xmit_lock_owner != (void *)current) {
 			HARD_TX_LOCK(dev);
 
 			if (!netif_queue_stopped(dev) &&
@@ -3349,7 +3340,7 @@
 	spin_lock_init(&dev->queue_lock);
 	spin_lock_init(&dev->_xmit_lock);
 	netdev_set_lockdep_class(&dev->_xmit_lock, dev->type);
-	dev->xmit_lock_owner = -1;
+	dev->xmit_lock_owner = (void *)-1;
 	spin_lock_init(&dev->ingress_lock);
 
 	dev->iflink = -1;
diff -ur linux-2.6.23-rc1-rt0/net/mac80211/ieee80211.c linux-2.6.23-rc1-rt0_new/net/mac80211/ieee80211.c
--- linux-2.6.23-rc1-rt0/net/mac80211/ieee80211.c	2007-07-24 15:15:57.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/net/mac80211/ieee80211.c	2007-08-07 15:21:28.000000000 -0400
@@ -2413,7 +2413,7 @@
 static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
 {
 	spin_lock_nested(&dev->_xmit_lock, subclass);
-	dev->xmit_lock_owner = smp_processor_id();
+	dev->xmit_lock_owner = (void *)current;
 }
 
 static void ieee80211_set_multicast_list(struct net_device *dev)
diff -ur linux-2.6.23-rc1-rt0/net/sched/sch_generic.c linux-2.6.23-rc1-rt0_new/net/sched/sch_generic.c
--- linux-2.6.23-rc1-rt0/net/sched/sch_generic.c	2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/net/sched/sch_generic.c	2007-08-07 15:20:10.000000000 -0400
@@ -88,7 +88,7 @@
 {
 	int ret;
 
-	if (unlikely(dev->xmit_lock_owner == smp_processor_id())) {
+	if (unlikely(dev->xmit_lock_owner == (void *)current)) {
 		/*
 		 * Same CPU holding the lock. It may be a transient
 		 * configuration error, when hard_start_xmit() recurses. We
@@ -153,7 +153,13 @@
 
 	if (!lockless) {
 #ifdef CONFIG_PREEMPT_RT
-		netif_tx_lock(dev);
+        if (dev->xmit_lock_owner == (void *)current) {
+            kfree_skb(skb);
+            if (net_ratelimit())
+                printk(KERN_DEBUG "Dead loop on netdevice %s, fix it urgently!\n", dev->name);
+            return -1;
+        }
+        netif_tx_lock(dev);
 #else
 		if (netif_tx_trylock(dev))
 			/* Another CPU grabbed the driver tx lock */



