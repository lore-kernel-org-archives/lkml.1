Return-Path: <linux-kernel-owner+w=401wt.eu-S1754285AbXJ2Cgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285AbXJ2Cgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 22:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXJ2Cgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 22:36:38 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:41609 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXJ2Cgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 22:36:37 -0400
Date: Sun, 28 Oct 2007 19:35:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] VFS: swap do_ioctl and vfs_ioctl names
Message-Id: <20071028193508.d49a53ae.randy.dunlap@oracle.com>
In-Reply-To: <11936184592699-git-send-email-ezk@cs.sunysb.edu>
References: <11936184581182-git-send-email-ezk@cs.sunysb.edu>
	<11936184592699-git-send-email-ezk@cs.sunysb.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 20:40:56 -0400 Erez Zadok wrote:

> Rename old vfs_ioctl to do_ioctl, because the comment above it clearly
> indicates that it is an internal function not to be exported to modules;
> therefore it should have a more traditional do_XXX name.  The new do_ioctl
> is exported in fs.h but not to modules.
> 
> Rename the old do_ioctl to vfs_ioctl because the names vfs_XXX should
> preferably be reserved to callable VFS functions which modules may call, as
> many other vfs_XXX functions already do.  Export the new vfs_ioctl to GPL
> modules so others can use it (including Unionfs and eCryptfs).  Add DocBook
> for new vfs_ioctl.
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  fs/compat_ioctl.c  |    2 +-
>  fs/ioctl.c         |   30 ++++++++++++++++++++++--------
>  include/linux/fs.h |    3 ++-
>  3 files changed, 25 insertions(+), 10 deletions(-)
> 

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 652cacf..34e3f58 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -16,8 +16,21 @@
>  
>  #include <asm/ioctls.h>
>  
> -static long do_ioctl(struct file *filp, unsigned int cmd,
> -		unsigned long arg)
> +/**
> + * vfs_ioctl - call filesystem specific ioctl methods
> + *

No "blank" line allowed in kernel-doc between function name and its
parameters.

> + * @filp: [in]     open file to invoke ioctl method on
> + * @cmd:  [in]     ioctl command to execute
> + * @arg:  [in/out] command-specific argument for ioctl
> + *
> + * Invokes filesystem specific ->unlock_ioctl, if one exists; otherwise
> + * invokes * filesystem specific ->ioctl method.  If neither method exists,
> + * returns -ENOTTY.
> + *
> + * Returns 0 on success, -errno on error.
> + */
> +long vfs_ioctl(struct file *filp, unsigned int cmd,
> +	       unsigned long arg)
>  {
>  	int error = -ENOTTY;
>  

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b3ec4a4..c0c5d36 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1924,7 +1924,8 @@ extern int vfs_stat_fd(int dfd, char __user *, struct kstat *);
>  extern int vfs_lstat_fd(int dfd, char __user *, struct kstat *);
>  extern int vfs_fstat(unsigned int, struct kstat *);
>  
> -extern int vfs_ioctl(struct file *, unsigned int, unsigned int, unsigned long);
> +extern long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
> +extern int do_ioctl(struct file *, unsigned int, unsigned int, unsigned long);

Use/keep parameter names, please.  That is preferred.

>  extern void get_filesystem(struct file_system_type *fs);
>  extern void put_filesystem(struct file_system_type *fs);
> -- 
> 1.5.2.2
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


---
~Randy
