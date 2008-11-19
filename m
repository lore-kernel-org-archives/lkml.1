Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbYKSI0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbYKSI0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbYKSI0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:26:11 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751092AbYKSI0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:26:10 -0500
Date: Wed, 19 Nov 2008 00:25:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       stable@kernel.org
Subject: Re: [PATCH] cgroups: fix a serious bug in cgroupstats
Message-Id: <20081119002552.3840e3d2.akpm@linux-foundation.org>
In-Reply-To: <4923CAF1.1020404@cn.fujitsu.com>
References: <4923CAF1.1020404@cn.fujitsu.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2008 16:14:41 +0800 Li Zefan <lizf@cn.fujitsu.com> wrote:

> Try this, and you'll get oops immediately:

I guess that's wrong.

>  # cd Documentation/accounting/
>  # gcc -o getdelays getdelays.c
>  # mount -t cgroup -o debug xxx /mnt
>  # ./getdelays -C /mnt/tasks
> 
> Because a normal file's dentry->d_fsdata is a pointer to struct cftype,
> not struct cgroup.
> 
> After the patch, it returns EINVAL if we try to get cgroupstats
> from a normal file.
> 
> CC: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..f6f5219 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
>  	struct cgroup *cgrp;
>  	struct cgroup_iter it;
>  	struct task_struct *tsk;
> +
>  	/*
> -	 * Validate dentry by checking the superblock operations
> +	 * Validate dentry by checking the superblock operations,
> +	 * and make sure it's a directory.
>  	 */
> -	if (dentry->d_sb->s_op != &cgroup_ops)
> +	if (dentry->d_sb->s_op != &cgroup_ops ||
> +	    !S_ISDIR(dentry->d_inode->i_mode))
>  		 goto err;
>  
>  	ret = 0;

The patch applies OK to 2.6.25, 2.6.26 and to 2.6.27.  I marked it as
needing backport to those kernel versions.  Please let me know if that
was inappropriate.

