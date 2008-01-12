Return-Path: <linux-kernel-owner+w=401wt.eu-S1763090AbYALUWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763090AbYALUWX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 15:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762880AbYALUUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 15:20:21 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:21337 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbYALUUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 15:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=c9QzhCjPwEinpfMzUWRWoq8IJqUZS9y1V+ll/Tk1zg/Itj5kaCZPMUMovRO0Q9Db62jlVvcwjDpsxF4HbgqzSpAux1zXtEjG2qUijZHx9rV2c8k6woI0zHeSy4eAUOVPjZqRWrO3S4Smlg/Jdtyjok1QtoePFRG3i6y9UNC3oLA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 21/21] ide-floppy: remove atomic test_*bit macros
Date: Sat, 12 Jan 2008 21:19:34 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200052699-28420-1-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-21-git-send-email-bbpetkov@yahoo.de> <1200052699-28420-22-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200052699-28420-22-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801122119.34418.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 January 2008, Borislav Petkov wrote:
> This change is temporary and after unification of the IDE subsystem proper
> bit setting and testing macros will be introduced.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-floppy.c |   82 +++++++++++++++++++++++++---------------------
>  1 files changed, 45 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 4106eb4..29c1983 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -479,12 +479,12 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
>  
>  	debug_log("Reached %s interrupt handler\n", __FUNCTION__);
>  
> -	if (test_bit(PC_DMA_IN_PROGRESS, &pc->flags)) {
> +	if ((1UL << PC_DMA_IN_PROGRESS) & pc->flags) {

How's about introducing new defines i.e.

enum {
	IDE_FLOPPY_FLAG_PC_ABORT		= (1 << 0),
	IDE_FLOPPY_FLAG_PC_DMA_RECOMMENDED	= (1 << 1),
	IDE_FLOPPY_FLAG_PC_DMA_IN_PROGRESS	= (1 << 2),
	...
}

instead of open-coding the bit-shifts?

>  		dma_error = HWIF(drive)->ide_dma_end(drive);
>  		if (dma_error) {
>  			printk(KERN_ERR "%s: DMA %s error\n", drive->name,
>  					write ?	"write" : "read");
> -			set_bit(PC_DMA_ERROR, &pc->flags);
> +			pc->flags |= (1UL << PC_DMA_ERROR);
>  		} else {
>  			pc->actually_transferred = pc->request_transfer;
>  			idefloppy_update_buffers(drive, pc);
> @@ -499,11 +499,11 @@ static ide_startstop_t idefloppy_pc_intr(ide_drive_t *drive)
>  		/* No more interrupts */
>  		debug_log("Packet command completed, %d bytes transferred\n",
>  				pc->actually_transferred);
> -		clear_bit(PC_DMA_IN_PROGRESS, &pc->flags);
> +		pc->flags &= ((1UL << PC_DMA_IN_PROGRESS) ^ ~0UL);

Same can be achieved with:

		pc->flags &= ~(1 << PC_DMA_IN_PROGRESS);
