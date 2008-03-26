Return-Path: <linux-kernel-owner+w=401wt.eu-S1758233AbYCZCXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233AbYCZCXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 22:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYCZCX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 22:23:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53448 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbYCZCX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 22:23:28 -0400
Message-ID: <47E9B39C.5010502@pobox.com>
Date: Tue, 25 Mar 2008 22:23:24 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: yshi <yang.shi@windriver.com>
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Improvev netconsole support for RTL8139 NIC driver
References: <47E9B115.9060109@windriver.com>
In-Reply-To: <47E9B115.9060109@windriver.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yshi wrote:
> In current RTL8139 NIC driver, spin_lock()/spin_unlock() is used
> for irq handler. But for netconsole/netpoll, it prefers
> spin_lock_irqsave()/spin_unlcok_irqrestore(). So this patch fixed
> this problem to improve netconsole/netpoll support.
> 
> Signed-off-by: Yang Shi <yang.shi@windriver.com>
> ---
> b/drivers/net/8139too.c |    9 +++++++++
> 1 file changed, 9 insertions(+)
> ---
> 
> --- a/drivers/net/8139too.c
> +++ b/drivers/net/8139too.c
> @@ -2136,8 +2136,13 @@ static irqreturn_t rtl8139_interrupt (in
>        u16 status, ackstat;
>        int link_changed = 0; /* avoid bogus "uninit" warning */
>        int handled = 0;
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +       unsigned long flags;
> 
> +       spin_lock_irqsave (&tp->lock, flags);
> +#else
>        spin_lock (&tp->lock);
> +#endif
>        status = RTL_R16 (IntrStatus);
> 
>        /* shared irq? */
> @@ -2185,7 +2190,11 @@ static irqreturn_t rtl8139_interrupt (in
>                        RTL_W16 (IntrStatus, TxErr);
>        }
>  out:
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +       spin_unlock_irqrestore (&tp->lock, flags);
> +#else
>        spin_unlock (&tp->lock);
> +#endif

This is bogus -- you should never need to slow down the hot path in such 
a way.

Add a local_irq_save()/restore() to rtl8139_poll_controller() or a 
similar solution, putting the burden on the netpoll/netconsole layer.

	Jeff



