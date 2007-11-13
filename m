Return-Path: <linux-kernel-owner+w=401wt.eu-S1757246AbXKNLl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbXKNLl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbXKNLlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:41:46 -0500
Received: from smtp109.mail.mud.yahoo.com ([209.191.85.219]:25948 "HELO
	smtp109.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751801AbXKNLlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:41:45 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X1OVurZci5NW3Uwcg3+1UbYlr89LpOIG5vQ04jmDQDqlGbypZVPfbwZR7RmtTey3JeXwPlrGV9qkb9kvA8n7VM9dV0+KExxNr1+nWZHr0hYb5pQZO8q1uIgNrz+HOMG2+qCzi9kZvoX4N0TCTKuTK/A34ap2JqgipYEK3NWuY9g=  ;
X-YMail-OSG: zOZ8a3UVM1lfSdK.RBj85QZtgiEDeAqKGzMmMalmyYRV4t7MkmYHDLEmOSH5TR72TmdPeYPl9w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: 2.6.24-rc2: Network commit causes SLUB performance regression with tbench
Date: Wed, 14 Nov 2007 10:39:22 +1100
User-Agent: KMail/1.9.5
Cc: clameter@sgi.com, netdev@vger.kernel.org, herbert@gondor.apana.org.au,
       linux-kernel@vger.kernel.org
References: <200711140514.28159.nickpiggin@yahoo.com.au> <200711140927.39796.nickpiggin@yahoo.com.au> <20071114.031022.183117678.davem@davemloft.net>
In-Reply-To: <20071114.031022.183117678.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711141039.22758.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 22:10, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 14 Nov 2007 09:27:39 +1100
>
> > OK, in vanilla kernels, the page allocator definitely shows higher
> > in the results (than with Herbert's patch reverted).
>
>  ...
>
> > I can't see that these numbers show much useful, unfortunately.
>
> Thanks for all of this data Nick.
>
> So the thing that's being effected here in TCP is
> net/ipv4/tcp.c:select_size(), specifically the else branch:
>
> 	int tmp = tp->mss_cache;
>  ...
> 		else {
> 			int pgbreak = SKB_MAX_HEAD(MAX_TCP_HEADER);
>
> 			if (tmp >= pgbreak &&
> 			    tmp <= pgbreak + (MAX_SKB_FRAGS - 1) * PAGE_SIZE)
> 				tmp = pgbreak;
> 		}
>
> This is deciding, in 'tmp', how much linear sk_buff space to
> allocate.  'tmp' is initially set to the path MSS, which
> for loopback is 16K - the space necessary for packet headers.
>
> The SKB_MAX_HEAD() value has changed as a result of Herbert's
> bug fix.   I suspect this 'if' test is passing both with and
> without the patch.
>
> But pgbreak is now smaller, and thus the skb->data linear
> data area size we choose to use is smaller as well.

OK, that makes sense. BTW, are you taking advantage of kmalloc's
"quantization" into slabs WRT the linear data area? I wonder if
it would be at all useful...


> You can test if this is precisely what is causing the performance
> regression by using the old calculation just here in select_size().
>
> Add something like this local to net/ipv4/tcp.c:
>
> #define OLD_SKB_WITH_OVERHEAD(X)	\
> 	(((X) - sizeof(struct skb_shared_info)) & \
> 	 ~(SMP_CACHE_BYTES - 1))
> #define OLD_SKB_MAX_ORDER(X, ORDER) \
> 	OLD_SKB_WITH_OVERHEAD((PAGE_SIZE << (ORDER)) - (X))
> #define OLD_SKB_MAX_HEAD(X)		(OLD_SKB_MAX_ORDER((X), 0))
>
> And then use OLD_SKB_MAX_HEAD() in select_size().

That brings performance back up!

I wonder why it isn't causing a problem for SLAB...
