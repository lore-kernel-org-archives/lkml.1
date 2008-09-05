Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYIEXYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYIEXYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:24:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751942AbYIEXY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:24:28 -0400
Received: from smtp-out.google.com ([216.239.33.17]:9578 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbYIEXY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:24:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=wgnNP1Ekbc0HevnUWjifKQs7Dz83w32V905aLxkr9oZeQVuJkDP3jElDafLb275Kg
	HLF4JLsU1fsMDMJ7E0utg==
Message-ID: <6599ad830809051624u239e14dbqea9570909bfce544@mail.gmail.com>
Date: Fri, 5 Sep 2008 16:24:18 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH -v2] cpuset: avoid changing cpuset's cpus when -errno returned
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Paul Jackson" <pj@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <48C0AA92.6030902@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48BE3DE1.6030801@cn.fujitsu.com>
	 <6599ad830809041049i646c9e43gb276090dc76ab1a7@mail.gmail.com>
	 <48C0AA92.6030902@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2008 at 8:42 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> After the patch:
>
> commit 0b2f630a28d53b5a2082a5275bc3334b10373508
> Author: Miao Xie <miaox@cn.fujitsu.com>
> Date:   Fri Jul 25 01:47:21 2008 -0700
>
>    cpusets: restructure the function update_cpumask() and update_nodemask()
>
> It might happen that 'echo 0 > /cpuset/sub/cpus' returned failure but 'cpus'
> has been changed, because cpus was changed before calling heap_init() which
> may return -ENOMEM.
>
> This patch restores the orginal behavior.
>
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

Paul

> ---
>  kernel/cpuset.c |   37 +++++++++++++++----------------------
>  1 files changed, 15 insertions(+), 22 deletions(-)
>
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index d5ab79c..0d33827 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -774,37 +774,25 @@ static void cpuset_change_cpumask(struct task_struct *tsk,
>  /**
>  * update_tasks_cpumask - Update the cpumasks of tasks in the cpuset.
>  * @cs: the cpuset in which each task's cpus_allowed mask needs to be changed
> + * @heap: if NULL, defer allocating heap memory to cgroup_scan_tasks()
>  *
>  * Called with cgroup_mutex held
>  *
>  * The cgroup_scan_tasks() function will scan all the tasks in a cgroup,
>  * calling callback functions for each.
>  *
> - * Return 0 if successful, -errno if not.
> + * No return value. It's guaranteed that cgroup_scan_tasks() always returns 0
> + * if @heap != NULL.
>  */
> -static int update_tasks_cpumask(struct cpuset *cs)
> +static void update_tasks_cpumask(struct cpuset *cs, struct ptr_heap *heap)
>  {
>        struct cgroup_scanner scan;
> -       struct ptr_heap heap;
> -       int retval;
> -
> -       /*
> -        * cgroup_scan_tasks() will initialize heap->gt for us.
> -        * heap_init() is still needed here for we should not change
> -        * cs->cpus_allowed when heap_init() fails.
> -        */
> -       retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
> -       if (retval)
> -               return retval;
>
>        scan.cg = cs->css.cgroup;
>        scan.test_task = cpuset_test_cpumask;
>        scan.process_task = cpuset_change_cpumask;
> -       scan.heap = &heap;
> -       retval = cgroup_scan_tasks(&scan);
> -
> -       heap_free(&heap);
> -       return retval;
> +       scan.heap = heap;
> +       cgroup_scan_tasks(&scan);
>  }
>
>  /**
> @@ -814,6 +802,7 @@ static int update_tasks_cpumask(struct cpuset *cs)
>  */
>  static int update_cpumask(struct cpuset *cs, const char *buf)
>  {
> +       struct ptr_heap heap;
>        struct cpuset trialcs;
>        int retval;
>        int is_load_balanced;
> @@ -848,6 +837,10 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
>        if (cpus_equal(cs->cpus_allowed, trialcs.cpus_allowed))
>                return 0;
>
> +       retval = heap_init(&heap, PAGE_SIZE, GFP_KERNEL, NULL);
> +       if (retval)
> +               return retval;
> +
>        is_load_balanced = is_sched_load_balance(&trialcs);
>
>        mutex_lock(&callback_mutex);
> @@ -858,9 +851,9 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
>         * Scan tasks in the cpuset, and update the cpumasks of any
>         * that need an update.
>         */
> -       retval = update_tasks_cpumask(cs);
> -       if (retval < 0)
> -               return retval;
> +       update_tasks_cpumask(cs, &heap);
> +
> +       heap_free(&heap);
>
>        if (is_load_balanced)
>                rebuild_sched_domains();
> @@ -1896,7 +1889,7 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
>                     nodes_empty(cp->mems_allowed))
>                        remove_tasks_in_empty_cpuset(cp);
>                else {
> -                       update_tasks_cpumask(cp);
> +                       update_tasks_cpumask(cp, NULL);
>                        update_tasks_nodemask(cp, &oldmems);
>                }
>        }
> --
> 1.5.4.rc3
>
>
