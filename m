Return-Path: <linux-kernel-owner+w=401wt.eu-S1754255AbYICWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbYICWXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYICWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:23:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53179 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868AbYICWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:23:10 -0400
Date: Wed, 3 Sep 2008 15:22:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nye Liu <nyet@nyet.org>
Cc: linux-kernel@vger.kernel.org, nyet@mrv.com
Subject: Re: [PATCH] INITRAMFS: Add option to preserve mtime from INITRAMFS
 cpio images
Message-Id: <20080903152231.6b82d9bf.akpm@linux-foundation.org>
In-Reply-To: <20080903202938.GA9065@curtisfong.org>
References: <20080805195232.GA5183@curtisfong.org>
	<20080903202938.GA9065@curtisfong.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Sep 2008 13:29:38 -0700
Nye Liu <nyet@nyet.org> wrote:

> Resubmission of initramfs preserve mtime patch following Andrew Morton's
> suggestions.

It's nice to provide some sort of accounting for the reviewer's
individual comments.  But in this case I only had three or fopur and I
see how they were addressed.

> From: Nye Liu <nyet@nyet.org>
> 
> When unpacking the cpio into the initramfs, mtimes are not preserved by
> default. This patch adds an INITRAMFS_PRESERVE_MTIME option that allows mtimes
> stored in the cpio image to be used when constructing the initramfs. For
> embedded applications that run exclusively out of the initramfs, this is
> invaluable.

Why is it "invlauable".  Please explain this value in full detail -
it's the whole reason for merging the patch!

> Signed-off-by: Nye Liu <nyet@nyet.org>
> 
> diff --git a/init/initramfs.c b/init/initramfs.c
> index 644fc01..ebfc049 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -6,6 +6,7 @@
>  #include <linux/delay.h>
>  #include <linux/string.h>
>  #include <linux/syscalls.h>
> +#include <linux/utime.h>
>  
>  static __initdata char *message;
>  static void __init error(char *x)
> @@ -72,6 +73,38 @@ static void __init free_hash(void)
>  	}
>  }
>  
> +static __initdata LIST_HEAD(dir_list);
> +struct dir_entry {
> +	struct list_head list;
> +	char *name;
> +	struct utimbuf mtime;
> +};
> +
> +static void __init dir_add(const char *name, struct utimbuf mtime)
> +{
> +	struct dir_entry *de = kmalloc(sizeof(struct dir_entry), GFP_KERNEL);
> +	if (!de)
> +		panic("can't allocate dir_entry buffer");
> +	INIT_LIST_HEAD(&de->list);
> +	de->name = kstrdup(name, GFP_KERNEL);
> +	de->mtime = mtime;
> +	list_add(&de->list, &dir_list);
> +}
> +
> +static void __init dir_utime(void)
> +{
> +	struct list_head *e, *tmp;
> +	list_for_each_safe(e, tmp, &dir_list) {
> +		struct dir_entry *de = list_entry(e, struct dir_entry, list);
> +		list_del(e);
> +		sys_utime(de->name, &de->mtime);

gargh.  Why does this work?  It's normally a big fail to pass a kernel
address into a system call.  I guess we're running under KERNEL_DS here
and getname() and strncpy_from_user() did the right thing.

On what CPU architecture was this tested?

Wouldn't it be simpler to put a timespec into struct dir_entry then go
direct to do_utimes() here?

> +		kfree(de->name);
> +		kfree(de);
> +	}
> +}
> +
> +static __initdata struct utimbuf mtime;
> +
>  /* cpio header parsing */
>  
>  static __initdata unsigned long ino, major, minor, nlink;
> @@ -97,6 +130,7 @@ static void __init parse_header(char *s)
>  	uid = parsed[2];
>  	gid = parsed[3];
>  	nlink = parsed[4];
> +	mtime.actime = mtime.modtime = parsed[5];
>  	body_len = parsed[6];
>  	major = parsed[7];
>  	minor = parsed[8];
> @@ -130,6 +164,7 @@ static inline void __init eat(unsigned n)
>  	count -= n;
>  }
>  
> +static __initdata char *vcollected;
>  static __initdata char *collected;
>  static __initdata int remains;
>  static __initdata char *collect;
> @@ -271,6 +306,7 @@ static int __init do_name(void)
>  			if (wfd >= 0) {
>  				sys_fchown(wfd, uid, gid);
>  				sys_fchmod(wfd, mode);
> +				vcollected = kstrdup(collected, GFP_KERNEL);
>  				state = CopyFile;
>  			}
>  		}
> @@ -278,12 +314,14 @@ static int __init do_name(void)
>  		sys_mkdir(collected, mode);
>  		sys_chown(collected, uid, gid);
>  		sys_chmod(collected, mode);
> +		dir_add(collected, mtime);
>  	} else if (S_ISBLK(mode) || S_ISCHR(mode) ||
>  		   S_ISFIFO(mode) || S_ISSOCK(mode)) {
>  		if (maybe_link() == 0) {
>  			sys_mknod(collected, mode, rdev);
>  			sys_chown(collected, uid, gid);
>  			sys_chmod(collected, mode);
> +			sys_utime(collected, &mtime);
>  		}
>  	}
>  	return 0;
> @@ -294,6 +332,8 @@ static int __init do_copy(void)
>  	if (count >= body_len) {
>  		sys_write(wfd, victim, body_len);
>  		sys_close(wfd);
> +		sys_utime(vcollected, &mtime);

and here?

> +		kfree(vcollected);
>  		eat(body_len);
>  		state = SkipIt;
>  		return 0;
> @@ -305,12 +345,26 @@ static int __init do_copy(void)
>  	}
>  }
>  
> +static long __init do_lutime(char __user *filename,
> +	struct utimbuf __user *times)
> +{
> +	struct timespec t[2];
> +
> +	t[0].tv_sec = times->actime;
> +	t[0].tv_nsec = 0;
> +	t[1].tv_sec = times->modtime;
> +	t[1].tv_nsec = 0;
> +
> +	return do_utimes(AT_FDCWD, filename, t, AT_SYMLINK_NOFOLLOW);
> +}
> +
>  static int __init do_symlink(void)
>  {
>  	collected[N_ALIGN(name_len) + body_len] = '\0';
>  	clean_path(collected, 0);
>  	sys_symlink(collected + N_ALIGN(name_len), collected);
>  	sys_lchown(collected, uid, gid);
> +	do_lutime(collected, &mtime);
>  	state = SkipIt;
>  	next_state = Reset;
>  	return 0;
> @@ -466,6 +520,7 @@ static char * __init unpack_to_rootfs(char *buf, unsigned len, int check_only)
>  		buf += inptr;
>  		len -= inptr;
>  	}
> +	dir_utime();

Perhaps this is the simplest implementation - I didn't check the fine
details.  What's your thinking here?  
