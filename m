Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZAEJKD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZAEJKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:10:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751887AbZAEJJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:09:44 -0500
Received: from tundra.namei.org ([65.99.196.166]:3071 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885AbZAEJJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:09:42 -0500
Date: Mon, 5 Jan 2009 20:08:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 03/10] Introduce
 d_realpath().
In-Reply-To: <20090101050940.282118078@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LRH.1.10.0901052007350.16049@tundra.namei.org>
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050940.282118078@I-love.SAKURA.ne.jp>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jan 2009, Tetsuo Handa wrote:

> To remove factors that make pathname based access control difficult
> (e.g. symbolic links, "..", "//", chroot() etc.), a variant of d_path()
> which traverses up to the root of the namespace is needed.
> 
> This patch introduces d_realpath(), a variant of d_path().
> While d_path() stops traversing at current->fs->root,
> d_realpath() doesn't stop traversiong at current->fs->root.
> 
> Three differences compared to d_path().
> (1) Ignores current process's root directory.
> (2) Trailing '/' is added if the pathname refers to a directory.
> (3) /proc/PID/ is represented as /proc/self/ if PID equals current->tgid.
> 

This needs an ack from Al and/or Christoph.

> Signed-off-by: Kentaro Takeda <takedakn@nttdata.co.jp>
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Signed-off-by: Toshiharu Harada <haradats@nttdata.co.jp>
> ---
>  fs/dcache.c            |   84 +++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/dcache.h |    1 
>  2 files changed, 85 insertions(+)
> 
> --- linux-2.6.28-mm1.orig/fs/dcache.c
> +++ linux-2.6.28-mm1/fs/dcache.c
> @@ -32,6 +32,7 @@
>  #include <linux/seqlock.h>
>  #include <linux/swap.h>
>  #include <linux/bootmem.h>
> +#include <linux/magic.h>
>  #include "internal.h"
>  
>  
> @@ -1978,6 +1979,89 @@ Elong:
>  }
>  
>  /**
> + * d_realpath - Get the realpath of a dentry.
> + *
> + * @path: Pointer to "struct path".
> + * @buffer: Pointer to buffer to return value in.
> + * @buflen: Sizeof @buffer.
> + *
> + * Returns pointer to the realpath on success, an error code othersize.
> + *
> + * If @dentry is a directory, trailing '/' is appended.
> + * /proc/PID/ is replaced by /proc/self/ if PID == task_tgid_nr_ns(current).
> + */
> +char *d_realpath(struct path *path, char *buffer, int buflen)
> +{
> +	struct dentry *dentry = path->dentry;
> +	struct vfsmount *vfsmnt = path->mnt;
> +	char *end = buffer + buflen;
> +
> +	spin_lock(&dcache_lock);
> +	spin_lock(&vfsmount_lock);
> +	if (buflen < 1 || prepend(&end, &buflen, "", 1))
> +		goto Elong;
> +	/*
> +	 * Exception: Add trailing '/' for directory.
> +	 */
> +	if (dentry->d_inode && S_ISDIR(dentry->d_inode->i_mode) &&
> +	    prepend(&end, &buflen, "/", 1))
> +		goto Elong;
> +	for (;;) {
> +		struct dentry *parent;
> +		const char *name;
> +		int name_len;
> +		unsigned long pid;
> +
> +		if (dentry == vfsmnt->mnt_root || IS_ROOT(dentry)) {
> +			/* Global root? */
> +			if (vfsmnt->mnt_parent == vfsmnt)
> +				break;
> +			dentry = vfsmnt->mnt_mountpoint;
> +			vfsmnt = vfsmnt->mnt_parent;
> +			continue;
> +		}
> +		parent = dentry->d_parent;
> +		prefetch(parent);
> +		/*
> +		 * Exception: Use /proc/self/ rather than /proc/\$/
> +		 * for current process.
> +		 */
> +		name = dentry->d_name.name;
> +		name_len = dentry->d_name.len;
> +		if (IS_ROOT(parent) &&
> +		    parent->d_sb->s_magic == PROC_SUPER_MAGIC &&
> +		    !strict_strtoul(name, 10, &pid)) {
> +			const pid_t tgid
> +				= task_tgid_nr_ns(current,
> +						  dentry->d_sb->s_fs_info);
> +			if (tgid && (pid_t) pid == tgid) {
> +				name = "self";
> +				name_len = 4;
> +			}
> +		}
> +		if (prepend(&end, &buflen, name, name_len))
> +			goto Elong;
> +		if (prepend(&end, &buflen, "/", 1))
> +			goto Elong;
> +		dentry = parent;
> +	}
> +	if (*end == '/') {
> +		/* hit the slash */
> +		buflen++;
> +		end++;
> +	}
> +	if (prepend_name(&end, &buflen, &dentry->d_name))
> +		goto Elong;
> + out:
> +	spin_unlock(&vfsmount_lock);
> +	spin_unlock(&dcache_lock);
> +	return end;
> + Elong:
> +	end = ERR_PTR(-ENAMETOOLONG);
> +	goto out;
> +}
> +
> +/**
>   * d_path - return the path of a dentry
>   * @path: path to report
>   * @buf: buffer to return value in
> --- linux-2.6.28-mm1.orig/include/linux/dcache.h
> +++ linux-2.6.28-mm1/include/linux/dcache.h
> @@ -305,6 +305,7 @@ extern char *dynamic_dname(struct dentry
>  extern char *__d_path(const struct path *path, struct path *root, char *, int);
>  extern char *d_path(const struct path *, char *, int);
>  extern char *dentry_path(struct dentry *, char *, int);
> +extern char *d_realpath(struct path *, char *, int);
>  
>  /* Allocation counts.. */
>  
> 
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
James Morris
<jmorris@namei.org>
