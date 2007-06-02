Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXFBCJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXFBCJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 22:09:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759390AbXFBCIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 22:08:54 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:56134 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758877AbXFBCIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 22:08:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id;
        b=N9BNiWBxV31LRH6tJRAu8VqI8xTHgCoPK8k9a9skflHG0G9Y0Uo1BwUykWwrxT9UUB8GyKajq7HaYJPg8GD/OLJ5dLCSFK6Rs0+UZRiKfkARHQ5YOq09Ei2uucFjP2ZxN2fB8eSRWG94bVU6ZYbpqI/VuwZhGuOce9D76l68RcA=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] since the definition of dst_discard_in and dst_discard_out
	are the same, 
Date: Fri, 01 Jun 2007 19:08:51 -0700 (PDT)
Message-ID: <4660d133.4d65d79b.64d5.72fc@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

they should merged into one

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 net/core/dst.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 764bccb..c6a0587 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -111,13 +111,7 @@ out:
 	spin_unlock(&dst_lock);
 }
 
-static int dst_discard_in(struct sk_buff *skb)
-{
-	kfree_skb(skb);
-	return 0;
-}
-
-static int dst_discard_out(struct sk_buff *skb)
+static int dst_discard(struct sk_buff *skb)
 {
 	kfree_skb(skb);
 	return 0;
@@ -138,8 +132,7 @@ void * dst_alloc(struct dst_ops * ops)
 	dst->ops = ops;
 	dst->lastuse = jiffies;
 	dst->path = dst;
-	dst->input = dst_discard_in;
-	dst->output = dst_discard_out;
+	dst->input = dst->output = dst_discard;
 #if RT_CACHE_DEBUG >= 2
 	atomic_inc(&dst_total);
 #endif
@@ -153,8 +146,7 @@ static void ___dst_free(struct dst_entry * dst)
 	   protocol module is unloaded.
 	 */
 	if (dst->dev == NULL || !(dst->dev->flags&IFF_UP)) {
-		dst->input = dst_discard_in;
-		dst->output = dst_discard_out;
+		dst->input = dst->output = dst_discard;
 	}
 	dst->obsolete = 2;
 }
@@ -242,8 +234,7 @@ static inline void dst_ifdown(struct dst_entry *dst, struct net_device *dev,
 		return;
 
 	if (!unregister) {
-		dst->input = dst_discard_in;
-		dst->output = dst_discard_out;
+		dst->input = dst->output = dst_discard;
 	} else {
 		dst->dev = &loopback_dev;
 		dev_hold(&loopback_dev);
-- 
1.4.4.2

