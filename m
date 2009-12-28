Return-Path: <linux-kernel-owner+w=401wt.eu-S1751518AbZL1ESE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbZL1ESE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 23:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbZL1ESA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 23:18:00 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37243 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZL1ESA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 23:18:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Dec 2009 13:14:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Alexander Shishkin <virtuoso@slind.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/4] memcg: implement memory thresholds
Message-Id: <20091228131440.3a49a943.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <cc557aab0912271923v4a4ed8cco168193c63efd44f@mail.gmail.com>
References: <cover.1261858972.git.kirill@shutemov.name>
	<3f29ccc3c93e2defd70fc1c4ca8c133908b70b0b.1261858972.git.kirill@shutemov.name>
	<59a7f92356bf1508f06d12c501a7aa4feffb1bbc.1261858972.git.kirill@shutemov.name>
	<c2379f3965225b6d62e64c64f8c0e67fee085d7f.1261858972.git.kirill@shutemov.name>
	<7a4e1d758b98ca633a0be06e883644ad8813c077.1261858972.git.kirill@shutemov.name>
	<20091228114325.e9b3b3d6.kamezawa.hiroyu@jp.fujitsu.com>
	<cc557aab0912271923v4a4ed8cco168193c63efd44f@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Dec 2009 05:23:51 +0200
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> On Mon, Dec 28, 2009 at 4:43 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > On Sun, 27 Dec 2009 04:09:02 +0200
> > "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
 /*
> >>   * Statistics for memory cgroup.
> >> @@ -72,6 +79,8 @@ enum mem_cgroup_stat_index {
> >>       MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> >>       MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
> >>                                       used by soft limit implementation */
> >> +     MEM_CGROUP_STAT_THRESHOLDS, /* decrements on each page in/out.
> >> +                                     used by threshold implementation */
> >>
> >>       MEM_CGROUP_STAT_NSTATS,
> >>  };
> >> @@ -182,6 +191,20 @@ struct mem_cgroup_tree {
> >>
> >>  static struct mem_cgroup_tree soft_limit_tree __read_mostly;
> >>
> >> +struct mem_cgroup_threshold {
> >> +     struct eventfd_ctx *eventfd;
> >> +     u64 threshold;
> >> +};
> >> +
> >> +struct mem_cgroup_threshold_ary {
> >> +     unsigned int size;
> >> +     atomic_t cur;
> >> +     struct mem_cgroup_threshold entries[0];
> >> +};
> >> +
> > Why "array" is a choice here ? IOW, why not list ?
> 
> We need be able to walk by thresholds in both directions to be fast.
> AFAIK, It's impossible with RCU-protected list.
> 
I couldn't read your code correctly. Could you add a comment on

  atomic_t cur; /* An array index points to XXXXX */

or use better name ?

> > How many waiters are expected as usual workload ?
> 
> Array of thresholds reads every 100 page in/out for every CPU.
> Write access only when registering new threshold.
> 



> >> +static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);
> >> +static void mem_cgroup_threshold(struct mem_cgroup* mem);
> >> +
> >>  /*
> >>   * The memory controller data structure. The memory controller controls both
> >>   * page cache and RSS per cgroup. We would eventually like to provide
> >> @@ -233,6 +256,15 @@ struct mem_cgroup {
> >>       /* set when res.limit == memsw.limit */
> >>       bool            memsw_is_minimum;
> >>
> >> +     /* protect arrays of thresholds */
> >> +     struct mutex thresholds_lock;
> >> +
> >> +     /* thresholds for memory usage. RCU-protected */
> >> +     struct mem_cgroup_threshold_ary *thresholds;
> >> +
> >> +     /* thresholds for mem+swap usage. RCU-protected */
> >> +     struct mem_cgroup_threshold_ary *memsw_thresholds;
> >> +
> >>       /*
> >>        * statistics. This must be placed at the end of memcg.
> >>        */
> >> @@ -525,6 +557,8 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
> >>               __mem_cgroup_stat_add_safe(cpustat,
> >>                               MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
> >>       __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
> >> +     __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS, -1);
> >> +
> >>       put_cpu();
> >>  }
> >>
> >> @@ -1510,6 +1544,8 @@ charged:
> >>       if (mem_cgroup_soft_limit_check(mem))
> >>               mem_cgroup_update_tree(mem, page);
> >>  done:
> >> +     if (mem_cgroup_threshold_check(mem))
> >> +             mem_cgroup_threshold(mem);
> >>       return 0;
> >>  nomem:
> >>       css_put(&mem->css);
> >> @@ -2075,6 +2111,8 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
> >>
> >>       if (mem_cgroup_soft_limit_check(mem))
> >>               mem_cgroup_update_tree(mem, page);
> >> +     if (mem_cgroup_threshold_check(mem))
> >> +             mem_cgroup_threshold(mem);
> >>       /* at swapout, this memcg will be accessed to record to swap */
> >>       if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
> >>               css_put(&mem->css);
> >> @@ -3071,12 +3109,246 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
> >>       return 0;
> >>  }
> >>
> >> +static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
> >> +{
> >> +     bool ret = false;
> >> +     int cpu;
> >> +     s64 val;
> >> +     struct mem_cgroup_stat_cpu *cpustat;
> >> +
> >> +     cpu = get_cpu();
> >> +     cpustat = &mem->stat.cpustat[cpu];
> >> +     val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_THRESHOLDS);
> >> +     if (unlikely(val < 0)) {
> >> +             __mem_cgroup_stat_set(cpustat, MEM_CGROUP_STAT_THRESHOLDS,
> >> +                             THRESHOLDS_EVENTS_THRESH);
> >> +             ret = true;
> >> +     }
> >> +     put_cpu();
> >> +     return ret;
> >> +}
> >> +
> >> +static void __mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
> >> +{
> >> +     struct mem_cgroup_threshold_ary *thresholds;
> >> +     u64 usage = mem_cgroup_usage(memcg, swap);
> >> +     int i, cur;
> >> +
> >> +     rcu_read_lock();
> >> +     if (!swap) {
> >> +             thresholds = rcu_dereference(memcg->thresholds);
> >> +     } else {
> >> +             thresholds = rcu_dereference(memcg->memsw_thresholds);
> >> +     }
> >> +
> >> +     if (!thresholds)
> >> +             goto unlock;
> >> +
> >> +     cur = atomic_read(&thresholds->cur);
> >> +
> >> +     /* Check if a threshold crossed in any direction */
> >> +
> >> +     for(i = cur; i >= 0 &&
> >> +             unlikely(thresholds->entries[i].threshold > usage); i--) {
> >> +             atomic_dec(&thresholds->cur);
> >> +             eventfd_signal(thresholds->entries[i].eventfd, 1);
> >> +     }
> >> +
> >> +     for(i = cur + 1; i < thresholds->size &&
> >> +             unlikely(thresholds->entries[i].threshold <= usage); i++) {
> >> +             atomic_inc(&thresholds->cur);
> >> +             eventfd_signal(thresholds->entries[i].eventfd, 1);
> >> +     }

Could you add explanation here ?

> >> +unlock:
> >> +     rcu_read_unlock();
> >> +}
> >> +
> >> +static void mem_cgroup_threshold(struct mem_cgroup *memcg)
> >> +{
> >> +     __mem_cgroup_threshold(memcg, false);
> >> +     if (do_swap_account)
> >> +             __mem_cgroup_threshold(memcg, true);
> >> +}
> >> +
> >> +static int compare_thresholds(const void *a, const void *b)
> >> +{
> >> +     const struct mem_cgroup_threshold *_a = a;
> >> +     const struct mem_cgroup_threshold *_b = b;
> >> +
> >> +     return _a->threshold - _b->threshold;
> >> +}
> >> +
> >> +static int mem_cgroup_register_event(struct cgroup *cgrp, struct cftype *cft,
> >> +             struct eventfd_ctx *eventfd, const char *args)
> >> +{
> >> +     struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> >> +     struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
> >> +     int type = MEMFILE_TYPE(cft->private);
> >> +     u64 threshold, usage;
> >> +     int size;
> >> +     int i, ret;
> >> +
> >> +     ret = res_counter_memparse_write_strategy(args, &threshold);
> >> +     if (ret)
> >> +             return ret;
> >> +
> >> +     mutex_lock(&memcg->thresholds_lock);
> >> +     if (type == _MEM)
> >> +             thresholds = memcg->thresholds;
> >> +     else if (type == _MEMSWAP)
> >> +             thresholds = memcg->memsw_thresholds;
> >> +     else
> >> +             BUG();
> >> +
> >> +     usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
> >> +
> >> +     /* Check if a threshold crossed before adding a new one */
> >> +     if (thresholds)
> >> +             __mem_cgroup_threshold(memcg, type == _MEMSWAP);
> >> +
> >> +     if (thresholds)
> >> +             size = thresholds->size + 1;
> >> +     else
> >> +             size = 1;
> >> +
> >> +     /* Allocate memory for new array of thresholds */
> >> +     thresholds_new = kmalloc(sizeof(*thresholds_new) +
> >> +                     size * sizeof(struct mem_cgroup_threshold),
> >> +                     GFP_KERNEL);
> >> +     if (!thresholds_new) {
> >> +             ret = -ENOMEM;
> >> +             goto unlock;
> >> +     }
> >> +     thresholds_new->size = size;
> >> +
> >> +     /* Copy thresholds (if any) to new array */
> >> +     if (thresholds)
> >> +             memcpy(thresholds_new->entries, thresholds->entries,
> >> +                             thresholds->size *
> >> +                             sizeof(struct mem_cgroup_threshold));
> >> +     /* Add new threshold */
> >> +     thresholds_new->entries[size - 1].eventfd = eventfd;
> >> +     thresholds_new->entries[size - 1].threshold = threshold;
> >> +
> >> +     /* Sort thresholds. Registering of new threshold isn't time-critical */
> >> +     sort(thresholds_new->entries, size,
> >> +                     sizeof(struct mem_cgroup_threshold),
> >> +                     compare_thresholds, NULL);
> >> +
> >> +     /* Find current threshold */
> >> +     atomic_set(&thresholds_new->cur, -1);
> >> +     for(i = 0; i < size; i++) {
> >> +             if (thresholds_new->entries[i].threshold < usage)
> >> +                     atomic_inc(&thresholds_new->cur);
> >> +     }
> >> +
> >> +     /*
> >> +      * We need to increment refcnt to be sure that all thresholds
> >> +      * will be unregistered before calling __mem_cgroup_free()
> >> +      */
> >> +     mem_cgroup_get(memcg);
> >> +
> >> +     if (type == _MEM)
> >> +             rcu_assign_pointer(memcg->thresholds, thresholds_new);
> >> +     else
> >> +             rcu_assign_pointer(memcg->memsw_thresholds, thresholds_new);
> >> +
> >> +     synchronize_rcu();
> >
> > Could you add explanation when you use synchronize_rcu() ?
> 
> It uses before freeing old array of thresholds to be sure than nobody uses it.
> 
> >> +     kfree(thresholds);
> >
> > Can't this be freed by RCU instead of synchronize_rcu() ?
> 
> Yes, this can. But I don't think that (un)registering os thresholds is
> time critical.
> I think my variant is more clean.
> 
I don't ;) But ok, this is a nitpick. Ignore me but add an explanation
commentary in codes.



> >> +unlock:
> >> +     mutex_unlock(&memcg->thresholds_lock);
> >> +
> >> +     return ret;
> >> +}
> >> +
> >> +static int mem_cgroup_unregister_event(struct cgroup *cgrp, struct cftype *cft,
> >> +             struct eventfd_ctx *eventfd)
> >> +{
> >> +     struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> >> +     struct mem_cgroup_threshold_ary *thresholds, *thresholds_new;
> >> +     int type = MEMFILE_TYPE(cft->private);
> >> +     u64 usage;
> >> +     int size = 0;
> >> +     int i, j, ret;
> >> +
> >> +     mutex_lock(&memcg->thresholds_lock);
> >> +     if (type == _MEM)
> >> +             thresholds = memcg->thresholds;
> >> +     else if (type == _MEMSWAP)
> >> +             thresholds = memcg->memsw_thresholds;
> >> +     else
> >> +             BUG();
> >> +
> >> +     /*
> >> +      * Something went wrong if we trying to unregister a threshold
> >> +      * if we don't have thresholds
> >> +      */
> >> +     BUG_ON(!thresholds);
> >> +
> >> +     usage = mem_cgroup_usage(memcg, type == _MEMSWAP);
> >> +
> >> +     /* Check if a threshold crossed before removing */
> >> +     __mem_cgroup_threshold(memcg, type == _MEMSWAP);
> >> +
> >> +     /* Calculate new number of threshold */
> >> +     for(i = 0; i < thresholds->size; i++) {
> >> +             if (thresholds->entries[i].eventfd != eventfd)
> >> +                     size++;
> >> +     }
> >> +
> >> +     /* Set thresholds array to NULL if we don't have thresholds */
> >> +     if (!size) {
> >> +             thresholds_new = NULL;
> >> +             goto assign;
> >> +     }
> >> +
> >> +     /* Allocate memory for new array of thresholds */
> >> +     thresholds_new = kmalloc(sizeof(*thresholds_new) +
> >> +                     size * sizeof(struct mem_cgroup_threshold),
> >> +                     GFP_KERNEL);
> >> +     if (!thresholds_new) {
> >> +             ret = -ENOMEM;
> >> +             goto unlock;
> >> +     }
> >> +     thresholds_new->size = size;
> >> +
> >> +     /* Copy thresholds and find current threshold */
> >> +     atomic_set(&thresholds_new->cur, -1);
> >> +     for(i = 0, j = 0; i < thresholds->size; i++) {
> >> +             if (thresholds->entries[i].eventfd == eventfd)
> >> +                     continue;
> >> +
> >> +             thresholds_new->entries[j] = thresholds->entries[i];
> >> +             if (thresholds_new->entries[j].threshold < usage)
> >> +                     atomic_inc(&thresholds_new->cur);
> > It's better to do atomic set after loop.
> 
> We need one more counter to do this. Do you like it?
> 
Please add a comment that "cur" is for what or use better name. 
Honestly, I don't understand fully how "cur" moves. I'm not sure
whether updating at insert/delete is really necessary or not.


> >> +             j++;
> >> +     }
> >
> > Hmm..is this "copy array" usual coding style for handling eventfd ?
> 
> Since we store only pointer to struct eventfd_ctx, I don't see a problem.
> 
Following is just an suggestion after brief look...

IMO, "cur" is not necessary in the 1st version.
Using simple list and do full-scan always will be good as first step.
(And do necessary optimization later.)
Then, size of patch will be dramatically small.

I think the "cur" magic complicates details too much.


Thanks,
-Kame



