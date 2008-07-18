Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbYGRSx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbYGRSx1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYGRSxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:53:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48497 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754871AbYGRSxS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:53:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/7] autofs4 - fix indirect mount pending expire race
References: <20080718023651.12802.59107.stgit@raven.themaw.net>
	<20080718023717.12802.80763.stgit@raven.themaw.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 18 Jul 2008 14:52:29 -0400
In-Reply-To: <20080718023717.12802.80763.stgit@raven.themaw.net> (Ian Kent's
	message of "Fri, 18 Jul 2008 10:37:18 +0800")
Message-ID: <x49r69rc9ea.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> The selection of a dentry for expiration and the setting of the
> AUTOFS_INF_EXPIRING flag isn't done atomically which can lead to
> lookups walking into an expiring mount.
>
> What happens is that an expire is initiated by the daemon and
> a dentry is selected for expire but, since there is no lock
> held between the selection and setting of the expiring flag,
> a process may find the flag clear and continue walking into
> the mount tree at the same time the daemon attempts the expire
> it.
>
> Signed-off-by: Ian Kent <raven@themaw.net>
>
> ---

[...]
>  static inline void autofs4_copy_atime(struct file *src, struct file *dst)
> diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
> index 894fee5..19f5bea 100644
> --- a/fs/autofs4/expire.c
> +++ b/fs/autofs4/expire.c
> @@ -292,6 +292,8 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
>  	struct list_head *next;
>  	int do_now = how & AUTOFS_EXP_IMMEDIATE;
>  	int exp_leaves = how & AUTOFS_EXP_LEAVES;
> +	struct autofs_info *ino;
> +	unsigned int ino_count;
>  
>  	if (!root)
>  		return NULL;
> @@ -316,6 +318,9 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
>  		dentry = dget(dentry);
>  		spin_unlock(&dcache_lock);
>  
> +		spin_lock(&sbi->fs_lock);
> +		ino = autofs4_dentry_ino(dentry);
> +
>  		/*
>  		 * Case 1: (i) indirect mount or top level pseudo direct mount
>  		 *	   (autofs-4.1).
> @@ -326,6 +331,11 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
>  			DPRINTK("checking mountpoint %p %.*s",
>  				dentry, (int)dentry->d_name.len, dentry->d_name.name);
>  
> +			/* Path walk currently on this dentry? */
> +			ino_count = atomic_read(&ino->count) + 2;
> +			if (atomic_read(&dentry->d_count) > ino_count)
> +				goto next;
> +

It would be nice to document the +2.  The +1s (below) may be evident
given that we did a dget above, but still might merit mention.

>  			/* Can we umount this guy */
>  			if (autofs4_mount_busy(mnt, dentry))
>  				goto next;
> @@ -343,23 +353,25 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
>  
>  		/* Case 2: tree mount, expire iff entire tree is not busy */
>  		if (!exp_leaves) {
> -			/* Lock the tree as we must expire as a whole */
> -			spin_lock(&sbi->fs_lock);
> -			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
> -				struct autofs_info *inf = autofs4_dentry_ino(dentry);
> +			/* Path walk currently on this dentry? */
> +			ino_count = atomic_read(&ino->count) + 1;
> +			if (atomic_read(&dentry->d_count) > ino_count)
> +				goto next;
>  
> -				/* Set this flag early to catch sys_chdir and the like */
> -				inf->flags |= AUTOFS_INF_EXPIRING;
> -				spin_unlock(&sbi->fs_lock);
> +			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
>  				expired = dentry;
>  				goto found;
>  			}
> -			spin_unlock(&sbi->fs_lock);
>  		/*
>  		 * Case 3: pseudo direct mount, expire individual leaves
>  		 *	   (autofs-4.1).
>  		 */
>  		} else {
> +			/* Path walk currently on this dentry? */
> +			ino_count = atomic_read(&ino->count) + 1;
> +			if (atomic_read(&dentry->d_count) > ino_count)
> +				goto next;
> +
>  			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
>  			if (expired) {
>  				dput(dentry);
> @@ -367,6 +379,7 @@ static struct dentry *autofs4_expire_indirect(struct super_block *sb,
>  			}
>  		}
>  next:
> +		spin_unlock(&sbi->fs_lock);
>  		dput(dentry);
>  		spin_lock(&dcache_lock);
>  		next = next->next;
> @@ -377,6 +390,9 @@ next:
>  found:
>  	DPRINTK("returning %p %.*s",
>  		expired, (int)expired->d_name.len, expired->d_name.name);
> +	ino = autofs4_dentry_ino(expired);

If we get here, ino is already set to the autofs4_dentry_ino(expired),
so this statement is redundant.

[...]
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index 2944b28..2ed2a51 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -133,7 +133,10 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
>  	/* Block on any pending expiry here; invalidate the dentry
>             when expiration is done to trigger mount request with a new
>             dentry */
> -	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
> +	spin_lock(&sbi->fs_lock);
> +	if (ino->flags & AUTOFS_INF_EXPIRING) {
> +		spin_unlock(&sbi->fs_lock);
> +
>  		DPRINTK("waiting for expire %p name=%.*s",
>  			 dentry, dentry->d_name.len, dentry->d_name.name);

This is okay, since we wait on the AUTOFS_INF_EXPIRING flag in
validate_request.  That check is done outside the lock, but I doubt
there are issues with not seeing an update since you perform a schedule
there.

> @@ -149,8 +152,11 @@ static int try_to_fill_dentry(struct dentry *dentry, int flags)
>  		status = d_invalidate(dentry);
>  		if (status != -EBUSY)
>  			return -EAGAIN;
> -	}
>  
> +		goto cont;
> +	}
> +	spin_unlock(&sbi->fs_lock);
> +cont:
>  	DPRINTK("dentry=%p %.*s ino=%p",
>  		 dentry, dentry->d_name.len, dentry->d_name.name, dentry->d_inode);
>  
> @@ -229,15 +235,21 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
>  		goto done;
>  
>  	/* If an expire request is pending wait for it. */
> -	if (ino && (ino->flags & AUTOFS_INF_EXPIRING)) {
> +	spin_lock(&sbi->fs_lock);
> +	if (ino->flags & AUTOFS_INF_EXPIRING) {
> +		spin_unlock(&sbi->fs_lock);
> +
>  		DPRINTK("waiting for active request %p name=%.*s",
>  			dentry, dentry->d_name.len, dentry->d_name.name);
>  
>  		status = autofs4_wait(sbi, dentry, NFY_NONE);
>  
>  		DPRINTK("request done status=%d", status);
> -	}
>  
> +		goto cont;
> +	}
> +	spin_unlock(&sbi->fs_lock);
> +cont:

could've done an:
} else
	spin_unlock(&sbi->fs_lock);

But, whatever...

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
