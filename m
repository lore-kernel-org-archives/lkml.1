Return-Path: <linux-kernel-owner+w=401wt.eu-S1753149AbYHLDWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbYHLDWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYHLDVx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:21:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.185]:14730 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYHLDVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=sy7aX7D+nk8soZlTgX2315/b2Q7nQjcZrlybmUjZ+hS9QBGaE+e/UNgQYk80tIB/9k
         c6C80Cat9/9rP1xUBY+7ql6qVtctwvpsdhgBezCuTMWYYuZOpvjqTuy2mCBk/uMAPhXo
         BCHF9/S22dgPmRaaEMiw/+I1W34mdpS7+LC/E=
Message-ID: <b9df5fa10808112021v7bb48c9ejefab284bea82c837@mail.gmail.com>
Date: Tue, 12 Aug 2008 09:21:49 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling (take 4)
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48A0B16B.2080801@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218490433-10576-1-git-send-email-maxk@qualcomm.com>
	 <48A0B16B.2080801@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/08, Max Krasnyansky <maxk@qualcomm.com> wrote:
>
>
>  Max Krasnyansky wrote:
>  > This is an updated version of my previous cpuset patch on top of
>  > the latest mainline git.
>  > The patch fixes CPU hotplug handling issues in the current cpusets code.
>  > Namely circular locking in rebuild_sched_domains() and unsafe access to
>  > the cpu_online_map in the cpuset cpu hotplug handler.
>
> Minor correction. I meant unsafe access to the cpu_online_map in the _memory_
>
> hotplug handler.
>
>
>  >
>  > This version includes changes suggested by Paul Jackson (naming, comments,
>  > style, etc). I also got rid of the separate workqueue thread because it is
>  > now safe to call get_online_cpus() from workqueue callbacks.
>  >
>  > --
>  > Here are some more details.
>  >
>  > rebuild_sched_domains() is the only way to rebuild sched domains
>  > correctly based on the current cpuset settings. What this means
>  > is that we need to be able to call it from different contexts,
>  > like cpu hotplug for example.
>  > Also latest scheduler code in -tip now calls rebuild_sched_domains()
>  > directly from functions like arch_reinit_sched_domains().
>  >
>  > In order to support that properly we need to rework cpuset locking
>  > rules to avoid circular dependencies, which is what this patch does.
>  > New lock nesting rules are explained in the comments.
>  > We can now safely call rebuild_sched_domains() from virtually any
>  > context. The only requirement is that it needs to be called under
>  > get_online_cpus(). This allows cpu hotplug handlers and the scheduler
>  > to call rebuild_sched_domains() directly.
>  > The rest of the cpuset code now offloads sched domains rebuilds to
>  > a workqueue (async_rebuild_sched_domains()).
>  >
>  > This version of the patch addresses comments from the previous review.
>  > I fixed all miss-formated comments and trailing spaces.
>  >
>  > I also factored out the code that builds domain masks and split up CPU and
>  > memory hotplug handling. This was needed to simplify locking, to avoid unsafe
>  > access to the cpu_online_map from mem hotplug handler, and in general to make
>  > things cleaner.
>  >
>  > The patch passes moderate testing (building kernel with -j 16, creating &
>  > removing domains and bringing cpus off/online at the same time) on the
>  > quad-core2 based machine.
>  > It passes lockdep checks, even with preemptable RCU enabled.
>  > This time I also tested in with suspend/resume path and everything is working
>  > as expected.
>  >
>  > Signed-off-by: Max Krasnyansky <maxk@qualcomm.com>
>  > Cc: mingo@elte.hu
>  > Cc: pj@sgi.com
>  > Cc: menage@google.com
>  > Cc: a.p.zijlstra@chello.nl
>  > Cc: vegard.nossum@gmail.com
>  > ---
>  >  kernel/cpuset.c |  312 ++++++++++++++++++++++++++++++++-----------------------
>  >  1 files changed, 182 insertions(+), 130 deletions(-)
>  >
>  > diff --git a/kernel/cpuset.c b/kernel/cpuset.c
>  > index d5ab79c..f227bc1 100644
>  > --- a/kernel/cpuset.c
>  > +++ b/kernel/cpuset.c
>  > @@ -14,6 +14,8 @@
>  >   *  2003-10-22 Updates by Stephen Hemminger.
>  >   *  2004 May-July Rework by Paul Jackson.
>  >   *  2006 Rework by Paul Menage to use generic cgroups
>  > + *  2008 Rework of the scheduler domains and CPU hotplug handling
>  > + *       by Max Krasnyansky
>  >   *
>  >   *  This file is subject to the terms and conditions of the GNU General Public
>  >   *  License.  See the file COPYING in the main directory of the Linux
>  > @@ -236,9 +238,11 @@ static struct cpuset top_cpuset = {
>  >
>  >  static DEFINE_MUTEX(callback_mutex);
>  >
>  > -/* This is ugly, but preserves the userspace API for existing cpuset
>  > +/*
>  > + * This is ugly, but preserves the userspace API for existing cpuset
>  >   * users. If someone tries to mount the "cpuset" filesystem, we
>  > - * silently switch it to mount "cgroup" instead */
>  > + * silently switch it to mount "cgroup" instead
>  > + */
>  >  static int cpuset_get_sb(struct file_system_type *fs_type,
>  >                        int flags, const char *unused_dev_name,
>  >                        void *data, struct vfsmount *mnt)
>  > @@ -473,10 +477,9 @@ static int validate_change(const struct cpuset *cur, const struct cpuset *trial)
>  >  }
>  >
>  >  /*
>  > - * Helper routine for rebuild_sched_domains().
>  > + * Helper routine for generate_sched_domains().
>  >   * Do cpusets a, b have overlapping cpus_allowed masks?
>  >   */
>  > -
>  >  static int cpusets_overlap(struct cpuset *a, struct cpuset *b)
>  >  {
>  >       return cpus_intersects(a->cpus_allowed, b->cpus_allowed);
>  > @@ -518,26 +521,15 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
>  >  }
>  >
>  >  /*
>  > - * rebuild_sched_domains()
>  > - *
>  > - * This routine will be called to rebuild the scheduler's dynamic
>  > - * sched domains:
>  > - * - if the flag 'sched_load_balance' of any cpuset with non-empty
>  > - *   'cpus' changes,
>  > - * - or if the 'cpus' allowed changes in any cpuset which has that
>  > - *   flag enabled,
>  > - * - or if the 'sched_relax_domain_level' of any cpuset which has
>  > - *   that flag enabled and with non-empty 'cpus' changes,
>  > - * - or if any cpuset with non-empty 'cpus' is removed,
>  > - * - or if a cpu gets offlined.
>  > - *
>  > - * This routine builds a partial partition of the systems CPUs
>  > - * (the set of non-overlappping cpumask_t's in the array 'part'
>  > - * below), and passes that partial partition to the kernel/sched.c
>  > - * partition_sched_domains() routine, which will rebuild the
>  > - * schedulers load balancing domains (sched domains) as specified
>  > - * by that partial partition.  A 'partial partition' is a set of
>  > - * non-overlapping subsets whose union is a subset of that set.
>  > + * generate_sched_domains()
>  > + *
>  > + * This function builds a partial partition of the systems CPUs
>  > + * A 'partial partition' is a set of non-overlapping subsets whose
>  > + * union is a subset of that set.
>  > + * The output of this function needs to be passed to kernel/sched.c
>  > + * partition_sched_domains() routine, which will rebuild the scheduler's
>  > + * load balancing domains (sched domains) as specified by that partial
>  > + * partition.
>  >   *
>  >   * See "What is sched_load_balance" in Documentation/cpusets.txt
>  >   * for a background explanation of this.
>  > @@ -547,13 +539,7 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
>  >   * domains when operating in the severe memory shortage situations
>  >   * that could cause allocation failures below.
>  >   *
>  > - * Call with cgroup_mutex held.  May take callback_mutex during
>  > - * call due to the kfifo_alloc() and kmalloc() calls.  May nest
>  > - * a call to the get_online_cpus()/put_online_cpus() pair.
>  > - * Must not be called holding callback_mutex, because we must not
>  > - * call get_online_cpus() while holding callback_mutex.  Elsewhere
>  > - * the kernel nests callback_mutex inside get_online_cpus() calls.
>  > - * So the reverse nesting would risk an ABBA deadlock.
>  > + * Must be called with cgroup_lock held.
>  >   *
>  >   * The three key local variables below are:
>  >   *    q  - a linked-list queue of cpuset pointers, used to implement a
>  > @@ -588,10 +574,10 @@ update_domain_attr_tree(struct sched_domain_attr *dattr, struct cpuset *c)
>  >   *   element of the partition (one sched domain) to be passed to
>  >   *   partition_sched_domains().
>  >   */
>  > -
>  > -void rebuild_sched_domains(void)
>  > +static int generate_sched_domains(cpumask_t **domains,
>  > +                     struct sched_domain_attr **attributes)
>  >  {
>  > -     LIST_HEAD(q);           /* queue of cpusets to be scanned*/
>  > +     LIST_HEAD(q);           /* queue of cpusets to be scanned */
>  >       struct cpuset *cp;      /* scans q */
>  >       struct cpuset **csa;    /* array of all cpuset ptrs */
>  >       int csn;                /* how many cpuset ptrs in csa so far */
>  > @@ -601,23 +587,26 @@ void rebuild_sched_domains(void)
>  >       int ndoms;              /* number of sched domains in result */
>  >       int nslot;              /* next empty doms[] cpumask_t slot */
>  >
>  > -     csa = NULL;
>  > +     ndoms = 0;
>  >       doms = NULL;
>  >       dattr = NULL;
>  > +     csa = NULL;
>  >
>  >       /* Special case for the 99% of systems with one, full, sched domain */
>  >       if (is_sched_load_balance(&top_cpuset)) {
>  > -             ndoms = 1;
>  >               doms = kmalloc(sizeof(cpumask_t), GFP_KERNEL);
>  >               if (!doms)
>  > -                     goto rebuild;
>  > +                     goto done;
>  > +
>  >               dattr = kmalloc(sizeof(struct sched_domain_attr), GFP_KERNEL);
>  >               if (dattr) {
>  >                       *dattr = SD_ATTR_INIT;
>  >                       update_domain_attr_tree(dattr, &top_cpuset);
>  >               }
>  >               *doms = top_cpuset.cpus_allowed;
>  > -             goto rebuild;
>  > +
>  > +             ndoms = 1;
>  > +             goto done;
>  >       }
>  >
>  >       csa = kmalloc(number_of_cpusets * sizeof(cp), GFP_KERNEL);
>  > @@ -680,61 +669,141 @@ restart:
>  >               }
>  >       }
>  >
>  > -     /* Convert <csn, csa> to <ndoms, doms> */
>  > +     /*
>  > +      * Now we know how many domains to create.
>  > +      * Convert <csn, csa> to <ndoms, doms> and populate cpu masks.
>  > +      */
>  >       doms = kmalloc(ndoms * sizeof(cpumask_t), GFP_KERNEL);
>  > -     if (!doms)
>  > -             goto rebuild;
>  > +     if (!doms) {
>  > +             ndoms = 0;
>  > +             goto done;
>  > +     }
>  > +
>  > +     /*
>  > +      * The rest of the code, including the scheduler, can deal with
>  > +      * dattr==NULL case. No need to abort if alloc fails.
>  > +      */
>  >       dattr = kmalloc(ndoms * sizeof(struct sched_domain_attr), GFP_KERNEL);
>  >
>  >       for (nslot = 0, i = 0; i < csn; i++) {
>  >               struct cpuset *a = csa[i];
>  > +             cpumask_t *dp;
>  >               int apn = a->pn;
>  >
>  > -             if (apn >= 0) {
>  > -                     cpumask_t *dp = doms + nslot;
>  > -
>  > -                     if (nslot == ndoms) {
>  > -                             static int warnings = 10;
>  > -                             if (warnings) {
>  > -                                     printk(KERN_WARNING
>  > -                                      "rebuild_sched_domains confused:"
>  > -                                       " nslot %d, ndoms %d, csn %d, i %d,"
>  > -                                       " apn %d\n",
>  > -                                       nslot, ndoms, csn, i, apn);
>  > -                                     warnings--;
>  > -                             }
>  > -                             continue;
>  > +             if (apn < 0) {
>  > +                     /* Skip completed partitions */
>  > +                     continue;
>  > +             }
>  > +
>  > +             dp = doms + nslot;
>  > +
>  > +             if (nslot == ndoms) {
>  > +                     static int warnings = 10;
>  > +                     if (warnings) {
>  > +                             printk(KERN_WARNING
>  > +                              "rebuild_sched_domains confused:"
>  > +                               " nslot %d, ndoms %d, csn %d, i %d,"
>  > +                               " apn %d\n",
>  > +                               nslot, ndoms, csn, i, apn);
>  > +                             warnings--;
>  >                       }
>  > +                     continue;
>  > +             }
>  >
>  > -                     cpus_clear(*dp);
>  > -                     if (dattr)
>  > -                             *(dattr + nslot) = SD_ATTR_INIT;
>  > -                     for (j = i; j < csn; j++) {
>  > -                             struct cpuset *b = csa[j];
>  > -
>  > -                             if (apn == b->pn) {
>  > -                                     cpus_or(*dp, *dp, b->cpus_allowed);
>  > -                                     b->pn = -1;
>  > -                                     if (dattr)
>  > -                                             update_domain_attr_tree(dattr
>  > -                                                                + nslot, b);
>  > -                             }
>  > +             cpus_clear(*dp);
>  > +             if (dattr)
>  > +                     *(dattr + nslot) = SD_ATTR_INIT;
>  > +             for (j = i; j < csn; j++) {
>  > +                     struct cpuset *b = csa[j];
>  > +
>  > +                     if (apn == b->pn) {
>  > +                             cpus_or(*dp, *dp, b->cpus_allowed);
>  > +                             if (dattr)
>  > +                                     update_domain_attr_tree(dattr + nslot, b);
>  > +
>  > +                             /* Done with this partition */
>  > +                             b->pn = -1;
>  >                       }
>  > -                     nslot++;
>  >               }
>  > +             nslot++;
>  >       }
>  >       BUG_ON(nslot != ndoms);
>  >
>  > -rebuild:
>  > -     /* Have scheduler rebuild sched domains */
>  > +done:
>  > +     kfree(csa);
>  > +
>  > +     *domains    = doms;
>  > +     *attributes = dattr;
>  > +     return ndoms;
>  > +}
>  > +
>  > +/*
>  > + * Rebuild scheduler domains.
>  > + *
>  > + * Call with neither cgroup_mutex held nor within get_online_cpus().
>  > + * Takes both cgroup_mutex and get_online_cpus().
>  > + *
>  > + * Cannot be directly called from cpuset code handling changes
>  > + * to the cpuset pseudo-filesystem, because it cannot be called
>  > + * from code that already holds cgroup_mutex.
>  > + */
>  > +static void do_rebuild_sched_domains(struct work_struct *unused)
>  > +{
>  > +     struct sched_domain_attr *attr;
>  > +     cpumask_t *doms;
>  > +     int ndoms;
>  > +
>  >       get_online_cpus();
>  > -     partition_sched_domains(ndoms, doms, dattr);
>  > +
>  > +     /* Generate domain masks and attrs */
>  > +     cgroup_lock();
>  > +     ndoms = generate_sched_domains(&doms, &attr);
>  > +     cgroup_unlock();
>  > +
>  > +     /* Have scheduler rebuild the domains */
>  > +     partition_sched_domains(ndoms, doms, attr);
>  > +
>  >       put_online_cpus();
>  > +}
>  >
>  > -done:
>  > -     kfree(csa);
>  > -     /* Don't kfree(doms) -- partition_sched_domains() does that. */
>  > -     /* Don't kfree(dattr) -- partition_sched_domains() does that. */
>  > +static DECLARE_WORK(rebuild_sched_domains_work, do_rebuild_sched_domains);
>  > +
>  > +/*
>  > + * Rebuild scheduler domains, asynchronously via workqueue.
>  > + *
>  > + * If the flag 'sched_load_balance' of any cpuset with non-empty
>  > + * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
>  > + * which has that flag enabled, or if any cpuset with a non-empty
>  > + * 'cpus' is removed, then call this routine to rebuild the
>  > + * scheduler's dynamic sched domains.
>  > + *
>  > + * The rebuild_sched_domains() and partition_sched_domains()
>  > + * routines must nest cgroup_lock() inside get_online_cpus(),
>  > + * but such cpuset changes as these must nest that locking the
>  > + * other way, holding cgroup_lock() for much of the code.
>  > + *
>  > + * So in order to avoid an ABBA deadlock, the cpuset code handling
>  > + * these user changes delegates the actual sched domain rebuilding
>  > + * to a separate workqueue thread, which ends up processing the
>  > + * above do_rebuild_sched_domains() function.
>  > + */
>  > +static void async_rebuild_sched_domains(void)
>  > +{
>  > +     schedule_work(&rebuild_sched_domains_work);
>  > +}
>  > +
>  > +/*
>  > + * Accomplishes the same scheduler domain rebuild as the above
>  > + * async_rebuild_sched_domains(), however it directly calls the
>  > + * rebuild routine synchronously rather than calling it via an
>  > + * asynchronous work thread.
>  > + *
>  > + * This can only be called from code that is not holding
>  > + * cgroup_mutex (not nested in a cgroup_lock() call.)
>  > + */
>  > +void rebuild_sched_domains(void)
>  > +{
>  > +     do_rebuild_sched_domains(NULL);
>  >  }
>  >
>  >  /**
>  > @@ -863,7 +932,7 @@ static int update_cpumask(struct cpuset *cs, const char *buf)
>  >               return retval;
>  >
>  >       if (is_load_balanced)
>  > -             rebuild_sched_domains();
>  > +             async_rebuild_sched_domains();
>  >       return 0;
>  >  }
>  >
>  > @@ -1090,7 +1159,7 @@ static int update_relax_domain_level(struct cpuset *cs, s64 val)
>  >       if (val != cs->relax_domain_level) {
>  >               cs->relax_domain_level = val;
>  >               if (!cpus_empty(cs->cpus_allowed) && is_sched_load_balance(cs))
>  > -                     rebuild_sched_domains();
>  > +                     async_rebuild_sched_domains();
>  >       }
>  >
>  >       return 0;
>  > @@ -1131,7 +1200,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
>  >       mutex_unlock(&callback_mutex);
>  >
>  >       if (cpus_nonempty && balance_flag_changed)
>  > -             rebuild_sched_domains();
>  > +             async_rebuild_sched_domains();
>  >
>  >       return 0;
>  >  }
>  > @@ -1492,6 +1561,9 @@ static u64 cpuset_read_u64(struct cgroup *cont, struct cftype *cft)
>  >       default:
>  >               BUG();
>  >       }
>  > +
>  > +     /* Unreachable but makes gcc happy */
>  > +     return 0;
>  >  }
>  >
>  >  static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
>  > @@ -1504,6 +1576,9 @@ static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
>  >       default:
>  >               BUG();
>  >       }
>  > +
>  > +     /* Unrechable but makes gcc happy */
>  > +     return 0;
>  >  }
>  >
>  >
>  > @@ -1692,15 +1767,9 @@ static struct cgroup_subsys_state *cpuset_create(
>  >  }
>  >
>  >  /*
>  > - * Locking note on the strange update_flag() call below:
>  > - *
>  >   * If the cpuset being removed has its flag 'sched_load_balance'
>  >   * enabled, then simulate turning sched_load_balance off, which
>  > - * will call rebuild_sched_domains().  The get_online_cpus()
>  > - * call in rebuild_sched_domains() must not be made while holding
>  > - * callback_mutex.  Elsewhere the kernel nests callback_mutex inside
>  > - * get_online_cpus() calls.  So the reverse nesting would risk an
>  > - * ABBA deadlock.
>  > + * will call async_rebuild_sched_domains().
>  >   */
>  >
>  >  static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
>  > @@ -1719,7 +1788,7 @@ static void cpuset_destroy(struct cgroup_subsys *ss, struct cgroup *cont)
>  >  struct cgroup_subsys cpuset_subsys = {
>  >       .name = "cpuset",
>  >       .create = cpuset_create,
>  > -     .destroy  = cpuset_destroy,
>  > +     .destroy = cpuset_destroy,
>  >       .can_attach = cpuset_can_attach,
>  >       .attach = cpuset_attach,
>  >       .populate = cpuset_populate,
>  > @@ -1811,7 +1880,7 @@ static void move_member_tasks_to_cpuset(struct cpuset *from, struct cpuset *to)
>  >  }
>  >
>  >  /*
>  > - * If common_cpu_mem_hotplug_unplug(), below, unplugs any CPUs
>  > + * If CPU and/or memory hotplug handlers, below, unplug any CPUs
>  >   * or memory nodes, we need to walk over the cpuset hierarchy,
>  >   * removing that CPU or node from all cpusets.  If this removes the
>  >   * last CPU or node from a cpuset, then move the tasks in the empty
>  > @@ -1903,35 +1972,6 @@ static void scan_for_empty_cpusets(const struct cpuset *root)
>  >  }
>  >
>  >  /*
>  > - * The cpus_allowed and mems_allowed nodemasks in the top_cpuset track
>  > - * cpu_online_map and node_states[N_HIGH_MEMORY].  Force the top cpuset to
>  > - * track what's online after any CPU or memory node hotplug or unplug event.
>  > - *
>  > - * Since there are two callers of this routine, one for CPU hotplug
>  > - * events and one for memory node hotplug events, we could have coded
>  > - * two separate routines here.  We code it as a single common routine
>  > - * in order to minimize text size.
>  > - */
>  > -
>  > -static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
>  > -{
>  > -     cgroup_lock();
>  > -
>  > -     top_cpuset.cpus_allowed = cpu_online_map;
>  > -     top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>  > -     scan_for_empty_cpusets(&top_cpuset);
>  > -
>  > -     /*
>  > -      * Scheduler destroys domains on hotplug events.
>  > -      * Rebuild them based on the current settings.
>  > -      */
>  > -     if (rebuild_sd)
>  > -             rebuild_sched_domains();
>  > -
>  > -     cgroup_unlock();
>  > -}
>  > -
>  > -/*
>  >   * The top_cpuset tracks what CPUs and Memory Nodes are online,
>  >   * period.  This is necessary in order to make cpusets transparent
>  >   * (of no affect) on systems that are actively using CPU hotplug
>  > @@ -1939,40 +1979,52 @@ static void common_cpu_mem_hotplug_unplug(int rebuild_sd)
>  >   *
>  >   * This routine ensures that top_cpuset.cpus_allowed tracks
>  >   * cpu_online_map on each CPU hotplug (cpuhp) event.
>  > + *
>  > + * Called within get_online_cpus().  Needs to call cgroup_lock()
>  > + * before calling generate_sched_domains().
>  >   */
>  > -
>  > -static int cpuset_handle_cpuhp(struct notifier_block *unused_nb,
>  > +static int cpuset_track_online_cpus(struct notifier_block *unused_nb,
>  >                               unsigned long phase, void *unused_cpu)
>  >  {
>  > +     struct sched_domain_attr *attr;
>  > +     cpumask_t *doms;
>  > +     int ndoms;
>  > +
>  >       switch (phase) {
>  > -     case CPU_UP_CANCELED:
>  > -     case CPU_UP_CANCELED_FROZEN:
>  > -     case CPU_DOWN_FAILED:
>  > -     case CPU_DOWN_FAILED_FROZEN:
>  >       case CPU_ONLINE:
>  >       case CPU_ONLINE_FROZEN:
>  >       case CPU_DEAD:
>  >       case CPU_DEAD_FROZEN:
>  > -             common_cpu_mem_hotplug_unplug(1);
>  >               break;
>  > +
>  >       default:
>  >               return NOTIFY_DONE;
>  >       }
>  >
>  > +     cgroup_lock();
>  > +     top_cpuset.cpus_allowed = cpu_online_map;
>  > +     scan_for_empty_cpusets(&top_cpuset);
>  > +     ndoms = generate_sched_domains(&doms, &attr);
>  > +     cgroup_unlock();
>  > +
>  > +     /* Have scheduler rebuild the domains */
>  > +     partition_sched_domains(ndoms, doms, attr);
>  > +
>  >       return NOTIFY_OK;
>  >  }
>  >
>  >  #ifdef CONFIG_MEMORY_HOTPLUG
>  >  /*
>  >   * Keep top_cpuset.mems_allowed tracking node_states[N_HIGH_MEMORY].
>  > - * Call this routine anytime after you change
>  > - * node_states[N_HIGH_MEMORY].
>  > - * See also the previous routine cpuset_handle_cpuhp().
>  > + * Call this routine anytime after node_states[N_HIGH_MEMORY] changes.
>  > + * See also the previous routine cpuset_track_online_cpus().
>  >   */
>  > -
>  >  void cpuset_track_online_nodes(void)
>  >  {
>  > -     common_cpu_mem_hotplug_unplug(0);
>  > +     cgroup_lock();
>  > +     top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>  > +     scan_for_empty_cpusets(&top_cpuset);
>  > +     cgroup_unlock();
>  >  }
>  >  #endif
>  >
>  > @@ -1987,7 +2039,7 @@ void __init cpuset_init_smp(void)
>  >       top_cpuset.cpus_allowed = cpu_online_map;
>  >       top_cpuset.mems_allowed = node_states[N_HIGH_MEMORY];
>  >
>  > -     hotcpu_notifier(cpuset_handle_cpuhp, 0);
>  > +     hotcpu_notifier(cpuset_track_online_cpus, 0);
>  >  }
>  >
   One more thing Max, while you are allocating memory for "dattr"  I
think it  needs to check that it is successful or not . I've shown it
on one of my previous patch on 7th
Aug.
>  >  /**
>  --
>
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  Please read the FAQ at  http://www.tux.org/lkml/
>
