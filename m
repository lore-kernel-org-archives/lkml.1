Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZKXIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZKXIQl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757742AbZKXIQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:16:40 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:49796 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757632AbZKXIQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:16:39 -0500
Message-ID: <4B0B9639.4070607@gmail.com>
Date: Tue, 24 Nov 2009 09:15:53 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>,
       Patrick McHardy <kaber@trash.net>,
       Mark Smith <lk-netdev@lk-netdev.nosense.org>
Subject: Re: [PATCH 2/4] macvlan: cleanup rx statistics
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <1259024166-28158-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1259024166-28158-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 24 Nov 2009 09:15:57 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann a écrit :
> We have very similar code for rx statistics in
> two places in the macvlan driver, with a third
> one being added in the next patch.
> 
> Consolidate them into one function to improve
> overall readability of the driver.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/macvlan.c |   63 +++++++++++++++++++++++++-----------------------
>  1 files changed, 33 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index ae2b5c7..a0dea23 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -116,42 +116,53 @@ static int macvlan_addr_busy(const struct macvlan_port *port,
>  	return 0;
>  }
>  
> +static inline void macvlan_count_rx(const struct macvlan_dev *vlan, int length,
> +			     int success, int multicast)

success and multicast should be declared as bool

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

I find following more readable, it probably generates more branches,
but avoid dirtying rx_errors if it is in another cache line.

if (likely(success)) {
	rx_stats->rx_packets++;
	rx_stats->rx_bytes += length;
	if (multicast)
		rx_stats->multicast++;
} else {
	rx_stats->rx_errors++;
}


> -	rx_stats = per_cpu_ptr(vlan->rx_stats, smp_processor_id());
>  	skb = skb_share_check(skb, GFP_ATOMIC);
> -	if (skb == NULL) {
> -		rx_stats->rx_errors++;
> -		return NULL;
> -	}
> -
> -	rx_stats->rx_bytes += skb->len + ETH_HLEN;
> -	rx_stats->rx_packets++;
> +	macvlan_count_rx(vlan, skb->len + ETH_HLEN, likely(skb != NULL), 0);

its not _likely_ that skb != NULL, its a fact :)

-> macvlan_count_rx(vlan, skb->len + ETH_HLEN, true, false);

