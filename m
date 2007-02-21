Return-Path: <linux-kernel-owner+w=401wt.eu-S965306AbXBUAZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965306AbXBUAZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965297AbXBUAZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:25:06 -0500
Received: from smtp.osdl.org ([65.172.181.24]:58176 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965271AbXBUAZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:25:03 -0500
Date: Tue, 20 Feb 2007 16:24:34 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>,
       David Howells <dhowells@redhat.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/bridge/br_if.c: fix possible use-after-free in
 port_carrier_check()
Message-ID: <20070220162434.72d3ad7b@freekitty>
In-Reply-To: <20070220221941.GA707@tv-sign.ru>
References: <20070220221941.GA707@tv-sign.ru>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Feb 2007 01:19:41 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> If del_nbp()->cancel_delayed_work(carrier_check) fails, port_carrier_check()
> may run later and access an already freed container (struct net_bridge_port).
> 
> With this patch, carrier_check owns a reference to "struct net_bridge_port",
> not net_device, so it is always safe to acces the container.
> 
> port_carrier_check() uses p->dev->br_port == NULL as indication that net_bridge_port
> is under destruction. Otherwise it assumes that p->dev->br_port == p.
> 
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
> Acked-By: David Howells <dhowells@redhat.com>
> 
> --- WQ/net/bridge/br_if.c~5_bridge_uaf	2007-02-18 23:06:15.000000000 +0300
> +++ WQ/net/bridge/br_if.c	2007-02-20 00:59:54.000000000 +0300
> @@ -83,14 +83,14 @@ static void port_carrier_check(struct wo
>  	struct net_device *dev;
>  	struct net_bridge *br;
>  
> -	dev = container_of(work, struct net_bridge_port,
> -			   carrier_check.work)->dev;
> +	p = container_of(work, struct net_bridge_port, carrier_check.work);
>  
>  	rtnl_lock();
> -	p = dev->br_port;
> -	if (!p)
> -		goto done;
>  	br = p->br;
> +	dev = p->dev;
> +
> +	if (!dev->br_port)
> +		goto done;
>  
>  	if (netif_carrier_ok(dev))
>  		p->path_cost = port_cost(dev);
> @@ -107,14 +107,16 @@ static void port_carrier_check(struct wo
>  		spin_unlock_bh(&br->lock);
>  	}
>  done:
> -	dev_put(dev);
>  	rtnl_unlock();
> +	kobject_put(&p->kobj);
>  }
>  
>  static void release_nbp(struct kobject *kobj)
>  {
>  	struct net_bridge_port *p
>  		= container_of(kobj, struct net_bridge_port, kobj);
> +
> +	dev_put(p->dev);
>  	kfree(p);
>  }
>  
> @@ -127,12 +129,6 @@ static struct kobj_type brport_ktype = {
>  
>  static void destroy_nbp(struct net_bridge_port *p)
>  {
> -	struct net_device *dev = p->dev;
> -
> -	p->br = NULL;
> -	p->dev = NULL;
> -	dev_put(dev);
> -
>  	kobject_put(&p->kobj);
>  }

Moving this around is problematic.
The ordering here was chosen to be RCU friendly so that
p->dev indicates the port is in process of being deleted but traffic
may still be using old reference, but new traffic should not use it.

Probably the best thing to do is pull the whole delayed work queue
and auto port speed stuff. When STP is moved to user space then
it can do the ethtool op there.




-- 
Stephen Hemminger <shemminger@linux-foundation.org>
