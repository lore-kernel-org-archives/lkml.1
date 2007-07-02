Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbXGBTnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbXGBTnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 15:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753023AbXGBTnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 15:43:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727AbXGBTnQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 15:43:16 -0400
Message-ID: <468954BD.50205@sandeen.net>
Date: Mon, 02 Jul 2007 14:40:45 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Chinner <dgc@sgi.com>, xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][XFS][resend] memory leak; allocated transaction not freed
 in xfs_inactive_free_eofblocks() in failure case.
References: <200707010116.54884.jesper.juhl@gmail.com>
In-Reply-To: <200707010116.54884.jesper.juhl@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> (this is back from May 16 2007, resending since it doesn't look like 
> the patch ever made it in anywhere)
> 
> 

Weird, looks like it's in cvs...

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-linux/xfs_vnodeops.c.diff?r1=text&tr1=1.699&r2=text&tr2=1.698&f=h

but not in git.

-Eric

> Fix XFS memory leak; allocated transaction not freed in xfs_inactive_free_eofblocks() in failure case.
> 
> the code allocates a transaction, but in the case where 'truncate' is
> !=0 and xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE, 0); happens to return
> an error, we'll just return from the function without dealing with the
> memory allocated byxfs_trans_alloc() and assigned to 'tp', thus it'll be
> orphaned/leaked - not good.
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> --- 
>  fs/xfs/xfs_vnodeops.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> index de17aed..32519cf 100644
> --- a/fs/xfs/xfs_vnodeops.c
> +++ b/fs/xfs/xfs_vnodeops.c
> @@ -1260,6 +1260,7 @@ xfs_inactive_free_eofblocks(
>  		error = xfs_itruncate_start(ip, XFS_ITRUNC_DEFINITE,
>  				    ip->i_size);
>  		if (error) {
> +			xfs_trans_cancel(tp, 0);
>  			xfs_iunlock(ip, XFS_IOLOCK_EXCL);
>  			return error;
>  		}
> 
> 
> 

