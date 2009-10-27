Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbZJ0CRE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbZJ0CRE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:17:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZJ0CRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:17:03 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:36309 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbZJ0CRC (ORCPT
	<rfc822;groupwise-PMullaney@novell.com;0:0>);
	Mon, 26 Oct 2009 22:17:02 -0400
From: Patrick Mullaney <pmullaney@novell.com>
Subject: [PATCH] vbus-enet: fix l4ro pool non-atomic allocations in softirq
	context
To: linux-kernel@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net
Date: Mon, 26 Oct 2009 22:17:01 -0400
Message-ID: <20091027021701.20826.67034.stgit@mimic.site>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code exhibits odd behavior in the guest when receiving L4RO
packets. This was tracked down to the improper allocation of
GFP_KERNEL memory from softirq context


Signed-off-by: Patrick Mullaney <pmullaney@novell.com>
---

 drivers/net/vbus-enet.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/vbus-enet.c b/drivers/net/vbus-enet.c
index 228c366..6aaee1c 100644
--- a/drivers/net/vbus-enet.c
+++ b/drivers/net/vbus-enet.c
@@ -182,11 +182,11 @@ rxdesc_alloc(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc, size_t len
 }
 
 static void
-rx_pageq_refill(struct vbus_enet_priv *priv)
+rx_pageq_refill(struct vbus_enet_priv *priv, gfp_t gfp_mask)
 {
 	struct ioq *ioq = priv->l4ro.pageq.queue;
 	struct ioq_iterator iter;
-	int ret;
+	int ret, added = 0;
 
 	if (ioq_full(ioq, ioq_idxtype_inuse))
 		/* nothing to do if the pageq is already fully populated */
@@ -202,11 +202,14 @@ rx_pageq_refill(struct vbus_enet_priv *priv)
 	 * Now populate each descriptor with an empty page
 	 */
 	while (!iter.desc->sown) {
-		struct page *page;
+		struct page *page = NULL;
+
+		page = alloc_page(gfp_mask);
 
-		page = alloc_page(GFP_KERNEL);
-		BUG_ON(!page);
+		if (!page)
+			break;
 
+		added = 1;
 		iter.desc->cookie = (u64)page;
 		iter.desc->ptr    = (u64)__pa(page_address(page));
 		iter.desc->len    = PAGE_SIZE;
@@ -215,7 +218,8 @@ rx_pageq_refill(struct vbus_enet_priv *priv)
 		BUG_ON(ret < 0);
 	}
 
-	ioq_signal(ioq, 0);
+	if (added)
+		ioq_signal(ioq, 0);
 }
 
 static void
@@ -271,7 +275,7 @@ rx_setup(struct vbus_enet_priv *priv)
 	}
 
 	if (priv->l4ro.available)
-		rx_pageq_refill(priv);
+		rx_pageq_refill(priv, GFP_KERNEL);
 }
 
 static void
@@ -602,7 +606,7 @@ vbus_enet_l4ro_import(struct vbus_enet_priv *priv, struct ioq_ring_desc *desc)
 	struct skb_shared_info *sinfo = skb_shinfo(skb);
 	int i;
 
-	rx_pageq_refill(priv);
+	rx_pageq_refill(priv, GFP_ATOMIC);
 
 	if (!vsg->len)
 		/*

