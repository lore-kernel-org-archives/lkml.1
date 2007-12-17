Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXLQQFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXLQQFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758987AbXLQQFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:05:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54127 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759334AbXLQQFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:05:46 -0500
Date: Mon, 17 Dec 2007 17:05:40 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
       akpm@linux-foundation.org
Subject: Re: [PATCH 2/6] udf: improve readability of do_udf_readdir
Message-ID: <20071217160540.GE6979@atrey.karlin.mff.cuni.cz>
References: <20071216021103.GC26986@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071216021103.GC26986@joi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> make reading do_udf_readdir easier by adding new variable
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> CC: Ben Fennema <bfennema@falcon.csc.calpoly.edu>
> ---
>  fs/udf/dir.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/udf/dir.c b/fs/udf/dir.c
> index 174d2fc..c26e281 100644
> --- a/fs/udf/dir.c
> +++ b/fs/udf/dir.c
> @@ -57,6 +57,7 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  	int i, num;
>  	unsigned int dt_type;
>  	struct extent_position epos = { NULL, 0, {0, 0} };
> +	unsigned char bits;
> 
>  	if (nf_pos >= size)
>  		return 0;
> @@ -65,12 +66,14 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  		nf_pos = (udf_ext0_offset(dir) >> 2);
> 
>  	fibh.soffset = fibh.eoffset = (nf_pos & ((dir->i_sb->s_blocksize - 1) >> 2)) << 2;
> +	bits = dir->i_sb->s_blocksize_bits;
> +
>  	if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_IN_ICB) {
>  		fibh.sbh = fibh.ebh = NULL;
> -	} else if (inode_bmap(dir, nf_pos >> (dir->i_sb->s_blocksize_bits - 2),
> +	} else if (inode_bmap(dir, nf_pos >> (bits - 2),
>  			      &epos, &eloc, &elen, &offset) == (EXT_RECORDED_ALLOCATED >> 30)) {
>  		block = udf_get_lb_pblock(dir->i_sb, eloc, offset);
> -		if ((++offset << dir->i_sb->s_blocksize_bits) < elen) {
> +		if ((++offset << bits) < elen) {
>  			if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_SHORT)
>  				epos.offset -= sizeof(short_ad);
>  			else if (UDF_I_ALLOCTYPE(dir) == ICBTAG_FLAG_AD_LONG)
> @@ -84,10 +87,10 @@ static int do_udf_readdir(struct inode *dir, struct file *filp,
>  			return -EIO;
>  		}
> 
> -		if (!(offset & ((16 >> (dir->i_sb->s_blocksize_bits - 9)) - 1))) {
> -			i = 16 >> (dir->i_sb->s_blocksize_bits - 9);
> -			if (i + offset > (elen >> dir->i_sb->s_blocksize_bits))
> -				i = (elen >> dir->i_sb->s_blocksize_bits) - offset;
> +		if (!(offset & ((16 >> (bits - 9)) - 1))) {
> +			i = 16 >> (bits - 9);
> +			if (i + offset > (elen >> bits))
> +				i = (elen >> bits) - offset;
>  			for (num = 0; i > 0; i--) {
>  				block = udf_get_lb_pblock(dir->i_sb, eloc, offset + i);
>  				tmp = udf_tgetblk(dir->i_sb, block);
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
