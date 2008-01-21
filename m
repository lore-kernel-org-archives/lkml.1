Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbYAUXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbYAUXCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 18:02:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbYAUXBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 18:01:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:17979 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYAUXBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 18:01:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lfChlQxxRoK7cZcVtGnON+Gk1+sMOgB8h5hdyipOQa6RKW1wnZTxZJeiZdyp74hTH0BJEGEqGw1GV9oolQDM71o0/vtXZbdkR6LnBbl93UYleeaj7HuhORR/fCZsM1baH7HFfB7JiY0XAFBIByk1bw4Dwvka/qw/HSw8l3QNKvY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] pata_pdc202xx_old: Fix crashes with ATAPI
Date: Tue, 22 Jan 2008 00:13:53 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: jeff@garzik.org, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
References: <20080119155126.180a010d@lxorguk.ukuu.org.uk>
In-Reply-To: <20080119155126.180a010d@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801220013.53545.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Saturday 19 January 2008, Alan Cox wrote:
> The PDC202xx older devices do not support ATAPI DMA via the usual
> interfaces. What documentation I have isn't sufficient to support DMA and
> it isn't clear if the Windows drivers do this or it is possible at all.
> (Neither do the drivers/ide old drivers)

IDE pdc202xx_old host driver supports ATAPI DMA just fine and in line
with the PDC2026x programming guide.

> So turn it ATAPI DMA off, these are disk optimised controllers.

This is an acceptable workaround for 2.6.24 but it probably just hides
some deeper pata_pdc202xx_old or/and libata problem.

Thanks,
Bart

> Signed-off-by: Alan Cox <alan@redhat.com>
> 
> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c linux-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c
> --- linux.vanilla-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c	2008-01-19 14:47:56.000000000 +0000
> +++ linux-2.6.24-rc8-mm1/drivers/ata/pata_pdc202xx_old.c	2008-01-19 15:19:25.000000000 +0000
> @@ -243,6 +243,24 @@
>  	return ata_sff_port_start(ap);
>  }
>  
> +/**
> + *	pdc2026x_check_atapi_dma - Check whether ATAPI DMA can be supported for this command
> + *	@qc: Metadata associated with taskfile to check
> + *
> + *	Just say no - not supported on older Promise.
> + *
> + *	LOCKING:
> + *	None (inherited from caller).
> + *
> + *	RETURNS: 0 when ATAPI DMA can be used
> + *		 1 otherwise
> + */
> +
> +static int pdc2026x_check_atapi_dma(struct ata_queued_cmd *qc)
> +{
> +	return 1;
> +}
> +
>  static struct scsi_host_template pdc202xx_sht = {
>  	.module			= THIS_MODULE,
>  	.name			= DRV_NAME,
> @@ -310,6 +328,7 @@
>  	.post_internal_cmd = ata_bmdma_post_internal_cmd,
>  	.cable_detect	= pdc2026x_cable_detect,
>  
> +	.check_atapi_dma= pdc2026x_check_atapi_dma,
>  	.bmdma_setup 	= ata_bmdma_setup,
>  	.bmdma_start 	= pdc2026x_bmdma_start,
>  	.bmdma_stop	= pdc2026x_bmdma_stop,
