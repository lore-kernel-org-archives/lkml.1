Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXKPTb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXKPTb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXKPTbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:31:51 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:8210 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXKPTbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:31:50 -0500
X-Greylist: delayed 494 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Nov 2007 14:31:50 EST
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: penguin-kernel@i-love.sakura.ne.jp
Subject: Re: [TOMOYO #5 18/18] LSM expansion for TOMOYO Linux.
Date: Fri, 16 Nov 2007 14:23:27 -0500
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>
References: <20071116173439.796600895@I-love.SAKURA.ne.jp> <20071116173529.826621737@I-love.SAKURA.ne.jp>
In-Reply-To: <20071116173529.826621737@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711161423.28065.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 November 2007 12:34:57 pm penguin-kernel@i-love.sakura.ne.jp 
wrote:
> LSM hooks for network accept and recv:
>    * socket_post_accept is modified to return int.
>    * post_recv_datagram is added in skb_recv_datagram.
>
> You can try TOMOYO Linux without this patch, but in that case, you
> can't use access control functionality for restricting signal
> transmission and incoming network data.

As discussed a few times before, I'm still not really excited about adding a 
new LSM hook in skb_recv_datagram() when we already have hooks to control 
locally consumed network traffic.  However, I will admit that these existing 
hooks do not allow the LSM to block and query userspace for an access 
decision like you are trying to do with TOMOYO.  I would prefer not to see 
this new LSM hook added but I do not have an alternative solution to your 
problem so I can't in good conscience completely object to this patch.

Regardless, I have a few comments which are included below ...

> --- linux-2.6-mm.orig/net/core/datagram.c	2007-10-10 05:31:38.000000000
> +0900 +++ linux-2.6-mm/net/core/datagram.c	2007-11-14 15:15:44.000000000
> +0900 @@ -55,6 +55,7 @@
>  #include <net/checksum.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h>
> +#include <linux/security.h>
>
>  /*
>   *	Is a socket 'connection oriented' ?
> @@ -178,6 +179,27 @@ struct sk_buff *skb_recv_datagram(struct
>  		} else
>  			skb = skb_dequeue(&sk->sk_receive_queue);
>
> +		error = security_post_recv_datagram(sk, skb, flags);
> +		if (error) {
> +			unsigned long cpu_flags;

With this patch the 'cpu_flags' variable will be used in two different 
if-blocks in this function and declared locally within each block.  Please 
move the 'cpu_flags' declaration to the top of the function so it only needs 
to be declared once.

> +
> +			if (!(flags & MSG_PEEK))
> +				goto no_peek;
> +
> +			spin_lock_irqsave(&sk->sk_receive_queue.lock,
> +					  cpu_flags);
> +			if (skb == skb_peek(&sk->sk_receive_queue)) {

I might be missing something here, but why do you need to do a skb_peek() 
again?  You already have the skb and the sock, just do the unlink.

> +				__skb_unlink(skb,
> +					     &sk->sk_receive_queue);
> +				atomic_dec(&skb->users);
> +			}
> +			spin_unlock_irqrestore(&sk->sk_receive_queue.lock,
> +					       cpu_flags);
> +no_peek:
> +			skb_free_datagram(sk, skb);
> +			goto no_packet;

Two things.  First you can probably just call kfree_skb() instead of 
skb_free_datagram().  Second, why not move the 'no_peek' code to just 
before 'no_packet'?

-- 
paul moore
linux security @ hp
