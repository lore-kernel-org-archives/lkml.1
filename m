Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbZCJTXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbZCJTXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:23:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbZCJTWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:22:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35611 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbZCJTWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:22:53 -0400
To: sage@newdream.net
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, adilger@sun.com
In-reply-to: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net> (message
	from Sage Weil on Mon, 9 Mar 2009 11:31:40 -0700 (PDT))
Subject: Re: [PATCH] vfs: make real_lookup do dentry revalidation with i_mutex
 held
References: <Pine.LNX.4.64.0903091118210.2773@cobra.newdream.net>
Message-Id: <E1Lh7XK-0000QO-DT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Mar 2009 20:22:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is wrong in case ->d_revalidate is NULL.

Something like this should fix it up:

Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-03-10 20:03:58.000000000 +0100
+++ linux-2.6/fs/namei.c	2009-03-10 20:19:29.000000000 +0100
@@ -501,6 +501,8 @@ static struct dentry * real_lookup(struc
 			 * The dentry was left behind invalid.  Just
 			 * do the lookup.
 			 */
+		} else {
+			goto out_unlock;
 		}
 	}
 
Otherwise looks OK.

Thanks,
Miklos


On Mon, 9 Mar 2009, Sage Weil wrote:
> real_lookup() is called by do_lookup() if dentry revalidation fails.  If
> the cache is re-populated while waiting for i_mutex, it may find that
> a d_lookup() subsequently succeeds (see the "Uhhuh! Nasty case" comment).
> 
> Previously, real_lookup() would drop i_mutex and do_revalidate() again. If
> revalidate failed _again_, however, it would give up with -ENOENT.  The
> problem here that network file systems may be invalidating dentries via
> server callbacks, e.g. due to concurrent access from another client, and
> -ENOENT is frequently the wrong answer.
> 
> This problem has been seen with both Lustre and Ceph.  It seems possible
> to hit this case with NFS as well if the cache lifetime is very short.
> 
> Instead, we should do_revalidate() while i_mutex is still held.  If
> revalidation fails, we can move on to a ->lookup() and ensure a correct
> result without worrying about any subsequent races.
> 
> Note that do_revalidate() is called with i_mutex held elsewhere.  For
> example, do_filp_open(), lookup_create(), do_unlinkat(), do_rmdir(),
> and possibly others all take the directory i_mutex, and then
> 
> -> lookup_hash
>         -> __lookup_hash
>                 -> cached_lookup
>                         -> do_revalidate
> 
> so this does not introduce any new locking rules for d_revalidate
> implementations.
> 
> CC: Al Viro <viro@zeniv.linux.org.uk>
> CC: Andreas Dilger <adilger@sun.com>
> Signed-off-by: Yehuda Sadeh <yehuda@newdream.net>
> Signed-off-by: Sage Weil <sage@newdream.net>
> ---
>  fs/namei.c |   56 +++++++++++++++++++++++++++++---------------------------
>  1 files changed, 29 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index c30e33d..49f58d1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -469,6 +469,7 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
>  {
>  	struct dentry * result;
>  	struct inode *dir = parent->d_inode;
> +	struct dentry *dentry;
>  
>  	mutex_lock(&dir->i_mutex);
>  	/*
> @@ -486,38 +487,39 @@ static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, s
>  	 * so doing d_lookup() (with seqlock), instead of lockfree __d_lookup
>  	 */
>  	result = d_lookup(parent, name);
> -	if (!result) {
> -		struct dentry *dentry;
> -
> -		/* Don't create child dentry for a dead directory. */
> -		result = ERR_PTR(-ENOENT);
> -		if (IS_DEADDIR(dir))
> -			goto out_unlock;
> -
> -		dentry = d_alloc(parent, name);
> -		result = ERR_PTR(-ENOMEM);
> -		if (dentry) {
> -			result = dir->i_op->lookup(dir, dentry, nd);
> +	if (result) {
> +		/*
> +		 * The cache was re-populated while we waited on the
> +		 * mutex.  We need to revalidate, this time while
> +		 * holding i_mutex (to avoid another race).
> +		 */
> +		if (result->d_op && result->d_op->d_revalidate) {
> +			result = do_revalidate(result, nd);
>  			if (result)
> -				dput(dentry);
> -			else
> -				result = dentry;
> +				goto out_unlock;
> +			/*
> +			 * The dentry was left behind invalid.  Just
> +			 * do the lookup.
> +			 */
>  		}
> -out_unlock:
> -		mutex_unlock(&dir->i_mutex);
> -		return result;
>  	}
>  
> -	/*
> -	 * Uhhuh! Nasty case: the cache was re-populated while
> -	 * we waited on the semaphore. Need to revalidate.
> -	 */
> -	mutex_unlock(&dir->i_mutex);
> -	if (result->d_op && result->d_op->d_revalidate) {
> -		result = do_revalidate(result, nd);
> -		if (!result)
> -			result = ERR_PTR(-ENOENT);
> +	/* Don't create child dentry for a dead directory. */
> +	result = ERR_PTR(-ENOENT);
> +	if (IS_DEADDIR(dir))
> +		goto out_unlock;
> +
> +	dentry = d_alloc(parent, name);
> +	result = ERR_PTR(-ENOMEM);
> +	if (dentry) {
> +		result = dir->i_op->lookup(dir, dentry, nd);
> +		if (result) {
> +			dput(dentry);
> +		} else
> +			result = dentry;
>  	}
> +out_unlock:
> +	mutex_unlock(&dir->i_mutex);
>  	return result;
>  }
>  
> -- 
> 1.5.6.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
