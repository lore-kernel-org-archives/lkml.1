Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZELKWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZELKWu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 06:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbZELKWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 06:22:39 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50555 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbZELKWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 06:22:38 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [tip:sched/core] sched: cpuacct: Use bigger percpu counter batch values for stats counters
Cc: kosaki.motohiro@jp.fujitsu.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       balajirrao@gmail.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20090512190346.D638.A69D9226@jp.fujitsu.com>
References: <1242122579.11251.325.camel@twins> <20090512190346.D638.A69D9226@jp.fujitsu.com>
Message-Id: <20090512191650.D63E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 12 May 2009 19:22:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Tue, 2009-05-12 at 19:01 +0900, KOSAKI Motohiro wrote:
> > > +#ifdef CONFIGCONFIG_SMP
> > 
> > typo ?
> 
> yes, this week is my memorial stupid one ;)

ok, assemble list indicate current patch have no typo ;)

ffffffff814ae920:       48 c7 40 30 10 eb 2a    movq   $0xffffffff812aeb10,0x30(%rax)
ffffffff814ae927:       81
ffffffff814ae928:       c7 05 3e 37 fe ff 01    movl   $0x1,-0x1c8c2(%rip)        # ffffffff81492070 <scheduler_running>
ffffffff814ae92f:       00 00 00
ffffffff814ae932:       8b 05 28 52 fe ff       mov    -0x1add8(%rip),%eax        # ffffffff81493b60 <percpu_counter_batch>
ffffffff814ae938:       89 05 36 37 fe ff       mov    %eax,-0x1c8ca(%rip)        # ffffffff81492074 <cpuacct_batch>
ffffffff814ae93e:       41 5c                   pop    %r12



---------------------------------------------------------
Subject: [PATCH] cpuacct: Use bigger percpu counter batch values for stats counters on archs that have VIRT_CPU_ACCOUNTING=y

percpu counters used to accumulate statistics in cpuacct controller use
the default batch value [max(2*nr_cpus, 32)] which can be too small for
archs that define VIRT_CPU_ACCOUNTING. In such archs, a tick could result in
cputime updates in the range of thousands. As a result, cpuacct_update_stats()
would end up acquiring the percpu counter spinlock on every tick which
is not good for performance.

Let those architectures to have a bigger batch threshold so that percpu counter
spinlock isn't taken on every tick. This change doesn't affect the archs which
don't define VIRT_CPU_ACCOUNTING and they continue to have the default
percpu counter batch value.

Cc: Balaji Rao <balajirrao@gmail.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 kernel/sched.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: b/kernel/sched.c
===================================================================
--- a/kernel/sched.c	2009-05-12 13:12:59.000000000 +0900
+++ b/kernel/sched.c	2009-05-12 19:04:49.000000000 +0900
@@ -870,6 +870,8 @@ static __read_mostly int scheduler_runni
  */
 int sysctl_sched_rt_runtime = 950000;
 
+static __read_mostly s32 cpuacct_batch;
+
 static inline u64 global_rt_period(void)
 {
 	return (u64)sysctl_sched_rt_period * NSEC_PER_USEC;
@@ -9284,6 +9286,10 @@ void __init sched_init(void)
 
 	perf_counter_init();
 
+#ifdef CONFIG_SMP
+	cpuacct_batch = jiffies_to_cputime(percpu_counter_batch);
+#endif
+
 	scheduler_running = 1;
 }
 
@@ -10457,7 +10463,8 @@ static void cpuacct_update_stats(struct 
 	ca = task_ca(tsk);
 
 	do {
-		percpu_counter_add(&ca->cpustat[idx], val);
+		__percpu_counter_add(&ca->cpustat[idx], val, cpuacct_batch);
+
 		ca = ca->parent;
 	} while (ca);
 	rcu_read_unlock();


