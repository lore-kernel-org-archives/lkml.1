Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbYAJXP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbYAJXP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYAJXPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:15:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:41739 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752993AbYAJXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:15:13 -0500
Date: Fri, 11 Jan 2008 00:15:12 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 06/16] udf: move calculating of nr_groups into helper
	function
Message-ID: <20080110231512.GD17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-7-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-7-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:22, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
> CC: Christoph Hellwig <hch@infradead.org>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
>  fs/udf/balloc.c |    4 +---
>  fs/udf/super.c  |   16 ++++++++++------
>  fs/udf/udf_sb.h |    2 ++
>  3 files changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
> index 8c0c279..3f67d9d 100644
> --- a/fs/udf/balloc.c
> +++ b/fs/udf/balloc.c
> @@ -231,9 +231,7 @@ static int udf_bitmap_prealloc_blocks(struct super_block *sb,
>  		block_count = part_len - first_block;
>  
>  repeat:
> -	nr_groups = (sbi->s_partmaps[partition].s_partition_len +
> -		     (sizeof(struct spaceBitmapDesc) << 3) +
> -		     (sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
> +	nr_groups = udf_compute_nr_groups(sb, partition);
>  	block = first_block + (sizeof(struct spaceBitmapDesc) << 3);
>  	block_group = block >> (sb->s_blocksize_bits + 3);
>  	group_start = block_group ? 0 : sizeof(struct spaceBitmapDesc);
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 2344157..187aff9 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -937,18 +937,22 @@ static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
>  		  root->logicalBlockNum, root->partitionReferenceNum);
>  }
>  
> +int udf_compute_nr_groups(struct super_block *sb, u32 partition)
> +{
> +	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
> +	return (map->s_partition_len +
> +		(sizeof(struct spaceBitmapDesc) << 3) +
> +		(sb->s_blocksize * 8) - 1) /
> +		(sb->s_blocksize * 8);
> +}
> +
>  static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
>  {
> -	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
>  	struct udf_bitmap *bitmap;
>  	int nr_groups;
>  	int size;
>  
> -	/* TODO: move calculating of nr_groups into helper function */
> -	nr_groups = (map->s_partition_len +
> -			(sizeof(struct spaceBitmapDesc) << 3) +
> -			(sb->s_blocksize * 8) - 1) /
> -			(sb->s_blocksize * 8);
> +	nr_groups = udf_compute_nr_groups(sb, index);
>  	size = sizeof(struct udf_bitmap) +
>  		(sizeof(struct buffer_head *) * nr_groups);
>  
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index 2c05f82..d9adb0f 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -43,6 +43,8 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
>  
>  struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
>  
> +int udf_compute_nr_groups(struct super_block *sb, u32 partition);
> +
>  #define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
>  #define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
>  #define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
> -- 
> 1.5.3.7
> 

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
