Return-Path: <linux-kernel-owner+w=401wt.eu-S934167AbXKOHNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934167AbXKOHNu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 02:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933340AbXKOHAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 02:00:53 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51520
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933341AbXKOHAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 02:00:51 -0500
Date: Wed, 14 Nov 2007 23:00:39 -0800 (PST)
Message-Id: <20071114.230039.114721276.davem@davemloft.net>
To: herbert@gondor.apana.org.au
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org,
       jmforbes@linuxtx.org, zwane@arm.linux.org.uk, tytso@mit.edu,
       rdunlap@xenotime.net, davej@redhat.com, chuckw@quantumlinux.com,
       reviews@ml.cw.f00f.org, mkrufky@linuxtv.org, cebbert@redhat.com,
       cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org
Subject: Re: [patch 06/23] Fix SKB_WITH_OVERHEAD calculations.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071115062939.GA23579@gondor.apana.org.au>
References: <20071115055238.692814352@mini.kroah.org>
	<20071115062022.GG8282@kroah.com>
	<20071115062939.GA23579@gondor.apana.org.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 15 Nov 2007 14:29:39 +0800

> On Wed, Nov 14, 2007 at 10:20:22PM -0800, Greg KH wrote:
> > -stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > patch deea84b0ae3d26b41502ae0a39fe7fe134e703d0 in mainline.
> > 
> > [NET]: Fix SKB_WITH_OVERHEAD calculation
> 
> Although this is correct as it is, it tirggers a latent bug
> which is fixed by
> 
> commit fb93134dfc2a6e6fbedc7c270a31da03fce88db9
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Wed Nov 14 15:45:21 2007 -0800
> 
>     [TCP]: Fix size calculation in sk_stream_alloc_pskb
> 
> So please postpone it to the next round such that both patches
> can be included together.

I was just about to mention this and what I think we should do
instead is keep the SKB_WITH_OVERHEAD calculation fix in there
(it fixes a serious bug which users are hitting) and add the
fix for the second bug fix this round as well.

Therefore, Greg please keep the patch add the following one as it will
address all of the issues.

[TCP]: Fix size calculation in sk_stream_alloc_pskb

[ Upstream commit: fb93134dfc2a6e6fbedc7c270a31da03fce88db9 ]

We round up the header size in sk_stream_alloc_pskb so that
TSO packets get zero tail room.  Unfortunately this rounding
up is not coordinated with the select_size() function used by
TCP to calculate the second parameter of sk_stream_alloc_pskb.

As a result, we may allocate more than a page of data in the
non-TSO case when exactly one page is desired.

In fact, rounding up the head room is detrimental in the non-TSO
case because it makes memory that would otherwise be available to
the payload head room.  TSO doesn't need this either, all it wants
is the guarantee that there is no tail room.

So this patch fixes this by adjusting the skb_reserve call so that
exactly the requested amount (which all callers have calculated in
a precise way) is made available as tail room.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/include/net/sock.h b/include/net/sock.h
index 5504fb9..567e468 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1235,14 +1235,16 @@ static inline struct sk_buff *sk_stream_alloc_pskb(struct sock *sk,
 						   gfp_t gfp)
 {
 	struct sk_buff *skb;
-	int hdr_len;
 
-	hdr_len = SKB_DATA_ALIGN(sk->sk_prot->max_header);
-	skb = alloc_skb_fclone(size + hdr_len, gfp);
+	skb = alloc_skb_fclone(size + sk->sk_prot->max_header, gfp);
 	if (skb) {
 		skb->truesize += mem;
 		if (sk_stream_wmem_schedule(sk, skb->truesize)) {
-			skb_reserve(skb, hdr_len);
+			/*
+			 * Make sure that we have exactly size bytes
+			 * available to the caller, no more, no less.
+			 */
+			skb_reserve(skb, skb_tailroom(skb) - size);
 			return skb;
 		}
 		__kfree_skb(skb);
