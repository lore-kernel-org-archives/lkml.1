Return-Path: <linux-kernel-owner+w=401wt.eu-S1761551AbXJaWFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761551AbXJaWFI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 18:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760689AbXJaWBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 18:01:38 -0400
Received: from mx3.mail.ru ([194.67.23.149]:10089 "EHLO mx3.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760624AbXJaWBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 18:01:37 -0400
Date: Thu, 1 Nov 2007 00:59:03 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Li Yang-r58472 <LeoLi@freescale.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] ucc_geth: add support for netpoll
Message-ID: <20071031215903.GA1287@zarina>
Reply-To: cbou@mail.ru
References: <20071011124842.GB13963@localhost.localdomain> <4723389F.7010109@ru.mvista.com> <20071027143731.GA2616@zarina> <989B956029373F45A0B8AF0297081890019B61BF@zch01exm26.fsl.freescale.net> <20071029121744.GA20372@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071029121744.GA20372@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 03:17:44PM +0300, Anton Vorontsov wrote:
[...]
> > Oops.  The original patch happened to hit the Junk mail box. :(
> 
> That one as well? http://lkml.org/lkml/2007/10/11/128
> 
> > I think
> > the patch is good to merge after the cosmetic change.  I can do it in
> > next pull request to Jeff.
> 
> Ok, great. Thanks.

I'm wondering if you missed that email again. Maybe your mail
client/server doing weird things with emails from @ru.mvista.com?

Thanks.

> Here it is:
> 
> - - - -
> From: Anton Vorontsov <avorontsov@ru.mvista.com>
> Subject: [PATCH] ucc_geth: add support for netpoll
> 
> This patch adds netpoll support for the QE UCC Gigabit Ethernet
> driver. Tested using netconsole and KGDBoE.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/net/ucc_geth.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
> index bec413b..94e78d8 100644
> --- a/drivers/net/ucc_geth.c
> +++ b/drivers/net/ucc_geth.c
> @@ -3678,6 +3678,23 @@ static irqreturn_t ucc_geth_irq_handler(int irq, void *info)
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
> +	int irq = ugeth->ug_info->uf_info.irq;
> +
> +	disable_irq(irq);
> +	ucc_geth_irq_handler(irq, dev);
> +	enable_irq(irq);
> +}
> +#endif /* CONFIG_NET_POLL_CONTROLLER */
> +
>  /* Called when something needs to use the ethernet device */
>  /* Returns 0 for success. */
>  static int ucc_geth_open(struct net_device *dev)
> @@ -3963,6 +3980,9 @@ static int ucc_geth_probe(struct of_device* ofdev, const struct of_device_id *ma
>  #ifdef CONFIG_UGETH_NAPI
>  	netif_napi_add(dev, &ugeth->napi, ucc_geth_poll, UCC_GETH_DEV_WEIGHT);
>  #endif				/* CONFIG_UGETH_NAPI */
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +	dev->poll_controller = ucc_netpoll;
> +#endif
>  	dev->stop = ucc_geth_close;
>  //    dev->change_mtu = ucc_geth_change_mtu;
>  	dev->mtu = 1500;
> -- 
> 1.5.2.2

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.net/bd2
