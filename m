Return-Path: <linux-kernel-owner+w=401wt.eu-S1757871AbYCJXhN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871AbYCJXhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 19:37:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbYCJXg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 19:36:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752637AbYCJXg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 19:36:57 -0400
Date: Mon, 10 Mar 2008 16:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: suresh.b.siddha@intel.com, ego@in.ibm.com, rjw@sisk.pl,
       dmitry.adamushko@gmail.com, mingo@elte.hu, oleg@sign.ru,
       yi.y.yang@intel.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH v2] keep rd->online and cpu_online_map in sync
Message-Id: <20080310163613.65a7313c.akpm@linux-foundation.org>
In-Reply-To: <20080310215813.10968.960.stgit@novell1.haskins.net>
References: <20080310221014.GB27329@linux-os.sc.intel.com>
	<20080310215813.10968.960.stgit@novell1.haskins.net>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008 17:59:11 -0400 Gregory Haskins <ghaskins@novell.com> wrote:

> >>> On Mon, Mar 10, 2008 at  6:10 PM, in message
> <20080310221014.GB27329@linux-os.sc.intel.com>, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote: 
> > On Mon, Mar 10, 2008 at 04:00:28PM -0600, Gregory Haskins wrote:
> >> >>> On Mon, Mar 10, 2008 at  6:03 PM, in message 
> > <200803102303.28660.rjw@sisk.pl>,
> >> "Rafael J. Wysocki" <rjw@sisk.pl> wrote: 
> >> > On Monday, 10 of March 2008, Suresh Siddha wrote:
> >> >> >  
> >> >> > -	case CPU_DOWN_PREPARE:
> >> >> > +	case CPU_DYING:
> >> >> 
> >> >> Don't we need to take care of CPU_DYING_FROZEN aswell?
> >> > 
> >> > Well, I'd say we do.
> >> 
> >> Should I add that to the patch as well then?
> > 
> > Yes please.
> 
> Here is v2 with the suggested improvement
> 
> -Greg
> 
> ------------------------
> keep rd->online and cpu_online_map in sync
> 
> It is possible to allow the root-domain cache of online cpus to
> become out of sync with the global cpu_online_map.  This is because we
> currently trigger removal of cpus too early in the notifier chain.
> Other DOWN_PREPARE handlers may in fact run and reconfigure the
> root-domain topology, thereby stomping on our own offline handling.
> 
> The end result is that rd->online may become out of sync with
> cpu_online_map, which results in potential task misrouting.
> 
> So change the offline handling to be more tightly coupled with the
> global offline process by triggering on CPU_DYING intead of
> CPU_DOWN_PREPARE.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> Cc: Gautham R Shenoy <ego@in.ibm.com>
> Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/sched.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 52b9867..1cb53fb 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -5881,7 +5881,8 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		spin_unlock_irq(&rq->lock);
>  		break;
>  
> -	case CPU_DOWN_PREPARE:
> +	case CPU_DYING:
> +	case CPU_DYING_FROZEN:
>  		/* Update our root-domain */
>  		rq = cpu_rq(cpu);
>  		spin_lock_irqsave(&rq->lock, flags);

Does this make
cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio.patch
(below) obsolete, or do we want both?  

--- a/kernel/sched.c~cpu-hotplug-register-update_sched_domains-notifier-with-higher-prio
+++ a/kernel/sched.c
@@ -7096,8 +7096,16 @@ void __init sched_init_smp(void)
 	if (cpus_empty(non_isolated_cpus))
 		cpu_set(smp_processor_id(), non_isolated_cpus);
 	put_online_cpus();
-	/* XXX: Theoretical race here - CPU may be hotplugged now */
-	hotcpu_notifier(update_sched_domains, 0);
+	/*
+	 * XXX: Theoretical race here - CPU may be hotplugged now
+	 *
+	 * We register the notifier with priority 11, which means that
+	 * update_sched_domains() will be called just before migration_call().
+	 *
+	 * This is necessary to ensure that the rt wake up logic works fine
+	 * and the rq->rd->online_map remains in sync with the cpu_online_map.
+	 */
+	hotcpu_notifier(update_sched_domains, 11);
 
 	/* Move init over to a non-isolated CPU */
 	if (set_cpus_allowed(current, non_isolated_cpus) < 0)
_

