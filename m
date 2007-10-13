Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXJMOuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXJMOuh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 10:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760963AbXJMOmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 10:42:44 -0400
Received: from 1wt.eu ([62.212.114.60]:3006 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761999AbXJMOmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 10:42:42 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20071013143448.%N@1wt.eu>
References: <20071013142822.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 17:28:29 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.21 review 07/35] SNAP: Fix SNAP protocol header accesses.
Content-Disposition: inline; filename=0034-SNAP-Fix-SNAP-protocol-header-accesses.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The snap_rcv code reads 5 bytes so we should make sure that
we have 5 bytes in the head before proceeding.

Based on diagnosis and fix by Evgeniy Polyakov, reported by
Alan J. Wylie.

Patch also kills the skb->sk assignment before kfree_skb
since it's redundant.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/802/psnap.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

Index: 2.6/net/802/psnap.c
===================================================================
--- 2.6.orig/net/802/psnap.c
+++ 2.6/net/802/psnap.c
@@ -55,6 +55,9 @@ static int snap_rcv(struct sk_buff *skb,
 		.type = __constant_htons(ETH_P_SNAP),
 	};
 
+	if (unlikely(!pskb_may_pull(skb, 5)))
+		goto drop;
+
 	rcu_read_lock();
 	proto = find_snap_client(skb->h.raw);
 	if (proto) {
@@ -62,14 +65,18 @@ static int snap_rcv(struct sk_buff *skb,
 		skb->h.raw  += 5;
 		skb_pull_rcsum(skb, 5);
 		rc = proto->rcvfunc(skb, dev, &snap_packet_type, orig_dev);
-	} else {
-		skb->sk = NULL;
-		kfree_skb(skb);
-		rc = 1;
 	}
-
 	rcu_read_unlock();
+
+	if (unlikely(!proto))
+		goto drop;
+
+out:
 	return rc;
+
+drop:
+	kfree_skb(skb);
+	goto out;
 }
 
 /*

-- 
