Return-Path: <linux-kernel-owner+w=401wt.eu-S1754456AbZKRGbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbZKRGbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 01:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753736AbZKRGbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 01:31:12 -0500
Received: from gw1.cosmosbay.com ([212.99.114.194]:43427 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbZKRGbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 01:31:11 -0500
Message-ID: <4B03949D.4000908@gmail.com>
Date: Wed, 18 Nov 2009 07:30:53 +0100
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Patrick McHardy <kaber@trash.net>,
       Patrick Mullaney <pmullaney@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Edge Virtual Bridging <evb@yahoogroups.com>,
       Anna Fischer <anna.fischer@hp.com>, bridge@lists.linux-foundation.org,
       virtualization@linux-foundation.com,
       Jens Osterkamp <jens@linux.vnet.ibm.com>,
       Gerhard Stenzel <gerhard.stenzel@de.ibm.com>
Subject: Re: [PATCH 1/3] macvlan: Reflect macvlan packets meant for other
 macvlan devices
References: <1258497551-25959-1-git-send-email-arnd@arndb.de> <1258497551-25959-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1258497551-25959-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Wed, 18 Nov 2009 07:30:55 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann a écrit :
> From: Eric Biederman <ebiederm@xmission.com>
> 
> Switch ports do not send packets back out the same port they came
> in on.	This causes problems when using a macvlan device inside
> of a network namespace as it becomes impossible to talk to
> other macvlan devices.

This patch is very welcome. I review it and found one oddity.

> 
> Signed-off-by: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> +static int macvlan_queue_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	const struct macvlan_dev *vlan = netdev_priv(dev);
> +	const struct macvlan_port *port = vlan->port;
> +	const struct macvlan_dev *dest;
> +	const struct ethhdr *eth;
>  
> -	skb->dev = dev;
> -	skb->pkt_type = PACKET_HOST;
> +	skb->protocol = eth_type_trans(skb, dev);
> +	eth = eth_hdr(skb);
>  
> -	netif_rx(skb);
> -	return NULL;
> +	skb_dst_drop(skb);

Why do you drop dst here ?

It seems strange, since this driver specifically masks out IFF_XMIT_DST_RELEASE
in its macvlan_setup() :

dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;

If we really want to drop dst, it could be done by caller, if IFF_XMIT_DST_RELEASE
was not masked in macvlan_setup().


> +	skb->mark = 0;
> +	secpath_reset(skb);
> +	nf_reset(skb);
> +
> +	if (is_multicast_ether_addr(eth->h_dest)) {
> +		macvlan_broadcast(skb, port, dev);
> +		return macvlan_xmit_world(skb, dev);
> +	}
> +
> +	dest = macvlan_hash_lookup(port, eth->h_dest);
> +	if (dest)
> +		return macvlan_unicast(skb, dest);
> +
> +	return macvlan_xmit_world(skb, dev);
>  }


# find net drivers/net|xargs grep -n IFF_XMIT_DST_RELEASE
net/8021q/vlan_dev.c:837:       dev->priv_flags         &= ~IFF_XMIT_DST_RELEASE;
net/atm/clip.c:561:     dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
net/core/dev.c:1778:            if (dev->priv_flags & IFF_XMIT_DST_RELEASE)
net/core/dev.c:5287:    dev->priv_flags = IFF_XMIT_DST_RELEASE;
net/ipv4/ip_gre.c:1236: dev->priv_flags         &= ~IFF_XMIT_DST_RELEASE;
net/ipv4/ipip.c:717:    dev->priv_flags         &= ~IFF_XMIT_DST_RELEASE;
net/ipv6/sit.c:1104:    dev->priv_flags        &= ~IFF_XMIT_DST_RELEASE;
drivers/net/appletalk/ipddp.c:76:       dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
drivers/net/bonding/bond_main.c:4534:   bond_dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
drivers/net/eql.c:197:  dev->priv_flags        &= ~IFF_XMIT_DST_RELEASE;
drivers/net/ifb.c:162:  dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
drivers/net/loopback.c:174:     dev->priv_flags        &= ~IFF_XMIT_DST_RELEASE;
drivers/net/macvlan.c:421:      dev->priv_flags        &= ~IFF_XMIT_DST_RELEASE;
drivers/net/ppp_generic.c:1057: dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
drivers/net/wan/hdlc_fr.c:1057: dev->priv_flags &= ~IFF_XMIT_DST_RELEASE;
