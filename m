Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbZLDAtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbZLDAtY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755197AbZLDAtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:49:18 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50104 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbZLDAtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:49:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZW3OLLpFHddGU8EmMHnUa+8FdeeQFxzLOduJXSApgwowWXcKwUXQ+vjNAFNgHpO1rX
         mihv9jwZ4hFrx/jLnxCK2dFOO939gheHfKoLMuLhTCUNqRUnUKQNsmH4KvFazDszDFHO
         2RBgni7yuigapURj7CQuOE2OSH6dshH8745ps=
MIME-Version: 1.0
In-Reply-To: <20091204091821.340ddcd5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091203102851.daeb940c.kamezawa.hiroyu@jp.fujitsu.com>
	 <4B17D506.7030701@gmail.com>
	 <20091204091821.340ddcd5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 4 Dec 2009 09:49:17 +0900
Message-ID: <28c262360912031649o42c9af52r35369fa820ec14f9@mail.gmail.com>
Subject: Re: [RFC][mmotm][PATCH] percpu mm struct counter cache
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       cl@linux-foundation.org,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       yanmin_zhang@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 4, 2009 at 9:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 04 Dec 2009 00:11:02 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
>
>> Hi, Kame.
>>
>> KAMEZAWA Hiroyuki wrote:
>> > Christophs's mm_counter+percpu implemtation has scalability at updates but
>> > read-side had some problems. Inspired by that, I tried to write percpu-cache
>> > counter + synchronization method. My own tiny benchmark shows something good
>> > but this patch's hooks may summon other troubles...
>> >
>> > Now, I start from sharing codes here. Any comments are welcome.
>> > (Especially, moving hooks to somewhere better is my concern.)
>> > My test proram will be posted in reply to this mail.
>> >
>> > Regards,
>> > -Kame
>> > ==
>> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> >
>> > This patch is for implemanting light-weight per-mm statistics.
>> > Now, when split-pagetable-lock is used, statistics per mm struct
>> > is maintainer by atomic_long_t value. This costs one atomic_inc()
>> > under page_table_lock and if multi-thread program runs and shares
>> > mm_struct, this tend to cause cache-miss+atomic_ops.
>>
>> Both cases are (page_table_lock + atomic inc) cost?
>>
>> AFAIK,
>> If we don't use split lock, we get the just spinlock of page_table_lock.
> yes.
>
>> If we use split lock, we get the just atomic_op cost + page->ptl lock.
> yes. now.
>
>> In case of split lock, ptl lock contention for rss accounting is little, I think.
>>
>> If I am wrong, could you write down changelog more clearly?
>>
> AFAIK, you're right.
>
>
>>
>> >
>> > This patch adds per-cpu mm statistics cache and sync it in periodically.
>> > Cached Information are synchronized into mm_struct at
>> >   - tick
>> >   - context_switch.
>> >   if there is difference.
>>
>> Should we sync mm statistics periodically?
>> Couldn't we sync statistics when we need it?
>> ex) get_mm_counter.
>> I am not sure it's possible. :)
>
> For this counter, read-side cost is important.
> My reply to Christoph's per-cpu-mm-counter, which gathers information at
> get_mm_counter.
> http://marc.info/?l=linux-mm&m=125747002917101&w=2
>
> Making read-side of this counter slower means making ps or top slower.
> IMO, ps or top is too slow now and making them more slow is very bad.

Also, we don't want to make regression in no-split-ptl lock system.
Now, tick update cost is zero in no-split-ptl-lock system.
but task switching is a little increased since compare instruction.
As you know, task-switching is rather costly function.
I mind additional overhead in so-split-ptl lock system.
I think we can remove the overhead completely.

