Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbYAJXZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbYAJXZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759252AbYAJXYx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:24:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:32939 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759221AbYAJXYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:24:52 -0500
Date: Fri, 11 Jan 2008 00:24:49 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 10/16] udf: create common function for changing free
	space counter
Message-ID: <20080110232449.GF17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-11-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-11-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:26, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Jan Kara <jack@suse.cz>
> CC: Christoph Hellwig <hch@infradead.org>
  Just two minor comment...

> ---
>  fs/udf/balloc.c |   49 ++++++++++++++++++++-----------------------------
>  1 files changed, 20 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index dc9f8a9..78dbf1d 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -140,6 +140,20 @@ static inline int load_block_bitmap(struct super_block *sb,
>  	return slot;
>  }
>  
> +static bool udf_inc_free_space(struct udf_sb_info *sbi,
  Maybe because you use the function for both increasing and decreasing
free space, you could call is udf_add_free_space?

> +				u16 partition, u32 cnt)
> +{
> +	struct logicalVolIntegrityDesc *lvid;
> +
> +	if (sbi->s_lvid_bh)
> +		return false;
> +
> +	lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> +	lvid->freeSpaceTable[partition] = cpu_to_le32(le32_to_cpu(
> +					lvid->freeSpaceTable[partition]) + cnt);
  I think macro like le32_add_cpu() just went into the kernel so you could
use that...

> +	return true;
> +}
> +
>  static void udf_bitmap_free_blocks(struct super_block *sb,
>  				   struct inode *inode,
>  				   struct udf_bitmap *bitmap,
> @@ -194,11 +208,7 @@ do_more:
>  		} else {
>  			if (inode)
>  				DQUOT_FREE_BLOCK(inode, 1);
> -			if (sbi->s_lvid_bh) {
> -				struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -				lvid->freeSpaceTable[sbi->s_partition] =
> -					cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + 1);
> -			}
> +			udf_inc_free_space(sbi, sbi->s_partition, 1);
>  		}
>  	}
>  	mark_buffer_dirty(bh);
> @@ -268,12 +278,8 @@ repeat:
>  	if (block_count > 0)
>  		goto repeat;
>  out:
> -	if (sbi->s_lvid_bh) {
> -		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -		lvid->freeSpaceTable[partition] =
> -			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
> +	if (udf_inc_free_space(sbi, partition, -alloc_count))
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -	}
>  	sb->s_dirt = 1;
>  	mutex_unlock(&sbi->s_alloc_mutex);
>  	return alloc_count;
> @@ -404,12 +410,8 @@ got_block:
>  
>  	mark_buffer_dirty(bh);
>  
> -	if (sbi->s_lvid_bh) {
> -		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -		lvid->freeSpaceTable[partition] =
> -			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
> +	if (udf_inc_free_space(sbi, partition, -1))
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -	}
>  	sb->s_dirt = 1;
>  	mutex_unlock(&sbi->s_alloc_mutex);
>  	*err = 0;
> @@ -450,12 +452,8 @@ static void udf_table_free_blocks(struct super_block *sb,
>  	   could occure, but.. oh well */
>  	if (inode)
>  		DQUOT_FREE_BLOCK(inode, count);
> -	if (sbi->s_lvid_bh) {
> -		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -		lvid->freeSpaceTable[sbi->s_partition] =
> -			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[sbi->s_partition]) + count);
> +	if (udf_inc_free_space(sbi, sbi->s_partition, count))
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -	}
>  
>  	start = bloc.logicalBlockNum + offset;
>  	end = bloc.logicalBlockNum + offset + count - 1;
> @@ -719,10 +717,7 @@ static int udf_table_prealloc_blocks(struct super_block *sb,
>  
>  	brelse(epos.bh);
>  
> -	if (alloc_count && sbi->s_lvid_bh) {
> -		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -		lvid->freeSpaceTable[partition] =
> -			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - alloc_count);
> +	if (alloc_count && udf_inc_free_space(sbi, partition, -alloc_count)) {
>  		mark_buffer_dirty(sbi->s_lvid_bh);
>  		sb->s_dirt = 1;
>  	}
> @@ -822,12 +817,8 @@ static int udf_table_new_block(struct super_block *sb,
>  		udf_delete_aext(table, goal_epos, goal_eloc, goal_elen);
>  	brelse(goal_epos.bh);
>  
> -	if (sbi->s_lvid_bh) {
> -		struct logicalVolIntegrityDesc *lvid = (struct logicalVolIntegrityDesc *)sbi->s_lvid_bh->b_data;
> -		lvid->freeSpaceTable[partition] =
> -			cpu_to_le32(le32_to_cpu(lvid->freeSpaceTable[partition]) - 1);
> +	if (udf_inc_free_space(sbi, partition, -1))
>  		mark_buffer_dirty(sbi->s_lvid_bh);
> -	}
>  
>  	sb->s_dirt = 1;
>  	mutex_unlock(&sbi->s_alloc_mutex);

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
