Return-Path: <linux-kernel-owner+w=401wt.eu-S1764247AbXHAOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764247AbXHAOVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751008AbXHAOVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:21:31 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:49596 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751286AbXHAOVa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:21:30 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Wed, 1 Aug 2007 10:22:20 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E93142D2@ranchero.sycamorenet.com>
In-Reply-To: <77B279EC7347F341A6AE891AA6AD68E93142D1@ranchero.sycamorenet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: AcfOJxpu1Cfa2CBISKiVNrBca7OklgGHheqgAABqxdA=
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>,
       "Ingo Molnar" <mingo@elte.hu>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 01 Aug 2007 14:22:21.0867 (UTC) FILETIME=[5FD157B0:01C7D447]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sorry..  I sent the wrong patch file.  There was a warning in the other one.



diff -ur linux-2.6.23-rc1-rt0/include/linux/netdevice.h linux-2.6.23-rc1-rt0_new/include/linux/netdevice.h
--- linux-2.6.23-rc1-rt0/include/linux/netdevice.h      2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/include/linux/netdevice.h  2007-08-01 09:10:01.000000000 -0400
@@ -468,7 +468,11 @@
        /* cpu id of processor entered to hard_start_xmit or -1,
           if nobody entered there.
         */
-       int                     xmit_lock_owner;
+#ifdef CONFIG_PREEMPT_RT
+       void *                  xmit_lock_owner;
+#else
+       int                     xmit_lock_owner;
+#endif
        void                    *priv;  /* pointer to private data      */
        int                     (*hard_start_xmit) (struct sk_buff *skb,
                                                    struct net_device *dev);
@@ -1041,32 +1045,54 @@
 static inline void netif_tx_lock(struct net_device *dev)
 {
        spin_lock(&dev->_xmit_lock);
-       dev->xmit_lock_owner = raw_smp_processor_id();
+#ifdef CONFIG_PREEMPT_RT
+       dev->xmit_lock_owner = (void *)current;
+#else
+       dev->xmit_lock_owner = raw_smp_processor_id();
+#endif
 }
 
 static inline void netif_tx_lock_bh(struct net_device *dev)
 {
        spin_lock_bh(&dev->_xmit_lock);
-       dev->xmit_lock_owner = raw_smp_processor_id();
+#ifdef CONFIG_PREEMPT_RT
+       dev->xmit_lock_owner = (void *)current;
+#else
+       dev->xmit_lock_owner = raw_smp_processor_id();
+#endif
 }
 
 static inline int netif_tx_trylock(struct net_device *dev)
 {
        int ok = spin_trylock(&dev->_xmit_lock);
        if (likely(ok))
-               dev->xmit_lock_owner = raw_smp_processor_id();
+       {
+#ifdef CONFIG_PREEMPT_RT
+       dev->xmit_lock_owner = (void *)current;
+#else
+       dev->xmit_lock_owner = raw_smp_processor_id();
+#endif
+    }
        return ok;
 }
 
 static inline void netif_tx_unlock(struct net_device *dev)
 {
+#ifdef CONFIG_PREEMPT_RT
+       dev->xmit_lock_owner = (void *)-1;
+#else
        dev->xmit_lock_owner = -1;
+#endif
        spin_unlock(&dev->_xmit_lock);
 }
 
 static inline void netif_tx_unlock_bh(struct net_device *dev)
 {
+#ifdef CONFIG_PREEMPT_RT
+       dev->xmit_lock_owner = (void *)-1;
+#else
        dev->xmit_lock_owner = -1;
+#endif
        spin_unlock_bh(&dev->_xmit_lock);
 }
 
diff -ur linux-2.6.23-rc1-rt0/net/core/dev.c linux-2.6.23-rc1-rt0_new/net/core/dev.c
--- linux-2.6.23-rc1-rt0/net/core/dev.c 2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/net/core/dev.c     2007-08-01 08:56:02.000000000 -0400
@@ -1592,7 +1592,7 @@
                 * No need to check for recursion with threaded interrupts:
                 */
 #ifdef CONFIG_PREEMPT_RT
-               if (1) {
+               if (dev->xmit_lock_owner != (void *)current) {
 #else
                int cpu = raw_smp_processor_id(); /* ok because BHs are off */
 diff -ur linux-2.6.23-rc1-rt0/net/sched/sch_generic.c linux-2.6.23-rc1-rt0_new/net/sched/sch_generic.c
--- linux-2.6.23-rc1-rt0/net/sched/sch_generic.c        2007-07-24 15:17:07.000000000 -0400
+++ linux-2.6.23-rc1-rt0_new/net/sched/sch_generic.c    2007-08-01 08:57:14.000000000 -0400
@@ -153,7 +153,13 @@
 
        if (!lockless) {
 #ifdef CONFIG_PREEMPT_RT
-               netif_tx_lock(dev);
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
