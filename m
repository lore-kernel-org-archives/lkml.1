Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab0CKVPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 16:15:47 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:60311 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0CKVPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 16:15:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mWqOmBK0vrBgIzkjBs8gyjz5vNBWpwqZg5hl5bwgoPGSQLQKxJCJ/fyD2i3iEiz/Wi
         OABRCGlzFyXQb0H3+3cFyxzqzHjrgXhXmDzuQEmo8gD5Uk/ds7shL6ejKYHE0iysBSYk
         ImOxD3uBtqyANBiIuqQY84YvMKE8YVph7IUME=
Date: Fri, 12 Mar 2010 00:15:38 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Stephane Eranian <eranian@google.com>,
       Robert Richter <robert.richter@amd.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] x86,perf: Implement minimal P4 PMU driver v14
Message-ID: <20100311211538.GC25162@lenovo>
References: <20100310183102.GC8070@lenovo> <1268274775.4996.16.camel@minggr.sh.intel.com> <20100311165439.GB5129@lenovo> <20100311181646.GA12235@elte.hu> <20100311183921.GA30249@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100311183921.GA30249@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 07:39:21PM +0100, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > 
> > > x86,perf: Implement minimal P4 PMU driver v15
> > 
> > tried it on a Pentium-D dual core CPU, and it boots fine:
> 
> an Athlon64 testbox was not as happy:
> 
> [    0.253338] calling  spawn_nmi_watchdog_task+0x0/0x63 @ 1
> [    0.256675] NMI watchdog enabled, takes one hw-pmu counter.
> [    0.260013] nmi_watchdog: hardware not available, trying software events
> [    0.263380] BUG: unable to handle kernel NULL pointer dereference at (null)
> [    0.266666] IP: [<(null)>] (null)
> [    0.266666] *pde = 00000000
> [    0.266666] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.266666] last sysfs file:
> [    0.266666]
> [    0.266666] Pid: 1, comm: swapper Not tainted 2.6.34-rc1-tip+ #20943 /
> [    0.266666] EIP: 0060:[<00000000>] EFLAGS: 00010046 CPU: 0
> [    0.266666] EIP is at 0x0
> [    0.266666] EAX: 434035b0 EBX: 00000000 ECX: 7f81fe08 EDX: 00000000
> [    0.266666] ESI: 43406444 EDI: 7f82e004 EBP: 7f81ff14 ESP: 7f81fdf0
> [    0.266666]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
> [    0.266666] Process swapper (pid: 1, ti=7f81f000 task=7f824000 task.ti=7f81f000)
> 
> config and full crashlog attached. I had to exclude tip:perf/x86 for now 
> (reverting commit a072738e04 cured the crash), you can re-create that kernel 
> by doing this:
> 
>  git checkout tip/master
>  git merge tip/perf/x86
> 
> (and fixes would be nice to have as delta patches against perf/x86 as well.)
> 
> Thanks,
> 
> 	Ingo

Perhaps something like the patch below (tested with kvm)? With this patch
we will actually waste ~4/8 bytes per PMU (intel,amd,p6) since this call
hits on p4 only, so I think perhaps better to use one x86 scheduler hook
instead of empty schedule_events() in PMU, hmm?
---

x86,perf: Fix NULL deref on not assigned x86_pmu

In case of not assigned x86_pmu and software events
NULL dereference may being hit via x86_pmu::schedule_events
method.

Fix it by calling x86_pmu::schedule_events only if we
have one. Otherwise use general scheduler.

Also the former x86_schedule_events calls restored.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event.c       |   10 +++++++---
 arch/x86/kernel/cpu/perf_event_amd.c   |    1 -
 arch/x86/kernel/cpu/perf_event_intel.c |    2 --
 arch/x86/kernel/cpu/perf_event_p6.c    |    1 -
 4 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event.c
@@ -604,6 +604,10 @@ static int x86_schedule_events(struct cp
 	int i, j, w, wmax, num = 0;
 	struct hw_perf_event *hwc;
 
+	/* the PMU has its own scheduler */
+	if (unlikely(x86_pmu.schedule_events))
+		return x86_pmu.schedule_events(cpuc, n, assign);
+
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
 
 	for (i = 0; i < n; i++) {
@@ -936,7 +940,7 @@ static int x86_pmu_enable(struct perf_ev
 	if (n < 0)
 		return n;
 
-	ret = x86_pmu.schedule_events(cpuc, n, assign);
+	ret = x86_schedule_events(cpuc, n, assign);
 	if (ret)
 		return ret;
 	/*
@@ -1268,7 +1272,7 @@ int hw_perf_group_sched_in(struct perf_e
 	if (n0 < 0)
 		return n0;
 
-	ret = x86_pmu.schedule_events(cpuc, n0, assign);
+	ret = x86_schedule_events(cpuc, n0, assign);
 	if (ret)
 		return ret;
 
@@ -1521,7 +1525,7 @@ static int validate_group(struct perf_ev
 
 	fake_cpuc->n_events = n;
 
-	ret = x86_pmu.schedule_events(fake_cpuc, n, NULL);
+	ret = x86_schedule_events(fake_cpuc, n, NULL);
 
 out_free:
 	kfree(fake_cpuc);
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_amd.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_amd.c
@@ -364,7 +364,6 @@ static __initconst struct x86_pmu amd_pm
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_hw_config,
-	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_K7_EVNTSEL0,
 	.perfctr		= MSR_K7_PERFCTR0,
 	.event_map		= amd_pmu_event_map,
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_intel.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_intel.c
@@ -750,7 +750,6 @@ static __initconst struct x86_pmu core_p
 	.enable			= x86_pmu_enable_event,
 	.disable		= x86_pmu_disable_event,
 	.hw_config		= x86_hw_config,
-	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
@@ -789,7 +788,6 @@ static __initconst struct x86_pmu intel_
 	.enable			= intel_pmu_enable_event,
 	.disable		= intel_pmu_disable_event,
 	.hw_config		= x86_hw_config,
-	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_ARCH_PERFMON_EVENTSEL0,
 	.perfctr		= MSR_ARCH_PERFMON_PERFCTR0,
 	.event_map		= intel_pmu_event_map,
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p6.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p6.c
@@ -110,7 +110,6 @@ static __initconst struct x86_pmu p6_pmu
 	.enable			= p6_pmu_enable_event,
 	.disable		= p6_pmu_disable_event,
 	.hw_config		= x86_hw_config,
-	.schedule_events	= x86_schedule_events,
 	.eventsel		= MSR_P6_EVNTSEL0,
 	.perfctr		= MSR_P6_PERFCTR0,
 	.event_map		= p6_pmu_event_map,
