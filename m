Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab0BYUzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 15:55:36 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:31430 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933758Ab0BYUzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 15:55:33 -0500
Subject: Re: [PATCH v3 2/7] net: remove old tcp_optlen function
From: Ben Hutchings <bhutchings@solarflare.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       David Miller <davem@davemloft.net>, Michael Chan <mchan@broadcom.com>
In-Reply-To: <4B86DFF4.5000007@gmail.com>
References: <4B86DDCB.50608@gmail.com>  <4B86DFF4.5000007@gmail.com>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Thu, 25 Feb 2010 20:55:29 +0000
Message-Id: <1267131329.2107.27.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Feb 2010 20:55:37.0484 (UTC) FILETIME=[E1CA04C0:01CAB65C]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17214.005
X-TM-AS-Result: No--32.748200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 15:39 -0500, William Allen Simpson wrote:
> The tcp_optlen() function returns a potential *negative* unsigned.
> 
> In the only two existing files using the old tcp_optlen() function,
> clean up confusing and inconsistent mixing of both byte and word
> offsets, and other coding style issues.  Document assumptions.
> 
> Quoth David Miller:
>     This is transmit, and the packets can only come from the Linux
>     TCP stack, not some external entity.
> 
>     You're being way too anal here, and adding these checks to
>     drivers would be just a lot of rediculious bloat. [sic]
> 
> Therefore, there are *no* checks for bad TCP and IP header sizes, nor
> any semantic changes.  The drivers should function exactly as existing.
> 
> No response from testers in 19+ weeks.

There's no need for these passive-aggressive comments and they certainly
won't get your patches merged any faster.

> Requires:
>    net: tcp_header_len_th and tcp_option_len_th
> 
> Signed-off-by: William.Allen.Simpson@gmail.com
> CC: Michael Chan <mchan@broadcom.com>
> ---
>   drivers/net/bnx2.c  |   29 +++++++++++++-----------
>   drivers/net/tg3.c   |   60 +++++++++++++++++++++++---------------------------
>   include/linux/tcp.h |    5 ----
>   3 files changed, 44 insertions(+), 50 deletions(-)

> diff --git a/drivers/net/bnx2.c b/drivers/net/bnx2.c
> index 65df1de..45452c5 100644
> --- a/drivers/net/bnx2.c
> +++ b/drivers/net/bnx2.c
> @@ -6352,6 +6352,8 @@ bnx2_vlan_rx_register(struct net_device *dev, struct vlan_group *vlgrp)
>  /* Called with netif_tx_lock.
>   * bnx2_tx_int() runs without netif_tx_lock unless it needs to call
>   * netif_wake_queue().
> + *
> + * No TCP or IP length checking, per David Miller (see commit log).
>   */
>  static netdev_tx_t
>  bnx2_start_xmit(struct sk_buff *skb, struct net_device *dev)
> @@ -6396,19 +6398,19 @@ bnx2_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  			(TX_BD_FLAGS_VLAN_TAG | (vlan_tx_tag_get(skb) << 16));
>  	}
>  #endif
> -	if ((mss = skb_shinfo(skb)->gso_size)) {
> -		u32 tcp_opt_len;
> -		struct iphdr *iph;
> +	mss = skb_shinfo(skb)->gso_size;
> +	if (mss != 0) {
> +		struct tcphdr *th = tcp_hdr(skb);
> +		int tcp_opt_words = th->doff - (sizeof(*th) >> 2);
> +		/* assumes positive tcp_opt_words without checking */

It would be far more helpful to add a comment to the top of this block
that notes that skbs with gso_size set are known to have valid headers.

>  		vlan_tag_flags |= TX_BD_FLAGS_SW_LSO;
>  
> -		tcp_opt_len = tcp_optlen(skb);
> -

How is this an improvement?

>  		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) {
>  			u32 tcp_off = skb_transport_offset(skb) -
>  				      sizeof(struct ipv6hdr) - ETH_HLEN;
>  
> -			vlan_tag_flags |= ((tcp_opt_len >> 2) << 8) |
> +			vlan_tag_flags |= (tcp_opt_words << 8) |
>  					  TX_BD_FLAGS_SW_FLAGS;
>  			if (likely(tcp_off == 0))
>  				vlan_tag_flags &= ~TX_BD_FLAGS_TCP6_OFF0_MSK;
> @@ -6421,14 +6423,15 @@ bnx2_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  				mss |= (tcp_off & 0xc) << TX_BD_TCP6_OFF2_SHL;
>  			}
>  		} else {
> -			iph = ip_hdr(skb);
> -			if (tcp_opt_len || (iph->ihl > 5)) {
> -				vlan_tag_flags |= ((iph->ihl - 5) +
> -						   (tcp_opt_len >> 2)) << 8;
> -			}
> +			struct iphdr *iph = ip_hdr(skb);
> +			int ip_opt_words = iph->ihl - (sizeof(*iph) >> 2);
> +			/* assumes positive ip_opt_words without checking */
> +			int opt_words = ip_opt_words + tcp_opt_words;
> +
> +			if (opt_words > 0)
> +				vlan_tag_flags |= opt_words << 8;
[...]

That *is* clearer.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

