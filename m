Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523Ab0ALRn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0ALRn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 12:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753649Ab0ALRn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 12:43:56 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:50056 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753527Ab0ALRn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 12:43:56 -0500
Date: Tue, 12 Jan 2010 11:43:53 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 6/7] sysfs: Pass super_block to sysfs_get_inode
Message-ID: <20100112174353.GC13506@us.ibm.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
 <1263241315-19499-6-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263241315-19499-6-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Currently sysfs_get_inode magically returns an inode on
> sysfs_sb.  Make the super_block parameter explicit and
> the code becomes clearer.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/dir.c   |    2 +-
>  fs/sysfs/inode.c |    5 +++--
>  fs/sysfs/mount.c |    2 +-
>  fs/sysfs/sysfs.h |    2 +-
>  4 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 1c364be..a491c72 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -701,7 +701,7 @@ static struct dentry * sysfs_lookup(struct inode *dir, struct dentry *dentry,
>  	}
> 
>  	/* attach dentry and inode */
> -	inode = sysfs_get_inode(sd);
> +	inode = sysfs_get_inode(dir->i_sb, sd);
>  	if (!inode) {
>  		ret = ERR_PTR(-ENOMEM);
>  		goto out_unlock;
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index f0172b3..487e33c 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -271,6 +271,7 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
> 
>  /**
>   *	sysfs_get_inode - get inode for sysfs_dirent
> + *	@sb: super block
>   *	@sd: sysfs_dirent to allocate inode for
>   *
>   *	Get inode for @sd.  If such inode doesn't exist, a new inode
> @@ -283,11 +284,11 @@ static void sysfs_init_inode(struct sysfs_dirent *sd, struct inode *inode)
>   *	RETURNS:
>   *	Pointer to allocated inode on success, NULL on failure.
>   */
> -struct inode * sysfs_get_inode(struct sysfs_dirent *sd)
> +struct inode * sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd)
>  {
>  	struct inode *inode;
> 
> -	inode = iget_locked(sysfs_sb, sd->s_ino);
> +	inode = iget_locked(sb, sd->s_ino);
>  	if (inode && (inode->i_state & I_NEW))
>  		sysfs_init_inode(sd, inode);
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 372a32c..77bce54 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -55,7 +55,7 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
> 
>  	/* get root inode, initialize and unlock it */
>  	mutex_lock(&sysfs_mutex);
> -	inode = sysfs_get_inode(&sysfs_root);
> +	inode = sysfs_get_inode(sb, &sysfs_root);
>  	mutex_unlock(&sysfs_mutex);
>  	if (!inode) {
>  		pr_debug("sysfs: could not get root inode\n");
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 85d5c6c..1ae6009 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -169,7 +169,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
>  /*
>   * inode.c
>   */
> -struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
> +struct inode *sysfs_get_inode(struct super_block *sb, struct sysfs_dirent *sd);
>  void sysfs_delete_inode(struct inode *inode);
>  int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
>  int sysfs_permission(struct inode *inode, int mask);
> -- 
> 1.6.5.2.143.g8cc62
