Return-Path: <linux-kernel-owner+w=401wt.eu-S1757744AbYDXE60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744AbYDXE60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 00:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754609AbYDXE47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 00:56:59 -0400
Received: from ozlabs.org ([203.10.76.45]:58767 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683AbYDXE45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 00:56:57 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 23 Apr 2008 23:56:47 -0500
Cc: virtualization@lists.linux-foundation.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] virtio: fix scatterlist sizing in net driver.
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241456.47476.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Herbert Xu points out (within another patch) that my scatterlists are
too short: one entry for the gso header, one for the skb->data, and
MAX_SKB_FRAGS for all the fragments.

Fix both xmit and recv sides (recv currently unused, coming in later
patch).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/net/virtio_net.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -r 86488a1161d2 drivers/net/virtio_net.c
--- a/drivers/net/virtio_net.c	Tue Apr 22 07:59:24 2008 +1000
+++ b/drivers/net/virtio_net.c	Tue Apr 22 12:56:20 2008 +1000
@@ -142,10 +142,10 @@ static void try_fill_recv(struct virtnet
 static void try_fill_recv(struct virtnet_info *vi)
 {
 	struct sk_buff *skb;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
+	struct scatterlist sg[2+MAX_SKB_FRAGS];
 	int num, err;
 
-	sg_init_table(sg, 1+MAX_SKB_FRAGS);
+	sg_init_table(sg, 2+MAX_SKB_FRAGS);
 	for (;;) {
 		skb = netdev_alloc_skb(vi->dev, MAX_PACKET_LEN);
 		if (unlikely(!skb))
@@ -231,11 +231,11 @@ static int start_xmit(struct sk_buff *sk
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	int num, err;
-	struct scatterlist sg[1+MAX_SKB_FRAGS];
+	struct scatterlist sg[2+MAX_SKB_FRAGS];
 	struct virtio_net_hdr *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
 
-	sg_init_table(sg, 1+MAX_SKB_FRAGS);
+	sg_init_table(sg, 2+MAX_SKB_FRAGS);
 
 	pr_debug("%s: xmit %p " MAC_FMT "\n", dev->name, skb,
 		 dest[0], dest[1], dest[2],

