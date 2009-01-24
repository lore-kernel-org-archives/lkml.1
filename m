Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbZAXALT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbZAXALT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 19:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZAXALA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 19:11:00 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:37183 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbZAXAK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 19:10:59 -0500
Date: Fri, 23 Jan 2009 16:10:53 -0800
From: Ira Snyder <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] virtio_net: use correct accessors for scatterlists
Message-ID: <20090124001053.GA20156@ovro.caltech.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Mark McLoughlin <markmc@redhat.com>,
	Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 23 Jan 2009 16:10:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this fix, virtio_net makes incorrect usage of scatterlists. It sets
the end of the scatterlist chain after the first element, despite the fact
that more entries come after it.

If you try to run dma_map_sg() on one of the scatterlists given to you by
add_buf(), you will get a null pointer oops.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---

I found this problem while working on implementing virtio-over-PCI as
suggested by Arnd Bergmann, David Miller, and others.

 drivers/net/virtio_net.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 43f6523..67ea2cf 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -286,7 +286,7 @@ static void try_fill_recv_maxbufs(struct virtnet_info *vi)
 		skb_put(skb, MAX_PACKET_LEN);
 
 		hdr = skb_vnet_hdr(skb);
-		sg_init_one(sg, hdr, sizeof(*hdr));
+		sg_set_buf(sg, hdr, sizeof(*hdr));
 
 		if (vi->big_packets) {
 			for (i = 0; i < MAX_SKB_FRAGS; i++) {
@@ -487,9 +487,9 @@ static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 
 	/* Encode metadata header at front. */
 	if (vi->mergeable_rx_bufs)
-		sg_init_one(sg, mhdr, sizeof(*mhdr));
+		sg_set_buf(sg, mhdr, sizeof(*mhdr));
 	else
-		sg_init_one(sg, hdr, sizeof(*hdr));
+		sg_set_buf(sg, hdr, sizeof(*hdr));
 
 	num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
 
-- 
1.5.4.3

