Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYGAN7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYGAN7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:59:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753800AbYGAN7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:59:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbYGAN7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:59:09 -0400
Subject: Re: [patch resend] gfs2: don't call permission()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <E1KDfzL-0005GI-DP@pomaz-ex.szeredi.hu>
References: <E1K8DFJ-0006nQ-E7@pomaz-ex.szeredi.hu>
	 <E1KDfzL-0005GI-DP@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 Jul 2008 14:51:50 +0100
Message-Id: <1214920311.4011.80.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2008-07-01 at 15:33 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> GFS2 calls permission() to verify permissions after locks on the files
> have been taken.
> 
> For this it's sufficient to call gfs2_permission() instead.  This
> results in the following changes:
> 
>   - IS_RDONLY() check is not performed
>   - IS_IMMUTABLE() check is not performed
>   - devcgroup_inode_permission() is not called
>   - security_inode_permission() is not called
> 
> IS_RDONLY() should be unnecessary anyway, as the per-mount read-only
> flag should provide protection against read-only remounts during
> operations.  do_gfs2_set_flags() has been fixed to perform
> mnt_want_write()/mnt_drop_write() to protect against remounting
> read-only.
> 
> IS_IMMUTABLE has been added to gfs2_do_permission()
> 
> Repeating the security checks seems to be pointless, as they don't
> normally change, and if they do, it's independent of the filesystem
> state.
> 
> I also suspect the conditional locking in gfs2_do_permission() could
> be cleaned up, due to the removal of the implicit recursion.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/gfs2/inode.c     |    6 +++---
>  fs/gfs2/inode.h     |    1 +
>  fs/gfs2/ops_file.c  |   11 +++++++++--
>  fs/gfs2/ops_inode.c |   18 +++++++++++++-----
>  4 files changed, 26 insertions(+), 10 deletions(-)
> 

I've seen this patch drop into my inbox a number of times now. What is
the status of the rest of the patches in the original series?

I'm sorry that I've not got around to looking at this again a bit sooner
(due to holidays and various things) but bearing in mind that both
myself and Christoph have raised various points relating to this, it
would have been nice to have seen them addressed rather than having to
watch you post this via -mm and various other places, still in its
original form.

So going back to my original comment:

>> That looks ok, but I wonder do we really need gfs2_do_permission()
and
>> gfs2_permission when the only difference seems to be one argument?

>Later in this series ->permission() is changed to take a dentry as the
>first argument, so a separate function would've had to be reintroduced
>anyway.

Is this still true? or are the later patches changed now? Even so I
don't see why that means we need two functions there. I've lost track of
what the other patches status is.

Christoph: are you now happy with this patch as it stands?

Steve.


