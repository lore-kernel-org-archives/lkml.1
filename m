Return-Path: <linux-kernel-owner+w=401wt.eu-S1755819AbZHMT7O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755819AbZHMT7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 15:59:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755698AbZHMT7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 15:59:12 -0400
Received: from kroah.org ([198.145.64.141]:41623 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZHMT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:10 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:25 2009
Message-Id: <20090813195124.932621003@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ajit Khaparde <ajitk@serverengines.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/74] be2net: Fix to avoid a crash seen on PPC with LRO and Jumbo frames.
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=be2net-fix-to-avoid-a-crash-seen-on-ppc-with-lro-and-jumbo-frames.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ajit Khaparde <ajitk@serverengines.com>

[ Upstream commit bd46cb6cf11867130a41ea9546dd65688b71f3c2 ]

While testing the driver on PPC, we ran into a crash with LRO, Jumbo frames.
With CONFIG_PPC_64K_PAGES configured (a default in PPC), MAX_SKB_FRAGS drops to 3 and we were crossing the array limits on skb_shinfo(skb)->frags[].
Now we coalesce the frags from the same physical page into one slot in
skb_shinfo(skb)->frags[] and go to the next index when the frag is from

different physical page.

This patch is against the net-2.6 tree.

Signed-off-by: Ajit Khaparde <ajitk@serverengines.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/benet/be.h         |    2 -
 drivers/net/benet/be_ethtool.c |    4 +--
 drivers/net/benet/be_main.c    |   45 +++++++++++++++++++++++++++++------------
 3 files changed, 35 insertions(+), 16 deletions(-)

--- a/drivers/net/benet/be_ethtool.c
+++ b/drivers/net/benet/be_ethtool.c
@@ -162,8 +162,8 @@ be_set_coalesce(struct net_device *netde
 		return -EINVAL;
 
 	adapter->max_rx_coal = coalesce->rx_max_coalesced_frames;
-	if (adapter->max_rx_coal > MAX_SKB_FRAGS)
-		adapter->max_rx_coal = MAX_SKB_FRAGS - 1;
+	if (adapter->max_rx_coal > BE_MAX_FRAGS_PER_FRAME)
+		adapter->max_rx_coal = BE_MAX_FRAGS_PER_FRAME;
 
 	/* if AIC is being turned on now, start with an EQD of 0 */
 	if (rx_eq->enable_aic == 0 &&
--- a/drivers/net/benet/be.h
+++ b/drivers/net/benet/be.h
@@ -73,7 +73,7 @@ static inline char *nic_name(struct pci_
 #define RX_FRAGS_REFILL_WM	(RX_Q_LEN - MAX_RX_POST)
 
 #define BE_MAX_LRO_DESCRIPTORS  16
-#define BE_MAX_FRAGS_PER_FRAME  16
+#define BE_MAX_FRAGS_PER_FRAME  (min((u32) 16, (u32) MAX_SKB_FRAGS))
 
 struct be_dma_mem {
 	void *va;
--- a/drivers/net/benet/be_main.c
+++ b/drivers/net/benet/be_main.c
@@ -682,7 +682,7 @@ static void skb_fill_rx_data(struct be_a
 {
 	struct be_queue_info *rxq = &adapter->rx_obj.q;
 	struct be_rx_page_info *page_info;
-	u16 rxq_idx, i, num_rcvd;
+	u16 rxq_idx, i, num_rcvd, j;
 	u32 pktsize, hdr_len, curr_frag_len;
 	u8 *start;
 
@@ -725,22 +725,33 @@ static void skb_fill_rx_data(struct be_a
 
 	/* More frags present for this completion */
 	pktsize -= curr_frag_len; /* account for above copied frag */
-	for (i = 1; i < num_rcvd; i++) {
+	for (i = 1, j = 0; i < num_rcvd; i++) {
 		index_inc(&rxq_idx, rxq->len);
 		page_info = get_rx_page_info(adapter, rxq_idx);
 
 		curr_frag_len = min(pktsize, rx_frag_size);
 
-		skb_shinfo(skb)->frags[i].page = page_info->page;
-		skb_shinfo(skb)->frags[i].page_offset = page_info->page_offset;
-		skb_shinfo(skb)->frags[i].size = curr_frag_len;
+		/* Coalesce all frags from the same physical page in one slot */
+		if (page_info->page_offset == 0) {
+			/* Fresh page */
+			j++;
+			skb_shinfo(skb)->frags[j].page = page_info->page;
+			skb_shinfo(skb)->frags[j].page_offset =
+							page_info->page_offset;
+			skb_shinfo(skb)->frags[j].size = 0;
+			skb_shinfo(skb)->nr_frags++;
+		} else {
+			put_page(page_info->page);
+		}
+
+		skb_shinfo(skb)->frags[j].size += curr_frag_len;
 		skb->len += curr_frag_len;
 		skb->data_len += curr_frag_len;
-		skb_shinfo(skb)->nr_frags++;
 		pktsize -= curr_frag_len;
 
 		memset(page_info, 0, sizeof(*page_info));
 	}
+	BUG_ON(j > MAX_SKB_FRAGS);
 
 	be_rx_stats_update(adapter, pktsize, num_rcvd);
 	return;
@@ -803,7 +814,7 @@ static void be_rx_compl_process_lro(stru
 	struct skb_frag_struct rx_frags[BE_MAX_FRAGS_PER_FRAME];
 	struct be_queue_info *rxq = &adapter->rx_obj.q;
 	u32 num_rcvd, pkt_size, remaining, vlanf, curr_frag_len;
-	u16 i, rxq_idx = 0, vid;
+	u16 i, rxq_idx = 0, vid, j;
 
 	num_rcvd = AMAP_GET_BITS(struct amap_eth_rx_compl, numfrags, rxcp);
 	pkt_size = AMAP_GET_BITS(struct amap_eth_rx_compl, pktsize, rxcp);
@@ -811,20 +822,28 @@ static void be_rx_compl_process_lro(stru
 	rxq_idx = AMAP_GET_BITS(struct amap_eth_rx_compl, fragndx, rxcp);
 
 	remaining = pkt_size;
-	for (i = 0; i < num_rcvd; i++) {
+	for (i = 0, j = -1; i < num_rcvd; i++) {
 		page_info = get_rx_page_info(adapter, rxq_idx);
 
 		curr_frag_len = min(remaining, rx_frag_size);
 
-		rx_frags[i].page = page_info->page;
-		rx_frags[i].page_offset = page_info->page_offset;
-		rx_frags[i].size = curr_frag_len;
-		remaining -= curr_frag_len;
+		/* Coalesce all frags from the same physical page in one slot */
+		if (i == 0 || page_info->page_offset == 0) {
+			/* First frag or Fresh page */
+			j++;
+			rx_frags[j].page = page_info->page;
+			rx_frags[j].page_offset = page_info->page_offset;
+			rx_frags[j].size = 0;
+		} else {
+			put_page(page_info->page);
+		}
+		rx_frags[j].size += curr_frag_len;
 
+		remaining -= curr_frag_len;
 		index_inc(&rxq_idx, rxq->len);
-
 		memset(page_info, 0, sizeof(*page_info));
 	}
+	BUG_ON(j > MAX_SKB_FRAGS);
 
 	if (likely(!vlanf)) {
 		lro_receive_frags(&adapter->rx_obj.lro_mgr, rx_frags, pkt_size,


