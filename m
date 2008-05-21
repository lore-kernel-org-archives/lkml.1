Return-Path: <linux-kernel-owner+w=401wt.eu-S1762300AbYEUFYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762300AbYEUFYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 01:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753261AbYEUFYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 01:24:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:20573 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbYEUFYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 01:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=mQyUO0l+SvRlm5g8mlCq7gsIrHPkNoa91IuvnN2Q40ov5Y37uwP/yvjmP3NIEndYzbnm8rHPGOOOn+UknvDmz896crQPRbjY9UkL3HPM+0pLI2apEBweOR6n9+skqLkS1FE0jW2Q+bMNeI6qGq+RRuYgtON/WBjoogZeyv5Ihko=
Date: Wed, 21 May 2008 07:24:29 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/40] ide-floppy: merge idefloppy_transfer_pc() and
	idefloppy_transfer_pc1()
Message-ID: <20080521052429.GA2414@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185633.5636.61364.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080518185633.5636.61364.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 08:56:33PM +0200, Bartlomiej Zolnierkiewicz wrote:
> * Check IDEFLOPPY_FLAG_ZIP_DRIVE flag in idefloppy_transfer_pc1()
>   and skip idefloppy_transfer_pc2()-phase if the flag is not set.
> 
> * Always use idefloppy_transfer_pc1() in idefloppy_issue_pc()
>   and remove no longer needed idefloppy_transfer_pc().

... and also probably mv idefloppy_transfer_pc1() to something like
idefloppy_start_transfer_pc() and rename idefloppy_transfer_pc2() to something
more appropriate like e.g. idefloppy_do_transfer_pc() or similar and do away
with those misleading names and probably even the comments are superfluous then.

> 
> There should be no functional changes caused by this patch.
> 
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-floppy.c |   65 ++++++++++++-----------------------------------
>  1 file changed, 17 insertions(+), 48 deletions(-)
> 
> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -522,40 +522,6 @@ static ide_startstop_t idefloppy_pc_intr
>  }
>  
>  /*
> - * This is the original routine that did the packet transfer.
> - * It fails at high speeds on the Iomega ZIP drive, so there's a slower version
> - * for that drive below. The algorithm is chosen based on drive type
> - */
> -static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
> -{
> -	ide_hwif_t *hwif = drive->hwif;
> -	ide_startstop_t startstop;
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> -	u8 ireason;
> -
> -	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
> -		printk(KERN_ERR "ide-floppy: Strange, packet command "
> -				"initiated yet DRQ isn't asserted\n");
> -		return startstop;
> -	}
> -	ireason = hwif->INB(hwif->io_ports.nsect_addr);
> -	if ((ireason & CD) == 0 || (ireason & IO)) {
> -		printk(KERN_ERR "ide-floppy: (IO,CoD) != (0,1) while "
> -				"issuing a packet command\n");
> -		return ide_do_reset(drive);
> -	}
> -
> -	/* Set the interrupt routine */
> -	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
> -
> -	/* Send the actual packet */
> -	hwif->output_data(drive, NULL, floppy->pc->c, 12);
> -
> -	return ide_started;
> -}
> -
> -
> -/*
>   * What we have here is a classic case of a top half / bottom half interrupt
>   * service routine. In interrupt mode, the device sends an interrupt to signal
>   * that it is ready to receive a packet. However, we need to delay about 2-3
> @@ -580,6 +546,8 @@ static ide_startstop_t idefloppy_transfe
>  {
>  	ide_hwif_t *hwif = drive->hwif;
>  	idefloppy_floppy_t *floppy = drive->driver_data;
> +	ide_expiry_t *expiry;
> +	unsigned int timeout;
>  	ide_startstop_t startstop;
>  	u8 ireason;
>  
> @@ -602,9 +570,20 @@ static ide_startstop_t idefloppy_transfe
>  	 * 40 and 50msec work well. idefloppy_pc_intr will not be actually
>  	 * used until after the packet is moved in about 50 msec.
>  	 */
> +	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
> +		timeout = floppy->ticks;
> +		expiry = &idefloppy_transfer_pc2;
> +	} else {
> +		timeout = IDEFLOPPY_WAIT_CMD;
> +		expiry = NULL;
> +	}
> +
> +	ide_set_handler(drive, &idefloppy_pc_intr, timeout, expiry);
> +
> +	if ((floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) == 0)
> +		/* Send the actual packet */
> +		hwif->output_data(drive, NULL, floppy->pc->c, 12);
>  
> -	ide_set_handler(drive, &idefloppy_pc_intr, floppy->ticks,
> -			&idefloppy_transfer_pc2);
>  	return ide_started;
>  }
>  
> @@ -629,7 +608,6 @@ static ide_startstop_t idefloppy_issue_p
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	ide_hwif_t *hwif = drive->hwif;
> -	ide_handler_t *pkt_xfer_routine;
>  	u16 bcount;
>  	u8 dma;
>  
> @@ -675,26 +653,17 @@ static ide_startstop_t idefloppy_issue_p
>  		hwif->dma_ops->dma_start(drive);
>  	}
>  
> -	/* Can we transfer the packet when we get the interrupt or wait? */
> -	if (floppy->flags & IDEFLOPPY_FLAG_ZIP_DRIVE) {
> -		/* wait */
> -		pkt_xfer_routine = &idefloppy_transfer_pc1;
> -	} else {
> -		/* immediate */
> -		pkt_xfer_routine = &idefloppy_transfer_pc;
> -	}
> -
>  	if (floppy->flags & IDEFLOPPY_FLAG_DRQ_INTERRUPT) {
>  		/* Issue the packet command */
>  		ide_execute_command(drive, WIN_PACKETCMD,
> -				pkt_xfer_routine,
> +				&idefloppy_transfer_pc1,
>  				IDEFLOPPY_WAIT_CMD,
>  				NULL);
>  		return ide_started;
>  	} else {
>  		/* Issue the packet command */
>  		ide_execute_pkt_cmd(drive);
> -		return (*pkt_xfer_routine) (drive);
> +		return idefloppy_transfer_pc1(drive);
>  	}
>  }
>  

-- 
Regards/Gruﬂ,
    Boris.
