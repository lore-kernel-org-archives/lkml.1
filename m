Return-Path: <linux-kernel-owner+w=401wt.eu-S933948AbYAaNBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948AbYAaNBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 08:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765924AbYAaNBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 08:01:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:36126 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765699AbYAaNBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 08:01:14 -0500
Date: Thu, 31 Jan 2008 14:01:10 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/10] udf: simple cleanup of truncate.c
Message-ID: <20080131130110.GE1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-6-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-6-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:55, marcin.slusarz@gmail.com wrote:
> - remove one indentation level by little code reorganization
> - convert "if (smth) BUG();" to "BUG_ON(smth);"
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/udf/truncate.c |   76 +++++++++++++++++++++++-----------------------------
>  1 files changed, 34 insertions(+), 42 deletions(-)
> 
> diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
> index fe61be1..f64f827 100644
> --- a/fs/udf/truncate.c
> +++ b/fs/udf/truncate.c
> @@ -224,34 +224,29 @@ void udf_truncate_extents(struct inode *inode)
>  				if (indirect_ext_len) {
>  					/* We managed to free all extents in the
>  					 * indirect extent - free it too */
> -					if (!epos.bh)
> -						BUG();
> +					BUG_ON(!epos.bh);
>  					udf_free_blocks(sb, inode, epos.block,
>  							0, indirect_ext_len);
> +				} else if (!epos.bh) {
> +					iinfo->i_lenAlloc = lenalloc;
> +					mark_inode_dirty(inode);
>  				} else {
> -					if (!epos.bh) {
> -						iinfo->i_lenAlloc =
> -								lenalloc;
> -						mark_inode_dirty(inode);
> -					} else {
> -						struct allocExtDesc *aed =
> -							(struct allocExtDesc *)
> -							(epos.bh->b_data);
> -						int len =
> -						    sizeof(struct allocExtDesc);
> +					struct allocExtDesc *aed =
> +						(struct allocExtDesc *)
> +						(epos.bh->b_data);
> +					int len = sizeof(struct allocExtDesc);
>  
> -						aed->lengthAllocDescs =
> -						    cpu_to_le32(lenalloc);
> -						if (!UDF_QUERY_FLAG(sb,
> -							UDF_FLAG_STRICT) ||
> -						    sbi->s_udfrev >= 0x0201)
> -							len += lenalloc;
> +					aed->lengthAllocDescs =
> +						cpu_to_le32(lenalloc);
> +					if (!UDF_QUERY_FLAG(sb,
> +						UDF_FLAG_STRICT) ||
> +						sbi->s_udfrev >= 0x0201)
> +						len += lenalloc;
>  
> -						udf_update_tag(epos.bh->b_data,
> -								len);
> -						mark_buffer_dirty_inode(
> -								epos.bh, inode);
> -					}
> +					udf_update_tag(epos.bh->b_data,
> +							len);
> +					mark_buffer_dirty_inode(
> +							epos.bh, inode);
>  				}
>  				brelse(epos.bh);
>  				epos.offset = sizeof(struct allocExtDesc);
> @@ -272,28 +267,25 @@ void udf_truncate_extents(struct inode *inode)
>  		}
>  
>  		if (indirect_ext_len) {
> -			if (!epos.bh)
> -				BUG();
> +			BUG_ON(!epos.bh);
>  			udf_free_blocks(sb, inode, epos.block, 0,
>  					indirect_ext_len);
> +		} else if (!epos.bh) {
> +			iinfo->i_lenAlloc = lenalloc;
> +			mark_inode_dirty(inode);
>  		} else {
> -			if (!epos.bh) {
> -				iinfo->i_lenAlloc = lenalloc;
> -				mark_inode_dirty(inode);
> -			} else {
> -				struct allocExtDesc *aed =
> -				    (struct allocExtDesc *)(epos.bh->b_data);
> -				aed->lengthAllocDescs = cpu_to_le32(lenalloc);
> -				if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
> -				    sbi->s_udfrev >= 0x0201)
> -					udf_update_tag(epos.bh->b_data,
> -						lenalloc +
> -						sizeof(struct allocExtDesc));
> -				else
> -					udf_update_tag(epos.bh->b_data,
> -						sizeof(struct allocExtDesc));
> -				mark_buffer_dirty_inode(epos.bh, inode);
> -			}
> +			struct allocExtDesc *aed =
> +				(struct allocExtDesc *)(epos.bh->b_data);
> +			aed->lengthAllocDescs = cpu_to_le32(lenalloc);
> +			if (!UDF_QUERY_FLAG(sb, UDF_FLAG_STRICT) ||
> +				sbi->s_udfrev >= 0x0201)
> +				udf_update_tag(epos.bh->b_data,
> +					lenalloc +
> +					sizeof(struct allocExtDesc));
> +			else
> +				udf_update_tag(epos.bh->b_data,
> +					sizeof(struct allocExtDesc));
> +			mark_buffer_dirty_inode(epos.bh, inode);
>  		}
>  	} else if (inode->i_size) {
>  		if (byte_offset) {
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
