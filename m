Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZDMPAD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZDMPAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:00:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZDMO7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 10:59:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731AbZDMO7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 10:59:48 -0400
Date: Mon, 13 Apr 2009 07:58:26 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jgarzik@pobox.com,
       davem@davemloft.net, bridge@lists.linux-foundation.org,
       fubar@us.ibm.com, bonding-devel@lists.sourceforge.net, kaber@trash.net,
       mschmidt@redhat.com, dada1@cosmosbay.com, ivecera@redhat.com
Subject: Re: [PATCH 1/4] net: introduce dev_mac_address_changed
Message-ID: <20090413075826.7c8b758e@nehalam>
In-Reply-To: <20090413083848.GB23734@psychotron.englab.brq.redhat.com>
References: <20090313183303.GF3436@psychotron.englab.brq.redhat.com>
	<20090413083729.GA23734@psychotron.englab.brq.redhat.com>
	<20090413083848.GB23734@psychotron.englab.brq.redhat.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 10:38:48 +0200
Jiri Pirko <jpirko@redhat.com> wrote:

> Introducing function dev_mac_address_changed which can be called from driver
> which changed his mac address to force notifiers to be called.
> 
> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> ---
>  include/linux/netdevice.h |    1 +
>  net/core/dev.c            |   12 ++++++++++++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 2e7783f..ff8db51 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1461,6 +1461,7 @@ extern int		dev_change_net_namespace(struct net_device *,
>  extern int		dev_set_mtu(struct net_device *, int);
>  extern int		dev_set_mac_address(struct net_device *,
>  					    struct sockaddr *);
> +extern void		dev_mac_address_changed(struct net_device *);
>  extern int		dev_hard_start_xmit(struct sk_buff *skb,
>  					    struct net_device *dev,
>  					    struct netdev_queue *txq);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 91d792d..1adc89b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3833,6 +3833,18 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa)
>  	return err;
>  }
>  
> +/**
> + *	dev_mac_address_changed - Notify Media Access Control Address changed
> + *	@dev: device
> + *
> + *	Notifies the change of the hardware (MAC) address of the device
> + */
> +void dev_mac_address_changed(struct net_device *dev)
> +{
> +	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
> +}
> +EXPORT_SYMBOL(dev_mac_address_changed);
> +
>  /*
>   *	Perform the SIOCxIFxxx calls, inside read_lock(dev_base_lock)
>   */

The original version of this that I send, allowed notifiers to return
an error to block changing address (error would go back to application).
This is how other notifier hooks work (mtu, etc).

Why is dev_set_mac_address_changed called out separately, it should
be inside dev_set_mac_address. 

