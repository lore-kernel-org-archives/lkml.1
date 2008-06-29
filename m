Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbYF2UEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbYF2UEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 16:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760155AbYF2UE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 16:04:28 -0400
Received: from mail.vyatta.com ([216.93.170.194]:60289 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759047AbYF2UE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 16:04:27 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.087
Date: Sun, 29 Jun 2008 13:04:20 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>,
       <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add missing skb->dev assignment in Frame Relay RX code
Message-ID: <20080629130420.62d00d59@extreme>
In-Reply-To: <m3wsk8aupw.fsf@maximus.localdomain>
References: <m3wsk8aupw.fsf@maximus.localdomain>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 21:48:11 +0200
Krzysztof Halasa <khc@pm.waw.pl> wrote:

> Hi,
> 
> Commit 4c13eb6657fe9ef7b4dc8f1a405c902e9e5234e0 ([ETH]: Make
> eth_type_trans set skb->dev like the other *_type_trans) removed
> skb->dev assignment from hdlc_fr.c:fr_rx(). Unfortunately it was also
> needed for cases other than eth_type_trans().
> 
> Adding it back.
> 
> It's quite serious and may be a security risk as it causes a wrong
> input interface indication (the physical hdlcX instead of logical
> pvcX). Probably -stable class fix.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/hdlc_fr.c b/drivers/net/wan/hdlc_fr.c
> index c4ab032..3a86e64 100644
> --- a/drivers/net/wan/hdlc_fr.c
> +++ b/drivers/net/wan/hdlc_fr.c
> @@ -1008,6 +1008,7 @@ static int fr_rx(struct sk_buff *skb)
>  		stats->rx_bytes += skb->len;
>  		if (pvc->state.becn)
>  			stats->rx_compressed++;
> +		skb->dev = dev;
>  		netif_rx(skb);
>  		return NET_RX_SUCCESS;
>  	} else {
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Better to use netdev_alloc_skb for receive buffers instead.
--- a/drivers/net/wan/hdlc_fr.c	2008-06-29 13:02:42.000000000 -0700
+++ b/drivers/net/wan/hdlc_fr.c	2008-06-29 13:04:01.000000000 -0700
@@ -515,7 +515,7 @@ static void fr_lmi_send(struct net_devic
 		}
 	}
 
-	skb = dev_alloc_skb(len);
+	skb = netdev_alloc_skb(dev, len);
 	if (!skb) {
 		printk(KERN_WARNING "%s: Memory squeeze on fr_lmi_send()\n",
 		       dev->name);
