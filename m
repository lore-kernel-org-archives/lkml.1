Return-Path: <linux-kernel-owner+w=401wt.eu-S935970AbZLQBfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935970AbZLQBfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936044AbZLQBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:34:38 -0500
Received: from kroah.org ([198.145.64.141]:48026 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763640AbZLQBUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:35 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:04 2009
Message-Id: <20091217011604.615316659@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [51/90] gro: Fix illegal merging of trailer trash
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 69c0cab120a85471054614418b447349caba22d7 ]

When we've merged skb's with page frags, and subsequently receive
a trailer skb (< MSS) that is not completely non-linear (this can
occur on Intel NICs if the packet size falls below the threshold),
GRO ends up producing an illegal GSO skb with a frag_list.

This is harmless unless the skb is then forwarded through an
interface that requires software GSO, whereupon the GSO code
will BUG.

This patch detects this case in GRO and avoids merging the
trailer skb.

Reported-by: Mark Wagner <mwagner@redhat.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/core/skbuff.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2704,7 +2704,8 @@ int skb_gro_receive(struct sk_buff **hea
 
 		NAPI_GRO_CB(skb)->free = 1;
 		goto done;
-	}
+	} else if (skb_gro_len(p) != pinfo->gso_size)
+		return -E2BIG;
 
 	headroom = skb_headroom(p);
 	nskb = netdev_alloc_skb(p->dev, headroom + skb_gro_offset(p));


