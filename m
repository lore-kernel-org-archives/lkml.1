Return-Path: <linux-kernel-owner+w=401wt.eu-S1759809AbZLOKqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbZLOKqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 05:46:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759786AbZLOKqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 05:46:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:28208 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783AbZLOKqe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 05:46:34 -0500
MIME-Version: 1.0
In-Reply-To: <20091215105850.87203454.kamezawa.hiroyu@jp.fujitsu.com>
References: <cover.1260571675.git.kirill@shutemov.name>
	 <ca59c422b495907678915db636f70a8d029cbf3a.1260571675.git.kirill@shutemov.name>
	 <c1847dfb5c4fed1374b7add236d38e0db02eeef3.1260571675.git.kirill@shutemov.name>
	 <747ea0ec22b9348208c80f86f7a813728bf8e50a.1260571675.git.kirill@shutemov.name>
	 <9e6e8d687224c6cbc54281f7c3d07983f701f93d.1260571675.git.kirill@shutemov.name>
	 <20091215105850.87203454.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 12:46:32 +0200
Message-ID: <cc557aab0912150246k476aa85m6c1b61045fb0b26e@mail.gmail.com>
Subject: Re: [PATCH RFC v2 4/4] memcg: implement memory thresholds
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: containers@lists.linux-foundation.org, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Dan Malek <dan@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 3:58 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Sat, 12 Dec 2009 00:59:19 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>
>> It allows to register multiple memory and memsw thresholds and gets
>> notifications when it crosses.
>>
>> To register a threshold application need:
>> - create an eventfd;
>> - open memory.usage_in_bytes or memory.memsw.usage_in_bytes;
>> - write string like "<event_fd> <memory.usage_in_bytes> <threshold>" to
>>   cgroup.event_control.
>>
>> Application will be notified through eventfd when memory usage crosses
>> threshold in any direction.
>>
>> It's applicable for root and non-root cgroup.
>>
>> It uses stats to track memory usage, simmilar to soft limits. It checks
>> if we need to send event to userspace on every 100 page in/out. I guess
>> it's good compromise between performance and accuracy of thresholds.
>>
>> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>> ---
>>  mm/memcontrol.c |  263 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 263 insertions(+), 0 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c6081cc..5ba2140 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -6,6 +6,10 @@
>>   * Copyright 2007 OpenVZ SWsoft Inc
>>   * Author: Pavel Emelianov <xemul@openvz.org>
>>   *
>> + * Memory thresholds
>> + * Copyright (C) 2009 Nokia Corporation
>> + * Author: Kirill A. Shutemov
>> + *
>>   * This program is free software; you can redistribute it and/or modify
>>   * it under the terms of the GNU General Public License as published by
>>   * the Free Software Foundation; either version 2 of the License, or
>> @@ -38,6 +42,7 @@
>>  #include <linux/vmalloc.h>
>>  #include <linux/mm_inline.h>
>>  #include <linux/page_cgroup.h>
>> +#include <linux/eventfd.h>
>>  #include "internal.h"
>>
>>  #include <asm/uaccess.h>
>> @@ -56,6 +61,7 @@ static int really_do_swap_account __initdata = 1; /* for remember boot option*/
>>
>>  static DEFINE_MUTEX(memcg_tasklist); /* can be hold under cgroup_mutex */
>>  #define SOFTLIMIT_EVENTS_THRESH (1000)
>> +#define THRESHOLDS_EVENTS_THRESH (100)
>>
>>  /*
>>   * Statistics for memory cgroup.
>> @@ -72,6 +78,8 @@ enum mem_cgroup_stat_index {
>>       MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
>>       MEM_CGROUP_STAT_SOFTLIMIT, /* decrements on each page in/out.
>>                                       used by soft limit implementation */
>> +     MEM_CGROUP_STAT_THRESHOLDS, /* decrements on each page in/out.
>> +                                     used by threshold implementation */
>>
>>       MEM_CGROUP_STAT_NSTATS,
>>  };
>> @@ -182,6 +190,15 @@ struct mem_cgroup_tree {
>>
>>  static struct mem_cgroup_tree soft_limit_tree __read_mostly;
>>
>> +struct mem_cgroup_threshold {
>> +     struct list_head list;
>> +     struct eventfd_ctx *eventfd;
>> +     u64 threshold;
>> +};
>> +
>> +static bool mem_cgroup_threshold_check(struct mem_cgroup* mem);
>> +static void mem_cgroup_threshold(struct mem_cgroup* mem, bool swap);
>> +
>>  /*
>>   * The memory controller data structure. The memory controller controls both
>>   * page cache and RSS per cgroup. We would eventually like to provide
>> @@ -233,6 +250,19 @@ struct mem_cgroup {
>>       /* set when res.limit == memsw.limit */
>>       bool            memsw_is_minimum;
>>
>> +     /* protect lists of thresholds*/
>> +     spinlock_t thresholds_lock;
>> +
>> +     /* thresholds for memory usage */
>> +     struct list_head thresholds;
>> +     struct mem_cgroup_threshold *below_threshold;
>> +     struct mem_cgroup_threshold *above_threshold;
>> +
>> +     /* thresholds for mem+swap usage */
>> +     struct list_head memsw_thresholds;
>> +     struct mem_cgroup_threshold *memsw_below_threshold;
>> +     struct mem_cgroup_threshold *memsw_above_threshold;
>> +
>>       /*
>>        * statistics. This must be placed at the end of memcg.
>>        */
>> @@ -519,6 +549,8 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>>               __mem_cgroup_stat_add_safe(cpustat,
>>                               MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
>>       __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_SOFTLIMIT, -1);
>> +     __mem_cgroup_stat_add_safe(cpustat, MEM_CGROUP_STAT_THRESHOLDS, -1);
>> +
>>       put_cpu();
>>  }
>>
>> @@ -1363,6 +1395,11 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>>       if (mem_cgroup_soft_limit_check(mem))
>>               mem_cgroup_update_tree(mem, page);
>>  done:
>> +     if (mem_cgroup_threshold_check(mem)) {
>> +             mem_cgroup_threshold(mem, false);
>> +             if (do_swap_account)
>> +                     mem_cgroup_threshold(mem, true);
>> +     }
>>       return 0;
>>  nomem:
>>       css_put(&mem->css);
>> @@ -1906,6 +1943,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>>
>>       if (mem_cgroup_soft_limit_check(mem))
>>               mem_cgroup_update_tree(mem, page);
>> +     if (mem_cgroup_threshold_check(mem)) {
>> +             mem_cgroup_threshold(mem, false);
>> +             if (do_swap_account)
>> +                     mem_cgroup_threshold(mem, true);
>> +     }
>>       /* at swapout, this memcg will be accessed to record to swap */
>>       if (ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>>               css_put(&mem->css);
>> @@ -2860,11 +2902,181 @@ static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
>>  }
>>
>>
>> +static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
>> +{
>> +     bool ret = false;
>> +     int cpu;
>> +     s64 val;
>> +     struct mem_cgroup_stat_cpu *cpustat;
>> +
>> +     cpu = get_cpu();
>> +     cpustat = &mem->stat.cpustat[cpu];
>> +     val = __mem_cgroup_stat_read_local(cpustat, MEM_CGROUP_STAT_THRESHOLDS);
>> +     if (unlikely(val < 0)) {
>> +             __mem_cgroup_stat_set(cpustat, MEM_CGROUP_STAT_THRESHOLDS,
>> +                             THRESHOLDS_EVENTS_THRESH);
>> +             ret = true;
>> +     }
>> +     put_cpu();
>> +     return ret;
>> +}
>> +
>
> Hmm. please check
>
>        if (likely(list_empty(&mem->thesholds) &&
>                   list_empty(&mem->memsw_thresholds)))
>                return;

