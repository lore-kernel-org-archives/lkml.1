Return-Path: <linux-kernel-owner+w=401wt.eu-S1030793AbXAZUl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030793AbXAZUl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030834AbXAZUl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:41:27 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54066 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030793AbXAZUl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:41:26 -0500
Date: Fri, 26 Jan 2007 12:41:20 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: devel@openvz.org, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3] lutimesat: simplify utime(2)
Message-Id: <20070126124120.f8f78623.akpm@osdl.org>
In-Reply-To: <20070126112142.GA11128@localhost.sw.ru>
References: <20070126112142.GA11128@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 14:21:42 +0300
Alexey Dobriyan <adobriyan@openvz.org> wrote:

> Rewrite via do_utimes() like compat_sys_utime().
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
> ---
> 
>  fs/utimes.c |   50 +++++++-------------------------------------------
>  1 file changed, 7 insertions(+), 43 deletions(-)
> 
> --- a/fs/utimes.c
> +++ b/fs/utimes.c
> @@ -22,52 +22,16 @@ #ifdef __ARCH_WANT_SYS_UTIME
>   */
>  asmlinkage long sys_utime(char __user * filename, struct utimbuf __user * times)
>  {
> -	int error;
> -	struct nameidata nd;
> -	struct inode * inode;
> -	struct iattr newattrs;
> +	struct timeval tv[2];
>  
> -	error = user_path_walk(filename, &nd);
> -	if (error)
> -		goto out;
> -	inode = nd.dentry->d_inode;
> -
> -	error = -EROFS;
> -	if (IS_RDONLY(inode))
> -		goto dput_and_out;
> -
> -	/* Don't worry, the checks are done in inode_change_ok() */
> -	newattrs.ia_valid = ATTR_CTIME | ATTR_MTIME | ATTR_ATIME;
>  	if (times) {
> -		error = -EPERM;
> -		if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
> -			goto dput_and_out;
> -
> -		error = get_user(newattrs.ia_atime.tv_sec, &times->actime);
> -		newattrs.ia_atime.tv_nsec = 0;
> -		if (!error)
> -			error = get_user(newattrs.ia_mtime.tv_sec, &times->modtime);
> -		newattrs.ia_mtime.tv_nsec = 0;
> -		if (error)
> -			goto dput_and_out;
> -
> -		newattrs.ia_valid |= ATTR_ATIME_SET | ATTR_MTIME_SET;
> -	} else {
> -                error = -EACCES;
> -                if (IS_IMMUTABLE(inode))
> -                        goto dput_and_out;
> -
> -		if (current->fsuid != inode->i_uid &&
> -		    (error = vfs_permission(&nd, MAY_WRITE)) != 0)
> -			goto dput_and_out;
> +		if (get_user(tv[0].tv_sec, &times->actime) ||
> +		    get_user(tv[1].tv_sec, &times->modtime))
> +			return -EFAULT;
> +		tv[0].tv_usec = 0;
> +		tv[1].tv_usec = 0;
>  	}
> -	mutex_lock(&inode->i_mutex);
> -	error = notify_change(nd.dentry, &newattrs);
> -	mutex_unlock(&inode->i_mutex);
> -dput_and_out:
> -	path_release(&nd);
> -out:
> -	return error;
> +	return do_utimes(AT_FDCWD, filename, times ? tv : NULL);
>  }
>  
>  #endif

I'm somewhat surprised that this wasn't done earlier.  I wonder if there's
some subtle reason why this won't work.   How well tested is this?
