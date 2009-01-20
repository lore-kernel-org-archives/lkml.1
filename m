Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbZATB0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbZATB0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 20:26:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZATB0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 20:26:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:26694 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbZATB0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 20:26:21 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=dlxXFjxAFaTF1w+wowgWZl5arheWjc59ZXulX0PgnZ28hGDnDxTxNFKPd7UE73Mhk
	yROQK1viOWGDdQN70DynA==
MIME-Version: 1.0
In-Reply-To: <4972E30A.6080107@cn.fujitsu.com>
References: <496FEFCA.9050908@cn.fujitsu.com> <4970000E.7040902@cn.fujitsu.com>
	 <20090116125738.22c21bf2.akpm@linux-foundation.org>
	 <4972E30A.6080107@cn.fujitsu.com>
Date: Mon, 19 Jan 2009 17:26:17 -0800
Message-ID: <6599ad830901191726x7adbcccev31dea73efc938dff@mail.gmail.com>
Subject: Re: [PATCH 2/3] cgroup: introduce cgroup_queue_deferred_work()
From: Paul Menage <menage@google.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, miaox@cn.fujitsu.com,
       maxk@qualcomm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.25.146.36
X-GMailtapped: menage
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 12:06 AM, Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> Sometimes we need require a lock to prevent something,
> but this lock cannot nest in cgroup_lock. So this work
> should be moved out of cgroup_lock's critical region.
>
> Using schedule_work() can move this work out of cgroup_lock's
> critical region. But it's a overkill for move a work to
> other process. And if we need flush_work() with cgroup_lock
> held, schedule_work() can not work for flush_work() will
> cause deadlock.
>
> Another solution is that deferring the work, and processing
> it after cgroup_lock released. This patch introduces
> cgroup_queue_deferred_work() for queue a cgroup_deferred_work.

I agree with Ingo - this seems rather complex. I think it would be
cleaner to address specific lock-dependency cases individually - in
some cases we can punt to a work queue; in other cases we can sanitize
the locking, etc.

Paul

>
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Max Krasnyansky <maxk@qualcomm.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> ---
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index e267e62..6d3e6dc 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -437,6 +437,19 @@ void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
>  int cgroup_scan_tasks(struct cgroup_scanner *scan);
>  int cgroup_attach_task(struct cgroup *, struct task_struct *);
>
> +struct cgroup_deferred_work {
> +       struct list_head list;
> +       void (*func)(struct cgroup_deferred_work *);
> +};
> +
> +#define CGROUP_DEFERRED_WORK(name, function)           \
> +       struct cgroup_deferred_work name = {            \
> +               .list = LIST_HEAD_INIT((name).list),    \
> +               .func = (function),                     \
> +       };
> +
> +int cgroup_queue_deferred_work(struct cgroup_deferred_work *deferred_work);
> +
>  #else /* !CONFIG_CGROUPS */
>
>  static inline int cgroup_init_early(void) { return 0; }
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c298310..75a352b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -540,6 +540,7 @@ void cgroup_lock(void)
>        mutex_lock(&cgroup_mutex);
>  }
>
> +static void cgroup_flush_deferred_work_locked(void);
>  /**
>  * cgroup_unlock - release lock on cgroup changes
>  *
> @@ -547,9 +548,80 @@ void cgroup_lock(void)
>  */
>  void cgroup_unlock(void)
>  {
> +       cgroup_flush_deferred_work_locked();
>        mutex_unlock(&cgroup_mutex);
>  }
>
> +/* deferred_work_list is protected by cgroup_mutex */
> +static LIST_HEAD(deferred_work_list);
> +
> +/* flush deferred works with cgroup_lock released */
> +static void cgroup_flush_deferred_work_locked(void)
> +{
> +       static bool running_deferred_work;
> +
> +       if (likely(list_empty(&deferred_work_list)))
> +               return;
> +
> +       /*
> +        * Ensure it's not recursive and also
> +        * ensure deferred works are run orderly.
> +        */
> +       if (running_deferred_work)
> +               return;
> +       running_deferred_work = true;
> +
> +       for ( ; ; ) {
> +               struct cgroup_deferred_work *deferred_work;
> +
> +               /* dequeue the first work, and mark it dequeued */
> +               deferred_work = list_first_entry(&deferred_work_list,
> +                               struct cgroup_deferred_work, list);
> +               list_del_init(&deferred_work->list);
> +
> +               mutex_unlock(&cgroup_mutex);
> +
> +               /*
> +                * cgroup_mutex is released. The callback function can use
> +                * cgroup_lock()/cgroup_unlock(). This behavior is safe
> +                * for running_deferred_work is set to 'true'.
> +                */
> +               deferred_work->func(deferred_work);
> +
> +               /*
> +                * regain cgroup_mutex to access deferred_work_list
> +                * and running_deferred_work.
> +                */
> +               mutex_lock(&cgroup_mutex);
> +
> +               if (list_empty(&deferred_work_list))
> +                       break;
> +       }
> +
> +       running_deferred_work = false;
> +}
> +
> +/**
> + * cgroup_queue_deferred_work - queue a deferred work
> + * @deferred_work: work to queue.
> + *
> + * Returns 0 if @deferred_work was already on the queue, non-zero otherwise.
> + *
> + * Must be called when cgroup_lock held.
> + * The deferred work will be run after cgroup_lock released.
> + */
> +int cgroup_queue_deferred_work(struct cgroup_deferred_work *deferred_work)
> +{
> +       int ret = 0;
> +
> +       if (list_empty(&deferred_work->list)) {
> +               list_add_tail(&deferred_work->list, &deferred_work_list);
> +               ret = 1;
> +       }
> +
> +       return ret;
> +}
> +
>  /*
>  * A couple of forward declarations required, due to cyclic reference loop:
>  * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->
>
>
>
>
>
