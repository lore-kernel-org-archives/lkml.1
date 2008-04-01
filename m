Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYDABP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYDABP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 21:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753847AbYDABPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 21:15:13 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbYDABPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 21:15:11 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>
Subject: [PATCH] drivers/atm/ambassador.c: stop inlining largish static functions
Date: Tue, 1 Apr 2008 03:14:58 +0200
User-Agent: KMail/1.8.2
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_SyY8H2N+EQZIBwC"
Message-Id: <200804010314.58117.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_SyY8H2N+EQZIBwC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi John,

Can you please take a look at this patch?

drivers/atm/ambassador.c has unusually large number
of static inline functions - 22.

I looked through them and half of them seem to be too big
to warrant inlining.

This patch removes "inline" from these static functions
(regardless of number of callsites - gcc nowadays auto-inlines
statics with one callsite).

Size difference for 32bit x86:
   text    data     bss     dec     hex filename
  10209    8488       4   18701    490d linux-2.6-ALLYES/drivers/atm/ambassador.o
   9462    8488       4   17954    4622 linux-2.6.inline-ALLYES/drivers/atm/ambassador.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_SyY8H2N+EQZIBwC
Content-Type: text/x-diff;
  charset="us-ascii";
  name="deinline_ambassador.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="deinline_ambassador.diff"

diff -urp -U 10 linux-2.6/drivers/atm/ambassador.c linux-2.6.inline/drivers/atm/ambassador.c
--- linux-2.6/drivers/atm/ambassador.c	2008-03-30 03:27:42.000000000 +0200
+++ linux-2.6.inline/drivers/atm/ambassador.c	2008-04-01 03:09:12.000000000 +0200
@@ -430,50 +430,50 @@ static inline void dump_skb (char * pref
   (void) vc;
   (void) skb;
 #endif
   return;
 }
 
 /********** check memory areas for use by Ambassador **********/
 
 /* see limitations under Hardware Features */
 
