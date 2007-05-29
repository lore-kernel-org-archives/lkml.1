Return-Path: <linux-kernel-owner+w=401wt.eu-S1764587AbXE2LR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764587AbXE2LR7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 07:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800AbXE2LRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 07:17:49 -0400
Received: from ik-out-1112.google.com ([66.249.90.181]:29921 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbXE2LRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 07:17:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=dd9S7vqV9m5haLS/HqChaaP7fiVy8Jjiod9/KWTu0Y2oXofH03lC3ZgToINh/MF6geJauzLwUE0A8z3IBX/KcHlLSXBBELWMdosHIYcGqUO2R3sPbC6VRTuMTXgaAZCA3RctVaa0WZG38qYd9/NZxSlXNn8Qhq2laUOqf1sPrNw=
Message-ID: <91b13c310705290417u4bf9cdedif07a0e907acd3108@mail.gmail.com>
Date: Tue, 29 May 2007 19:17:46 +0800
From: "rae l" <crquan@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH] merge dst_discard in & out into one, removed a duplicate function
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/07, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> Uhm, just replace every invocation of dst_discard_in/_out() directly
> by dst_discard ... don't add macros for that.

merge dst_discard in & out into one, this removed a duplicate function.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---

Is there anybody also found this duplicate? I found this duplcate had
existed from linux-2.2 linux-2.4 to the latest kernel tree, you could
check it in the lxr site conveniently:
http://lxr.linux.no/source/net/core/dst.c?v=2.2.26
http://lxr.linux.no/source/net/core/dst.c?v=2.4.18
http://lxr.linux.no/source/net/core/dst.c
With little difference, the 2.2 and 2.4 version use two different
function name: dst_discard and dst_blackhole, but the definition of
them are the same, so they are  same substantially. Additionally, the
two same function are two local(static) functions in a single file
dst.c, I don't know why there should exist two same functions. I
wonder what the consideration of this design is, because I'm just a
kernel newbie; this problem has been confusing me for many days, so if
you know why, please drop me some directions.

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
