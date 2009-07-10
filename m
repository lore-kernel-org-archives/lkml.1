Return-Path: <linux-kernel-owner+w=401wt.eu-S1753076AbZGJIAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076AbZGJIAl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 04:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJIAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 04:00:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:27435 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZGJIA3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 04:00:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,377,1243839600"; 
   d="scan'208";a="163525898"
Date: Fri, 10 Jul 2009 16:00:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: David Miller <davem@davemloft.net>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
	usage
Message-ID: <20090710080017.GA24168@localhost>
References: <20090608023757.GA6244@localhost> <20090706105216.GA19124@gondor.apana.org.au> <20090709131746.GA27965@localhost> <20090709.171355.09466097.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090709.171355.09466097.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 08:13:55AM +0800, David Miller wrote:
> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Thu, 9 Jul 2009 21:17:46 +0800
> 
> > @@ -2100,7 +2100,8 @@ void tcp_send_fin(struct sock *sk)
> >  	} else {
> >  		/* Socket is locked, keep trying until memory is available. */
> >  		for (;;) {
> > -			skb = alloc_skb_fclone(MAX_TCP_HEADER, GFP_KERNEL);
> > +			skb = alloc_skb_fclone(MAX_TCP_HEADER,
> > +					       sk->sk_allocation);
> >  			if (skb)
> >  				break;
> >  			yield();
> 
> I think this specific case needs more thinking.
> 
> If the allocation fails, and it's GFP_ATOMIC, we are going to yield()
> (which sleeps) and loop endlessly waiting for the allocation to
> succeed.

The _retried_ GFP_ATOMIC won't be much worse than GFP_KERNEL.

GFP_KERNEL can directly reclaim FS pages; GFP_ATOMIC will wake up
kswapd to do that. So after yield(), GFP_ATOMIC have good opportunity
to succeed if GFP_KERNEL could succeed.

The original GFP_KERNEL does have _a bit_ better chance to succeed,
but there are no guarantee. It could loop endlessly whether it be
GFP_KERNEL or GFP_ATOMIC.

btw, generally speaking, it would be more robust that NFS set
sk_allocation to GFP_NOIO, and let the networking code choose
whether to use plain sk_allocation or (sk_allocation & ~__GFP_WAIT).

The (sk_allocation & ~__GFP_WAIT) cases should be rare, but I guess
the networking code shall do it anyway, because sk_allocation defaults
to GFP_KERNEL. It seems that currently the networking code simply uses
a lot of GFP_ATOMIC, do they really mean "I cannot sleep"?

Thanks,
Fengguang
