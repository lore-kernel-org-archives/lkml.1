Return-Path: <linux-kernel-owner+w=401wt.eu-S934500AbYAaRJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934500AbYAaRJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934297AbYAaRJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:09:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:50202 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934230AbYAaRI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:08:59 -0500
Date: Thu, 31 Jan 2008 18:08:58 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/10] udf: truncate: create function for updating of
	Allocation Ext Descriptor
Message-ID: <20080131170858.GK1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-7-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-7-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:56, marcin.slusarz@gmail.com wrote:
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  There are at least a few other places in inode.c which do exactly what
you do in udf_update_alloc_ext_desc() so these should be converted as well.
Moreover I think that we could move all the work with allocation extent
descriptors into some helper functions but I have to think a bit (and also
read the standard) how to do that best.

								Honza

> ---
>  fs/udf/truncate.c |   56 +++++++++++++++++++++-------------------------------
>  1 files changed, 23 insertions(+), 33 deletions(-)
> 
> diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
> index f64f827..eb98616 100644
> --- a/fs/udf/truncate.c
> +++ b/fs/udf/truncate.c
> @@ -180,6 +180,24 @@ void udf_discard_prealloc(struct inode *inode)
>  	brelse(epos.bh);
>  }
>  
> +static void udf_update_alloc_ext_desc(struct inode *inode,
> +				      struct extent_position *epos,
> +				      u32 lenalloc)
> +{
> +	struct super_block *sb = inode->i_sb;
> +	struct udf_sb_info *sbi = UDF_SB(sb);
> +
> +	struct allocExtDesc *aed = (struct allocExtDesc *) (epos->bh->b_data);
> +	int len = sizeof(struct allocExtDesc);
> +
> +	aed->lengthAllocDescs =	cpu_to_le32(lenalloc);
> +	if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) || sbi->s_udfrev >= 0x0201)
> +		len += lenalloc;
> +
> +	udf_update_tag(epos->bh->b_data, len);
> +	mark_buffer_dirty_inode(epos->bh, inode);
> +}
> +
>  void udf_truncate_extents(struct inode *inode)
>  {
>  	struct extent_position epos;
> @@ -187,7 +205,6 @@ void udf_truncate_extents(struct inode *inode)
>  	uint32_t elen, nelen = 0, indirect_ext_len = 0, lenalloc;
>  	int8_t etype;
>  	struct super_block *sb = inode->i_sb;
> -	struct udf_sb_info *sbi = UDF_SB(sb);
>  	sector_t first_block = inode->i_size >> sb->s_blocksize_bits, offset;
>  	loff_t byte_offset;
>  	int adsize;
> @@ -230,24 +247,9 @@ void udf_truncate_extents(struct inode *inode)
>  				} else if (!epos.bh) {
>  					iinfo->i_lenAlloc = lenalloc;
>  					mark_inode_dirty(inode);
> -				} else {
> -					struct allocExtDesc *aed =
> -						(struct allocExtDesc *)
> -						(epos.bh->b_data);
> -					int len = sizeof(struct allocExtDesc);
> -
> -					aed->lengthAllocDescs =
> -						cpu_to_le32(lenalloc);
> -					if (!UDF_QUERY_FLAG(sb,
> -						UDF_FLAG_STRICT) ||
> -						sbi->s_udfrev >= 0x0201)
> -						len += lenalloc;
> -
> -					udf_update_tag(epos.bh->b_data,
> -							len);
> -					mark_buffer_dirty_inode(
> -							epos.bh, inode);
> -				}
> +				} else
> +					udf_update_alloc_ext_desc(inode,
> +							&epos, lenalloc);
>  				brelse(epos.bh);
>  				epos.offset = sizeof(struct allocExtDesc);
>  				epos.block = eloc;
> @@ -273,20 +275,8 @@ void udf_truncate_extents(struct inode *inode)
>  		} else if (!epos.bh) {
>  			iinfo->i_lenAlloc = lenalloc;
>  			mark_inode_dirty(inode);
> -		} else {
> -			struct allocExtDesc *aed =
> -				(struct allocExtDesc *)(epos.bh->b_data);
> -			aed->lengthAllocDescs = cpu_to_le32(lenalloc);
> -			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
> -				sbi->s_udfrev >= 0x0201)
> -				udf_update_tag(epos.bh->b_data,
> -					lenalloc +
> -					sizeof(struct allocExtDesc));
> -			else
> -				udf_update_tag(epos.bh->b_data,
> -					sizeof(struct allocExtDesc));
> -			mark_buffer_dirty_inode(epos.bh, inode);
> -		}
> +		} else
> +			udf_update_alloc_ext_desc(inode, &epos, lenalloc);
>  	} else if (inode->i_size) {
>  		if (byte_offset) {
>  			kernel_long_ad extent;
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
