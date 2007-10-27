Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbXJ0NJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbXJ0NJy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 09:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbXJ0NJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 09:09:45 -0400
Received: from homer.mvista.com ([63.81.120.155]:1770 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752615AbXJ0NJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 09:09:44 -0400
Message-ID: <4723389F.7010109@ru.mvista.com>
Date: Sat, 27 Oct 2007 17:09:51 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: netdev@vger.kernel.org, linuxppc-dev@ozlabs.org, leoli@freescale.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ucc_geth: add support for netpoll
References: <20071011124842.GB13963@localhost.localdomain>
In-Reply-To: <20071011124842.GB13963@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Anton Vorontsov wrote:

> This patch adds netpoll support for the QE UCC Gigabit Ethernet
> driver. The approach is very similar to the gianfar driver.

    It's rather contrarywise -- this is standard approach and gianfar with its 
3 TSEC IRQs has a quite non-standard poll_controller() implementation.

> Tested using netconsole.

    KGDBoE is considered a better test (I hope you've also tested with it).

> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
> index 18a6f48..06807ce 100644
> --- a/drivers/net/ucc_geth.c
> +++ b/drivers/net/ucc_geth.c
> @@ -3691,6 +3691,22 @@ static irqreturn_t ucc_geth_irq_handler(int irq, void *info)
>  	return IRQ_HANDLED;
>  }
>  
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +/*
> + * Polling 'interrupt' - used by things like netconsole to send skbs
> + * without having to re-enable interrupts. It's not called while
> + * the interrupt routine is executing.
> + */
> +static void ucc_netpoll(struct net_device *dev)
> +{
> +	struct ucc_geth_private *ugeth = netdev_priv(dev);
> +
> +	disable_irq(ugeth->ug_info->uf_info.irq);
> +	ucc_geth_irq_handler(ugeth->ug_info->uf_info.irq, dev);
> +	enable_irq(ugeth->ug_info->uf_info.irq);

    Why not make it less complex (for a reader and gcc too :-) ?

	struct ucc_geth_private *ugeth = netdev_priv(dev);
	int irq = ugeth->ug_info->uf_info.irq;

	disable_irq(irq);
	ucc_geth_irq_handler(irq, dev);
	enable_irq(irq);

> +}
> +#endif /* CONFIG_NET_POLL_CONTROLLER */
> +
>  /* Called when something needs to use the ethernet device */
>  /* Returns 0 for success. */
>  static int ucc_geth_open(struct net_device *dev)

WBR, Sergei
