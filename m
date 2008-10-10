Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYJJIrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYJJIrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 04:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYJJIrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:47:16 -0400
Received: from nebensachen.de ([195.34.83.29]:39814 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYJJIrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:47:14 -0400
From: Elias Oltmanns <eo@nebensachen.de>
To: Alan Cox <alan@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Better timeout recovery
Date: Fri, 10 Oct 2008 10:46:21 +0200
Message-ID: <87od1set2a.fsf@denkblock.local>
References: <20081009164351.26205.50193.stgit@localhost.localdomain>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
X-Hashcash: 1:20:081010:alan@redhat.com::zDza0yn8fMPOKPzy:00006s
X-Hashcash: 1:20:081010:linux-kernel@vger.kernel.org::nqS6FPwgFLiixCKh:0000000000000000000000000000000002aDu
X-Hashcash: 1:20:081010:linux-ide@vger.kernel.org::vMa6P5Mmjf1dkzGn:0000000000000000000000000000000000000yFQ
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@redhat.com> wrote:
> Check for completed commands on a timeout, also implement data draining as
> Mark Lord suggested. The former should help a lot on various promise
> controllers which show random IRQ loss now and then, the latter at least for
> me fixes the hanging DRQ cases I can test.
>
> To get the lost IRQ recovery working better we really need to short circuit a
> lot fo the recovery paths we trigger needlessly when EH finds that actually
> all was well.
>
> Signed-off-by: Alan Cox <alan@redhat.com>
> ---

This patch has a lot of style issues. Most of them are caught by
checkpatch. A few more are indicated below:

> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index c1db2f2..fa48031 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
[...]
> @@ -530,7 +530,19 @@ void ata_scsi_error(struct Scsi_Host *host)
>  		int nr_timedout = 0;
>  
>  		spin_lock_irqsave(ap->lock, flags);
> -
> +		
> +		/* This must occur under the ap->lock as we don't want
> +		   a polled recovery to race the real interrupt handler
> +		   
> +		   The lost_interrupt handler checks for any completed but
> +		   non-notified command and completes much like an IRQ handler.
> +		   
> +		   We then fall into the error recovery code which will treat
> +		   this as if normal completion won the race */

I'd very much prefer comments to be formatted like this:

		/* This must occur under the ap->lock as we don't want
		 * a polled recovery to race the real interrupt handler
		 *
		 * The lost_interrupt handler checks for any completed but
		 * non-notified command and completes much like an IRQ handler.
		 *
		 * We then fall into the error recovery code which will treat
		 * this as if normal completion won the race
		 */

There are more of those which I won't bore you with.

[...]
> diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
> index 2a4c516..ea7f0e1 100644
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
[...]
> @@ -1533,7 +1536,7 @@ bool ata_sff_qc_fill_rtf(struct ata_queued_cmd *qc)
>   *	RETURNS:
>   *	One if interrupt was handled, zero if not (shared irq).
>   */
> -inline unsigned int ata_sff_host_intr(struct ata_port *ap,
> +unsigned int ata_sff_host_intr(struct ata_port *ap,
>  				      struct ata_queued_cmd *qc)

Indentation should be adjusted here.

[...]
> @@ -2073,6 +2117,39 @@ void ata_sff_postreset(struct ata_link *link, unsigned int *classes)
>  }
>  
>  /**
> + *	ata_sff_drain_fifo - Stock FIFO drain logic for SFF controllers
> + *	@ap: port to drain
> + *	@qc: command
> + *
> + *	Drain the FIFO and device of any stuck data following a command
> + *	failing to complete. In some cases this is neccessary before a
> + *	reset will recover the device.
> + *
> + */
> + 
> +void ata_sff_drain_fifo(struct ata_queued_cmd *qc)
> +{
> +	int count;
> +	struct ata_port *ap;
> +
> +	/* We only need to flush incoming data when a command was running */
> +	if (qc == NULL || qc->dma_dir == DMA_TO_DEVICE)
> +		return;
> +
> +	ap = qc->ap;
> +	/* Drain up to 64K of data before we give up this recovery method */
> +	for (count = 0; (ap->ops->sff_check_status(ap) & ATA_DRQ)
> +						&& count < 32768; count++)
> +		ioread16(ap->ioaddr.data_addr);
> +
> +	/* Can become DEBUG later */
> +	if (count)
> +		ata_port_printk(ap, KERN_WARNING,
> +			"drained %d bytes to clear DRQ.\n", count);
> +
> +}

Presumably, you didn't intentionally leave a blank line before the
closing brace.

Sorry if you were aware of all that and just sent the patch as a first
draft in order to get comments on the actual code.

Regards,

Elias
