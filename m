Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbXITUgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbXITUgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 16:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbXITUgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 16:36:14 -0400
Received: from mail.fieldses.org ([66.93.2.214]:49098 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbXITUgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 16:36:14 -0400
Date: Thu, 20 Sep 2007 16:36:12 -0400
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH] Fix potential OOPS in generic_setlease() (v2)
Message-ID: <20070920203612.GG23287@fieldses.org>
References: <46F233E0.4090206@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F233E0.4090206@openvz.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OK, this version I can't see any more problem with.  Thanks!

--b.

On Thu, Sep 20, 2007 at 12:48:32PM +0400, Pavel Emelyanov wrote:
> This code is run under lock_kernel(), which is dropped during
> sleeping operations, so the following race is possible:
> 
> CPU1:                                CPU2:
>   vfs_setlease();                    vfs_setlease();
>   lock_kernel();
>                                      lock_kernel(); /* spin */
>   generic_setlease():
>     ...
>     for (before = ...)
>     /* here we found some lease after
>      * which we will insert the new one
>      */
>     fl = locks_alloc_lock();
>     /* go to sleep in this allocation and
>      * drop the BKL
>      */
>                                      generic_setlease():
>                                        ...
>                                        for (before = ...)
>                                        /* here we find the "before" pointing
>                                         * at the one we found on CPU1
>                                         */
>                                       ->fl_change(my_before, arg);
>                                               lease_modify();
>                                                      locks_free_lock();
>                                                      /* and we freed it */
>                                      ...
>                                      unlock_kernel();
>    locks_insert_lock(before, fl);
>    /* OOPS! We have just tried to add the lease
>     * at the tail of already removed one
>     */
> 
> The similar races are already handled in other code - all the 
> allocations are performed before any checks/updates.
> 
> Fixed the problem, spotted by J. Bruce Fields, about the fl
> variable reuse.
> 
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> 
> ---
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index a1c1c01..d5b9653 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1354,6 +1354,7 @@ int fcntl_getlease(struct file *filp)
>  int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  {
>  	struct file_lock *fl, **before, **my_before = NULL, *lease;
> +	struct file_lock *new_fl = NULL;
>  	struct dentry *dentry = filp->f_path.dentry;
>  	struct inode *inode = dentry->d_inode;
>  	int error, rdlease_count = 0, wrlease_count = 0;
> @@ -1380,6 +1381,11 @@ int generic_setlease(struct file *filp, 
>  		|| (atomic_read(&inode->i_count) > 1)))
>  		goto out;
>  
> +	error = -ENOMEM;
> +	new_fl = locks_alloc_lock();
> +	if (new_fl == NULL)
> +		goto out;
> +
>  	/*
>  	 * At this point, we know that if there is an exclusive
>  	 * lease on this file, then we hold it on this filp
> @@ -1422,18 +1428,15 @@ int generic_setlease(struct file *filp, 
>  	if (!leases_enable)
>  		goto out;
>  
> -	error = -ENOMEM;
> -	fl = locks_alloc_lock();
> -	if (fl == NULL)
> -		goto out;
> -
> -	locks_copy_lock(fl, lease);
> -
> -	locks_insert_lock(before, fl);
> +	locks_copy_lock(new_fl, lease);
> +	locks_insert_lock(before, new_fl);
>  
>  	*flp = fl;
> -	error = 0;
> +	return 0;
> +
>  out:
> +	if (new_fl != NULL)
> +		locks_free_lock(new_fl);
>  	return error;
>  }
>  EXPORT_SYMBOL(generic_setlease);
