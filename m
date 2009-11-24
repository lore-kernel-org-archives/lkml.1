Return-Path: <linux-kernel-owner+w=401wt.eu-S932722AbZKXKlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722AbZKXKlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:41:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932680AbZKXKlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:41:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:64884 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932636AbZKXKle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:41:34 -0500
Message-ID: <4B0BB862.6070101@trash.net>
Date: Tue, 24 Nov 2009 11:41:38 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>
Subject: Re: [PATCH 2/4] macvlan: cleanup rx statistics
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <1259024166-28158-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1259024166-28158-3-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index ae2b5c7..a0dea23 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -116,42 +116,53 @@ static int macvlan_addr_busy(const struct macvlan_port *port,
>  	return 0;
>  }
>  
> +static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,

Please use unsigned int for length values.

Regarding Eric's comments, I also think it would be more readable to use
if (success) {
	...
} else {
	...
}

> +			     int success, int multicast)
> +{
> +	struct macvlan_rx_stats *rx_stats;
> +
> +	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
> +	rx_stats->rx_packets += success != 0;
> +	rx_stats->rx_bytes   += success ? length : 0;
> +	rx_stats->multicast  += success && multicast;
> +	rx_stats->rx_errors  += !success;
> +}
> +
> +static int macvlan_broadcast_one(struct sk_buff *skb, struct net_device *dev,
> +				 const struct ethhdr *eth)
> +{
> +	if (!skb)
> +		return NET_RX_DROP;
> +
> +	skb->dev = dev;
> +	if (!compare_ether_addr_64bits(eth->h_dest,
> +				       dev->broadcast))

This would fit on one line without reducing readability.

> +		skb->pkt_type = PACKET_BROADCAST;
> +	else
> +		skb->pkt_type = PACKET_MULTICAST;
> +
> +	return netif_rx(skb);
> +}
