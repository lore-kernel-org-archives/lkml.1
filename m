Return-Path: <linux-kernel-owner+w=401wt.eu-S935183AbYBMWDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935183AbYBMWDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934939AbYBMVvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:51:00 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:17147 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913AbYBMVu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:50:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=E860SW6F7TdoxH6tT/6CelG0VCFxvs75syClRAIop3crZ+WZ67Rxm/l/K8QYr8mQ5Eq2UhUpv2JdKbACUM6i9u5wS9Zs5NiB9H+df+Y9xp01akHEmROEZeZVMoXBlio7LvrPGhYLb6EfINa7oRPZnIC3LKuIHNy+DhFGJbOuT2A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH] ide-floppy: merge callbacks
Date: Wed, 13 Feb 2008 23:04:23 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080213205733.GC13446@gollum.tnic>
In-Reply-To: <20080213205733.GC13446@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802132304.24126.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2008, Borislav Petkov wrote:
> commit d1f1f84f413ab00cb2fec48170d022fcd900e214
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Wed Feb 13 20:26:56 2008 +0100
> 
>     ide-floppy: merge callbacks
>     
>     The appropriate functionality of the callback is established through querying
>     the ATAPI packet command in pc->c[0].
>     
>     While at it, simplify if (floppy->failed_pc)-branch to be found in the original
>     idefloppy_request_sense_callback().
>     
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 5f133df..1365310 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -313,50 +313,39 @@ static struct request *idefloppy_next_rq_storage(ide_drive_t *drive)
>  	return (&floppy->rq_stack[floppy->rq_stack_index++]);
>  }
>  
> -static void idefloppy_request_sense_callback(ide_drive_t *drive)
> +static void ide_floppy_callback(ide_drive_t *drive)
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
> -	u8 *buf = floppy->pc->buf;
>  
>  	debug_log("Reached %s\n", __func__);
>  
> -	if (!floppy->pc->error) {
> -		floppy->sense_key = buf[2] & 0x0F;
> -		floppy->asc = buf[12];
> -		floppy->ascq = buf[13];
> -		floppy->progress_indication = buf[15] & 0x80 ?
> -			(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
> +	if (floppy->pc->c[0] == GPCMD_REQUEST_SENSE) {
> +		u8 *buf = floppy->pc->buf;
>  
> -		if (floppy->failed_pc)
> -			debug_log("pc = %x, sense key = %x, asc = %x,"
> -					" ascq = %x\n",
> -					floppy->failed_pc->c[0],
> -					floppy->sense_key,
> -					floppy->asc,
> -					floppy->ascq);
> -		else
> -			debug_log("sense key = %x, asc = %x, ascq = %x\n",
> -					floppy->sense_key,
> -					floppy->asc,
> -					floppy->ascq);
> -
> -
> -		idefloppy_end_request(drive, 1, 0);
> -	} else {
> -		printk(KERN_ERR "Error in REQUEST SENSE itself - Aborting"
> -				" request!\n");
> -		idefloppy_end_request(drive, 0, 0);
> -	}
> -}
> +		if (!floppy->pc->error) {
> +			floppy->sense_key = buf[2] & 0x0F;
> +			floppy->asc = buf[12];
> +			floppy->ascq = buf[13];
> +			floppy->progress_indication = buf[15] & 0x80 ?
> +				(u16)get_unaligned((u16 *)&buf[16]) : 0x10000;
>  
> -/* General packet command callback function. */
> -static void idefloppy_pc_callback(ide_drive_t *drive)
> -{
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +			if (floppy->failed_pc)
> +				debug_log("pc = %x, ", floppy->failed_pc->c[0]);
>  
> -	debug_log("Reached %s\n", __func__);
> +			debug_log("sense key = %x, asc = %x, ascq = %x\n",
> +				floppy->sense_key, floppy->asc,	floppy->ascq);
>  
> -	idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
> +			idefloppy_end_request(drive, 1, 0);
> +		} else {
> +			printk(KERN_ERR "Error in REQUEST SENSE itself - "
> +					"Aborting request!\n");
> +			idefloppy_end_request(drive, 0, 0);
> +		}
> +	} else if (floppy->pc->c[0] == GPCMD_READ_10 ||
> +		floppy->pc->c[0] == GPCMD_WRITE_10)
> +		idefloppy_end_request(drive, 1, 0);
> +	else
> +		idefloppy_end_request(drive, floppy->pc->error ? 0 : 1, 0);
>  }
>  
>  static void idefloppy_init_pc(struct ide_atapi_pc *pc)
> @@ -367,7 +356,7 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
>  	pc->req_xfer = 0;
>  	pc->buf = pc->pc_buf;
>  	pc->buf_size = IDEFLOPPY_PC_BUFFER_SIZE;
> -	pc->idefloppy_callback = &idefloppy_pc_callback;
> +	pc->idefloppy_callback = &ide_floppy_callback;
>  }
>  
>  static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
> @@ -376,7 +365,6 @@ static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
>  	pc->c[0] = GPCMD_REQUEST_SENSE;
>  	pc->c[4] = 255;
>  	pc->req_xfer = 18;
> -	pc->idefloppy_callback = &idefloppy_request_sense_callback;
>  }
>  
>  /*
> @@ -697,14 +685,6 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
>  	}
>  }
>  
> -static void idefloppy_rw_callback(ide_drive_t *drive)
> -{
> -	debug_log("Reached %s\n", __func__);
> -
> -	idefloppy_end_request(drive, 1, 0);
> -	return;
> -}
> -
>  static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
>  {
>  	debug_log("creating prevent removal command, prevent = %d\n", prevent);
> @@ -799,7 +779,6 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
>  	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
>  	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
>  
> -	pc->idefloppy_callback = &idefloppy_rw_callback;
>  	pc->rq = rq;
>  	pc->b_count = cmd == READ ? 0 : rq->bio->bi_size;
>  	if (rq->cmd_flags & REQ_RW)
> @@ -813,7 +792,6 @@ static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
>  		struct ide_atapi_pc *pc, struct request *rq)
>  {
>  	idefloppy_init_pc(pc);
> -	pc->idefloppy_callback = &idefloppy_rw_callback;

For unknown reasons blk_pc_request() requests were overriding the default
*_pc_callback and using *_rw_callback instead - the patch changes this
behavior silently.

[ When I suggest some changes I can be wrong as well (just like in this case
  because after closer look merging callbacks is not as simple as checking
  only pc->c[0]) so do not trust me automatically :) + please always try to
  fully read and understand the underlying code. ]

Otherwise patch looks fine, please correct the above issue (either
by fixing idefloppy_blockpc_cmd() to use *_pc_callback in a pre-patch
or by adding missing check for blk_pc_request() requests) + resubmit.

>  	memcpy(pc->c, rq->cmd, sizeof(pc->c)); 
>  	pc->rq = rq;
>  	pc->b_count = rq->data_len;
