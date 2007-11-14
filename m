Return-Path: <linux-kernel-owner+w=401wt.eu-S1756349AbXKNLKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbXKNLKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbXKNLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:10:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59905
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751462AbXKNLKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:10:23 -0500
Date: Wed, 14 Nov 2007 03:10:22 -0800 (PST)
Message-Id: <20071114.031022.183117678.davem@davemloft.net>
To: nickpiggin@yahoo.com.au
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression
 with tbench
From: David Miller <davem@davemloft.net>
In-Reply-To: <200711140927.39796.nickpiggin@yahoo.com.au>
References: <200711140514.28159.nickpiggin@yahoo.com.au>
	<20071113.223726.40898879.davem@davemloft.net>
	<200711140927.39796.nickpiggin@yahoo.com.au>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nick Piggin <nickpiggin@yahoo.com.au>
Date: Wed, 14 Nov 2007 09:27:39 +1100

> OK, in vanilla kernels, the page allocator definitely shows higher
> in the results (than with Herbert's patch reverted).
 ...
> I can't see that these numbers show much useful, unfortunately.

Thanks for all of this data Nick.

So the thing that's being effected here in TCP is
net/ipv4/tcp.c:select_size(), specifically the else branch:

	int tmp = tp->mss_cache;
 ...
		else {
			int pgbreak = SKB_MAX_HEAD(MAX_TCP_HEADER);

			if (tmp >= pgbreak &&
			    tmp <= pgbreak + (MAX_SKB_FRAGS - 1) * PAGE_SIZE)
				tmp = pgbreak;
		}

This is deciding, in 'tmp', how much linear sk_buff space to
allocate.  'tmp' is initially set to the path MSS, which
for loopback is 16K - the space necessary for packet headers.

The SKB_MAX_HEAD() value has changed as a result of Herbert's
bug fix.   I suspect this 'if' test is passing both with and
without the patch.

But pgbreak is now smaller, and thus the skb->data linear
data area size we choose to use is smaller as well.

You can test if this is precisely what is causing the performance
regression by using the old calculation just here in select_size().

Add something like this local to net/ipv4/tcp.c:

#define OLD_SKB_WITH_OVERHEAD(X)	\
	(((X) - sizeof(struct skb_shared_info)) & \
	 ~(SMP_CACHE_BYTES - 1))
#define OLD_SKB_MAX_ORDER(X, ORDER) \
	OLD_SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
#define OLD_SKB_MAX_HEAD(X)		(OLD_SKB_MAX_ORDER((X), 0))

And then use OLD_SKB_MAX_HEAD() in select_size().
