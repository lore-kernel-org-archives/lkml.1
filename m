Return-Path: <linux-kernel-owner+w=401wt.eu-S934138AbYAaQs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138AbYAaQs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760898AbYAaQsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:48:18 -0500
Received: from styx.suse.cz ([82.119.242.94]:40527 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761208AbYAaQsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:48:17 -0500
Date: Thu, 31 Jan 2008 17:48:16 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/10] udf: replace udf_*_offset macros with functions
Message-ID: <20080131164816.GI1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-10-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-10-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:59, marcin.slusarz@gmail.com wrote:
> - translate udf_file_entry_alloc_offset macro into function
> - translate udf_ext0_offset macro into function
> - add comment about crypticly named fields in struct udf_inode_info
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/udf/udfdecl.h         |   29 +++++++++++++++++++----------
>  include/linux/udf_fs_i.h |    4 ++--
>  2 files changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index c6c457b..375be1b 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -12,6 +12,7 @@
>  #include <linux/buffer_head.h>
>  
>  #include "udfend.h"
> +#include "udf_i.h"
>  
>  #define udf_fixed_to_variable(x) ( ( ( (x) >> 5 ) * 39 ) + ( (x) & 0x0000001F ) )
>  #define udf_variable_to_fixed(x) ( ( ( (x) / 39 ) << 5 ) + ( (x) % 39 ) )
> @@ -23,16 +24,24 @@
>  #define UDF_NAME_LEN		256
>  #define UDF_PATH_LEN		1023
>  
> -#define udf_file_entry_alloc_offset(inode)\
> -	(UDF_I(inode)->i_use ?\
> -		sizeof(struct unallocSpaceEntry) :\
> -		((UDF_I(inode)->i_efe ?\
> -			sizeof(struct extendedFileEntry) :\
> -			sizeof(struct fileEntry)) + UDF_I(inode)->i_lenEAttr))
> -
> -#define udf_ext0_offset(inode)\
> -	(UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB ?\
> -		udf_file_entry_alloc_offset(inode) : 0)
> +static inline size_t udf_file_entry_alloc_offset(struct inode *inode)
> +{
> +	struct udf_inode_info *iinfo = UDF_I(inode);
> +	if (iinfo->i_use)
> +		return sizeof(struct unallocSpaceEntry);
> +	else if (iinfo->i_efe)
> +		return sizeof(struct extendedFileEntry) + iinfo->i_lenEAttr;
> +	else
> +		return sizeof(struct fileEntry) + iinfo->i_lenEAttr;
> +}
> +
> +static inline size_t udf_ext0_offset(struct inode *inode)
> +{
> +	if (UDF_I(inode)->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB)
> +		return udf_file_entry_alloc_offset(inode);
> +	else
> +		return 0;
> +}
>  
>  #define udf_get_lb_pblock(sb,loc,offset) udf_get_pblock((sb), (loc).logicalBlockNum, (loc).partitionReferenceNum, (offset))
>  
> diff --git a/include/linux/udf_fs_i.h b/include/linux/udf_fs_i.h
> index ffaf056..6281a52 100644
> --- a/include/linux/udf_fs_i.h
> +++ b/include/linux/udf_fs_i.h
> @@ -27,8 +27,8 @@ struct udf_inode_info
>  	__u32			i_next_alloc_block;
>  	__u32			i_next_alloc_goal;
>  	unsigned		i_alloc_type : 3;
> -	unsigned		i_efe : 1;
> -	unsigned		i_use : 1;
> +	unsigned		i_efe : 1; /* extendedFileEntry */
> +	unsigned		i_use : 1; /* unallocSpaceEntry */
>  	unsigned		i_strat4096 : 1;
>  	unsigned		reserved : 26;
>  	union
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
