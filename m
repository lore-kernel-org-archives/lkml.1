Return-Path: <linux-kernel-owner+w=401wt.eu-S933286AbZFLJuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286AbZFLJuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 05:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761520AbZFLJuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 05:50:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62281 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758598AbZFLJuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 05:50:06 -0400
Message-ID: <4A32251C.8060001@cn.fujitsu.com>
Date: Fri, 12 Jun 2009 17:51:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Zhaolei <zhaolei@cn.fujitsu.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH RFC] softirq: fix ksoftirq starved
References: <alpine.DEB.2.00.0905111003280.14976@gandalf.stny.rr.com> <20090511142734.GA12722@Krystal> <alpine.DEB.2.00.0905111039470.2492@gandalf.stny.rr.com> <20090511151353.GA14391@Krystal> <4A094677.5090900@cn.fujitsu.com> <4A0BF82A.2070208@cn.fujitsu.com> <20090514124013.GC21241@Krystal> <alpine.DEB.2.00.0905140926010.30591@gandalf.stny.rr.com> <4A0CCB2E.10202@cn.fujitsu.com> <6A70E08D65F749FA92475F8BA1F9510D@zhaoleiwin> <20090519082435.GB15286@elte.hu> <4A31BF1D.1050400@cn.fujitsu.com>
In-Reply-To: <4A31BF1D.1050400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai Jiangshan wrote:
> Ingo Molnar wrote:
>> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
>>
>>> * From: "Xiao Guangrong" <xiaoguangrong@cn.fujitsu.com>
>>>> Steven Rostedt wrote:
>>>>> On Thu, 14 May 2009, Mathieu Desnoyers wrote:
>>>>>>> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>>>>>>>
>>>>>>> This patch is modified from Mathieu Desnoyers' patch. The original patch
>>>>>>> can be found here: 
>>>>>>> http://marc.info/?l=linux-kernel&m=123791201816245&w=2
>>>>>>> This tracepoint can trace the time stamp when softirq action is raised. 
>>>>>>>
>>>>>>> Changelog for v1 -> v2: 
>>>>>>> 1: Use TRACE_EVENT instead of DEFINE_TRACE
>>>>>>> 2: Move the tracepoint from raise_softirq_irqoff() to
>>>>>>>    __raise_softirq_irqoff()
>>>>>>>
>>>>>>> Changelog for v2 -> v3: 
>>>>>>> Move the definition of __raise_softifq_irqoff() to .c file when
>>>>>>> CONFIG_TRACEPOINTS is enabled, to avoid recursive includes
>>>>>>>
>>>>>>> Changelog for v3 -> v4: 
>>>>>>> 1: Come back to v2, and use forward declarations to avoid
>>>>>>>    recursive includes as Mathieu's suggestion
>>>>>>> 2: Modifiy the tracepoint name
>>>>>>> 3: Add comments for this tracepoint
>>>>>>>
>>>>>> This is a step in the right direction, but please see my email to Lai
>>>>>> about the fact that this assumes correct and undocumented include
>>>>>> dependencies in kernel/trace/events.c. Not explicitely stating the
>>>>>> include dependencies is a build error waiting to happen.
>>>>>>
>>>>>> Including interrupt.h under a ifdef would allow keeping track of
>>>>>> TRACE_EVENT specific build dependencies neatly on a per header basis.
>>>>> This is all moot, the events.c file no longer exists and as not an issue.
>>>>>
>>>> As Steve's says, use ftrace in ftrace.h not in events.c now. 
>>>> So, this mistake does not exist.
>>>> Dose this patch has other error? I expect for your views.
>>>>
>>>> Thanks for your review, is great help to me. ;-) 
>>> Hello,
>>>
>>> It seems Mathieu has no other comments on this patch now.
>>> Ingo, what is your opinion on this patch?
>> There's a complication: this area of the softirq code needs fixes 
>> (unrelated to tracing).
>>  
>> This API:
>>
>> inline void raise_softirq_irqoff(unsigned int nr)
>> {
>>         __raise_softirq_irqoff(nr);
>>
>>         /*
>>          * If we're in an interrupt or softirq, we're done
>>          * (this also catches softirq-disabled code). We will
>>          * actually run the softirq once we return from
>>          * the irq or softirq.
>>          *
>>          * Otherwise we wake up ksoftirqd to make sure we
>>          * schedule the softirq soon.
>>          */
>>         if (!in_interrupt())
>>                 wakeup_softirqd();
>> }
>>
>> is broken with RT tasks (as recently reported to lkml), as when a 
>> real-time task wakes up ksoftirqd (which has lower priority) it wont 
>> execute and we starve softirq execution.
>>
>> The proper solution would be to have a new API:
>>
>> 	raise_softirq_check()
>>
>> and to remove the wakeup_softirqd() hack from raise_softirq_irqoff() 
>> - and put raise_softirq_check() to all places that use 
>> raise_softirq*() from process context.
> 
> It's a nice solution. But I think it would be nicer when it is changed a little.
> 
> The new API raise_softirq_check() will become a very hard _burden_ to
> the users of raise_softirq*(). They have to find out a proper place to place
> the "raise_softirq_check();". It's not an easy things, functions are complicated
> and hard to be determined WHERE is the process context and WHEN(a function may be
> called from multi kinds of context).
> 
> Instead, I prefer that raise_softirq_check() is hidden from users. We call
> raise_softirq_check() from schedule(), it will handle the un-handle softirqs in time
> (if un-handle softirqs are too much, it'll wakeup the ksoftirqd).
> 
> 
> Lai
> 
> 
>>  
>> raise_softirq_check() would execute softirq handlers from process 
>> context, if there's any pending ones. It has to be called outside of 
>> bh critical sections - i.e. often a bit after the raise_softirq() 
>> has been done.
>>
>> __raise_softirq_irqoff() would be made private to kernel/softirq.c, 
>> and we'd only have two public APIs to trigger softirqs: 
>> raise_softirq() and raise_softirq_irqoff(). Both just set the 
>> pending flag and dont do any wakeup.
>>
>> As a side-effect of these fixes, the tracepoints will be sorted out 
>> as well - there wont be any need to hack into 
>> __raise_softirq_irqoff().
>>
>> 	Ingo
>>
>>
>>
> 

Subject: [PATCH RFC] softirq: fix ksoftirq starved

The API:
void raise_softirq_irqoff(unsigned int nr)
{
	__raise_softirq_irqoff(nr);

	/*
	 * If we're in an interrupt or softirq, we're done
	 * (this also catches softirq-disabled code). We will
	 * actually run the softirq once we return from
	 * the irq or softirq.
	 *
	 * Otherwise we wake up ksoftirqd to make sure we
	 * schedule the softirq soon.
	 */
	if (!in_interrupt())
		wakeup_softirqd();
}

is broken with RT tasks, as when a real-time task wakes up ksoftirqd
(which has lower priority) it wont execute and we starve softirq execution.

To make pending softirq is called in time, we check and run the pending
softirq in schedule().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index dd574d5..f59e552 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -359,6 +359,7 @@ struct softirq_action
 
 asmlinkage void do_softirq(void);
 asmlinkage void __do_softirq(void);
+extern void schedule_softirq_check(void);
 extern void open_softirq(int nr, void (*action)(struct softirq_action *));
 extern void softirq_init(void);
 #define __raise_softirq_irqoff(nr) do { or_softirq_pending(1UL << (nr)); } while (0)
diff --git a/kernel/sched.c b/kernel/sched.c
index cfb0456..21b5f67 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5307,6 +5307,7 @@ need_resched:
 	release_kernel_lock(prev);
 need_resched_nonpreemptible:
 
+	schedule_softirq_check();
 	schedule_debug(prev);
 
 	if (sched_feat(HRTICK))
diff --git a/kernel/softirq.c b/kernel/softirq.c
index b41fb71..59d142b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -55,6 +55,7 @@ EXPORT_SYMBOL(irq_stat);
 static struct softirq_action softirq_vec[NR_SOFTIRQS] __cacheline_aligned_in_smp;
 
 static DEFINE_PER_CPU(struct task_struct *, ksoftirqd);
+static DEFINE_PER_CPU(int, schedule_softirq_check);
 
 char *softirq_to_name[NR_SOFTIRQS] = {
 	"HI", "TIMER", "NET_TX", "NET_RX", "BLOCK",
@@ -76,6 +77,14 @@ void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
+static void set_schedule_softirq_check(void)
+{
+	if (current != __get_cpu_var(ksoftirqd)) {
+		__get_cpu_var(schedule_softirq_check) = 1;
+		set_tsk_need_resched(current);
+	}
+}
+
 /*
  * This one is for softirq.c-internal use,
  * where hardirqs are disabled legitimately:
@@ -243,6 +252,7 @@ restart:
 
 	lockdep_softirq_exit();
 
+	__get_cpu_var(schedule_softirq_check) = 0;
 	account_system_vtime(current);
 	_local_bh_enable();
 }
@@ -269,6 +279,12 @@ asmlinkage void do_softirq(void)
 
 #endif
 
+void schedule_softirq_check(void)
+{
+	if (__get_cpu_var(schedule_softirq_check))
+		do_softirq();
+}
+
 /*
  * Enter an interrupt context.
  */
@@ -323,11 +339,16 @@ inline void raise_softirq_irqoff(unsigned int nr)
 	 * actually run the softirq once we return from
 	 * the irq or softirq.
 	 *
-	 * Otherwise we wake up ksoftirqd to make sure we
-	 * schedule the softirq soon.
+	 * Otherwise we check and run the pending softirq in schedule().
+	 *
+	 * NOTE: It's sometimes helpless to wakeup the ksoftirqd here.
+	 *       Because when current task is a real-time task(which
+	 *       has higher priority) or a real-time task is on standby
+	 *       in this cpu, ksoftirqd won't execute, we starve softirq
+	 *       execution.
 	 */
 	if (!in_interrupt())
-		wakeup_softirqd();
+		set_schedule_softirq_check();
 }
 
 void raise_softirq(unsigned int nr)

