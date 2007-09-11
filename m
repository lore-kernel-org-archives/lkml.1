Return-Path: <linux-kernel-owner+w=401wt.eu-S1757484AbXIKVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757484AbXIKVlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 17:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754773AbXIKVkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 17:40:19 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:27297 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754212AbXIKVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 17:40:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=UW7LeGnPC+5wizdSqDCQPqLYyxD4q5TFFvGtLM32FcT90p3OUME+r5zFk8IfU7J3Sb2CNCp0Q0k4pmLgqZanJ3xlnNPs+beP+FGYOSKWkZZuCjVBaoZ4OQmc4sH9sGReZTpu9/Ab/3/0qUi6sONLigl4fXLR6ZkSwV/rGVFHGx8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [-mm patch] remove ide_get_error_location()
Date: Tue, 11 Sep 2007 23:27:20 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20070831215822.26e1432b.akpm@linux-foundation.org> <20070909202455.GM3563@stusta.de>
In-Reply-To: <20070909202455.GM3563@stusta.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709112327.20764.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 September 2007, Adrian Bunk wrote:
> On Fri, Aug 31, 2007 at 09:58:22PM -0700, Andrew Morton wrote:
> >...
> > Changes since 2.6.23-rc3-mm1:
> >...
> >  git-block.patch
> >...
> >  git trees
> >...
> 
> ide_get_error_location() is no longer used.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Since git-block contains the patch which removes the only user of
ide_get_error_location() I think that this patch should be also merged
through block tree.  Jens?

PS none of the blkdev_issue_flush() users uses *error_sector argument
so it can be probably removed as well

> ---
> 
>  drivers/ide/ide-io.c |   35 -----------------------------------
>  include/linux/ide.h  |    5 -----
>  2 files changed, 40 deletions(-)
> 
> 924249789a0c0d577c5c5bfa91f4e514b7ebde60 
> diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> index c1692d9..ec835e3 100644
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -322,41 +322,6 @@ static void ide_complete_pm_request (ide_drive_t *drive, struct request *rq)
>  	spin_unlock_irqrestore(&ide_lock, flags);
>  }
>  
> -/*
> - * FIXME: probably move this somewhere else, name is bad too :)
> - */
> -u64 ide_get_error_location(ide_drive_t *drive, char *args)
> -{
> -	u32 high, low;
> -	u8 hcyl, lcyl, sect;
> -	u64 sector;
> -
> -	high = 0;
> -	hcyl = args[5];
> -	lcyl = args[4];
> -	sect = args[3];
> -
> -	if (ide_id_has_flush_cache_ext(drive->id)) {
> -		low = (hcyl << 16) | (lcyl << 8) | sect;
> -		HWIF(drive)->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
> -		high = ide_read_24(drive);
> -	} else {
> -		u8 cur = HWIF(drive)->INB(IDE_SELECT_REG);
> -		if (cur & 0x40) {
> -			high = cur & 0xf;
> -			low = (hcyl << 16) | (lcyl << 8) | sect;
> -		} else {
> -			low = hcyl * drive->head * drive->sect;
> -			low += lcyl * drive->sect;
> -			low += sect - 1;
> -		}
> -	}
> -
> -	sector = ((u64) high << 24) | low;
> -	return sector;
> -}
> -EXPORT_SYMBOL(ide_get_error_location);
> -
>  /**
>   *	ide_end_drive_cmd	-	end an explicit drive command
>   *	@drive: command 
> diff --git a/include/linux/ide.h b/include/linux/ide.h
> index 48871f9..65de5c3 100644
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -1088,11 +1088,6 @@ extern ide_startstop_t ide_do_reset (ide_drive_t *);
>  extern void ide_init_drive_cmd (struct request *rq);
>  
>  /*
> - * this function returns error location sector offset in case of a write error
> - */
> -extern u64 ide_get_error_location(ide_drive_t *, char *);
> -
> -/*
>   * "action" parameter type for ide_do_drive_cmd() below.
>   */
>  typedef enum {
> 
> 


