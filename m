Return-Path: <linux-kernel-owner+w=401wt.eu-S1757133AbZLXLFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757133AbZLXLFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 06:05:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbZLXLFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 06:05:23 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48191 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752856AbZLXLFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 06:05:22 -0500
Subject: Re: [PATCH 05/37] kdb: core for kgdb back end
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu, mort@sgi.com,
       linux-arch@vger.kernel.org
In-Reply-To: <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
	 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Dec 2009 12:04:32 +0100
Message-ID: <1261652672.4937.189.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-23 at 15:19 -0600, Jason Wessel wrote:
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 87f1f47..6e1cfcf 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -9785,7 +9785,7 @@ void normalize_rt_tasks(void)
>  
>  #endif /* CONFIG_MAGIC_SYSRQ */
>  
> -#ifdef CONFIG_IA64
> +#if    defined(CONFIG_IA64) || defined(CONFIG_KGDB_KDB)
>  /*
>   * These functions are only useful for the IA64 MCA handling.
>   *
> @@ -10912,6 +10912,97 @@ struct cgroup_subsys cpuacct_subsys = {
>  };
>  #endif /* CONFIG_CGROUP_CPUACCT */
>  
> +#ifdef CONFIG_KGDB_KDB
> +#include <linux/kdb.h>
> +
> +static void
> +kdb_prio(char *name, struct rt_prio_array *array, kdb_printf_t xxx_printf,
> +       unsigned int cpu)
> +{
> +       int pri, printed_header = 0;
> +       struct task_struct *p;
> +
> +       xxx_printf("  %s rt bitmap: 0x%lx 0x%lx 0x%lx\n",
> +               name,
> +               array->bitmap[0], array->bitmap[1], array->bitmap[2]);
> +
> +       pri = sched_find_first_bit(array->bitmap);
> +       if (pri < MAX_RT_PRIO) {
> +               xxx_printf("   rt bitmap priorities:");
> +               while (pri < MAX_RT_PRIO) {
> +                       xxx_printf(" %d", pri);
> +                       pri++;
> +                       pri = find_next_bit(array->bitmap, MAX_RT_PRIO, pri);
> +               }
> +               xxx_printf("\n");
> +       }
> +
> +       for (pri = 0; pri < MAX_RT_PRIO; pri++) {
> +               int printed_hdr = 0;
> +               struct list_head *head, *curr;
> +
> +               head = array->queue + pri;
> +               curr = head->next;
> +               while (curr != head) {
> +                       struct task_struct *task;
> +                       if (!printed_hdr) {
> +                               xxx_printf("   queue at priority=%d\n", pri);
> +                               printed_hdr = 1;
> +                       }
> +                       task = list_entry(curr, struct task_struct,
> +                                         rt.run_list);
> +                       if (task)
> +                               xxx_printf("    0x%p %d %s  time_slice:%d\n",
> +                                  task, task->pid, task->comm,
> +                                  task->rt.time_slice);
> +                       curr = curr->next;
> +               }
> +       }
> +       for_each_process(p) {
> +               if (p->se.on_rq && (task_cpu(p) == cpu) &&
> +                  (p->policy == SCHED_NORMAL)) {
> +                       if (!printed_header) {
> +                               xxx_printf("  sched_normal queue:\n");
> +                               printed_header = 1;
> +                       }
> +                       xxx_printf("    0x%p %d %s pri:%d spri:%d npri:%d\n",
> +                               p, p->pid, p->comm, p->prio,
> +                               p->static_prio, p->normal_prio);
> +               }
> +       }
> +}
> +
> +/* This code must be in sched.c because struct rq is only defined in this
> + * source.  To allow most of kdb to be modular, this code cannot call any kdb
> + * functions directly, any external functions that it needs must be passed in
> + * as parameters.
> + */

Wrong comment style.

> +void
> +kdb_runqueue(unsigned long cpu, kdb_printf_t xxx_printf)
> +{
> +       struct rq *rq;
> +
> +       rq = cpu_rq(cpu);
> +
> +       xxx_printf("CPU%ld lock:%s curr:0x%p(%d)(%s)",
> +                  cpu, (raw_spin_is_locked(&rq->lock)) ? "LOCKED" : "free",
> +                  rq->curr, rq->curr->pid, rq->curr->comm);
> +       if (rq->curr == rq->idle)
> +               xxx_printf(" is idle");
> +       xxx_printf("\n ");
> +#ifdef CONFIG_SMP
> +       xxx_printf(" cpu_load:%lu %lu %lu",
> +                       rq->cpu_load[0], rq->cpu_load[1], rq->cpu_load[2]);
> +#endif
> +       xxx_printf(" nr_running:%lu nr_switches:%llu\n",
> +                  rq->nr_running, (long long)rq->nr_switches);
> +       kdb_prio("active", &rq->rt.active, xxx_printf, (unsigned int)cpu);
> +}
> +EXPORT_SYMBOL(kdb_runqueue);
> +
> +#endif /* CONFIG_KGDB_KDB */
> +

So what is this code supposed to do? It looks like it simply cannot be
correct.

