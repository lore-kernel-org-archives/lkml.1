Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0BBWmn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:42:43 -0500
Received: from science.horizon.com ([71.41.210.146]:53709 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754747Ab0BBWmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:42:42 -0500
Date: 2 Feb 2010 17:42:41 -0500
Message-ID: <20100202224241.10918.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: rostedt@goodmis.org
Subject: Re: [patch 2/3] scheduler: add full memory barriers upon task
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> again:
>   tmp_mask = mm_cpumask(current->mm);
>   smp_mb();
>    rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
>    for_each_cpu(cpu, tmp_mask) {
>      spin_lock_irq(&cpu_rq(cpu)->lock);
>      ret = current->mm == cpu_curr(cpu)->mm;
>      spin_unlock_irq(&cpu_rq(cpu)->lock);
>      if (ret)
>        smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
>    }
>    rcu_read_unlock();
>    smp_mb();
>    if (tmp_mask != mm_cpumask(current->mm)) {
>       /* do check for signals here */
>       goto again;
>    }

How about the harder-to-livelock version that avoids sending
a second IPI to all the processors if the retry condition
hits?

(It also caches current->mm across the various barriers, as I think the
compiler will have difficulty inferring that otherwise).


cpumask_t unsent_mask;
cpumask_setall(&unsent_mask);
cpumask_clear_cpu(smp_processor_id(), &unsent_mask);

struct mm_struct const *current_mm = current->mm;

for (;;) {
    cpumask_t const *tmp_mask = mm_cpumask(current_mm);
    int cpu = cpumask_next_and(-1, tmp_mask, &unsent_mask);

    if (cpu > nr_cpu_ids)
	break;

    smp_mb();
    rcu_read_lock(); /* ensures validity of cpu_curr(cpu) tasks */
    do {
	struct mm_struct const *other_mm;
	spin_lock_irq(&cpu_rq(cpu)->lock);
	other_mm = cpu_curr(cpu)->mm;
	spin_unlock_irq(&cpu_rq(cpu)->lock);
	if (other_mm == current_mm) {
	    smp_call_function_single(cpu, membarrier_ipi, NULL, 1);
	    cpumask_clear_cpu(cpu, &unsent_mask);
        }
	cpu = cpumask_next_and(cpu, tmp_mask, &unsent_mask);
    } while (cpu < nr_cpu_ids);
    rcu_read_unlock();
    smp_mb();
    /* And now check again if any more CPUs have joined the mm */
}
