Return-Path: <linux-kernel-owner+w=401wt.eu-S1762417AbXEVU3s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762417AbXEVU3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 16:29:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757616AbXEVU3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 16:29:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:54664 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687AbXEVU3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 16:29:39 -0400
Date: Tue, 22 May 2007 22:29:38 +0200
From: Jan Kara <jack@suse.cz>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] UDF: possible usage of uninitialized variables
Message-ID: <20070522202938.GA30666@atrey.karlin.mff.cuni.cz>
References: <20070522175223.GA8259@cvg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522175223.GA8259@cvg>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A few variables could be used without being explicitly initialized.
> Fixed.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> 
>  balloc.c |    6 +++++-
>  super.c  |    5 ++++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/balloc.c b/balloc.c
> index 4cec910..be37393 100644
> --- a/balloc.c
> +++ b/balloc.c
> @@ -744,7 +744,11 @@ static int udf_table_new_block(struct super_block * sb,
>  	uint32_t spread = 0xFFFFFFFF, nspread = 0xFFFFFFFF;
>  	uint32_t newblock = 0, adsize;
>  	uint32_t elen, goal_elen = 0;
> -	kernel_lb_addr eloc, goal_eloc;
> +	kernel_lb_addr eloc;
> +	kernel_lb_addr goal_eloc = {
> +		.logicalBlockNum = 0,
> +		.partitionReferenceNum = 0,
> +	};
>  	struct extent_position epos, goal_epos;
>  	int8_t etype;
  As I read the code, I don't think it can happen goal_eloc is used
unitialized. Also please diff the tree completely, not just the udf
directory..

> diff --git a/super.c b/super.c
> index 9b8644a..068a99c 100644
> --- a/super.c
> +++ b/super.c
> @@ -1358,7 +1358,10 @@ udf_load_partition(struct super_block *sb, kernel_lb_addr *fileset)
>  			case UDF_VIRTUAL_MAP15:
>  			case UDF_VIRTUAL_MAP20:
>  			{
> -				kernel_lb_addr ino;
> +				kernel_lb_addr ino = {
> +					.logicalBlockNum = 0,
> +					.partitionReferenceNum = 0,
> +				};
>  
>  				if (!UDF_SB_LASTBLOCK(sb))
>  				{
  This one seems correct. Thanks for fixing this.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