> Index: linux-2.6/fs/gfs2/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/gfs2/inode.c	2008-06-09 19:16:43.000000000 +0200
> +++ linux-2.6/fs/gfs2/inode.c	2008-06-09 21:10:11.000000000 +0200
> @@ -504,7 +504,7 @@ struct inode *gfs2_lookupi(struct inode 
>  	}
>  
>  	if (!is_root) {
> -		error = permission(dir, MAY_EXEC, NULL);
> +		error = gfs2_do_permission(dir, MAY_EXEC);
>  		if (error)
>  			goto out;
>  	}
> @@ -667,7 +667,7 @@ static int create_ok(struct gfs2_inode *
>  {
>  	int error;
>  
> -	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
> +	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
>  	if (error)
>  		return error;
>  
> @@ -1134,7 +1134,7 @@ int gfs2_unlink_ok(struct gfs2_inode *di
>  	if (IS_APPEND(&dip->i_inode))
>  		return -EPERM;
>  
> -	error = permission(&dip->i_inode, MAY_WRITE | MAY_EXEC, NULL);
> +	error = gfs2_do_permission(&dip->i_inode, MAY_WRITE | MAY_EXEC);
>  	if (error)
>  		return error;
>  
> Index: linux-2.6/fs/gfs2/inode.h
> ===================================================================
> --- linux-2.6.orig/fs/gfs2/inode.h	2008-06-09 19:16:43.000000000 +0200
> +++ linux-2.6/fs/gfs2/inode.h	2008-06-09 21:10:11.000000000 +0200
> @@ -91,6 +91,7 @@ int gfs2_rmdiri(struct gfs2_inode *dip, 
>  		struct gfs2_inode *ip);
>  int gfs2_unlink_ok(struct gfs2_inode *dip, const struct qstr *name,
>  		   const struct gfs2_inode *ip);
> +int gfs2_do_permission(struct inode *inode, int mask);
>  int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to);
>  int gfs2_readlinki(struct gfs2_inode *ip, char **buf, unsigned int *len);
>  int gfs2_glock_nq_atime(struct gfs2_holder *gh);
> Index: linux-2.6/fs/gfs2/ops_file.c
> ===================================================================
> --- linux-2.6.orig/fs/gfs2/ops_file.c	2008-06-09 19:16:43.000000000 +0200
> +++ linux-2.6/fs/gfs2/ops_file.c	2008-06-09 21:10:11.000000000 +0200
> @@ -15,6 +15,7 @@
>  #include <linux/uio.h>
>  #include <linux/blkdev.h>
>  #include <linux/mm.h>
> +#include <linux/mount.h>
>  #include <linux/fs.h>
>  #include <linux/gfs2_ondisk.h>
>  #include <linux/ext2_fs.h>
> @@ -220,10 +221,14 @@ static int do_gfs2_set_flags(struct file
>  	int error;
>  	u32 new_flags, flags;
>  
> -	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
> +	error = mnt_want_write(filp->f_path.mnt);
>  	if (error)
>  		return error;
>  
> +	error = gfs2_glock_nq_init(ip->i_gl, LM_ST_EXCLUSIVE, 0, &gh);
> +	if (error)
> +		goto out_drop_write;
> +
>  	flags = ip->i_di.di_flags;
>  	new_flags = (flags & ~mask) | (reqflags & mask);
>  	if ((new_flags ^ flags) == 0)
> @@ -242,7 +247,7 @@ static int do_gfs2_set_flags(struct file
>  	    !capable(CAP_LINUX_IMMUTABLE))
>  		goto out;
>  	if (!IS_IMMUTABLE(inode)) {
> -		error = permission(inode, MAY_WRITE, NULL);
> +		error = gfs2_do_permission(inode, MAY_WRITE);
>  		if (error)
>  			goto out;
>  	}
> @@ -272,6 +277,8 @@ out_trans_end:
>  	gfs2_trans_end(sdp);
>  out:
>  	gfs2_glock_dq_uninit(&gh);
> +out_drop_write:
> +	mnt_drop_write(filp->f_path.mnt);
>  	return error;
>  }
>  
> Index: linux-2.6/fs/gfs2/ops_inode.c
> ===================================================================
> --- linux-2.6.orig/fs/gfs2/ops_inode.c	2008-06-09 19:16:43.000000000 +0200
> +++ linux-2.6/fs/gfs2/ops_inode.c	2008-06-09 21:10:11.000000000 +0200
> @@ -163,7 +163,7 @@ static int gfs2_link(struct dentry *old_
>  	if (error)
>  		goto out;
>  
> -	error = permission(dir, MAY_WRITE | MAY_EXEC, NULL);
> +	error = gfs2_do_permission(dir, MAY_WRITE | MAY_EXEC);
>  	if (error)
>  		goto out_gunlock;
>  
> @@ -669,7 +669,7 @@ static int gfs2_rename(struct inode *odi
>  			}
>  		}
>  	} else {
> -		error = permission(ndir, MAY_WRITE | MAY_EXEC, NULL);
> +		error = gfs2_do_permission(ndir, MAY_WRITE | MAY_EXEC);
>  		if (error)
>  			goto out_gunlock;
>  
> @@ -704,7 +704,7 @@ static int gfs2_rename(struct inode *odi
>  	/* Check out the dir to be renamed */
>  
>  	if (dir_rename) {
> -		error = permission(odentry->d_inode, MAY_WRITE, NULL);
> +		error = gfs2_do_permission(odentry->d_inode, MAY_WRITE);
>  		if (error)
>  			goto out_gunlock;
>  	}
> @@ -891,7 +891,7 @@ static void *gfs2_follow_link(struct den
>   * Returns: errno
>   */
>  
> -static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
> +int gfs2_do_permission(struct inode *inode, int mask)
>  {
>  	struct gfs2_inode *ip = GFS2_I(inode);
>  	struct gfs2_holder i_gh;
> @@ -905,13 +905,21 @@ static int gfs2_permission(struct inode 
>  		unlock = 1;
>  	}
>  
> -	error = generic_permission(inode, mask, gfs2_check_acl);
> +	if ((mask & MAY_WRITE) && IS_IMMUTABLE(inode))
> +		error = -EACCES;
> +	else
> +		error = generic_permission(inode, mask, gfs2_check_acl);
>  	if (unlock)
>  		gfs2_glock_dq_uninit(&i_gh);
>  
>  	return error;
>  }
>  
> +static int gfs2_permission(struct inode *inode, int mask, struct nameidata *nd)
> +{
> +	return gfs2_do_permission(inode, mask);
> +}
> +
>  static int setattr_size(struct inode *inode, struct iattr *attr)
>  {
>  	struct gfs2_inode *ip = GFS2_I(inode);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

