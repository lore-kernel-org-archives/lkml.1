Return-Path: <linux-kernel-owner+w=401wt.eu-S1754188AbYJ3Hlx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbYJ3Hlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 03:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbYJ3Hln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 03:41:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:33524 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbYJ3Hln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 03:41:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=f2eM0SASr5Qrb0l51yyjPkZAVLMD79GHQrJpdoT8QFwyeEDkOd/ZsTmC6Gzk7CDMO
	75+ZYq1hpq1Q3jexSX6lw==
Message-ID: <6599ad830810300041o1f97999em7b64426414bae380@mail.gmail.com>
Date: Thu, 30 Oct 2008 00:41:39 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: fix invalid cgrp->dentry before cgroup has been completely removed
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       "Linux Containers" <containers@lists.linux-foundation.org>
In-Reply-To: <490960EF.7020500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490960EF.7020500@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:23 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> This fixes oops when reading /proc/sched_debug.
>
> A cgroup won't be removed completely until finishing cgroup_diput(), so we
> shouldn't invalidate cgrp->dentry in cgroup_rmdir(). Otherwise, when a
> group is being removed while cgroup_path() gets called, we may trigger NULL
> dereference BUG.

Clearly a bug if it can hit a NULL dereference. But clearing the
dentry to NULL is something that cgroups inherited from cpusets - it
looks OK to remove it, but I'm mildly nervous.

Directly after the code in your patch, we dput() the dentry. So
theoretically it could be released any time after that. But I guess
that as soon as it *is* released, cgroup_diput() will be called as
part of that cleanup, at which point any subsystems should drop any
pointers they have to the cgroup or the dentry. So I guess it should
be OK.

Thanks.

Acked-by: Paul Menage <menage@google.com>



>
> The bug can be reproduced:
>
>  # cat test.sh
>  #!/bin/sh
>  mount -t cgroup -o cpu xxx /mnt
>  for (( ; ; ))
>  {
>        mkdir /mnt/sub
>        rmdir /mnt/sub
>  }
>  # ./test.sh &
>  # cat /proc/sched_debug
>
> BUG: unable to handle kernel NULL pointer dereference at 00000038
> IP: [<c045a47f>] cgroup_path+0x39/0x90
> ...
> Call Trace:
>  [<c0420344>] ? print_cfs_rq+0x6e/0x75d
>  [<c0421160>] ? sched_debug_show+0x72d/0xc1e
> ...
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/cgroup.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 35eebd5..358e775 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2497,7 +2497,6 @@ static int cgroup_rmdir(struct inode *unused_dir, struct dentry *dentry)
>        list_del(&cgrp->sibling);
>        spin_lock(&cgrp->dentry->d_lock);
>        d = dget(cgrp->dentry);
> -       cgrp->dentry = NULL;
>        spin_unlock(&d->d_lock);
>
>        cgroup_d_remove_dir(d);
> --
> 1.5.4.rc3
>
>
