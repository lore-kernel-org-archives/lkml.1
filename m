Return-Path: <linux-kernel-owner+w=401wt.eu-S1751470AbZG3CAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751470AbZG3CAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 22:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbZG3CAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 22:00:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56157 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZG3CAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 22:00:52 -0400
Message-ID: <4A70FEE3.2070302@cn.fujitsu.com>
Date: Thu, 30 Jul 2009 10:01:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       Li Zefan <lizf@cn.fujitsu.com>, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/1] cpu_hotplug: don't play with current->cpus_allowed
References: <20090729023302.GA8899@redhat.com> <20090729212125.GA16970@redhat.com> <20090729214310.GB24631@redhat.com>
In-Reply-To: <20090729214310.GB24631@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> _cpu_down() changes the current task's affinity and then recovers it at
> the end. The problems are well known: we can't restore old_allowed if it
> was bound to the now-dead-cpu, and we can race with the userspace which
> can change cpu-affinity during unplug.
> 
> _cpu_down() should not play with current->cpus_allowed at all. Instead,
> take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
> removes the dying cpu from cpu_online_mask.
> 
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  include/linux/sched.h |    1 +
>  kernel/sched.c        |    2 +-
>  kernel/cpu.c          |   19 ++++++-------------
>  3 files changed, 8 insertions(+), 14 deletions(-)
> 
> --- CPUHP/include/linux/sched.h~CPU_DOWN_AFF	2009-07-23 17:06:39.000000000 +0200
> +++ CPUHP/include/linux/sched.h	2009-07-29 23:27:44.000000000 +0200
> @@ -1794,6 +1794,7 @@ extern void sched_clock_idle_sleep_event
>  extern void sched_clock_idle_wakeup_event(u64 delta_ns);
>  
>  #ifdef CONFIG_HOTPLUG_CPU
> +extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
>  extern void idle_task_exit(void);
>  #else
>  static inline void idle_task_exit(void) {}
> --- CPUHP/kernel/sched.c~CPU_DOWN_AFF	2009-07-29 22:18:33.000000000 +0200
> +++ CPUHP/kernel/sched.c	2009-07-29 23:27:44.000000000 +0200
> @@ -7118,7 +7118,7 @@ static int __migrate_task_irq(struct tas
>  /*
>   * Figure out where task on dead CPU should go, use force if necessary.
>   */
> -static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
> +void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
>  {
>  	int dest_cpu;
>  	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
> --- CPUHP/kernel/cpu.c~CPU_DOWN_AFF	2009-06-23 14:23:52.000000000 +0200
> +++ CPUHP/kernel/cpu.c	2009-07-29 23:27:44.000000000 +0200
> @@ -163,6 +163,7 @@ static inline void check_for_tasks(int c
>  }
>  
>  struct take_cpu_down_param {
> +	struct task_struct *caller;
>  	unsigned long mod;
>  	void *hcpu;
>  };
> @@ -171,6 +172,7 @@ struct take_cpu_down_param {
>  static int __ref take_cpu_down(void *_param)
>  {
>  	struct take_cpu_down_param *param = _param;
> +	unsigned int cpu = (unsigned long)param->hcpu;
>  	int err;
>  
>  	/* Ensure this CPU doesn't handle any more interrupts. */
> @@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_pa
>  	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
>  				param->hcpu);
>  
> +	if (task_cpu(param->caller) == cpu)
> +		move_task_off_dead_cpu(cpu, param->caller);

move_task_off_dead_cpu() calls cpuset_cpus_allowed_locked() which
needs callback_mutex held. But actually we don't hold it, it'll
will corrupt the work of other task which holds callback_mutex.
Is it right?

Lai


