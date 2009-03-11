Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbZCKSNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbZCKSNt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 14:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZCKSNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 14:13:40 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:53259 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZCKSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 14:13:39 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Laurent GUERBY <laurent@guerby.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.29-rc5][BUG] swapon on vfat file gets stuck on inode lock
References: <1236779832.11347.2082.camel@localhost>
	<alpine.LFD.2.00.0903110837590.32478@localhost.localdomain>
	<87ocw80z6s.fsf@devron.myhome.or.jp>
Date: Thu, 12 Mar 2009 03:13:34 +0900
In-Reply-To: <87ocw80z6s.fsf@devron.myhome.or.jp> (OGAWA Hirofumi's message of
	"Thu, 12 Mar 2009 02:03:23 +0900")
Message-ID: <874oy0orld.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:

> I'm sure that path touch the metadata without locking (so, reused entry
> can not be for that inode anymore). However, I guess the result doesn't
> become any fs corruption, so and other fs is ignoring the possibly wrong
> result of bmap().
>
> I'm thinking to use this patch instead of removing.

Ok. Simple stress test was done. BTW, since fat caches the metadata on
that path, fat would be sensitive to race more than other fs.

Anyway, if you are ok, please apply. Otherwise, I'm going to prepare for
this patch to next merge window.

Thanks.

> [PATCH] Fix _fat_bmap() locking
>
> On swapon() path, it has already i_mutex. So, this uses i_alloc_sem
> instead of it.
>
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
>
>  fs/fat/inode.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff -puN fs/fat/inode.c~fat_bmap-locking-fix fs/fat/inode.c
> --- linux-2.6/fs/fat/inode.c~fat_bmap-locking-fix	2009-03-12 00:47:15.000000000 +0900
> +++ linux-2.6-hirofumi/fs/fat/inode.c	2009-03-12 00:47:42.000000000 +0900
> @@ -202,9 +202,9 @@ static sector_t _fat_bmap(struct address
>  	sector_t blocknr;
>  
>  	/* fat_get_cluster() assumes the requested blocknr isn't truncated. */
> -	mutex_lock(&mapping->host->i_mutex);
> +	down_read(&mapping->host->i_alloc_sem);
>  	blocknr = generic_block_bmap(mapping, block, fat_get_block);
> -	mutex_unlock(&mapping->host->i_mutex);
> +	up_read(&mapping->host->i_alloc_sem);
>  
>  	return blocknr;
>  }
> _

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
