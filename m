Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYAGLfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYAGLfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801AbYAGLf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:35:27 -0500
Received: from styx.suse.cz ([82.119.242.94]:48562 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754707AbYAGLfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:35:25 -0500
Date: Mon, 7 Jan 2008 12:35:24 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 22/24] udf: convert UDF_SB_ALLOC_BITMAP macro to
	udf_sb_alloc_bitmap function
Message-ID: <20080107113524.GE12589@duck.suse.cz>
References: <1198374674-12128-1-git-send-email-marcin.slusarz@gmail.com> <1198374674-12128-23-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1198374674-12128-23-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 23-12-07 02:51:12, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> CC: Jan Kara <jack@suse.cz>
  Looks much better :). Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/udf/super.c  |    4 ++--
>  fs/udf/udf_sb.h |   37 ++++++++++++++++++++-----------------
>  2 files changed, 22 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 33ccf66..1afea58 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -949,7 +949,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  						  i, map->s_uspace.s_table->i_ino);
>  				}
>  				if (phd->unallocSpaceBitmap.extLength) {
> -					UDF_SB_ALLOC_BITMAP(sb, i, s_uspace);
> +					map->s_uspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
>  					if (map->s_uspace.s_bitmap != NULL) {
>  						map->s_uspace.s_bitmap->s_extLength =
>  							le32_to_cpu(phd->unallocSpaceBitmap.extLength);
> @@ -979,7 +979,7 @@ static int udf_load_partdesc(struct super_block *sb, struct buffer_head *bh)
>  						  i, map->s_fspace.s_table->i_ino);
>  				}
>  				if (phd->freedSpaceBitmap.extLength) {
> -					UDF_SB_ALLOC_BITMAP(sb, i, s_fspace);
> +					map->s_fspace.s_bitmap = udf_sb_alloc_bitmap(sb, i);
>  					if (map->s_fspace.s_bitmap != NULL) {
>  						map->s_fspace.s_bitmap->s_extLength =
>  							le32_to_cpu(phd->freedSpaceBitmap.extLength);
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index a5805c5..4cf91f2 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -2,6 +2,7 @@
>  #define __LINUX_UDF_SB_H
>  
>  #include <linux/errno.h>
> +#include <linux/vmalloc.h>
>  
>  /* Since UDF 2.01 is ISO 13346 based... */
>  #define UDF_SUPER_MAGIC			0x15013346
> @@ -149,23 +150,25 @@ static inline void udf_update_revision(struct super_block *sb, __u16 revision)
>  		udf_sb(sb)->s_udfrev = revision;
>  }
>  
> -#define UDF_SB_ALLOC_BITMAP(X,Y,Z)\
> -{\
> -	int nr_groups = ((udf_sb_partmap((X),(Y))->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +\
> -		((X)->s_blocksize * 8) - 1) / ((X)->s_blocksize * 8));\
> -	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);\
> -	if (size <= PAGE_SIZE)\
> -		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = kmalloc(size, GFP_KERNEL);\
> -	else\
> -		udf_sb_partmaps(X)[(Y)].Z.s_bitmap = vmalloc(size);\
> -	if (udf_sb_partmaps(X)[(Y)].Z.s_bitmap != NULL) {\
> -		memset(udf_sb_partmaps(X)[(Y)].Z.s_bitmap, 0x00, size);\
> -		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_block_bitmap =\
> -			(struct buffer_head **)(udf_sb_partmaps(X)[(Y)].Z.s_bitmap + 1);\
> -		udf_sb_partmaps(X)[(Y)].Z.s_bitmap->s_nr_groups = nr_groups;\
> -	} else {\
> -		udf_error(X, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);\
> -	}\
> +static inline struct udf_bitmap *udf_sb_alloc_bitmap(struct super_block *sb, __u32 index)
> +{
> +	struct udf_part_map *map = udf_sb_partmap(sb, index);
> +	int nr_groups = (map->s_partition_len + (sizeof(struct spaceBitmapDesc) << 3) +
> +		(sb->s_blocksize * 8) - 1) / (sb->s_blocksize * 8);
> +	int size = sizeof(struct udf_bitmap) + (sizeof(struct buffer_head *) * nr_groups);
> +	struct udf_bitmap *bitmap;
> +
> +	if (size <= PAGE_SIZE)
> +		bitmap = kmalloc(size, GFP_KERNEL);
> +	else
> +		bitmap = vmalloc(size);
> +	if (bitmap != NULL) {
> +		memset(bitmap, 0x00, size);
> +		bitmap->s_block_bitmap = (struct buffer_head **)(bitmap + 1);
> +		bitmap->s_nr_groups = nr_groups;
> +	} else
> +		udf_error(sb, __FUNCTION__, "Unable to allocate space for bitmap and %d buffer_head pointers", nr_groups);
> +	return bitmap;
>  }
>  
>  #define UDF_SB_FREE_BITMAP(X,Y,Z)\
> -- 
> 1.5.3.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
