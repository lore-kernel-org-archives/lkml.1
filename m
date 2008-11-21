Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbYKUS3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbYKUS3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 13:29:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbYKUS2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 13:28:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:16435 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbYKUS2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 13:28:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=g201BFnHtCtE3PTAvjiYLRn0Ng0RvQ1s95uB+j1CSdzjh9nWpU7ahCIA1n5OiYUrG
	ShBsaTXplMoEzLnBKWRww==
MIME-Version: 1.0
In-Reply-To: <4926761B.2060608@cn.fujitsu.com>
References: <4926761B.2060608@cn.fujitsu.com>
Date: Fri, 21 Nov 2008 10:28:44 -0800
Message-ID: <6599ad830811211028v2d9532cfsfef18c0af5935964@mail.gmail.com>
Subject: Re: [PATCH] cgroups: defer free css_set
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
> we free css_set when refcnt became 0 immediately(except cgroup_attach_task()).
> I will destroy the data which read side maybe still access it.
> this patch use call_rcu() to defer free css_set
>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index 1164963..22901ff 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -178,6 +178,8 @@ struct css_set {
>         */
>        struct list_head cg_links;
>
> +       struct rcu_head rcu;
> +
>        /*
>         * Set of subsystem states, one for each subsystem. This array
>         * is immutable after creation apart from the init_css_set
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 358e775..ddc10ac 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -252,6 +252,11 @@ static void unlink_css_set(struct css_set *cg)
>        }
>  }
>
> +static void rcu_free_css_set(struct rcu_head *head)
> +{
> +       kfree(container_of(head, struct css_set, rcu));
> +}
> +
>  static void __put_css_set(struct css_set *cg, int taskexit)
>  {
>        int i;
> @@ -281,7 +286,7 @@ static void __put_css_set(struct css_set *cg, int taskexit)
>                }
>        }
>        rcu_read_unlock();
> -       kfree(cg);
> +       call_rcu(&cg->rcu, rcu_free_css_set);
>  }
>
>  /*
> @@ -1267,7 +1277,6 @@ int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk)
>                        ss->attach(ss, cgrp, oldcgrp, tsk);
>        }
>        set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
> -       synchronize_rcu();

I'm reluctant to remove this synchronize_rcu() call - it gives the
property that if you get a pointer to a task's cgroup protected by
RCU, then even if you race with the task moving away to a different
cgroup, then no other cgroup_mutex-protected operation can start until
you've finished your RCU section (since the thread that you raced with
is blocking in synchronize_rcu() while holding cgroup_mutex). I'm
pretty sure that some of the cgroups code relies on that property,
although I can't find exactly which bit I'm thinking of.

Also, using call_rcu() for freeing all css_sets seems unnecessary -
the only one that appears to be potentially broken is the one from
cgroup_exit(), since in the other cases the css_set hasn't been
visible via a task->cgroups pointer. So how about making
__put_css_set() do a call_rcu() for the case when taskexit is true,
and a plain free() otherwise? That would also reduce the change of
overloading the RCU system with too many deferred frees.

Paul
