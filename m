Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbYKUTSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbYKUTSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 14:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbYKUTSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 14:18:33 -0500
Received: from smtp-out.google.com ([216.239.45.13]:27085 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYKUTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 14:18:32 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=TZvViobZmh/fb1GQYSvzrVUgzbLQmPdLppYF3QpzhoBbsHJT8kzSETfZBGzvnmNHu
	OdU4K6V0da0x4bYrkJHtw==
MIME-Version: 1.0
In-Reply-To: <49267633.8040607@cn.fujitsu.com>
References: <49267633.8040607@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 11:18:29 -0800
Message-ID: <6599ad830811211118kd410ce0o68db8249e60c8dd8@mail.gmail.com>
Subject: Re: [PATCH] cgroups: use task_lock() for access tsk->cgroups safe in 
	cgroup_clone()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2008 at 12:49 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>
> use task_lock() protect tsk->cgroups and get_css_set(tsk->cgroups)
>
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Sounds reasonable, given the race with cgroup_exit()

Reviewed-by: Paul Menage <menage@google.com>

Thanks,

Paul

> ---
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..ddc10ac 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2933,6 +2943,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
>                mutex_unlock(&cgroup_mutex);
>                return 0;
>        }
> +       task_lock(tsk);
>        cg = tsk->cgroups;
>        parent = task_cgroup(tsk, subsys->subsys_id);
>
> @@ -2941,6 +2952,7 @@ int cgroup_clone(struct task_struct *tsk, struct cgroup_subsys *subsys,
>
>        /* Keep the cgroup alive */
>        get_css_set(cg);
> +       task_unlock(tsk);
>        mutex_unlock(&cgroup_mutex);
>
>        /* Now do the VFS work to create a cgroup */
>
>
