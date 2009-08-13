Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZHMUOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZHMUOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755869AbZHMUOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:14:40 -0400
Received: from kroah.org ([198.145.64.141]:41661 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZHMT7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:17 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.055293320@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 10/74] gso: Stop fraglists from escaping
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=gso-stop-fraglists-from-escaping.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 278b2513f76161a9cf1ebddd620dc9d1714fe573 ]

As it stands skb fraglists can get past the check in dev_queue_xmit
if the skb is marked as GSO.  In particular, if the packet doesn't
have the proper checksums for GSO, but can otherwise be handled by
the underlying device, we will not perform the fraglist check on it
at all.

If the underlying device cannot handle fraglists, then this will
break.

The fix is as simple as moving the fraglist check from the device
check into skb_gso_ok.

This has caused crashes with Xen when used together with GRO which
can generate GSO packets with fraglists.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/netdevice.h |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1856,15 +1856,14 @@ static inline int net_gso_ok(int feature
 
 static inline int skb_gso_ok(struct sk_buff *skb, int features)
 {
-	return net_gso_ok(features, skb_shinfo(skb)->gso_type);
+	return net_gso_ok(features, skb_shinfo(skb)->gso_type) &&
+	       (!skb_shinfo(skb)->frag_list || (features & NETIF_F_FRAGLIST));
 }
 
 static inline int netif_needs_gso(struct net_device *dev, struct sk_buff *skb)
 {
 	return skb_is_gso(skb) &&
 	       (!skb_gso_ok(skb, dev->features) ||
-	        (skb_shinfo(skb)->frag_list &&
-	         !(dev->features & NETIF_F_FRAGLIST)) ||
 		unlikely(skb->ip_summed != CHECKSUM_PARTIAL));
 }
 


