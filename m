Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbYCBTEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbYCBTEt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 14:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758907AbYCBTDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 14:03:38 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:37094 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827AbYCBTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 14:03:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=A+sY7JGKKUQXFoOMcZX4EgufVGEnu/86YjKK/On2DaGaM3FzqviIXyXMBdenLTE6lyaQjyNHBDAeBk0TVN6/Qktj5qEpx4pdib4JULxr5Ww27HzQJrfMU9NX+hNjCIiItyczSltwOn4scgZjV4NUhFrehB464eskJfd8aEEeno4=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 04/24] ide-tape: remove pipeline-specific code from idetape_chrdev_write
Date: Sun, 2 Mar 2008 19:41:28 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1204361928-30229-1-git-send-email-petkovbb@gmail.com> <1204361928-30229-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1204361928-30229-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803021941.28401.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2008, Borislav Petkov wrote:
> Also, remove unused stage-parameter from idetape_copy_stage_from_user()

Changes like this one are the best to put into separate patches
at the very beginning of the patch series.

> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   15 ++++-----------
>  1 files changed, 4 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index e919d41..4a064c1 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -1700,7 +1700,7 @@ static idetape_stage_t *idetape_kmalloc_stage(idetape_tape_t *tape)
>  }
>  
>  static int idetape_copy_stage_from_user(idetape_tape_t *tape,
> -		idetape_stage_t *stage, const char __user *buf, int n)
> +					const char __user *buf, int n)
>  {
>  	struct idetape_bh *bh = tape->bh;
>  	int count;
> @@ -2696,8 +2696,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
>  
>  	/* Initialize write operation */
>  	if (tape->chrdev_dir != IDETAPE_DIR_WRITE) {
> -		if (tape->chrdev_dir == IDETAPE_DIR_READ)
> -			idetape_discard_read_pipeline(drive, 1);

Why this is OK thing to do?

Are you sure that there are no hidden side-effects?

>  		if (tape->merge_stage || tape->merge_stage_size) {
>  			printk(KERN_ERR "ide-tape: merge_stage_size "
>  				"should be 0 now\n");
> @@ -2729,8 +2727,6 @@ static ssize_t idetape_chrdev_write(struct file *file, const char __user *buf,
>  	}
>  	if (count == 0)
>  		return (0);
> -	if (tape->restart_speed_control_req)
> -		idetape_restart_speed_control(drive);

ditto

tape->restart_speed_control_req can still be non-zero.
