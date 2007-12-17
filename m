Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXLQWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXLQWg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 17:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbXLQWgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 17:36:45 -0500
Received: from smtp112.sbc.mail.re2.yahoo.com ([68.142.229.93]:23619 "HELO
	smtp112.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755961AbXLQWgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 17:36:43 -0500
X-YMail-OSG: XypW1sIVM1nTwJYKugcN9q26T15nGZqL0LPn3RLmAZg8y1QrxvnIQgcwbQbw_cRbaaYu3MLjwGy7Uca5Jzv039D_hv_y6.dT4Xo_DGGcHtpSpESBg.x7qqTa5lKD9GVFBEeC8y4-
Date: Mon, 17 Dec 2007 16:28:54 -0600
From: serge@hallyn.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: alan@redhat.com, viro@zeniv.linux.org.uk, hch@infradead.org,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC/PATCH 2/8] revoke: inode revoke lock V7
Message-ID: <20071217222850.GA10076@vino.hallyn.com>
References: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712141715440.28689@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Pekka J Enberg (penberg@cs.helsinki.fi):
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The revoke operation cannibalizes the revoked struct inode and removes it from
> the inode cache thus forcing subsequent callers to look up the real inode.
> Therefore we must make sure that while the revoke operation is in progress
> (e.g. flushing dirty pages to disk) no one takes a new reference to the inode
> and starts I/O on it.
> 
> Cc: Alan Cox <alan@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  fs/inode.c         |    1 +
>  fs/namei.c         |   15 ++++++++++++++-
>  include/linux/fs.h |    3 +++
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> Index: 2.6/include/linux/fs.h
> ===================================================================
> --- 2.6.orig/include/linux/fs.h	2007-11-23 09:58:11.000000000 +0200
> +++ 2.6/include/linux/fs.h	2007-12-14 16:40:50.000000000 +0200
> @@ -150,6 +150,7 @@ #define MS_MGC_MSK 0xffff0000
>  #define S_NOCMTIME	128	/* Do not update file c/mtime */
>  #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
>  #define S_PRIVATE	512	/* Inode is fs-internal */
> +#define S_REVOKE_LOCK	1024	/* Inode is being revoked */
>  
>  /*
>   * Note that nosuid etc flags are inode-specific: setting some file-system
> @@ -183,6 +184,7 @@ #define MS_MGC_MSK 0xffff0000
>  #define IS_NOCMTIME(inode)	((inode)->i_flags & S_NOCMTIME)
>  #define IS_SWAPFILE(inode)	((inode)->i_flags & S_SWAPFILE)
>  #define IS_PRIVATE(inode)	((inode)->i_flags & S_PRIVATE)
> +#define IS_REVOKE_LOCKED(inode)	((inode)->i_flags & S_REVOKE_LOCK)
>  
>  /* the read-only stuff doesn't really belong here, but any other place is
>     probably as bad and I don't want to create yet another include file. */
> @@ -642,6 +644,7 @@ struct inode {
>  	struct list_head	inotify_watches; /* watches on this inode */
>  	struct mutex		inotify_mutex;	/* protects the watches list */
>  #endif
> +	wait_queue_head_t	i_revoke_wait;
>  
>  	unsigned long		i_state;
>  	unsigned long		dirtied_when;	/* jiffies of first dirtying */
> Index: 2.6/fs/inode.c
> ===================================================================
> --- 2.6.orig/fs/inode.c	2007-10-26 09:36:45.000000000 +0300
> +++ 2.6/fs/inode.c	2007-12-14 16:40:50.000000000 +0200
> @@ -216,6 +216,7 @@ 	memset(inode, 0, sizeof(*inode));
>  	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
>  	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
>  	i_size_ordered_init(inode);
> +	init_waitqueue_head(&inode->i_revoke_wait);
>  #ifdef CONFIG_INOTIFY
>  	INIT_LIST_HEAD(&inode->inotify_watches);
>  	mutex_init(&inode->inotify_mutex);
> Index: 2.6/fs/namei.c
> ===================================================================
> --- 2.6.orig/fs/namei.c	2007-10-26 09:36:48.000000000 +0300
> +++ 2.6/fs/namei.c	2007-12-14 16:40:50.000000000 +0200
> @@ -785,10 +785,23 @@ static int do_lookup(struct nameidata *n
>  		     struct path *path)
>  {
>  	struct vfsmount *mnt = nd->mnt;
> -	struct dentry *dentry = __d_lookup(nd->dentry, name);
> +	struct dentry *dentry;
>  
> +again:
> +	dentry  = __d_lookup(nd->dentry, name);
>  	if (!dentry)
>  		goto need_lookup;
> +
> +	if (dentry->d_inode && IS_REVOKE_LOCKED(dentry->d_inode)) {

Hi,

not sure whether this is a problem or not, but dentry->d_inode isn't
locked here, right?  So nothing is keeping do_lookup() returning
with an inode which gets revoked between here and the return 0
a few lines down?

> +		int err;
> +
> +		err = wait_event_interruptible(dentry->d_inode->i_revoke_wait,
> +			!IS_REVOKE_LOCKED(dentry->d_inode));
> +		if (err)
> +			return err;
> +		goto again;
> +	}
> +
>  	if (dentry->d_op && dentry->d_op->d_revalidate)
>  		goto need_revalidate;
>  done:
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
