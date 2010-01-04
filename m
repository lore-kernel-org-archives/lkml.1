Return-Path: <linux-kernel-owner+w=401wt.eu-S1753309Ab0ADKkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab0ADKkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752878Ab0ADKkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:40:07 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:42449 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0ADKkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:40:06 -0500
Message-ID: <4B41C4C2.3030404@gmail.com>
Date: Mon, 04 Jan 2010 11:36:50 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Milan Dadok <milan@dadok.name>
CC: kaber@trash.net, uaca@alumni.uv.es, johann.baudy@gnu-log.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] 1/1 net: packet: Keep 802.1Q VLAN tag in packet on SOCK_DGRAM
 socket - resend
References: <001801ca8d1d$90c68de0$b253a9a0$@name>
In-Reply-To: <001801ca8d1d$90c68de0$b253a9a0$@name>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 04 Jan 2010 11:36:52 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 04/01/2010 10:09, Milan Dadok a écrit :
> Keep 802.1Q VLAN tag on non HW vlan accelerated network card received to SOCK_DGRAM socket.
> 
> Signed-off-by: Milan Dadok <milan@dadok.name>
> 
> ---
> diff -urN af_packet.c.orig af_packet.c
> --- af_packet.c.orig    2009-12-26 12:34:15.000000000 +0100
> +++ af_packet.c 2009-12-28 14:31:14.000000000 +0100
> @@ -57,6 +57,8 @@
>  #include <linux/inet.h>
>  #include <linux/netdevice.h>
>  #include <linux/if_packet.h>
> +#include <linux/if_vlan.h>
> +#include "../8021q/vlan.h"

This is ugly, please move is_vlan_dev() in if_vlan.h instead ?

>  #include <linux/wireless.h>
>  #include <linux/kernel.h>
>  #include <linux/kmod.h>
> @@ -680,8 +682,28 @@
>                 if (sk->sk_type != SOCK_DGRAM)
>                         skb_push(skb, skb->data - skb_mac_header(skb));
>                 else if (skb->pkt_type == PACKET_OUTGOING) {
> -                       /* Special case: outgoing packets have ll header at head */
> -                       skb_pull(skb, skb_network_offset(skb));
> +                       /* Special case: outgoing packets have ll header at head
> +                        * but we must leave 802.1Q encapsulation etc. (only for non HW vlan accelerated)
> +                        * encasulation len = actual header_len minus hard_header_len
> +                        * packet outgoing from vlan1@eth0 on eth0 have skb_network_offset=18, hard_header_len=14
> +                        */
> +                       int hard_header_len;
> +                       struct net_device *pdev;
> +                       hard_header_len = dev->hard_header_len;
> +                       pdev = dev;
> +                       /* if dev is vlan device, hard_header_len contains 802.1Q encap, subtract it, recursively
> +                        * ie. vlan3@vlan2@vlan1@eth0
> +                        */
> +                       while (is_vlan_dev(pdev)) {
> +                               struct net_device *real_dev = vlan_dev_info(pdev)->real_dev;
A new line after variable definition is welcomed.
> +                               hard_header_len -= pdev->hard_header_len - real_dev->hard_header_len;
> +                               pdev = real_dev;
> +                       }
> +
> +                       skb_pull(skb, skb_network_offset(skb) -
> +                            (skb_network_offset(skb) - hard_header_len>0 ? skb_network_offset(skb) - hard_header_len : 0));
>                 }
>         }

I find this logic a bit hard to read, you might use this instead :

if (skb_network_offset(skb) > hard_header_len)
	skb_pull(skb, hard_header_len);
else
	skb_pull(skb, skb_network_offset(skb));




Also, could you please read Documentation/SubmittingPatches and
Documentation/email-clients.txt

Your patch has at least two problems :

1) It is not an unified diff
2) It has garbled tabulations (they are replaced by spaces)

It is not applicable as is.

Thank you