>
>>
>> >
>> > Tiny test progam on x86-64/4core/2socket machine shows (small) improvements.
>> > This test program measures # of page faults on cpu  0 and 4.
>> > (Using all 8cpus, most of time is used for spinlock and you can't see
>> >  benefits of this patch..)
>> >
>> > [Before Patch]
>> > Performance counter stats for './multi-fault 2' (5 runs):
>> >
>> >        44282223  page-faults                ( +-   0.912% )
>> >      1015540330  cache-references           ( +-   1.701% )
>> >       210497140  cache-misses               ( +-   0.731% )
>> >  29262804803383988  bus-cycles                 ( +-   0.003% )
>> >
>> >    60.003401467  seconds time elapsed   ( +-   0.004% )
>> >
>> >  4.75 miss/faults
>> >  660825108.1564714580837551899777 bus-cycles/faults
>> >
>> > [After Patch]
>> > Performance counter stats for './multi-fault 2' (5 runs):
>> >
>> >        45543398  page-faults                ( +-   0.499% )
>> >      1031865896  cache-references           ( +-   2.720% )
>> >       184901499  cache-misses               ( +-   0.626% )
>> >  29261889737265056  bus-cycles                 ( +-   0.002% )
>> >
>> >    60.001218501  seconds time elapsed   ( +-   0.000% )
>> >
>> >  4.05 miss/faults
>> >  642505632.5 bus-cycles/faults
>> >
>> > Note: to enable split-pagetable-lock, you have to disable SPINLOCK_DEBUG.
>> >
>> > This patch moves mm_counter definitions to mm.h+memory.c from sched.h.
>> > So, total patch size seems to be big.
>>
>> What's your goal/benefit?
>> You cut down atomic operations with (cache and sync) method?
>>
>> Please, write down the your goal/benefit. :)
>>
> Sorry.

No problem. :)

>
> My goal is adding more counters like swap_usage or lowmem_rss_usage,
> etc. Adding them means I'll add more cache-misses.
> Once we can add cache-hit+no-atomic-ops counter, adding statistics will be
> much easier.

Yeb. It would be better to add this in changelog.

> And considering relaxinug mmap_sem as my speculative-page-fault patch,
> this mm_counter will be another heavy cache-miss point.
>
>
>> >
>> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
>> > +/*
>> > + * The mm counters are not protected by its page_table_lock,
>> > + * so must be incremented atomically.
>> > + */
>> > +void set_mm_counter(struct mm_struct *mm, int member, long value)
>> > +{
>> > +   atomic_long_set(&mm->counters[member], value);
>> > +}
>> > +
>> > +unsigned long get_mm_counter(struct mm_struct *mm, int member)
>> > +{
>> > +   long ret = atomic_long_read(&mm->counters[member]);
>>
>> Which case do we get the minus 'ret'?
>>
> When a process is heavily swapped out and no "sync" happens,
> we can get minus. And file-map,fault,munmap in short time can
> make this minus.

Yes. please, add this description by comment.

> And In this patch, dec_mm_counter() is not used so much.
> But I'll add ones at adding swap_usage counter.
>
>
>
>
>> > +   if (ret < 0)
>> > +           return 0;
>> > +   return ret;
>> > +}
>> > +
>> > +void add_mm_counter(struct mm_struct *mm, int member, long value)
>> > +{
>> > +   atomic_long_add(value, &mm->counters[member]);
>> > +}
>> > +
>> > +/*
>> > + * Always called under pte_lock....irq off, mm != curr_mmc.mm if called
>> > + * by get_user_pages() etc.
>> > + */
>> > +static void
>> > +add_mm_counter_fast(struct mm_struct *mm, int member, long val)
>> > +{
>> > +   if (likely(percpu_read(curr_mmc.mm) == mm))
>> > +           percpu_add(curr_mmc.counters[member], val);
>> > +   else
>> > +           add_mm_counter(mm, member, val);
>> > +}
>> > +
>> > +/* Called by not-preemptable context */
>>               non-preemptible
>> > +void sync_tsk_mm_counters(void)
>> > +{
>> > +   struct pcp_mm_cache *cache = &per_cpu(curr_mmc, smp_processor_id());
>> > +   int i;
>> > +
>> > +   if (!cache->mm)
>> > +           return;
>> > +
>> > +   for (i = 0; i < NR_MM_STATS; i++) {
>> > +           if (!cache->counters[i])
>> > +                   continue;
>> > +           add_mm_counter(cache->mm, i, cache->counters[i]);
>> > +           cache->counters[i] = 0;
>> > +   }
>> > +}
>> > +
>> > +void prepare_mm_switch(struct task_struct *prev, struct task_struct *next)
>> > +{
>> > +   if (prev->mm == next->mm)
>> > +           return;
>> > +   /* If task is exited, sync is already done and prev->mm is NULL */
>> > +   if (prev->mm)
>> > +           sync_tsk_mm_counters();
>> > +   percpu_write(curr_mmc.mm, next->mm);
>> > +}
>>
>> Further optimization.
>> In case of (A-> kernel thread -> A), we don't need sync only if
>> we update statistics when we need it as i suggested.
>>
> Hmm. I'll check following can work or not.
> ==
>       if (next->mm == &init_mm)
>                return;
>       if (prev->mm == &init_mm) {
>                if (percpu_read(curr_mmc.mm) == next->mm)
>                        return;
>        }
> ==
if next->mm is NULL, it's kernel thread.
You can use this rule.

