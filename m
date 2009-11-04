Return-Path: <linux-kernel-owner+w=401wt.eu-S1756587AbZKDO1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587AbZKDO1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 09:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756573AbZKDO1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 09:27:30 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:47138 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756513AbZKDO13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 09:27:29 -0500
Date: Wed, 4 Nov 2009 08:27:16 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>
Subject: Re: [PATCH 15/13] sysfs: Protect sysfs_refresh_inode with inode
	mutex.
Message-ID: <20091104142716.GD4355@us.ibm.com>
References: <m13a4vbz8r.fsf@fess.ebiederm.org> <m1hbta1onf.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbta1onf.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> 
> In general everything that writes to vfs inodes holds the
> inode mutex, so hold the inode mutex over sysfs_refresh_inode.
> The sysfs data structures don't need this but it looks like the
> vfs might.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

Oh right so pls disregard my last reply to patch 9 :)


Acked-by: Serge Hallyn <serue@us.ibm.com>

> ---
>  fs/sysfs/inode.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/sysfs/inode.c b/fs/sysfs/inode.c
> index e2595a7..ad549f5 100644
> --- a/fs/sysfs/inode.c
> +++ b/fs/sysfs/inode.c
> @@ -240,9 +240,11 @@ int sysfs_getattr(struct vfsmount *mnt, struct dentry *dentry, struct kstat *sta
>  	struct sysfs_dirent *sd = dentry->d_fsdata;
>  	struct inode *inode = dentry->d_inode;
> 
> +	mutex_lock(&inode->i_mutex);
>  	mutex_lock(&sysfs_mutex);
>  	sysfs_refresh_inode(sd, inode);
>  	mutex_unlock(&sysfs_mutex);
> +	mutex_unlock(&inode->i_mutex);
> 
>  	generic_fillattr(inode, stat);
>  	return 0;
> @@ -353,9 +355,11 @@ int sysfs_permission(struct inode *inode, int mask)
>  {
>  	struct sysfs_dirent *sd = inode->i_private;
> 
> +	mutex_lock(&inode->i_mutex);
>  	mutex_lock(&sysfs_mutex);
>  	sysfs_refresh_inode(sd, inode);
>  	mutex_unlock(&sysfs_mutex);
> +	mutex_unlock(&inode->i_mutex);
> 
>  	return generic_permission(inode, mask, NULL);
>  }
> -- 
> 1.6.5.2.143.g8cc62
