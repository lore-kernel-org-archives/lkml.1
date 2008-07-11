Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbYGKPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbYGKPez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYGKPer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:34:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52902 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277AbYGKPeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:34:46 -0400
Date: Fri, 11 Jul 2008 08:34:23 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bridge: send correct MTU value in PMTU
Message-ID: <20080711083423.64b67c0c@extreme>
In-Reply-To: <20080711124735.GA16996@hrz.tu-chemnitz.de>
References: <20080711124735.GA16996@hrz.tu-chemnitz.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2008 14:47:35 +0200
Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de> wrote:

> When bridging interfaces with different MTUs, the bridge correctly
> chooses
> the minimum of the MTUs of the physical devices as the bridges MTU. But
> when a frame is passed which fits through the incoming, but not through
> the
> outgoing interface, a "Fragmentation Needed" packet is generated.
> However, the propagated MTU is hardcoded to 1500, which is wrong in this
> situation. The sender will repeat the packet again with the same frame
> size,
> and the same problem will occur again.
> 
> Instead of sending 1500, the (correct) MTU value of the bridge is now
> sent via PMTU. To achieve this, the corresponding rtable structure is
> stored in its net_bridge structure.
> 
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
>  net/bridge/br_device.c    |    5 ++++-
>  net/bridge/br_if.c        |   31 +++++++++++++++++++++++++++++++
>  net/bridge/br_netfilter.c |   45 ++++++++++++---------------------------------
>  net/bridge/br_private.h   |    4 ++++
>  4 files changed, 51 insertions(+), 34 deletions(-)
> 
> diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> index bf77873..a52075b 100644
> --- a/net/bridge/br_device.c
> +++ b/net/bridge/br_device.c
> @@ -76,10 +76,13 @@ static int br_dev_stop(struct net_device *dev)
>  
>  static int br_change_mtu(struct net_device *dev, int new_mtu)
>  {
> -	if (new_mtu < 68 || new_mtu > br_min_mtu(netdev_priv(dev)))
> +	struct net_bridge *br = netdev_priv(dev);
> +	if (new_mtu < 68 || new_mtu > br_min_mtu(br))
>  		return -EINVAL;
>  
>  	dev->mtu = new_mtu;
> +	/* remember the MTU in the rtable for PMTU */
> +	br->fake_rtable.u.dst.metrics[RTAX_MTU - 1] = new_mtu;
>  	return 0;
>  }
>  
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index f38cc53..b8d438d 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -170,6 +170,34 @@ static void del_br(struct net_bridge *br)
>  	unregister_netdevice(br->dev);
>  }
>  
> +/* We need these fake structures to make netfilter happy --
> + * lots of places assume that skb->dst != NULL, which isn't
> + * all that unreasonable.
> + *
> + * Currently, we fill in the PMTU entry because netfilter
> + * refragmentation needs it, and the rt_flags entry because
> + * ipt_REJECT needs it.  Future netfilter modules might
> + * require us to fill additional fields. */
> +struct net_device __fake_net_device = {
> +	.hard_header_len	= ETH_HLEN,
> +#ifdef CONFIG_NET_NS
> +	.nd_net			= &init_net,
> +#endif
> +};
> +
> +struct rtable __fake_rtable = {
> +	.u = {
> +		.dst = {
> +			.__refcnt		= ATOMIC_INIT(1),
> +			.dev			= &__fake_net_device,
> +			.path			= &__fake_rtable.u.dst,
> +			.metrics		= {[RTAX_MTU - 1] = 1500},
> +			.flags			= DST_NOXFRM,
> +		}
> +	},
> +	.rt_flags	= 0,
> +};
> +
>  static struct net_device *new_bridge_dev(const char *name)
>  {
>  	struct net_bridge *br;
> @@ -204,6 +232,9 @@ static struct net_device *new_bridge_dev(const char *name)
>  	br->topology_change = 0;
>  	br->topology_change_detected = 0;
>  	br->ageing_time = 300 * HZ;
> +	memcpy(&br->fake_rtable, &__fake_rtable, sizeof(__fake_rtable));
> +	br->fake_rtable.u.dst.path = &br->fake_rtable.u.dst;
> +
>  	INIT_LIST_HEAD(&br->age_list);
>  
>  	br_stp_timer_init(br);
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index bb90cd7..9d6a578 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -101,33 +101,12 @@ static inline __be16 pppoe_proto(const struct sk_buff *skb)
>  	 pppoe_proto(skb) == htons(PPP_IPV6) && \
>  	 brnf_filter_pppoe_tagged)
>  
> -/* We need these fake structures to make netfilter happy --
> - * lots of places assume that skb->dst != NULL, which isn't
> - * all that unreasonable.
> - *
> - * Currently, we fill in the PMTU entry because netfilter
> - * refragmentation needs it, and the rt_flags entry because
> - * ipt_REJECT needs it.  Future netfilter modules might
> - * require us to fill additional fields. */
> -static struct net_device __fake_net_device = {
> -	.hard_header_len	= ETH_HLEN,
> -#ifdef CONFIG_NET_NS
> -	.nd_net			= &init_net,
> -#endif
> -};
> +static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
> +{
> +	struct net_bridge_port *port = rcu_dereference(dev->br_port);
>  
> -static struct rtable __fake_rtable = {
> -	.u = {
> -		.dst = {
> -			.__refcnt		= ATOMIC_INIT(1),
> -			.dev			= &__fake_net_device,
> -			.path			= &__fake_rtable.u.dst,
> -			.metrics		= {[RTAX_MTU - 1] = 1500},
> -			.flags			= DST_NOXFRM,
> -		}
> -	},
> -	.rt_flags	= 0,
> -};
> +	return port ? &port->br->fake_rtable: &__fake_rtable;
> +}


port should always be non-null so the existing fake_rtable can
just go away no?

Also some of this could be #ifdef CONFIG_BRNETFILTER
