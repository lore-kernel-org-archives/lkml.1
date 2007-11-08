Return-Path: <linux-kernel-owner+w=401wt.eu-S1762846AbXKHTBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762846AbXKHTBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:01:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761530AbXKHTBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:01:20 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:47802 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760895AbXKHTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:01:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=tyPDhTSDzTaCmvf6ReRKvQqcBFTrd8B1Z2aUqLEN2TFXKh2UNdHhP+XWd4ud4GaMLWj3fX4puMKHtOeznHDW4cqtt1Hhy8NDiO5NCN93NqQPILj/DH3aiNSJs/TueUsW0f0PhRd7ADAMgU8cVL9nUpEQ778O6kwp2q6tPKMvU1o=  ;
X-YMail-OSG: mU9A6TEVM1k.0iAKS2I_vVnczRabcg82j4zIQ7NuYwRQT45R4fCHBuc42HBfmilqiFu4jXBFPQ--
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] spi: Fix error paths on txx9spi_probe
Date: Thu, 8 Nov 2007 10:46:22 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20071108.233516.92587434.anemo@mba.ocn.ne.jp>
In-Reply-To: <20071108.233516.92587434.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711081046.22630.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2007, Atsushi Nemoto wrote:
> Some error paths in txx9spi_probe wrongly return 0.  This patch fixes
> them by using the devres interfaces.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

ACK

> ---
>  drivers/spi/spi_txx9.c |   40 ++++++++++++++++++++--------------------
>  1 files changed, 20 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/spi/spi_txx9.c b/drivers/spi/spi_txx9.c
> index cc5094f..363ac8e 100644
> --- a/drivers/spi/spi_txx9.c
> +++ b/drivers/spi/spi_txx9.c
> @@ -24,6 +24,7 @@
>  #include <linux/spi/spi.h>
>  #include <linux/err.h>
>  #include <linux/clk.h>
> +#include <linux/io.h>
>  #include <asm/gpio.h>
>  
>  
> @@ -74,7 +75,6 @@ struct txx9spi {
>  	struct list_head queue;
>  	wait_queue_head_t waitq;
>  	void __iomem *membase;
> -	int irq;
>  	int baseclk;
>  	struct clk *clk;
>  	u32 max_speed_hz, min_speed_hz;
> @@ -350,12 +350,12 @@ static int __init txx9spi_probe(struct platform_device *dev)
>  	struct resource *res;
>  	int ret = -ENODEV;
>  	u32 mcr;
> +	int irq;
>  
>  	master = spi_alloc_master(&dev->dev, sizeof(*c));
>  	if (!master)
>  		return ret;
>  	c = spi_master_get_devdata(master);
> -	c->irq = -1;
>  	platform_set_drvdata(dev, master);
>  
>  	INIT_WORK(&c->work, txx9spi_work);
> @@ -381,32 +381,36 @@ static int __init txx9spi_probe(struct platform_device *dev)
>  
>  	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
>  	if (!res)
> -		goto exit;
> -	c->membase = ioremap(res->start, res->end - res->start + 1);
> +		goto exit_busy;
> +	if (!devm_request_mem_region(&dev->dev,
> +				     res->start, res->end - res->start + 1,
> +				     "spi_txx9"))
> +		goto exit_busy;
> +	c->membase = devm_ioremap(&dev->dev,
> +				  res->start, res->end - res->start + 1);
>  	if (!c->membase)
> -		goto exit;
> +		goto exit_busy;
>  
>  	/* enter config mode */
>  	mcr = txx9spi_rd(c, TXx9_SPMCR);
>  	mcr &= ~(TXx9_SPMCR_OPMODE | TXx9_SPMCR_SPSTP | TXx9_SPMCR_BCLR);
>  	txx9spi_wr(c, mcr | TXx9_SPMCR_CONFIG | TXx9_SPMCR_BCLR, TXx9_SPMCR);
>  
> -	c->irq = platform_get_irq(dev, 0);
> -	if (c->irq < 0)
> -		goto exit;
> -	ret = request_irq(c->irq, txx9spi_interrupt, 0, dev->name, c);
> -	if (ret) {
> -		c->irq = -1;
> +	irq = platform_get_irq(dev, 0);
> +	if (irq < 0)
> +		goto exit_busy;
> +	ret = devm_request_irq(&dev->dev, irq, txx9spi_interrupt, 0,
> +			       "spi_txx9", c);
> +	if (ret)
>  		goto exit;
> -	}
>  
>  	c->workqueue = create_singlethread_workqueue(master->dev.parent->bus_id);
>  	if (!c->workqueue)
> -		goto exit;
> +		goto exit_busy;
>  	c->last_chipselect = -1;
>  
>  	dev_info(&dev->dev, "at %#llx, irq %d, %dMHz\n",
> -		 (unsigned long long)res->start, c->irq,
> +		 (unsigned long long)res->start, irq,
>  		 (c->baseclk + 500000) / 1000000);
>  
>  	master->bus_num = dev->id;
> @@ -418,13 +422,11 @@ static int __init txx9spi_probe(struct platform_device *dev)
>  	if (ret)
>  		goto exit;
>  	return 0;
> +exit_busy:
> +	ret = -EBUSY;
>  exit:
>  	if (c->workqueue)
>  		destroy_workqueue(c->workqueue);
> -	if (c->irq >= 0)
> -		free_irq(c->irq, c);
> -	if (c->membase)
> -		iounmap(c->membase);
>  	if (c->clk) {
>  		clk_disable(c->clk);
>  		clk_put(c->clk);
> @@ -442,8 +444,6 @@ static int __exit txx9spi_remove(struct platform_device *dev)
>  	spi_unregister_master(master);
>  	platform_set_drvdata(dev, NULL);
>  	destroy_workqueue(c->workqueue);
> -	free_irq(c->irq, c);
> -	iounmap(c->membase);
>  	clk_disable(c->clk);
>  	clk_put(c->clk);
>  	spi_master_put(master);
> 


