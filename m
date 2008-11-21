Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYKURif@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYKURif (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:38:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757488AbYKURiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:38:20 -0500
Received: from smtp-out.google.com ([216.239.45.13]:6505 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbYKURiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:38:19 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=hnsgYIdSWJkiiX/Ag3AU9fMvF533wPrin4CvjW4qUEw4MxCdZdRF2c/gTkFMlBUeg
	b7MkOHBM2Ov9arICdIQEw==
MIME-Version: 1.0
In-Reply-To: <49267610.6090003@cn.fujitsu.com>
References: <49267610.6090003@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 09:38:15 -0800
Message-ID: <6599ad830811210938h4ea7cca5j8f716098935bbb55@mail.gmail.com>
Subject: Re: [PATCH] cgroups: fix cgroup_iter_next() bug.
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
> we access to res->cgroups without the task_lock(),
> so res->cgroups may be changed. it's unreliable,
> and "if (l == &res->cgroups->tasks)" may be false forever.
>
> we don't need add any lock for fixing this bug. we just access to
> struct css_set by struct cg_cgroup_link, not by struct task_struct.
>
> since we hold css_set_lock, struct cg_cgroup_link is reliable.
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Sounds plausible - you'd need to have thread A have completed the call
to find_css_set() and then have the iteration begin in thread B, so
it's a pretty tight race. But accessing through the cs_cgroup_link is
probably conceptually better anyway, regardless of races.

Thanks.

Reviewed-by: Paul Menage <menage@google.com>

> ---
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..ddc10ac 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1810,6 +1819,7 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
>  {
>        struct task_struct *res;
>        struct list_head *l = it->task;
> +       struct cg_cgroup_link *link;
>
>        /* If the iterator cg is NULL, we have no tasks */
>        if (!it->cg_link)
> @@ -1817,7 +1827,8 @@ struct task_struct *cgroup_iter_next(struct cgroup *cgrp,
>        res = list_entry(l, struct task_struct, cg_list);
>        /* Advance iterator to find next entry */
>        l = l->next;
> -       if (l == &res->cgroups->tasks) {
> +       link = list_entry(it->cg_link, struct cg_cgroup_link, cgrp_link_list);
> +       if (l == &link->cg->tasks) {
>                /* We reached the end of this task list - move on to
>                 * the next cg_cgroup_link */
>                cgroup_advance_iter(cgrp, it);
>
>
>
