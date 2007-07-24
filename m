Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbXGXPro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbXGXPro (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760102AbXGXPrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:47:31 -0400
Received: from users.sycamorenet.com ([12.146.0.130]:24192 "EHLO
	edsel.sycamorenet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759247AbXGXPra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:47:30 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Subject: RE: [PATCH -rt] Preemption problem in kernel RT Patch
Date: Tue, 24 Jul 2007 11:48:16 -0400
Message-ID: <77B279EC7347F341A6AE891AA6AD68E931429B@ranchero.sycamorenet.com>
In-Reply-To: <1182608766.20203.208.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -rt] Preemption problem in kernel RT Patch
Thread-Index: Ace1ootSMn+Fi0ZZTYWS/Da8rP82qgYZN7Vw
From: "Beauchemin, Mark" <Mark.Beauchemin@sycamorenet.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, <mingo@elte.hu>,
       "David Miller" <davem@davemloft.net>
X-OriginalArrivalTime: 24 Jul 2007 15:48:18.0435 (UTC) FILETIME=[0E112D30:01C7CE0A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

	I think I've gotten to the heart of the problem.  Here's an excerpt
from the latest -rt patch:  net/core/dev.c in the function dev_queue_xmit


@@ -1588,11 +1588,17 @@ gso:
 	   Either shot noqueue qdisc, it is even simpler 8)
 	 */
 	if (dev->flags & IFF_UP) {
-		int cpu = smp_processor_id(); /* ok because BHs are off */
+		/*
+		 * No need to check for recursion with threaded interrupts:
+		 */
+#ifdef CONFIG_PREEMPT_RT
+		if (1) {
+#else
+		int cpu = raw_smp_processor_id(); /* ok because BHs are off */
 
 		if (dev->xmit_lock_owner != cpu) {
-
-			HARD_TX_LOCK(dev, cpu);
+#endif
+			HARD_TX_LOCK(dev);
 
 			if (!netif_queue_stopped(dev) &&
 			    !netif_subqueue_stopped(dev, skb->queue_mapping)) {


I'm not sure why the check for recursion has been removed.  
In the backtrace below, I think it would be caught by this check and 
not recursively call the spinlock code.

> Call Trace:                                                                                                           
> [D010BB40] [C01C7BA8] rt_spin_lock_slowlock+0x44/0x1f8 (unreliable)                                                   
> [D010BB90] [C0153464] dev_queue_xmit+0x298/0x2a0         Tunnel2                                                      
> [D010BBB0] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BBE0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
> [D010BC60] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
> [D010BC80] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel4                                                      
> [D010BCA0] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BCD0] [C01AC078] ipip_tunnel_xmit+0x508/0x698                                                                    
> [D010BD50] [C0150DF4] dev_hard_start_xmit+0x1b4/0x2a4                                                                 
> [D010BD70] [C0153430] dev_queue_xmit+0x264/0x2a0         Tunnel2                                                      
> [D010BD90] [C0176398] ip_output+0x288/0x2dc                                                                           
> [D010BDC0] [C017685C] ip_queue_xmit+0x1ac/0x4e4                                                                       
> [D010BE30] [C018762C] tcp_transmit_skb+0x390/0x810                                                                    
> [D010BE70] [C018882C] tcp_retransmit_skb+0x160/0x638                                                                  
> [D010BEA0] [C018BA5C] tcp_write_timer+0x274/0x6c0                                                                     
> [D010BED0] [C0024314] run_timer_softirq+0x2d0/0xedc                                                                   
> [D010BF80] [C001F1C4] ksoftirqd+0xf8/0x1b0                                                                            
> [D010BFC0] [C0031588] kthread+0xc0/0xfc                                                                               
> [D010BFF0] [C000471C] kernel_thread+0x44/0x60                                                                         



I found one other place in the code which appears to do the same thing.
Although it is written to handle smp collisions, I think it should also
handle the error case above.


Index: linux-rt-rebase.q/net/sched/sch_generic.c
===================================================================
--- linux-rt-rebase.q.orig/net/sched/sch_generic.c
+++ linux-rt-rebase.q/net/sched/sch_generic.c
@@ -12,6 +12,7 @@
  */
 
 #include <linux/bitops.h>
+#include <linux/kallsyms.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
@@ -150,16 +151,28 @@ static inline int qdisc_restart(struct n
 	 */
 	lockless = (dev->features & NETIF_F_LLTX);
 
-	if (!lockless && !netif_tx_trylock(dev)) {
-		/* Another CPU grabbed the driver tx lock */
-		return handle_dev_cpu_collision(skb, dev, q);
+	if (!lockless) {
+#ifdef CONFIG_PREEMPT_RT
+		netif_tx_lock(dev);
+#else
+		if (netif_tx_trylock(dev))
+			/* Another CPU grabbed the driver tx lock */
+			return handle_dev_cpu_collision(skb, dev, q);
+#endif


	What do you think?

		Thanks,
			Mark

