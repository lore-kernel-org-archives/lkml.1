Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbXKMRkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbXKMRkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 12:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbXKMRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 12:39:55 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:58957 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbXKMRjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 12:39:55 -0500
Subject: Re: [PATCH] NFSD: fix wrong mnt_writer count in rename (MMOTM
	2007-11-10-19-05)
From: Dave Hansen <haveblue@us.ibm.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: bfields@fieldses.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <200711130115.lAD1FBfG015626@agora.fsl.cs.sunysb.edu>
References: <200711130115.lAD1FBfG015626@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Tue, 13 Nov 2007 09:39:41 -0800
Message-Id: <1194975581.7078.144.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 20:15 -0500, Erez Zadok wrote:
> NFSD forgets to call mnt_drop_write after a successful rename.  Here's a
> fix.  (Ah, the curse of a stackable file system developer: you have to debug
> everyone else's too. :-)
> 
> One thing I wasn't sure is whether I could move the mnt_drop_write line a
> little above, just after the call to vfs_rename.  If we can drop the ref
> earlier, it could improve scalability/performance just a bit, no? (i.e.,
> what are the ramifications of holding on to this mnt writer ref longer than
> needed?)

I do see some write-ish things happening inside of the nfsd_sync_dir()
call chain: the fsync() and filemap_fdatawrite().

The danger here is that the moment you mnt_drop_write(), the filesystem
is mounted r/o by someone else, then those fsync() writes occur when
everyone thinks it is r/o.  So, I think your fix is the most
conservative, and the most correct.

> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 7dfde65..47aec49 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1693,6 +1693,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
>  		if (!host_err)
>  			host_err = nfsd_sync_dir(fdentry);
>  	}
> +	mnt_drop_write(ffhp->fh_export->ex_path.mnt);
> 
>   out_dput_new:
>  	dput(ndentry);

Otherwise, looks good to me.  Thanks.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>

-- Dave

