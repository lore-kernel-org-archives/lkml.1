Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbYESFKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbYESFKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 01:10:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559AbYESFKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 01:10:38 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:4814 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748AbYESFKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 01:10:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=Btoppuxy6iCTPkFM50WlMhlUvg3OwPOTQo15KVIY9v2Ni5E1vDI3EYlJ64wYkQNO57fyuwTKJTYe2gC1z4wazrlRA3UzwFdy6qKPznQwRwpl1/dRoS3QsUsrHctgznZYSjKca8iNf0Q3gnDQ9H0VhsRLXoCa9W+NtXk+66nJGr4=
Date: Mon, 19 May 2008 07:10:32 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/40] ide-scsi: fix Interrupt Reason checking in
	idescsi_pc_intr()
Message-ID: <20080519051032.GB31130@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080518185428.5636.77234.sendpatchset@localhost.localdomain> <20080518185503.5636.98141.sendpatchset@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080518185503.5636.98141.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 08:55:03PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Set PC_FLAG_WRITING pc flag in idescsi_queue() (if needed)
> and then fix Interrupt Reason checking in idescsi_pc_intr().
> 
> Cc: Borislav Petkov <petkovbb@gmail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/scsi/ide-scsi.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> Index: b/drivers/scsi/ide-scsi.c
> ===================================================================
> --- a/drivers/scsi/ide-scsi.c
> +++ b/drivers/scsi/ide-scsi.c
> @@ -427,7 +427,15 @@ static ide_startstop_t idescsi_pc_intr (
>  		printk(KERN_ERR "ide-scsi: CoD != 0 in idescsi_pc_intr\n");
>  		return ide_do_reset (drive);
>  	}
> -	if (ireason & IO) {
> +	if (((ireason & IO) == IO) == !!(pc->flags & PC_FLAG_WRITING)) {
> +		/* Hopefully, we will never get here */
> +		printk(KERN_ERR "%s: We wanted to %s, but the device wants us "
> +				"to %s!\n", drive->name,
> +				(ireason & IO) ? "Write" : "Read",
> +				(ireason & IO) ? "Read" : "Write");
> +		return ide_do_reset(drive);
> +	}
> +	if (!(pc->flags & PC_FLAG_WRITING)) {
>  		temp = pc->xferred + bcount;
>  		if (temp > pc->req_xfer) {
>  			if (temp > pc->buf_size) {
> @@ -436,7 +444,6 @@ static ide_startstop_t idescsi_pc_intr (
>  					"- discarding data\n");
>  				temp = pc->buf_size - pc->xferred;
>  				if (temp) {
> -					pc->flags &= ~PC_FLAG_WRITING;
>  					if (pc->sg)
>  						idescsi_input_buffers(drive, pc,
>  									temp);
> @@ -457,15 +464,11 @@ static ide_startstop_t idescsi_pc_intr (
>  			printk (KERN_NOTICE "ide-scsi: The scsi wants to send us more data than expected - allowing transfer\n");
>  #endif /* IDESCSI_DEBUG_LOG */
>  		}
> -	}
> -	if (ireason & IO) {
> -		pc->flags &= ~PC_FLAG_WRITING;
>  		if (pc->sg)
>  			idescsi_input_buffers(drive, pc, bcount);
>  		else
>  			hwif->input_data(drive, NULL, pc->cur_pos, bcount);
>  	} else {
> -		pc->flags |= PC_FLAG_WRITING;

Yeah, what was the driver doing turning on/off that flag in the irq handler? Are
those pc's getting reused in ide-scsi... I guess this is one of the bugs you
were talking about :).

>  		if (pc->sg)
>  			idescsi_output_buffers(drive, pc, bcount);
>  		else
> @@ -777,6 +780,8 @@ static int idescsi_queue (struct scsi_cm
>  
>  	memset (pc->c, 0, 12);
>  	pc->flags = 0;
> +	if (cmd->sc_data_direction == DMA_TO_DEVICE)
> +		pc->flags |= PC_FLAG_WRITING;
>  	pc->rq = rq;
>  	memcpy (pc->c, cmd->cmnd, cmd->cmd_len);
>  	pc->buf = NULL;

-- 
Regards/Gruﬂ,
    Boris.
