Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412Ab0ASJRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab0ASJRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 04:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754303Ab0ASJRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 04:17:31 -0500
Received: from mail-iw0-f197.google.com ([209.85.223.197]:39416 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab0ASJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 04:17:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DaUYmLIP00Rmj4RAYzQbkOsruJC0Mz/4/9RhNKmGO/Cep8HUCtDy+zlkzGp4XKcGuz
         2R220M/MUZx8CQl40kC12zDvWpS+NApO/dJ3Nsji4JR0BKsVSK/3tVjldjkMfvvr1Fsu
         12wMYsvF1Hzs9CBM9FNZEDEg2XbuamC2x3Rkc=
Message-ID: <4B5578A5.50705@gmail.com>
Date: Tue, 19 Jan 2010 04:17:25 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: netdev <netdev@vger.kernel.org>, Patrick McHardy <kaber@trash.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xt_TCPMSS: SYN packets are allowed to contain data
References: <4B54CDE5.3070100@simon.arlott.org.uk>
In-Reply-To: <4B54CDE5.3070100@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> The check for data only needs to apply where the packet length
> could be increased by adding the MSS option. (The MSS option
> itself applies to the sender's maximum receive size which is
> not relevant to any data in its own packet.)
> 
> This moves the check for (header size != packet size) to after
> attempting to modify an existing MSS option. Another check is
> needed before looking through the header to ensure it doesn't
> claim to be larger than the packet size.
> 
What's the path from tcp_v[4,6]_rcv() to these tests?

1) Header larger than the packet is already tested in about 5 places,
and my patch "tcp: harmonize tcp_vx_rcv header length assumptions"
tries to get them all down to just *one* test.

2) There certainly *can* be data on SYN.  That code is already in
2.6.33....


> The ERROR level printk() is also removed as it can be triggered
> by remote hosts and is not useful:
> [4941777.937417] xt_TCPMSS: bad length (40 bytes)
> [4941782.409724] xt_TCPMSS: bad length (40 bytes)
> [4941790.762332] xt_TCPMSS: bad length (40 bytes)
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> ---
>  net/netfilter/xt_TCPMSS.c |   21 +++++++++++----------
>  1 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
> index eda64c1..76f92bf 100644
> --- a/net/netfilter/xt_TCPMSS.c
> +++ b/net/netfilter/xt_TCPMSS.c
> @@ -60,17 +60,9 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>  	tcplen = skb->len - tcphoff;
>  	tcph = (struct tcphdr *)(skb_network_header(skb) + tcphoff);
>  
> -	/* Since it passed flags test in tcp match, we know it is is
> -	   not a fragment, and has data >= tcp header length.  SYN
> -	   packets should not contain data: if they did, then we risk
> -	   running over MTU, sending Frag Needed and breaking things
> -	   badly. --RR */
> -	if (tcplen != tcph->doff*4) {
> -		if (net_ratelimit())
> -			printk(KERN_ERR "xt_TCPMSS: bad length (%u bytes)\n",
> -			       skb->len);
> +	/* Header cannot be larger than the packet */
> +	if (tcplen < tcph->doff*4)
>  		return -1;
> -	}
>  
>  	if (info->mss == XT_TCPMSS_CLAMP_PMTU) {
>  		if (dst_mtu(skb_dst(skb)) <= minlen) {
> @@ -115,6 +107,15 @@ tcpmss_mangle_packet(struct sk_buff *skb,
>  		}
>  	}
>  
> +	/* Since it passed flags test in tcp match, we know it is
> +	   not a fragment, and has data >= tcp header length.  SYN
> +	   packets should not contain data: if they did, then we risk
> +	   running over MTU, sending Frag Needed and breaking things
> +	   badly. --RR
> +	*/
> +	if (tcplen > tcph->doff*4)
> +		return -1;
> +
>  	/*
>  	 * MSS Option not found ?! add it..
>  	 */

