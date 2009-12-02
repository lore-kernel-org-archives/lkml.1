Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZLBXxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZLBXxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 18:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754621AbZLBXxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 18:53:48 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38505 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbZLBXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 18:53:47 -0500
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com>
	<1259783983-26884-2-git-send-email-jlayton@redhat.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 02 Dec 2009 15:53:42 -0800
In-Reply-To: <1259783983-26884-2-git-send-email-jlayton@redhat.com> (Jeff Layton's message of "Wed\,  2 Dec 2009 14\:59\:42 -0500")
Message-ID: <m1zl61q6ex.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH 1/2] vfs: force reval of target when following LAST_BIND symlinks
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Layton <jlayton@redhat.com> writes:

> procfs-style symlinks return a last_type of LAST_BIND without an actual
> path string. This causes __follow_link to skip calling __vfs_follow_link
> and so the dentry isn't revalidated.
>
> This is a problem when the link target sits on NFSv4 as it depends on
> the VFS to revalidate the dentry before using it on an open call. Ensure
> that this occurs by forcing a revalidation of the target dentry of
> LAST_BIND symlinks.

This seems reasonable to me, and in a quick run through I can't see any
problems.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

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
