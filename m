Return-Path: <linux-kernel-owner+w=401wt.eu-S1754265AbXE3N31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265AbXE3N31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 09:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXE3N3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 09:29:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:45610 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbXE3N3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 09:29:20 -0400
Message-ID: <465D7BE9.70702@windriver.com>
Date: Wed, 30 May 2007 08:28:09 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org,
       Jarek Poplawski <jarkao2@o2.pl>, Thomas Gleixner <tglx@linutronix.de>,
       stable@kernel.org
Subject: [PATCH] Re: [2.6.21.1] soft lockup when removing netconsole module
References: <20070526154011.GB3735@vanheusden.com> <20070529005628.f7f3abc6.akpm@linux-foundation.org>
In-Reply-To: <20070529005628.f7f3abc6.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------040406020001040707050801"
X-OriginalArrivalTime: 30 May 2007 13:28:10.0915 (UTC) FILETIME=[5E132F30:01C7A2BE]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040406020001040707050801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Attached is a patch to fix the soft lockup problem when removing the 
netconsole module.

It looks different than the original patch I posted because the context 
had to change to maintain 80 column code.  For reference the original 
e-mail + patch was "[BUG] 2.6.21 hang in 
cancel_rearming_delayed_workqueue()" sent on 5/25/07.

Jason.



--------------040406020001040707050801
Content-Type: text/plain;
 name="netpoll_cleanup_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="netpoll_cleanup_fix.patch"

>From 102a018d601e954f658d272d4daeef139ae40e0e Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Wed, 30 May 2007 08:03:52 -0500
Subject: [PATCH] The netpoll_cleanup handler can hang the kernel if there is no work in
the work queue because a call to cancel_rearming_delayed_work() with
no work goes into an infinite loop.

The typical case where this is a problem is on removing a kernel
module such as the netconsole driver or kgdboe.

To maintain 80 column code, the function had to have one level of braces
dropped.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 net/core/netpoll.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 4581ece..28fa50e 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -766,30 +766,32 @@ void netpoll_cleanup(struct netpoll *np)
 	struct netpoll_info *npinfo;
 	unsigned long flags;
 
-	if (np->dev) {
-		npinfo = np->dev->npinfo;
-		if (npinfo) {
-			if (npinfo->rx_np == np) {
-				spin_lock_irqsave(&npinfo->rx_lock, flags);
-				npinfo->rx_np = NULL;
-				npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
-				spin_unlock_irqrestore(&npinfo->rx_lock, flags);
-			}
+	if (!np->dev)
+		return;
+
+	npinfo = np->dev->npinfo;
+	if (npinfo) {
+		if (npinfo->rx_np == np) {
+			spin_lock_irqsave(&npinfo->rx_lock, flags);
+			npinfo->rx_np = NULL;
+			npinfo->rx_flags &= ~NETPOLL_RX_ENABLED;
+			spin_unlock_irqrestore(&npinfo->rx_lock, flags);
+		}
 
-			np->dev->npinfo = NULL;
-			if (atomic_dec_and_test(&npinfo->refcnt)) {
-				skb_queue_purge(&npinfo->arp_tx);
-				skb_queue_purge(&npinfo->txq);
+		np->dev->npinfo = NULL;
+		if (atomic_dec_and_test(&npinfo->refcnt)) {
+			skb_queue_purge(&npinfo->arp_tx);
+			skb_queue_purge(&npinfo->txq);
+			if (delayed_work_pending(&npinfo->tx_work)) {
 				cancel_rearming_delayed_work(&npinfo->tx_work);
 				flush_scheduled_work();
-
-				kfree(npinfo);
 			}
-		}
 
-		dev_put(np->dev);
+			kfree(npinfo);
+		}
 	}
 
+	dev_put(np->dev);
 	np->dev = NULL;
 }
 
-- 
1.5.0.6


--------------040406020001040707050801--
