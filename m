Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXEUFAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXEUFAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXEUFAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:00:36 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34988 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXEUFAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:00:35 -0400
Date: Mon, 21 May 2007 10:31:01 +0530
From: Maneesh Soni <maneesh@in.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH 2/2] sysfs: fix race condition around sd->s_dentry, take#2
Message-ID: <20070521050101.GC9214@in.ibm.com>
Reply-To: maneesh@in.ibm.com
References: <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com> <20070517120423.GE17712@kroah.com> <20070517173912.GA14370@in.ibm.com> <464C95AB.3020209@gmail.com> <464C9801.8000606@gmail.com> <464C9BEA.7060309@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464C9BEA.7060309@gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 08:16:10PM +0200, Tejun Heo wrote:
> Allowing attribute and symlink dentries to be reclaimed means
> sd->s_dentry can change dynamically.  However, updates to the field
> are unsynchronized leading to race conditions.  This patch adds
> sysfs_lock and use it to synchronize updates to sd->s_dentry.
> 
> Due to the locking around ->d_iput, the check in sysfs_drop_dentry()
> is complex.  sysfs_lock only protect sd->s_dentry pointer itself.  The
> validity of the dentry is protected by dcache_lock, so whether dentry
> is alive or not can only be tested while holding both locks.
> 
> This is minimal backport of sysfs_drop_dentry() rewrite in devel
> branch.
> 
> DONT APPLY JUST YET

Looks ok to me.. I have tested it it but unfortunately I couldn't
recreate the race without the patch also. It would be helpful if
people actually seeing the race, provide the test results.

Greg, please merge this one once we have some test results.

Regards,
Maneesh

> ---
> Moving sysfs_drop_dentry() and sysfs_put() calls out of mutex isn't
> necessary, so this is the minimal one but there shouldn't be
> any difference functionality-wise.
> 
>  fs/sysfs/dir.c   |   22 ++++++++++++++++++++--
>  fs/sysfs/inode.c |   18 +++++++++++++++++-
>  fs/sysfs/sysfs.h |    1 +
>  3 files changed, 38 insertions(+), 3 deletions(-)
> 
> Index: work/fs/sysfs/dir.c
> ===================================================================
> --- work.orig/fs/sysfs/dir.c
> +++ work/fs/sysfs/dir.c
> @@ -13,14 +13,26 @@
>  #include "sysfs.h"
> 
>  DECLARE_RWSEM(sysfs_rename_sem);
> +spinlock_t sysfs_lock = SPIN_LOCK_UNLOCKED;
> 
>  static void sysfs_d_iput(struct dentry * dentry, struct inode * inode)
>  {
>  	struct sysfs_dirent * sd = dentry->d_fsdata;
> 
>  	if (sd) {
> -		BUG_ON(sd->s_dentry != dentry);
> -		sd->s_dentry = NULL;
> +		/* sd->s_dentry is protected with sysfs_lock.  This
> +		 * allows sysfs_drop_dentry() to dereference it.
> +		 */
> +		spin_lock(&sysfs_lock);
> +
> +		/* The dentry might have been deleted or another
> +		 * lookup could have happened updating sd->s_dentry to
> +		 * point the new dentry.  Ignore if it isn't pointing
> +		 * to this dentry.
> +		 */
> +		if (sd->s_dentry == dentry)
> +			sd->s_dentry = NULL;
> +		spin_unlock(&sysfs_lock);
>  		sysfs_put(sd);
>  	}
>  	iput(inode);
> @@ -238,7 +250,10 @@ static int sysfs_attach_attr(struct sysf
>          }
> 
>  	dentry->d_fsdata = sysfs_get(sd);
> +	/* protect sd->s_dentry against sysfs_d_iput */
> +	spin_lock(&sysfs_lock);
>  	sd->s_dentry = dentry;
> +	spin_unlock(&sysfs_lock);
>  	error = sysfs_create(dentry, (attr->mode & S_IALLUGO) | S_IFREG, init);
>  	if (error) {
>  		sysfs_put(sd);
> @@ -260,7 +275,10 @@ static int sysfs_attach_link(struct sysf
>  	int err = 0;
> 
>  	dentry->d_fsdata = sysfs_get(sd);
> +	/* protect sd->s_dentry against sysfs_d_iput */
> +	spin_lock(&sysfs_lock);
>  	sd->s_dentry = dentry;
> +	spin_unlock(&sysfs_lock);
>  	err = sysfs_create(dentry, S_IFLNK|S_IRWXUGO, init_symlink);
>  	if (!err) {
>  		dentry->d_op = &sysfs_dentry_ops;
> Index: work/fs/sysfs/inode.c
> ===================================================================
> --- work.orig/fs/sysfs/inode.c
> +++ work/fs/sysfs/inode.c
> @@ -244,9 +244,23 @@ static inline void orphan_all_buffers(st
>   */
>  void sysfs_drop_dentry(struct sysfs_dirent * sd, struct dentry * parent)
>  {
> -	struct dentry * dentry = sd->s_dentry;
> +	struct dentry *dentry = NULL;
>  	struct inode *inode;
> 
> +	/* We're not holding a reference to ->s_dentry dentry but the
> +	 * field will stay valid as long as sysfs_lock is held.
> +	 */
> +	spin_lock(&sysfs_lock);
> +	spin_lock(&dcache_lock);
> +
> +	/* dget dentry if it's still alive */
> +	if (sd->s_dentry && sd->s_dentry->d_inode)
> +		dentry = dget_locked(sd->s_dentry);
> +
> +	spin_unlock(&dcache_lock);
> +	spin_unlock(&sysfs_lock);
> +
> +	/* drop dentry */
>  	if (dentry) {
>  		spin_lock(&dcache_lock);
>  		spin_lock(&dentry->d_lock);
> @@ -266,6 +280,8 @@ void sysfs_drop_dentry(struct sysfs_dire
>  			spin_unlock(&dentry->d_lock);
>  			spin_unlock(&dcache_lock);
>  		}
> +
> +		dput(dentry);
>  	}
>  }
> 
> Index: work/fs/sysfs/sysfs.h
> ===================================================================
> --- work.orig/fs/sysfs/sysfs.h
> +++ work/fs/sysfs/sysfs.h
> @@ -32,6 +32,7 @@ extern const unsigned char * sysfs_get_n
>  extern void sysfs_drop_dentry(struct sysfs_dirent *sd, struct dentry *parent);
>  extern int sysfs_setattr(struct dentry *dentry, struct iattr *iattr);
> 
> +extern spinlock_t sysfs_lock;
>  extern struct rw_semaphore sysfs_rename_sem;
>  extern struct super_block * sysfs_sb;
>  extern const struct file_operations sysfs_dir_operations;

-- 
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
