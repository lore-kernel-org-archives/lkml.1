Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZFVOjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZFVOjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFVOjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:39:31 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:11360 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568AbZFVOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:39:30 -0400
X-SourceIP: 213.93.53.227
Subject: Re: I.5 - Mmaped count
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470906220554m1da6ebe7h50444db6ab606aa1@mail.gmail.com>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
	 <20090622115239.GF24366@elte.hu>
	 <7c86c4470906220525x409bedadj29be01236e42ea1@mail.gmail.com>
	 <1245674154.19816.228.camel@twins>
	 <7c86c4470906220554m1da6ebe7h50444db6ab606aa1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 22 Jun 2009 16:39:32 +0200
Message-Id: <1245681572.19816.481.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 14:54 +0200, stephane eranian wrote:
> On Mon, Jun 22, 2009 at 2:35 PM, Peter Zijlstra<a.p.zijlstra@chello.nl> wrote:
> > On Mon, 2009-06-22 at 14:25 +0200, stephane eranian wrote:
> >> On Mon, Jun 22, 2009 at 1:52 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >> >> 5/ Mmaped count
> >> >>
> >> >> It is possible to read counts directly from user space for
> >> >> self-monitoring threads. This leverages a HW capability present on
> >> >> some processors. On X86, this is possible via RDPMC.
> >> >>
> >> >> The full 64-bit count is constructed by combining the hardware
> >> >> value extracted with an assembly instruction and a base value made
> >> >> available thru the mmap. There is an atomic generation count
> >> >> available to deal with the race condition.
> >> >>
> >> >> I believe there is a problem with this approach given that the PMU
> >> >> is shared and that events can be multiplexed. That means that even
> >> >> though you are self-monitoring, events get replaced on the PMU.
> >> >> The assembly instruction is unaware of that, it reads a register
> >> >> not an event.
> >> >>
> >> >> On x86, assume event A is hosted in counter 0, thus you need
> >> >> RDPMC(0) to extract the count. But then, the event is replaced by
> >> >> another one which reuses counter 0. At the user level, you will
> >> >> still use RDPMC(0) but it will read the HW value from a different
> >> >> event and combine it with a base count from another one.
> >> >>
> >> >> To avoid this, you need to pin the event so it stays in the PMU at
> >> >> all times. Now, here is something unclear to me. Pinning does not
> >> >> mean stay in the SAME register, it means the event stays on the
> >> >> PMU but it can possibly change register. To prevent that, I
> >> >> believe you need to also set exclusive so that no other group can
> >> >> be scheduled, and thus possibly use the same counter.
> >> >>
> >> >> Looks like this is the only way you can make this actually work.
> >> >> Not setting pinned+exclusive, is another pitfall in which many
> >> >> people will fall into.
> >> >
> >> >   do {
> >> >     seq = pc->lock;
> >> >
> >> >     barrier()
> >> >     if (pc->index) {
> >> >       count = pmc_read(pc->index - 1);
> >> >       count += pc->offset;
> >> >     } else
> >> >       goto regular_read;
> >> >
> >> >     barrier();
> >> >   } while (pc->lock != seq);
> >> >
> >> > We don't see the hole you are referring to. The sequence lock
> >> > ensures you get a consistent view.
> >> >
> >> Let's take an example, with two groups, one event in each group.
> >> Both events scheduled on counter0, i.e,, rdpmc(0). The 2 groups
> >> are multiplexed, one each tick. The user gets 2 file descriptors
> >> and thus two mmap'ed pages.
> >>
> >> Suppose the user wants to read, using the above loop, the value of the
> >> event in the first group BUT it's the 2nd group  that is currently active
> >> and loaded on counter0, i.e., rdpmc(0) returns the value of the 2nd event.
> >>
> >> Unless you tell me that pc->index is marked invalid (0) when the
> >> event is not scheduled. I don't see how you can avoid reading
> >> the wrong value. I am assuming that is the event is not scheduled
> >> lock remains constant.
> >
> > Indeed, pc->index == 0 means its not currently available.
> 
> I don't see where you clear that field on x86.

x86 doesn't have this feature fully implemented yet.. its still on the
todo list. Paulus started this on power, so it should work there.

> Looks like it comes from hwc->idx. I suspect you need
> to do something in x86_pmu_disable() to be symmetrical
> with x86_pmu_enable().

Right.

> I suspect something similar needs to be done on Power.

It looks like the power disable method does indeed do this:

	if (counter->hw.idx) {
		write_pmc(counter->hw.idx, 0);
		counter->hw.idx = 0;
	}
	perf_counter_update_userpage(counter);


The below might suffice for x86.. but its not real nice.
Power already has that whole +1 thing in its ->idx field, x86 does not.
So I either munge x86 or add something like I did below..

Paul, any suggestions?

---
Index: linux-2.6/arch/x86/kernel/cpu/perf_counter.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_counter.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_counter.c
@@ -912,6 +912,8 @@ x86_perf_counter_set_period(struct perf_
 	err = checking_wrmsrl(hwc->counter_base + idx,
 			     (u64)(-left) & x86_pmu.counter_mask);
 
+	perf_counter_update_userpage(counter);
+
 	return ret;
 }
 
@@ -1041,6 +1043,8 @@ try_generic:
 	x86_perf_counter_set_period(counter, hwc, idx);
 	x86_pmu.enable(hwc, idx);
 
+	perf_counter_update_userpage(counter);
+
 	return 0;
 }
 
@@ -1133,6 +1137,8 @@ static void x86_pmu_disable(struct perf_
 	x86_perf_counter_update(counter, hwc, idx);
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
+
+	perf_counter_update_userpage(counter);
 }
 
 /*
Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -1753,6 +1753,14 @@ int perf_counter_task_disable(void)
 	return 0;
 }
 
+static int perf_counter_index(struct perf_counter *counter)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return 0;
+
+	return counter->hw->idx + 1 - PERF_COUNTER_INDEX_OFFSET;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -1777,7 +1785,7 @@ void perf_counter_update_userpage(struct
 	preempt_disable();
 	++userpg->lock;
 	barrier();
-	userpg->index = counter->hw.idx;
+	userpg->index = perf_counter_index(counter);
 	userpg->offset = atomic64_read(&counter->count);
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
Index: linux-2.6/arch/powerpc/include/asm/perf_counter.h
===================================================================
--- linux-2.6.orig/arch/powerpc/include/asm/perf_counter.h
+++ linux-2.6/arch/powerpc/include/asm/perf_counter.h
@@ -61,6 +61,8 @@ struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
+#define PERF_COUNTER_INDEX_OFFSET	1
+
 /*
  * Only override the default definitions in include/linux/perf_counter.h
  * if we have hardware PMU support.
Index: linux-2.6/arch/x86/include/asm/perf_counter.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_counter.h
+++ linux-2.6/arch/x86/include/asm/perf_counter.h
@@ -87,6 +87,9 @@ union cpuid10_edx {
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
+
+#define PERF_COUNTER_INDEX_OFFSET			0
+
 #else
 static inline void init_hw_perf_counters(void)		{ }
 static inline void perf_counters_lapic_init(void)	{ }


