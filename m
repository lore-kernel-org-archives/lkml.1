Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZGJAOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZGJAOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 20:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbZGJANx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 20:13:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49275
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104AbZGJANw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 20:13:52 -0400
Date: Thu, 09 Jul 2009 17:13:55 -0700 (PDT)
Message-Id: <20090709.171355.09466097.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       linux-nfs@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: sk_lock: inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W}
 usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090709131746.GA27965@localhost>
References: <20090608023757.GA6244@localhost>
	<20090706105216.GA19124@gondor.apana.org.au>
	<20090709131746.GA27965@localhost>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Fengguang <fengguang.wu@intel.com>
Date: Thu, 9 Jul 2009 21:17:46 +0800

> @@ -2100,7 +2100,8 @@ void tcp_send_fin(struct sock *sk)
>  	} else {
>  		/* Socket is locked, keep trying until memory is available. */
>  		for (;;) {
> -			skb = alloc_skb_fclone(MAX_TCP_HEADER, GFP_KERNEL);
> +			skb = alloc_skb_fclone(MAX_TCP_HEADER,
> +					       sk->sk_allocation);
>  			if (skb)
>  				break;
>  			yield();

I think this specific case needs more thinking.

If the allocation fails, and it's GFP_ATOMIC, we are going to yield()
(which sleeps) and loop endlessly waiting for the allocation to
succeed.
