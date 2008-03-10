Return-Path: <linux-kernel-owner+w=401wt.eu-S1757178AbYCJW1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178AbYCJW1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 18:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753271AbYCJW1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 18:27:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52480 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbYCJW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 18:27:08 -0400
Date: Mon, 10 Mar 2008 15:25:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ego@in.ibm.com
Cc: Gregory Haskins <ghaskins@novell.com>, suresh.b.siddha@intel.com,
       rjw@sisk.pl, dmitry.adamushko@gmail.com, mingo@elte.hu, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: [PATCH] cpu-hotplug: Register update_sched_domains() notifier
 with higher prio
Message-Id: <20080310152556.76868270.akpm@linux-foundation.org>
In-Reply-To: <20080310131355.GF17646@in.ibm.com>
References: <20080308015045.GB15909@linux-os.sc.intel.com>
	<20080308050627.4831.87630.stgit@novell1.haskins.net>
	<20080310081425.GA11031@in.ibm.com>
	<20080310131355.GF17646@in.ibm.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 18:43:55 +0530 Gautham R Shenoy <ego@in.ibm.com> wrote:

> cpu-hotplug: Register update_sched_domains() notifier with higher prio
> From: Gautham R Shenoy <ego@in.ibm.com>
> 
> The current -rt wake_up logic uses the rq->rd->online_map which is
> updated on cpu-hotplug events by update_sched_domains(). Currently
> update_sched_domains() is registered with a priority 0. It is
> preferable that update_sched_domains() be the first notifier called on
> a CPU_DEAD or CPU_ONLINE events inorder to ensure that the
> rq->rd->online_map is in sync with the cpu_online_map.
> 
> This way on a CPU_DOWN_PREPARE,
> we would destroy the sched_domains and reattach all the rq's to the
> def_root_domain. This will be followed by a CPU_DOWN_PREPARE in
> migration_call() which will clear the bit of the cpu going offline
> from the corresponding rq.
> This will ensure that no task will be woken up on the cpu which is
> going to be offlined between CPU_DOWN_PREPARE and CPU_DEAD.
> 
> Ditto for the CPU_ONLINE path.
> 
> Tested on a 4-way Intel Xeon Box with cpu-hotplug tests running in parallel
> with kernbench.
> 
> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> ---
> 
>  kernel/sched.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 69ecb1a..374c46f 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7079,8 +7079,16 @@ void __init sched_init_smp(void)
>  	if (cpus_empty(non_isolated_cpus))
>  		cpu_set(smp_processor_id(), non_isolated_cpus);
>  	put_online_cpus();
> -	/* XXX: Theoretical race here - CPU may be hotplugged now */
> -	hotcpu_notifier(update_sched_domains, 0);
> +	/*
> +	 * XXX: Theoretical race here - CPU may be hotplugged now
> +	 *
> +	 * We register the notifier with priority 11, which means that
> +	 * update_sched_domains() will be called just before migration_call().
> +	 *
> +	 * This is necessary to ensure that the rt wake up logic works fine
> +	 * and the rq->rd->online_map remains in sync with the cpu_online_map.
> +	 */
> +	hotcpu_notifier(update_sched_domains, 11);
>  
>  	/* Move init over to a non-isolated CPU */
>  	if (set_cpus_allowed(current, non_isolated_cpus) < 0)

This fixes my poweroff-doesn't-work post-2.6.24 regression.
