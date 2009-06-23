Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbZFWXQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbZFWXQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbZFWXQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:16:08 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52278
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751664AbZFWXQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:16:07 -0400
Date: Tue, 23 Jun 2009 16:16:11 -0700 (PDT)
Message-Id: <20090623.161611.139291300.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       petkovbb@gmail.com, htejun@gmail.com
Subject: Re: [patch 2/6] ide: fix ide_kill_rq() for special
 ide-{floppy,tape} driver requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <200906232326.06830.bzolnier@gmail.com>
References: <200906232326.06830.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 23 Jun 2009 23:26:06 +0200

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: fix ide_kill_rq() for special ide-{floppy,tape} driver requests
> 
> Such requests should be failed with -EIO (like all other requests
> in this function) instead of being completed successfully.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Untested, you may try pinging Borislav and/or Tejun about possible
> testing if you would like to verify the patch before applying.

This must be tested in some way.  I can see this potentially
breaking something.

Especially this is true because ide_complete_rq() does it's
"complete whole request right now" logic for error <= 0.

Borislov/Tejun, can either of you test this code path with this
change applied?  I'd very much appreciate it.

Thanks!

>  drivers/ide/ide-io.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -152,7 +152,7 @@ void ide_kill_rq(ide_drive_t *drive, str
>  
>  	if ((media == ide_floppy || media == ide_tape) && drv_req) {
>  		rq->errors = 0;
> -		ide_complete_rq(drive, 0, blk_rq_bytes(rq));
> +		ide_complete_rq(drive, -EIO, blk_rq_bytes(rq));
>  	} else {
>  		if (media == ide_tape)
>  			rq->errors = IDE_DRV_ERROR_GENERAL;
