Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZKKP3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZKKP3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756277AbZKKP3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:29:49 -0500
Received: from stinky.trash.net ([213.144.137.162]:33439 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028AbZKKP3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:29:48 -0500
Message-ID: <4AFAD86A.9070506@trash.net>
Date: Wed, 11 Nov 2009 16:29:46 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       arnd@arndb.de, bridge@lists.linux-foundation.org, evb@yahoogroups.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] macvlan: allow in-kernel modules to create and manage
 macvlan devices
References: <20091110222632.24100.14884.stgit@mimic.site> <20091110222757.24100.16046.stgit@mimic.site>
In-Reply-To: <20091110222757.24100.16046.stgit@mimic.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Mullaney wrote:
> The macvlan driver didn't allow for creation/deletion of devices
> by other in-kernel modules. This patch provides common routines
> for both in-kernel and netlink based management. This patch
> also enables macvlan device support for gro for lower level
> devices that support gro.

> -static void macvlan_transfer_operstate(struct net_device *dev)
> +void macvlan_transfer_operstate(struct net_device *dev)
>  {
>  	struct macvlan_dev *vlan = netdev_priv(dev);
>  	const struct net_device *lowerdev = vlan->lowerdev;
> @@ -458,6 +458,7 @@ static void macvlan_transfer_operstate(struct net_device *dev)
>  			netif_carrier_off(dev);
>  	}
>  }
> +EXPORT_SYMBOL_GPL(macvlan_transfer_operstate);

I think this function could be moved to net/core/dev.c or
net/core/link_watch.c. The VLAN code has an identical copy.

> -int macvlan_newlink(struct net_device *dev,
> -		    struct nlattr *tb[], struct nlattr *data[])
> +int macvlan_link_lowerdev(struct net_device *dev,
> +						  struct net_device *lowerdev)

Please indent this more cleanly.

>  {
>  	struct macvlan_dev *vlan = netdev_priv(dev);
>  	struct macvlan_port *port;
> +	int err = 0;
> +
> +	if (lowerdev->macvlan_port == NULL) {
> +		err = macvlan_port_create(lowerdev);
> +		if (err < 0)
> +			return err;
> +	}
> +	port = lowerdev->macvlan_port;
> +
> +	vlan->lowerdev = lowerdev;
> +	vlan->dev      = dev;
> +	vlan->port     = port;
> +	vlan->receive  = netif_rx;
> +
> +	macvlan_init(dev);
> +
> +	list_add_tail(&vlan->list, &port->vlans);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(macvlan_link_lowerdev);

> @@ -502,23 +539,14 @@ int macvlan_newlink(struct net_device *dev,
>  	if (!tb[IFLA_ADDRESS])
>  		random_ether_addr(dev->dev_addr);
>  
> -	if (lowerdev->macvlan_port == NULL) {
> -		err = macvlan_port_create(lowerdev);
> -		if (err < 0)
> -			return err;
> -	}
> -	port = lowerdev->macvlan_port;
> -
> -	vlan->lowerdev = lowerdev;
> -	vlan->dev      = dev;
> -	vlan->port     = port;
> -	vlan->receive  = netif_rx;
> +	err = macvlan_link_lowerdev(dev, lowerdev);
> +	if (err < 0)
> +		return err;
>
>  	err = register_netdevice(dev);
>  	if (err < 0)
>  		return err;

You've already added the device to the port->vlans list, so you
need to remove it again when register_netdevice() fails.

> -	list_add_tail(&vlan->list, &port->vlans);
>  	macvlan_transfer_operstate(dev);
>  	return 0;
>  }
> @@ -526,14 +554,8 @@ EXPORT_SYMBOL_GPL(macvlan_newlink);
