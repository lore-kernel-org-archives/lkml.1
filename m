Return-Path: <linux-kernel-owner+w=401wt.eu-S1752196AbXBFNnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbXBFNnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 08:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbXBFNnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 08:43:46 -0500
Received: from styx.suse.cz ([82.119.242.94]:6385 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752183AbXBFNnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 08:43:45 -0500
Date: Tue, 6 Feb 2007 14:46:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@osdl.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-ID: <20070206134629.GG328@duck.suse.cz>
References: <20070206132333.GA9919@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206132333.GA9919@lst.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 06-02-07 14:23:33, Christoph Hellwig wrote:
> Iterate over sb->s_inodes instead of sb->s_files in add_dquot_ref.
> This reduces list search and lock hold time aswell as getting rid of
> one of the few uses of file_list_lock which Ingo identified as a
> scalability problem.
> 
> Previously we called dq_op->initialize for every inode handing of
> a writeable file that wasn't initialized before.  Now we're calling
> it for every inode that has a non-zero i_writecount, aka a writeable
> file descriptor refering to it.
> 
> Thanks a lot to Jan Kara for running this patch through his quota
> test harness.
> 
> Note:  this is ontop of '[PATCH] move remove_dquot_ref to dqout.c'
> which I sent out yesterday.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
  Signed-off-by: Jan Kara <jack@suse.cz>

> Index: linux-2.6/fs/dquot.c
> ===================================================================
> --- linux-2.6.orig/fs/dquot.c	2007-02-05 18:54:36.000000000 +0100
> +++ linux-2.6/fs/dquot.c	2007-02-05 18:59:48.000000000 +0100
> @@ -689,23 +689,27 @@
>  /* This routine is guarded by dqonoff_mutex mutex */
>  static void add_dquot_ref(struct super_block *sb, int type)
>  {
> -	struct list_head *p;
> +	struct inode *inode;
>  
>  restart:
> -	file_list_lock();
> -	list_for_each(p, &sb->s_files) {
> -		struct file *filp = list_entry(p, struct file, f_u.fu_list);
> -		struct inode *inode = filp->f_path.dentry->d_inode;
> -		if (filp->f_mode & FMODE_WRITE && dqinit_needed(inode, type)) {
> -			struct dentry *dentry = dget(filp->f_path.dentry);
> -			file_list_unlock();
> -			sb->dq_op->initialize(inode, type);
> -			dput(dentry);
> -			/* As we may have blocked we had better restart... */
> -			goto restart;
> -		}
> +	spin_lock(&inode_lock);
> +	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
> +		if (!atomic_read(&inode->i_writecount))
> +			continue;
> +		if (!dqinit_needed(inode, type))
> +			continue;
> +		if (inode->i_state & (I_FREEING|I_WILL_FREE))
> +			continue;
> +
> +		__iget(inode);
> +		spin_unlock(&inode_lock);
> +
> +		sb->dq_op->initialize(inode, type);
> +		iput(inode);
> +		/* As we may have blocked we had better restart... */
> +		goto restart;
>  	}
> -	file_list_unlock();
> +	spin_unlock(&inode_lock);
>  }
>  
>  /* Return 0 if dqput() won't block (note that 1 doesn't necessarily mean blocking) */

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
