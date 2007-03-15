Return-Path: <linux-kernel-owner+w=401wt.eu-S1750876AbXCOTDM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750876AbXCOTDM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751108AbXCOTDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:03:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876AbXCOTDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:03:11 -0400
Message-ID: <45F9984A.4020206@redhat.com>
Date: Thu, 15 Mar 2007 15:02:34 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (Macintosh/20070221)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: torvalds@linux-foundation.org, jgarzik@pobox.com,
       linux-kernel@vger.kernel.org, Jay Cliburn <jacliburn@bellsouth.net>
Subject: Re: [PATCH 14/17] atl1 trivial endianness misannotations
References: <E1HRPeU-0003a3-2G@ZenIV.linux.org.uk>
In-Reply-To: <E1HRPeU-0003a3-2G@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> NB: driver is choke-full of code that will break on big-endian; as long
> as the hardware is onboard-only we can live with that, but sooner or
> later that'll need fixing.
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  drivers/net/atl1/atl1_main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/atl1/atl1_main.c b/drivers/net/atl1/atl1_main.c
> index 88d4f70..dee3638 100644
> --- a/drivers/net/atl1/atl1_main.c
> +++ b/drivers/net/atl1/atl1_main.c
> @@ -1328,7 +1328,7 @@ static int atl1_tx_csum(struct atl1_adapter *adapter, struct sk_buff *skb,
>  
>  	if (likely(skb->ip_summed == CHECKSUM_PARTIAL)) {
>  		cso = skb->h.raw - skb->data;
> -		css = (skb->h.raw + skb->csum) - skb->data;
> +		css = (skb->h.raw + skb->csum_offset) - skb->data;
>  		if (unlikely(cso & 0x1)) {
>  			printk(KERN_DEBUG "%s: payload offset != even number\n",
>  				atl1_driver_name);

This could certainly explain some checksumming problems we've seen.

> @@ -1562,7 +1562,7 @@ static int atl1_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
>  	/* mss will be nonzero if we're doing segment offload (TSO/GSO) */
>  	mss = skb_shinfo(skb)->gso_size;
>  	if (mss) {
> -		if (skb->protocol == ntohs(ETH_P_IP)) {
> +		if (skb->protocol == htons(ETH_P_IP)) {
>  			proto_hdr_len = ((skb->h.raw - skb->data) +
>  					 (skb->h.th->doff << 2));
>  			if (unlikely(proto_hdr_len > len)) {

ACK.
