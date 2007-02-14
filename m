Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXBNKv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXBNKv7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 05:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932215AbXBNKv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 05:51:59 -0500
Received: from styx.suse.cz ([82.119.242.94]:58843 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932203AbXBNKv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 05:51:58 -0500
Date: Wed, 14 Feb 2007 11:55:22 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FAT: DIO-write fallback to normal buffered
Message-ID: <20070214105522.GA23203@duck.suse.cz>
References: <87sldenkg0.fsf@duaron.myhome.or.jp> <87ejoynkcu.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ejoynkcu.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 10-02-07 23:44:01, OGAWA Hirofumi wrote:
> [RESEND: forget to add linux-kernel@vger.kernel.org]
> 
> If the DIO write on FAT is expanding the size, it will be fail by -EINVAL,
> because FAT can't handle it now.
> 
> This patch fallback it to the normal buffered-write and would return
> success.
> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
  Signed-off-by: Jan Kara <jack@suse.cz>

  Just to explain a bit: I think that returning EINVAL is quite unexpected
for users in this case (I actually got a bugreport which turned out to be
this problem) and fallback to buffered IO seems to be a reasonable thing to
do. Probably it's not the cleanest solution but for FAT I think it's good
enough ;).

								Honza

> ---
> 
>  fs/fat/inode.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff -puN fs/fat/inode.c~fat_direct-io-fallback fs/fat/inode.c
> --- linux-2.6/fs/fat/inode.c~fat_direct-io-fallback	2007-02-10 22:08:33.000000000 +0900
> +++ linux-2.6-hirofumi/fs/fat/inode.c	2007-02-10 22:08:33.000000000 +0900
> @@ -173,10 +173,12 @@ static ssize_t fat_direct_IO(int rw, str
>  		 *
>  		 * But we must fill the remaining area or hole by nul for
>  		 * updating ->mmu_private.
> +		 *
> +		 * Return 0, and fallback to normal buffered write.
>  		 */
>  		loff_t size = offset + iov_length(iov, nr_segs);
>  		if (MSDOS_I(inode)->mmu_private < size)
> -			return -EINVAL;
> +			return 0;
>  	}
>  
>  	/*
> _
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
