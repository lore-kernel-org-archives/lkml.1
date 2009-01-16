Return-Path: <linux-kernel-owner+w=401wt.eu-S935017AbZAPU6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935017AbZAPU6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 15:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZAPU57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 15:57:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57491 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbZAPU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 15:57:58 -0500
Date: Fri, 16 Jan 2009 12:57:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: menage@google.com, miaox@cn.fujitsu.com, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: fix possible deadlock in
 async_rebuild_sched_domains
Message-Id: <20090116125738.22c21bf2.akpm@linux-foundation.org>
In-Reply-To: <4970000E.7040902@cn.fujitsu.com>
References: <496FEFCA.9050908@cn.fujitsu.com>
	<4970000E.7040902@cn.fujitsu.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 11:33:34 +0800
Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> 
> But queuing a work to an other thread is adding some overhead for cpuset.
> And a new separate workqueue thread is wasteful, this thread is sleeping
> at most time.
> 
> This is an effective fix:
> 
> This patch add cgroup_queue_defer_work(). And the works will be deferring
> processed with cgroup_mutex released. And this patch just add very very
> little overhead for cgroup_unlock()'s fast path.
> 
> Lai
> 
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> Lockdep reported some possible circular locking info when we tested cpuset on
> NUMA/fake NUMA box.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.29-rc1-00224-ga652504 #111
> -------------------------------------------------------
> bash/2968 is trying to acquire lock:
>  (events){--..}, at: [<ffffffff8024c8cd>] flush_work+0x24/0xd8
> 
> but task is already holding lock:
>  (cgroup_mutex){--..}, at: [<ffffffff8026ad1e>] cgroup_lock_live_group+0x12/0x29
> 
> which lock already depends on the new lock.
> ......
> -------------------------------------------------------
> 
> Steps to reproduce:
> # mkdir /dev/cpuset
> # mount -t cpuset xxx /dev/cpuset
> # mkdir /dev/cpuset/0
> # echo 0 > /dev/cpuset/0/cpus
> # echo 0 > /dev/cpuset/0/mems
> # echo 1 > /dev/cpuset/0/memory_migrate
> # cat /dev/zero > /dev/null &
> # echo $! > /dev/cpuset/0/tasks
> 
> This is because async_rebuild_sched_domains has the following lock sequence:
> run_workqueue(async_rebuild_sched_domains)
> 	-> do_rebuild_sched_domains -> cgroup_lock
> 
> But, attaching tasks when memory_migrate is set has following:
> cgroup_lock_live_group(cgroup_tasks_write)
> 	-> do_migrate_pages -> flush_work
> 
> This can be fixed by using a separate workqueue thread.
> 
> But queuing a work to an other thread is adding some overhead for cpuset.
> And a new separate workqueue thread is wasteful, this thread is sleeping
> at most time.
> 
> This patch add cgroup_queue_defer_work(). And the works will be deferring
> processed with cgroup_mutex released. And this patch just add very very
> little overhead for cgroup_unlock()'s fast path.

hm.  There's little discussion for such a large-looking patch?

> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -437,6 +437,19 @@ void cgroup_iter_end(struct cgroup *cgrp, struct cgroup_iter *it);
>  int cgroup_scan_tasks(struct cgroup_scanner *scan);
>  int cgroup_attach_task(struct cgroup *, struct task_struct *);
>  
> +struct cgroup_defer_work {
> +	struct list_head list;
> +	void (*func)(struct cgroup_defer_work *);
> +};
> +
> +#define CGROUP_DEFER_WORK(name, function)		\
> +	struct cgroup_defer_work name = {		\
> +		.list = LIST_HEAD_INIT((name).list),	\
> +		.func = (function),			\
> +	};
> +
> +int cgroup_queue_defer_work(struct cgroup_defer_work *defer_work);

These should be called "cgroup_deferred_work" and
"queue_deferred_work", I think?  Maybe not.

> +static void cgroup_flush_defer_work_locked(void);

cgroup_flush_deferred_work_locked()?

>  /**
>   * cgroup_unlock - release lock on cgroup changes
>   *
> @@ -547,9 +548,67 @@ void cgroup_lock(void)
>   */
>  void cgroup_unlock(void)
>  {
> +	cgroup_flush_defer_work_locked();
>  	mutex_unlock(&cgroup_mutex);
>  }
>  
> +static LIST_HEAD(defer_work_list);

Please add a comment telling readers what the locking protocol is for
this list.

> +/* flush deferred works with cgroup_mutex released */
> +static void cgroup_flush_defer_work_locked(void)
> +{
> +	static bool running_dely_work;

"running_delayed_work"

> +	if (likely(list_empty(&defer_work_list)))
> +		return;
> +
> +	/*
> +	 * Insure it's not recursive and also
> +	 * insure deferred works are run orderly.

"ensure"

> +	 */
> +	if (running_dely_work)
> +		return;
> +	running_dely_work = true;
> +
> +	for ( ; ; ) {
> +		struct cgroup_defer_work *defer_work;
> +
> +		defer_work = list_first_entry(&defer_work_list,
> +				struct cgroup_defer_work, list);
> +		list_del_init(&defer_work->list);
> +		mutex_unlock(&cgroup_mutex);
> +
> +		defer_work->func(defer_work);
> +
> +		mutex_lock(&cgroup_mutex);
> +		if (list_empty(&defer_work_list))
> +			break;
> +	}
> +
> +	running_dely_work = false;
> +}
> +
> +/**
> + * cgroup_queue_defer_work - queue a deferred work
> + * @defer_work: work to queue
> + *
> + * Returns 0 if @defer_work was already on the queue, non-zero otherwise.
> + *
> + * Must called when cgroup_mutex held.

"must be"

> + * The defered work will be run after cgroup_mutex released.

"deferred"

> + */
> +int cgroup_queue_defer_work(struct cgroup_defer_work *defer_work)
> +{
> +	int ret = 0;
> +
> +	if (list_empty(&defer_work->list)) {
> +		list_add_tail(&defer_work->list, &defer_work_list);
> +		ret = 1;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * A couple of forward declarations required, due to cyclic reference loop:
>   * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->
> @@ -616,7 +675,7 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		 * agent */
>  		synchronize_rcu();
>  
> -		mutex_lock(&cgroup_mutex);
> +		cgroup_lock();

All these changes add rather a lot of noise.  It would be better to do
this as two patches:

1: "convert open-coded mutex_lock(&cgroup_mutex) calls into cgroup_lock() calls"
2: "cpuset: fix possible deadlock in async_rebuild_sched_domains"

Although it doesn't matter a lot.


Also, as it now appears to be compulsory to use cgroup_lock(), you
should rename cgroup_mutex to something else, to prevent accidental
direct usage of the lock.

