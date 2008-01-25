Return-Path: <linux-kernel-owner+w=401wt.eu-S1754579AbYAYQTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbYAYQTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 11:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbYAYQTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 11:19:45 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34513 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751780AbYAYQTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 11:19:44 -0500
Date: Fri, 25 Jan 2008 08:19:23 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 108/196] Kobject: change net/bridge to use
 kobject_create_and_add
Message-ID: <20080125081923.22425d36@deepthought>
In-Reply-To: <1201246425-5058-29-git-send-email-gregkh@suse.de>
References: <20080125071127.GA4860@kroah.com>
	<1201246425-5058-29-git-send-email-gregkh@suse.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jan 2008 23:32:17 -0800
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> The kobject in the bridge code is only used for registering with sysfs,
> not for any lifespan rules.  This patch changes it to be only a pointer
> and use the simpler api for this kind of thing.
> 
> Cc: Stephen Hemminger <shemminger@linux-foundation.org>
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  net/bridge/br_if.c       |    2 +-
>  net/bridge/br_private.h  |    2 +-
>  net/bridge/br_sysfs_br.c |   14 ++++----------
>  net/bridge/br_sysfs_if.c |    2 +-
>  4 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> index 935784f..dadec94 100644
> --- a/net/bridge/br_if.c
> +++ b/net/bridge/br_if.c
> @@ -133,7 +133,7 @@ static void del_nbp(struct net_bridge_port *p)
>  	struct net_bridge *br = p->br;
>  	struct net_device *dev = p->dev;
>  
> -	sysfs_remove_link(&br->ifobj, dev->name);
> +	sysfs_remove_link(br->ifobj, dev->name);
>  
>  	dev_set_promiscuity(dev, -1);
>  
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index f666f7b..c11b554 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -124,7 +124,7 @@ struct net_bridge
>  	struct timer_list		tcn_timer;
>  	struct timer_list		topology_change_timer;
>  	struct timer_list		gc_timer;
> -	struct kobject			ifobj;
> +	struct kobject			*ifobj;
>  };
>  
>  extern struct notifier_block br_device_notifier;
> diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
> index 3312e8f..4e7f91f 100644
> --- a/net/bridge/br_sysfs_br.c
> +++ b/net/bridge/br_sysfs_br.c
> @@ -426,16 +426,10 @@ int br_sysfs_addbr(struct net_device *dev)
>  		goto out2;
>  	}
>  
> -
> -	kobject_set_name(&br->ifobj, SYSFS_BRIDGE_PORT_SUBDIR);
> -	br->ifobj.ktype = NULL;
> -	br->ifobj.kset = NULL;
> -	br->ifobj.parent = brobj;
> -
> -	err = kobject_register(&br->ifobj);
> -	if (err) {
> +	br->ifobj = kobject_create_and_add(SYSFS_BRIDGE_PORT_SUBDIR, brobj);
> +	if (!br->ifobj) {
>  		pr_info("%s: can't add kobject (directory) %s/%s\n",
> -			__FUNCTION__, dev->name, kobject_name(&br->ifobj));
> +			__FUNCTION__, dev->name, SYSFS_BRIDGE_PORT_SUBDIR);
>  		goto out3;
>  	}
>  	return 0;
> @@ -453,7 +447,7 @@ void br_sysfs_delbr(struct net_device *dev)
>  	struct kobject *kobj = &dev->dev.kobj;
>  	struct net_bridge *br = netdev_priv(dev);
>  
> -	kobject_unregister(&br->ifobj);
> +	kobject_unregister(br->ifobj);
>  	sysfs_remove_bin_file(kobj, &bridge_forward);
>  	sysfs_remove_group(kobj, &bridge_group);
>  }
> diff --git a/net/bridge/br_sysfs_if.c b/net/bridge/br_sysfs_if.c
> index 79db51f..02b2d50 100644
> --- a/net/bridge/br_sysfs_if.c
> +++ b/net/bridge/br_sysfs_if.c
> @@ -229,7 +229,7 @@ int br_sysfs_addif(struct net_bridge_port *p)
>  			goto out2;
>  	}
>  
> -	err= sysfs_create_link(&br->ifobj, &p->kobj, p->dev->name);
> +	err = sysfs_create_link(br->ifobj, &p->kobj, p->dev->name);
>  out2:
>  	return err;
>  }

Okay, but where is the new kobject freed?

-- 
Stephen Hemminger <stephen.hemminger@vyatta.com>
