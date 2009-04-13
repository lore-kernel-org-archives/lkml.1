Return-Path: <linux-kernel-owner+w=401wt.eu-S1755667AbZDMIwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755667AbZDMIwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 04:52:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZDMIwl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 04:52:41 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:57643 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZDMIwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 04:52:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=Q0rC5IWHrrbXi0B3w5/2QdQIf5dYyOo+ksNOagvp/FhPN4XXOQzzRtsaLaStpJGd+y
         RE/3afnos5uBfzqNVlgF+kuu4CkX/jn/mo/A7/xjdYPXrzw1nsQzgIWEd69aozCgRoPq
         wgvfO2qGmRWbINXYbidMEgUIUEaTZAr1yj+pU=
Date: Mon, 13 Apr 2009 10:52:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH 14/14] ide-cd: use bio for request sense
Message-ID: <20090413085233.GA10115@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <tj@kernel.org>,
	bzolnier@gmail.com, linux-kernel@vger.kernel.org, axboe@kernel.dk,
	linux-ide@vger.kernel.org
References: <1237910776-10983-1-git-send-email-tj@kernel.org> <1237910776-10983-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1237910776-10983-15-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:06:16AM +0900, Tejun Heo wrote:
> Impact: unify request data buffer handling
> 
> rq->data is used mostly to pass kernel buffer through request queue
> without using bio.  There are only a couple of places which still do
> this in kernel and converting to bio isn't difficult.
> 
> This patch converts ide-cd to use bio instead of rq->data for request
> sense and internal pc commands.  As request sense is issued from
> atomic context, drive->request_sense_bio and ->request_sense_bvec[2]
> are used via bio_map_kern_prealloc().  Internal pc commands use
> blk_rq_map_kern().
> 
> cdrom_do_block_pc() now doesn't have to deal with REQ_TYPE_ATA_PC
> special case.  Simplified.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> ---
>  drivers/ide/ide-cd.c |   31 ++++++++++++++++++-------------
>  1 files changed, 18 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index de6ce8d..22c95b9 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -209,8 +209,12 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
>  static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
>  				      struct request *failed_command)
>  {
> -	struct cdrom_info *info		= drive->driver_data;
> -	struct request *rq		= &drive->request_sense_rq;
> +	struct cdrom_info *info	= drive->driver_data;
> +	struct request *rq	= &drive->request_sense_rq;
> +	struct bio *bio		= &drive->request_sense_bio;
> +	struct bio_vec *bvec	= drive->request_sense_bvec;
> +	unsigned int bvec_len	= ARRAY_SIZE(drive->request_sense_bvec);
> +	int error;
>  
>  	ide_debug_log(IDE_DBG_SENSE, "enter");
>  
> @@ -224,10 +228,12 @@ static void cdrom_queue_request_sense(ide_drive_t *drive, void *sense,
>  	rq->cmd_type = REQ_TYPE_ATA_PC;

by the way, this line can go too, since the correct type is REQ_TYPE_SENSE now.

>  	rq->rq_disk = info->disk;
>  
> -	rq->data = sense;
> +	error = blk_rq_map_kern_prealloc(drive->queue, rq, bio, bvec, bvec_len,
> +					 sense, 18, true);
> +	BUG_ON(error);
> +
>  	rq->cmd[0] = GPCMD_REQUEST_SENSE;
>  	rq->cmd[4] = 18;
> -	rq->data_len = 18;
>  
>  	rq->cmd_type = REQ_TYPE_SENSE;
>  	rq->cmd_flags |= REQ_PREEMPT;
> @@ -556,8 +562,12 @@ int ide_cd_queue_pc(ide_drive_t *drive, const unsigned char *cmd,
>  		rq->cmd_flags |= cmd_flags;
>  		rq->timeout = timeout;
>  		if (buffer) {
> -			rq->data = buffer;
> -			rq->data_len = *bufflen;
> +			error = blk_rq_map_kern(drive->queue, rq, buffer,
> +						*bufflen, __GFP_WAIT);
> +			if (error) {
> +				blk_put_request(rq);
> +				return error;
> +			}
>  		}
>  
>  		error = blk_execute_rq(drive->queue, info->disk, rq, 0);
> @@ -847,15 +857,10 @@ static void cdrom_do_block_pc(ide_drive_t *drive, struct request *rq)
>  	drive->dma = 0;
>  
>  	/* sg request */
> -	if (rq->bio || ((rq->cmd_type == REQ_TYPE_ATA_PC) && rq->data_len)) {
> +	if (rq->bio) {
>  		struct request_queue *q = drive->queue;
> +		char *buf = bio_data(rq->bio);
>  		unsigned int alignment;
> -		char *buf;
> -
> -		if (rq->bio)
> -			buf = bio_data(rq->bio);
> -		else
> -			buf = rq->data;
>  
>  		drive->dma = !!(drive->dev_flags & IDE_DFLAG_USING_DMA);
>  
> -- 
> 1.6.0.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards/Gruss,
    Boris.
