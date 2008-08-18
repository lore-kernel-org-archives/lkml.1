Return-Path: <linux-kernel-owner+w=401wt.eu-S1754098AbYHRMsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbYHRMsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 08:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753704AbYHRMsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 08:48:03 -0400
Received: from styx.suse.cz ([82.119.242.94]:50409 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753714AbYHRMsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 08:48:01 -0400
Date: Mon, 18 Aug 2008 14:47:59 +0200
From: Jan Kara <jack@suse.cz>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH REVIEW] udf: Fix lock inversion between iprune_mutex
	and alloc_mutex
Message-ID: <20080818124758.GA11523@duck.suse.cz>
References: <12187361983539-git-send-email-jack@suse.cz> <200808142048.10966.ioe-lkml@rameria.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808142048.10966.ioe-lkml@rameria.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-08-08 20:48:10, Ingo Oeser wrote:
> Hi Jan,
> 
> On Thursday 14 August 2008, Jan Kara wrote:
> > A memory allocation inside alloc_mutex must not recurse back
> > into the filesystem itself because that leads to lock inversion
> > between iprune_mutex and alloc_mutex (and thus to deadlocks - see
> > traces below). Make allocations inside alloc_mutex use GFP_NOFS
> > to avoid this problem.
> 
> What about moving the allocation before taking the mutex?
> That way, we even reduce the lock contention and simplify the failure path.
  Thanks for the idea and the review. Actually, I've checked and
i_alloc_mutex is needed only to update allocation statistics in the
superblock. So we can release i_alloc_mutex earlier before allocating
memory. Actually, I ended up moving the memory allocation as well - even
before the block allocation - to fix the error path cleanup. I'll post
resulting two patches in a moment.

									Honza

> Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>
> 
> diff --git a/fs/udf/ialloc.c b/fs/udf/ialloc.c
> index eb9cfa2..76446eb 100644
> --- a/fs/udf/ialloc.c
> +++ b/fs/udf/ialloc.c
> @@ -90,6 +90,25 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
>  		return NULL;
>  	}
>  
> +	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
> +		iinfo->i_efe = 1;
> +		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
> +			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
> +		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
> +					    sizeof(struct extendedFileEntry),
> +					    GFP_KERNEL);
> +	} else {
> +		iinfo->i_efe = 0;
> +		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
> +					    sizeof(struct fileEntry),
> +					    GFP_KERNEL);
> +	}
> +	if (!iinfo->i_ext.i_data) {
> +		iput(inode);
> +		*err = -ENOMEM;
> +		return NULL;
> +	}
> +
>  	mutex_lock(&sbi->s_alloc_mutex);
>  	if (sbi->s_lvid_bh) {
>  		struct logicalVolIntegrityDesc *lvid =
> @@ -129,25 +148,6 @@ struct inode *udf_new_inode(struct inode *dir, int mode, int *err)
>  	iinfo->i_lenEAttr = 0;
>  	iinfo->i_lenAlloc = 0;
>  	iinfo->i_use = 0;
> -	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_EXTENDED_FE)) {
> -		iinfo->i_efe = 1;
> -		if (UDF_VERS_USE_EXTENDED_FE > sbi->s_udfrev)
> -			sbi->s_udfrev = UDF_VERS_USE_EXTENDED_FE;
> -		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
> -					    sizeof(struct extendedFileEntry),
> -					    GFP_KERNEL);
> -	} else {
> -		iinfo->i_efe = 0;
> -		iinfo->i_ext.i_data = kzalloc(inode->i_sb->s_blocksize -
> -					    sizeof(struct fileEntry),
> -					    GFP_KERNEL);
> -	}
> -	if (!iinfo->i_ext.i_data) {
> -		iput(inode);
> -		*err = -ENOMEM;
> -		mutex_unlock(&sbi->s_alloc_mutex);
> -		return NULL;
> -	}
>  	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
>  		iinfo->i_alloc_type = ICBTAG_FLAG_AD_IN_ICB;
>  	else if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_SHORT_AD))
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
