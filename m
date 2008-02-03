Return-Path: <linux-kernel-owner+w=401wt.eu-S935755AbYBCACy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935755AbYBCACy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935425AbYBCAAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:00:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:56176 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935715AbYBCAAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=Vhyn/COXL1twJh+9l0TTHMCx0PcRtO3Y7vGEghuiguo6Ac8ss49oY31T4pPJvJeVPcjV0ZWJmEV/qgG8GryaQlpyo6Gb3cTdhI3N6D5qS0A0uLw0UEXz9jit7xoSAQ0PrGl0/VO1+UaAYFdvAKVwiAkUnAsIbYVx9pDTIy+WglU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [RFC PATCH 26/32] ide-tape: remove packet command and struct request memory buffers
Date: Sun, 3 Feb 2008 01:03:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>, Jens Axboe <jens.axboe@oracle.com>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-21-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-21-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802030103.30492.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Bart,
> this one is rather intrusive so please doublecheck it wrt to kzalloc/kfree
> balancing on all the codepaths so that we don't leak memory all over the place.
> I free all the alloc'd pc's and rq's in idetape_end_request() which is called
> from the callback idetape_pc_callback() registered with the packet command
> struct when creating the respective ATAPI cmd.

I was hoping for re-using requests from the request queue for this purpose
(with help of blk_get_request()/blk_put_request()).  Jens, is this OK?

This approach wouldn't have a problem with out-of-memory situations (because
blk_get_request() can wait until free request is available), needs less code
and provides additional benefits (like NUMA-friendly allocations).

When it comes to pc-s: long-term it should be possible to use only request
structure and get rid off them.