-static inline int check_area (void * start, size_t length) {
+static int check_area (void * start, size_t length) {
   // assumes length > 0
   const u32 fourmegmask = -1 << 22;
   const u32 twofivesixmask = -1 << 8;
   const u32 starthole = 0xE0000000;
   u32 startaddress = virt_to_bus (start);
   u32 lastaddress = startaddress+length-1;
   if ((startaddress ^ lastaddress) & fourmegmask ||
       (startaddress & twofivesixmask) == starthole) {
     PRINTK (KERN_ERR, "check_area failure: [%x,%x] - mail maintainer!",
 	    startaddress, lastaddress);
     return -1;
   } else {
     return 0;
   }
 }
 
 /********** free an skb (as per ATM device driver documentation) **********/
 
-static inline void amb_kfree_skb (struct sk_buff * skb) {
+static void amb_kfree_skb (struct sk_buff * skb) {
   if (ATM_SKB(skb)->vcc->pop) {
     ATM_SKB(skb)->vcc->pop (ATM_SKB(skb)->vcc, skb);
   } else {
     dev_kfree_skb_any (skb);
   }
 }
 
 /********** TX completion **********/
 
-static inline void tx_complete (amb_dev * dev, tx_out * tx) {
+static void tx_complete (amb_dev * dev, tx_out * tx) {
   tx_simple * tx_descr = bus_to_virt (tx->handle);
   struct sk_buff * skb = tx_descr->skb;
   
   PRINTD (DBG_FLOW|DBG_TX, "tx_complete %p %p", dev, tx);
   
   // VC layer stats
   atomic_inc(&ATM_SKB(skb)->vcc->stats->tx);
   
   // free the descriptor
   kfree (tx_descr);
@@ -636,21 +636,21 @@ static int command_do (amb_dev * dev, co
   } else {
     cq->filled++;
     spin_unlock (&cq->lock);
     return -EAGAIN;
   }
   
 }
 
 /********** TX queue pair **********/
 
-static inline int tx_give (amb_dev * dev, tx_in * tx) {
+static int tx_give (amb_dev * dev, tx_in * tx) {
   amb_txq * txq = &dev->txq;
   unsigned long flags;
   
   PRINTD (DBG_FLOW|DBG_TX, "tx_give %p", dev);
 
   if (test_bit (dead, &dev->flags))
     return 0;
   
   spin_lock_irqsave (&txq->lock, flags);
   
@@ -668,21 +668,21 @@ static inline int tx_give (amb_dev * dev
       txq->high = txq->pending;
     spin_unlock_irqrestore (&txq->lock, flags);
     return 0;
   } else {
     txq->filled++;
     spin_unlock_irqrestore (&txq->lock, flags);
     return -EAGAIN;
   }
 }
 
-static inline int tx_take (amb_dev * dev) {
+static int tx_take (amb_dev * dev) {
   amb_txq * txq = &dev->txq;
   unsigned long flags;
   
   PRINTD (DBG_FLOW|DBG_TX, "tx_take %p", dev);
   
   spin_lock_irqsave (&txq->lock, flags);
   
   if (txq->pending && txq->out.ptr->handle) {
     // deal with TX completion
     tx_complete (dev, txq->out.ptr);
@@ -696,21 +696,21 @@ static inline int tx_take (amb_dev * dev
     return 0;
   } else {
     
     spin_unlock_irqrestore (&txq->lock, flags);
     return -1;
   }
 }
 
 /********** RX queue pairs **********/
 
-static inline int rx_give (amb_dev * dev, rx_in * rx, unsigned char pool) {
+static int rx_give (amb_dev * dev, rx_in * rx, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   unsigned long flags;
   
   PRINTD (DBG_FLOW|DBG_RX, "rx_give %p[%hu]", dev, pool);
   
   spin_lock_irqsave (&rxq->lock, flags);
   
   if (rxq->pending < rxq->maximum) {
     PRINTD (DBG_RX, "RX in slot %p", rxq->in.ptr);
 
@@ -721,21 +721,21 @@ static inline int rx_give (amb_dev * dev
     wr_mem (dev, offsetof(amb_mem, mb.adapter.rx_address[pool]), virt_to_bus (rxq->in.ptr));
     
     spin_unlock_irqrestore (&rxq->lock, flags);
     return 0;
   } else {
     spin_unlock_irqrestore (&rxq->lock, flags);
     return -1;
   }
 }
 
-static inline int rx_take (amb_dev * dev, unsigned char pool) {
+static int rx_take (amb_dev * dev, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   unsigned long flags;
   
   PRINTD (DBG_FLOW|DBG_RX, "rx_take %p[%hu]", dev, pool);
   
   spin_lock_irqsave (&rxq->lock, flags);
   
   if (rxq->pending && (rxq->out.ptr->status || rxq->out.ptr->length)) {
     // deal with RX completion
     rx_complete (dev, rxq->out.ptr);
@@ -754,21 +754,21 @@ static inline int rx_take (amb_dev * dev
     if (!rxq->pending && rxq->buffers_wanted)
       rxq->emptied++;
     spin_unlock_irqrestore (&rxq->lock, flags);
     return -1;
   }
 }
 
 /********** RX Pool handling **********/
 
 /* pre: buffers_wanted = 0, post: pending = 0 */
-static inline void drain_rx_pool (amb_dev * dev, unsigned char pool) {
+static void drain_rx_pool (amb_dev * dev, unsigned char pool) {
   amb_rxq * rxq = &dev->rxq[pool];
   
   PRINTD (DBG_FLOW|DBG_POOL, "drain_rx_pool %p %hu", dev, pool);
   
   if (test_bit (dead, &dev->flags))
     return;
   
   /* we are not quite like the fill pool routines as we cannot just
      remove one buffer, we have to remove all of them, but we might as
      well pretend... */
@@ -789,21 +789,21 @@ static inline void drain_rx_pool (amb_de
 
 static void drain_rx_pools (amb_dev * dev) {
   unsigned char pool;
   
   PRINTD (DBG_FLOW|DBG_POOL, "drain_rx_pools %p", dev);
   
   for (pool = 0; pool < NUM_RX_POOLS; ++pool)
     drain_rx_pool (dev, pool);
 }
 
-static inline void fill_rx_pool (amb_dev * dev, unsigned char pool,
+static void fill_rx_pool (amb_dev * dev, unsigned char pool,
                                  gfp_t priority)
 {
   rx_in rx;
   amb_rxq * rxq;
   
   PRINTD (DBG_FLOW|DBG_POOL, "fill_rx_pool %p %hu %x", dev, pool, priority);
   
   if (test_bit (dead, &dev->flags))
     return;
   
@@ -839,29 +839,29 @@ static void fill_rx_pools (amb_dev * dev
   PRINTD (DBG_FLOW|DBG_POOL, "fill_rx_pools %p", dev);
   
   for (pool = 0; pool < NUM_RX_POOLS; ++pool)
     fill_rx_pool (dev, pool, GFP_ATOMIC);
   
   return;
 }
 
 /********** enable host interrupts **********/
 
-static inline void interrupts_on (amb_dev * dev) {
+static void interrupts_on (amb_dev * dev) {
   wr_plain (dev, offsetof(amb_mem, interrupt_control),
 	    rd_plain (dev, offsetof(amb_mem, interrupt_control))
 	    | AMB_INTERRUPT_BITS);
 }
 
 /********** disable host interrupts **********/
 
-static inline void interrupts_off (amb_dev * dev) {
+static void interrupts_off (amb_dev * dev) {
   wr_plain (dev, offsetof(amb_mem, interrupt_control),
 	    rd_plain (dev, offsetof(amb_mem, interrupt_control))
 	    &~ AMB_INTERRUPT_BITS);
 }
 
 /********** interrupt handling **********/
 
 static irqreturn_t interrupt_handler(int irq, void *dev_id) {
   amb_dev * dev = dev_id;
   

--Boundary-00=_SyY8H2N+EQZIBwC--
