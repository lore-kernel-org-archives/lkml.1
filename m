Return-Path: <linux-kernel-owner+w=401wt.eu-S1759322AbYGPI5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322AbYGPI5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 04:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754846AbYGPI5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 04:57:32 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:65201 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYGPI5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 04:57:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EjuJHLbBxqW3GNJPlL1XqAkhDZwseDgwvc9qoWW8mVJr+Yxq74VeuvbnzR4TemUixB
         5RTVBswpRLCC1jmq7gsHt6E7nU2XecUVJJm0Xp3PNZtjs7bf8yh5xQxlClMSy38z8eph
         GrKPQqEJhZjVd0NjbRRGhFppCI2H+ubWG/R84=
Message-ID: <b647ffbd0807160157maba3934vef9b9d74680d6508@mail.gmail.com>
Date: Wed, 16 Jul 2008 10:57:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [PATCH] cpu hotplug, sched: Introduce cpu_active_map and redo sched domain managment (take 2)
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
       pj@sgi.com, ghaskins@novell.com, linux-kernel@vger.kernel.org
In-Reply-To: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216122229-4865-1-git-send-email-maxk@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Max Krasnyansky <maxk@qualcomm.com>:
> From: Max Krasnyanskiy <maxk@qualcomm.com>
>
> Addressed Ingo's comments and merged on top of latest Linus's tree.

a few remarks:

(1) in __migrate_task(), a test for !cpu_active(dest_cpu) should be
done after double_rq_lock() [ or add the second one ]

migration_thread() calls __migrate_task() with disabled interrupts (no
rq-locks held), i.e. if we merely rely on rq-locks for
synchronization, this can race with cpu_down(dest_cpu).

[ assume, the test was done in __migration_task() and it's about to
take double_lock()... and at this time, down_cpu(dest_cpu) starts and
completes on another CPU ]

note, we may still take the rq-lock for a "dead" cpu in this case and
then only do a check (remark: in fact, not with stop_machine() in
place _but_ I consider that we don't make any assumptions on its
behavior);

(2) it's worth to take a look at the use of any_online_cpu():

many places are ok, because there will be an additional check against
cpu_active_mask later on, but e.g.

set_cpus_allowed_ptr() ->
migrate_task(p, any_online_cpu(mask), ...) ->
migrate_task(p, dest_cpu)

doesn't seem to have any verifications wrt cpu_active_map.

(3) I assume, we have some kind of explicit sched_sync() after
cpu_clear(cpu, cpu_active_mask) because:

(a) not all places where task-migration may take place do take the
rq-lock for dest_cpu : e.g. try_to_wake_up() or even
sched_migrate_task() [ yes, there is a special (one might call
"subtle") assumption/restriction in this case ]

that's why the fact that cpu_down() takes the rq-lock for
soon-to-be-offline cpu at some point can not be a "natural" sync.
point to guarantee that "stale" cpu_active_map is not used.

(b) in fact, stop_machine() acts as a (very strong) sync. point,
sched-wise. But perhaps, we don't want to have this new easy-to-follow
approach to be built on top of assumptions on how something from
another sub-system behaves.