These lists are never be empty. They have at least two fake threshold for 0
and RESOURCE_MAX.

>
> or adds a flag as mem->no_threshold_check to skip this routine quickly.
>
> _OR_
> I personally don't like to have 2 counters to catch events.
>
> How about this ?
>
>   adds
>   struct mem_cgroup {
>        atomic_t        event_counter; // this is incremented per 32
>                                           page-in/out
>        atomic_t last_softlimit_check;
>        atomic_t last_thresh_check;
>   };
>
> static bool mem_cgroup_threshold_check(struct mem_cgroup *mem)
> {
>        decrement percpu event counter.
>        if (percpu counter reaches 0) {
>                if  (atomic_dec_and_test(&mem->check_thresh) {
>                        check threashold.
>                        reset counter.
>                }
>                if  (atomic_dec_and_test(&memc->check_softlimit) {
>                        update softlimit tree.
>                        reset counter.
>                }
>                reset percpu counter.
>        }
> }
>
> Then, you can have a counter like system-wide event counter.

I leave it as is for now, as you mention in other letter.

>> +static void mem_cgroup_threshold(struct mem_cgroup *memcg, bool swap)
>> +{
>> +     struct mem_cgroup_threshold **below, **above;
>> +     struct list_head *thresholds;
>> +     u64 usage = mem_cgroup_usage(memcg, swap);
>> +
>> +     if (!swap) {
>> +             thresholds = &memcg->thresholds;
>> +             above = &memcg->above_threshold;
>> +             below = &memcg->below_threshold;
>> +     } else {
>> +             thresholds = &memcg->memsw_thresholds;
>> +             above = &memcg->memsw_above_threshold;
>> +             below = &memcg->memsw_below_threshold;
>> +     }
>> +
>> +     spin_lock(&memcg->thresholds_lock);
>> +     if ((*above)->threshold <= usage) {
>> +             *below = *above;
>> +             list_for_each_entry_continue((*above), thresholds, list) {
>> +                     eventfd_signal((*below)->eventfd, 1);
>> +                     if ((*above)->threshold > usage)
>> +                             break;
>> +                     *below = *above;
>> +             }
>> +     } else if ((*below)->threshold > usage) {
>> +             *above = *below;
>> +             list_for_each_entry_continue_reverse((*below), thresholds,
>> +                             list) {
>> +                     eventfd_signal((*above)->eventfd, 1);
>> +                     if ((*below)->threshold <= usage)
>> +                             break;
>> +                     *above = *below;
>> +             }
>> +     }
>> +     spin_unlock(&memcg->thresholds_lock);
>> +}
>
> Could you adds comment on above check ?

I'll add comments in next version of patchset.

> And do we need *spin_lock* here ? Can't you use RCU list walk ?

I'll play with it.

> If you use have to use spinlock here, this is a system-wide spinlock,
> threshold as "100" is too small, I think.

What is reasonable value for THRESHOLDS_EVENTS_THRESH for you?

In most cases spinlock taken only for two checks. Is it significant time?

Unfortunately, I can't test it on a big box. I have only dual-core system.
It's not enough to test scalability.

> Even if you can't use spinlock, please use mutex. (with checking gfp_mask).
>
> Thanks,
> -Kame
