Return-Path: <linux-kernel-owner+w=401wt.eu-S1753093AbZLCKjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093AbZLCKjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:39:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834AbZLCKjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:39:15 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:48006 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbZLCKjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:39:14 -0500
To: Jeff Layton <jlayton@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com, ebiederm@xmission.com
In-reply-to: <1259783983-26884-2-git-send-email-jlayton@redhat.com> (message
	from Jeff Layton on Wed, 2 Dec 2009 14:59:42 -0500)
Subject: Re: [PATCH 1/2] vfs: force reval of target when following LAST_BIND symlinks
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com> <1259783983-26884-2-git-send-email-jlayton@redhat.com>
Message-Id: <E1NG95f-0002dq-Hw@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Dec 2009 11:39:15 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Dec 2009, Jeff Layton wrote:
> procfs-style symlinks return a last_type of LAST_BIND without an actual
> path string. This causes __follow_link to skip calling __vfs_follow_link
> and so the dentry isn't revalidated.
> 
> This is a problem when the link target sits on NFSv4 as it depends on
> the VFS to revalidate the dentry before using it on an open call. Ensure
> that this occurs by forcing a revalidation of the target dentry of
> LAST_BIND symlinks.

An added advantage is that the symlinks in /proc will show the
invalidated path as "(deleted)".  Maybe proc_pid_readlink() should
also call force_reval_path() to get an up-to-date state of the path?

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/namei.c |   45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 45 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 3374917..339789e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -414,6 +414,46 @@ do_revalidate(struct dentry *dentry, struct nameidata *nd)
>  }
>  
>  /*
> + * force_reval_path - force revalidation of a dentry
> + *
> + * In some situations the path walking code will trust dentries without
> + * revalidating them. This causes problems for filesystems that depend on
> + * d_revalidate to handle file opens (e.g. NFSv4). When FS_REVAL_DOT is set
> + * (which indicates that it's possible for the dentry to go stale), force
> + * a d_revalidate call before proceeding.
> + *
> + * Returns 0 if the revalidation was successful. If the revalidation fails,
> + * either return the error returned by d_revalidate or -ESTALE if the
> + * revalidation it just returned 0. If d_revalidate returns 0, we attempt to
> + * invalidate the dentry. It's up to the caller to handle putting references
> + * to the path if necessary.
> + */
> +static int
> +force_reval_path(struct path *path, struct nameidata *nd)
> +{
> +	int status;
> +	struct dentry *dentry = path->dentry;
> +
> +	/*
> +	 * only check on filesystems where it's possible for the dentry to
> +	 * become stale. It's assumed that if this flag is set then the
> +	 * d_revalidate op will also be defined.
> +	 */
> +	if (!(dentry->d_sb->s_type->fs_flags & FS_REVAL_DOT))
> +		return 0;
> +
> +	status = dentry->d_op->d_revalidate(dentry, nd);
> +	if (status > 0)
> +		return 0;
> +
> +	if (!status) {
> +		d_invalidate(dentry);
> +		status = -ESTALE;
> +	}
> +	return status;
> +}
> +
> +/*
>   * Internal lookup() using the new generic dcache.
>   * SMP-safe
>   */
> @@ -641,6 +681,11 @@ static __always_inline int __do_follow_link(struct path *path, struct nameidata
>  		error = 0;
>  		if (s)
>  			error = __vfs_follow_link(nd, s);
> +		else if (nd->last_type == LAST_BIND) {
> +			error = force_reval_path(&nd->path, nd);
> +			if (error)
> +				path_put(&nd->path);
> +		}
>  		if (dentry->d_inode->i_op->put_link)
>  			dentry->d_inode->i_op->put_link(dentry, nd, cookie);
>  	}
> -- 
> 1.5.5.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
