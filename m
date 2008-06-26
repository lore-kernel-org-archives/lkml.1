Return-Path: <linux-kernel-owner+w=401wt.eu-S1758731AbYFZSkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731AbYFZSkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYFZSjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:39:53 -0400
Received: from bu3sch.de ([62.75.166.246]:45719 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbYFZSjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:39:52 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Oops when using growisofs
Date: Thu, 26 Jun 2008 20:39:04 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200806221818.24372.mb@bu3sch.de> <200806262021.32140.mb@bu3sch.de> <20080626183610.GI20851@kernel.dk>
In-Reply-To: <20080626183610.GI20851@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806262039.04678.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 June 2008 20:36:11 Jens Axboe wrote:
> Something like this, totally untested...
> 
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index 68e7f19..5c1e663 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -1308,13 +1308,29 @@ static int cdrom_read_capacity(ide_drive_t *drive, unsigned long *capacity,
>  	req.cmd_flags |= REQ_QUIET;
>  
>  	stat = ide_cd_queue_pc(drive, &req);
> -	if (stat == 0) {
> -		*capacity = 1 + be32_to_cpu(capbuf.lba);
> -		*sectors_per_frame =
> -			be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> +	if (stat)
> +		return stat;
> +
> +	/*
> +	 * Sanity check the given block size
> +	 */
> +	switch (capbuf.blocklen) {
> +	case 512:
> +	case 1024:
> +	case 2048:
> +	case 4096:
> +		break;
> +	default:
> +		printk(KERN_ERR "ide-cd: weird block size %u\n",
> +							capbuf.blocklen);
> +		printk(KERN_ERR "ide-cd: default to 2kb block size\n");

KERN_WARNING

> +		capbuf.blocklen = 2048;
> +		break;
>  	}
>  
> -	return stat;
> +	*capacity = 1 + be32_to_cpu(capbuf.lba);
> +	*sectors_per_frame = be32_to_cpu(capbuf.blocklen) >> SECTOR_BITS;
> +	return 0;
>  }
>  
>  static int cdrom_read_tocentry(ide_drive_t *drive, int trackno, int msf_flag,
> 

I'll test this. Thanks a lot. :)
However I cannot reproduce the bug. So I cannot tell whether it fixes it.

-- 
Greetings Michael.
