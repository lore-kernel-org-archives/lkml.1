Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbXEFVTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbXEFVTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbXEFVTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:19:49 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42896 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbXEFVTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:19:47 -0400
Date: Sun, 6 May 2007 22:19:46 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
Subject: Re: [PATCH 3/5] nfsctl: Use vfs_path_lookup
Message-ID: <20070506211946.GC13333@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	akpm@linux-foundation.org, viro@ftp.linux.org.uk,
	Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com
References: <1178473289617-git-send-email-jsipek@cs.sunysb.edu> <1178473290774-git-send-email-jsipek@cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178473290774-git-send-email-jsipek@cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 01:41:27PM -0400, Josef 'Jeff' Sipek wrote:
> use vfs_path_lookup instead of open-coding the necessary functionality.
> 
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
> ---
>  fs/nfsctl.c |   15 +++++----------
>  1 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/nfsctl.c b/fs/nfsctl.c
> index c043136..c97df14 100644
> --- a/fs/nfsctl.c
> +++ b/fs/nfsctl.c
> @@ -23,19 +23,14 @@
>  static struct file *do_open(char *name, int flags)
>  {
>  	struct nameidata nd;
> +	struct vfsmount *mnt;
>  	int error;
>  
> -	nd.mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
> +	mnt = do_kern_mount("nfsd", 0, "nfsd", NULL);
> +	if (IS_ERR(mnt))
> +		return (struct file *)mnt;
>  
> -	if (IS_ERR(nd.mnt))
> -		return (struct file *)nd.mnt;
> -
> -	nd.dentry = dget(nd.mnt->mnt_root);
> -	nd.last_type = LAST_ROOT;
> -	nd.flags = 0;
> -	nd.depth = 0;
> -
> -	error = path_walk(name, &nd);
> +	error = vfs_path_lookup(mnt->mnt_root, mnt, name, 0, &nd);
>  	if (error)
>  		return ERR_PTR(error);

I think you're leaking a reference on the mount here as we didn't
do a mntget before.  We need to do an additional mntput just after
the lookup to drop the reference from do_kern_mount.
