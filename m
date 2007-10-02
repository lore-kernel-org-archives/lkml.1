Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbXJBOg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbXJBOg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 10:36:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbXJBOgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 10:36:50 -0400
Received: from namei.org ([69.55.235.186]:54823 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751845AbXJBOgu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:36:50 -0400
Date: Tue, 2 Oct 2007 07:36:32 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [TOMOYO 14/15](repost) LSM expansion for TOMOYO Linux.
In-Reply-To: <4701F5CC.7040209@nttdata.co.jp>
Message-ID: <Xine.LNX.4.64.0710020653470.28698@us.intercode.com.au>
References: <4701F285.5000206@nttdata.co.jp> <4701F5CC.7040209@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Kentaro Takeda wrote:


> --- linux-2.6.orig/net/core/datagram.c	2007-10-02 11:11:51.000000000 +0900
> +++ linux-2.6/net/core/datagram.c	2007-10-02 11:26:23.000000000 +0900
> @@ -55,6 +55,7 @@
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
> +
> +			if (!(flags & MSG_PEEK))
> +				goto no_peek;
> +
> +			spin_lock_irqsave(&sk->sk_receive_queue.lock,
> +					  cpu_flags);
> +			if (skb == skb_peek(&sk->sk_receive_queue)) {
> +				__skb_unlink(skb,
> +					     &sk->sk_receive_queue);
> +				atomic_dec(&skb->users);
> +			}
> +			spin_unlock_irqrestore(&sk->sk_receive_queue.lock,
> +					       cpu_flags);
> +no_peek:
> +			skb_free_datagram(sk, skb);
> +			goto no_packet;
> +		}
> +
>  		if (skb)
>  			return skb;

I'm guessing you need this to determine the receiving process, rather than 
the socket (which is available via security_sock_rcv_skb()).

If so, is this to interactively determine from the user or admin whether 
the packet should be accepted/denied for the receiving process?


- James
-- 
James Morris
<jmorris@namei.org>
