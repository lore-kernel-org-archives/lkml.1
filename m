Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbYF0Glz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbYF0Glz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 02:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbYF0GlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 02:41:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47270 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbYF0GlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 02:41:23 -0400
Message-ID: <48648B7D.5050908@pobox.com>
Date: Fri, 27 Jun 2008 02:41:01 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Pavel Machek <pavel@suse.cz>
CC: Tejun Heo <tj@kernel.org>, Andreas Schwab <schwab@suse.de>,
       kernel list <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: sata_svw data corruption, strange problems
References: <20080617093602.GA28140@elf.ucw.cz> <485EF061.3010601@kernel.org> <20080623082055.GB1850@elf.ucw.cz> <je63s0sfxv.fsf@sykes.suse.de> <20080623085338.GE1850@elf.ucw.cz> <485F6540.6000907@kernel.org> <20080623090130.GF1850@elf.ucw.cz>
In-Reply-To: <20080623090130.GF1850@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> Clarify comment in sata_svw.c.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/drivers/ata/sata_svw.c b/drivers/ata/sata_svw.c
> index 16aa683..fb13b82 100644
> --- a/drivers/ata/sata_svw.c
> +++ b/drivers/ata/sata_svw.c
> @@ -253,21 +253,29 @@ static void k2_bmdma_start_mmio(struct a
>  	/* start host DMA transaction */
>  	dmactl = readb(mmio + ATA_DMA_CMD);
>  	writeb(dmactl | ATA_DMA_START, mmio + ATA_DMA_CMD);
> -	/* There is a race condition in certain SATA controllers that can
> -	   be seen when the r/w command is given to the controller before the
> -	   host DMA is started. On a Read command, the controller would initiate
> -	   the command to the drive even before it sees the DMA start. When there
> -	   are very fast drives connected to the controller, or when the data request
> -	   hits in the drive cache, there is the possibility that the drive returns a part
> -	   or all of the requested data to the controller before the DMA start is issued.
> -	   In this case, the controller would become confused as to what to do with the data.
> -	   In the worst case when all the data is returned back to the controller, the
> -	   controller could hang. In other cases it could return partial data returning
> -	   in data corruption. This problem has been seen in PPC systems and can also appear
> -	   on an system with very fast disks, where the SATA controller is sitting behind a
> -	   number of bridges, and hence there is significant latency between the r/w command
> -	   and the start command. */
> -	/* issue r/w command if the access is to ATA*/
> +	/* This works around possible data corruption.
> +
> +	   On certain SATA controllers that can be seen when the r/w
> +	   command is given to the controller before the host DMA is
> +	   started.
> +
> +	   On a Read command, the controller would initiate the
> +	   command to the drive even before it sees the DMA
> +	   start. When there are very fast drives connected to the
> +	   controller, or when the data request hits in the drive
> +	   cache, there is the possibility that the drive returns a
> +	   part or all of the requested data to the controller before
> +	   the DMA start is issued.  In this case, the controller
> +	   would become confused as to what to do with the data.  In
> +	   the worst case when all the data is returned back to the
> +	   controller, the controller could hang. In other cases it
> +	   could return partial data returning in data
> +	   corruption. This problem has been seen in PPC systems and
> +	   can also appear on an system with very fast disks, where
> +	   the SATA controller is sitting behind a number of bridges,
> +	   and hence there is significant latency between the r/w
> +	   command and the start command. */
> +	/* issue r/w command if the access is to ATA */
>  	if (qc->tf.protocol == ATA_PROT_DMA)
>  		ap->ops->sff_exec_command(ap, &qc->tf);
>  }
> 
> 

applied

