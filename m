Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbZDJFBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbZDJFBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 01:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZDJFBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 01:01:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32835 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752672AbZDJFBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 01:01:35 -0400
Date: Thu, 9 Apr 2009 21:59:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] skge: fix occasional BUG during MTU change
Message-Id: <20090409215902.0c6251b7.akpm@linux-foundation.org>
In-Reply-To: <20090407183623.7545bb0b@leela>
References: <20090407183623.7545bb0b@leela>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 18:36:23 +0200 Michal Schmidt <mschmidt@redhat.com> wrote:

> The BUG_ON(skge->tx_ring.to_use != skge->tx_ring.to_clean) in skge_up()
> was sometimes observed when setting MTU.
> 
> skge_down() disables the TX queue, but then reenables it by mistake via
> skge_tx_clean().
> Fix it by moving the waking of the queue from skge_tx_clean() to the
> other caller. And to make sure start_xmit is not in progress on another
> CPU, skge_down() should call netif_tx_disable().
> 
> The bug was reported to me by Jiri Jilek whose Debian system sometimes
> failed to boot. He tested the patch and the bug did not happen anymore.

It's conventional to add the reporter's "Reported-by:" tag to the
changelog in this situation.

> Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

As the bug is present in 2.6.29 (and possibly earlier?) it's
appropriate to add a Cc: <stable@kernel.org> too.  This makes davem go
mad at you, but I prefer getting madded at over possibly losing bugfixes ;)

> 
> diff --git a/drivers/net/skge.c b/drivers/net/skge.c
> index 952d37f..b2a05af 100644
> --- a/drivers/net/skge.c
> +++ b/drivers/net/skge.c
> @@ -2674,7 +2674,7 @@ static int skge_down(struct net_device *dev)
>  	if (netif_msg_ifdown(skge))
>  		printk(KERN_INFO PFX "%s: disabling interface\n", dev->name);
>  
> -	netif_stop_queue(dev);
> +	netif_tx_disable(dev);
>  
>  	if (hw->chip_id == CHIP_ID_GENESIS && hw->phy_type == SK_PHY_XMAC)
>  		del_timer_sync(&skge->link_timer);
> @@ -2881,7 +2881,6 @@ static void skge_tx_clean(struct net_device *dev)
>  	}
>  
>  	skge->tx_ring.to_clean = e;
> -	netif_wake_queue(dev);
>  }
>  
>  static void skge_tx_timeout(struct net_device *dev)
> @@ -2893,6 +2892,7 @@ static void skge_tx_timeout(struct net_device *dev)
>  
>  	skge_write8(skge->hw, Q_ADDR(txqaddr[skge->port], Q_CSR), CSR_STOP);
>  	skge_tx_clean(dev);
> +	netif_wake_queue(dev);
>  }
>  
>  static int skge_change_mtu(struct net_device *dev, int new_mtu)

