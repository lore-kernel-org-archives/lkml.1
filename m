Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbZLCK6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbZLCK6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 05:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755979AbZLCK6m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 05:58:42 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37069 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755976AbZLCK6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 05:58:41 -0500
To: Jeff Layton <jlayton@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       jamie@shareable.org, pavel@ucw.cz, miklos@szeredi.hu,
       viro@ZenIV.linux.org.uk, duaneg@dghda.com, ebiederm@xmission.com
In-reply-to: <1259783983-26884-3-git-send-email-jlayton@redhat.com> (message
	from Jeff Layton on Wed, 2 Dec 2009 14:59:43 -0500)
Subject: Re: [PATCH 2/2] vfs: force reval on dentry of bind mounted files on FS_REVAL_DOT filesystems
References: <1259783983-26884-1-git-send-email-jlayton@redhat.com> <1259783983-26884-3-git-send-email-jlayton@redhat.com>
Message-Id: <E1NG9OV-0002g5-3D@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 03 Dec 2009 11:58:43 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Dec 2009, Jeff Layton wrote:
> In the case of a bind mounted file, the path walking code will assume
> that the cached dentry that was bind mounted is valid. This is a problem
> problem for NFSv4 in a way that's similar to LAST_BIND symlinks.
> 
> Fix this by revalidating the dentry if FS_FOLLOW_DOT is set and
> __follow_mount returns true.
> 
> Note that in the non-open codepath, we cannot return an error to the
> lookup if the revalidation fails. Doing so will leave a bind mount in
> a state such that we can't unmount it. In that case we'll just have to
> settle for d_invalidating it (which should mostly turn out to be a
> d_drop in this case) and returning success.

The only worry I have is that this adds an extra branch in a very hot
codepath (do_lookup).  An error can't be returned, as you note, and
for bind mounted directories d_invalidate() will not succeed: the
directory is busy, it's referenced by the mount.  So basically the
only thing this does is working around the NFSv4 issue.  But Trond has
a proper solution to that, and a temporary solution could be added to
do_filp_open() rather than burdening do_lookup() with it, no?

Thanks,
Miklos

> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/namei.c |   11 ++++++++++-
>  1 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 339789e..0d55b6f 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -851,7 +851,13 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
>  done:
>  	path->mnt = mnt;
>  	path->dentry = dentry;
> -	__follow_mount(path);
> +
> +	/*
> +	 * cannot return the error returned by force_reval_path as that can
> +	 * make it impossible to unmount a bind mounted dentry if it's stale.
> +	 */
> +	if (__follow_mount(path))
> +		force_reval_path(path, nd);
>  	return 0;
>  
>  need_lookup:
> @@ -1840,6 +1846,9 @@ do_last:
>  		error = -ELOOP;
>  		if (flag & O_NOFOLLOW)
>  			goto exit_dput;
> +		error = force_reval_path(&path, &nd);
> +		if (error)
> +			goto exit_dput;
>  	}
>  
>  	error = -ENOENT;
> -- 
> 1.5.5.6
> 
> 
