Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbXGPJM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbXGPJM7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756071AbXGPJMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:12:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60334 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755388AbXGPJMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:12:47 -0400
Date: Mon, 16 Jul 2007 11:12:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, olaf.kirch@oracle.com, davem@davemloft.net
Subject: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
Message-ID: <20070716091236.GA10718@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


current -git broke my main testbox. No TCP/IP networking to/from the box 
and e1000 would time out in xmit:

 NETDEV WATCHDOG: eth0: transmit timed out
 e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
   Tx Queue             <0>
   TDH                  <95>
   TDT                  <95>
   next_to_use          <95>
   next_to_clean        <ea>
 buffer_info[next_to_clean]
   time_stamp           <ffff8f43>
   next_to_watch        <ea>
   jiffies              <ffffb5cc>
   next_to_watch.status <1>

After a bisection session the bad commit turned out to be:

 29578624e354f56143d92510fff33a8b2aaa2c03 is first bad commit
 commit 29578624e354f56143d92510fff33a8b2aaa2c03
 Author: Olaf Kirch <olaf.kirch@oracle.com>
 Date:   Wed Jul 11 19:32:02 2007 -0700

     [NET]: Fix races in net_rx_action vs netpoll.

     Keep netpoll/poll_napi from messing with the poll_list.
     Only net_rx_action is allowed to manipulate the list.

     Signed-off-by: Olaf Kirch <olaf.kirch@oracle.com>
     Signed-off-by: David S. Miller <davem@davemloft.net>

and indeed the testbox uses netconsole (it's a laptop so this is the 
only viable remote debugging option). Applying the revert patch below 
makes it work again.

	Ingo

------------------>
Subject: [patch] revert: [NET]: Fix races in net_rx_action vs netpoll
From: Ingo Molnar <mingo@elte.hu>

commit 29578624 causes netconsole failures:

  NETDEV WATCHDOG: eth0: transmit timed out
  e1000: eth0: e1000_clean_tx_irq: Detected Tx Unit Hang
    Tx Queue             <0>
    TDH                  <95>
    TDT                  <95>
    next_to_use          <95>
    next_to_clean        <ea>
  buffer_info[next_to_clean]
    time_stamp           <ffff8f43>
    next_to_watch        <ea>
    jiffies              <ffffb5cc>
    next_to_watch.status <1>

revert it for now, to make my testsystem work.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/netdevice.h |   10 ----------
 net/core/netpoll.c        |    8 --------
 2 files changed, 18 deletions(-)

Index: linux/include/linux/netdevice.h
===================================================================
--- linux.orig/include/linux/netdevice.h
+++ linux/include/linux/netdevice.h
@@ -261,8 +261,6 @@ enum netdev_state_t
 	__LINK_STATE_LINKWATCH_PENDING,
 	__LINK_STATE_DORMANT,
 	__LINK_STATE_QDISC_RUNNING,
-	/* Set by the netpoll NAPI code */
-	__LINK_STATE_POLL_LIST_FROZEN,
 };
 
 
@@ -1016,14 +1014,6 @@ static inline void netif_rx_complete(str
 {
 	unsigned long flags;
 
-#ifdef CONFIG_NETPOLL
-	/* Prevent race with netpoll - yes, this is a kludge.
-	 * But at least it doesn't penalize the non-netpoll
-	 * code path. */
-	if (test_bit(__LINK_STATE_POLL_LIST_FROZEN, &dev->state))
-		return;
-#endif
-
 	local_irq_save(flags);
 	__netif_rx_complete(dev);
 	local_irq_restore(flags);
Index: linux/net/core/netpoll.c
===================================================================
--- linux.orig/net/core/netpoll.c
+++ linux/net/core/netpoll.c
@@ -124,13 +124,6 @@ static void poll_napi(struct netpoll *np
 	if (test_bit(__LINK_STATE_RX_SCHED, &np->dev->state) &&
 	    npinfo->poll_owner != smp_processor_id() &&
 	    spin_trylock(&npinfo->poll_lock)) {
-		/* When calling dev->poll from poll_napi, we may end up in
-		 * netif_rx_complete. However, only the CPU to which the
-		 * device was queued is allowed to remove it from poll_list.
-		 * Setting POLL_LIST_FROZEN tells netif_rx_complete
-		 * to leave the NAPI state alone.
-		 */
-		set_bit(__LINK_STATE_POLL_LIST_FROZEN, &np->dev->state);
 		npinfo->rx_flags |= NETPOLL_RX_DROP;
 		atomic_inc(&trapped);
 
@@ -138,7 +131,6 @@ static void poll_napi(struct netpoll *np
 
 		atomic_dec(&trapped);
 		npinfo->rx_flags &= ~NETPOLL_RX_DROP;
-		clear_bit(__LINK_STATE_POLL_LIST_FROZEN, &np->dev->state);
 		spin_unlock(&npinfo->poll_lock);
 	}
 }