>
> This is based on Linus' idea of creating cpu_active_map that prevents
> scheduler load balancer from migrating tasks to the cpu that is going
> down.
>
> It allows us to simplify domain management code and avoid unecessary
> domain rebuilds during cpu hotplug event handling.
>
> Please ignore the cpusets part for now. It needs some more work in order
> to avoid crazy lock nesting. Although I did simplfy and unify domain
> reinitialization logic. We now simply call partition_sched_domains() in
> all the cases. This means that we're using exact same code paths as in
> cpusets case and hence the test below cover cpusets too.
> Cpuset changes to make rebuild_sched_domains() callable from various
> contexts are in the separate patch (right next after this one).
>
> This not only boots but also easily handles
>        while true; do make clean; make -j 8; done
> and
>        while true; do on-off-cpu 1; done
> at the same time.
> (on-off-cpu 1 simple does echo 0/1 > /sys/.../cpu1/online thing).
>
> Suprisingly the box (dual-core Core2) is quite usable. In fact I'm typing
> this on right now in gnome-terminal and things are moving just fine.
>
> Also this is running with most of the debug features enabled (lockdep,
> mutex, etc) no BUG_ONs or lockdep complaints so far.
>
> I beleive I addressed all of the Dmitry's comments for original Linus'
> version. I changed both fair and rt balancer to mask out non-active cpus.
> And replaced cpu_is_offline() with !cpu_active() in the main scheduler
> code where it made sense (to me).
>
> Peter, please take a look at how I merged it with your latest RT runtime
> fixes. I basically moved calls to disable_runtime() into the separate
> notifier callback since we do not need update_sched_domains() anymore if
> cpusets are enabled.
>
> Greg, please take a look at the RT balancer merge. I decided not to muck
> with the cpupri thing and instead mask inactive cpus after the search.
>
> I've probably missed something but I'd dare to say consider for the
> inclusion ;-)
>
> Signed-off-by: Max Krasnyanskiy <maxk@qualcomm.com>
> Cc: ghaskins@novell.com
> Cc: Max Krasnyanskiy <maxk@qualcomm.com>
> Cc: dmitry.adamushko@gmail.com
> Cc: a.p.zijlstra@chello.nl
> Cc: torvalds@linux-foundation.org
> Cc: pj@sgi.com
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/linux/cpumask.h |    6 ++-
>  include/linux/cpuset.h  |    7 +++
>  init/main.c             |    7 +++
>  kernel/cpu.c            |   30 ++++++++++---
>  kernel/cpuset.c         |    2 +-
>  kernel/sched.c          |  108 +++++++++++++++++++---------------------------
>  kernel/sched_fair.c     |    3 +
>  kernel/sched_rt.c       |    7 +++
>  8 files changed, 99 insertions(+), 71 deletions(-)
>
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index c24875b..d614d24 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -359,13 +359,14 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
>
>  /*
>  * The following particular system cpumasks and operations manage
> - * possible, present and online cpus.  Each of them is a fixed size
> + * possible, present, active and online cpus.  Each of them is a fixed size
>  * bitmap of size NR_CPUS.
>  *
>  *  #ifdef CONFIG_HOTPLUG_CPU
>  *     cpu_possible_map - has bit 'cpu' set iff cpu is populatable
>  *     cpu_present_map  - has bit 'cpu' set iff cpu is populated
>  *     cpu_online_map   - has bit 'cpu' set iff cpu available to scheduler
> + *     cpu_active_map   - has bit 'cpu' set iff cpu available to migration
>  *  #else
>  *     cpu_possible_map - has bit 'cpu' set iff cpu is populated
>  *     cpu_present_map  - copy of cpu_possible_map
> @@ -416,6 +417,7 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
>  extern cpumask_t cpu_possible_map;
>  extern cpumask_t cpu_online_map;
>  extern cpumask_t cpu_present_map;
> +extern cpumask_t cpu_active_map;
>
>  #if NR_CPUS > 1
>  #define num_online_cpus()      cpus_weight(cpu_online_map)
> @@ -424,6 +426,7 @@ extern cpumask_t cpu_present_map;
>  #define cpu_online(cpu)                cpu_isset((cpu), cpu_online_map)
>  #define cpu_possible(cpu)      cpu_isset((cpu), cpu_possible_map)
>  #define cpu_present(cpu)       cpu_isset((cpu), cpu_present_map)
> +#define cpu_active(cpu)                cpu_isset((cpu), cpu_active_map)
>  #else
>  #define num_online_cpus()      1
>  #define num_possible_cpus()    1
> @@ -431,6 +434,7 @@ extern cpumask_t cpu_present_map;
>  #define cpu_online(cpu)                ((cpu) == 0)
>  #define cpu_possible(cpu)      ((cpu) == 0)
>  #define cpu_present(cpu)       ((cpu) == 0)
> +#define cpu_active(cpu)                ((cpu) == 0)
>  #endif
>
>  #define cpu_is_offline(cpu)    unlikely(!cpu_online(cpu))
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 0385783..e8f450c 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -78,6 +78,8 @@ extern void cpuset_track_online_nodes(void);
>
>  extern int current_cpuset_is_being_rebound(void);
>
> +extern void rebuild_sched_domains(void);
> +
>  #else /* !CONFIG_CPUSETS */
>
>  static inline int cpuset_init_early(void) { return 0; }
> @@ -156,6 +158,11 @@ static inline int current_cpuset_is_being_rebound(void)
>        return 0;
>  }
>
> +static inline void rebuild_sched_domains(void)
> +{
> +       partition_sched_domains(0, NULL, NULL);
> +}
> +
>  #endif /* !CONFIG_CPUSETS */
>
>  #endif /* _LINUX_CPUSET_H */
> diff --git a/init/main.c b/init/main.c
> index f7fb200..bfccff6 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -414,6 +414,13 @@ static void __init smp_init(void)
>  {
>        unsigned int cpu;
>
> +       /*
> +        * Set up the current CPU as possible to migrate to.
> +        * The other ones will be done by cpu_up/cpu_down()
> +        */
> +       cpu = smp_processor_id();
> +       cpu_set(cpu, cpu_active_map);
> +
>        /* FIXME: This should be done in userspace --RR */
>        for_each_present_cpu(cpu) {
>                if (num_online_cpus() >= setup_max_cpus)
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index b11f06d..71c5c9d 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -64,6 +64,8 @@ void __init cpu_hotplug_init(void)
>        cpu_hotplug.refcount = 0;
>  }
>
> +cpumask_t cpu_active_map;
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>
>  void get_online_cpus(void)
> @@ -291,11 +293,20 @@ int __ref cpu_down(unsigned int cpu)
>        int err = 0;
>
>        cpu_maps_update_begin();
> -       if (cpu_hotplug_disabled)
> +
> +       if (cpu_hotplug_disabled) {
>                err = -EBUSY;
> -       else
> -               err = _cpu_down(cpu, 0);
> +               goto out;
> +       }
> +
> +       cpu_clear(cpu, cpu_active_map);
> +
> +       err = _cpu_down(cpu, 0);
> +
> +       if (cpu_online(cpu))
> +               cpu_set(cpu, cpu_active_map);
>
> +out:
>        cpu_maps_update_done();
>        return err;
>  }
> @@ -354,11 +365,18 @@ int __cpuinit cpu_up(unsigned int cpu)
>        }
>
>        cpu_maps_update_begin();
> -       if (cpu_hotplug_disabled)
> +
> +       if (cpu_hotplug_disabled) {
>                err = -EBUSY;
> -       else
> -               err = _cpu_up(cpu, 0);
> +               goto out;
> +       }
>
> +       err = _cpu_up(cpu, 0);
> +
> +       if (cpu_online(cpu))
> +               cpu_set(cpu, cpu_active_map);
> +
> +out:
>        cpu_maps_update_done();
>        return err;
>  }
> diff --git a/kernel/cpuset.c b/kernel/cpuset.c
> index 459d601..3c3ef02 100644
> --- a/kernel/cpuset.c
> +++ b/kernel/cpuset.c
> @@ -564,7 +564,7 @@ update_domain_attr(struct sched_domain_attr *dattr, struct cpuset *c)
>  *     partition_sched_domains().
>  */
>
> -static void rebuild_sched_domains(void)
> +void rebuild_sched_domains(void)
>  {
>        struct kfifo *q;        /* queue of cpusets to be scanned */
>        struct cpuset *cp;      /* scans q */
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 99e6d85..9019f63 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2881,7 +2881,7 @@ static void sched_migrate_task(struct task_struct *p, int dest_cpu)
>
>        rq = task_rq_lock(p, &flags);
>        if (!cpu_isset(dest_cpu, p->cpus_allowed)
> -           || unlikely(cpu_is_offline(dest_cpu)))
> +           || unlikely(!cpu_active(dest_cpu)))
>                goto out;
>
>        /* force the process onto the specified CPU */
> @@ -3849,7 +3849,7 @@ int select_nohz_load_balancer(int stop_tick)
>                /*
>                 * If we are going offline and still the leader, give up!
>                 */
> -               if (cpu_is_offline(cpu) &&
> +               if (!cpu_active(cpu) &&
>                    atomic_read(&nohz.load_balancer) == cpu) {
>                        if (atomic_cmpxchg(&nohz.load_balancer, cpu, -1) != cpu)
>                                BUG();
> @@ -5876,7 +5876,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>        struct rq *rq_dest, *rq_src;
>        int ret = 0, on_rq;
>
> -       if (unlikely(cpu_is_offline(dest_cpu)))
> +       if (unlikely(!cpu_active(dest_cpu)))
>                return ret;
>
>        rq_src = cpu_rq(src_cpu);
> @@ -7553,18 +7553,6 @@ void __attribute__((weak)) arch_update_cpu_topology(void)
>  }
>
>  /*
> - * Free current domain masks.
> - * Called after all cpus are attached to NULL domain.
> - */
> -static void free_sched_domains(void)
> -{
> -       ndoms_cur = 0;
> -       if (doms_cur != &fallback_doms)
> -               kfree(doms_cur);
> -       doms_cur = &fallback_doms;
> -}
> -
> -/*
>  * Set up scheduler domains and groups. Callers must hold the hotplug lock.
>  * For now this just excludes isolated cpus, but could be used to
>  * exclude other special cases in the future.
> @@ -7642,7 +7630,7 @@ static int dattrs_equal(struct sched_domain_attr *cur, int idx_cur,
>  * ownership of it and will kfree it when done with it. If the caller
>  * failed the kmalloc call, then it can pass in doms_new == NULL,
>  * and partition_sched_domains() will fallback to the single partition
> - * 'fallback_doms'.
> + * 'fallback_doms', it also forces the domains to be rebuilt.
>  *
>  * Call with hotplug lock held
>  */
> @@ -7656,12 +7644,8 @@ void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
>        /* always unregister in case we don't destroy any domains */
>        unregister_sched_domain_sysctl();
>
> -       if (doms_new == NULL) {
> -               ndoms_new = 1;
> -               doms_new = &fallback_doms;
> -               cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
> -               dattr_new = NULL;
> -       }
> +       if (doms_new == NULL)
> +               ndoms_new = 0;
>
>        /* Destroy deleted domains */
>        for (i = 0; i < ndoms_cur; i++) {
> @@ -7676,6 +7660,14 @@ match1:
>                ;
>        }
>
> +       if (doms_new == NULL) {
> +               ndoms_cur = 0;
> +               ndoms_new = 1;
> +               doms_new = &fallback_doms;
> +               cpus_andnot(doms_new[0], cpu_online_map, cpu_isolated_map);
> +               dattr_new = NULL;
> +       }
> +
>        /* Build new domains */
>        for (i = 0; i < ndoms_new; i++) {
>                for (j = 0; j < ndoms_cur; j++) {
> @@ -7706,17 +7698,10 @@ match2:
>  #if defined(CONFIG_SCHED_MC) || defined(CONFIG_SCHED_SMT)
>  int arch_reinit_sched_domains(void)
>  {
> -       int err;
> -
>        get_online_cpus();
> -       mutex_lock(&sched_domains_mutex);
> -       detach_destroy_domains(&cpu_online_map);
> -       free_sched_domains();
> -       err = arch_init_sched_domains(&cpu_online_map);
> -       mutex_unlock(&sched_domains_mutex);
> +       rebuild_sched_domains();
>        put_online_cpus();
> -
> -       return err;
> +       return 0;
>  }
>
>  static ssize_t sched_power_savings_store(const char *buf, size_t count, int smt)
> @@ -7782,59 +7767,49 @@ int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
>  }
>  #endif /* CONFIG_SCHED_MC || CONFIG_SCHED_SMT */
>
> +#ifndef CONFIG_CPUSETS
>  /*
> - * Force a reinitialization of the sched domains hierarchy. The domains
> - * and groups cannot be updated in place without racing with the balancing
> - * code, so we temporarily attach all running cpus to the NULL domain
> - * which will prevent rebalancing while the sched domains are recalculated.
> + * Add online and remove offline CPUs from the scheduler domains.
> + * When cpusets are enabled they take over this function.
>  */
>  static int update_sched_domains(struct notifier_block *nfb,
>                                unsigned long action, void *hcpu)
>  {
> +       switch (action) {
> +       case CPU_ONLINE:
> +       case CPU_ONLINE_FROZEN:
> +       case CPU_DEAD:
> +       case CPU_DEAD_FROZEN:
> +               partition_sched_domains(0, NULL, NULL);
> +               return NOTIFY_OK;
> +
> +       default:
> +               return NOTIFY_DONE;
> +       }
> +}
> +#endif
> +
> +static int update_runtime(struct notifier_block *nfb,
> +                               unsigned long action, void *hcpu)
> +{
>        int cpu = (int)(long)hcpu;
>
>        switch (action) {
>        case CPU_DOWN_PREPARE:
>        case CPU_DOWN_PREPARE_FROZEN:
>                disable_runtime(cpu_rq(cpu));
> -               /* fall-through */
> -       case CPU_UP_PREPARE:
> -       case CPU_UP_PREPARE_FROZEN:
> -               detach_destroy_domains(&cpu_online_map);
> -               free_sched_domains();
>                return NOTIFY_OK;
>
> -
>        case CPU_DOWN_FAILED:
>        case CPU_DOWN_FAILED_FROZEN:
>        case CPU_ONLINE:
>        case CPU_ONLINE_FROZEN:
>                enable_runtime(cpu_rq(cpu));
> -               /* fall-through */
> -       case CPU_UP_CANCELED:
> -       case CPU_UP_CANCELED_FROZEN:
> -       case CPU_DEAD:
> -       case CPU_DEAD_FROZEN:
> -               /*
> -                * Fall through and re-initialise the domains.
> -                */
> -               break;
> +               return NOTIFY_OK;
> +
>        default:
>                return NOTIFY_DONE;
>        }
> -
> -#ifndef CONFIG_CPUSETS
> -       /*
> -        * Create default domain partitioning if cpusets are disabled.
> -        * Otherwise we let cpusets rebuild the domains based on the
> -        * current setup.
> -        */
> -
> -       /* The hotplug lock is already held by cpu_up/cpu_down */
> -       arch_init_sched_domains(&cpu_online_map);
> -#endif
> -
> -       return NOTIFY_OK;
>  }
>
>  void __init sched_init_smp(void)
> @@ -7854,8 +7829,15 @@ void __init sched_init_smp(void)
>                cpu_set(smp_processor_id(), non_isolated_cpus);
>        mutex_unlock(&sched_domains_mutex);
>        put_online_cpus();
> +
> +#ifndef CONFIG_CPUSETS
>        /* XXX: Theoretical race here - CPU may be hotplugged now */
>        hotcpu_notifier(update_sched_domains, 0);
> +#endif
> +
> +       /* RT runtime code needs to handle some hotplug events */
> +       hotcpu_notifier(update_runtime, 0);
> +
>        init_hrtick();
>
>        /* Move init over to a non-isolated CPU */
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f2aa987..d924c67 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -1004,6 +1004,8 @@ static void yield_task_fair(struct rq *rq)
>  * not idle and an idle cpu is available.  The span of cpus to
>  * search starts with cpus closest then further out as needed,
>  * so we always favor a closer, idle cpu.
> + * Domains may include CPUs that are not usable for migration,
> + * hence we need to mask them out (cpu_active_map)
>  *
>  * Returns the CPU we should wake onto.
>  */
> @@ -1031,6 +1033,7 @@ static int wake_idle(int cpu, struct task_struct *p)
>                    || ((sd->flags & SD_WAKE_IDLE_FAR)
>                        && !task_hot(p, task_rq(p)->clock, sd))) {
>                        cpus_and(tmp, sd->span, p->cpus_allowed);
> +                       cpus_and(tmp, tmp, cpu_active_map);
>                        for_each_cpu_mask(i, tmp) {
>                                if (idle_cpu(i)) {
>                                        if (i != task_cpu(p)) {
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 47ceac9..5166080 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -922,6 +922,13 @@ static int find_lowest_rq(struct task_struct *task)
>                return -1; /* No targets found */
>
>        /*
> +        * Only consider CPUs that are usable for migration.
> +        * I guess we might want to change cpupri_find() to ignore those
> +        * in the first place.
> +        */
> +       cpus_and(*lowest_mask, *lowest_mask, cpu_active_map);
> +
> +       /*
>         * At this point we have built a mask of cpus representing the
>         * lowest priority tasks in the system.  Now we want to elect
>         * the best one based on our affinity and topology.
> --
> 1.5.5.1
>
>



-- 
Best regards,
Dmitry Adamushko
