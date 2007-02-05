Return-Path: <linux-kernel-owner+w=401wt.eu-S1752697AbXBEEuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbXBEEuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 23:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbXBEEuQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 23:50:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:56073 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbXBEEuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 23:50:14 -0500
Date: Sun, 4 Feb 2007 23:49:55 -0500
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 013 of 14] knfsd: SUNRPC: support IPv6 addresses in RPC server's UDP receive path.
Message-ID: <20070205044955.GB1193@filer.fsl.cs.sunysb.edu>
References: <20070202153531.18622.patches@notabene> <1070202044044.19169@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070202044044.19169@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:40:44PM +1100, NeilBrown wrote:
...
> diff .prev/net/sunrpc/svcsock.c ./net/sunrpc/svcsock.c
> --- .prev/net/sunrpc/svcsock.c	2007-02-02 15:22:40.000000000 +1100
> +++ ./net/sunrpc/svcsock.c	2007-02-02 15:22:58.000000000 +1100
> @@ -715,13 +715,55 @@ svc_write_space(struct sock *sk)
>  	}
>  }
>  
> +static void svc_udp_get_sender_address(struct svc_rqst *rqstp,
> +					struct sk_buff *skb)
> +{
> +	switch (rqstp->rq_sock->sk_sk->sk_family) {
> +	case AF_INET:
> +		/* this seems to come from net/ipv4/udp.c:udp_recvmsg */
> +		do {
> +			struct sockaddr_in *sin = svc_addr_in(rqstp);
> +
> +			sin->sin_family = AF_INET;
> +			sin->sin_port = skb->h.uh->source;
> +			sin->sin_addr.s_addr = skb->nh.iph->saddr;
> +			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
> +			/* Remember which interface received this request */
> +			rqstp->rq_daddr.addr.s_addr = skb->nh.iph->daddr;
> +		} while (0);
> +		break;

Why the while(0) ?

> +#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
> +	case AF_INET6:
> +		/* this is derived from net/ipv6/udp.c:udpv6_recvmesg */
> +		do {
> +			struct sockaddr_in6 *sin6 = svc_addr_in6(rqstp);
> +
> +			sin6->sin6_family = AF_INET6;
> +			sin6->sin6_port = skb->h.uh->source;
> +			sin6->sin6_flowinfo = 0;
> +			sin6->sin6_scope_id = 0;
> +			if (ipv6_addr_type(&sin6->sin6_addr) &
> +							IPV6_ADDR_LINKLOCAL)
> +				sin6->sin6_scope_id = IP6CB(skb)->iif;
> +			ipv6_addr_copy(&sin6->sin6_addr,
> +							&skb->nh.ipv6h->saddr);
> +			rqstp->rq_addrlen = sizeof(struct sockaddr_in);
> +			/* Remember which interface received this request */
> +			ipv6_addr_copy(&rqstp->rq_daddr.addr6,
> +							&skb->nh.ipv6h->saddr);
> +		} while (0);
> +		break;

Ditto.

Josef "Jeff" Sipek.

-- 
You measure democracy by the freedom it gives its dissidents, not the
freedom it gives its assimilated conformists.
		- Abbie Hoffman
