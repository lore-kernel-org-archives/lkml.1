Return-Path: <linux-kernel-owner+w=401wt.eu-S1750893AbXCZJHQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750893AbXCZJHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 05:07:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXCZJHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 05:07:16 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36803 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXCZJHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 05:07:14 -0400
Date: Mon, 26 Mar 2007 10:39:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc5
Message-ID: <20070326083920.GA14648@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070326083146.GA11666@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070326083146.GA11666@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> my first quick guess was to extend np->priv locking to the whole of 
> nv_start_xmit/nv_start_xmit_optimized - while that appeared to make 
> the crash a bit less likely, it did not prevent it. So there must be 
> some other, more fundamental problem be left as well. At first glance 
> the SMP locking looks OK, so maybe the ring indices are messed up 
> somehow and we got into a 'ring head bites the tail' scenario?

to be specific, the patch below is what i tried - but it didnt 
completely fix the crash.

	Ingo

---
 drivers/net/forcedeth.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux/drivers/net/forcedeth.c
===================================================================
--- linux.orig/drivers/net/forcedeth.c
+++ linux/drivers/net/forcedeth.c
@@ -1650,9 +1650,10 @@ static int nv_start_xmit(struct sk_buff 
 			   ((skb_shinfo(skb)->frags[i].size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
 	}
 
+	spin_lock_irq(&np->lock);
+
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
-		spin_lock_irq(&np->lock);
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
 		spin_unlock_irq(&np->lock);
@@ -1718,8 +1719,6 @@ static int nv_start_xmit(struct sk_buff 
 		tx_flags_extra = skb->ip_summed == CHECKSUM_PARTIAL ?
 			 NV_TX2_CHECKSUM_L3 | NV_TX2_CHECKSUM_L4 : 0;
 
-	spin_lock_irq(&np->lock);
-
 	/* set tx flags */
 	start_tx->flaglen |= cpu_to_le32(tx_flags | tx_flags_extra);
 	np->put_tx.orig = put_tx;
@@ -1766,9 +1765,10 @@ static int nv_start_xmit_optimized(struc
 			   ((skb_shinfo(skb)->frags[i].size & (NV_TX2_TSO_MAX_SIZE-1)) ? 1 : 0);
 	}
 
+	spin_lock_irq(&np->lock);
+
 	empty_slots = nv_get_empty_tx_slots(np);
 	if (unlikely(empty_slots <= entries)) {
-		spin_lock_irq(&np->lock);
 		netif_stop_queue(dev);
 		np->tx_stop = 1;
 		spin_unlock_irq(&np->lock);
@@ -1846,8 +1846,6 @@ static int nv_start_xmit_optimized(struc
 			start_tx->txvlan = 0;
 	}
 
-	spin_lock_irq(&np->lock);
-
 	/* set tx flags */
 	start_tx->flaglen |= cpu_to_le32(tx_flags | tx_flags_extra);
 	np->put_tx.ex = put_tx;
@@ -3484,6 +3482,7 @@ static void nv_do_nic_poll(unsigned long
 	struct net_device *dev = (struct net_device *) data;
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
+	unsigned long flags;
 	u32 mask = 0;
 
 	/*
@@ -3519,7 +3518,7 @@ static void nv_do_nic_poll(unsigned long
 		printk(KERN_INFO "forcedeth: MAC in recoverable error state\n");
 		if (netif_running(dev)) {
 			netif_tx_lock_bh(dev);
-			spin_lock(&np->lock);
+			spin_lock_irqsave(&np->lock, flags);
 			/* stop engines */
 			nv_stop_rx(dev);
 			nv_stop_tx(dev);
@@ -3545,7 +3544,7 @@ static void nv_do_nic_poll(unsigned long
 			/* restart rx engine */
 			nv_start_rx(dev);
 			nv_start_tx(dev);
-			spin_unlock(&np->lock);
+			spin_unlock_irqrestore(&np->lock, flags);
 			netif_tx_unlock_bh(dev);
 		}
 	}
