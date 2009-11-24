Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbZKXKxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbZKXKxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 05:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932316AbZKXKxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 05:53:32 -0500
Received: from stinky.trash.net ([213.144.137.162]:65198 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932131AbZKXKxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 05:53:31 -0500
Message-ID: <4B0BBB2E.8020502@trash.net>
Date: Tue, 24 Nov 2009 11:53:34 +0100
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
Subject: Re: [PATCH 4/4] macvlan: export macvlan mode through netlink
References: <1259024166-28158-1-git-send-email-arnd@arndb.de> <1259024166-28158-5-git-send-email-arnd@arndb.de>
In-Reply-To: <1259024166-28158-5-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> @@ -600,6 +594,18 @@ static int macvlan_validate(struct nlattr *tb[], struct nlattr *data[])
>  		if (!is_valid_ether_addr(nla_data(tb[IFLA_ADDRESS])))
>  			return -EADDRNOTAVAIL;
>  	}
> +
> +	if (data && data[IFLA_MACVLAN_MODE]) {
> +		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
> +		switch (mode) {
> +		case MACVLAN_MODE_PRIVATE:
> +		case MACVLAN_MODE_VEPA:
> +		case MACVLAN_MODE_BRIDGE:
> +			break;
> +		default:
> +			return -EINVAL;

EINVAL is quite unspecific. In this case I think EOPNOTSUPP would
be fine and provide more information.

> +		}
> +	}
>  	return 0;
>  }
> @@ -664,6 +670,13 @@ static int macvlan_newlink(struct net *src_net, struct net_device *dev,
>  	vlan->dev      = dev;
>  	vlan->port     = port;
>  
> +	vlan->mode     = MACVLAN_MODE_VEPA;
> +	if (data && data[IFLA_MACVLAN_MODE]) {
> +		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
> +
> +		vlan->mode     = mode;

This looks a bit strange, like cut-and-paste without reformatting :)
I'd suggest to simply use "vlan->mode = nla_get_u32(...)".

> +	}
> +
>  	err = register_netdevice(dev);
>  	if (err < 0)
>  		return err;
> @@ -685,6 +698,39 @@ static void macvlan_dellink(struct net_device *dev, struct list_head *head)
>  		macvlan_port_destroy(port->dev);
>  }
>  
> +static int macvlan_changelink(struct net_device *dev,
> +		struct nlattr *tb[], struct nlattr *data[])
> +{
> +	struct macvlan_dev *vlan = netdev_priv(dev);
> +	if (data && data[IFLA_MACVLAN_MODE]) {
> +		u32 mode = nla_get_u32(data[IFLA_MACVLAN_MODE]);
> +		vlan->mode     = mode;

Same here.

> +	}
> +
> +	return 0;
> +}
