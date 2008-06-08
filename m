Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYFHJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYFHJdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbYFHJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:33:09 -0400
Received: from s36.avahost.net ([74.53.95.194]:42902 "EHLO s36.avahost.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbYFHJdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:33:08 -0400
Message-ID: <484BA739.7030707@katalix.com>
Date: Sun, 08 Jun 2008 10:32:41 +0100
From: James Chapman <jchapman@katalix.com>
Organization: Katalix Systems Ltd
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: stable@kernel.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Missing patch from stable [5/7]
References: <20080608090150.GE6439@1wt.eu>
In-Reply-To: <20080608090150.GE6439@1wt.eu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s36.avahost.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - katalix.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau wrote:
> Hi,
> 
> this patch from mainline seems suitable for -stable, but was not proposed
> for inclusion. I think we should include it for next review unless the
> author disagrees.

OK by me.

>>From 090c48d3dd5ea90b37350334aaed9a93b0c1e0a1 Mon Sep 17 00:00:00 2001
> From: James Chapman <jchapman@katalix.com>
> Date: Mon, 19 May 2008 14:10:01 -0700
> Subject: l2tp: avoid skb truesize bug if headroom is increased
> 
> A user reported seeing occasional bugs such as the following when
> using the L2TP driver.
> 
>   SKB BUG: Invalid truesize (272) len=72, sizeof(sk_buff)=208
> 
> When L2TP adds its header in the transmit path, it might need to
> increase the headroom of the skb. In some cases, the increased
> headroom trips a kernel bug when the skb is freed because the skb has
> grown beyond its truesize value. The fix is to increase the truesize
> by the amount of headroom added, after orphaning the skb.
> 
> While here, fix a misleading comment.
> 
> Thanks to Iouri Kharon <bc-info@styx.cabel.net> for the initial
> report and testing the fix.
> 
> Signed-off-by: James Chapman <jchapman@katalix.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  drivers/net/pppol2tp.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/pppol2tp.c b/drivers/net/pppol2tp.c
> index 7935991..8db342f 100644
> --- a/drivers/net/pppol2tp.c
> +++ b/drivers/net/pppol2tp.c
> @@ -980,6 +980,8 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
>  	__wsum csum = 0;
>  	struct udphdr *uh;
>  	unsigned int len;
> +	int old_headroom;
> +	int new_headroom;
>  
>  	if (sock_flag(sk, SOCK_DEAD) || !(sk->sk_state & PPPOX_CONNECTED))
>  		goto abort;
> @@ -1001,16 +1003,18 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
>  
>  	/* Check that there's enough headroom in the skb to insert IP,
>  	 * UDP and L2TP and PPP headers. If not enough, expand it to
> -	 * make room. Note that a new skb (or a clone) is
> -	 * allocated. If we return an error from this point on, make
> -	 * sure we free the new skb but do not free the original skb
> -	 * since that is done by the caller for the error case.
> +	 * make room. Adjust truesize.
>  	 */
>  	headroom = NET_SKB_PAD + sizeof(struct iphdr) +
>  		sizeof(struct udphdr) + hdr_len + sizeof(ppph);
> +	old_headroom = skb_headroom(skb);
>  	if (skb_cow_head(skb, headroom))
>  		goto abort;
>  
> +	new_headroom = skb_headroom(skb);
> +	skb_orphan(skb);
> +	skb->truesize += new_headroom - old_headroom;
> +
>  	/* Setup PPP header */
>  	__skb_push(skb, sizeof(ppph));
>  	skb->data[0] = ppph[0];
> @@ -1065,7 +1069,6 @@ static int pppol2tp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
>  	/* Get routing info from the tunnel socket */
>  	dst_release(skb->dst);
>  	skb->dst = dst_clone(__sk_dst_get(sk_tun));
> -	skb_orphan(skb);
>  	skb->sk = sk_tun;
>  
>  	/* Queue the packet to IP for output */


-- 
James Chapman
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

