Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYBKJI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYBKJI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYBKJIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:08:42 -0500
Received: from styx.suse.cz ([82.119.242.94]:47583 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750751AbYBKJI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:08:29 -0500
Subject: Re: [PATCH] proc: extend /proc/<pid>/fdinfo/<fd>
From: Miklos Szeredi <mszeredi@suse.cz>
To: Eugene Teo <eugeneteo@kernel.sg>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080209120157.GA3035@kernel.sg>
References: <20080209120157.GA3035@kernel.sg>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 10:08:27 +0100
Message-Id: <1202720907.4739.36.camel@tucsk.pomaz.szeredi.hu>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-02-09 at 20:01 +0800, Eugene Teo wrote:
> This patch extends /proc/<pid>/fdinfo/<fd> to report information about open
> files, and pathname. This information can be useful to know when debugging an
> application.
> 
> For each file descriptor, the information is provided in the following format:
> 
> kerndev: ~/code/kernel# cat /proc/`pgrep pickup`/fdinfo/6
> mode:   0622
> dev:    253,0
> ino:    21463057

These are already available via 'stat /proc/<pid>/fd/<fd>'

> uid:    89
> gid:    89

AFAICS file->f_[ug]id are only used by the netfilter code, but I guess
it wouldn't hurt to show them here.  But please add fields at the end of
the file, instead of the beggining.

> rdev:   0,0

This is in struct stat too.

> pos:    0
> flags:  04002 FD_CLOEXEC # if close-on-exec flag is set

FD_CLOEXEC should be on a separate line, because it's not an O_FOO flag.

> path:   /var/spool/postfix/public/pickup

readlink /proc/<pid>/fd/<fd>

Thanks,
Miklos

> 
> You can also use this to find out more information about locked open files:
> 
> kerndev: /proc# cat /proc/locks
> 1: POSIX  ADVISORY  WRITE 2663 fd:00:21398205 0 EOF
>                           ^^^^       ^^^^^^^^
> 2: FLOCK  ADVISORY  WRITE 2654 fd:00:21398203 0 EOF
> 3: FLOCK  ADVISORY  WRITE 2564 fd:00:21463056 0 EOF
> 4: FLOCK  ADVISORY  WRITE 2266 fd:00:21398151 0 EOF
> kerndev: /proc# cd 2663/fdinfo/
> kerndev: /proc/2663/fdinfo# grep 21398205 * -B2 -A6
>                ^^^^
> 3-mode:	0644
> 3-dev:	253,0
> 3:ino:	21398205
>         ^^^^^^^^
> 3-uid:	0
> 3-gid:	0
> 3-rdev:	0,0
> 3-pos:	5
> 3-flags:	02 FD_CLOEXEC
> 3-path:	/var/run/atd.pid
> 
> Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
> ---
>  fs/proc/base.c |   47 +++++++++++++++++++++++++++++++++++++++++------
>  1 files changed, 41 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index c59852b..dde617f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1402,7 +1402,7 @@ out:
>  	return ~0U;
>  }
>  
> -#define PROC_FDINFO_MAX 64
> +#define PROC_FDINFO_MAX 256
>  
>  static int proc_fd_info(struct inode *inode, struct dentry **dentry,
>  			struct vfsmount **mnt, char *info)
> @@ -1411,6 +1411,7 @@ static int proc_fd_info(struct inode *inode, struct dentry **dentry,
>  	struct files_struct *files = NULL;
>  	struct file *file;
>  	int fd = proc_fd(inode);
> +	int ret = -ENOENT;
>  
>  	if (task) {
>  		files = get_files_struct(task);
> @@ -1424,24 +1425,58 @@ static int proc_fd_info(struct inode *inode, struct dentry **dentry,
>  		spin_lock(&files->file_lock);
>  		file = fcheck_files(files, fd);
>  		if (file) {
> +			ret = 0;
> +
>  			if (mnt)
>  				*mnt = mntget(file->f_path.mnt);
>  			if (dentry)
>  				*dentry = dget(file->f_path.dentry);
> -			if (info)
> +			/* called by proc_fdinfo_read() */
> +			if (info) {
> +				struct fdtable *fdt = files_fdtable(files);
> +				struct dentry *d = dget(file->f_path.dentry);
> +				struct vfsmount *v = mntget(file->f_path.mnt);
> +				char *page = (char *)__get_free_page(GFP_TEMPORARY);
> +				int gcoe = FD_ISSET(fd, fdt->close_on_exec);
> +				int dev_nr = d->d_inode->i_sb->s_dev;
> +				int rdev_nr = d->d_inode->i_rdev;
> +
> +				if (!page) {
> +					ret = -ENOMEM;
> +					goto out;
> +				}
> +
>  				snprintf(info, PROC_FDINFO_MAX,
> +					 "mode:\t0%o\n"
> +					 "dev:\t%d,%d\n"
> +					 "ino:\t%ld\n"
> +					 "uid:\t%d\n"
> +					 "gid:\t%d\n"
> +					 "rdev:\t%d,%d\n"
>  					 "pos:\t%lli\n"
> -					 "flags:\t0%o\n",
> +					 "flags:\t0%o %s\n"
> +					 "path:\t%s\n",
> +					 d->d_inode->i_mode & 0777,
> +					 MAJOR(dev_nr), MINOR(dev_nr),
> +					 d->d_inode->i_ino,
> +					 file->f_uid, file->f_gid,
> +					 MAJOR(rdev_nr), MINOR(rdev_nr),
>  					 (long long) file->f_pos,
> -					 file->f_flags);
> +					 file->f_flags, gcoe ? "FD_CLOEXEC" : "",
> +					 d_path(d, v, page, PAGE_SIZE));
> +				free_page((unsigned long)page);
> +out:
> +				mntput(v);
> +				dput(d);
> +			}
>  			spin_unlock(&files->file_lock);
>  			put_files_struct(files);
> -			return 0;
> +			return ret;
>  		}
>  		spin_unlock(&files->file_lock);
>  		put_files_struct(files);
>  	}
> -	return -ENOENT;
> +	return ret;
>  }
>  
>  static int proc_fd_link(struct inode *inode, struct dentry **dentry,
> 

