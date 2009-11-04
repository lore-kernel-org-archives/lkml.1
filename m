Return-Path: <linux-kernel-owner+w=401wt.eu-S1754644AbZKDEXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644AbZKDEXo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754472AbZKDEXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:23:43 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34861 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZKDEXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:23:42 -0500
Date: Tue, 3 Nov 2009 22:23:45 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 10/13] sysfs: In sysfs_chmod_file lazily propagate the
	mode change.
Message-ID: <20091104042345.GF27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-10-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-10-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Now that sysfs_getattr and sysfs_permission refresh the vfs
> inode there is no need to immediatly push the mode change
> into the vfs cache.  Reducing the amount of work needed and
> simplifying the locking.
> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Nice.

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/file.c |   31 ++++++++-----------------------
>  1 files changed, 8 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index faa1a80..dc30d9e 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -579,38 +579,23 @@ EXPORT_SYMBOL_GPL(sysfs_add_file_to_group);
>   */
>  int sysfs_chmod_file(struct kobject *kobj, struct attribute *attr, mode_t mode)
>  {
> -	struct sysfs_dirent *victim_sd = NULL;
> -	struct dentry *victim = NULL;
> -	struct inode * inode;
> +	struct sysfs_dirent *sd;
>  	struct iattr newattrs;
>  	int rc;
> 
> -	rc = -ENOENT;
> -	victim_sd = sysfs_get_dirent(kobj->sd, attr->name);
> -	if (!victim_sd)
> -		goto out;
> +	mutex_lock(&sysfs_mutex);
> 
> -	mutex_lock(&sysfs_rename_mutex);
> -	victim = sysfs_get_dentry(victim_sd);
> -	mutex_unlock(&sysfs_rename_mutex);
> -	if (IS_ERR(victim)) {
> -		rc = PTR_ERR(victim);
> -		victim = NULL;
> +	rc = -ENOENT;
> +	sd = sysfs_find_dirent(kobj->sd, attr->name);
> +	if (!sd)
>  		goto out;
> -	}
> -
> -	inode = victim->d_inode;
> 
> -	mutex_lock(&inode->i_mutex);
> -
> -	newattrs.ia_mode = (mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
> +	newattrs.ia_mode = (mode & S_IALLUGO) | (sd->s_mode & ~S_IALLUGO);
>  	newattrs.ia_valid = ATTR_MODE;
> -	rc = sysfs_setattr(victim, &newattrs);
> +	rc = sysfs_sd_setattr(sd, &newattrs);
> 
> -	mutex_unlock(&inode->i_mutex);
>   out:
> -	dput(victim);
> -	sysfs_put(victim_sd);
> +	mutex_unlock(&sysfs_mutex);
>  	return rc;
>  }
>  EXPORT_SYMBOL_GPL(sysfs_chmod_file);
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
