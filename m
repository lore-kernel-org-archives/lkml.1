Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZKDDyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZKDDyM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 22:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZKDDyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 22:54:12 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33700 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbZKDDyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 22:54:11 -0500
Date: Tue, 3 Nov 2009 21:54:13 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 07/13] sysfs: Update s_iattr on link and unlink.
Message-ID: <20091104035413.GD27639@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <1257249429-12384-7-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257249429-12384-7-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Currently sysfs updates the timestamps on the vfs directory
> inode when we create or remove a directory entry but doesn't
> update the cached copy on the sysfs_dirent, fix that oversight.

confused... why not do this in sysfs_addrm_finish()?

I guess you'd have to do at it at top before dropping sysfs_mutex
so it wouldn't be as pretty as I was thinking, but at least you
could just do it once.

> 
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  fs/sysfs/dir.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
> index b5e8499..fa37126 100644
> --- a/fs/sysfs/dir.c
> +++ b/fs/sysfs/dir.c
> @@ -464,6 +464,8 @@ void sysfs_addrm_start(struct sysfs_addrm_cxt *acxt,
>   */
>  int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  {
> +	struct sysfs_inode_attrs *ps_iattr;
> +
>  	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
>  		return -EEXIST;
> 
> @@ -476,6 +478,13 @@ int __sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> 
>  	sysfs_link_sibling(sd);
> 
> +	/* Update timestamps on the parent */
> +	ps_iattr = acxt->parent_sd->s_iattr;
> +	if (ps_iattr) {
> +		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
> +		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
> +	}
> +
>  	return 0;
>  }
> 
> @@ -554,10 +563,19 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>   */
>  void sysfs_remove_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
>  {
> +	struct sysfs_inode_attrs *ps_iattr;
> +
>  	BUG_ON(sd->s_flags & SYSFS_FLAG_REMOVED);
> 
>  	sysfs_unlink_sibling(sd);
> 
> +	/* Update timestamps on the parent */
> +	ps_iattr = acxt->parent_sd->s_iattr;
> +	if (ps_iattr) {
> +		struct iattr *ps_iattrs = &ps_iattr->ia_iattr;
> +		ps_iattrs->ia_ctime = ps_iattrs->ia_mtime = CURRENT_TIME;
> +	}
> +
>  	sd->s_flags |= SYSFS_FLAG_REMOVED;
>  	sd->s_sibling = acxt->removed;
>  	acxt->removed = sd;
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
