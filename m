Return-Path: <linux-kernel-owner+w=401wt.eu-S932668AbYAaQqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668AbYAaQqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:46:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbYAaQqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:46:39 -0500
Received: from styx.suse.cz ([82.119.242.94]:36501 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755510AbYAaQqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:46:39 -0500
Date: Thu, 31 Jan 2008 17:46:38 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] udf: simplify __udf_read_inode
Message-ID: <20080131164637.GH1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-9-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-9-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:58, marcin.slusarz@gmail.com wrote:
> - move all brelse(ibh) after main if, because it's called
>   on every path except one where ibh is null
> - move variables to the most inner blocks
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
  Acked-by: Jan Kara <jack@suse.cz>

									Honza

> ---
>  fs/udf/inode.c |   52 +++++++++++++++++++++++-----------------------------
>  1 files changed, 23 insertions(+), 29 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 68db2ea..c2d0477 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -1116,42 +1116,36 @@ static void __udf_read_inode(struct inode *inode)
>  	fe = (struct fileEntry *)bh->b_data;
>  
>  	if (fe->icbTag.strategyType == cpu_to_le16(4096)) {
> -		struct buffer_head *ibh = NULL, *nbh = NULL;
> -		struct indirectEntry *ie;
> +		struct buffer_head *ibh;
>  
>  		ibh = udf_read_ptagged(inode->i_sb, iinfo->i_location, 1,
>  					&ident);
> -		if (ident == TAG_IDENT_IE) {
> -			if (ibh) {
> -				kernel_lb_addr loc;
> -				ie = (struct indirectEntry *)ibh->b_data;
> -
> -				loc = lelb_to_cpu(ie->indirectICB.extLocation);
> -
> -				if (ie->indirectICB.extLength &&
> -				    (nbh = udf_read_ptagged(inode->i_sb, loc, 0,
> -							    &ident))) {
> -					if (ident == TAG_IDENT_FE ||
> -					    ident == TAG_IDENT_EFE) {
> -						memcpy(&iinfo->i_location,
> -						       &loc,
> -						       sizeof(kernel_lb_addr));
> -						brelse(bh);
> -						brelse(ibh);
> -						brelse(nbh);
> -						__udf_read_inode(inode);
> -						return;
> -					} else {
> -						brelse(nbh);
> -						brelse(ibh);
> -					}
> -				} else {
> +		if (ident == TAG_IDENT_IE && ibh) {
> +			struct buffer_head *nbh = NULL;
> +			kernel_lb_addr loc;
> +			struct indirectEntry *ie;
> +
> +			ie = (struct indirectEntry *)ibh->b_data;
> +			loc = lelb_to_cpu(ie->indirectICB.extLocation);
> +
> +			if (ie->indirectICB.extLength &&
> +				(nbh = udf_read_ptagged(inode->i_sb, loc, 0,
> +							&ident))) {
> +				if (ident == TAG_IDENT_FE ||
> +					ident == TAG_IDENT_EFE) {
> +					memcpy(&iinfo->i_location,
> +						&loc,
> +						sizeof(kernel_lb_addr));
> +					brelse(bh);
>  					brelse(ibh);
> +					brelse(nbh);
> +					__udf_read_inode(inode);
> +					return;
>  				}
> +				brelse(nbh);
>  			}
> -		} else {
> -			brelse(ibh);
>  		}
> +		brelse(ibh);
>  	} else if (fe->icbTag.strategyType != cpu_to_le16(4)) {
>  		printk(KERN_ERR "udf: unsupported strategy type: %d\n",
>  		       le16_to_cpu(fe->icbTag.strategyType));
> -- 
> 1.5.3.7
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
