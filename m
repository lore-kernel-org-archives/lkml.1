Return-Path: <linux-kernel-owner+w=401wt.eu-S1030964AbXD2RgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030964AbXD2RgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 13:36:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXD2Rbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 13:31:32 -0400
Received: from gw.goop.org ([64.81.55.164]:58979 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754414AbXD2Raa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 13:30:30 -0400
Message-Id: <20070429172916.237274000@goop.org>
References: <20070429172835.284784000@goop.org>
User-Agent: quilt/0.46-1
Date: Sun, 29 Apr 2007 10:29:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Subject: [patch 28/32] xen: xen-netfront: use skb.cb for storing private data
Content-Disposition: inline; filename=xen-netfront-use-cb.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Netfront's use of nh.raw and h.raw for storing page+offset is a bit
hinky, and it breaks with upcoming network stack updates which reduce
these fields to sub-pointer sizes.  Fortunately, skb offers the "cb"
field specifically for stashing this kind of info, so use it.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>

---
 drivers/net/xen-netfront.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

===================================================================
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -52,6 +52,13 @@
 #include <xen/page.h>
 #include <xen/grant_table.h>
 
+struct netfront_cb {
+	struct page *page;
+	unsigned offset;
+};
+
+#define NETFRONT_SKB_CB(skb)	((struct netfront_cb *)((skb)->cb))
+
 /*
  * Mutually-exclusive module options to select receive data path:
  *  rx_copy : Packets are copied by network backend into local memory
@@ -944,10 +951,11 @@ static void handle_incoming_queue(struct
 	struct sk_buff *skb;
 
 	while ((skb = __skb_dequeue(rxq)) != NULL) {
-		struct page *page = (struct page *)skb->nh.raw;
+		struct page *page = NETFRONT_SKB_CB(skb)->page;
 		void *vaddr = page_address(page);
-
-		memcpy(skb->data, vaddr + (skb->h.raw - skb->nh.raw),
+		unsigned offset = NETFRONT_SKB_CB(skb)->offset;
+
+		memcpy(skb->data, vaddr + offset,
 		       skb_headlen(skb));
 
 		if (page != skb_shinfo(skb)->frags[0].page)
@@ -1251,8 +1259,8 @@ err:
 			}
 		}
 
-		skb->nh.raw = (void *)skb_shinfo(skb)->frags[0].page;
-		skb->h.raw = skb->nh.raw + rx->offset;
+		NETFRONT_SKB_CB(skb)->page = skb_shinfo(skb)->frags[0].page;
+		NETFRONT_SKB_CB(skb)->offset = rx->offset;
 
 		len = rx->status;
 		if (len > RX_COPY_THRESHOLD)

-- 

