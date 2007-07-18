Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXGROBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXGROBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757099AbXGROBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:01:07 -0400
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:53132 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756935AbXGROBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:01:06 -0400
Date: Wed, 18 Jul 2007 16:02:11 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: fix sysfs root inode nlink accounting
Message-ID: <20070718160211.3bbc3c1c@hyperion.delvare>
In-Reply-To: <20070718052906.GG23568@htj.dyndns.org>
References: <20070715124232.4e371bf9@hyperion.delvare>
	<20070717034844.GB11602@suse.de>
	<20070717131255.71b7e72e@hyperion.delvare>
	<20070717183652.GG9702@suse.de>
	<20070717230530.64d9a896@hyperion.delvare>
	<20070718052906.GG23568@htj.dyndns.org>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, 18 Jul 2007 14:29:06 +0900, Tejun Heo wrote:
> While making sysfs indoes hashed, sysfs root inode was left out.  Now
> that nlink accounting depends on the inode being on the hash, sysfs
> root inode nlink isn't adjusted properly.
> 
> Put sysfs root inode on the inode hash by allocating it using
> sysfs_get_inode() like other sysfs inodes.  While at it, massage
> comments a bit.

This fixed my problem as expected. Thanks a lot!

> Signed-off-by: Tejun Heo <htejun@gmail.com>

For what it's worth:

Acked-by: Jean Delvare <khali@linux-fr.org>

> ---
>  fs/sysfs/mount.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> Index: work/fs/sysfs/mount.c
> ===================================================================
> --- work.orig/fs/sysfs/mount.c
> +++ work/fs/sysfs/mount.c
> @@ -43,19 +43,19 @@ static int sysfs_fill_super(struct super
>  	sb->s_time_gran = 1;
>  	sysfs_sb = sb;
>  
> -	inode = new_inode(sysfs_sb);
> +	/* get root inode, initialize and unlock it */
> +	inode = sysfs_get_inode(&sysfs_root);
>  	if (!inode) {
>  		pr_debug("sysfs: could not get root inode\n");
>  		return -ENOMEM;
>  	}
>  
> -	sysfs_init_inode(&sysfs_root, inode);
> -
>  	inode->i_op = &sysfs_dir_inode_operations;
>  	inode->i_fop = &sysfs_dir_operations;
> -	/* directory inodes start off with i_nlink == 2 (for "." entry) */
> -	inc_nlink(inode);
> +	inc_nlink(inode); /* directory, account for "." */
> +	unlock_new_inode(inode);
>  
> +	/* instantiate and link root dentry */
>  	root = d_alloc_root(inode);
>  	if (!root) {
>  		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);


-- 
Jean Delvare
