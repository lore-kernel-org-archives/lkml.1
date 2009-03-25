Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZCYPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZCYPMY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755593AbZCYPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 11:12:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:27086 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbZCYPMN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 11:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=kqP2V3qBy9b1yAiD7eQMfzjcMObvs0rlQ2DP6SXP6afCA4Oz1WLVyF/6Qut1soYDVU
         vP4cEoBdQyIlO45LznMzxIDiD1Xgky0YV6pp4XUjLN1x+TiDgNL5WbWlya5upZH9Y/q8
         2KvFo+J6uB3VMCOfRbcgSiROjqRzsEhgM7k8Q=
MIME-Version: 1.0
Reply-To: petkovbb@gmail.com
In-Reply-To: <1237990673-8358-5-git-send-email-tj@kernel.org>
References: <1237990673-8358-1-git-send-email-tj@kernel.org>
	 <1237990673-8358-5-git-send-email-tj@kernel.org>
Date: Wed, 25 Mar 2009 16:12:11 +0100
Message-ID: <9ea470500903250812r19970910h12d197716d262c82@mail.gmail.com>
Subject: Re: [PATCH 04/10] ide-tape: use standard data transfer mechanism
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 3:17 PM, Tejun Heo <tj@kernel.org> wrote:
> Impact: use standard way to transfer data
>
> Now that data area is represented with bio, there is no need to use
> custom data transfer methods.  Drop idetape_io_buffers() and
> idetape_update_buffers().  pc->bh is set to null to tell ide-atapi to
> use standard data transfer mechanism and idetape_bh byte counts are
> updated by the issuer on completion using the residual count.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  drivers/ide/ide-tape.c |   84 +++--------------------------------------------
>  1 files changed, 6 insertions(+), 78 deletions(-)
>
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index bd0e839..dd37fd7 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -292,65 +292,6 @@ static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
>        return tape;
>  }
>
> -static int idetape_input_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
> -                                 unsigned int bcount)
> -{
> -       struct idetape_bh *bh = pc->bh;
> -       int count;
> -
> -       if (bcount && bh) {
> -               count = min(
> -                       (unsigned int)(bh->b_size - atomic_read(&bh->b_count)),
> -                       bcount);
> -               drive->hwif->tp_ops->input_data(drive, NULL, bh->b_data +
> -                                       atomic_read(&bh->b_count), count);
> -               bcount -= count;
> -               atomic_add(count, &bh->b_count);
> -               if (atomic_read(&bh->b_count) == bh->b_size)
> -                       pc->bh = NULL;
> -       }
> -
> -       return bcount;
> -}
> -
> -static int idetape_output_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
> -                                  unsigned int bcount)
> -{
> -       struct idetape_bh *bh = pc->bh;
> -       int count;
> -
> -       if (bcount && bh) {
> -               count = min((unsigned int)pc->b_count, (unsigned int)bcount);
> -               drive->hwif->tp_ops->output_data(drive, NULL, pc->b_data, count);
> -               bcount -= count;
> -               pc->b_data += count;
> -               pc->b_count -= count;
> -               if (!pc->b_count)
> -                       pc->bh = NULL;
> -       }
> -
> -       return bcount;
> -}
> -
> -static void idetape_update_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc)
> -{
> -       struct idetape_bh *bh = pc->bh;
> -       unsigned int bcount = pc->xferred;
> -
> -       if (pc->flags & PC_FLAG_WRITING)
> -               return;
> -       if (bcount) {
> -               if (bh == NULL || bcount > bh->b_size) {
> -                       printk(KERN_ERR "ide-tape: bh == NULL in %s\n",
> -                                       __func__);
> -                       return;
> -               }
> -               atomic_set(&bh->b_count, bcount);
> -               if (atomic_read(&bh->b_count) == bh->b_size)
> -                       pc->bh = NULL;
> -       }
> -}
> -
>  /*
>  * called on each failed packet command retry to analyze the request sense. We
>  * currently do not utilize this information.
> @@ -368,12 +309,10 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
>                 pc->c[0], tape->sense_key, tape->asc, tape->ascq);
>
>        /* Correct pc->xferred by asking the tape.       */
> -       if (pc->flags & PC_FLAG_DMA_ERROR) {
> +       if (pc->flags & PC_FLAG_DMA_ERROR)
>                pc->xferred = pc->req_xfer -
>                        tape->blk_size *
>                        get_unaligned_be32(&sense[3]);
> -               idetape_update_buffers(drive, pc);
> -       }
>
>        /*
>         * If error was the result of a zero-length read or write command,
> @@ -520,19 +459,6 @@ static void ide_tape_handle_dsc(ide_drive_t *drive)
>        idetape_postpone_request(drive);
>  }
>
> -static int ide_tape_io_buffers(ide_drive_t *drive, struct ide_atapi_pc *pc,
> -                               unsigned int bcount, int write)
> -{
> -       unsigned int bleft;
> -
> -       if (write)
> -               bleft = idetape_output_buffers(drive, pc, bcount);
> -       else
> -               bleft = idetape_input_buffers(drive, pc, bcount);
> -
> -       return bcount - bleft;
> -}
> -
>  /*
>  * Packet Command Interface
>  *
> @@ -685,7 +611,7 @@ static void ide_tape_create_rw_cmd(idetape_tape_t *tape,
>        ide_init_pc(pc);
>        put_unaligned(cpu_to_be32(length), (unsigned int *) &pc->c[1]);
>        pc->c[1] = 1;
> -       pc->bh = bh;
> +       pc->bh = NULL;
>        pc->buf = NULL;
>        pc->buf_size = length * tape->blk_size;
>        pc->req_xfer = pc->buf_size;
> @@ -1083,7 +1009,11 @@ static int idetape_queue_rw_tail(ide_drive_t *drive, int cmd, int blocks,
>
>        blk_execute_rq(drive->queue, tape->disk, rq, 0);
>
> +       /* calculate the number of transferred bytes and update bh */
>        size -= rq->data_len;
> +       if (cmd == REQ_IDETAPE_READ)
> +               atomic_add(size, &bh->b_count);
> +
>        ret = size;
>        if (rq->errors == IDE_DRV_ERROR_GENERAL)
>                ret = -EIO;
> @@ -2037,8 +1967,6 @@ static void idetape_setup(ide_drive_t *drive, idetape_tape_t *tape, int minor)
>        u16 *ctl = (u16 *)&tape->caps[12];
>
>        drive->pc_callback       = ide_tape_callback;
> -       drive->pc_update_buffers = idetape_update_buffers;
> -       drive->pc_io_buffers     = ide_tape_io_buffers;

You might just as well remove those two ide_drive_t members since
they're used only by ide-tape.

-- 
Regards/Gruss,
Boris
