Return-Path: <linux-kernel-owner+w=401wt.eu-S1750951AbXCECNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750951AbXCECNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 21:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbXCECNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 21:13:51 -0500
Received: from mail.clusterfs.com ([206.168.112.78]:33609 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbXCECNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 21:13:50 -0500
Date: Mon, 5 Mar 2007 10:13:44 +0800
From: Andreas Dilger <adilger@clusterfs.com>
To: Dmitriy Monakhov <dmonakhov@sw.ru>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext3: dirindex error pointer issues
Message-ID: <20070305021344.GO6662@schatzie.adilger.int>
Mail-Followup-To: Dmitriy Monakhov <dmonakhov@sw.ru>,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
References: <87lkidf5y0.fsf@sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lkidf5y0.fsf@sw.ru>
User-Agent: Mutt/1.4.1i
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 04, 2007  17:18 +0300, Dmitriy Monakhov wrote:
>  - ext3_dx_find_entry() exit with out setting proper error pointer
>  - do_split() exit with out setting proper error pointer
>    it is realy painful because many callers contain folowing code:
>            de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
>            if (!(de))
>                         return retval;
>            <<< WOW retval wasn't changed by do_split(), so caller failed
>            <<< but return SUCCESS :)
>  - Rearrange do_split() error path. Current error path is realy ugly, all
>    this up and down jump stuff doesn't make code easy to understand.
> 
> Signed-off-by: Monakhov Dmitriy <dmonakhov@openvz.org>
> ---
>  fs/ext3/namei.c |   26 +++++++++++++++-----------
>  fs/ext4/namei.c |   26 +++++++++++++++-----------
>  2 files changed, 30 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
> index 49159f1..1a52586 100644
> --- a/fs/ext3/namei.c
> +++ b/fs/ext3/namei.c
> @@ -969,6 +969,7 @@ static struct buffer_head * ext3_dx_find_entry(struct dentry *dentry,
>  				  (block<<EXT3_BLOCK_SIZE_BITS(sb))
>  					  +((char *)de - bh->b_data))) {
>  				brelse (bh);
> +				*err = ERR_BAD_DX_DIR;
>  				goto errout;
>  			}
>  			*res_dir = de;

I have no objection to this change (by principle of least surprise) but
I don't know if it fixes a real problem.  The one caller of this function
treats ERR_BAD_DX_DIR the same as bh == NULL.

> @@ -1134,9 +1135,9 @@ static struct ext3_dir_entry_2 *do_split(handle_t *handle, struct inode *dir,
>  	char *data1 = (*bh)->b_data, *data2;
>  	unsigned split;
>  	struct ext3_dir_entry_2 *de = NULL, *de2;
> -	int	err;
> +	int	err = 0;
>  
> -	bh2 = ext3_append (handle, dir, &newblock, error);
> +	bh2 = ext3_append (handle, dir, &newblock, &err);

Why don't we just remove "err" entirely and use *error to avoid any risk
of setting err and not returning it in error?  Also reduces stack usage
that tiny little bit.


In ext3_dx_add_entry() it appears like we should "goto journal_error"
to report an error after the failed call to do_split(), instead of just
"goto cleanup" so that we report an error in the filesystem.  Not 100%
sure of this.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

