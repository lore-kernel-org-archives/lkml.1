Return-Path: <linux-kernel-owner+w=401wt.eu-S1762319AbXFFLMI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762319AbXFFLMI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 07:12:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbXFFLL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 07:11:56 -0400
Received: from aun.it.uu.se ([130.238.12.36]:58994 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXFFLLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 07:11:55 -0400
Date: Wed, 6 Jun 2007 13:11:37 +0200 (MEST)
Message-Id: <200706061111.l56BBbHB003469@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: htejun@gmail.com, jeff@garzik.org
Subject: Re: [REPOST PATCH] sata_promise: use TF interface for polling NODATA commands
Cc: akpm@linux-foundation.org, david@dgreaves.com, jean.luc.coulon@gmail.com,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org,
       michal.k.k.piotrowski@gmail.com, mikpe@it.uu.se,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007 19:21:22 +0900, Tejun Heo wrote:
> sata_promise uses two different command modes - packet and TF.  Packet
> mode is intelligent low-overhead mode while TF is the same old
> taskfile interface.  As with other advanced interface (ahci/sil24),
> ATA_TFLAG_POLLING has no effect in packet mode.  However, PIO commands
> are issued using TF interface in polling mode, so pdc_interrupt()
> considers interrupts spurious if ATA_TFLAG_POLLING is set.
> 
> This is broken for polling NODATA commands because command is issued
> using packet mode but the interrupt handler ignores it due to
> ATA_TFLAG_POLLING.  Fix pdc_qc_issue_prot() such that ATA/ATAPI NODATA
> commands are issued using TF interface if ATA_TFLAG_POLLING is set.
> 
> This patch fixes detection failure introduced by polling SETXFERMODE.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
> David, please verify this patch.  Mikael, does this look okay?  Please
> push this upstream after David and Mikael's ack.

Thanks Tejun.

I totally agree with the analysis and the solution. I considered bouncing
polled commands back to libata, but Tejun beat me to it :-)

Tested successfully with SATA and PATA disks on 20619, 20575, 20775,
and 40718 chips.

Acked-by: Mikael Pettersson <mikpe@it.uu.se>

/Mikael

> 
> (This repost is identical to the previous posting but it's now on the
>  correct thread.)
> 
> Thanks.
> 
>  drivers/ata/sata_promise.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
> index 2b924a6..6dc0b01 100644
> --- a/drivers/ata/sata_promise.c
> +++ b/drivers/ata/sata_promise.c
> @@ -784,9 +784,12 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
>  		if (qc->dev->flags & ATA_DFLAG_CDB_INTR)
>  			break;
>  		/*FALLTHROUGH*/
> +	case ATA_PROT_NODATA:
> +		if (qc->tf.flags & ATA_TFLAG_POLLING)
> +			break;
> +		/*FALLTHROUGH*/
>  	case ATA_PROT_ATAPI_DMA:
>  	case ATA_PROT_DMA:
> -	case ATA_PROT_NODATA:
>  		pdc_packet_start(qc);
>  		return 0;
>  
> @@ -800,7 +803,7 @@ static unsigned int pdc_qc_issue_prot(struct ata_queued_cmd *qc)
>  static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
>  {
>  	WARN_ON (tf->protocol == ATA_PROT_DMA ||
> -		 tf->protocol == ATA_PROT_NODATA);
> +		 tf->protocol == ATA_PROT_ATAPI_DMA);
>  	ata_tf_load(ap, tf);
>  }
>  
> @@ -808,7 +811,7 @@ static void pdc_tf_load_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
>  static void pdc_exec_command_mmio(struct ata_port *ap, const struct ata_taskfile *tf)
>  {
>  	WARN_ON (tf->protocol == ATA_PROT_DMA ||
> -		 tf->protocol == ATA_PROT_NODATA);
> +		 tf->protocol == ATA_PROT_ATAPI_DMA);
>  	ata_exec_command(ap, tf);
>  }
>  
> 
