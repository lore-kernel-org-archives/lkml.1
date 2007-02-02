Return-Path: <linux-kernel-owner+w=401wt.eu-S1423101AbXBBT1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423101AbXBBT1O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 14:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423116AbXBBT1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 14:27:14 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:58257 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423101AbXBBT1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 14:27:13 -0500
Message-ID: <45C3908D.8040600@us.ibm.com>
Date: Fri, 02 Feb 2007 13:27:09 -0600
From: Maynard Johnson <maynardj@us.ibm.com>
Reply-To: maynardj@us.ibm.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.3) Gecko/20040910
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: cbe-oss-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, oprofile-list@lists.sourceforge.net,
       Anton Blanchard <anton@samba.org>
Subject: Re: [Cbe-oss-dev] [RFC, PATCH 4/4] Add support to OProfile for profiling
 Cell BE SPUs -- update
References: <45BE4ED0.5030808@us.ibm.com> <200701300839.05144.arnd@arndb.de> <45BFBB78.7060907@us.ibm.com> <200701310657.41317.arnd@arndb.de>
In-Reply-To: <200701310657.41317.arnd@arndb.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

> On Tuesday 30 January 2007 22:41, Maynard Johnson wrote:
> 
>>Arnd Bergmann wrote:
> 
> 
>>>>+       kt = ktime_set(0, profiling_interval);
>>>>+       if (!spu_prof_running)
>>>>+               goto STOP;
>>>>+       hrtimer_forward(timer, timer->base->get_time(), kt);
>>>>+       return HRTIMER_RESTART;
>>>
>>>
>>>is hrtimer_forward really the right interface here? You are ignoring
>>>the number of overruns anyway, so hrtimer_start(,,) sounds more
>>>correct to me.
>>
>>According to Tom Gleixner, "hrtimer_forward is a convenience function to 
>>move the expiry time of a timer forward in multiples of the interval, so 
>>it is in the future.  After setting the expiry time you restart the 
>>timer either with [sic] a return HRTIMER_RESTART (if you are in the 
>>timer callback function)."
>>
> 
> Ok, I see. Have you seen the timer actually coming in late, resulting
> in hrtimer_forward returning non-zero? I guess it's not a big problem
> for statistic data collection if that happens, but you might still want
> to be able to see it.
I don't think there's much point in knowing if we have overrun(s). 
We're not going to schedule the timer any differently. We want to keep 
the timer interrupts as consistent as possible according to the user's 
request.
> 
> 
>>>>+       /* Since cpufreq_quick_get returns frequency in kHz, we use
>>>>+        * USEC_PER_SEC here vs NSEC_PER_SEC.
>>>>+        */
>>>>+       unsigned long nsPerCyc = (USEC_PER_SEC << SCALE_SHIFT)/khzfreq;
>>>>+       profiling_interval = (nsPerCyc * cycles_reset) >> SCALE_SHIFT;
>>>>+       
>>>>+       pr_debug("timer resolution: %lu\n", 
>>>>+                TICK_NSEC);
>>>
>>>
>>>Don't you need to adapt the profiling_interval at run time, when cpufreq
>>>changes the core frequency? You should probably use
>>>cpufreq_register_notifier() to update this.
>>
>>Since OProfile is a statistical profiler, the exact frequency is not 
>>critical.  The user is going to be looking for hot spots in their code, 
>>so it's all relative.  With that said,  I don't imagine using the 
>>cpufreq notiication would be a big deal.  We'll look at it.
>>
>>
>>>>@@ -480,7 +491,22 @@
>>>>              struct op_system_config *sys, int num_ctrs)
>>>>{
>>>>       int i, j, cpu;
>>>>+       spu_cycle_reset = 0;
>>>>
>>>>+       /* The cpufreq_quick_get function requires that cbe_cpufreq module
>>>>+        * be loaded.  This function is not actually provided and exported
>>>>+        * by cbe_cpufreq, but it relies on cbe_cpufreq initialize kernel
>>>>+        * data structures.  Since there's no way for depmod to realize
>>>>+        * that our OProfile module depends on cbe_cpufreq, we currently
>>>>+        * are letting the userspace tool, opcontrol, ensure that the
>>>>+        * cbe_cpufreq module is loaded.
>>>>+        */
>>>>+       khzfreq = cpufreq_quick_get(smp_processor_id());
>>>
>>>
>>>You should probably have a fallback in here in case the cpufreq module
>>>is not loaded. There is a global variable ppc_proc_freq (in Hz) that
>>>you can access.
>>
>>Our userspace tool ensures the cpufreq module is loaded.
> 
> 
> You should not rely on user space tools to do the right thing in the kernel.
Ok, we'll look at the fallback option you suggest.  I don't recall if I 
even knew about ppc_proc_freq before or why I originally chose 
cpufreq_guick_get.  Maybe we can do without the cpufreq and use 
ppc_proc_freq all the time.  We'll see . . .
> 
> Moreover, if the exact frequency is not that important, as you mentioned
> above, you can probably just hardcode a compile-time constant here.
Well, exact frequency isn't critical, but it should, as close as 
possible, correspond with the user's requested value for "spu cycle reset".
> 
> 
>>>>+ * 
>>>>+ * Ideally, we would like to be able to create the cached_info for
>>>>+ * an SPU task just one time -- when libspe first loads the SPU 
>>>>+ * binary file.  We would store the cached_info in a list.  Then, as
>>>>+ * SPU tasks are switched out and new ones switched in, the cached_info
>>>>+ * for inactive tasks would be kept, and the active one would be placed
>>>>+ * at the head of the list.  But this technique may not with
>>>>+ * current spufs functionality since the spu used in bind_context may
>>>>+ * be a different spu than was used in a previous bind_context for a
>>>>+ * reactivated SPU task.  Additionally, a reactivated SPU task may be
>>>>+ * assigned to run on a different physical SPE.  We will investigate
>>>>+ * further if this can be done.
>>>>+ *
>>>>+ */
>>>
>>>
>>>You should stuff a pointer to cached_info into struct spu_context,
>>>e.g. 'void *profile_private'.
>>>
>>>
>>>
>>>>+struct cached_info {
>>>>+       vma_map_t * map;
>>>>+       struct spu * the_spu;
>>>>+       struct kref cache_ref;
>>>>+       struct list_head list;
>>>>+};
>>>
>>>
>>>And replace the 'the_spu' member with a back pointer to the
>>>spu_context if you need it.
>>>
>>>
>>>
>>>>+
>>>>+/* A data structure for cached information about active SPU tasks.
>>>>+ * Storage is dynamically allocated, sized as
>>>>+ * "number of active nodes multplied by 8". 
>>>>+ * The info_list[n] member holds 0 or more 
>>>>+ * 'struct cached_info' objects for SPU#=n. 
>>>>+ *
>>>>+ * As currently implemented, there will only ever be one cached_info 
>>>>+ * in the list for a given SPU.  If we can devise a way to maintain
>>>>+ * multiple cached_infos in our list, then it would make sense
>>>>+ * to also cache the dcookie representing the PPU task application.
>>>>+ * See above description of struct cached_info for more details.
>>>>+ */
>>>>+struct spu_info_stacks {
>>>>+       struct list_head * info_list;
>>>>+};
>>>
>>>
>>>Why do you store pointers to list_head structures? If you want to store
>>>lists, you should have a lists_head itself in here.
>>
>>info_list is an array of n lists, where n is the number of SPUs.
> 
> 
> My point was that it's not an array of lists, but an array of pointers
> to lists. The way that include/list.h works is by having a struct list_head
> as the anchor and then add nodes to it. By simply pointing to a list_head,
> you won't be able to use the list_for_each_entry() macro the way it is meant.
I've got to rework this implementation anyway . . .
> 
> 
[snip]

-Maynard

> 
> 	Arnd <><


