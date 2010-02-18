Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0BRFNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 00:13:43 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:38870 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115Ab0BRFNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 00:13:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAHdafEtLd/sX/2dsb2JhbAAHgn7Gf49vgTCCUVwEgxU
X-IronPort-AV: E=Sophos;i="4.49,495,1262581200"; 
   d="scan'208";a="56252388"
Message-ID: <4B7CCC7E.3060108@teksavvy.com>
Date: Thu, 18 Feb 2010 00:13:34 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [RFC 1/4] libata: cache device select
References: <20100217130847.16338.55586.stgit@localhost.localdomain>
In-Reply-To: <20100217130847.16338.55586.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/10 08:10, Alan Cox wrote:
> Avoid the device select overhead on every qc_issue (>  10uS) by caching the
> currently selected device. This shows up on profiles under load. Best case
> this costs us 10uS for the delay, worst case with a dumb interface it's
> costing us about *1mS* a command.
>
> I believe the logic here is sufficient, but would welcome some second reviews
> as its not something you want to get wrong !
>
> Signed-off-by: Alan Cox<alan@linux.intel.com>
..

I totally agree with this patch, but question the timings used to justify it.
Surely the overhead is only 1-2usec for the case where the device
is the one that was already selected (on a "smart" interface) ?

And for the case where the currently selected device is different
than the desired device (the 1msec case), this patch makes little/no difference?

Cheers


> ---
>
>   drivers/ata/libata-sff.c |    8 ++++++--
>   include/linux/libata.h   |    1 +
>   2 files changed, 7 insertions(+), 2 deletions(-)
>
>
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 63d9c6a..cf0332a 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -469,6 +469,7 @@ void ata_sff_dev_select(struct ata_port *ap, unsigned int device)
>
>   	iowrite8(tmp, ap->ioaddr.device_addr);
>   	ata_sff_pause(ap);	/* needed; also flushes, for mmio */
> +	ap->sff_selected = device;
>   }
>   EXPORT_SYMBOL_GPL(ata_sff_dev_select);
>
> @@ -1538,7 +1539,8 @@ unsigned int ata_sff_qc_issue(struct ata_queued_cmd *qc)
>   	}
>
>   	/* select the device */
> -	ata_dev_select(ap, qc->dev->devno, 1, 0);
> +	if (qc->dev->devno != ap->sff_selected)
> +        	ata_dev_select(ap, qc->dev->devno, 1, 0);
>
>   	/* start the command */
>   	switch (qc->tf.protocol) {
> @@ -1925,6 +1927,8 @@ int ata_sff_prereset(struct ata_link *link, unsigned long deadline)
>   	struct ata_eh_context *ehc =&link->eh_context;
>   	int rc;
>
> +	link->ap->sff_selected = -1;	/* Unknown */
> +
>   	rc = ata_std_prereset(link, deadline);
>   	if (rc)
>   		return rc;
> @@ -2687,7 +2691,7 @@ void ata_bus_reset(struct ata_port *ap)
>   		iowrite8(ap->ctl, ioaddr->ctl_addr);
>   		ap->last_ctl = ap->ctl;
>   	}
> -
> +	ap->sff_selected = -1;
>   	DPRINTK("EXIT\n");
>   	return;
>
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 5fb8884..a85adc2 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -725,6 +725,7 @@ struct ata_port {
>
>   #ifdef CONFIG_ATA_SFF
>   	struct ata_ioports	ioaddr;	/* ATA cmd/ctl/dma register blocks */
> +	int			sff_selected;	/* Cache of selected device */
>   #endif /* CONFIG_ATA_SFF */
>
>   	u8			ctl;	/* cache of ATA control register */
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

