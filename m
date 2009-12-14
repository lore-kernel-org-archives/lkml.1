Return-Path: <linux-kernel-owner+w=401wt.eu-S1756469AbZLNMxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756469AbZLNMxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 07:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755377AbZLNMxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 07:53:19 -0500
Received: from stinky.trash.net ([213.144.137.162]:61572 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbZLNMxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 07:53:18 -0500
Message-ID: <4B26353A.9020005@trash.net>
Date: Mon, 14 Dec 2009 13:53:14 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       "" <davem@davemloft.net>, "Michael S. Tsirkin" <mst@redhat.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Or Gerlitz <ogerlitz@voltaire.com>,
       "Fischer, Anna" <anna.fischer@hp.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Edge Virtual Bridging <evb@yahoogroups.com>
Subject: Re: [RFC] macvlan: add tap device backend
References: <1259862720-28432-1-git-send-email-arnd@arndb.de> <1259862720-28432-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1259862720-28432-3-git-send-email-arnd@arndb.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> +static int macvtap_newlink(struct net *src_net,
> +			   struct net_device *dev,
> +			   struct nlattr *tb[],
> +			   struct nlattr *data[])
> +{
> +	struct device *classdev;
> +	dev_t devt;
> +	int err;
> +
> +	err = macvlan_common_newlink(src_net, dev, tb, data,
> +				     macvtap_receive, macvtap_forward);
> +	if (err)
> +		goto out;
> +
> +	devt = MKDEV(MAJOR(macvtap_major), dev->ifindex);
> +
> +	classdev = device_create(macvtap_class, &dev->dev, devt,
> +				 dev, "tap%d", dev->ifindex);
> +	if (IS_ERR(classdev)) {
> +		err = PTR_ERR(classdev);
> +		macvtap_del_queues(dev);
> +		macvlan_dellink(dev, NULL);

I think this may cause a double free since macvlan_dellink() will
free the device and rtnl_newlink() will free it again on error.

> +	}
> +
> +out:
> +	return err;
> +}
> +
> +static void macvtap_dellink(struct net_device *dev,
> +			    struct list_head *head)
> +{
> +	device_destroy(macvtap_class,
> +		       MKDEV(MAJOR(macvtap_major), dev->ifindex));
> +
> +	macvtap_del_queues(dev);
> +	macvlan_dellink(dev, head);
> +}
> +
> +static struct rtnl_link_ops macvtap_link_ops __read_mostly = {
> +	.kind		= "macvtap",
> +	.newlink	= macvtap_newlink,
> +	.dellink	= macvtap_dellink,
> +};
