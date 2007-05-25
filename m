Return-Path: <linux-kernel-owner+w=401wt.eu-S1763229AbXEYQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229AbXEYQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbXEYQEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 12:04:11 -0400
Received: from smtp.osdl.org ([207.189.120.12]:45783 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbXEYQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 12:04:10 -0400
Date: Fri, 25 May 2007 08:59:47 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Adam Osuchowski <adwol@zonk.pl>
Cc: bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Bridge] [BUG] Dropping fragmented IP packets within VLAN
 frames on bridge
Message-ID: <20070525085947.12841835@freepuppy>
In-Reply-To: <20070525081750.5ba4a411@zonk.pl>
References: <20070525081750.5ba4a411@zonk.pl>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 10:17:50 +0200
Adam Osuchowski <adwol@zonk.pl> wrote:

> There is a problem with fragmented IP packet sent within 802.1Q tagged
> ethernet frame through bridge. Problem exists when conntrack is enabled
> (i.e. nf_conntrack_ipv4 module is loaded). Then, such packets are not
> fragmented again (after prior reassembling on bridge device) during
> passing it to bridge enslaved NIC. It cause MTU exceeding and as a result
> dropping packet.
> 
> Problem exists from kernel version 2.6.17 to 2.6.21.3 inclusive.
> 
> Below, there is a patch to fix it.
> 
> Regards.
> 
> 
> --- linux-2.6.21.3.orig/net/bridge/br_netfilter.c	2007-05-25 09:56:15.000000000 +0200
> +++ linux-2.6.21.3/net/bridge/br_netfilter.c	2007-05-25 10:11:42.000000000 +0200
> @@ -731,7 +731,7 @@
>  
>  static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
> -	if (skb->protocol == htons(ETH_P_IP) &&
> +	if ((skb->protocol == htons(ETH_P_IP) || IS_VLAN_IP(skb)) &&
>  	    skb->len > skb->dev->mtu &&
>  	    !skb_is_gso(skb))
>  		return ip_fragment(skb, br_dev_queue_push_xmit);

It would be better to account for the tag in the length check.
Something like
	if (skb->protocol == htons(ETH_P_IP) &&
	    skb->len > skb->dev->mtu - (IS_VLAN_IP(skb) ? VLAN_HLEN : 0) &&
	    !skb_is_gso(skb))
		return ip_fragment ...


-- 
Stephen Hemminger <shemminger@linux-foundation.org>
