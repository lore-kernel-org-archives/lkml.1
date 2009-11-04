Return-Path: <linux-kernel-owner+w=401wt.eu-S1754689AbZKDEcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754689AbZKDEcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:32:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754430AbZKDEct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:32:49 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58778 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbZKDEcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:32:48 -0500
Date: Tue, 3 Nov 2009 22:32:49 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 11/13] sysfs: Gut sysfs_addrm_start and
	sysfs_addrm_finish
Message-ID: <20091104043249.GG27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-11-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-11-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> With lazy inode updates and dentry operations bringing everything
> into sync on demand there is no longer any need to immediately
> update the vfs or grab i_mutex to protect those updates as we
> make changes to sysfs.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/dir.c   |   91 ++---------------------------------------------------
>  fs/sysfs/sysfs.h |    2 -
>  2 files changed, 4 insertions(+), 89 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 25d052a..a05b027 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -386,12 +386,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
>  	return NULL;
>  }
> 
> -static int sysfs_ilookup_test(struct inode *inode, void *arg)
> -{
> -	struct sysfs_dirent *sd = arg;
> -	return inode->i_ino == sd->s_ino;
> -}
> -
>  /**
>   *	sysfs_addrm_start - prepare for sysfs_dirent add/remove
>   *	@acxt: pointer to sysfs_addrm_cxt to be used
> @@ -399,47 +393,20 @@ static int sysfs_ilookup_test(struct inode *inode, void *arg)
>   *
>   *	This function is called when the caller is about to add or
>   *	remove sysfs_dirent under @parent_sd.  This function acquires
> - *	sysfs_mutex, grabs inode for @parent_sd if available and lock
> - *	i_mutex of it.  @acxt is used to keep and pass context to
> + *	sysfs_mutex.  @acxt is used to keep and pass context to
>   *	other addrm functions.
>   *
>   *	LOCKING:
>   *	Kernel thread context (may sleep).  sysfs_mutex is locked on
> - *	return.  i_mutex of parent inode is locked on return if
> - *	available.
> + *	return.
>   */
>  void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
>  		       struct sysfs_dirent *parent_sd)
>  {
> -	struct inode *inode;
> -
>  	memset(acxt, 0, sizeof(*acxt));
>  	acxt->parent_sd = parent_sd;
> 
> -	/* Lookup parent inode.  inode initialization is protected by
> -	 * sysfs_mutex, so inode existence can be determined by
> -	 * looking up inode while holding sysfs_mutex.
> -	 */
>  	mutex_lock(&sysfs_mutex);
> -
> -	inode = ilookup5(sysfs_sb, parent_sd->s_ino, sysfs_ilookup_test,
> -			 parent_sd);
> -	if (inode) {
> -		WARN_ON(inode->i_state & I_NEW);
> -
> -		/* parent inode available */
> -		acxt->parent_inode = inode;
> -
> -		/* sysfs_mutex is below i_mutex in lock hierarchy.
> -		 * First, trylock i_mutex.  If fails, unlock
> -		 * sysfs_mutex and lock them in order.
> -		 */
> -		if (!mutex_trylock(&inode->i_mutex)) {
> -			mutex_unlock(&sysfs_mutex);
> -			mutex_lock(&inode->i_mutex);
> -			mutex_lock(&sysfs_mutex);
> -		}
> -	}
>  }
> 
>  /**
> @@ -471,11 +438,6 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> 
>  	sd->s_parent = sysfs_get(acxt->parent_sd);
> 
> -	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
> -		inc_nlink(acxt->parent_inode);
> -
> -	acxt->cnt++;
> -
>  	sysfs_link_sibling(sd);
> 
>  	/* Update timestamps on the parent */
> @@ -579,40 +541,6 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  	sd->s_flags |= SYSFS_FLAG_REMOVED;
>  	sd->s_sibling = acxt->removed;
>  	acxt->removed = sd;
> -
> -	if (sysfs_type(sd) == SYSFS_DIR && acxt->parent_inode)
> -		drop_nlink(acxt->parent_inode);
> -
> -	acxt->cnt++;
> -}
> -
> -/**
> - *	sysfs_dec_nlink - Decrement link count for the specified sysfs_dirent
> - *	@sd: target sysfs_dirent
> - *
> - *	Decrement nlink for @sd.  @sd must have been unlinked from its
> - *	parent on entry to this function such that it can't be looked
> - *	up anymore.
> - */
> -static void sysfs_dec_nlink(struct sysfs_dirent *sd)
> -{
> -	struct inode *inode;
> -
> -	inode = ilookup(sysfs_sb, sd->s_ino);
> -	if (!inode)
> -		return;
> -
> -	/* adjust nlink and update timestamp */
> -	mutex_lock(&inode->i_mutex);
> -
> -	inode->i_ctime = CURRENT_TIME;
> -	drop_nlink(inode);
> -	if (sysfs_type(sd) == SYSFS_DIR)
> -		drop_nlink(inode);
> -
> -	mutex_unlock(&inode->i_mutex);
> -
> -	iput(inode);
>  }
> 
>  /**
> @@ -621,25 +549,15 @@ static void sysfs_dec_nlink(struct sysfs_dirent *sd)
>   *
>   *	Finish up sysfs_dirent add/remove.  Resources acquired by
>   *	sysfs_addrm_start() are released and removed sysfs_dirents are
> - *	cleaned up.  Timestamps on the parent inode are updated.
> + *	cleaned up.
>   *
>   *	LOCKING:
> - *	All mutexes acquired by sysfs_addrm_start() are released.
> + *	sysfs_mutex is released.
>   */
>  void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
>  {
>  	/* release resources acquired by sysfs_addrm_start() */
>  	mutex_unlock(&sysfs_mutex);
> -	if (acxt->parent_inode) {
> -		struct inode *inode = acxt->parent_inode;
> -
> -		/* if added/removed, update timestamps on the parent */
> -		if (acxt->cnt)
> -			inode->i_ctime = inode->i_mtime = CURRENT_TIME;
> -
> -		mutex_unlock(&inode->i_mutex);
> -		iput(inode);
> -	}
> 
>  	/* kill removed sysfs_dirents */
>  	while (acxt->removed) {
> @@ -648,7 +566,6 @@ void sysfs_addrm_finish(struct sysfs_addrm_cxt *acxt)
>  		acxt->removed = sd->s_sibling;
>  		sd->s_sibling = NULL;
> 
> -		sysfs_dec_nlink(sd);
>  		sysfs_deactivate(sd);
>  		unmap_bin_file(sd);
>  		sysfs_put(sd);
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 12ccc07..90b3501 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -89,9 +89,7 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
>   */
>  struct sysfs_addrm_cxt {
>  	struct sysfs_dirent	*parent_sd;
> -	struct inode		*parent_inode;
>  	struct sysfs_dirent	*removed;
> -	int			cnt;
>  };
> 
>  /*
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
