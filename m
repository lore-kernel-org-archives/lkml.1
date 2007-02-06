Return-Path: <linux-kernel-owner+w=401wt.eu-S965594AbXBFXuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965594AbXBFXuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965593AbXBFXuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:50:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55657 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965592AbXBFXuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:50:12 -0500
Date: Tue, 6 Feb 2007 15:50:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Hellwig <hch@lst.de>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sb->s_files and file_list_lock usage in dquot.c
Message-Id: <20070206155001.22ab74f6.akpm@linux-foundation.org>
In-Reply-To: <20070206132333.GA9919@lst.de>
References: <20070206132333.GA9919@lst.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Feb 2007 14:23:33 +0100
Christoph Hellwig <hch@lst.de> wrote:

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

That loop has (and had) up to O(n^n) operations.  Is there something which
prevents this from going insane?
