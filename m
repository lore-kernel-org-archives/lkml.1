Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYIEPRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYIEPRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYIEPRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:17:13 -0400
Received: from [195.171.2.24] ([195.171.2.24]:51243 "EHLO fogou.chygwyn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753233AbYIEPRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:17:11 -0400
X-Greylist: delayed 3627 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 11:17:11 EDT
Date: Fri, 5 Sep 2008 15:13:52 +0100
From: steve@chygwyn.com
To: Julien Brunel <brunel@diku.dk>
Cc: swhiteho@redhat.com, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] fs/gfs2: Use an IS_ERR test rather than a NULL test
Message-ID: <20080905141352.GA20654@fogou.chygwyn.com>
References: <200809011051.22862.brunel@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809011051.22862.brunel@diku.dk>
Organization: ChyGwyn Limited
X-Registered-Office: Digital Technium, Singleton Park, Swansea. SA2 8PP
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for taking so long about this. Its now in the -nmw git tree.
Thanks,

Steve.

On Mon, Sep 01, 2008 at 10:51:22AM +0200, Julien Brunel wrote:
> From: Julien Brunel <brunel@diku.dk>
> 
> In case of error, the function gfs2_inode_lookup returns an
> ERR pointer, but never returns a NULL pointer. So a NULL test that
> necessarily comes after an IS_ERR test should be deleted, and a NULL
> test that may come after a call to this function should be
> strengthened by an IS_ERR test.
> 
> The semantic match that finds this problem is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @match_bad_null_test@
> expression x, E;
> statement S1,S2;
> @@
> x = gfs2_inode_lookup(...)
> ... when != x = E
> * if (x != NULL) 
> S1 else S2
> // </smpl>
> 
> Signed-off-by:  Julien Brunel <brunel@diku.dk>
> Signed-off-by:  Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/gfs2/inode.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff -u -p a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -1033,13 +1033,11 @@ struct inode *gfs2_createi(struct gfs2_h
>  
>  	if (bh)
>  		brelse(bh);
> -	if (!inode)
> -		return ERR_PTR(-ENOMEM);
>  	return inode;
>  
>  fail_gunlock2:
>  	gfs2_glock_dq_uninit(ghs + 1);
> -	if (inode)
> +	if (inode && !IS_ERR(inode))
>  		iput(inode);
>  fail_gunlock:
>  	gfs2_glock_dq(ghs);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
