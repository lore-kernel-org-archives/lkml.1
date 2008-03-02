Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbYCBTEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbYCBTEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:04:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbYCBTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:39140 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758791AbYCBTDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=JrnqvNPO1mzTetx9nQQKe3j+jl8U5xlVdTHI4dQIDFJmAFEub4OqATqvRZndkIcvzYrnRjSs2NOM2IfqXMlwA6hy3KIDtzNmwlTtZJNwXsVf1b4wVhyLLR2anUi2Wft+R6b8/oMmGvqXwYMNA06nC6oH86aDDlXf8U98V1u5Kco=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 03/24] ide-tape: remove pipeline-specific code from idetape_add_chrdev_read_request
Date: Sun, 2 Mar 2008 19:36:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021936.12741.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> We fall back to non-pipelined operation through idetape_queue_rw_tail with cmd
> set to REQ_IDETAPE_READ. Also, remove idetape_switch_buffers() since it becomes
> unused.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   46 +---------------------------------------------
>  1 files changed, 1 insertions(+), 45 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index abf3efa..e919d41 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -1776,16 +1776,6 @@ static void idetape_init_merge_stage(idetape_tape_t *tape)
>  	}
>  }
>  
> -static void idetape_switch_buffers(idetape_tape_t *tape, idetape_stage_t *stage)
> -{
> -	struct idetape_bh *tmp;
> -
> -	tmp = stage->bh;
> -	stage->bh = tape->merge_stage->bh;
> -	tape->merge_stage->bh = tmp;
> -	idetape_init_merge_stage(tape);
> -}
> -
>  /* Add a new stage at the end of the pipeline. */
>  static void idetape_add_stage_tail(ide_drive_t *drive, idetape_stage_t *stage)
>  {
> @@ -2403,9 +2393,6 @@ static int idetape_init_read(ide_drive_t *drive, int max_stages)
>  static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
> -	unsigned long flags;
> -	struct request *rq_ptr;
> -	int bytes_read;
>  
>  	debug_log(DBG_PROCS, "Enter %s, %d blocks\n", __func__, blocks);
>  
> @@ -2413,39 +2400,8 @@ static int idetape_add_chrdev_read_request(ide_drive_t *drive, int blocks)
>  	if (test_bit(IDETAPE_FLAG_FILEMARK, &tape->flags))
>  		return 0;
>  
> -	/* Wait for the next block to reach the head of the pipeline. */
> -	idetape_init_read(drive, tape->max_stages);

Can it be simply removed?  Why?

> -	if (tape->first_stage == NULL) {
> -		if (test_bit(IDETAPE_FLAG_PIPELINE_ERR, &tape->flags))
> -			return 0;
> -		return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
> +	return idetape_queue_rw_tail(drive, REQ_IDETAPE_READ, blocks,
>  					tape->merge_stage->bh);

Looking at the driver code tape->first_stage is not always NULL,
seems like ide_tape_add_stage_tail() should vanish first?
