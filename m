Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330Ab0BWART (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 19:17:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751115Ab0BWARR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 19:17:17 -0500
Date: Mon, 22 Feb 2010 16:17:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix __d_path for lazy unmounts
Message-Id: <20100222161714.de1a7fca.akpm@linux-foundation.org>
In-Reply-To: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
References: <1266668858-15253-1-git-send-email-john.johansen@canonical.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Feb 2010 04:27:38 -0800 john.johansen@canonical.com wrote:

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

Please put a space between the `while' and the `('.

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

Did you really mean to assign 1 to dentry->d_name.len here?  Was `=='
intended?  I hope so, because modifying the dentry in d_path() would be odd.

If this was a mistake then why did the patch pass testing?


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

