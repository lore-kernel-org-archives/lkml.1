Return-Path: <linux-kernel-owner+w=401wt.eu-S1753395AbXEGCAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbXEGCAh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 22:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXEGCAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 22:00:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395AbXEGCAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 22:00:36 -0400
From: Neil Brown <neilb@suse.de>
To: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Date: Mon, 7 May 2007 11:59:52 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17982.34840.356475.551081@notabene.brown>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, mhalcrow@us.ibm.com
Subject: Re: [PATCH 1/1] nfsctl: Use vfs_path_lookup
In-Reply-To: message from Josef 'Jeff' Sipek on Sunday May 6
References: <20070506211946.GC13333@infradead.org>
	<1178489631201-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday May 6, jsipek@cs.sunysb.edu wrote:
> use vfs_path_lookup instead of open-coding the necessary functionality.
> 
> Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>

Acked-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown

> ---
>  fs/nfsctl.c |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/nfsctl.c b/fs/nfsctl.c
> index c043136..51f1b31 100644
> --- a/fs/nfsctl.c
> +++ b/fs/nfsctl.c
> @@ -23,19 +23,15 @@
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
> +	mntput(mnt);	/* drop do_kern_mount reference */
>  	if (error)
>  		return ERR_PTR(error);
>  
> -- 
> 1.5.2.rc1.20.g86b9
