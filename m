Return-Path: <linux-kernel-owner+w=401wt.eu-S1756970AbYAGLgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756970AbYAGLgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbYAGLg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:36:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:48578 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754834AbYAGLg0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:36:26 -0500
Date: Mon, 7 Jan 2008 12:36:24 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 23/24] udf: convert UDF_SB_FREE_BITMAP macro to
	udf_sb_free_bitmap function
Message-ID: <20080107113624.GF12589@duck.suse.cz>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-24-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-24-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-12-07 02:51:13, marcin.slusarz@gmail.com wrote:
> additionally fix sparse warnings:
> fs/udf/super.c:1636:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1469:6: originally declared here
> fs/udf/super.c:1638:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1469:6: originally declared here
> fs/udf/super.c:1712:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1701:6: originally declared here
> fs/udf/super.c:1714:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1701:6: originally declared here
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
  Looks fine. Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/super.c  |    8 ++++----
>  fs/udf/udf_sb.h |   31 ++++++++++++++-----------------
>  2 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 1afea58..f6c911b 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -1634,9 +1634,9 @@ error_out:
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
>  			iput(map->s_fspace.s_table);
>  		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
> +			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
> +			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
>  		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
>  			for (i = 0; i < 4; i++)
>  				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
> @@ -1710,9 +1710,9 @@ static void udf_put_super(struct super_block *sb)
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_TABLE)
>  			iput(map->s_fspace.s_table);
>  		if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_uspace);
> +			udf_sb_free_bitmap(map->s_uspace.s_bitmap);
>  		if (map->s_partition_flags & UDF_PART_FLAG_FREED_BITMAP)
> -			UDF_SB_FREE_BITMAP(sb, udf_sb_partition(sb), s_fspace);
> +			udf_sb_free_bitmap(map->s_fspace.s_bitmap);
>  		if (map->s_partition_type == UDF_SPARABLE_MAP15) {
>  			for (i = 0; i < 4; i++)
>  				brelse(map->s_type_specific.s_sparing.s_spar_map[i]);
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index 4cf91f2..8fc2be9 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -171,27 +171,24 @@ static inline struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u
>  	return bitmap;
>  }
>  
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
> -		kfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
> -	else\
> -		vfree(udf_sb_partmaps(X)[Y].Z.s_bitmap);\
> +static inline void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
> +{
> +	int i;
> +	int nr_groups = bitmap->s_nr_groups;
> +	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
> +
> +	for (i = 0; i < nr_groups; i++) {
> +		if (bitmap->s_block_bitmap[i])
> +			brelse(bitmap->s_block_bitmap[i]);
> +	}
> +	if (size <= PAGE_SIZE)
> +		kfree(bitmap);
> +	else
> +		vfree(bitmap);
>  }
>  
>  #define UDF_QUERY_FLAG(X,Y)			( udf_sb(X)->s_flags & ( 1 << (Y) ) )
>  #define UDF_SET_FLAG(X,Y)			( udf_sb(X)->s_flags |= ( 1 << (Y) ) )
>  #define UDF_CLEAR_FLAG(X,Y)			( udf_sb(X)->s_flags &= ~( 1 << (Y) ) )
>  
> -#define UDF_SB_BITMAP(X,Y,Z,I)			( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap[I] )
> -#define UDF_SB_BITMAP_NR_GROUPS(X,Y,Z)		( udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups )
> -
> -
>  #endif /* __LINUX_UDF_SB_H */
> -- 
> 1.5.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
