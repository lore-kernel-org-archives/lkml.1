Return-Path: <linux-kernel-owner+w=401wt.eu-S1757976AbZDPRGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976AbZDPRGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 13:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757535AbZDPRF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 13:05:58 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:49097 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467AbZDPRF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 13:05:58 -0400
Date: Thu, 16 Apr 2009 18:05:56 +0100
From: Andrew Price <andy@andrewprice.me.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: using rootfstype=ext4 causes oops
Message-ID: <20090416170556.GA24066@sucs.org>
Mail-Followup-To: Andrew Price <andy@andrewprice.me.uk>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Theodore Tso <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org
References: <20090415205926.GA28246@sucs.org> <20090416104758.GA433@sucs.org> <20090416145357.GM21586@mit.edu> <200904161802.21302.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904161802.21302.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 06:02:21PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Freeing non-slab objects is bad.
> 
> Andrew, does this patch help?

Yes, that seems to fix it. I tested it with gfs2 and ext4 the usual way
and I couldn't reproduce the panic.

Thanks Bartlomiej.

> ---
>  drivers/ide/ide-io.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> Index: b/drivers/ide/ide-io.c
> ===================================================================
> --- a/drivers/ide/ide-io.c
> +++ b/drivers/ide/ide-io.c
> @@ -102,11 +102,14 @@ void ide_complete_cmd(ide_drive_t *drive
>  			drive->dev_flags |= IDE_DFLAG_PARKED;
>  	}
>  
> -	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE)
> -		memcpy(rq->special, cmd, sizeof(*cmd));
> +	if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
> +		struct ide_cmd *orig_cmd = rq->special;
>  
> -	if (cmd->tf_flags & IDE_TFLAG_DYN)
> -		kfree(cmd);
> +		if (cmd->tf_flags & IDE_TFLAG_DYN)
> +			kfree(orig_cmd);
> +		else
> +			memcpy(orig_cmd, cmd, sizeof(*cmd));
> +	}
>  }
>  
>  /* obsolete, blk_rq_bytes() should be used instead */
> 

--
Andrew Price
