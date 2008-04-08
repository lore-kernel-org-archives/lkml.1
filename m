Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYDHKWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYDHKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 06:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433AbYDHKWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 06:22:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:36634 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbYDHKWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 06:22:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=YQkgkLKFJkNX3+S1Hweq6R/CtQ4qhMi4j3WhCmN306LdTBNt8tqNUlWYtHUFXcK0JUUibDp8AyK8iJhIeNwXVmh/0EPDPdVw0l4vvzB7sQ9IA7BHlsN0kqxLOSuRKVa/Qg8Xf/yxWLJZZ4Qj5EWwL+1f25aj7sxDvF3+1SJlezo=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Chas Williams <chas@cmf.nrl.navy.mil>, David Miller <davem@davemloft.net>
Subject: [PATCH] drivers/atm/horizon.c: stop inlining largish static functions
Date: Tue, 8 Apr 2008 12:21:42 +0200
User-Agent: KMail/1.8.2
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_2c0+HwiW+JWe+kC"
Message-Id: <200804081221.42465.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_2c0+HwiW+JWe+kC
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi David,

Can you also take this patch?

drivers/atm/horizon.c has unusually large number
of static inline functions - 36.

I looked through them. Most of them seems to be small enough,
but a few are big, others are using udelay or busy loop,
and as such are better not be inlined.

This patch removes "inline" from these static functions
(regardless of number of callsites - gcc nowadays auto-inlines
statics with one callsite).

Size difference for 32bit x86:
   text    data     bss     dec     hex filename
   8201     180       6    8387    20c3 linux-2.6-ALLYES/drivers/atm/horizon.o
   7840     180       6    8026    1f5a linux-2.6.inline-ALLYES/drivers/atm/horizon.o

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_2c0+HwiW+JWe+kC
Content-Type: text/x-diff;
  charset="us-ascii";
  name="deinline_horizon.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="deinline_horizon.diff"

