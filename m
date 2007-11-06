Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbXKFJBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbXKFJBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 04:01:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbXKFJBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 04:01:04 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:57024 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbXKFJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 04:01:03 -0500
Date: Tue, 6 Nov 2007 10:01:02 +0100
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <haveblue@us.ibm.com>, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH 16/27] r-o-bind-mounts-elevate-write-count-for-some-ioctls
Message-ID: <20071106090102.GA32704@atrey.karlin.mff.cuni.cz>
References: <20071101230826.9A4F6E00@kernel> <20071101230847.1CD52DBD@kernel> <20071105152346.9060641a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105152346.9060641a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 01 Nov 2007 16:08:47 -0700
> Dave Hansen <haveblue@us.ibm.com> wrote:
> 
> > Some ioctl()s can cause writes to the filesystem.  Take these, and make them
> > use mnt_want/drop_write() instead.
> > 
> > We need to pass the filp one layer deeper in XFS, but somebody _just_ pulled
> > it out in February because nobody was using it, so I don't feel guilty for
> > adding it back.
> 
> See, when we combine this patch with Jan's
> forbid-user-to-change-file-flags-on-quota-files.patch we silently add bugs
> to five filesystems.  Lessons:
> 
> - never ever ever do `return' from deep in the guts of a function.  This
>   is a *classic* instance of the maintainability risks which this practice
>   introduces.
  OK, lesson learned ;) Thanks for spotting this. But if there already
was a label like:

err_out:
   return err;

  And I would have just added a place which does 'goto err_out', then
the same problem could arise... But I agree it's less likely than if we
do just return err;.

> - this whole elevate-the-write-count-in-a-zillion-places stuff is quite
>   fragile.
> 
> diff -puN fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files fs/ext2/ioctl.c
> --- a/fs/ext2/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext2/ioctl.c
> @@ -57,7 +57,8 @@ int ext2_ioctl (struct inode * inode, st
>  		/* Is it quota file? Do not allow user to mess with it */
>  		if (IS_NOQUOTA(inode)) {
>  			mutex_unlock(&inode->i_mutex);
> -			return -EPERM;
> +			ret = -EPERM;
> +			goto setflags_out;
>  		}
>  		oldflags = ei->i_flags;
>  
> diff -puN fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files fs/ext3/ioctl.c
> --- a/fs/ext3/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext3/ioctl.c
> @@ -60,7 +60,8 @@ int ext3_ioctl (struct inode * inode, st
>  		/* Is it quota file? Do not allow user to mess with it */
>  		if (IS_NOQUOTA(inode)) {
>  			mutex_unlock(&inode->i_mutex);
> -			return -EPERM;
> +			err = -EPERM;
> +			goto flags_out;
>  		}
>  		oldflags = ei->i_flags;
>  
> diff -puN fs/ext4/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files fs/ext4/ioctl.c
> --- a/fs/ext4/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/ext4/ioctl.c
> @@ -59,7 +59,8 @@ int ext4_ioctl (struct inode * inode, st
>  		/* Is it quota file? Do not allow user to mess with it */
>  		if (IS_NOQUOTA(inode)) {
>  			mutex_unlock(&inode->i_mutex);
> -			return -EPERM;
> +			err = -EPERM;
> +			goto flags_out;
>  		}
>  		oldflags = ei->i_flags;
>  
> diff -puN fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files fs/jfs/ioctl.c
> --- a/fs/jfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files
> +++ a/fs/jfs/ioctl.c
> @@ -85,8 +85,10 @@ int jfs_ioctl(struct inode * inode, stru
>  			flags &= ~JFS_DIRSYNC_FL;
>  
>  		/* Is it quota file? Do not allow user to mess with it */
> -		if (IS_NOQUOTA(inode))
> -			return -EPERM;
> +		if (IS_NOQUOTA(inode)) {
> +			err = -EPERM;
> +			goto setflags_out;
> +		}
>  		jfs_get_inode_flags(jfs_inode);
>  		oldflags = jfs_inode->mode2;
>  
> diff -puN fs/reiserfs/ioctl.c~r-o-bind-mounts-elevate-write-count-for-some-ioctls-vs-forbid-user-to-change-file-flags-on-quota-files fs/reiserfs/ioctl.c
> _
  Why there's no modification for reiserfs?

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
