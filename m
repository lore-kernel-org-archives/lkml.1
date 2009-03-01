Return-Path: <linux-kernel-owner+w=401wt.eu-S1757527AbZCATns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527AbZCATns (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 14:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754868AbZCATnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 14:43:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:45026 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbZCATni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 14:43:38 -0500
Date: Sun, 1 Mar 2009 13:43:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090301194333.GA25234@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203435.98735E54@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> 
> Introduce a files_struct counter to indicate whether a particular
> file_struct has ever contained a file which can not be
> checkpointed.  This flag is a one-way trip; once it is set, it may
> not be unset.
> 
> We assume at allocation that a new files_struct is clean and may
> be checkpointed.  However, as soon as it has had its files filled
> from its parent's, we check it for real in __scan_files_for_cr().
> At that point, we mark it if it contained any uncheckpointable
> files.
> 
> We also check each 'struct file' when it is installed in a fd
> slot.  This way, if anyone open()s or managed to dup() an
> unsuppored file, we can catch it.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/fs/file.c                  |   19 +++++++++++++++++++
>  linux-2.6.git-dave/fs/open.c                  |    5 +++++
>  linux-2.6.git-dave/include/linux/checkpoint.h |   14 ++++++++++++++
>  linux-2.6.git-dave/include/linux/fdtable.h    |    3 +++
>  4 files changed, 41 insertions(+)
> 
> diff -puN fs/file.c~track-files_struct-checkpointability fs/file.c
> --- linux-2.6.git/fs/file.c~track-files_struct-checkpointability	2009-02-27 12:07:41.000000000 -0800
> +++ linux-2.6.git-dave/fs/file.c	2009-02-27 12:07:41.000000000 -0800
> @@ -15,6 +15,7 @@
>  #include <linux/file.h>
>  #include <linux/fdtable.h>
>  #include <linux/bitops.h>
> +#include <linux/checkpoint.h>
>  #include <linux/interrupt.h>
>  #include <linux/spinlock.h>
>  #include <linux/rcupdate.h>
> @@ -285,6 +286,20 @@ static int count_open_files(struct fdtab
>  	return i;
>  }
> 
> +static void __scan_files_for_cr(struct files_struct *files)
> +{
> +	int i;
> +
> +	for (i = 0; i < files->fdtab.max_fds; i++) {
> +		struct file *f = fcheck_files(files, i);
> +		if (!f)
> +			continue;
> +		if (cr_file_supported(f))
> +			continue;
> +		files_deny_checkpointing(files);
> +	}
> +}
> +
>  /*
>   * Allocate a new files structure and copy contents from the
>   * passed in files structure.
> @@ -303,6 +318,9 @@ struct files_struct *dup_fd(struct files
>  		goto out;
> 
>  	atomic_set(&newf->count, 1);
> +#ifdef CONFIG_CHECKPOINT_RESTART
> +	newf->may_checkpoint = 1;
> +#endif
> 
>  	spin_lock_init(&newf->file_lock);
>  	newf->next_fd = 0;
> @@ -396,6 +414,7 @@ struct files_struct *dup_fd(struct files
> 
>  	rcu_assign_pointer(newf->fdt, new_fdt);
> 
> +	__scan_files_for_cr(newf);
>  	return newf;
> 
>  out_release:
> diff -puN fs/open.c~track-files_struct-checkpointability fs/open.c
> --- linux-2.6.git/fs/open.c~track-files_struct-checkpointability	2009-02-27 12:07:41.000000000 -0800
> +++ linux-2.6.git-dave/fs/open.c	2009-02-27 12:07:41.000000000 -0800
> @@ -29,6 +29,7 @@
>  #include <linux/rcupdate.h>
>  #include <linux/audit.h>
>  #include <linux/falloc.h>
> +#include <linux/checkpoint.h>
> 
>  int vfs_statfs(struct dentry *dentry, struct kstatfs *buf)
>  {
> @@ -1015,6 +1016,10 @@ void fd_install(unsigned int fd, struct 
>  {
>  	struct files_struct *files = current->files;
>  	struct fdtable *fdt;
> +
> +	if (!cr_file_supported(file))
> +		files_deny_checkpointing(files);
> +
>  	spin_lock(&files->file_lock);
>  	fdt = files_fdtable(files);
>  	BUG_ON(fdt->fd[fd] != NULL);
> diff -puN include/linux/checkpoint.h~track-files_struct-checkpointability include/linux/checkpoint.h
> --- linux-2.6.git/include/linux/checkpoint.h~track-files_struct-checkpointability	2009-02-27 12:07:41.000000000 -0800
> +++ linux-2.6.git-dave/include/linux/checkpoint.h	2009-02-27 12:07:41.000000000 -0800
> @@ -12,6 +12,7 @@
> 
>  #include <linux/path.h>
>  #include <linux/fs.h>
> +#include <linux/fdtable.h>
> 
>  #ifdef CONFIG_CHECKPOINT_RESTART
> 
> @@ -102,6 +103,18 @@ extern int cr_read_files(struct cr_ctx *
> 
>  #define pr_fmt(fmt) "[%d:c/r:%s] " fmt, task_pid_vnr(current), __func__
> 
> +static inline void __files_deny_checkpointing(struct files_struct *files,
> +		char *file, int line)
> +{
> +	if (!test_and_clear_bit(0, &files->may_checkpoint))
> +		return;
> +	printk(KERN_INFO "process performed an action that can not be "
> +			"checkpointed at: %s:%d\n", file, line);
> +	WARN_ON(1);

This WARN_ON(1) is one step past the line into obnoxiousness on my
console :)

-serge
