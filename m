Return-Path: <linux-kernel-owner+w=401wt.eu-S1763210AbYFHLLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763210AbYFHLLR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:11:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbYFHLLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:11:06 -0400
Received: from styx.suse.cz ([82.119.242.94]:56294 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757486AbYFHLLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:11:05 -0400
Subject: Re: Missing patch from stable [3/7]
From: Miklos Szeredi <mszeredi@suse.cz>
To: Willy Tarreau <w@1wt.eu>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
       Michael Halcrow <mhalcrow@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20080608085923.GC6439@1wt.eu>
References: <20080608085923.GC6439@1wt.eu>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 13:11:02 +0200
Message-Id: <1212923462.4020.224.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-06-08 at 10:59 +0200, Willy Tarreau wrote:
> this patch from mainline seems suitable for -stable,

Willy,

Thanks for picking up these ecryptfs patches ...but they hardly meet
_any_ of the -stable rules.  In particular:


 - It must be obviously correct and tested.

It's obvious, but I don't know if it's been tested (or even looked at by
the maintainer).

 - It cannot be bigger than 100 lines, with context.

Check.

 - It must fix only one thing.

No, it's a small fix as well as a cleanup.

 - It must fix a real bug that bothers people (not a, "This could be a
   problem..." type thing).

No, it doesn't seem to bother anybody.

 - It must fix a problem that causes a build error (but not for things
   marked CONFIG_BROKEN), an oops, a hang, data corruption, a real
   security issue, or some "oh, that's not good" issue.  In short, something
   critical.

Not critical at all.

 - No "theoretical race condition" issues, unless an explanation of how the
   race can be exploited is also provided.

It's theoretical, I have no idea how it's exploitable, if at all.

 - It cannot contain any "trivial" fixes in it (spelling changes,
   whitespace cleanups, etc).

Check.

 - It must follow the Documentation/SubmittingPatches rules.

Check.

 - It or an equivalent fix must already exist in Linus' tree.  Quote the
   respective commit ID in Linus' tree in your patch submission to -stable.

Check.


Total: 4/9, not a very convincing score :)

Thanks,
Miklos


> 
> Thanks,
> Willy
> --
> 
> From 8dc4e37362a5dc910d704d52ac6542bfd49ddc2f Mon Sep 17 00:00:00 2001
> From: Miklos Szeredi <mszeredi@suse.cz>
> Date: Mon, 12 May 2008 14:02:04 -0700
> Subject: ecryptfs: clean up (un)lock_parent
> 
> dget(dentry->d_parent) --> dget_parent(dentry)
> 
> unlock_parent() is racy and unnecessary.  Replace single caller with
> unlock_dir().
> 
> There are several other suspect uses of ->d_parent in ecryptfs...
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> Cc: Michael Halcrow <mhalcrow@us.ibm.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  fs/ecryptfs/inode.c |   13 ++++---------
>  1 files changed, 4 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 0a13973..c92cc1c 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -37,17 +37,11 @@ static struct dentry *lock_parent(struct dentry *dentry)
>  {
>  	struct dentry *dir;
>  
> -	dir = dget(dentry->d_parent);
> +	dir = dget_parent(dentry);
>  	mutex_lock_nested(&(dir->d_inode->i_mutex), I_MUTEX_PARENT);
>  	return dir;
>  }
>  
> -static void unlock_parent(struct dentry *dentry)
> -{
> -	mutex_unlock(&(dentry->d_parent->d_inode->i_mutex));
> -	dput(dentry->d_parent);
> -}
> -
>  static void unlock_dir(struct dentry *dir)
>  {
>  	mutex_unlock(&dir->d_inode->i_mutex);
> @@ -426,8 +420,9 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
>  	int rc = 0;
>  	struct dentry *lower_dentry = ecryptfs_dentry_to_lower(dentry);
>  	struct inode *lower_dir_inode = ecryptfs_inode_to_lower(dir);
> +	struct dentry *lower_dir_dentry;
>  
> -	lock_parent(lower_dentry);
> +	lower_dir_dentry = lock_parent(lower_dentry);
>  	rc = vfs_unlink(lower_dir_inode, lower_dentry);
>  	if (rc) {
>  		printk(KERN_ERR "Error in vfs_unlink; rc = [%d]\n", rc);
> @@ -439,7 +434,7 @@ static int ecryptfs_unlink(struct inode *dir, struct dentry *dentry)
>  	dentry->d_inode->i_ctime = dir->i_ctime;
>  	d_drop(dentry);
>  out_unlock:
> -	unlock_parent(lower_dentry);
> +	unlock_dir(lower_dir_dentry);
>  	return rc;
>  }
>  

