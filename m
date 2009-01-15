Return-Path: <linux-kernel-owner+w=401wt.eu-S1762827AbZAONKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762827AbZAONKU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:10:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbZAONKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:10:01 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:61004 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbZAONKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Y4lgYQkN2ftRWcU+xefoeMp0/aN8NPaN+1UGA1rggXKRWJ/uosCi3JUVeneiyOdBFn
         fFO3SVXWzAFnqctr4jqxYBJdOADaONcFrA80n+0W2gx7Q7017raIBwkIChXixxse9Kjy
         AV9MbvItKLGxCJEQfZCKQ9P7knLY/m0r1FE6w=
Message-ID: <c62985530901150509we244b70l4e7af5c6b6145f30@mail.gmail.com>
Date: Thu, 15 Jan 2009 14:09:54 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Lai Jiangshan" <laijs@cn.fujitsu.com>
Subject: Re: [PATCH -tip] trace_workqueue: use percpu data for workqueue stat
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <496F25A8.5040303@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <496F25A8.5040303@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lai,

2009/1/15 Lai Jiangshan <laijs@cn.fujitsu.com>:
>
> Impact: make trace_workqueue works well on NUMA
>
> It's not correct when (num_possible_cpus() < nr_cpumask_bits):
>        all_workqueue_stat = kmalloc(sizeof(struct workqueue_global_stats)
>                                     * num_possible_cpus(), GFP_KERNEL);


What is the difference between num_possible_cpus() and nr_cpumask_bits actually?
It looks like nr_cpumask_bits binds to NR_CPUS on early time and after
it is set to
num_possible_cpus() , right?
In this case num_possible_cpus() seems more relevant...no?

(I'm pretty sure I'm wrong.... :-)

> And alloc_percpu() allocate the cpu's data on the cpu's memory node.

Ok.

Thanks.
Frederic.


> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index f8118d3..79617e2 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -8,6 +8,7 @@
>
>  #include <trace/workqueue.h>
>  #include <linux/list.h>
> +#include <linux/percpu.h>
>  #include "trace_stat.h"
>  #include "trace.h"
>
> @@ -38,6 +39,7 @@ struct workqueue_global_stats {
>  * never freed.
>  */
>  static struct workqueue_global_stats *all_workqueue_stat;
> +#define workqueue_cpu_stat(cpu) per_cpu_ptr(all_workqueue_stat, cpu)
>
>  /* Insertion of a work */
>  static void
> @@ -48,8 +50,8 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
>        struct cpu_workqueue_stats *node, *next;
>        unsigned long flags;
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
>                                                        list) {
>                if (node->pid == wq_thread->pid) {
>                        atomic_inc(&node->inserted);
> @@ -58,7 +60,7 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
>        }
>        pr_debug("trace_workqueue: entry not found\n");
>  found:
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
>
>  /* Execution of a work */
> @@ -70,8 +72,8 @@ probe_workqueue_execution(struct task_struct *wq_thread,
>        struct cpu_workqueue_stats *node, *next;
>        unsigned long flags;
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
>                                                        list) {
>                if (node->pid == wq_thread->pid) {
>                        node->executed++;
> @@ -80,7 +82,7 @@ probe_workqueue_execution(struct task_struct *wq_thread,
>        }
>        pr_debug("trace_workqueue: entry not found\n");
>  found:
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
>
>  /* Creation of a cpu workqueue thread */
> @@ -104,11 +106,11 @@ static void probe_workqueue_creation(struct task_struct *wq_thread, int cpu)
>
>        cws->pid = wq_thread->pid;
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       if (list_empty(&all_workqueue_stat[cpu].list))
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       if (list_empty(&workqueue_cpu_stat(cpu)->list))
>                cws->first_entry = true;
> -       list_add_tail(&cws->list, &all_workqueue_stat[cpu].list);
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       list_add_tail(&cws->list, &workqueue_cpu_stat(cpu)->list);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>  }
>
>  /* Destruction of a cpu workqueue thread */
> @@ -119,8 +121,8 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
>        struct cpu_workqueue_stats *node, *next;
>        unsigned long flags;
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       list_for_each_entry_safe(node, next, &all_workqueue_stat[cpu].list,
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
>                                                        list) {
>                if (node->pid == wq_thread->pid) {
>                        list_del(&node->list);
> @@ -131,7 +133,7 @@ static void probe_workqueue_destruction(struct task_struct *wq_thread)
>
>        pr_debug("trace_workqueue: don't find workqueue to destroy\n");
>  found:
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>
>  }
>
> @@ -141,13 +143,13 @@ static struct cpu_workqueue_stats *workqueue_stat_start_cpu(int cpu)
>        struct cpu_workqueue_stats *ret = NULL;
>
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
>
> -       if (!list_empty(&all_workqueue_stat[cpu].list))
> -               ret = list_entry(all_workqueue_stat[cpu].list.next,
> +       if (!list_empty(&workqueue_cpu_stat(cpu)->list))
> +               ret = list_entry(workqueue_cpu_stat(cpu)->list.next,
>                                 struct cpu_workqueue_stats, list);
>
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>
>        return ret;
>  }
> @@ -172,9 +174,9 @@ static void *workqueue_stat_next(void *prev, int idx)
>        unsigned long flags;
>        void *ret = NULL;
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       if (list_is_last(&prev_cws->list, &all_workqueue_stat[cpu].list)) {
> -               spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       if (list_is_last(&prev_cws->list, &workqueue_cpu_stat(cpu)->list)) {
> +               spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>                for (++cpu ; cpu < num_possible_cpus(); cpu++) {
>                        ret = workqueue_stat_start_cpu(cpu);
>                        if (ret)
> @@ -182,7 +184,7 @@ static void *workqueue_stat_next(void *prev, int idx)
>                }
>                return NULL;
>        }
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>
>        return list_entry(prev_cws->list.next, struct cpu_workqueue_stats,
>                          list);
> @@ -199,10 +201,10 @@ static int workqueue_stat_show(struct seq_file *s, void *p)
>                   cws->executed,
>                   trace_find_cmdline(cws->pid));
>
> -       spin_lock_irqsave(&all_workqueue_stat[cpu].lock, flags);
> -       if (&cws->list == all_workqueue_stat[cpu].list.next)
> +       spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> +       if (&cws->list == workqueue_cpu_stat(cpu)->list.next)
>                seq_printf(s, "\n");
> -       spin_unlock_irqrestore(&all_workqueue_stat[cpu].lock, flags);
> +       spin_unlock_irqrestore(&workqueue_cpu_stat(cpu)->lock, flags);
>
>        return 0;
>  }
> @@ -258,8 +260,7 @@ int __init trace_workqueue_early_init(void)
>        if (ret)
>                goto no_creation;
>
> -       all_workqueue_stat = kmalloc(sizeof(struct workqueue_global_stats)
> -                                    * num_possible_cpus(), GFP_KERNEL);
> +       all_workqueue_stat = alloc_percpu(struct workqueue_global_stats);
>
>        if (!all_workqueue_stat) {
>                pr_warning("trace_workqueue: not enough memory\n");
> @@ -267,8 +268,8 @@ int __init trace_workqueue_early_init(void)
>        }
>
>        for_each_possible_cpu(cpu) {
> -               spin_lock_init(&all_workqueue_stat[cpu].lock);
> -               INIT_LIST_HEAD(&all_workqueue_stat[cpu].list);
> +               spin_lock_init(&workqueue_cpu_stat(cpu)->lock);
> +               INIT_LIST_HEAD(&workqueue_cpu_stat(cpu)->list);
>        }
>
>        return 0;
>
>
>
