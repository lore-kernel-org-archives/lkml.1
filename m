Return-Path: <linux-kernel-owner+w=401wt.eu-S1764816AbXJOUAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764816AbXJOUAL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbXJOT7z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 15:59:55 -0400
Received: from gw.goop.org ([64.81.55.164]:40836 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752982AbXJOT7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 15:59:54 -0400
Message-ID: <4713C6B9.1010402@goop.org>
Date: Mon, 15 Oct 2007 12:59:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] xen-netfront: use net_device's stats structure
References: <470C2737.60403@goop.org> <4713AFC3.8000403@pobox.com>
In-Reply-To: <4713AFC3.8000403@pobox.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> ACK patches 1-3, but they still do not apply.
>
> Since net-2.6.24 has gone upstream, you may send diffs against
> torvalds/linux-2.6.git if you like -- there are no outstanding
> dependencies at this time.

Yes, there was a larger patch which globally rolled all the private
stats structures into the netdev one, so the xen-specfic one was
redundant, and someone else submitted the deadcode removal one, so the
only outstanding patch is this one:

Subject: xen-netfront: rearrange netfront structure to separate tx and rx

Keep tx and rx elements separate on different cachelines to prevent
bouncing.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Acked-by: Jeff Garzik <jgarzik@pobox.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>

---
 drivers/net/xen-netfront.c |   37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -74,22 +74,12 @@ struct netfront_info {
 
 	struct napi_struct napi;
 
+	unsigned int evtchn;
+	struct xenbus_device *xbdev;
+
+	spinlock_t   tx_lock;
 	struct xen_netif_tx_front_ring tx;
-	struct xen_netif_rx_front_ring rx;
-
-	spinlock_t   tx_lock;
-	spinlock_t   rx_lock;
-
-	unsigned int evtchn;
-
-	/* Receive-ring batched refills. */
-#define RX_MIN_TARGET 8
-#define RX_DFL_MIN_TARGET 64
-#define RX_MAX_TARGET min_t(int, NET_RX_RING_SIZE, 256)
-	unsigned rx_min_target, rx_max_target, rx_target;
-	struct sk_buff_head rx_batch;
-
-	struct timer_list rx_refill_timer;
+	int tx_ring_ref;
 
 	/*
 	 * {tx,rx}_skbs store outstanding skbuffs. Free tx_skb entries
@@ -108,13 +98,22 @@ struct netfront_info {
 	grant_ref_t grant_tx_ref[NET_TX_RING_SIZE];
 	unsigned tx_skb_freelist;
 
+	spinlock_t   rx_lock ____cacheline_aligned_in_smp;
+	struct xen_netif_rx_front_ring rx;
+	int rx_ring_ref;
+
+	/* Receive-ring batched refills. */
+#define RX_MIN_TARGET 8
+#define RX_DFL_MIN_TARGET 64
+#define RX_MAX_TARGET min_t(int, NET_RX_RING_SIZE, 256)
+	unsigned rx_min_target, rx_max_target, rx_target;
+	struct sk_buff_head rx_batch;
+
+	struct timer_list rx_refill_timer;
+
 	struct sk_buff *rx_skbs[NET_RX_RING_SIZE];
 	grant_ref_t gref_rx_head;
 	grant_ref_t grant_rx_ref[NET_RX_RING_SIZE];
-
-	struct xenbus_device *xbdev;
-	int tx_ring_ref;
-	int rx_ring_ref;
 
 	unsigned long rx_pfn_array[NET_RX_RING_SIZE];
 	struct multicall_entry rx_mcl[NET_RX_RING_SIZE+1];


