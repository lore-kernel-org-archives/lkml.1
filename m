Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbXE1Kf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbXE1Kf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 06:35:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753379AbXE1KfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 06:35:17 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:34826 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXE1KfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 06:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MU3aJe3pt7VakJ4T24NydNiu/jJRKtdTVw7uaHEMtg9YQqC9scmoFAoFlFT8RA00U6N28e9cuUXYPOB2syFV2f+al26/4ZzAl2cwVAFs9bYxhLTA5tdaPKwnQ6gE+ylUaBx4cbDBtqMMm6LiHq/y3saivPFMqjjsfq6AMTDkeYQ=
Message-ID: <91b13c310705280335k1f7d442cjdc874a3198c8acfc@mail.gmail.com>
Date: Mon, 28 May 2007 18:35:12 +0800
From: "rae l" <crquan@gmail.com>
To: "Jan Engelhardt" <jengelh@linux01.gwdg.de>
Subject: [PATCH] merge dst_discard in & out into one, this decrements the vmlinux image by 21 bytes under i386 arch.
Cc: "David S. Miller" <davem@davemloft.net>,
       "Networking Team" <netdev@vger.kernel.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Adrian Bunk" <trivial@kernel.org>
In-Reply-To: <Pine.LNX.4.61.0705281150010.11140@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <91b13c310705271941n48e266b9vc202b862ad4fabba@mail.gmail.com>
	 <Pine.LNX.4.61.0705281150010.11140@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> Uhm, just replace every invocation of dst_discard_in/_out() directly
> by dst_discard ... don't add macros for that.
so that, the trival patch changed to this:

because the definition of dst_discard_in and dst_discard_out are the
same, so they merged into one.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---

diff --git a/net/core/dst.c b/net/core/dst.c
index 764bccb..c6a0587 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -111,13 +111,7 @@ out:
        spin_unlock(&dst_lock);
 }

-static int dst_discard_in(struct sk_buff *skb)
-{
-       kfree_skb(skb);
-       return 0;
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
-       dst->input = dst_discard_in;
-       dst->output = dst_discard_out;
+       dst->input = dst->output = dst_discard;
 #if RT_CACHE_DEBUG >= 2
        atomic_inc(&dst_total);
 #endif
@@ -153,8 +146,7 @@ static void ___dst_free(struct dst_entry * dst)
           protocol module is unloaded.
         */
        if (dst->dev == NULL || !(dst->dev->flags&IFF_UP)) {
-               dst->input = dst_discard_in;
-               dst->output = dst_discard_out;
+               dst->input = dst->output = dst_discard;
        }
        dst->obsolete = 2;
 }
@@ -242,8 +234,7 @@ static inline void dst_ifdown(struct dst_entry
*dst, struct net_device *dev,
                return;

        if (!unregister) {
-               dst->input = dst_discard_in;
-               dst->output = dst_discard_out;
+               dst->input = dst->output = dst_discard;
        } else {
                dst->dev = &loopback_dev;
                dev_hold(&loopback_dev);


-- 
Denis Cheng
Linux Application Developer
