Return-Path: <linux-kernel-owner+w=401wt.eu-S1759555AbXEaH1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555AbXEaH1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 03:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756700AbXEaH1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 03:27:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:58206 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbXEaH1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 03:27:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=AYqqxyWyezECkEvH8/ZHBb1BEsPklMrnTtZ/8F9aF4R9+z8Eo/MqEWkpljpNzaDPv0m2FCDO/yKV46of16Fs4bxzsI7bKl//y3uigpkxgIIN6NPMyh669r1Al7YzprUHGwj4SRue2Rn549Y174T+pBszflryIiYO7Igoc7/vtik=
Message-ID: <465E78BE.6010807@gmail.com>
Date: Thu, 31 May 2007 15:26:54 +0800
From: Rankle_ <crquan@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: netdev@vger.kernel.org
CC: linux-kernel@vger.kernel.org
Subject: [git patch] since the definition of dst_discard_in and dst_discard_out
 are the same,,they should merged into one
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 From 30d6996860f7e5589d1bce10404bbcfd6592c9de Mon Sep 17 00:00:00 2001
From: Denis Cheng <crquan@gmail.com>
Date: Thu, 31 May 2007 15:21:58 +0800
Subject: [PATCH] since the definition of dst_discard_in and 
dst_discard_out are the same,
they should merged into one

Signed-off-by: Denis Cheng <crquan@gmail.com>

diff --git a/net/core/dst.c b/net/core/dst.c
index 764bccb..c6a0587 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -111,13 +111,7 @@ out:
     spin_unlock(&dst_lock);
 }
 
-static int dst_discard_in(struct sk_buff *skb)
-{
-    kfree_skb(skb);
-    return 0;
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
-    dst->input = dst_discard_in;
-    dst->output = dst_discard_out;
+    dst->input = dst->output = dst_discard;
 #if RT_CACHE_DEBUG >= 2
     atomic_inc(&dst_total);
 #endif
@@ -153,8 +146,7 @@ static void ___dst_free(struct dst_entry * dst)
        protocol module is unloaded.
      */
     if (dst->dev == NULL || !(dst->dev->flags&IFF_UP)) {
-        dst->input = dst_discard_in;
-        dst->output = dst_discard_out;
+        dst->input = dst->output = dst_discard;
     }
     dst->obsolete = 2;
 }
@@ -242,8 +234,7 @@ static inline void dst_ifdown(struct dst_entry *dst, 
struct net_device *dev,
         return;
 
     if (!unregister) {
-        dst->input = dst_discard_in;
-        dst->output = dst_discard_out;
+        dst->input = dst->output = dst_discard;
     } else {
         dst->dev = &loopback_dev;
         dev_hold(&loopback_dev);
