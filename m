Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812Ab0ARVKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab0ARVKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:10:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434Ab0ARVKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:10:47 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:50499 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab0ARVKq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:10:46 -0500
Date: Mon, 18 Jan 2010 22:10:43 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
Message-ID: <Pine.LNX.4.64.1001182206190.30446@ask.diku.dk>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010, Andreas Mohr wrote:

> Hi,
> 
> drivers/net/usb/mcs7830.c does several:
> 
>         mutex_lock(&dev->phy_mutex);
>         /* write the MII command */
>         ret = mcs7830_set_reg(dev, HIF_REG_PHY_CMD1, 2, cmd);
>         if (ret < 0)
>                 goto out;
> 
>         /* wait for the data to become valid, should be within < 1ms */
>         for (i = 0; i < 10; i++) {
>                 ret = mcs7830_get_reg(dev, HIF_REG_PHY_CMD1, 2, cmd);
>                 if ((ret < 0) || (cmd[1] &
> HIF_REG_PHY_CMD2_READY_FLAG_BIT))
>                         break;
>                 ret = -EIO;
>                 msleep(1);
>         }
> 
> 
> Forgive me, but doesn't that mutex_lock()/msleep() (ab)use mean
> risking a "scheduling while atomic"?
> (such as discussed in e.g.
> http://search.luky.org/linux-kernel.2004/msg92817.html )
> 
> 
> And, if that is the case, shouldn't all such cases simply be killed for
> good via a capable semantic patch?

The semantic match shown below finds 55 matches.  All but two involve 
mutex_lock.  Those are in the file 
/var/linuxes/linux-next/drivers/usb/host/ehci-hub.c
in the functions ehci_bus_suspend and ehci_hub_control.

julia


@@
@@

(
*mutex_lock(...)
|
*spin_lock(...)
|
*spin_lock_irq(...)
|
*spin_lock_irqsave(...)
)
... when != mutex_unlock(...)
    when != spin_unlock(...)
    when != spin_unlock_irq(...)
    when != spin_unlock_irqrestore(...)
*msleep(...)
