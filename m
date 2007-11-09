Return-Path: <linux-kernel-owner+w=401wt.eu-S1764658AbXKIXqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764658AbXKIXqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:46:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764194AbXKIXqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:46:24 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37054 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764192AbXKIXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:46:22 -0500
Date: Fri, 9 Nov 2007 15:46:20 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "David S. Miller" <davem@davemloft.net>,
       Herbert Xu <herbert@gondor.apana.org.au>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: 2.6.24-rc2: Network commit causes SLUB performance regression with
 tbench
In-Reply-To: <Pine.LNX.4.64.0711090928270.14601@schroedinger.engr.sgi.com>
Message-ID: <Pine.LNX.4.64.0711091533300.17621@schroedinger.engr.sgi.com>
References: <200711092336.56172.nickpiggin@yahoo.com.au>
 <Pine.LNX.4.64.0711090712440.13823@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0711090928270.14601@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

commit deea84b0ae3d26b41502ae0a39fe7fe134e703d0 seems to cause a drop
in SLUB tbench performance:

8p x86_64 system:

2.6.24-rc2:
	1260.80 MB/sec

After reverting the patch:
	2350.04 MB/sec

SLAB performance (which is at 2435.58 MB/sec, ~3% better than SLUB) is not 
affected by the patch.

Since this is an alignment change it seems that tbench performance is 
sensitive to the data layout? SLUB packs data more tightly than SLAB. So 
8 byte allocations could result in cacheline contention if adjacent 
objects are allocated from different cpus. SLABs minimum size is 32 
bytes so the cacheline contention is likely more limited.

Maybe we need to allocate a mininum of one cacheline to the skb head? Or 
padd it out to a full cacheline?




commit deea84b0ae3d26b41502ae0a39fe7fe134e703d0
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun Oct 21 16:27:46 2007 -0700

    [NET]: Fix SKB_WITH_OVERHEAD calculation

    The calculation in SKB_WITH_OVERHEAD is incorrect in that it can cause
    an overflow across a page boundary which is what it's meant to prevent.
    In particular, the header length (X) should not be lumped together with
    skb_shared_info.  The latter needs to be aligned properly while the header
    has no choice but to sit in front of wherever the payload is.

    Therefore the correct calculation is to take away the aligned size of
    skb_shared_info, and then subtract the header length.  The resulting
    quantity L satisfies the following inequality:

        SKB_DATA_ALIGN(L + X) + sizeof(struct skb_shared_info) <= PAGE_SIZE

    This is the quantity used by alloc_skb to do the actual allocation.

    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f93f22b..369f60a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -41,8 +41,7 @@
 #define SKB_DATA_ALIGN(X)      (((X) + (SMP_CACHE_BYTES - 1)) & \
                                 ~(SMP_CACHE_BYTES - 1))
 #define SKB_WITH_OVERHEAD(X)   \
-       (((X) - sizeof(struct skb_shared_info)) & \
-        ~(SMP_CACHE_BYTES - 1))
+       ((X) - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 #define SKB_MAX_ORDER(X, ORDER) \
        SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
 #define SKB_MAX_HEAD(X)                (SKB_MAX_ORDER((X), 0))

