Return-Path: <linux-kernel-owner+w=401wt.eu-S1752589Ab0ALFlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab0ALFlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 00:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445Ab0ALFlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 00:41:46 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56926 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0ALFlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 00:41:45 -0500
Date: Mon, 11 Jan 2010 23:41:41 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Eric Dumazet <eric.dumazet@gmail.com>, Benjamin LaHaise <bcrl@lhnet.ca>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 1/7] sysfs: Serialize updates to the vfs inode
Message-ID: <20100112054141.GA10756@us.ibm.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
 <1263241315-19499-1-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263241315-19499-1-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> The way the vfs is structured only calls to the filesystem
> methods actually update the vfs inode.  We add to the
> normal number of places where the vfs inode is updated by
> also updating the vfs inode in sysfs_refresh_inode.
> 
> Grabbing the inode mutex in sysfs_permission and sysfs_getattr
> causes deadlocks, because somtimes those operations are called
> with the inode mutex held, but not always.  Therefore we can
> not depend upon the inode mutex to serialize all updates
> to the vfs inode.
> 
> We take the sysfs_mutex in all of those places so we can
> also use it to protect the vfs inode.  To accomplish that
> we simply requires extending the vfs inode in sysfs_setattr
> over inode_change_ok (so we have an unchanging inode
> when we perform the check), and inode_setattr.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

I'm a little confused about the patch intro:  it makes it sound
like this is preparatory for a followup, but in fact it is a bugfix,
right?  Hard to exploit i think, but should it go to -stable?

Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/inode.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index 220b758..104cbc1 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -112,20 +112,20 @@ int sysfs_setattr(struct dentry *dentry, struct iattr *iattr)
>  	if (!sd)
>  		return -EINVAL;
> 
> +	mutex_lock(&sysfs_mutex);
>  	error = inode_change_ok(inode, iattr);
>  	if (error)
> -		return error;
> +		goto out;
> 
>  	iattr->ia_valid &= ~ATTR_SIZE; /* ignore size changes */
> 
>  	error = inode_setattr(inode, iattr);
>  	if (error)
> -		return error;
> +		goto out;
> 
> -	mutex_lock(&sysfs_mutex);
>  	error = sysfs_sd_setattr(sd, iattr);
> +out:
>  	mutex_unlock(&sysfs_mutex);
> -
>  	return error;
>  }
> 
> -- 
> 1.6.5.2.143.g8cc62
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
