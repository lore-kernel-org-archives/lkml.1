Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbZAUKGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbZAUKGN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 05:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZAUKF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 05:05:57 -0500
Received: from smtp-out.google.com ([216.239.33.17]:24009 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZAUKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:05:57 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=xzW+cMxNa1SeMOay+g+O4bF678phGKYC8CXbduktPh0NyMgU0soqs7gQTLvLm7yeq
	Z6aJuvUCik2kLRvnM5wKw==
MIME-Version: 1.0
In-Reply-To: <497572AA.8020101@cn.fujitsu.com>
References: <497572AA.8020101@cn.fujitsu.com>
Date: Wed, 21 Jan 2009 02:05:49 -0800
Message-ID: <6599ad830901210205jea6274rf898f59b9a48fa73@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix lock inconsistency in cgroup_clone()
From: Paul Menage <menage@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.78
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 10:43 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> I fixed a bug in cgroup_clone() in Linus' tree (commit 7b574b7), without
> noticing there was a cleanup patch in -mm tree that should be rebased
> (now commit 104cbd5), thus resulted in lock inconsistency.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

> ---
>
> for 2.6.29
>
> ---
>  kernel/cgroup.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c298310..a5826f3 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2991,20 +2991,21 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
>                mutex_unlock(&cgroup_mutex);
>                return 0;
>        }
> -       task_lock(tsk);
> -       cg = tsk->cgroups;
> -       parent = task_cgroup(tsk, subsys->subsys_id);
>
>        /* Pin the hierarchy */
> -       if (!atomic_inc_not_zero(&parent->root->sb->s_active)) {
> +       if (!atomic_inc_not_zero(&root->sb->s_active)) {
>                /* We race with the final deactivate_super() */
>                mutex_unlock(&cgroup_mutex);
>                return 0;
>        }
>
>        /* Keep the cgroup alive */
> +       task_lock(tsk);
> +       parent = task_cgroup(tsk, subsys->subsys_id);
> +       cg = tsk->cgroups;
>        get_css_set(cg);
>        task_unlock(tsk);
> +
>        mutex_unlock(&cgroup_mutex);
>
>        /* Now do the VFS work to create a cgroup */
> @@ -3043,7 +3044,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
>                mutex_unlock(&inode->i_mutex);
>                put_css_set(cg);
>
> -               deactivate_super(parent->root->sb);
> +               deactivate_super(root->sb);
>                /* The cgroup is still accessible in the VFS, but
>                 * we're not going to try to rmdir() it at this
>                 * point. */
> @@ -3069,7 +3070,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
>        mutex_lock(&cgroup_mutex);
>        put_css_set(cg);
>        mutex_unlock(&cgroup_mutex);
> -       deactivate_super(parent->root->sb);
> +       deactivate_super(root->sb);
>        return ret;
>  }
>
> --
> 1.5.4.rc3
>
>
>
