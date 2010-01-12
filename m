Return-Path: <linux-kernel-owner+w=401wt.eu-S1752986Ab0ALF4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab0ALF4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751402Ab0ALF4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:56:45 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56789 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0ALF4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:56:45 -0500
Date: Mon, 11 Jan 2010 23:56:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 3/7] sysfs: Keep an nlink count on sysfs directories.
Message-ID: <20100112055641.GB10756@us.ibm.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
 <1263241315-19499-3-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263241315-19499-3-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> On large directories sysfs_count_nlinks can be a significant
> bottleneck, so keep a count in sysfs_dirent.  If we exceed
> the maximum number of directory entries we can store return
> nlink of 1.  An nlink of 1 matches what reiserfs does in
> this case, and it let's find and similar utlities know that
> we have a the directory nlink can not be used for optimization
> purposes.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/dir.c   |   20 ++++++++++++++++++++
>  fs/sysfs/inode.c |   15 +--------------
>  fs/sysfs/mount.c |    1 +
>  fs/sysfs/sysfs.h |    1 +
>  4 files changed, 23 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index 5c4703d..1c364be 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -359,6 +359,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
>  	sd->s_name = name;
>  	sd->s_mode = mode;
>  	sd->s_flags = type;
> +	sd->s_nlink = type == SYSFS_DIR? 2:1;
> 
>  	return sd;
> 
> @@ -392,6 +393,23 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
>  	mutex_lock(&sysfs_mutex);
>  }
> 
> +static void sysfs_dir_inc_nlink(struct sysfs_dirent *sd)
> +{
> +	/* If we overflow force nlink to be 1 */
> +	if (sd->s_nlink > 1) {
> +		sd->s_nlink++;
> +		if (sd->s_nlink == 0)
> +			sd->s_nlink = 1;
> +	}
> +}

Now, the original code only ups nlink on parent if child is a dir.
IIUC your code will now inc nlink for files as well.  Is any userspace
going to be confused by that?

> +
> +static void sysfs_dir_dec_nlink(struct sysfs_dirent *sd)
> +{
> +	/* Don't decrement if we overflowed an increment */
> +	if (sd->s_nlink != 1)
> +		sd->s_nlink--;
> +}
> +
>  /**
>   *	__sysfs_add_one - add sysfs_dirent to parent without warning
>   *	@acxt: addrm context to use
> @@ -420,6 +438,7 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  		return -EEXIST;
> 
>  	sd->s_parent = sysfs_get(acxt->parent_sd);
> +	sysfs_dir_inc_nlink(sd->s_parent);
> 
>  	sysfs_link_sibling(sd);
> 
> @@ -512,6 +531,7 @@ void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> 
>  	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
> 
> +	sysfs_dir_dec_nlink(sd->s_parent);
>  	sysfs_unlink_sibling(sd);
> 
>  	/* Update timestamps on the parent */
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 104cbc1..f0172b3 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -201,18 +201,6 @@ static inline void set_inode_attr(struct inode * inode, struct iattr * iattr)
>  	inode->i_ctime = iattr->ia_ctime;
>  }
> 
> -static int sysfs_count_nlink(struct sysfs_dirent *sd)
> -{
> -	struct sysfs_dirent *child;
> -	int nr = 0;
> -
> -	for (child = sd->s_dir.children; child; child = child->s_sibling)
> -		if (sysfs_type(child) == SYSFS_DIR)
> -			nr++;
> -
> -	return nr + 2;
> -}
> -
>  static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
>  {
>  	struct sysfs_inode_attrs *iattrs = sd->s_iattr;
> @@ -228,8 +216,7 @@ static void sysfs_refresh_inode(struct sysfs_dirent *sd, struct inode *inode)
>  					    iattrs->ia_secdata_len);
>  	}
> 
> -	if (sysfs_type(sd) == SYSFS_DIR)
> -		inode->i_nlink = sysfs_count_nlink(sd);
> +	inode->i_nlink = sd->s_nlink;
>  }
> 
>  int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *stat)
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 4974995..372a32c 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -37,6 +37,7 @@ struct sysfs_dirent sysfs_root = {
>  	.s_count	= ATOMIC_INIT(1),
>  	.s_flags	= SYSFS_DIR,
>  	.s_mode		= S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO,
> +	.s_nlink	= 2,
>  	.s_ino		= 1,
>  };
> 
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index 0417805..85d5c6c 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -67,6 +67,7 @@ struct sysfs_dirent {
> 
>  	unsigned int		s_flags;
>  	unsigned short		s_mode;
> +	unsigned short		s_nlink;
>  	ino_t			s_ino;
>  	struct sysfs_inode_attrs *s_iattr;
>  };
> -- 
> 1.6.5.2.143.g8cc62
