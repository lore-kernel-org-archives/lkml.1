Return-Path: <linux-kernel-owner+w=401wt.eu-S1753513AbZLAESJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbZLAESJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 23:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZLAESI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 23:18:08 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33006 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbZLAESG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 23:18:06 -0500
Date: Mon, 30 Nov 2009 23:17:43 -0500
Message-Id: <200912010417.nB14Hhbm030497@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/41] fallthru: tmpfs fallthru support 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:32 PDT."
             <1256152779-10054-35-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-35-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> Add support for fallthru directory entries to tmpfs

Need to CC tmpfs maintainers here.

> XXX - Makes up inode number for dirent
> 
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/dcache.c |    3 +-
>  fs/libfs.c  |   21 +++++++++++++++++--
>  mm/shmem.c  |   60 ++++++++++++++++++++++++++++++++++++++++++++++++++++------
>  3 files changed, 73 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index ca8a661..8ef2d89 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -2292,7 +2292,8 @@ resume:
>  		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
>  		next = tmp->next;
>  		if (d_unhashed(dentry)||(!dentry->d_inode &&
> -					 !d_is_whiteout(dentry)))
> +					 !d_is_whiteout(dentry) &&
> +					 !d_is_fallthru(dentry)))
>  			continue;
>  		if (!list_empty(&dentry->d_subdirs)) {
>  			this_parent = dentry;
> diff --git a/fs/libfs.c b/fs/libfs.c
> index dcec3d3..01f3e73 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -133,6 +133,7 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  	struct dentry *cursor = filp->private_data;
>  	struct list_head *p, *q = &cursor->d_u.d_child;
>  	ino_t ino;
> +	int d_type;
>  	int i = filp->f_pos;
>  
>  	switch (i) {
> @@ -158,14 +159,28 @@ int dcache_readdir(struct file * filp, void * dirent, filldir_t filldir)
>  			for (p=q->next; p != &dentry->d_subdirs; p=p->next) {
>  				struct dentry *next;
>  				next = list_entry(p, struct dentry, d_u.d_child);
> -				if (d_unhashed(next) || !next->d_inode)
> +				if (d_unhashed(next) || (!next->d_inode && !d_is_fallthru(next)))
>  					continue;
>  
> +				if (d_is_fallthru(next)) {
> +					/* XXX We don't know the inode
> +					 * number of the directory
> +					 * entry in the underlying
> +					 * file system.  Should look
> +					 * it up, either on fallthru
> +					 * creation at first readdir
> +					 * or now at filldir time. */
> +					ino = 123; /* Made up ino */

Ok, so here it's 123, as in ext2, but not jffs2, who had it set to 100...

> +					d_type = DT_UNKNOWN;
> +				} else {
> +					ino = next->d_inode->i_ino;
> +					d_type = dt_type(next->d_inode);
> +				}
> +
>  				spin_unlock(&dcache_lock);
>  				if (filldir(dirent, next->d_name.name, 
>  					    next->d_name.len, filp->f_pos, 
> -					    next->d_inode->i_ino, 
> -					    dt_type(next->d_inode)) < 0)
> +					    ino, d_type) < 0)
>  					return 0;
>  				spin_lock(&dcache_lock);
>  				/* next is still alive */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 2faa14b..4f4b4b6 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1798,8 +1798,7 @@ static int shmem_rmdir(struct inode *dir, struct dentry *dentry);
>  static int shmem_unlink(struct inode *dir, struct dentry *dentry);
>  
>  /*
> - * This is the whiteout support for tmpfs. It uses one singleton whiteout
> - * inode per superblock thus it is very similar to shmem_link().
> + * Create a dentry to signify a whiteout.
>   */
>  static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
>  			  struct dentry *new_dentry)
> @@ -1830,8 +1829,10 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
>  		spin_unlock(&sbinfo->stat_lock);
>  	}
>  
> -	if (old_dentry->d_inode) {
> -		if (S_ISDIR(old_dentry->d_inode->i_mode))
> +	if (old_dentry->d_inode || d_is_fallthru(old_dentry)) {
> +		/* A fallthru for a dir is treated like a regular link */
> +		if (old_dentry->d_inode &&
> +		    S_ISDIR(old_dentry->d_inode->i_mode))
>  			shmem_rmdir(dir, old_dentry);
>  		else
>  			shmem_unlink(dir, old_dentry);
> @@ -1848,6 +1849,48 @@ static int shmem_whiteout(struct inode *dir, struct dentry *old_dentry,
>  }
>  
>  static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
> +				struct inode *inode);
> +
> +/*
> + * Create a dentry to signify a fallthru.  A fallthru in tmpfs is the
> + * logical equivalent of an in-kernel readdir() cache.  It can't be
> + * deleted until the file system is unmounted.
> + */
> +static int shmem_fallthru(struct inode *dir, struct dentry *dentry)
> +{
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(dir->i_sb);
> +
> +	/* FIXME: this is stupid */
> +	if (!(dir->i_sb->s_flags & MS_WHITEOUT))
> +		return -EPERM;
> +
> +	if (dentry->d_inode || d_is_fallthru(dentry) || d_is_whiteout(dentry))
> +		return -EEXIST;
> +
> +	/*
> +	 * Each new link needs a new dentry, pinning lowmem, and tmpfs
> +	 * dentries cannot be pruned until they are unlinked.
> +	 */
> +	if (sbinfo->max_inodes) {
> +		spin_lock(&sbinfo->stat_lock);
> +		if (!sbinfo->free_inodes) {
> +			spin_unlock(&sbinfo->stat_lock);
> +			return -ENOSPC;
> +		}
> +		sbinfo->free_inodes--;
> +		spin_unlock(&sbinfo->stat_lock);
> +	}
> +
> +	shmem_d_instantiate(dir, dentry, NULL);
> +	dir->i_ctime = dir->i_mtime = CURRENT_TIME;
> +
> +	spin_lock(&dentry->d_lock);
> +	dentry->d_flags |= DCACHE_FALLTHRU;
> +	spin_unlock(&dentry->d_lock);
> +	return 0;
> +}
> +
> +static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
>  				struct inode *inode)
>  {
>  	if (d_is_whiteout(dentry)) {
> @@ -1855,14 +1898,15 @@ static void shmem_d_instantiate(struct inode *dir, struct dentry *dentry,
>  		shmem_free_inode(dir->i_sb);
>  		if (S_ISDIR(inode->i_mode))
>  			inode->i_mode |= S_OPAQUE;
> +	} else if (d_is_fallthru(dentry)) {
> +		shmem_free_inode(dir->i_sb);
>  	} else {
>  		/* New dentry */
>  		dir->i_size += BOGO_DIRENT_SIZE;
>  		dget(dentry); /* Extra count - pin the dentry in core */
>  	}
> -	/* Will clear DCACHE_WHITEOUT flag */
> +	/* Will clear DCACHE_WHITEOUT and DCACHE_FALLTHRU flags */
>  	d_instantiate(dentry, inode);
> -
>  }
>  /*
>   * File creation. Allocate an inode, and we're done..
> @@ -1947,7 +1991,8 @@ static int shmem_unlink(struct inode *dir, struct dentry *dentry)
>  {
>  	struct inode *inode = dentry->d_inode;
>  
> -	if (d_is_whiteout(dentry) || (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
> +	if (d_is_whiteout(dentry) || d_is_fallthru(dentry) ||
> +	    (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode)))
>  		shmem_free_inode(dir->i_sb);

I'd reorder this || condition above so the more common sub-conditions to be
true, show up first (inode->i_nlink > 1 && !S_ISDIR(inode->i_mode).
d_is_whatever should go last.

>  
>  	if (inode) {
> @@ -2583,6 +2628,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
>  	.mknod		= shmem_mknod,
>  	.rename		= shmem_rename,
>  	.whiteout       = shmem_whiteout,
> +	.fallthru       = shmem_fallthru,
>  #endif
>  #ifdef CONFIG_TMPFS_POSIX_ACL
>  	.setattr	= shmem_notify_change,
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Erez.
