Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYC3SwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYC3SwE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 14:52:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYC3Svw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 14:51:52 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38314 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbYC3Svw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 14:51:52 -0400
Subject: Re: [patch 7/7] vfs: mountinfo: show dominating group id
From: Ram Pai <linuxram@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080327122400.595798095@szeredi.hu>
References: <20080327120619.031944658@szeredi.hu>
	 <20080327122400.595798095@szeredi.hu>
Content-Type: text/plain
Date: Sun, 30 Mar 2008 11:51:57 -0700
Message-Id: <1206903118.3694.13.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 13:06 +0100, Miklos Szeredi wrote:
> plain text document attachment (mountinfo_dominator.patch)
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Show peer group ID of nearest dominating group that has intersection
> with the mount's namespace.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  Documentation/filesystems/proc.txt |    6 ++++
>  fs/namespace.c                     |    9 +++++-
>  fs/pnode.c                         |   51 +++++++++++++++++++++++++++++++++++++
>  fs/pnode.h                         |    1 
>  4 files changed, 65 insertions(+), 2 deletions(-)
> 
> Index: vfs-2.6/Documentation/filesystems/proc.txt
> ===================================================================
> --- vfs-2.6.orig/Documentation/filesystems/proc.txt	2008-03-27 12:06:15.000000000 +0100
> +++ vfs-2.6/Documentation/filesystems/proc.txt	2008-03-27 12:06:17.000000000 +0100
> @@ -2374,8 +2374,14 @@ possible optional fields are:
> 
>  shared:X  mount is shared in peer group X
>  master:X  mount is slave to peer group X
> +propagate_from:X  mount is slave and receives propagation from peer group X (*)
>  unbindable  mount is unbindable
> 
> +(*) X is the closest dominant peer group under the process's root.  If
> +X is the immediate master of the mount, or if there's no dominant peer
> +group under the same root, then only the "master:X" field is present
> +and not the "propagate_from:X" field.
> +
>  For more information on mount propagation see:
> 
>    Documentation/filesystems/sharedsubtree.txt
> Index: vfs-2.6/fs/namespace.c
> ===================================================================
> --- vfs-2.6.orig/fs/namespace.c	2008-03-27 12:06:15.000000000 +0100
> +++ vfs-2.6/fs/namespace.c	2008-03-27 12:06:17.000000000 +0100
> @@ -836,8 +836,13 @@ static int show_mountinfo(struct seq_fil
>  	/* Tagged fields ("foo:X" or "bar") */
>  	if (IS_MNT_SHARED(mnt))
>  		seq_printf(m, " shared:%i", mnt->mnt_group_id);
> -	if (IS_MNT_SLAVE(mnt))
> -		seq_printf(m, " master:%i", mnt->mnt_master->mnt_group_id);
> +	if (IS_MNT_SLAVE(mnt)) {
> +		int master = mnt->mnt_master->mnt_group_id;
> +		int dom = get_dominating_id(mnt, &p->root);
> +		seq_printf(m, " master:%i", master);
> +		if (dom && dom != master)
> +			seq_printf(m, " propagate_from:%i", dom);
> +	}
>  	if (IS_MNT_UNBINDABLE(mnt))
>  		seq_puts(m, " unbindable");
> 
> Index: vfs-2.6/fs/pnode.c
> ===================================================================
> --- vfs-2.6.orig/fs/pnode.c	2008-03-27 12:06:10.000000000 +0100
> +++ vfs-2.6/fs/pnode.c	2008-03-27 12:06:17.000000000 +0100
> @@ -28,6 +28,57 @@ static inline struct vfsmount *next_slav
>  	return list_entry(p->mnt_slave.next, struct vfsmount, mnt_slave);
>  }
> 
> +/*
> + * Return true if path is reachable from root
> + *
> + * namespace_sem is held, and mnt is attached
> + */
> +static bool is_path_reachable(struct vfsmount *mnt, struct dentry *dentry,
> +			 const struct path *root)
> +{
> +	while (mnt != root->mnt && mnt->mnt_parent != mnt) {
> +		dentry = mnt->mnt_mountpoint;
> +		mnt = mnt->mnt_parent;
> +	}
> +	return mnt == root->mnt && is_subdir(dentry, root->dentry);
> +}


This function belongs somewhere else, maybe namespace.c since it has
nothing to do with propagation and is generally provides a useful
service.

RP




