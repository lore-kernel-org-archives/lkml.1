Return-Path: <linux-kernel-owner+w=401wt.eu-S935684AbXJPT4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935684AbXJPT4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 15:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934231AbXJPT4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 15:56:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34540 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761673AbXJPT4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 15:56:35 -0400
Date: Tue, 16 Oct 2007 12:54:03 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Max Kellermann <mk@cm4all.com>
Cc: chrisw@sous-sol.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] /proc Security Hooks
Message-ID: <20071016125403.40ec5c18@laptopd505.fenrus.org>
In-Reply-To: <20071016193850.GA5418@roonstrasse.net>
References: <20071016193850.GA5418@roonstrasse.net>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007 21:38:50 +0200
Max Kellermann <mk@cm4all.com> wrote:

> Add two LSM hooks for limiting access to the proc file system.
> 
> security_proc_task() defines the visibility of tasks in /proc.
> 
> security_proc_generic() lets the LSM define who will see "generic"
> proc entries (see fs/proc/generic.c).
> 
> This patch attempts to unify duplicated code found in modules like
> Linux VServer.

can you please merge this patch only when you also merge the first user
of it? That's the only way we can keep the LSM hooks sane... is to see
them in thew conect of a user.

> +#ifdef CONFIG_SECURITY_PROC
> +		if (security_proc_task(task) != 0)
> +			continue;
> +#endif

please don't use an ifdef like this; just make security_proc_task() be
a define to 0 in the header for that CONFIG_ .. 
In addition, why is this a separate config option? LSM should really
only be one big switch... microswitches like this don't make any sense.

>  		if (proc_pid_fill_cache(filp, dirent, filldir, task,
> tgid) < 0) { put_task_struct(task);
>  			goto out;
> @@ -2453,6 +2457,11 @@ static struct dentry *proc_task_lookup(struct
> inode *dir, struct dentry * dentry goto out;
>  	if (leader->tgid != task->tgid)
>  		goto out_drop_task;
> +#ifdef CONFIG_SECURITY_PROC
> +	result = ERR_PTR(security_proc_task(task));
> +	if (IS_ERR(result))
> +		goto out_drop_task;
> +#endif

same here


> +#ifdef CONFIG_SECURITY_PROC
> +#include <linux/security.h>
> +#endif

don't put ifdefs around includes please.... if anything the ifdef
should be inside the header

> +#ifdef CONFIG_SECURITY_PROC
> +				error = security_proc_generic(de);
> +				if (error != 0)
> +					break;
> +#endif

and this ifdef should die too
>  				spin_unlock(&proc_subdir_lock);
>  				error = -EINVAL;
>  				inode = proc_get_inode(dir->i_sb,
> ino, de); @@ -483,6 +491,10 @@ int proc_readdir(struct file * filp,
>  
>  				/* filldir passes info to user space
> */ de_get(de);
> +#ifdef CONFIG_SECURITY_PROC
> +				if (security_proc_generic(de) != 0)
> +					goto skip;
> +#endif

as does this one... but the goto looks horrid to me
