Return-Path: <linux-kernel-owner+w=401wt.eu-S1758015AbYAGX2Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015AbYAGX2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 18:28:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYAGX2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 18:28:15 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39749 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755402AbYAGX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 18:28:14 -0500
Date: Mon, 7 Jan 2008 15:10:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: linux-kernel@vger.kernel.org, johnpol@2ka.mipt.ru, mreimer@vpop.net,
       szabolcs.gyurko@tlt.hu
Subject: Re: [PATCH] DS1WM: decouple host IRQ and INTR active state
 settings.
Message-Id: <20080107151022.82901fcc.akpm@linux-foundation.org>
In-Reply-To: <1199627174.28826.11.camel@localhost.localdomain>
References: <1199627174.28826.11.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jan 2008 14:46:14 +0100
Philipp Zabel <philipp.zabel@gmail.com> wrote:

> The DS1WM driver incorrectly infers the IAS bit (1-wire interrupt active
> high) from IRQ settings. There are devices that have IAS=0 but still need
> the IRQ to trigger on a rising edge. With this patch, machines with DS1WM
> that need IAS=1 have to set .active_high=1 in the ds1wm_platform_data.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  drivers/w1/masters/ds1wm.c |    9 +++++----
>  include/linux/ds1wm.h      |    1 +
>  2 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/w1/masters/ds1wm.c b/drivers/w1/masters/ds1wm.c
> index 5747997..688e435 100644
> --- a/drivers/w1/masters/ds1wm.c
> +++ b/drivers/w1/masters/ds1wm.c
> @@ -361,11 +361,12 @@ static int ds1wm_probe(struct platform_device *pdev)
>  		goto err1;
>  	}
>  	ds1wm_data->irq = res->start;
> -	ds1wm_data->active_high = (res->flags & IORESOURCE_IRQ_HIGHEDGE) ?
> -		1 : 0;
> +	ds1wm_data->active_high = plat->active_high;
>  
> -	set_irq_type(ds1wm_data->irq, ds1wm_data->active_high ?
> -			IRQ_TYPE_EDGE_RISING : IRQ_TYPE_EDGE_FALLING);
> +	if (res->flags & IORESOURCE_IRQ_HIGHEDGE)
> +		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_RISING);
> +	if (res->flags & IORESOURCE_IRQ_LOWEDGE)
> +		set_irq_type(ds1wm_data->irq, IRQ_TYPE_EDGE_FALLING);
>  
>  	ret = request_irq(ds1wm_data->irq, ds1wm_isr, IRQF_DISABLED,
>  			  "ds1wm", ds1wm_data);
> diff --git a/include/linux/ds1wm.h b/include/linux/ds1wm.h
> index 31f6e3c..d3c65e4 100644
> --- a/include/linux/ds1wm.h
> +++ b/include/linux/ds1wm.h
> @@ -6,6 +6,7 @@ struct ds1wm_platform_data {
>  			     * e.g. on h5xxx and h2200 this is 2
>  			     * (registers aligned to 4-byte boundaries),
>  			     * while on hx4700 this is 1 */
> +	int active_high;
>  	void (*enable)(struct platform_device *pdev);
>  	void (*disable)(struct platform_device *pdev);
>  };

But no drivers are converted to set ds1wm_platform_data.active_high.  Won't
IORESOURCE_IRQ_HIGHEDGE devices be broken by this change?
