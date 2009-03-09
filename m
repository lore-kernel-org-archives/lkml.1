Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbZCIJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbZCIJYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbZCIJYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 05:24:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56518 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035AbZCIJYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 05:24:09 -0400
Date: Mon, 9 Mar 2009 10:24:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, martin.petersen@oracle.com
Subject: Re: [PATCH] block: fix memory leak in bio_clone()
Message-ID: <20090309092407.GI11787@kernel.dk>
References: <49B4DD9C.5030902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B4DD9C.5030902@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09 2009, Li Zefan wrote:
> If bio_integrity_clone() fails, bio_clone() returns NULL without freeing
> the newly allocated bio.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  fs/bio.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/bio.c b/fs/bio.c
> index 124b95c..896330e 100644
> --- a/fs/bio.c
> +++ b/fs/bio.c
> @@ -465,8 +465,10 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
>  
>  		ret = bio_integrity_clone(b, bio, fs_bio_set);
>  
> -		if (ret < 0)
> +		if (ret < 0) {
> +			bio_put(bio);
>  			return NULL;
> +		}
>  	}
>  
>  	return b;
> -- 1.5.4.rc3 

Good spotting. But it looks like there are actually several problems
there. bio_integrity_clone() is mempool backed. Currently that ret < 0
can never trigger, since bio_integrity_clone() has hard-wired __GFP_WAIT
as the mempool mask. So the leak will not occur, but it does mean that
it isn't honoring the gfp_mask passed in to bio_clone(), which is the
first bug. The second bug is that it should be using its own bioset, as
it is illegal to do multiple __GFP_WAIT allocations on a single mempool
and always expect progress.

-- 
Jens Axboe

