Return-Path: <linux-kernel-owner+w=401wt.eu-S1755703AbYCTX6D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703AbYCTX6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:58:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756783AbYCTX42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:28 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:61948 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756347AbYCTX4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=gzzO2W58l/bIgM3G/njcAVuGtdG9WNZpUEuBJPvTd0LiWqX0YvZsbSyg2nDGeDQXcQ54+9PyxAu2SfaU0dYmLUt1ig91ZcqwUC7ekUUeAHfTVckHA/Dg1CLRTPOzCM1WN8I+Hm+SDJPhQad1fosH+QS7N31qz77bCG/cYNvjNM8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 03/17] ide-tape: remove idetape_discard_read_pipeline()
Date: Fri, 21 Mar 2008 01:09:01 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.02044.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Now that we don't queue any more requests on the pipeline we don't need to
> discard it anymore. Also, remove __idetape_discard_read_pipeline() too.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   92 +----------------------------------------------
>  1 files changed, 2 insertions(+), 90 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 241f596..429fed4 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -1875,52 +1875,6 @@ static int idetape_create_prevent_cmd(ide_drive_t *drive,
>  	return 1;
>  }
>  
> -static int __idetape_discard_read_pipeline(ide_drive_t *drive)
> -{
> -	idetape_tape_t *tape = drive->driver_data;
> -	unsigned long flags;
> -	int cnt;
> -
> -	if (tape->chrdev_dir != IDETAPE_DIR_READ)
> -		return 0;
> -
> -	/* Remove merge stage. */
> -	cnt = tape->merge_stage_size / tape->blk_size;
> -	if (test_and_clear_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
> -		++cnt;		/* Filemarks count as 1 sector */
> -	tape->merge_stage_size = 0;

->merge_stage_size is still used for accounting and we've just silently
deleted code modifying it...

> -	if (tape->merge_stage != NULL) {
> -		__idetape_kfree_stage(tape->merge_stage);
> -		tape->merge_stage = NULL;
> -	}
> -
> -	/* Clear pipeline flags. */
> -	clear_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags);
> -	tape->chrdev_dir = IDETAPE_DIR_NONE;

ditto for ->merge_stage and ->chrdev_dir (!)

> -	/* Remove pipeline stages. */
> -	if (tape->first_stage == NULL)
> -		return 0;

only code below could be safely deleted at the moment
(we know that ->first_stage is always NULL)

> -	spin_lock_irqsave(&tape->lock, flags);
> -	tape->next_stage = NULL;
> -	if (test_bit(IDETAPE_FLAG_PIPELINE_ACTIVE, &tape->flags))
> -		idetape_wait_for_request(drive, tape->active_data_rq);
> -	spin_unlock_irqrestore(&tape->lock, flags);
> -
> -	while (tape->first_stage != NULL) {
> -		struct request *rq_ptr = &tape->first_stage->rq;
> -
> -		cnt += rq_ptr->nr_sectors - rq_ptr->current_nr_sectors;
> -		if (rq_ptr->errors == IDETAPE_ERROR_FILEMARK)
> -			++cnt;
> -		idetape_remove_stage_head(drive);
> -	}
> -	tape->nr_pending_stages = 0;
> -	tape->max_stages = tape->min_pipeline;
> -	return cnt;
> -}
> -
>  /*
>   * Position the tape to the requested block using the LOCATE packet command.
>   * A READ POSITION command is then issued to check where we are positioned. Like
> @@ -1930,12 +1884,9 @@ static int __idetape_discard_read_pipeline(ide_drive_t *drive)
>  static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
>  		u8 partition, int skip)
>  {
> -	idetape_tape_t *tape = drive->driver_data;
> -	int retval;
>  	struct ide_atapi_pc pc;
> +	int retval;
>  
> -	if (tape->chrdev_dir == IDETAPE_DIR_READ)
> -		__idetape_discard_read_pipeline(drive);
>  	idetape_wait_ready(drive, 60 * 5 * HZ);
>  	idetape_create_locate_cmd(drive, &pc, block, partition, skip);
>  	retval = idetape_queue_pc_tail(drive, &pc);
> @@ -1946,25 +1897,6 @@ static int idetape_position_tape(ide_drive_t *drive, unsigned int block,
>  	return (idetape_queue_pc_tail(drive, &pc));
>  }
>  
> -static void idetape_discard_read_pipeline(ide_drive_t *drive,
> -					  int restore_position)
> -{
> -	idetape_tape_t *tape = drive->driver_data;
> -	int cnt;
> -	int seek, position;
> -
> -	cnt = __idetape_discard_read_pipeline(drive);
> -	if (restore_position) {
> -		position = idetape_read_position(drive);
> -		seek = position > cnt ? position - cnt : 0;
> -		if (idetape_position_tape(drive, seek, 0, 0)) {

and here we've silently deleted idetape_position_tape() call
(for 'restore_position == 1' users)

I just skipped this patch => I had to slightly re-do later patches
while merging them...

> -			printk(KERN_INFO "ide-tape: %s: position_tape failed in"
> -					 " discard_pipeline()\n", tape->name);
> -			return;
> -		}
> -	}
> -}
> -
>  /*
>   * Generate a read/write request for the block device interface and wait for it
>   * to be serviced.
> @@ -2406,11 +2338,6 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
>  				 * pipeline. There is no point in allowing the
>  				 * drive to continue reading any farther, so we
>  				 * stop the pipeline.
> -				 *
> -				 * This section should be moved to a separate
> -				 * subroutine because similar operations are
> -				 * done in __idetape_discard_read_pipeline(),
> -				 * for example.
>  				 */
>  				tape->next_stage = NULL;
>  				spin_unlock_irqrestore(&tape->lock, flags);
> @@ -2423,7 +2350,6 @@ static int idetape_space_over_filemarks(ide_drive_t *drive, short mt_op,
>  				++count;
>  			idetape_remove_stage_head(drive);
>  		}
> -		idetape_discard_read_pipeline(drive, 0);
>  	}
>  
>  	/*
> @@ -2547,8 +2473,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
>  
>  	/* Initialize write operation */
>  	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
> -		if (tape->chrdev_dir == IDETAPE_DIR_READ)
> -			idetape_discard_read_pipeline(drive, 1);
>  		if (tape->merge_stage || tape->merge_stage_size) {
>  			printk(KERN_ERR "ide-tape: merge_stage_size "
>  				"should be 0 now\n");
> @@ -2675,7 +2599,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
>  	case MTWEOF:
>  		if (tape->write_prot)
>  			return -EACCES;
> -		idetape_discard_read_pipeline(drive, 1);
>  		for (i = 0; i < mt_count; i++) {
>  			retval = idetape_write_filemark(drive);
>  			if (retval)
> @@ -2683,12 +2606,10 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
>  		}
>  		return 0;
>  	case MTREW:
> -		idetape_discard_read_pipeline(drive, 0);
>  		if (idetape_rewind_tape(drive))
>  			return -EIO;
>  		return 0;
>  	case MTLOAD:
> -		idetape_discard_read_pipeline(drive, 0);
>  		idetape_create_load_unload_cmd(drive, &pc,
>  					       IDETAPE_LU_LOAD_MASK);
>  		return idetape_queue_pc_tail(drive, &pc);
> @@ -2703,7 +2624,6 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
>  				if (!idetape_queue_pc_tail(drive, &pc))
>  					tape->door_locked = DOOR_UNLOCKED;
>  		}
> -		idetape_discard_read_pipeline(drive, 0);
>  		idetape_create_load_unload_cmd(drive, &pc,
>  					      !IDETAPE_LU_LOAD_MASK);
>  		retval = idetape_queue_pc_tail(drive, &pc);
> @@ -2711,10 +2631,8 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
>  			clear_bit(IDETAPE_FLAG_MEDIUM_PRESENT, &tape->flags);
>  		return retval;
>  	case MTNOP:
> -		idetape_discard_read_pipeline(drive, 0);
>  		return idetape_flush_tape_buffers(drive);
>  	case MTRETEN:
> -		idetape_discard_read_pipeline(drive, 0);
>  		idetape_create_load_unload_cmd(drive, &pc,
>  			IDETAPE_LU_RETENSION_MASK | IDETAPE_LU_LOAD_MASK);
>  		return idetape_queue_pc_tail(drive, &pc);
> @@ -2736,11 +2654,9 @@ static int idetape_mtioctop(ide_drive_t *drive, short mt_op, int mt_count)
>  			set_bit(IDETAPE_FLAG_DETECT_BS, &tape->flags);
>  		return 0;
>  	case MTSEEK:
> -		idetape_discard_read_pipeline(drive, 0);
>  		return idetape_position_tape(drive,
>  			mt_count * tape->user_bs_factor, tape->partition, 0);
>  	case MTSETPART:
> -		idetape_discard_read_pipeline(drive, 0);
>  		return idetape_position_tape(drive, 0, mt_count, 0);
>  	case MTFSR:
>  	case MTBSR:
> @@ -2821,8 +2737,6 @@ static int idetape_chrdev_ioctl(struct inode *inode, struct file *file,
>  			return -EFAULT;
>  		return 0;
>  	default:
> -		if (tape->chrdev_dir == IDETAPE_DIR_READ)
> -			idetape_discard_read_pipeline(drive, 1);
>  		return idetape_blkdev_ioctl(drive, cmd, arg);
>  	}
>  }
> @@ -2966,9 +2880,7 @@ static int idetape_chrdev_release(struct inode *inode, struct file *filp)
>  	if (tape->chrdev_dir == IDETAPE_DIR_WRITE)
>  		idetape_write_release(drive, minor);
>  	if (tape->chrdev_dir == IDETAPE_DIR_READ) {
> -		if (minor < 128)
> -			idetape_discard_read_pipeline(drive, 1);
> -		else
> +		if (minor >= 128)
>  			idetape_wait_for_pipeline(drive);
>  	}
