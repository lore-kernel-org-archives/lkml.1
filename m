Return-Path: <linux-kernel-owner+w=401wt.eu-S1755391AbYKGEiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391AbYKGEiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 23:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYKGEiB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 23:38:01 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:46503 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYKGEiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 23:38:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wwEGrrgur95zn8iLYcQym4VSanWe/B9Z1c5POA2n3seZCShrDE8Ti2ppbht//85vWp
         SmqCcCsd87jFiWJ66BA5L8w4Q/yYCEH0KdN4uo+0cntJJ5cvU378+gxgQ8Mf0fytdPGa
         XSfx2H2ewblRjjBA6v19+RCCRsYtURykW0+LY=
Date: Fri, 7 Nov 2008 07:41:18 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 2/7] proc: Implement support for automounts in task
	directories
Message-ID: <20081107044118.GA21330@x200.localdomain>
References: <m1ej1p2l6u.fsf@frodo.ebiederm.org> <m1abcd2kqk.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1abcd2kqk.fsf@frodo.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:48:35AM -0800, Eric W. Biederman wrote:
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -18,6 +18,7 @@ proc-y	+= meminfo.o
>  proc-y	+= stat.o
>  proc-y	+= uptime.o
>  proc-y	+= version.o
> +proc-y	+= automount.o
>  proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
>  proc-$(CONFIG_NET)		+= proc_net.o
>  proc-$(CONFIG_PROC_KCORE)	+= kcore.o

> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -101,6 +101,7 @@ extern spinlock_t proc_subdir_lock;
>  
>  extern void proc_root_init(void);
>  
> +void proc_shrink_automounts(void);
>  void proc_flush_task(struct task_struct *task);
>  struct dentry *proc_pid_lookup(struct inode *dir, struct dentry * dentry, struct nameidata *);
>  int proc_pid_readdir(struct file * filp, void * dirent, filldir_t filldir);
> diff --git a/kernel/exit.c b/kernel/exit.c
> index 80137a5..8a8badb 100644
> --- a/kernel/exit.c
> +++ b/kernel/exit.c
> @@ -161,6 +161,7 @@ void release_task(struct task_struct * p)
>  repeat:
>  	tracehook_prepare_release_task(p);
>  	atomic_dec(&p->user->processes);
> +	proc_shrink_automounts();

This, of course, won't compile when PROC_FS=n.