> ---
> These buffers were always statically allocated during driver initialization no
> matter what. Remove them by allocating GFP_ATOMIC memory on demand. In the case
> of allocation error, we only issue error msg in the *alloc_{pc,rq} thus postponing
> the final error handling and cleanup in their callers. Packet command and
> request memory is freed in idetape_end_request() which is at the end of the
> request path entered from all the callbacks.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |  122 ++++++++++++++++++++++-------------------------
>  1 files changed, 57 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 041edcd..3c1a7db 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -105,13 +105,6 @@ enum {
>  #define IDETAPE_PC_BUFFER_SIZE		256
>  
>  /*
> - *	In various places in the driver, we need to allocate storage
> - *	for packet commands and requests, which will remain valid while
> - *	we leave the driver to wait for an interrupt or a timeout event.
> - */
> -#define IDETAPE_PC_STACK		(10 + IDETAPE_MAX_PC_RETRIES)
> -
> -/*
>   * Some drives (for example, Seagate STT3401A Travan) require a very long
>   * timeout, because they don't return an interrupt or clear their busy bit
>   * until after the command completes (even retension commands).
> @@ -271,13 +264,6 @@ typedef struct ide_tape_obj {
>  	 */
>  	idetape_pc_t *failed_pc;
>  
> -	idetape_pc_t pc_stack[IDETAPE_PC_STACK];
> -	/* Next free packet command storage space */
> -	int pc_stack_idx;
> -	struct request rq_stack[IDETAPE_PC_STACK];
> -	/* We implement a circular array */
> -	int rq_stack_idx;
> -
>  	/*
>  	 * DSC polling variables.
>  	 *
> @@ -669,45 +655,32 @@ static void idetape_update_buffers (idetape_pc_t *pc)
>  	pc->bh = bh;
>  }
>  
> -/*
> - *	idetape_next_pc_storage returns a pointer to a place in which we can
> - *	safely store a packet command, even though we intend to leave the
> - *	driver. A storage space for a maximum of IDETAPE_PC_STACK packet
> - *	commands is allocated at initialization time.
> - */
> -static idetape_pc_t *idetape_next_pc_storage (ide_drive_t *drive)
> +static idetape_pc_t *ide_tape_alloc_pc(void)
>  {
> -	idetape_tape_t *tape = drive->driver_data;
> +	idetape_pc_t *pc;
>  
> -	debug_log(DBG_PCRQ_STACK, "pc_stack_index=%d\n", tape->pc_stack_idx);
> +	pc = kzalloc(sizeof(idetape_pc_t), GFP_ATOMIC);
> +	if (!pc)
> +		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
> +				__func__);
>  
> -	if (tape->pc_stack_idx == IDETAPE_PC_STACK)
> -		tape->pc_stack_idx = 0;
> -	return (&tape->pc_stack[tape->pc_stack_idx++]);
> +	return pc;
>  }
>  
>  /*
> - *	idetape_next_rq_storage is used along with idetape_next_pc_storage.
> - *	Since we queue packet commands in the request queue, we need to
> - *	allocate a request, along with the allocation of a packet command.
> + * Since we queue packet commands in the request queue, we need to allocate a
> + * request, along with a packet command.
>   */
> - 
> -/**************************************************************
> - *                                                            *
> - *  This should get fixed to use kmalloc(.., GFP_ATOMIC)      *
> - *  followed later on by kfree().   -ml                       *
> - *                                                            *
> - **************************************************************/
> - 
> -static struct request *idetape_next_rq_storage (ide_drive_t *drive)
> +static struct request *ide_tape_alloc_rq(void)
>  {
> -	idetape_tape_t *tape = drive->driver_data;
> +	struct request *rq;
>  
> -	debug_log(DBG_PCRQ_STACK, "rq_stack_index=%d\n", tape->rq_stack_idx);
> +	rq = kzalloc(sizeof(struct request), GFP_ATOMIC);
> +	if (!rq)
> +		printk(KERN_ERR "ide-tape: %s: memory allocation error.",
> +				__func__);
>  
> -	if (tape->rq_stack_idx == IDETAPE_PC_STACK)
> -		tape->rq_stack_idx = 0;
> -	return (&tape->rq_stack[tape->rq_stack_idx++]);
> +	return rq;
>  }
>  
>  /*
> @@ -981,9 +954,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
>  		}
>  	}
>  	ide_end_drive_cmd(drive, 0, 0);
> -//	blkdev_dequeue_request(rq);
> -//	drive->rq = NULL;
> -//	end_that_request_last(rq);
> +	kfree(tape->pc);
> +	kfree(rq);
>  
>  	if (remove_stage)
>  		idetape_remove_stage_head(drive);
> @@ -1032,13 +1004,9 @@ static void idetape_init_rq(struct request *rq, u8 cmd)
>   *
>   *	idetape_queue_pc_head is called from the request handling part of
>   *	the driver (the "bottom" part). Safe storage for the request should
> - *	be allocated with idetape_next_pc_storage and idetape_next_rq_storage
> + *	be allocated with ide_tape_alloc_pc and ide_tape_alloc_rq
>   *	before calling idetape_queue_pc_head.
>   *
> - *	Memory for those requests is pre-allocated at initialization time, and
> - *	is limited to IDETAPE_PC_STACK requests. We assume that we have enough
> - *	space for the maximum possible number of inter-dependent packet commands.
> - *
>   *	The higher level of the driver - The ioctl handler and the character
>   *	device handling functions should queue request to the lower level part
>   *	and wait for their completion using idetape_queue_pc_tail or
> @@ -1055,19 +1023,27 @@ static void idetape_queue_pc_head (ide_drive_t *drive, idetape_pc_t *pc,struct r
>  }
>  
>  /*
> - *	idetape_retry_pc is called when an error was detected during the
> - *	last packet command. We queue a request sense packet command in
> - *	the head of the request list.
> + * Called when an error was detected during the last packet command. We queue a
> + * request sense packet command in the head of the request list.
>   */
> -static ide_startstop_t idetape_retry_pc (ide_drive_t *drive)
> +static ide_startstop_t idetape_retry_pc(ide_drive_t *drive)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
>  	idetape_pc_t *pc;
>  	struct request *rq;
>  
>  	(void)drive->hwif->INB(IDE_ERROR_REG);
> -	pc = idetape_next_pc_storage(drive);
> -	rq = idetape_next_rq_storage(drive);
> +	pc = ide_tape_alloc_pc();
> +	rq = ide_tape_alloc_rq();
> +
> +	if (!pc || !rq) {
> +		printk(KERN_ERR "ide-tape: Cannot retry packet command due to "
> +				"low memory.");
> +		kfree(pc);
> +		kfree(rq);
> +		return ide_stopped;
> +	}
> +
>  	idetape_create_request_sense_cmd(pc);
>  	set_bit(IDETAPE_IGNORE_DSC, &tape->flags);
>  	idetape_queue_pc_head(drive, pc, rq);
> @@ -1719,21 +1695,33 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  	if (rq->cmd[0] & REQ_IDETAPE_READ) {
>  		tape->buffer_head++;
>  		tape->postpone_cnt = 0;
> -		pc = idetape_next_pc_storage(drive);
> -		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
> +		pc = ide_tape_alloc_pc();
> +		if (!pc)
> +			goto err;
> +
> +		idetape_create_read_cmd(tape, pc, rq->current_nr_sectors,
> +				(struct idetape_bh *)rq->special);
>  		goto out;
>  	}
>  	if (rq->cmd[0] & REQ_IDETAPE_WRITE) {
>  		tape->buffer_head++;
>  		tape->postpone_cnt = 0;
> -		pc = idetape_next_pc_storage(drive);
> -		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
> +		pc = ide_tape_alloc_pc();
> +		if (!pc)
> +			goto err;
> +
> +		idetape_create_write_cmd(tape, pc, rq->current_nr_sectors,
> +				(struct idetape_bh *)rq->special);
>  		goto out;
>  	}
>  	if (rq->cmd[0] & REQ_IDETAPE_READ_BUFFER) {
>  		tape->postpone_cnt = 0;
> -		pc = idetape_next_pc_storage(drive);
> -		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors, (struct idetape_bh *)rq->special);
> +		pc = ide_tape_alloc_pc();
> +		if (!pc)
> +			goto err;
> +
> +		idetape_create_read_buffer_cmd(tape, pc, rq->current_nr_sectors,
> +				(struct idetape_bh *)rq->special);
>  		goto out;
>  	}
>  	if (rq->cmd[0] & REQ_IDETAPE_PC1) {
> @@ -1749,6 +1737,11 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  	BUG();
>  out:
>  	return idetape_issue_packet_command(drive, pc);
> +
> +err:
> +	printk(KERN_ERR "ide-tape: Error processing request %u\n", rq->cmd[0]);
> +	idetape_end_request(drive, 0, 0);
> +	return ide_stopped;
>  }
>  
>  /*
> @@ -2055,7 +2048,7 @@ static void idetape_create_test_unit_ready_cmd(idetape_pc_t *pc)
>   *	for an interrupt or a timer event.
>   *
>   *	From the bottom part of the driver, we should allocate safe memory
> - *	using idetape_next_pc_storage and idetape_next_rq_storage, and add
> + *	using ide_tape_alloc_pc and ide_tape_alloc_rq, and add
>   *	the request to the request list without waiting for it to be serviced !
>   *	In that case, we usually use idetape_queue_pc_head.
>   */
> @@ -3644,7 +3637,6 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
>  	tape->name[1] = 't';
>  	tape->name[2] = '0' + minor;
>  	tape->chrdev_dir = idetape_dir_none;
> -	tape->pc = tape->pc_stack;
>  	tape->max_ins_speed = 10000;
>  	tape->speed_ctl = 1;
>  	*((unsigned short *) &gcw) = drive->id->config;
