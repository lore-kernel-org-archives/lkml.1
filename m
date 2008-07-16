Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbYGPHL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbYGPHL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752656AbYGPHLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:11:20 -0400
Received: from smtp-out.google.com ([216.239.33.17]:25663 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYGPHLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:11:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=eASr91pv04X6JwB/gCRlQbPr9bO+KKd4kwp09KKPhcsMTA0dhhH4S4qC2PcPd/MLs
	7zUdGzubVKSZtkV9uZ1vw==
Message-ID: <6599ad830807160011h39378e24ld24b837da1710d27@mail.gmail.com>
Date: Wed, 16 Jul 2008 00:11:12 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any context (take 2)
Cc: mingo@elte.hu, pj@sgi.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com
In-Reply-To: <1216189268-30122-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216189268-30122-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:21 PM, Max Krasnyansky <maxk@qualcomm.com> wrote:
> From: Max Krasnyanskiy <maxk@qualcomm.com>
>
> Basically as Paul J. pointed out rebuild_sched_domains() is the
> only way to rebuild sched domains correctly based on the current
> cpuset settings. What this means is that we need to be able to
> call it from different contexts, like cpuhotplug for example.
> Also if you look at the cpu_active_map patches, the scheduler now
> calls rebuild_sched_domains() directly from places like
> arch_init_sched_domains().
>
> In order to support that properly we need to change cpuset locking
> a bit, to avoid circular locking dependencies.
> This patch makes rebuild_sched_domains() callable from any context.
> The only requirement now is the the caller has to hold cpu_hotplug.lock
> (ie get_online_cpus()).

Calling get_online_cpus() doesn't technically result in you holding
cpu_hotplug.lock - it ensures that either you're the active
cpu_hotplug writer or else no-one else holds cpu_hotplug.lock and
cpu_hotplug.refcount > 0. Can you specify this more precisely? Maybe
say "the caller has to hold cpu_hotplug for read or write"? A useful
patch might be to rename "struct {} cpu_hotplug" to "struct {}
cpu_hotplug_recursive_rw_mutex", since that's exactly what it is. Then
this patch could say "caller has to hold
cpu_hotplug_recursive_rw_mutex". Yes, it's a bit ugly, but at least it
exposes it properly.

> +       /* We have to iterate cgroup hierarchy, make sure nobody is messing
> +        * with it. */
> +       cgroup_lock();
> +
>        /* Special case for the 99% of systems with one, full, sched domain */
>        if (is_sched_load_balance(&top_cpuset)) {
>                ndoms = 1;
> @@ -598,10 +606,10 @@ void rebuild_sched_domains(void)
>
>        q = kfifo_alloc(number_of_cpusets * sizeof(cp), GFP_KERNEL, NULL);
>        if (IS_ERR(q))
> -               goto done;
> +               goto unlock;
>        csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
>        if (!csa)
> -               goto done;
> +               goto unlock;
>        csn = 0;
>
>        cp = &top_cpuset;
> @@ -688,10 +696,16 @@ restart:
>        BUG_ON(nslot != ndoms);
>
>  rebuild:
> +       /* Drop cgroup lock before calling the scheduler.
> +        * This is not strictly necesseary but simplifies lock nesting. */
> +       cgroup_unlock();
> +
>        /* Have scheduler rebuild sched domains */
> -       get_online_cpus();
>        partition_sched_domains(ndoms, doms, dattr);
> -       put_online_cpus();
> +       goto done;
> +
> +unlock:
> +       cgroup_unlock();

This goto ordering's a bit ugly. rebuild_sched_domains() is ripe for a
refactoring, but I guess that can wait.
> +/*
> + * Internal helper for rebuilding sched domains when something changes.
> + * rebuild_sched_domains() must be called under get_online_cpus() and
> + * it needs to take cgroup_lock(). But most of the cpuset code is already
> + * holding cgroup_lock() while calling __rebuild_sched_domains().
> + * In order to avoid incorrect lock nesting we delegate the actual domain
> + * rebuilding to the workqueue.
> + */
> +static void __rebuild_sched_domains(void)
> +{
> +       queue_work(cpuset_wq, &rebuild_domains_work);
> +}
> +

The __ prefix is normally used to indicate a lower-level or pre-locked
version of a function. In this case it's a higher-level function so I
don't think that prefix is appropriate. How about
async_rebuild_sched_domains() ?

>
> -static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
> +static void common_cpu_mem_hotplug_unplug(void)
>  {
>        cgroup_lock();
>
> @@ -1902,13 +1934,6 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
>        top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>        scan_for_empty_cpusets(&top_cpuset);

This is still unsafe because it accesses cpu_online_map without
get_online_cpus() (when called as the memory hotplug handler)?

Maybe scan_for_empty_cpusets() should take a parameter indicating
whether we're interested in cpus or mems?

>        hotcpu_notifier(cpuset_handle_cpuhp, 0);
> +
> +       cpuset_wq = create_singlethread_workqueue("cpuset");
> +       BUG_ON(!cpuset_wq);

Seems a bit of a shame to waste a kthread on this. Is there no generic
single-threaded workqueue that we could piggyback on? Maybe create one
in workqueue.c that can be used by anyone who specifically needs a
singlethreaded workqueue for occasional work?

Paul
