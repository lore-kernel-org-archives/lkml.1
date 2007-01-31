Return-Path: <linux-kernel-owner+w=401wt.eu-S1030363AbXAaRWf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbXAaRWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 12:22:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030377AbXAaRWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 12:22:35 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:58785 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030352AbXAaRW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 12:22:26 -0500
Message-ID: <45C0D050.4030302@garzik.org>
Date: Wed, 31 Jan 2007 12:22:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Alan <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: Fix (hopefully) all the remaining problems with
 devices failing setup/identify
References: <20070131172605.2c5dfc78@localhost.localdomain>
In-Reply-To: <20070131172605.2c5dfc78@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan wrote:
> @@ -5142,6 +5174,20 @@
>  	status = ata_chk_status(ap);
>  	if (unlikely(status & ATA_BUSY))
>  		goto idle_irq;
> +		
> +	if (unlikely(qc->tf.command == ATA_CMD_SET_FEATURES && 
> +			qc->tf.feature == SETFEATURES_XFER)) {
> +		/* Let the timings change settle and the drive catch up as
> +		   some hardware needs up to 10uS to get its brain back in
> +		   gear. Taken from the workarounds in drivers/ide done by
> +		   Matthew Faupel/Niccolo Rigacci */
> +		for (i = 0; i < 10; i++) {
> +			if ((status & (ATA_BUSY | ATA_DRQ | ATA_ERR)) == 0)
> +				break;
> +			udelay(1);
> +			status = ata_chk_status(ap);
> +		}


Looks like you should use ata_busy_wait() here, rather than reproducing 
the same code again.

	Jeff


