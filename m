Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbXKHJIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbXKHJIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 04:08:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXKHJIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 04:08:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45889
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753450AbXKHJIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:08:39 -0500
Date: Thu, 08 Nov 2007 01:08:38 -0800 (PST)
Message-Id: <20071108.010838.266803185.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: frankvm@frankvm.com, linux-kernel@vger.kernel.org
Subject: Re: VM/networking crash cause #1: page allocation failure
 (order:1, GFP_ATOMIC)
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711081655.38371.nickpiggin@yahoo.com.au>
References: <200711070901.17839.nickpiggin@yahoo.com.au>
	<20071107134843.GA14000@janus>
	<200711081655.38371.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Thu, 8 Nov 2007 16:55:38 +1100

> But it's an order-1 allocation, which may not be available due to
> fragmentation.

If the user is using an MTU of only 1500 (and thus not using
jumbo frames) he may be being bitten by a bug that was recently
fixed by Herbert Xu that made us use order > 0 pages accidently.

His fix is below:

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
 #define SKB_DATA_ALIGN(X)	(((X) + (SMP_CACHE_BYTES - 1)) & \
 				 ~(SMP_CACHE_BYTES - 1))
 #define SKB_WITH_OVERHEAD(X)	\
-	(((X) - sizeof(struct skb_shared_info)) & \
-	 ~(SMP_CACHE_BYTES - 1))
+	((X) - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
 #define SKB_MAX_ORDER(X, ORDER) \
 	SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
 #define SKB_MAX_HEAD(X)		(SKB_MAX_ORDER((X), 0))
