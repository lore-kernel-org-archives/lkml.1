Return-Path: <linux-kernel-owner+w=401wt.eu-S1757739AbYJPRlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbYJPRlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 13:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbYJPRlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 13:41:15 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:51062 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754783AbYJPRlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 13:41:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAMcZ90hMQWq+/2dsb2JhbACBcsJNg2w
Date: Thu, 16 Oct 2008 13:40:56 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 02/46] sysfs: crash debugging
Message-ID: <20081016174055.GA8806@Krystal>
References: <20081016170954.GA11824@kroah.com> <1224177047-11859-2-git-send-email-gregkh@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1224177047-11859-2-git-send-email-gregkh@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:33:53 up 133 days, 22:14,  9 users,  load average: 0.18, 0.59,
	0.66
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg Kroah-Hartman (gregkh@suse.de) wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> Print the name of the last-accessed sysfs file when we oops, to help track
> down oopses which occur in sysfs store/read handlers.  Because these oopses
> tend to not leave any trace of the offending code in the stack traces.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/x86/kernel/dumpstack_32.c |    2 ++
>  arch/x86/kernel/dumpstack_64.c |    2 ++
>  fs/sysfs/file.c                |   13 +++++++++++++
>  include/linux/sysfs.h          |    6 ++++++
>  4 files changed, 23 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
> index 201ee35..1a78180 100644
> --- a/arch/x86/kernel/dumpstack_32.c
> +++ b/arch/x86/kernel/dumpstack_32.c
> @@ -13,6 +13,7 @@
>  #include <linux/kexec.h>
>  #include <linux/bug.h>
>  #include <linux/nmi.h>
> +#include <linux/sysfs.h>
>  
>  #include <asm/stacktrace.h>
>  
> @@ -343,6 +344,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  	printk("DEBUG_PAGEALLOC");
>  #endif
>  	printk("\n");
> +	sysfs_printk_last_file();
>  	if (notify_die(DIE_OOPS, str, regs, err,
>  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
>  		return 1;
> diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
> index 086cc81..96a5db7 100644
> --- a/arch/x86/kernel/dumpstack_64.c
> +++ b/arch/x86/kernel/dumpstack_64.c
> @@ -13,6 +13,7 @@
>  #include <linux/kexec.h>
>  #include <linux/bug.h>
>  #include <linux/nmi.h>
> +#include <linux/sysfs.h>
>  
>  #include <asm/stacktrace.h>
>  
> @@ -489,6 +490,7 @@ int __kprobes __die(const char *str, struct pt_regs *regs, long err)
>  	printk("DEBUG_PAGEALLOC");
>  #endif
>  	printk("\n");
> +	sysfs_printk_last_file();
>  	if (notify_die(DIE_OOPS, str, regs, err,
>  			current->thread.trap_no, SIGSEGV) == NOTIFY_STOP)
>  		return 1;
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index c9e4e50..ce8339c 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -19,10 +19,18 @@
>  #include <linux/poll.h>
>  #include <linux/list.h>
>  #include <linux/mutex.h>
> +#include <linux/limits.h>
>  #include <asm/uaccess.h>
>  
>  #include "sysfs.h"
>  
> +/* used in crash dumps to help with debugging */
> +static char last_sysfs_file[PATH_MAX];
> +void sysfs_printk_last_file(void)
> +{
> +	printk(KERN_EMERG "last sysfs file: %s\n", last_sysfs_file);
> +}
> +
>  /*
>   * There's one sysfs_buffer for each open file and one
>   * sysfs_open_dirent for each sysfs_dirent with one or more open
> @@ -328,6 +336,11 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	struct sysfs_buffer *buffer;
>  	struct sysfs_ops *ops;
>  	int error = -EACCES;
> +	char *p;
> +
> +	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
> +	if (p)

if (!IS_ERR(p)) ?

> +		memmove(last_sysfs_file, p, strlen(p) + 1);
>  

Given we do a strlen() here anyway, shouldn't we just use strcpy ?

Mathieu

>  	/* need attr_sd for attr and ops, its parent for kobj */
>  	if (!sysfs_get_active_two(attr_sd))
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 37fa241..8ec406a 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -119,6 +119,8 @@ void sysfs_remove_file_from_group(struct kobject *kobj,
>  
>  void sysfs_notify(struct kobject *kobj, char *dir, char *attr);
>  
> +void sysfs_printk_last_file(void);
> +
>  extern int __must_check sysfs_init(void);
>  
>  #else /* CONFIG_SYSFS */
> @@ -231,6 +233,10 @@ static inline int __must_check sysfs_init(void)
>  	return 0;
>  }
>  
> +static inline void sysfs_printk_last_file(void)
> +{
> +}
> +
>  #endif /* CONFIG_SYSFS */
>  
>  #endif /* _SYSFS_H_ */
> -- 
> 1.6.0.2
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