As I suggested, I want to remove this compare overhead in non-split-ptl system.


>> > +
>> > +#else  /* !USE_SPLIT_PTLOCKS */
>> > +/*
>> > + * The mm counters are protected by its page_table_lock,
>> > + * so can be incremented directly.
>> > + */
>> > +void set_mm_counter(struct mm_struct *mm, int member, long value)
>> > +{
>> > +   mm->counters[member] = value;
>> > +}
>> > +
>> > +unsigned long get_mm_counter(struct mm_struct *mm, int member)
>> > +{
>> > +   return mm->counters[member];
..
<snip>
..
>> >     pte_unmap_unlock(pte - 1, ptl);
>> > Index: mmotm-2.6.32-Nov24/mm/swapfile.c
>> > ===================================================================
>> > --- mmotm-2.6.32-Nov24.orig/mm/swapfile.c
>> > +++ mmotm-2.6.32-Nov24/mm/swapfile.c
>> > @@ -839,7 +839,7 @@ static int unuse_pte(struct vm_area_stru
>> >             goto out;
>> >     }
>> >
>> > -   inc_mm_counter(vma->vm_mm, anon_rss);
>> > +   add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
>>
>> Why can't we use inc_mm_counter_fast in here?
>>
> This vma->vm_mm isn't current->mm in many case, I think.

I missed point. Thanks.

>
>
>> >     get_page(page);
>> >     set_pte_at(vma->vm_mm, addr, pte,
>> >                pte_mkold(mk_pte(page, vma->vm_page_prot)));
>> > Index: mmotm-2.6.32-Nov24/kernel/timer.c
>> > ===================================================================
>> > --- mmotm-2.6.32-Nov24.orig/kernel/timer.c
>> > +++ mmotm-2.6.32-Nov24/kernel/timer.c
>> > @@ -1200,6 +1200,8 @@ void update_process_times(int user_tick)
>> >     account_process_tick(p, user_tick);
>> >     run_local_timers();
..
<snip>
..
     /*
>> >      * For paravirt, this is coupled with an exit in switch_to to
>> >      * combine the page table reload and the switch backend into
>> >
>>
>> I think code is not bad but I don't know how effective this patch is in practice.
> Maybe the benefit of this patch itself is not clear at this point.
> I'll post with "more counters" patch as swap_usage, lowmem_rss usage counter in the
> next time. Adding more counters without atomic_ops will seems attractive.

I agree.

>> Thanks for good effort. Kame. :)
>>
>
> Thank you for review.
> -Kame
>
>



-- 
Kind regards,
Minchan Kim
