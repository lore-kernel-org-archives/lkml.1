Return-Path: <linux-kernel-owner+w=401wt.eu-S1765631AbXKOG02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765631AbXKOG02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764900AbXKOGV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:21:57 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:45898 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764891AbXKOGVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:21:55 -0500
Date: Wed, 14 Nov 2007 22:20:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
Message-ID: <20071115062022.GG8282@kroah.com>
References: <20071115055238.692814352@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-skb_with_overhead-calculations.patch"
In-Reply-To: <20071115061806.GA8282@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Herbert Xu <herbert@gondor.apana.org.au>

patch deea84b0ae3d26b41502ae0a39fe7fe134e703d0 in mainline.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/skbuff.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

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

-- 
