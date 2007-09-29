Return-Path: <linux-kernel-owner+w=401wt.eu-S1757965AbXI2GYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbXI2GYh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 02:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbXI2GY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 02:24:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58503 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXI2GYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 02:24:25 -0400
Message-ID: <46FDEF90.9050702@pobox.com>
Date: Sat, 29 Sep 2007 02:24:16 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Mark Lord <liml@rtr.ca>
CC: Tejun Heo <htejun@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       michal.k.k.piotrowski@gmail.com, bryan@arbores.ca,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata drain fifo on stuck DRQ HSM violation (try#2)
References: <46CFA08E.6090604@arbores.ca> <6bffcb0e0708261610g10d9c59ck5789fac6feca9f42@mail.gmail.com> <46DBCB6C.8080206@gmail.com> <20070905095327.6277d054.akpm@linux-foundation.org>	<46DEE617.4050004@rtr.ca> <46E0A253.7060803@gmail.com>	<46E154DE.2060602@rtr.ca> <46FB563A.80108@gmail.com>	<20070927193701.6230d77f@the-village.bc.nu> <46FC3D7D.90009@gmail.com>	<46FC3FDD.5060201@pobox.com> <46FC423C.2050206@gmail.com>	<46FC7B72.2030103@rtr.ca> <20070928112735.264733ad@the-village.bc.nu> <46FD0486.3060405@rtr.ca>
In-Reply-To: <46FD0486.3060405@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> I think this original patch still applies cleanly on at least 2.6.23-rc7.
> 
> Drain up to 512 words from host/bridge FIFO on stuck DRQ HSM violation,
> rather than just getting stuck there forever.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> 
> --- old/drivers/ata/libata-sff.c    2007-09-28 09:29:22.000000000 -0400
> +++ linux/drivers/ata/libata-sff.c    2007-09-28 09:39:44.000000000 -0400
> @@ -420,6 +420,28 @@
>     ap->ops->irq_on(ap);
> }
> 
> +static void ata_drain_fifo(struct ata_port *ap, struct ata_queued_cmd *qc)
> +{
> +    u8 stat = ata_chk_status(ap);
> +    /*
> +     * Try to clear stuck DRQ if necessary,
> +     * by reading/discarding up to two sectors worth of data.
> +     */
> +    if ((stat & ATA_DRQ) && (!qc || qc->dma_dir != DMA_TO_DEVICE)) {
> +        unsigned int i;
> +        unsigned int limit = qc ? qc->sect_size : ATA_SECT_SIZE;
> +
> +        printk(KERN_WARNING "Draining up to %u words from data FIFO.\n",
> +                                    limit);
> +        for (i = 0; i < limit ; ++i) {
> +            ioread16(ap->ioaddr.data_addr);
> +            if (!(ata_chk_status(ap) & ATA_DRQ))
> +                break;
> +        }
> +        printk(KERN_WARNING "Drained %u/%u words.\n", i, limit);
> +    }
> +}
> +
> /**
>  *    ata_bmdma_drive_eh - Perform EH with given methods for BMDMA 
> controller
>  *    @ap: port to handle error for
> @@ -476,7 +498,7 @@
>     }
> 
>     ata_altstatus(ap);
> -    ata_chk_status(ap);
> +    ata_drain_fifo(ap, qc);
>     ap->ops->irq_clear(ap);
> 
>     spin_unlock_irqrestore(ap->lock, flags);

applied, after hand-editing out the top of the message, so that it would 
not be copied into the kernel changelog

