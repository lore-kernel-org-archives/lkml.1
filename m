Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbYHSEvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbYHSEvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 00:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYHSEvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 00:51:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbYHSEvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 00:51:05 -0400
Date: Mon, 18 Aug 2008 21:50:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Xiaoming.Zhang" <Xiaoming.Zhang@resilience.com>
Cc: shemminger@linux-foundation.org, linux-kernel@vger.kernel.org,
       Eric Brower <eric.brower@resilience.com>
Subject: Re: [PATCH] driver/net/skge.c: Restart the interface when it's
 options or pauseparam is set
Message-Id: <20080818215046.f035c715.akpm@linux-foundation.org>
In-Reply-To: <200808071102.52415.Xiaoming.Zhang@resilience.com>
References: <200808071102.52415.Xiaoming.Zhang@resilience.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008 11:02:52 +0800 "Xiaoming.Zhang" <Xiaoming.Zhang@resilience.com> wrote:

> Hi,
> 
> We have an issue of the skge driver: The card won't work when it's options are
> changed. That's the hardware info:
> # lspci -v
> 05:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit Ethernet Controller (rev 13)
>         Subsystem: Marvell Technology Group Ltd. Marvell RDK-8001
>         Flags: bus master, 66MHz, medium devsel, latency 32, IRQ 16
>         Memory at d042c000 (32-bit, non-prefetchable) [size=16K]
>         I/O ports at d000 [size=256]
>         [virtual] Expansion ROM at 20400000 [disabled] [size=128K]
>         Capabilities: [48] Power Management version 2
>         Capabilities: [50] Vital Product Data
> 
> The happens in both Linux-2.6.26(skge version 1.23) and RHEL5.2(skge version 1.6).
> 
> 
> For example, at first it is set to "speed 1000 duplex full auto-neg on" and
> it works, then run 
>        ethtool -s <ethx> autoneg off
> or     ethtool -s <ethx> speed 100 duplex full autoneg off
> 
> Then it will stop working. After that if we restart the interface:
> 	ifconifg <ethx> down
> 	ifconfig <ethx> up
> It will work again. And `ethtool -A' has the same issue.
> 
> So we think after setting the options, the interface should be restarted.
> That's the patch, thank you.
> 
> 
> skge: Restart the interface when it's options or pauseparam is set.
> 
> Signed-off-by: Zhang Xiaoming <xiaoming.zhang@resilience.com>
> ---
> diff -uprN linux-2.6.26/drivers/net/skge.c.orig linux-2.6.26/drivers/net/skge.c
> --- linux-2.6.26/drivers/net/skge.c.orig        2008-08-07 01:26:34.000000000 +0800
> +++ linux-2.6.26/drivers/net/skge.c     2008-08-07 01:29:31.000000000 +0800

Your email client turns tabs into spaces.  I turn spaces back into
tabs, but it gets dull after a while.

> @@ -367,8 +367,10 @@ static int skge_set_settings(struct net_
>         skge->autoneg = ecmd->autoneg;
>         skge->advertising = ecmd->advertising;
> 
> -       if (netif_running(dev))
> -               skge_phy_reset(skge);
> +       if (netif_running(dev)) {
> +               skge_down(dev);
> +               skge_up(dev);
> +       }
> 
>         return (0);
>  }
> @@ -609,8 +611,10 @@ static int skge_set_pauseparam(struct ne
>                         skge->flow_control = FLOW_MODE_NONE;
>         }
> 
> -       if (netif_running(dev))
> -               skge_phy_reset(skge);
> +       if (netif_running(dev)) {
> +               skge_down(dev);
> +               skge_up(dev);
> +       }
> 
>         return 0;
>  }

Seems a bit drastic, although skge_set_ring_param() already does this.

skge_set_ring_param() checks for errors from skge_up(), but the above
code does not.

Mysterious code sequences like the above should be commented, IMO.

I suspect this patch will be treated more as a bug report than as a
patch.  We shall see.

