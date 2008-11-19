Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbYKSWbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbYKSWbq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYKSWbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:31:36 -0500
Received: from smtp-out.google.com ([216.239.45.13]:48768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbYKSWbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:31:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=YLdVPNXevpyhD5LJRvkKxDh+PfBnG0hUc2KXtEyeSsB1/hpBE6O8DKlQC4jYrPxUc
	h49dyxoFbgO1Rn8YA58TA==
MIME-Version: 1.0
In-Reply-To: <4923CAF1.1020404@cn.fujitsu.com>
References: <4923CAF1.1020404@cn.fujitsu.com>
Date: Wed, 19 Nov 2008 14:31:30 -0800
Message-ID: <6599ad830811191431k1994017dr5a08bb4811eb7466@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix a serious bug in cgroupstats
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 12:14 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Try this, and you'll get oops immediately:
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

Good catch, thanks.

Acked-by: Paul Menage <menage@google.com>



> ---
>  kernel/cgroup.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..f6f5219 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2039,10 +2039,13 @@ int cgroupstats_build(struct cgroupstats *stats, struct dentry *dentry)
>        struct cgroup *cgrp;
>        struct cgroup_iter it;
>        struct task_struct *tsk;
> +
>        /*
> -        * Validate dentry by checking the superblock operations
> +        * Validate dentry by checking the superblock operations,
> +        * and make sure it's a directory.
>         */
> -       if (dentry->d_sb->s_op != &cgroup_ops)
> +       if (dentry->d_sb->s_op != &cgroup_ops ||
> +           !S_ISDIR(dentry->d_inode->i_mode))
>                 goto err;
>
>        ret = 0;
> --
> 1.5.4.rc3
>
