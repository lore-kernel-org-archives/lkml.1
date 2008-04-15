Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYDOHef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYDOHef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752237AbYDOHe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:34:28 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41591
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbYDOHe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:34:27 -0400
Date: Tue, 15 Apr 2008 00:34:29 -0700 (PDT)
Message-Id: <20080415.003429.00202360.davem@davemloft.net>
To: vgusev@openvz.org
Cc: kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH][NET] Fix never pruned tcp out-of-order queue
From: David Miller <davem@davemloft.net>
In-Reply-To: <200804142121.53860.vgusev@openvz.org>
References: <200804142121.53860.vgusev@openvz.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vitaliy Gusev <vgusev@openvz.org>
Date: Mon, 14 Apr 2008 21:21:53 +0400

[ Please CC: netdev@vger.kernel.org for networking patches in
  the future, thank you ]

> tcp_prune_queue() doesn't prune an out-of-order queue at all.
> Therefore sk_rmem_schedule() can fail but the out-of-order queue
> isn't pruned . This can lead to tcp deadlock state if the
> next two conditions are held:
> 
> 1. There are a sequence hole between last received in
>    order segment and segments enqueued to the out-of-order queue.
> 
> 2. Size of all segments in the out-of-order queue is more than tcp_mem[2].
> 
> 
> Signed-off-by: Vitaliy Gusev <vgusev@openvz.org>

Looks good, applied.

> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 5119856..fb5f522 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -3841,8 +3841,26 @@ static void tcp_ofo_queue(struct sock *sk)
>  	}
>  }
>  
> +static void tcp_prune_ofo_queue(struct sock *sk);
>  static int tcp_prune_queue(struct sock *sk);
>  
> +static inline int tcp_try_rmem_schedule(struct sock *sk, unsigned int size)
> +{
> +	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> +	    !sk_rmem_schedule(sk, size)) {
> +
> +		if (tcp_prune_queue(sk) < 0)
> +			return -1;
> +
> +		if (!sk_rmem_schedule(sk, size)) {
> +			tcp_prune_ofo_queue(sk);
> +			if (!sk_rmem_schedule(sk, size))
> +				return -1;
> +		}
> +	}
> +	return 0;
> +}
> +
>  static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>  {
>  	struct tcphdr *th = tcp_hdr(skb);
> @@ -3892,12 +3910,9 @@ static void tcp_data_queue(struct sock *sk, struct sk_buff *skb)
>  		if (eaten <= 0) {
>  queue_and_out:
>  			if (eaten < 0 &&
> -			    (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> -			     !sk_rmem_schedule(sk, skb->truesize))) {
> -				if (tcp_prune_queue(sk) < 0 ||
> -				    !sk_rmem_schedule(sk, skb->truesize))
> -					goto drop;
> -			}
> +			    tcp_try_rmem_schedule(sk, skb->truesize))
> +				goto drop;
> +
>  			skb_set_owner_r(skb, sk);
>  			__skb_queue_tail(&sk->sk_receive_queue, skb);
>  		}
> @@ -3966,12 +3981,8 @@ drop:
>  
>  	TCP_ECN_check_ce(tp, skb);
>  
> -	if (atomic_read(&sk->sk_rmem_alloc) > sk->sk_rcvbuf ||
> -	    !sk_rmem_schedule(sk, skb->truesize)) {
> -		if (tcp_prune_queue(sk) < 0 ||
> -		    !sk_rmem_schedule(sk, skb->truesize))
> -			goto drop;
> -	}
> +	if (tcp_try_rmem_schedule(sk, skb->truesize))
> +		goto drop;
>  
>  	/* Disable header prediction. */
>  	tp->pred_flags = 0;
> @@ -4198,6 +4209,28 @@ static void tcp_collapse_ofo_queue(struct sock *sk)
>  	}
>  }
>  
> +/*
> + * Purge the out-of-order queue.
> + */
> +static void tcp_prune_ofo_queue(struct sock *sk)
> +{
> +	struct tcp_sock *tp = tcp_sk(sk);
> +
> +	if (!skb_queue_empty(&tp->out_of_order_queue)) {
> +		NET_INC_STATS_BH(LINUX_MIB_OFOPRUNED);
> +		__skb_queue_purge(&tp->out_of_order_queue);
> +
> +		/* Reset SACK state.  A conforming SACK implementation will
> +		 * do the same at a timeout based retransmit.  When a connection
> +		 * is in a sad state like this, we care only about integrity
> +		 * of the connection not performance.
> +		 */
> +		if (tp->rx_opt.sack_ok)
> +			tcp_sack_reset(&tp->rx_opt);
> +		sk_mem_reclaim(sk);
> +	}
> +}
> +
>  /* Reduce allocated memory if we can, trying to get
>   * the socket within its memory limits again.
>   *
> @@ -4231,20 +4264,7 @@ static int tcp_prune_queue(struct sock *sk)
>  	/* Collapsing did not help, destructive actions follow.
>  	 * This must not ever occur. */
>  
> -	/* First, purge the out_of_order queue. */
> -	if (!skb_queue_empty(&tp->out_of_order_queue)) {
> -		NET_INC_STATS_BH(LINUX_MIB_OFOPRUNED);
> -		__skb_queue_purge(&tp->out_of_order_queue);
> -
> -		/* Reset SACK state.  A conforming SACK implementation will
> -		 * do the same at a timeout based retransmit.  When a connection
> -		 * is in a sad state like this, we care only about integrity
> -		 * of the connection not performance.
> -		 */
> -		if (tcp_is_sack(tp))
> -			tcp_sack_reset(&tp->rx_opt);
> -		sk_mem_reclaim(sk);
> -	}
> +	tcp_prune_ofo_queue(sk);
>  
>  	if (atomic_read(&sk->sk_rmem_alloc) <= sk->sk_rcvbuf)
>  		return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
