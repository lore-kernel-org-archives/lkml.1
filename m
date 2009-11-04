Return-Path: <linux-kernel-owner+w=401wt.eu-S1754410AbZKDDQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410AbZKDDQc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:16:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZKDDQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:16:30 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:56608 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZKDDQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:16:29 -0500
Date: Tue, 3 Nov 2009 21:16:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 06/13] sysfs: Fix locking and factor out
	sysfs_sd_setattr
Message-ID: <20091104031632.GC27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-6-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-6-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Cleanly separate the work that is specific to setting the
> attributes of a sysfs_dirent from what is needed to update
> the attributes of a vfs inode.
> 
> Additionally grab the sysfs_mutex to keep any nasties from
> surprising us when updating the sysfs_dirent.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/inode.c |   52 ++++++++++++++++++++++++++++++++--------------------
>  fs/sysfs/sysfs.h |    1 +
>  2 files changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index fed7a74..fccfb55 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -64,30 +64,15 @@ struct sysfs_inode_attrs *sysfs_init_inode_attrs(struct sysfs_dirent *sd)
> 
>  	return attrs;
>  }
> -int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
> +
> +int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr * iattr)
>  {
> -	struct inode * inode = dentry->d_inode;
> -	struct sysfs_dirent * sd = dentry->d_fsdata;
>  	struct sysfs_inode_attrs *sd_attrs;
>  	struct iattr *iattrs;
>  	unsigned int ia_valid = iattr->ia_valid;
> -	int error;
> -
> -	if (!sd)
> -		return -EINVAL;
> 
>  	sd_attrs = sd->s_iattr;
> 
> -	error = inode_change_ok(inode, iattr);
> -	if (error)
> -		return error;
> -
> -	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
> -
> -	error = inode_setattr(inode, iattr);
> -	if (error)
> -		return error;
> -
>  	if (!sd_attrs) {
>  		/* setting attributes for the first time, allocate now */
>  		sd_attrs = sysfs_init_inode_attrs(sd);
> @@ -110,12 +95,39 @@ int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
>  			iattrs->ia_ctime = iattr->ia_ctime;
>  		if (ia_valid & ATTR_MODE) {
>  			umode_t mode = iattr->ia_mode;
> -
> -			if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> -				mode &= ~S_ISGID;
>  			iattrs->ia_mode = sd->s_mode = mode;
>  		}
>  	}
> +	return 0;
> +}
> +
> +int sysfs_setattr(struct dentry * dentry, struct iattr * iattr)
> +{
> +	struct inode * inode = dentry->d_inode;
> +	struct sysfs_dirent * sd = dentry->d_fsdata;
> +	int error;
> +
> +	if (!sd)
> +		return -EINVAL;
> +
> +	error = inode_change_ok(inode, iattr);
> +	if (error)
> +		return error;
> +
> +	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
> +	if (iattr->ia_valid & ATTR_MODE) {
> +		if (!in_group_p(inode->i_gid) && !capable(CAP_FSETID))
> +			iattr->ia_mode &= ~S_ISGID;
> +	}

Was it a bug that before this patch this wasn't cleared before the
actual inode_setattr()?

Since the S_ISGID will be set for the *new* gid, that is,
iattr->ia_gid, shouldn't the user be required to be
in_group_p(iattr->i_gid)?  Note you haven't done the
inode_setattr() yet.

> +
> +	error = inode_setattr(inode, iattr);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&sysfs_mutex);
> +	error = sysfs_sd_setattr(sd, iattr);
> +	mutex_unlock(&sysfs_mutex);
> +
>  	return error;
>  }
> 
> diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
> index af4c4e7..a96d967 100644
> --- a/fs/sysfs/sysfs.h
> +++ b/fs/sysfs/sysfs.h
> @@ -155,6 +155,7 @@ static inline void __sysfs_put(struct sysfs_dirent *sd)
>   */
>  struct inode *sysfs_get_inode(struct sysfs_dirent *sd);
>  void sysfs_delete_inode(struct inode *inode);
> +int sysfs_sd_setattr(struct sysfs_dirent *sd, struct iattr *iattr);
>  int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
>  int sysfs_setxattr(struct dentry *dentry, const char *name, const void *value,
>  		size_t size, int flags);
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
