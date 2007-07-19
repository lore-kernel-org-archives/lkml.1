Return-Path: <linux-kernel-owner+w=401wt.eu-S934680AbXGSWE2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934680AbXGSWE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 18:04:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763320AbXGSWEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 18:04:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57426 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763220AbXGSWET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 18:04:19 -0400
Date: Thu, 19 Jul 2007 15:03:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Ogrisegg <tom-lkml@lkml.fnord.at>
Cc: linux-kernel@vger.kernel.org, rml@novell.com,
       John McCutchan <ttb@tentacle.dhs.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, robin.ksj@gmail.com
Subject: Re: [PATCH] procfs fixes for inotify/dnotify
Message-Id: <20070719150355.2971e8e4.akpm@linux-foundation.org>
In-Reply-To: <20060221211623.GA26413@rescue.iwoars.net>
References: <20060221211623.GA26413@rescue.iwoars.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Feb 2006 22:16:23 +0100
Thomas Ogrisegg <tom-lkml@lkml.fnord.at> wrote:

> Problem description:
> When a new process is created, the creation of the respective PID
> subdirectory of /proc is deferred until the /proc-directory is beeing
> read (by e.g. ps(1)). This causes file notification frameworks like
> dnotify and inotify to not work correctly with /proc.
> 
> This patch fixes the problem.
> 
> Signed-off-by: Thomas Ogrisegg <tom-lkml@lkml.fnord.at>

Robin has raised this report:

	http://bugzilla.kernel.org/show_bug.cgi?id=8782

pointing at your 15-month-old patch, which seemed to have got lost.

The patch rather doesn't work any more.  If you have time to update it then
please do so, and copy John and Eric on the patch?  

Thanks.

A few things I noticed:

> 
> diff -uNr -X linux-2.6.15/Documentation/dontdiff linux-2.6.15/kernel/fork.c linux-2.6.15.4/kernel/fork.c
> --- linux-2.6.15/kernel/fork.c	2006-01-03 04:21:10.000000000 +0100
> +++ linux-2.6.15.4/kernel/fork.c	2006-02-18 14:09:54.000000000 +0100
> @@ -43,6 +43,7 @@
>  #include <linux/rmap.h>
>  #include <linux/acct.h>
>  #include <linux/cn_proc.h>
> +#include <linux/proc_fs.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
> @@ -1141,6 +1142,7 @@
>  	write_unlock_irq(&tasklist_lock);
>  	proc_fork_connector(p);
>  	cpuset_fork(p);
> +	proc_root_notify(pid);
>  	retval = 0;
>  
>  fork_out:
> --- linux-2.6.15/include/linux/proc_fs.h	2006-01-03 04:21:10.000000000 +0100
> +++ linux-2.6.15.4/include/linux/proc_fs.h	2006-02-18 13:55:52.000000000 +0100
> @@ -4,6 +4,8 @@
>  #include <linux/config.h>
>  #include <linux/slab.h>
>  #include <linux/fs.h>
> +#include <linux/fsnotify.h>
> +#include <linux/mount.h>
>  #include <asm/atomic.h>
>  
>  /*
> @@ -194,6 +196,13 @@
>  	remove_proc_entry(name,proc_net);
>  }
>  
> +static inline void proc_root_notify (pid_t pid)
> +{
> +	char buf[20];
> +	snprintf (buf, sizeof (buf), "%d", pid);
> +	fsnotify_mkdir (proc_mnt->mnt_root->d_inode, buf);
> +}

This shouldn't inlined.

Don't put spaces between the function name and the (

>  #else
>  
>  #define proc_root_driver NULL
> @@ -224,6 +233,8 @@
>  	mode_t mode, struct proc_dir_entry *base, get_info_t *get_info)
>  	{ return NULL; }
>  
> +static inline void proc_root_notify (pid_t pid) {}

This can remain inlined in the header.

>  struct tty_driver;
>  static inline void proc_tty_register_driver(struct tty_driver *driver) {};
>  static inline void proc_tty_unregister_driver(struct tty_driver *driver) {};
> diff -uNr -X linux-2.6.15/Documentation/dontdiff linux-2.6.15/fs/proc/base.c linux-2.6.15.4/fs/proc/base.c
> --- linux-2.6.15/fs/proc/base.c	2006-01-03 04:21:10.000000000 +0100
> +++ linux-2.6.15.4/fs/proc/base.c	2006-02-19 10:44:28.000000000 +0100
> @@ -1945,6 +1945,7 @@
>  	if(proc_dentry != NULL) {
>  		shrink_dcache_parent(proc_dentry);
>  		dput(proc_dentry);
> +		fsnotify_nameremove (proc_dentry, 1);
>  	}

I wonder if this is racy - after the dput() we might no longer have a
reference?

