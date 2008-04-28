Return-Path: <linux-kernel-owner+w=401wt.eu-S936320AbYD1STy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936320AbYD1STy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934868AbYD1ST1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:19:27 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:4390 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933231AbYD1STY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:19:24 -0400
Message-Id: <20080428181445.546732331@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 28 Apr 2008 11:14:45 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: gprocida@madge.com, mingo@elte.hu, matthew@wil.cx, chas@cmf.nrl.navy.mil,
       linux-kernel@vger.kernel.org
Subject: [PATCH] atm: ambassador: vcc_sf semaphore to mutex
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/atm/ambassador.c |   19 ++++++++++---------
 drivers/atm/ambassador.h |    2 +-
 2 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6.23/drivers/atm/ambassador.c
===================================================================
--- linux-2.6.23.orig/drivers/atm/ambassador.c
+++ linux-2.6.23/drivers/atm/ambassador.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/poison.h>
 #include <linux/bitrev.h>
+#include <linux/mutex.h>
 
 #include <asm/atomic.h>
 #include <asm/io.h>
@@ -1177,7 +1178,7 @@ static int amb_open (struct atm_vcc * at
     
     vcc->tx_frame_bits = tx_frame_bits;
     
-    down (&dev->vcc_sf);
+    mutex_lock(&dev->vcc_sf);
     if (dev->rxer[vci]) {
       // RXer on the channel already, just modify rate...
       cmd.request = cpu_to_be32 (SRB_MODIFY_VC_RATE);
@@ -1203,7 +1204,7 @@ static int amb_open (struct atm_vcc * at
 	schedule();
     }
     dev->txer[vci].tx_present = 1;
-    up (&dev->vcc_sf);
+    mutex_unlock(&dev->vcc_sf);
   }
   
   if (rxtp->traffic_class != ATM_NONE) {
@@ -1211,7 +1212,7 @@ static int amb_open (struct atm_vcc * at
     
     vcc->rx_info.pool = pool;
     
-    down (&dev->vcc_sf); 
+    mutex_lock(&dev->vcc_sf);
     /* grow RX buffer pool */
     if (!dev->rxq[pool].buffers_wanted)
       dev->rxq[pool].buffers_wanted = rx_lats;
@@ -1237,7 +1238,7 @@ static int amb_open (struct atm_vcc * at
       schedule();
     // this link allows RX frames through
     dev->rxer[vci] = atm_vcc;
-    up (&dev->vcc_sf);
+    mutex_unlock(&dev->vcc_sf);
   }
   
   // indicate readiness
@@ -1262,7 +1263,7 @@ static void amb_close (struct atm_vcc * 
   if (atm_vcc->qos.txtp.traffic_class != ATM_NONE) {
     command cmd;
     
-    down (&dev->vcc_sf);
+    mutex_lock(&dev->vcc_sf);
     if (dev->rxer[vci]) {
       // RXer still on the channel, just modify rate... XXX not really needed
       cmd.request = cpu_to_be32 (SRB_MODIFY_VC_RATE);
@@ -1277,7 +1278,7 @@ static void amb_close (struct atm_vcc * 
     dev->txer[vci].tx_present = 0;
     while (command_do (dev, &cmd))
       schedule();
-    up (&dev->vcc_sf);
+    mutex_unlock(&dev->vcc_sf);
   }
   
   // disable RXing
@@ -1287,7 +1288,7 @@ static void amb_close (struct atm_vcc * 
     // this is (the?) one reason why we need the amb_vcc struct
     unsigned char pool = vcc->rx_info.pool;
     
-    down (&dev->vcc_sf);
+    mutex_lock(&dev->vcc_sf);
     if (dev->txer[vci].tx_present) {
       // TXer still on the channel, just go to pool zero XXX not really needed
       cmd.request = cpu_to_be32 (SRB_MODIFY_VC_FLAGS);
@@ -1314,7 +1315,7 @@ static void amb_close (struct atm_vcc * 
       dev->rxq[pool].buffers_wanted = 0;
       drain_rx_pool (dev, pool);
     }
-    up (&dev->vcc_sf);
+    mutex_unlock(&dev->vcc_sf);
   }
   
   // free our structure
@@ -2189,7 +2190,7 @@ static void setup_dev(amb_dev *dev, stru
       
       // semaphore for txer/rxer modifications - we cannot use a
       // spinlock as the critical region needs to switch processes
-      init_MUTEX (&dev->vcc_sf);
+      mutex_init(&dev->vcc_sf);
       // queue manipulation spinlocks; we want atomic reads and
       // writes to the queue descriptors (handles IRQ and SMP)
       // consider replacing "int pending" -> "atomic_t available"
Index: linux-2.6.23/drivers/atm/ambassador.h
===================================================================
--- linux-2.6.23.orig/drivers/atm/ambassador.h
+++ linux-2.6.23/drivers/atm/ambassador.h
@@ -638,7 +638,7 @@ struct amb_dev {
   amb_txq          txq;
   amb_rxq          rxq[NUM_RX_POOLS];
   
-  struct semaphore vcc_sf;
+  struct mutex     vcc_sf;
   amb_tx_info      txer[NUM_VCS];
   struct atm_vcc * rxer[NUM_VCS];
   unsigned int     tx_avail;
-- 

-- 
