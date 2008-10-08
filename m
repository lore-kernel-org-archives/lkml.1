Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYJHTf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYJHTf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbYJHTfr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:35:47 -0400
Received: from mail27.svc.cra.dublin.eircom.net ([159.134.118.223]:37703 "HELO
	mail27.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752045AbYJHTfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:35:47 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 1/2] virtio_net: Recycle some more rx buffer pages
Date: Wed,  8 Oct 2008 20:34:58 +0100
Message-Id: <1223494499-18732-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each time we re-fill the recv queue with buffers, we allocate
one too many skbs and free it again when adding fails. We should
recycle the pages allocated in this case.

A previous version of this patch made trim_pages() trim trailing
unused pages from skbs with some paged data, but this actually
caused a barely measurable slowdown.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/net/virtio_net.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0196a0d..985271a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -82,6 +82,16 @@ static void give_a_page(struct virtnet_info *vi, struct page *page)
 	vi->pages = page;
 }
 
+static void trim_pages(struct virtnet_info *vi, struct sk_buff *skb)
+{
+	unsigned int i;
+
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
+		give_a_page(vi, skb_shinfo(skb)->frags[i].page);
+	skb_shinfo(skb)->nr_frags = 0;
+	skb->data_len = 0;
+}
+
 static struct page *get_a_page(struct virtnet_info *vi, gfp_t gfp_mask)
 {
 	struct page *p = vi->pages;
@@ -121,14 +131,8 @@ static void receive_skb(struct net_device *dev, struct sk_buff *skb,
 	}
 	len -= sizeof(struct virtio_net_hdr);
 
-	if (len <= MAX_PACKET_LEN) {
-		unsigned int i;
-
-		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++)
-			give_a_page(dev->priv, skb_shinfo(skb)->frags[i].page);
-		skb->data_len = 0;
-		skb_shinfo(skb)->nr_frags = 0;
-	}
+	if (len <= MAX_PACKET_LEN)
+		trim_pages(dev->priv, skb);
 
 	err = pskb_trim(skb, len);
 	if (err) {
@@ -232,6 +236,7 @@ static void try_fill_recv(struct virtnet_info *vi)
 		err = vi->rvq->vq_ops->add_buf(vi->rvq, sg, 0, num, skb);
 		if (err) {
 			skb_unlink(skb, &vi->recv);
+			trim_pages(vi, skb);
 			kfree_skb(skb);
 			break;
 		}
-- 
1.5.4.3

