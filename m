Return-Path: <linux-kernel-owner+w=401wt.eu-S1762095AbZEFWNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762095AbZEFWNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761588AbZEFVzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:55:06 -0400
Received: from kroah.org ([198.145.64.141]:57343 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761463AbZEFVy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:59 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:48:01 2009
Message-Id: <20090506214801.547563691@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:46:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Lennert Buytenhek <buytenh@marvell.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 45/58] mv643xx_eth: OOM handling fixes
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=mv643xx_eth-oom-handling-fixes.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lennert Buytenhek <buytenh@wantstofly.org>

commit 1319ebadf185933e6b7ff95211d3cef9004e9754 upstream.

Currently, when OOM occurs during rx ring refill, mv643xx_eth will get
into an infinite loop, due to the refill function setting the OOM bit
but not clearing the 'rx refill needed' bit for this queue, while the
calling function (the NAPI poll handler) will call the refill function
in a loop until the 'rx refill needed' bit goes off, without checking
the OOM bit.

This patch fixes this by checking the OOM bit in the NAPI poll handler
before attempting to do rx refill.  This means that once OOM occurs,
we won't try to do any memory allocations again until the next invocation
of the poll handler.

While we're at it, change the OOM flag to be a single bit instead of
one bit per receive queue since OOM is a system state rather than a
per-queue state, and cancel the OOM timer on entry to the NAPI poll
handler if it's running to prevent it from firing when we've already
come out of OOM.

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Cc: stable@kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/mv643xx_eth.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -372,12 +372,12 @@ struct mv643xx_eth_private {
 	struct work_struct tx_timeout_task;
 
 	struct napi_struct napi;
+	u8 oom;
 	u8 work_link;
 	u8 work_tx;
 	u8 work_tx_end;
 	u8 work_rx;
 	u8 work_rx_refill;
-	u8 work_rx_oom;
 
 	int skb_size;
 	struct sk_buff_head rx_recycle;
@@ -603,7 +603,7 @@ static int rxq_refill(struct rx_queue *r
 					    dma_get_cache_alignment() - 1);
 
 		if (skb == NULL) {
-			mp->work_rx_oom |= 1 << rxq->index;
+			mp->oom = 1;
 			goto oom;
 		}
 
@@ -1906,8 +1906,10 @@ static int mv643xx_eth_poll(struct napi_
 
 	mp = container_of(napi, struct mv643xx_eth_private, napi);
 
-	mp->work_rx_refill |= mp->work_rx_oom;
-	mp->work_rx_oom = 0;
+	if (unlikely(mp->oom)) {
+		mp->oom = 0;
+		del_timer(&mp->rx_oom);
+	}
 
 	work_done = 0;
 	while (work_done < budget) {
@@ -1921,8 +1923,10 @@ static int mv643xx_eth_poll(struct napi_
 			continue;
 		}
 
-		queue_mask = mp->work_tx | mp->work_tx_end |
-				mp->work_rx | mp->work_rx_refill;
+		queue_mask = mp->work_tx | mp->work_tx_end | mp->work_rx;
+		if (likely(!mp->oom))
+			queue_mask |= mp->work_rx_refill;
+
 		if (!queue_mask) {
 			if (mv643xx_eth_collect_events(mp))
 				continue;
@@ -1943,7 +1947,7 @@ static int mv643xx_eth_poll(struct napi_
 			txq_maybe_wake(mp->txq + queue);
 		} else if (mp->work_rx & queue_mask) {
 			work_done += rxq_process(mp->rxq + queue, work_tbd);
-		} else if (mp->work_rx_refill & queue_mask) {
+		} else if (!mp->oom && (mp->work_rx_refill & queue_mask)) {
 			work_done += rxq_refill(mp->rxq + queue, work_tbd);
 		} else {
 			BUG();
@@ -1951,7 +1955,7 @@ static int mv643xx_eth_poll(struct napi_
 	}
 
 	if (work_done < budget) {
-		if (mp->work_rx_oom)
+		if (mp->oom)
 			mod_timer(&mp->rx_oom, jiffies + (HZ / 10));
 		napi_complete(napi);
 		wrlp(mp, INT_MASK, INT_TX_END | INT_RX | INT_EXT);
@@ -2143,7 +2147,7 @@ static int mv643xx_eth_open(struct net_d
 		rxq_refill(mp->rxq + i, INT_MAX);
 	}
 
-	if (mp->work_rx_oom) {
+	if (mp->oom) {
 		mp->rx_oom.expires = jiffies + (HZ / 10);
 		add_timer(&mp->rx_oom);
 	}


