Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab0BVRjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:39:17 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46117 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0BVRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:39:15 -0500
Date: Mon, 22 Feb 2010 11:38:54 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
Message-ID: <20100222173854.GA7886@us.ibm.com>
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting john.johansen@canonical.com (john.johansen@canonical.com):
> From: John Johansen <john.johansen@canonical.com>
> 
> When __d_path() hits a lazily unmounted mount point, it tries to prepend
> the name of the lazily unmounted dentry to the path name.  It gets this wrong,
> and also overwrites the slash that separates the name from the following
> pathname component. This patch fixes that; if a process was in directory
> /foo/bar and /foo got lazily unmounted, the old result was ``foobar'' (note the
> missing slash), while the new result with this patch is ``/foo/bar''.
> 
> Signed-off-by: John Johansen <john.johansen@canonical.com>

Tested-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>

In particular, I tested for closed pipes and lazily umounted mounts
and binds - lazily umounted binds are fixed, and no apparent regression
in the others.

Thanks, John.

-serge

> ---
>  fs/dcache.c |   27 +++++++++++++++++++++++----
>  1 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 953173a..df49666 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1922,11 +1922,9 @@ char *__d_path(const struct path *path, struct path *root,
>  	retval = end-1;
>  	*retval = '/';
> 
> -	for (;;) {
> +	while(dentry != root->dentry || vfsmnt != root->mnt) {
>  		struct dentry * parent;
> 
> -		if (dentry == root->dentry && vfsmnt == root->mnt)
> -			break;
>  		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
>  			/* Global root? */
>  			if (vfsmnt->mnt_parent == vfsmnt) {
> @@ -1950,9 +1948,30 @@ out:
>  	return retval;
> 
>  global_root:
> -	retval += 1;	/* hit the slash */
> +	/*
> +	 * We went past the (vfsmount, dentry) we were looking for and have
> +	 * either hit a root dentry, a lazily unmounted dentry, an
> +	 * unconnected dentry, or the file is on a pseudo filesystem.
> +	 */
> +	if ((dentry->d_sb->s_flags & MS_NOUSER) ||
> +	    (dentry->d_name.len = 1 && *dentry->d_name.name == '/')) {
> +		/*
> +		 * Historically, we also glue together the root dentry and
> +		 * remaining name for pseudo filesystems like pipefs, which
> +		 * have the MS_NOUSER flag set. This results in pathnames
> +		 * like "pipe:[439336]".
> +		 */
> +		retval += 1;	/* overwrite the slash */
> +		buflen++;
> +	}
>  	if (prepend_name(&retval, &buflen, &dentry->d_name) != 0)
>  		goto Elong;
> +
> +	/* connect lazily unmounted mount point */
> +	if (*retval != '/' && !(dentry->d_sb->s_flags & MS_NOUSER) &&
> +	    prepend(&retval, &buflen, "/", 1) != 0)
> +		goto Elong;
> +
>  	root->mnt = vfsmnt;
>  	root->dentry = dentry;
>  	goto out;
> -- 
> 1.6.6.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
