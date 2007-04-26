Return-Path: <linux-kernel-owner+w=401wt.eu-S1752905AbXDZQrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbXDZQrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754836AbXDZQrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:47:08 -0400
Received: from mivlgu.ru ([81.18.140.87]:36262 "EHLO mail.mivlgu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbXDZQrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:47:07 -0400
X-Greylist: delayed 1502 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Apr 2007 12:47:06 EDT
Date: Thu, 26 Apr 2007 20:21:57 +0400
From: Sergey Vlasov <vsu@altlinux.ru>
To: Greg KH <gregkh@suse.de>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
       "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: "IPV6: Disallow RH0 by default" patch looks broken (Re: Linux
 2.6.20.9)
Message-Id: <20070426202157.e357ece5.vsu@altlinux.ru>
In-Reply-To: <20070426072503.GA5643@kroah.com>
References: <20070426072441.GA5515@kroah.com>
	<20070426072503.GA5643@kroah.com>
X-Mailer: Sylpheed version 2.2.9 (GTK+ 2.10.6; i586-alt-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 00:25:03 -0700 Greg KH wrote:

[...]
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index 0711f92..5fd7cf9 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
[...]
> @@ -378,6 +395,22 @@ static int ipv6_rthdr_rcv(struct sk_buff **skbp)
>  
>  	hdr = (struct ipv6_rt_hdr *) skb->h.raw;
>  
> +	switch (hdr->type) {
> +#ifdef CONFIG_IPV6_MIP6
> +		break;

I suppose "case IPV6_SRCRT_TYPE_2:" is missing before "break"?

The same broken patch went in 2.6.21.

> +#endif
> +	case IPV6_SRCRT_TYPE_0:
> +		if (accept_source_route > 0)
> +			break;
> +		kfree_skb(skb);
> +		return -1;
> +	default:
> +		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst),
> +				 IPSTATS_MIB_INHDRERRORS);
> +		icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, (&hdr->type) - skb->nh.raw);
> +		return -1;
> +	}
> +
>  	if (ipv6_addr_is_multicast(&skb->nh.ipv6h->daddr) ||
>  	    skb->pkt_type != PACKET_HOST) {
>  		IP6_INC_STATS_BH(ip6_dst_idev(skb->dst),
[...]
