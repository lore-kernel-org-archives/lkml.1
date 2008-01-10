Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYAJXOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYAJXOR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:14:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752463AbYAJXOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:14:04 -0500
Received: from styx.suse.cz ([82.119.242.94]:36132 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752438AbYAJXOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:14:02 -0500
Date: Fri, 11 Jan 2008 00:14:00 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/16] udf: convert macros related to bitmaps to
	functions
Message-ID: <20080110231400.GC17430@duck.suse.cz>
References: <1200002792-8449-1-git-send-email-marcin.slusarz@gmail.com> <1200002792-8449-6-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200002792-8449-6-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 10-01-08 23:06:21, marcin.slusarz@gmail.com wrote:
> convert UDF_SB_ALLOC_BITMAP macro to udf_sb_alloc_bitmap function
> convert UDF_SB_FREE_BITMAP macro to udf_sb_free_bitmap function
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
> CC: Christoph Hellwig <hch@infradead.org>
  Acked-by: Jan Kara <jack@suse.cz>

> ---
>  fs/udf/super.c  |   61 +++++++++++++++++++++++++++++++++++++++++++++++++-----
>  fs/udf/udf_sb.h |   38 ----------------------------------
>  2 files changed, 55 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 9257796..2344157 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -937,6 +937,39 @@ static void udf_load_fileset(struct super_block *sb, struct buffer_head *bh,
>  		  root->logicalBlockNum, root->partitionReferenceNum);
>  }
>  
> +static struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, u32 index)
> +{
> +	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[index];
> +	struct udf_bitmap *bitmap;
> +	int nr_groups;
> +	int size;
> +
> +	/* TODO: move calculating of nr_groups into helper function */
> +	nr_groups = (map->s_partition_len +
> +			(sizeof(struct spaceBitmapDesc) << 3) +
> +			(sb->s_blocksize * 8) - 1) /
> +			(sb->s_blocksize * 8);
> +	size = sizeof(struct udf_bitmap) +
> +		(sizeof(struct buffer_head *) * nr_groups);
> +
> +	if (size <= PAGE_SIZE)
> +		bitmap = kmalloc(size, GFP_KERNEL);
> +	else
> +		bitmap = vmalloc(size); /* TODO: get rid of vmalloc */
> +
> +	if (bitmap == NULL) {
> +		udf_error(sb, __FUNCTION__,
> +			  "Unable to allocate space for bitmap "
> +			  "and %d buffer_head pointers", nr_groups);
> +		return NULL;
> +	}
> +
> +	memset(bitmap, 0x00, size);
> +	bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
> +	bitmap->s_nr_groups = nr_groups;
> +	return bitmap;
> +}
> +
>  static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  {
>  	struct partitionDesc *p;
> @@ -987,7 +1020,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  						  i, map->s_uspace.s_table->i_ino);
>  				}
>  				if (phd->unallocSpaceBitmap.extLength) {
> -					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
> +					map->s_uspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
>  					if (map->s_uspace.s_bitmap != NULL) {
>  						map->s_uspace.s_bitmap->s_extLength =
>  							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
> @@ -1017,7 +1050,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  						  i, map->s_fspace.s_table->i_ino);
>  				}
>  				if (phd->freedSpaceBitmap.extLength) {
> -					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
> +					map->s_fspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
>  					if (map->s_fspace.s_bitmap != NULL) {
>  						map->s_fspace.s_bitmap->s_extLength =
>  							le32_to_cpu(phd->freedSpaceBitmap.extLength);
> @@ -1504,6 +1537,22 @@ static void udf_close_lvid(struct super_block *sb)
>  	}
>  }
>  
> +static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
> +{
> +	int i;
> +	int nr_groups = bitmap->s_nr_groups;
> +	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
> +
> +	for (i = 0; i < nr_groups; i++)
> +		if (bitmap->s_block_bitmap[i])
> +			brelse(bitmap->s_block_bitmap[i]);
> +
> +	if (size <= PAGE_SIZE)
> +		kfree(bitmap);
> +	else
> +		vfree(bitmap);
> +}
> +
>  /*
>   * udf_read_super
>   *
> @@ -1689,9 +1738,9 @@ error_out:
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
>  			iput(map->s_fspace.s_table);
>  		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
> +			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
> +			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
>  		if (map->s_partition_type == UDF_SPARABLE_MAP15)
>  			for (i = 0; i < 4; i++)
>  				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
> @@ -1767,9 +1816,9 @@ static void udf_put_super(struct super_block *sb)
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
>  			iput(map->s_fspace.s_table);
>  		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_uspace);
> +			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, sbi->s_partition, s_fspace);
> +			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
>  		if (map->s_partition_type == UDF_SPARABLE_MAP15)
>  			for (i = 0; i < 4; i++)
>  				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index 4d3bd77..2c05f82 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -43,46 +43,8 @@ static inline struct udf_sb_info *UDF_SB(struct super_block *sb)
>  
>  struct logicalVolIntegrityDescImpUse *udf_sb_lvidiu(struct udf_sb_info *sbi);
>  
> -#define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
> -{\
> -	struct udf_sb_info *sbi = UDF_SB(X);\
> -	int nr_groups = ((sbi->s_partmaps[(Y)].s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
> -		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
> -	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
> -	if (size <= PAGE_SIZE)\
> -		sbi->s_partmaps[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
> -	else\
> -		sbi->s_partmaps[(Y)].Z.s_bitmap = vmalloc(size);\
> -	if (sbi->s_partmaps[(Y)].Z.s_bitmap != NULL) {\
> -		memset(sbi->s_partmaps[(Y)].Z.s_bitmap, 0x00, size);\
> -		sbi->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap =\
> -			(struct buffer_head **)(sbi->s_partmaps[(Y)].Z.s_bitmap + 1);\
> -		sbi->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
> -	} else {\
> -		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
> -	}\
> -}
> -
> -#define UDF_SB_FREE_BITMAP(X,Y,Z)\
> -{\
> -	int i;\
> -	int nr_groups = UDF_SB_BITMAP_NR_GROUPS(X,Y,Z);\
> -	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
> -	for (i = 0; i < nr_groups; i++) {\
> -		if (UDF_SB_BITMAP(X,Y,Z,i))\
> -			brelse(UDF_SB_BITMAP(X,Y,Z,i));\
> -	}\
> -	if (size <= PAGE_SIZE)\
> -		kfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
> -	else\
> -		vfree(UDF_SB(X)->s_partmaps[Y].Z.s_bitmap);\
> -}
> -
>  #define UDF_QUERY_FLAG(X,Y)			( UDF_SB(X)->s_flags & ( 1 << (Y) ) )
>  #define UDF_SET_FLAG(X,Y)			( UDF_SB(X)->s_flags |= ( 1 << (Y) ) )
>  #define UDF_CLEAR_FLAG(X,Y)			( UDF_SB(X)->s_flags &= ~( 1 << (Y) ) )
>  
> -#define UDF_SB_BITMAP(X,Y,Z,I)			( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_block_bitmap[I] )
> -#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( UDF_SB(X)->s_partmaps[(Y)].Z.s_bitmap->s_nr_groups )
> -
>  #endif /* __LINUX_UDF_SB_H */
> -- 
> 1.5.3.7

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
