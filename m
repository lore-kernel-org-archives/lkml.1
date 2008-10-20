Return-Path: <linux-kernel-owner+w=401wt.eu-S1752490AbYJTBbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490AbYJTBbn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 21:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYJTBbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 21:31:36 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50088 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbYJTBbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 21:31:35 -0400
Date: Sun, 19 Oct 2008 21:31:33 -0400
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/31] proc: move rest of /proc/locks to fs/locks.c
Message-ID: <20081020013133.GA12741@fieldses.org>
References: <20081017124540.GM22653@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081017124540.GM22653@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks.  Looks like good clean up to me; I've queued it up for 2.6.29.

--b.

On Fri, Oct 17, 2008 at 04:45:40PM +0400, Alexey Dobriyan wrote:
> 
> >From 09a3878c4ba92dc906e6573245fb18bef5d760ff Mon Sep 17 00:00:00 2001
> From: Alexey Dobriyan <adobriyan@gmail.com>
> Date: Sat, 4 Oct 2008 22:34:18 +0400
> Subject: [PATCH 12/31] proc: move rest of /proc/locks to fs/locks.c
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
>  fs/locks.c          |   22 +++++++++++++++++++++-
>  fs/proc/proc_misc.c |   17 -----------------
>  include/linux/fs.h  |    1 -
>  3 files changed, 21 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 5eb259e..90e87f5 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -2078,6 +2078,7 @@ int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
>  EXPORT_SYMBOL_GPL(vfs_cancel_lock);
>  
>  #ifdef CONFIG_PROC_FS
> +#include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  
>  static void lock_get_status(struct seq_file *f, struct file_lock *fl,
> @@ -2183,12 +2184,31 @@ static void locks_stop(struct seq_file *f, void *v)
>  	unlock_kernel();
>  }
>  
> -struct seq_operations locks_seq_operations = {
> +static const struct seq_operations locks_seq_operations = {
>  	.start	= locks_start,
>  	.next	= locks_next,
>  	.stop	= locks_stop,
>  	.show	= locks_show,
>  };
> +
> +static int locks_open(struct inode *inode, struct file *filp)
> +{
> +	return seq_open(filp, &locks_seq_operations);
> +}
> +
> +static const struct file_operations proc_locks_operations = {
> +	.open		= locks_open,
> +	.read		= seq_read,
> +	.llseek		= seq_lseek,
> +	.release	= seq_release,
> +};
> +
> +static int __init proc_locks_init(void)
> +{
> +	proc_create("locks", 0, NULL, &proc_locks_operations);
> +	return 0;
> +}
> +module_init(proc_locks_init);
>  #endif
>  
>  /**
> diff --git a/fs/proc/proc_misc.c b/fs/proc/proc_misc.c
> index 8ae7d38..19cf7a0 100644
> --- a/fs/proc/proc_misc.c
> +++ b/fs/proc/proc_misc.c
> @@ -455,20 +455,6 @@ static const struct file_operations proc_interrupts_operations = {
>  	.release	= seq_release,
>  };
>  
> -#ifdef CONFIG_FILE_LOCKING
> -static int locks_open(struct inode *inode, struct file *filp)
> -{
> -	return seq_open(filp, &locks_seq_operations);
> -}
> -
> -static const struct file_operations proc_locks_operations = {
> -	.open		= locks_open,
> -	.read		= seq_read,
> -	.llseek		= seq_lseek,
> -	.release	= seq_release,
> -};
> -#endif /* CONFIG_FILE_LOCKING */
> -
>  #ifdef CONFIG_PROC_PAGE_MONITOR
>  #define KPMSIZE sizeof(u64)
>  #define KPMMASK (KPMSIZE - 1)
> @@ -607,9 +593,6 @@ void __init proc_misc_init(void)
>  	proc_symlink("mounts", NULL, "self/mounts");
>  
>  	/* And now for trickier ones */
> -#ifdef CONFIG_FILE_LOCKING
> -	proc_create("locks", 0, NULL, &proc_locks_operations);
> -#endif
>  	proc_create("devices", 0, NULL, &proc_devinfo_operations);
>  	proc_create("cpuinfo", 0, NULL, &proc_cpuinfo_operations);
>  #ifdef CONFIG_BLOCK
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a6a625b..0240495 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1037,7 +1037,6 @@ extern int vfs_setlease(struct file *, long, struct file_lock **);
>  extern int lease_modify(struct file_lock **, int);
>  extern int lock_may_read(struct inode *, loff_t start, unsigned long count);
>  extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
> -extern struct seq_operations locks_seq_operations;
>  #else /* !CONFIG_FILE_LOCKING */
>  #define fcntl_getlk(a, b) ({ -EINVAL; })
>  #define fcntl_setlk(a, b, c, d) ({ -EACCES; })
> -- 
> 1.5.6.5
> 
