Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262Ab0ARUsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0ARUsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 15:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052Ab0ARUsI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 15:48:08 -0500
Received: from www.tglx.de ([62.245.132.106]:32846 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752762Ab0ARUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 15:48:07 -0500
Date: Mon, 18 Jan 2010 21:47:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andreas Mohr <andi@lisas.de>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       Julia Lawall <julia@diku.dk>
Subject: Re: mcs7830 usb net: "scheduling while atomic" danger?
In-Reply-To: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
Message-ID: <alpine.LFD.2.00.1001182145060.2906@localhost.localdomain>
References: <20100118184942.GA10171@rhlx01.hs-esslingen.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
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

No, that's different. You are allowed to sleep with a mutex held. The
thread is about spin_lock()/msleep().

spin_lock() is implicitly disabling preemption, mutex_lock() does not.

Thanks,

	tglx
