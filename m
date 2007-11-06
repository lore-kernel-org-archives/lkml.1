Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbXKFAuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbXKFAuJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 19:50:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXKFAt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 19:49:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48949 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755028AbXKFAt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:49:57 -0500
Date: Mon, 5 Nov 2007 16:49:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] fat: optimize fat_count_free_clusters()
Message-Id: <20071105164954.ac568ba3.akpm@linux-foundation.org>
In-Reply-To: <87hck1pssj.fsf@duaron.myhome.or.jp>
References: <87hck1pssj.fsf@duaron.myhome.or.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2007 07:09:00 +0900
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> wrote:

> On large partition, scanning the free clusters is very slow if users
> doesn't use "usefree" option.
> 
> For optimizing it, this patch uses sb_breadahead() to read of FAT
> sectors. On some user's 15GB partition, this patch improved it very
> much (1min => 600ms).
> 
> The following is the result of 2GB partition on my machine.
> 
> without patch:
> 	root@devron (/)# time df -h > /dev/null
> 
> 	real    0m1.202s
> 	user    0m0.000s
> 	sys     0m0.440s
> 
> with patch:
> 	root@devron (/)# time df -h > /dev/null
> 
> 	real    0m0.378s
> 	user    0m0.012s
> 	sys     0m0.168s
> 

Can't complain about that ;)

> ---
> 
>  fs/fat/fatent.c |   28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff -puN fs/fat/fatent.c~fat_optimize-count-freeclus fs/fat/fatent.c
> --- linux-2.6/fs/fat/fatent.c~fat_optimize-count-freeclus	2007-11-05 06:01:10.000000000 +0900
> +++ linux-2.6-hirofumi/fs/fat/fatent.c	2007-11-05 06:01:10.000000000 +0900
> @@ -590,21 +590,49 @@ error:
>  
>  EXPORT_SYMBOL_GPL(fat_free_clusters);
>  
> +/* 128kb is the whole sectors for FAT12 and FAT16 */
> +#define FAT_READA_SIZE		(128 * 1024)
> +
> +static void fat_ent_reada(struct super_block *sb, struct fat_entry *fatent,
> +			  unsigned long reada_blocks)
> +{
> +	struct fatent_operations *ops = MSDOS_SB(sb)->fatent_ops;
> +	sector_t blocknr;
> +	int i, offset;
> +
> +	ops->ent_blocknr(sb, fatent->entry, &offset, &blocknr);
> +
> +	for (i = 0; i < reada_blocks; i++)
> +		sb_breadahead(sb, blocknr + i);
> +}

You might find that it's simpler and faster to call
page_cache_sync_readahead() against sb->s_bdev->bd_inode->i_mapping.

Or maybe not - that requires a struct file_ra_state.  We _used_ to have a
nice simple read-some-stuff-into-pagecache function which didn't need an
ra_state but that seems to have disappeared in the various recent readahead
churn.  Oh well.

