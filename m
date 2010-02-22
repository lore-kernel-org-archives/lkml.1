Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0BVUye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 15:54:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab0BVUyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 15:54:33 -0500
Date: Mon, 22 Feb 2010 15:54:29 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] vfs: Fix use-after-free of vfsmount by mnt_drop_write()
Message-ID: <20100222205429.GH972@shell>
References: <874ol9cfm7.fsf@devron.myhome.or.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874ol9cfm7.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 03:03:28AM +0900, OGAWA Hirofumi wrote:
> Hi,
> 
> Please review this. (This originally was for #untested branch, so this is
> not minimal change perfectly.)
> 
> 
> 
> Those might be assuming that the nd->path.mnt refcnt is keeped by
> filp after nameidata_to_filp().
> 
> It's wrong if nameidata_to_filp() returned the error.  (nd->path and
> filp are invalid)
> 
> Instead to use deep knowledge of nameidata_to_filp() internal, this
> thinks the nd->path is invalid after nameidata_to_filp(). So, this
> just take refcnt for mnt_want/drop_write().

You might take a look at the patch I just posted:

Subject: [RFC PATCH] VFS: Simplify truncate logic in do_filp_open()

If that patch is correct, it will considerably simplify the second
part of your patch.

-VAL

> 
> Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> ---
> 
>  fs/namei.c |   35 +++++++++++++++++++++++------------
>  1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff -puN fs/namei.c~nameidata_to_filp-mount-writer-fix fs/namei.c
> --- linux-2.6/fs/namei.c~nameidata_to_filp-mount-writer-fix	2010-02-22 23:22:26.000000000 +0900
> +++ linux-2.6-hirofumi/fs/namei.c	2010-02-22 23:59:34.000000000 +0900
> @@ -1617,6 +1617,7 @@ struct file *do_filp_open(int dfd, const
>  	struct path path;
>  	struct dentry *dir;
>  	int count = 0;
> +	struct vfsmount *uninitialized_var(mnt_writer);
>  	int will_truncate;
>  	int flag = open_to_namei_flags(open_flag);
>  	int force_reval = 0;
> @@ -1733,16 +1734,20 @@ do_last:
>  		 * a permanent write count is taken through
>  		 * the 'struct file' in nameidata_to_filp().
>  		 */
> -		error = mnt_want_write(nd.path.mnt);
> +		mnt_writer = nd.path.mnt;
> +		error = mnt_want_write(mnt_writer);
>  		if (error)
>  			goto exit_mutex_unlock;
>  		error = __open_namei_create(&nd, &path, flag, mode);
>  		if (error) {
> -			mnt_drop_write(nd.path.mnt);
> +			mnt_drop_write(mnt_writer);
>  			goto exit;
>  		}
> +		mntget(mnt_writer);
> +		/* nd->path is invalid after this */
>  		filp = nameidata_to_filp(&nd);
> -		mnt_drop_write(nd.path.mnt);
> +		mnt_drop_write(mnt_writer);
> +		mntput(mnt_writer);
>  		if (nd.root.mnt)
>  			path_put(&nd.root);
>  		if (!IS_ERR(filp)) {
> @@ -1794,16 +1799,20 @@ ok:
>  	 */
>  	will_truncate = open_will_truncate(flag, nd.path.dentry->d_inode);
>  	if (will_truncate) {
> -		error = mnt_want_write(nd.path.mnt);
> +		mnt_writer = nd.path.mnt;
> +		error = mnt_want_write(mnt_writer);
>  		if (error)
>  			goto exit;
>  	}
>  	error = may_open(&nd.path, acc_mode, flag);
>  	if (error) {
>  		if (will_truncate)
> -			mnt_drop_write(nd.path.mnt);
> +			mnt_drop_write(mnt_writer);
>  		goto exit;
>  	}
> +	if (will_truncate)
> +		mntget(mnt_writer);
> +	/* nd->path is invalid after this */
>  	filp = nameidata_to_filp(&nd);
>  	if (!IS_ERR(filp)) {
>  		error = ima_file_check(filp, acc_mode);
> @@ -1814,10 +1823,10 @@ ok:
>  	}
>  	if (!IS_ERR(filp)) {
>  		if (acc_mode & MAY_WRITE)
> -			vfs_dq_init(nd.path.dentry->d_inode);
> +			vfs_dq_init(filp->f_path.dentry->d_inode);
>  
>  		if (will_truncate) {
> -			error = handle_truncate(&nd.path);
> +			error = handle_truncate(&filp->f_path);
>  			if (error) {
>  				fput(filp);
>  				filp = ERR_PTR(error);
> @@ -1825,12 +1834,14 @@ ok:
>  		}
>  	}
>  	/*
> -	 * It is now safe to drop the mnt write
> -	 * because the filp has had a write taken
> -	 * on its behalf.
> +	 * It is now safe to drop the mnt write because the filp has
> +	 * had a write taken on its behalf. (NOTE: since O_TRUNC can
> +	 * be used with O_RDONLY, this needs to cover truncate path)
>  	 */
> -	if (will_truncate)
> -		mnt_drop_write(nd.path.mnt);
> +	if (will_truncate) {
> +		mnt_drop_write(mnt_writer);
> +		mntput(mnt_writer);
> +	}
>  	if (nd.root.mnt)
>  		path_put(&nd.root);
>  	return filp;
> _
> 
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
