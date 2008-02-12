Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYBLV1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYBLV1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:27:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYBLV0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:26:05 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:3573 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbYBLVZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:25:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=iHuCtV37qe/7oRYblC39phH0oORsjU/QL4eecLQ1wvQMbkP3VTT4foL2we0kCbuhi+o2y4LWXVJkL5XPGCyUO2UPn5/bdgIyvgD2flfWF2d5W7pkiuJC5fqjq8TCS8iBcF4IqSmjY7VCGF9q2rmmd3LB8nmxvfYqRdRIaDcxWvY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [RFC PATCH] ide-floppy: use rq->cmd for preparing and sending packet cmds to the drive
Date: Tue, 12 Feb 2008 22:39:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20080212143715.GB4530@gollum.tnic>
In-Reply-To: <20080212143715.GB4530@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802122239.22566.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Borislav,

On Tuesday 12 February 2008, Borislav Petkov wrote:
> Hi Bart,
> 
> here's a first go at converting ide-floppy to using rq->cmd for packet commands.
> The code below is pretty rough and from what i can tell needs to be hammered a
> lot more, for it raises a lot of issues:

I think that this _really_ should be done _after_ unifying ATAPI handling [*].
Otherwise you will be making some of the same changes to the _three_ copies
of (more or less) identical code and more importantly we will have to delay
unification after _all_ drivers are converted to rq->cmd[] (+ lets not forget
that I'll have more changes to review ;).

(*) please take a closer look at *_issue_pc(), *_transfer_pc() and *_pc_intr()
    in ide-{floppy,tape,scsi} (the useful hint is that after making these
    functions free of references to device driver specific objects/functions
    we can use drive->media == ide_{floppy,tape,scsi} checks for handling
    not yet fully unified / media type specific code).

> 1. The command control (pc->callback, request type, etc) is still done using the pc
> pointer passed to all the functions prior to issuing the command. This, imho, can be

It sems that different callback types can be easily removed by merging code
from all callbacks into the common one which decides what to do basing on
the ATAPI command (pc->c[0] / rq->cmd[0]).

[ Probably same can be done in ide-tape's case. ]

> done a lot cleaner and easier. What is the rationale here, do we want ide_atapi_pc
> removed in the long run and get by only with rq's as is the case with ide-cd?

Yes but this is also premature w.r.t. the current state of these drivers.

> 2. I end up allocating all the requests on the stack just like the respective
> ide_atapi_pc structs and don't use the heap allocation facilities. I guess this will
> get resolved after we've decided on allocation scheme for the rq structs... In the
> meantime, the stack is probably gonna blow with additional sizeof(struct request).

Hmm, we shouldn't be worried about increased stack usage - please take look
at the current code workflow:

- idefloppy_queue_pc_head() is only called from idefloppy_retry_pc()
  (which gets rq from floppy->pc_stack[]).

- idefloppy_queue_pc_tail() already gets rq from the stack
  (the changes just move the allocation from this function up)

> 3. idefloppy_queue_pc_{head,tail} turn into simple wrappers which begs for
> merging them but this is trivial.

no need for these wrappers now => s/merging/removing/

> 4.Made rq->cmd_type = REQ_TYPE_ATA_PC from REQ_TYPE_SPECIAL but i guess the
> final goal is REQ_TYPE_BLOCK_PC. Will have to see how is this handled in the
> block layer and whether we're ready to do that.

It is not the safe until you review both IDE subsystem and block layer w.r.t.
handling of REQ_TYPE_ATA_PC vs REQ_TYPE_SPECIAL.  After quick audit it seems
to be safe on the block layer level but ironically ide-floppy itself uses
blk_special_request() checks (IOW this change just broke ide-floppy ;).

Please do _not_ mix such changes with purely cleanup ones which shouldn't
(in theory) cause any functional changes (doing it in a post-patch after
having anylised potential consequences is fine).

> 5. This change is less intrusive but begs for a lot of simplification afterwards
> similar to ide-cd, which will probably get rid of all those create_.*_cmd()
> helpers.
> 
> 6. Only compile-tested. Proper testing follows...

The one more concern is with many places extracting rq from pc.  This looks
backwards and un-intuitive (your patch is not to be blamed for this because
it was like that before).

Maybe we should just set rq->special to pc, pass rq where necessary and
remove pc->rq (this may be a worthy change to do in pre-patch but again,
ATAPI handling unification should come first).

In summary: the change is good but it looks a bit premature as IMO we should
try to cleanup as much as possible (ATAPI handling unification / ->callbacks
/ pc->rq removal / anything else?) before attacking things like pc->c[] ->
rq->cmd[] / removing static pc/rq allocations / etc.

Thanks,
Bart

> --
> commit 8359f6f7122e87c30467ff73895399b82610b835
> Author: Borislav Petkov <petkovbb@gmail.com>
> Date:   Tue Feb 12 10:06:55 2008 +0100
> 
>     ide-floppy: use rq->cmd for preparing and sending packet cmds to the drive
> 
>     ... similar to the way it is done in ide-cd.
> 
>     Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index bf1ef60..ab125ad 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -297,16 +297,9 @@ static void idefloppy_update_buffers(ide_drive_t *drive,
>   * the current request so that it will be processed immediately, on the next
>   * pass through the driver.
>   */
> -static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc,
> -		struct request *rq)
> +static void idefloppy_queue_pc_head(ide_drive_t *drive, struct ide_atapi_pc *pc)
>  {
> -	struct ide_floppy_obj *floppy = drive->driver_data;
> -
> -	ide_init_drive_cmd(rq);
> -	rq->buffer = (char *) pc;
> -	rq->cmd_type = REQ_TYPE_SPECIAL;
> -	rq->rq_disk = floppy->disk;
> -	(void) ide_do_drive_cmd(drive, rq, ide_preempt);
> +	(void)ide_do_drive_cmd(drive, pc->rq, ide_preempt);
>  }
>  
>  static struct ide_atapi_pc *idefloppy_next_pc_storage(ide_drive_t *drive)
> @@ -344,7 +337,7 @@ static void idefloppy_request_sense_callback(ide_drive_t *drive)
>  		if (floppy->failed_pc)
>  			debug_log("pc = %x, sense key = %x, asc = %x,"
>  					" ascq = %x\n",
> -					floppy->failed_pc->c[0],
> +					floppy->failed_pc->rq->cmd[0],
>  					floppy->sense_key,
>  					floppy->asc,
>  					floppy->ascq);
> @@ -375,7 +368,6 @@ static void idefloppy_pc_callback(ide_drive_t *drive)
>  
>  static void idefloppy_init_pc(struct ide_atapi_pc *pc)
>  {
> -	memset(pc->c, 0, 12);
>  	pc->retries = 0;
>  	pc->flags = 0;
>  	pc->req_xfer = 0;
> @@ -384,11 +376,25 @@ static void idefloppy_init_pc(struct ide_atapi_pc *pc)
>  	pc->idefloppy_callback = &idefloppy_pc_callback;
>  }
>  
> -static void idefloppy_create_request_sense_cmd(struct ide_atapi_pc *pc)
> +void ide_floppy_init_rq(ide_drive_t *drive, struct request *rq)
> +{
> +	struct ide_floppy_obj *floppy = drive->driver_data;
> +
> +	ide_init_drive_cmd(rq);
> +	rq->cmd_type = REQ_TYPE_ATA_PC;
> +	rq->rq_disk = floppy->disk;
> +}
> +
> +static void idefloppy_create_request_sense_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc)
>  {
> +	struct request *rq = pc->rq;
> +
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_REQUEST_SENSE;
> -	pc->c[4] = 255;
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_REQUEST_SENSE;
> +	rq->cmd[4] = 255;
>  	pc->req_xfer = 18;
>  	pc->idefloppy_callback = &idefloppy_request_sense_callback;
>  }
> @@ -405,8 +411,8 @@ static void idefloppy_retry_pc(ide_drive_t *drive)
>  	(void)ide_read_error(drive);
>  	pc = idefloppy_next_pc_storage(drive);
>  	rq = idefloppy_next_rq_storage(drive);
> -	idefloppy_create_request_sense_cmd(pc);
> -	idefloppy_queue_pc_head(drive, pc, rq);
> +	idefloppy_create_request_sense_cmd(drive, pc);
> +	idefloppy_queue_pc_head(drive, pc);
>  }
>  
>  /* The usual interrupt handler called during a packet command. */
> @@ -452,7 +458,7 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
>  			/* Error detected */
>  			debug_log("%s: I/O error\n", drive->name);
>  			rq->errors++;
> -			if (pc->c[0] == GPCMD_REQUEST_SENSE) {
> +			if (rq->cmd[0] == GPCMD_REQUEST_SENSE) {
>  				printk(KERN_ERR "ide-floppy: I/O error in "
>  					"request sense command\n");
>  				return ide_do_reset(drive);
> @@ -544,8 +550,9 @@ static ide_startstop_t idefloppy_pc_intr (ide_drive_t *drive)
>  static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
>  {
>  	ide_hwif_t *hwif = drive->hwif;
> -	ide_startstop_t startstop;
>  	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct request *rq = floppy->pc->rq;
> +	ide_startstop_t startstop;
>  	u8 ireason;
>  
>  	if (ide_wait_stat(&startstop, drive, DRQ_STAT, BUSY_STAT, WAIT_READY)) {
> @@ -563,7 +570,7 @@ static ide_startstop_t idefloppy_transfer_pc(ide_drive_t *drive)
>  	/* Set the interrupt routine */
>  	ide_set_handler(drive, &idefloppy_pc_intr, IDEFLOPPY_WAIT_CMD, NULL);
>  	/* Send the actual packet */
> -	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
> +	HWIF(drive)->atapi_output_bytes(drive, rq->cmd, 12);
>  	return ide_started;
>  }
>  
> @@ -583,7 +590,7 @@ static int idefloppy_transfer_pc2(ide_drive_t *drive)
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  
>  	/* Send the actual packet */
> -	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->c, 12);
> +	HWIF(drive)->atapi_output_bytes(drive, floppy->pc->rq->cmd, 12);
>  	/* Timeout for the packet command */
>  	return IDEFLOPPY_WAIT_CMD;
>  }
> @@ -631,7 +638,7 @@ static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
>  
>  	printk(KERN_ERR "ide-floppy: %s: I/O error, pc = %2x, key = %2x, "
>  			"asc = %2x, ascq = %2x\n",
> -			floppy->drive->name, pc->c[0], floppy->sense_key,
> +			floppy->drive->name, pc->rq->cmd[0], floppy->sense_key,
>  			floppy->asc, floppy->ascq);
>  
>  }
> @@ -642,11 +649,11 @@ static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	ide_hwif_t *hwif = drive->hwif;
>  	ide_handler_t *pkt_xfer_routine;
> +	struct request *rq = pc->rq;
>  	u16 bcount;
>  	u8 dma;
>  
> -	if (floppy->failed_pc == NULL &&
> -	    pc->c[0] != GPCMD_REQUEST_SENSE)
> +	if (floppy->failed_pc == NULL && rq->cmd[0] != GPCMD_REQUEST_SENSE)
>  		floppy->failed_pc = pc;
>  	/* Set the current packet command */
>  	floppy->pc = pc;
> @@ -719,30 +726,44 @@ static void idefloppy_rw_callback(ide_drive_t *drive)
>  	return;
>  }
>  
> -static void idefloppy_create_prevent_cmd(struct ide_atapi_pc *pc, int prevent)
> +static void idefloppy_create_prevent_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc, int prevent)
>  {
> +	struct request *rq = pc->rq;
> +
>  	debug_log("creating prevent removal command, prevent = %d\n", prevent);
>  
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
> -	pc->c[4] = prevent;
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_PREVENT_ALLOW_MEDIUM_REMOVAL;
> +	rq->cmd[4] = prevent;
>  }
>  
> -static void idefloppy_create_read_capacity_cmd(struct ide_atapi_pc *pc)
> +static void idefloppy_create_read_capacity_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc)
>  {
> +	struct request *rq = pc->rq;
> +
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_READ_FORMAT_CAPACITIES;
> -	pc->c[7] = 255;
> -	pc->c[8] = 255;
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_READ_FORMAT_CAPACITIES;
> +	rq->cmd[7] = 255;
> +	rq->cmd[8] = 255;
>  	pc->req_xfer = 255;
>  }
>  
> -static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
> -		int l, int flags)
> +static void idefloppy_create_format_unit_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc, int b,	int l, int flags)
>  {
> +	struct request *rq = pc->rq;
> +
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_FORMAT_UNIT;
> -	pc->c[1] = 0x17;
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_FORMAT_UNIT;
> +	rq->cmd[1] = 0x17;
>  
>  	memset(pc->buf, 0, 12);
>  	pc->buf[1] = 0xA2;
> @@ -759,15 +780,18 @@ static void idefloppy_create_format_unit_cmd(struct ide_atapi_pc *pc, int b,
>  }
>  
>  /* A mode sense command is used to "sense" floppy parameters. */
> -static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
> -		u8 page_code, u8 type)
> +static void idefloppy_create_mode_sense_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc, u8 page_code, u8 type)
>  {
>  	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
> +	struct request *rq = pc->rq;
>  
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_MODE_SENSE_10;
> -	pc->c[1] = 0;
> -	pc->c[2] = page_code + (type << 6);
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_MODE_SENSE_10;
> +	rq->cmd[1] = 0;
> +	rq->cmd[2] = page_code + (type << 6);
>  
>  	switch (page_code) {
>  	case IDEFLOPPY_CAPABILITIES_PAGE:
> @@ -777,24 +801,32 @@ static void idefloppy_create_mode_sense_cmd(struct ide_atapi_pc *pc,
>  		length += 32;
>  		break;
>  	default:
> -		printk(KERN_ERR "ide-floppy: unsupported page code "
> -				"in create_mode_sense_cmd\n");
> +		printk(KERN_ERR "ide-floppy: unsupported page code %s\n",
> +				__func__);
>  	}
> -	put_unaligned(cpu_to_be16(length), (u16 *) &pc->c[7]);
> +	put_unaligned(cpu_to_be16(length), (u16 *) &rq->cmd[7]);
>  	pc->req_xfer = length;
>  }
>  
> -static void idefloppy_create_start_stop_cmd(struct ide_atapi_pc *pc, int start)
> +static void idefloppy_create_start_stop_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc, int start)
>  {
> +	struct request *rq = pc->rq;
> +
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_START_STOP_UNIT;
> -	pc->c[4] = start;
> +	ide_floppy_init_rq(drive, rq);
> +
> +	rq->cmd[0] = GPCMD_START_STOP_UNIT;
> +	rq->cmd[4] = start;
>  }
>  
> -static void idefloppy_create_test_unit_ready_cmd(struct ide_atapi_pc *pc)
> +static void idefloppy_create_test_unit_ready_cmd(ide_drive_t *drive,
> +		struct ide_atapi_pc *pc)
>  {
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = GPCMD_TEST_UNIT_READY;
> +	ide_floppy_init_rq(drive, pc->rq);
> +
> +	pc->rq->cmd[0] = GPCMD_TEST_UNIT_READY;
>  }
>  
>  static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
> @@ -809,9 +841,11 @@ static void idefloppy_create_rw_cmd(idefloppy_floppy_t *floppy,
>  		block, blocks);
>  
>  	idefloppy_init_pc(pc);
> -	pc->c[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
> -	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&pc->c[7]);
> -	put_unaligned(cpu_to_be32(block), (unsigned int *) &pc->c[2]);
> +	ide_floppy_init_rq(floppy->drive, rq);
> +
> +	rq->cmd[0] = cmd == READ ? GPCMD_READ_10 : GPCMD_WRITE_10;
> +	put_unaligned(cpu_to_be16(blocks), (unsigned short *)&rq->cmd[7]);
> +	put_unaligned(cpu_to_be32(block), (unsigned int *) &rq->cmd[2]);
>  
>  	pc->idefloppy_callback = &idefloppy_rw_callback;
>  	pc->rq = rq;
> @@ -827,8 +861,8 @@ static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
>  		struct ide_atapi_pc *pc, struct request *rq)
>  {
>  	idefloppy_init_pc(pc);
> +
>  	pc->idefloppy_callback = &idefloppy_rw_callback;
> -	memcpy(pc->c, rq->cmd, sizeof(pc->c));
>  	pc->rq = rq;
>  	pc->b_count = rq->data_len;
>  	if (rq->data_len && rq_data_dir(rq) == WRITE)
> @@ -898,15 +932,7 @@ static ide_startstop_t idefloppy_do_request(ide_drive_t *drive,
>   */
>  static int idefloppy_queue_pc_tail(ide_drive_t *drive, struct ide_atapi_pc *pc)
>  {
> -	struct ide_floppy_obj *floppy = drive->driver_data;
> -	struct request rq;
> -
> -	ide_init_drive_cmd(&rq);
> -	rq.buffer = (char *) pc;
> -	rq.cmd_type = REQ_TYPE_SPECIAL;
> -	rq.rq_disk = floppy->disk;
> -
> -	return ide_do_drive_cmd(drive, &rq, ide_wait);
> +	return ide_do_drive_cmd(drive, pc->rq, ide_wait);
>  }
>  
>  /*
> @@ -917,13 +943,17 @@ static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
> +
>  	u8 *page;
>  	int capacity, lba_capacity;
>  	u16 transfer_rate, sector_size, cyls, rpm;
>  	u8 heads, sectors;
>  
> -	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_FLEXIBLE_DISK_PAGE,
> -					MODE_SENSE_CURRENT);
> +	pc.rq = &rq;
> +
> +	idefloppy_create_mode_sense_cmd(drive, &pc,
> +			IDEFLOPPY_FLEXIBLE_DISK_PAGE, MODE_SENSE_CURRENT);
>  
>  	if (idefloppy_queue_pc_tail(drive, &pc)) {
>  		printk(KERN_ERR "ide-floppy: Can't get flexible disk page"
> @@ -969,9 +999,12 @@ static int idefloppy_get_sfrp_bit(ide_drive_t *drive)
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
> +
> +	pc.rq = &rq;
>  
>  	floppy->srfp = 0;
> -	idefloppy_create_mode_sense_cmd(&pc, IDEFLOPPY_CAPABILITIES_PAGE,
> +	idefloppy_create_mode_sense_cmd(drive, &pc, IDEFLOPPY_CAPABILITIES_PAGE,
>  						 MODE_SENSE_CURRENT);
>  
>  	pc.flags |= PC_FLAG_SUPPRESS_ERROR;
> @@ -990,17 +1023,20 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
>  	u8 *cap_desc;
>  	u8 header_len, desc_cnt;
>  	int i, rc = 1, blocks, length;
>  
> +	pc.rq = &rq;
> +
>  	drive->bios_cyl = 0;
>  	drive->bios_head = drive->bios_sect = 0;
>  	floppy->blocks = 0;
>  	floppy->bs_factor = 1;
>  	set_capacity(floppy->disk, 0);
>  
> -	idefloppy_create_read_capacity_cmd(&pc);
> +	idefloppy_create_read_capacity_cmd(drive, &pc);
>  	if (idefloppy_queue_pc_tail(drive, &pc)) {
>  		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
>  		return 1;
> @@ -1102,6 +1138,7 @@ static int ide_floppy_get_capacity(ide_drive_t *drive)
>  static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
>  {
>  	struct ide_atapi_pc pc;
> +	struct request rq;
>  	u8 header_len, desc_cnt;
>  	int i, blocks, length, u_array_size, u_index;
>  	int __user *argp;
> @@ -1112,7 +1149,9 @@ static int ide_floppy_get_format_capacities(ide_drive_t *drive, int __user *arg)
>  	if (u_array_size <= 0)
>  		return (-EINVAL);
>  
> -	idefloppy_create_read_capacity_cmd(&pc);
> +	pc.rq = &rq;
> +
> +	idefloppy_create_read_capacity_cmd(drive, &pc);
>  	if (idefloppy_queue_pc_tail(drive, &pc)) {
>  		printk(KERN_ERR "ide-floppy: Can't get floppy parameters\n");
>  		return (-EIO);
> @@ -1167,10 +1206,13 @@ static int idefloppy_get_format_progress(ide_drive_t *drive, int __user *arg)
>  {
>  	idefloppy_floppy_t *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
>  	int progress_indication = 0x10000;
>  
> +	pc.rq = &rq;
> +
>  	if (floppy->srfp) {
> -		idefloppy_create_request_sense_cmd(&pc);
> +		idefloppy_create_request_sense_cmd(drive, &pc);
>  		if (idefloppy_queue_pc_tail(drive, &pc))
>  			return (-EIO);
>  
> @@ -1373,8 +1415,11 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
>  	struct ide_floppy_obj *floppy;
>  	ide_drive_t *drive;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
>  	int ret = 0;
>  
> +	pc.rq = &rq;
> +
>  	debug_log("Reached %s\n", __func__);
>  
>  	floppy = ide_floppy_get(disk);
> @@ -1389,9 +1434,9 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
>  		floppy->flags &= ~IDEFLOPPY_FLAG_FORMAT_IN_PROGRESS;
>  		/* Just in case */
>  
> -		idefloppy_create_test_unit_ready_cmd(&pc);
> +		idefloppy_create_test_unit_ready_cmd(drive, &pc);
>  		if (idefloppy_queue_pc_tail(drive, &pc)) {
> -			idefloppy_create_start_stop_cmd(&pc, 1);
> +			idefloppy_create_start_stop_cmd(drive, &pc, 1);
>  			(void) idefloppy_queue_pc_tail(drive, &pc);
>  		}
>  
> @@ -1414,7 +1459,7 @@ static int idefloppy_open(struct inode *inode, struct file *filp)
>  		floppy->flags |= IDEFLOPPY_FLAG_MEDIA_CHANGED;
>  		/* IOMEGA Clik! drives do not support lock/unlock commands */
>  		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
> -			idefloppy_create_prevent_cmd(&pc, 1);
> +			idefloppy_create_prevent_cmd(drive, &pc, 1);
>  			(void) idefloppy_queue_pc_tail(drive, &pc);
>  		}
>  		check_disk_change(inode->i_bdev);
> @@ -1436,13 +1481,16 @@ static int idefloppy_release(struct inode *inode, struct file *filp)
>  	struct ide_floppy_obj *floppy = ide_floppy_g(disk);
>  	ide_drive_t *drive = floppy->drive;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
> +
> +	pc.rq = &rq;
>  
>  	debug_log("Reached %s\n", __func__);
>  
>  	if (floppy->openers == 1) {
>  		/* IOMEGA Clik! drives do not support lock/unlock commands */
>  		if (!(floppy->flags & IDEFLOPPY_FLAG_CLIK_DRIVE)) {
> -			idefloppy_create_prevent_cmd(&pc, 0);
> +			idefloppy_create_prevent_cmd(drive, &pc, 0);
>  			(void) idefloppy_queue_pc_tail(drive, &pc);
>  		}
>  
> @@ -1481,12 +1529,12 @@ static int ide_floppy_lockdoor(idefloppy_floppy_t *floppy,
>  		if (cmd == CDROMEJECT)
>  			prevent = 0;
>  
> -		idefloppy_create_prevent_cmd(pc, prevent);
> +		idefloppy_create_prevent_cmd(floppy->drive, pc, prevent);
>  		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
>  	}
>  
>  	if (cmd == CDROMEJECT) {
> -		idefloppy_create_start_stop_cmd(pc, 2);
> +		idefloppy_create_start_stop_cmd(floppy->drive, pc, 2);
>  		(void) idefloppy_queue_pc_tail(floppy->drive, pc);
>  	}
>  
> @@ -1498,6 +1546,10 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
>  {
>  	int blocks, length, flags, err = 0;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
> +	ide_drive_t *drive = floppy->drive;
> +
> +	pc.rq = &rq;
>  
>  	if (floppy->openers > 1) {
>  		/* Don't format if someone is using the disk */
> @@ -1529,10 +1581,10 @@ static int ide_floppy_format_unit(idefloppy_floppy_t *floppy,
>  		goto out;
>  	}
>  
> -	(void) idefloppy_get_sfrp_bit(floppy->drive);
> -	idefloppy_create_format_unit_cmd(&pc, blocks, length, flags);
> +	(void) idefloppy_get_sfrp_bit(drive);
> +	idefloppy_create_format_unit_cmd(drive, &pc, blocks, length, flags);
>  
> -	if (idefloppy_queue_pc_tail(floppy->drive, &pc))
> +	if (idefloppy_queue_pc_tail(drive, &pc))
>  		err = -EIO;
>  
>  out:
> @@ -1549,9 +1601,12 @@ static int idefloppy_ioctl(struct inode *inode, struct file *file,
>  	struct ide_floppy_obj *floppy = ide_floppy_g(bdev->bd_disk);
>  	ide_drive_t *drive = floppy->drive;
>  	struct ide_atapi_pc pc;
> +	struct request rq;
>  	void __user *argp = (void __user *)arg;
>  	int err;
>  
> +	pc.rq = &rq;
> +
>  	switch (cmd) {
>  	case CDROMEJECT:
>  		/* fall through */
> 