diff -urp -U 10 linux-2.6/drivers/atm/horizon.c linux-2.6.inline/drivers/atm/horizon.c
--- linux-2.6/drivers/atm/horizon.c	2008-03-30 03:27:42.000000000 +0200
+++ linux-2.6.inline/drivers/atm/horizon.c	2008-03-31 22:26:49.000000000 +0200
@@ -417,32 +417,32 @@ static inline u32 rd_framer (const hrz_d
 
 /********** specialised access functions **********/
 
 /* RX */
 
 static inline void FLUSH_RX_CHANNEL (hrz_dev * dev, u16 channel) {
   wr_regw (dev, RX_CHANNEL_PORT_OFF, FLUSH_CHANNEL | channel);
   return;
 }
 
-static inline void WAIT_FLUSH_RX_COMPLETE (hrz_dev * dev) {
+static void WAIT_FLUSH_RX_COMPLETE (hrz_dev * dev) {
   while (rd_regw (dev, RX_CHANNEL_PORT_OFF) & FLUSH_CHANNEL)
     ;
   return;
 }
 
 static inline void SELECT_RX_CHANNEL (hrz_dev * dev, u16 channel) {
   wr_regw (dev, RX_CHANNEL_PORT_OFF, channel);
   return;
 }
 
-static inline void WAIT_UPDATE_COMPLETE (hrz_dev * dev) {
+static void WAIT_UPDATE_COMPLETE (hrz_dev * dev) {
   while (rd_regw (dev, RX_CHANNEL_PORT_OFF) & RX_CHANNEL_UPDATE_IN_PROGRESS)
     ;
   return;
 }
 
 /* TX */
 
 static inline void SELECT_TX_CHANNEL (hrz_dev * dev, u16 tx_channel) {
   wr_regl (dev, TX_CHANNEL_PORT_OFF, tx_channel);
   return;
@@ -789,21 +789,21 @@ static int hrz_open_rx (hrz_dev * dev, u
 #if 0
 /********** change vc rate for a given vc **********/
 
 static void hrz_change_vc_qos (ATM_RXER * rxer, MAAL_QOS * qos) {
   rxer->rate = make_rate (qos->peak_cells);
 }
 #endif
 
 /********** free an skb (as per ATM device driver documentation) **********/
 
-static inline void hrz_kfree_skb (struct sk_buff * skb) {
+static void hrz_kfree_skb (struct sk_buff * skb) {
   if (ATM_SKB(skb)->vcc->pop) {
     ATM_SKB(skb)->vcc->pop (ATM_SKB(skb)->vcc, skb);
   } else {
     dev_kfree_skb_any (skb);
   }
 }
 
 /********** cancel listen on a VC **********/
 
 static void hrz_close_rx (hrz_dev * dev, u16 vc) {
@@ -1069,34 +1069,34 @@ static void rx_schedule (hrz_dev * dev, 
 #else
     // grrrrrrr!
     irq = 0;
   }
   return;
 #endif
 }
 
 /********** handle RX bus master complete events **********/
 
-static inline void rx_bus_master_complete_handler (hrz_dev * dev) {
+static void rx_bus_master_complete_handler (hrz_dev * dev) {
   if (test_bit (rx_busy, &dev->flags)) {
     rx_schedule (dev, 1);
   } else {
     PRINTD (DBG_RX|DBG_ERR, "unexpected RX bus master completion");
     // clear interrupt condition on adapter
     wr_regl (dev, MASTER_RX_COUNT_REG_OFF, 0);
   }
   return;
 }
 
 /********** (queue to) become the next TX thread **********/
 
-static inline int tx_hold (hrz_dev * dev) {
+static int tx_hold (hrz_dev * dev) {
   PRINTD (DBG_TX, "sleeping at tx lock %p %lu", dev, dev->flags);
   wait_event_interruptible(dev->tx_queue, (!test_and_set_bit(tx_busy, &dev->flags)));
   PRINTD (DBG_TX, "woken at tx lock %p %lu", dev, dev->flags);
   if (signal_pending (current))
     return -1;
   PRINTD (DBG_TX, "set tx_busy for dev %p", dev);
   return 0;
 }
 
 /********** allow another TX thread to start **********/
@@ -1225,35 +1225,35 @@ static void tx_schedule (hrz_dev * const
 #else
     // grrrrrrr!
     irq = 0;
   }
   return;
 #endif
 }
 
 /********** handle TX bus master complete events **********/
 
-static inline void tx_bus_master_complete_handler (hrz_dev * dev) {
+static void tx_bus_master_complete_handler (hrz_dev * dev) {
   if (test_bit (tx_busy, &dev->flags)) {
     tx_schedule (dev, 1);
   } else {
     PRINTD (DBG_TX|DBG_ERR, "unexpected TX bus master completion");
     // clear interrupt condition on adapter
     wr_regl (dev, MASTER_TX_COUNT_REG_OFF, 0);
   }
   return;
 }
 
 /********** move RX Q pointer to next item in circular buffer **********/
 
 // called only from IRQ sub-handler
-static inline u32 rx_queue_entry_next (hrz_dev * dev) {
+static u32 rx_queue_entry_next (hrz_dev * dev) {
   u32 rx_queue_entry;
   spin_lock (&dev->mem_lock);
   rx_queue_entry = rd_mem (dev, &dev->rx_q_entry->entry);
   if (dev->rx_q_entry == dev->rx_q_wrap)
     dev->rx_q_entry = dev->rx_q_reset;
   else
     dev->rx_q_entry++;
   wr_regw (dev, RX_QUEUE_RD_PTR_OFF, dev->rx_q_entry - dev->rx_q_reset);
   spin_unlock (&dev->mem_lock);
   return rx_queue_entry;
@@ -1263,21 +1263,21 @@ static inline u32 rx_queue_entry_next (h
 
 static inline void rx_disabled_handler (hrz_dev * dev) {
   wr_regw (dev, RX_CONFIG_OFF, rd_regw (dev, RX_CONFIG_OFF) | RX_ENABLE);
   // count me please
   PRINTK (KERN_WARNING, "RX was disabled!");
 }
 
 /********** handle RX data received by device **********/
 
 // called from IRQ handler
-static inline void rx_data_av_handler (hrz_dev * dev) {
+static void rx_data_av_handler (hrz_dev * dev) {
   u32 rx_queue_entry;
   u32 rx_queue_entry_flags;
   u16 rx_len;
   u16 rx_channel;
   
   PRINTD (DBG_FLOW, "hrz_data_av_handler");
   
   // try to grab rx lock (not possible during RX bus mastering)
   if (test_and_set_bit (rx_busy, &dev->flags)) {
     PRINTD (DBG_RX, "locked out of rx lock");
@@ -1387,21 +1387,21 @@ static irqreturn_t interrupt_handler(int
   hrz_dev *dev = dev_id;
   u32 int_source;
   unsigned int irq_ok;
   
   PRINTD (DBG_FLOW, "interrupt_handler: %p", dev_id);
   
   // definitely for us
   irq_ok = 0;
   while ((int_source = rd_regl (dev, INT_SOURCE_REG_OFF)
 	  & INTERESTING_INTERRUPTS)) {
-    // In the interests of fairness, the (inline) handlers below are
+    // In the interests of fairness, the handlers below are
     // called in sequence and without immediate return to the head of
     // the while loop. This is only of issue for slow hosts (or when
     // debugging messages are on). Really slow hosts may find a fast
     // sender keeps them permanently in the IRQ handler. :(
     
     // (only an issue for slow hosts) RX completion goes before
     // rx_data_av as the former implies rx_busy and so the latter
     // would just abort. If it reschedules another transfer
     // (continuing the same frame) then it will not clear rx_busy.
     
@@ -1451,21 +1451,21 @@ static void do_housekeeping (unsigned lo
   dev->unassigned_cell_count += rd_regw (dev, UNASSIGNED_CELL_COUNT_OFF);
 
   mod_timer (&dev->housekeeping, jiffies + HZ/10);
 
   return;
 }
 
 /********** find an idle channel for TX and set it up **********/
 
 // called with tx_busy set
-static inline short setup_idle_tx_channel (hrz_dev * dev, hrz_vcc * vcc) {
+static short setup_idle_tx_channel (hrz_dev * dev, hrz_vcc * vcc) {
   unsigned short idle_channels;
   short tx_channel = -1;
   unsigned int spin_count;
   PRINTD (DBG_FLOW|DBG_TX, "setup_idle_tx_channel %p", dev);
   
   // better would be to fail immediately, the caller can then decide whether
   // to wait or drop (depending on whether this is UBR etc.)
   spin_count = 0;
   while (!(idle_channels = rd_regw (dev, TX_STATUS_OFF) & IDLE_CHANNELS_MASK)) {
     PRINTD (DBG_TX|DBG_WARN, "waiting for idle TX channel");
@@ -1770,27 +1770,27 @@ static void hrz_reset (const hrz_dev * d
   wr_regl (dev, CONTROL_0_REG, control_0_reg |
 	   RESET_ATM | RESET_RX | RESET_TX | RESET_HOST);
   // just guessing here
   udelay (1000);
   
   wr_regl (dev, CONTROL_0_REG, control_0_reg);
 }
 
 /********** read the burnt in address **********/
 
-static inline void WRITE_IT_WAIT (const hrz_dev *dev, u32 ctrl)
+static void WRITE_IT_WAIT (const hrz_dev *dev, u32 ctrl)
 {
 	wr_regl (dev, CONTROL_0_REG, ctrl);
 	udelay (5);
 }
   
-static inline void CLOCK_IT (const hrz_dev *dev, u32 ctrl)
+static void CLOCK_IT (const hrz_dev *dev, u32 ctrl)
 {
 	// DI must be valid around rising SK edge
 	WRITE_IT_WAIT(dev, ctrl & ~SEEPROM_SK);
 	WRITE_IT_WAIT(dev, ctrl | SEEPROM_SK);
 }
 
 static u16 __devinit read_bia (const hrz_dev * dev, u16 addr)
 {
   u32 ctrl = rd_regl (dev, CONTROL_0_REG);
   

--Boundary-00=_2c0+HwiW+JWe+kC--
