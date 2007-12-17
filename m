Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbXLQQuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbXLQQuk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:50:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbXLQQuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:50:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:58342 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbXLQQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:50:19 -0500
Date: Mon, 17 Dec 2007 17:50:17 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH 6/6] udf: fix sparse warnings (shadowing & mismatch between declaration and definition)
Message-ID: <20071217165017.GJ6979@atrey.karlin.mff.cuni.cz>
References: <20071216021741.GG26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216021741.GG26986@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> fix warnings:
> fs/udf/super.c:1320:24: warning: symbol 'bh' shadows an earlier one
> fs/udf/super.c:1240:21: originally declared here
> fs/udf/super.c:1583:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1418:6: originally declared here
> fs/udf/super.c:1585:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1418:6: originally declared here
> fs/udf/super.c:1658:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1648:6: originally declared here
> fs/udf/super.c:1660:4: warning: symbol 'i' shadows an earlier one
> fs/udf/super.c:1648:6: originally declared here
> fs/udf/super.c:450:6: warning: symbol 'udf_write_super' was not declared. Should it be static?
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
  Thanks for the patch.  The 'bh' change is fine. The problems with 'i'
should be solved differently I think. Those functions UDF_SB_FREE,
UDF_SB_ALLOC_PARTMAPS should be functions and not macros. Please convert
those to either inline functions if they are small or to regular
functions if they are larger.  It won't be completely trivial because of
the hackery e.g. in UDF_SB_ALLOC_BITMAP. It gets an argument meaning on
which struct member something should be performed. But for example in
the UDF_SB_ALLOC_BITMAP case you can simply make the function return the
pointer to allocated and initialized space and the caller would assign
it to a proper element of the superblock. This would help the overall
code quality of UDF (which is sadly quite poor). Thanks.

								Honza
> ---
>  fs/udf/super.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index 4360c7a..9f82b5a 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -447,7 +447,7 @@ static int udf_parse_options(char *options, struct udf_options *uopt)
>  	return 1;
>  }
> 
> -void udf_write_super(struct super_block *sb)
> +static void udf_write_super(struct super_block *sb)
>  {
>  	lock_kernel();
> 
> @@ -1317,7 +1317,6 @@ static int udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  				UDF_SB_TYPEVIRT(sb, i).s_num_entries =
>  					(UDF_SB_VAT(sb)->i_size - 36) >> 2;
>  			} else if (UDF_SB_PARTTYPE(sb, i) == UDF_VIRTUAL_MAP20) {
> -				struct buffer_head *bh = NULL;
>  				uint32_t pos;
> 
>  				pos = udf_block_map(UDF_SB_VAT(sb), 0);
> @@ -1415,7 +1414,7 @@ static void udf_close_lvid(struct super_block *sb)
>   */
>  static int udf_fill_super(struct super_block *sb, void *options, int silent)
>  {
> -	int i;
> +	int idx;
>  	struct inode *inode = NULL;
>  	struct udf_options uopt;
>  	kernel_lb_addr rootdir, fileset;
> @@ -1584,8 +1583,8 @@ error_out:
>  		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
>  			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
>  		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
> -			for (i = 0; i < 4; i++)
> -				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
> +			for (idx = 0; idx < 4; idx++)
> +				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
>  		}
>  	}
>  #ifdef CONFIG_UDF_NLS
> @@ -1645,7 +1644,7 @@ void udf_warning(struct super_block *sb, const char *function,
>   */
>  static void udf_put_super(struct super_block *sb)
>  {
> -	int i;
> +	int idx;
> 
>  	if (UDF_SB_VAT(sb))
>  		iput(UDF_SB_VAT(sb));
> @@ -1659,8 +1658,8 @@ static void udf_put_super(struct super_block *sb)
>  		if (UDF_SB_PARTFLAGS(sb, UDF_SB_PARTITION(sb)) & UDF_PART_FLAG_FREED_BITMAP)
>  			UDF_SB_FREE_BITMAP(sb,UDF_SB_PARTITION(sb), s_fspace);
>  		if (UDF_SB_PARTTYPE(sb, UDF_SB_PARTITION(sb)) == UDF_SPARABLE_MAP15) {
> -			for (i = 0; i < 4; i++)
> -				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[i]);
> +			for (idx = 0; idx < 4; idx++)
> +				brelse(UDF_SB_TYPESPAR(sb, UDF_SB_PARTITION(sb)).s_spar_map[idx]);
>  		}
>  	}
>  #ifdef CONFIG_UDF_NLS
> --
> 1.5.3.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
