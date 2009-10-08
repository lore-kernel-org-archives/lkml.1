Return-Path: <linux-kernel-owner+w=401wt.eu-S1751392AbZJHDMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbZJHDMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 23:12:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750854AbZJHDMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 23:12:13 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:45526 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZJHDMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 23:12:12 -0400
Message-ID: <4ACD585B.5080106@gmail.com>
Date: Thu, 08 Oct 2009 05:11:23 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Thomas Chou <thomas@wytron.com.tw>
CC: netdev@vger.kernel.org, thierry.reding@avionic-design.de,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: Add netdev_alloc_skb_ip_align() helper
References: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>
In-Reply-To: <1254969161-3609-1-git-send-email-thomas@wytron.com.tw>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 08 Oct 2009 05:11:24 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Chou a écrit :
> As suggested by Stephen Hemminger.
> 
> Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
> ---
>  drivers/net/ethoc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
> index ecc53d9..4a1ed81 100644
> --- a/drivers/net/ethoc.c
> +++ b/drivers/net/ethoc.c
> @@ -409,7 +409,7 @@ static int ethoc_rx(struct net_device *dev, int limit)
>  			struct sk_buff *skb = netdev_alloc_skb(dev, size);
>  
>  			size -= 4; /* strip the CRC */
> -			skb_reserve(skb, 2); /* align TCP/IP header */
> +			skb_reserve(skb, NET_IP_ALIGN);
>  
>  			if (likely(skb)) {
>  				void *src = phys_to_virt(bd.addr);

Sorry to be dense here, but this code breaks if NET_IP_ALIGN > 4.
Its also suboptimal, you alloc two bytes in excess.


You should do :

size -= 4; /* strip the CRC */
skb = netdev_alloc_skb(dev, size + NET_IP_ALIGN);
if (skb) {
	skb_reserve(skb, NET_IP_ALIGN);
	...
}


Please check other implementations...

David, maybe we should add following helper :

[PATCH] net: Add netdev_alloc_skb_ip_align() helper

Instead of hardcoding NET_IP_ALIGN stuff in various network drivers, we can
add a helper around netdev_alloc_skb()

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index df7b23a..fed788e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1489,6 +1489,16 @@ static inline struct sk_buff *netdev_alloc_skb(struct net_device *dev,
 	return __netdev_alloc_skb(dev, length, GFP_ATOMIC);
 }
 
+static inline struct sk_buff *netdev_alloc_skb_ip_align(struct net_device *dev,
+		unsigned int length)
+{
+	struct sk_buff *skb = netdev_alloc_skb(dev, length + NET_IP_ALIGN);
+
+	if (NET_IP_ALIGN && skb)
+		skb_reserve(skb, NET_IP_ALIGN);
+	return skb;
+}
+
 extern struct page *__netdev_alloc_page(struct net_device *dev, gfp_t gfp_mask);
 
 /**
