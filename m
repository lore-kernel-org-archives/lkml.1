Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbXELR6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbXELR6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 13:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752595AbXELR6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 13:58:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:42037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbXELR6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 13:58:15 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] scalable rw_mutex
References: <20070511131541.992688403@chello.nl>
	<20070511132321.895740140@chello.nl>
	<20070511093108.495feb70.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705111006470.32716@schroedinger.engr.sgi.com>
	<20070511110522.ed459635.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 12 May 2007 20:55:28 +0200
In-Reply-To: <20070511110522.ed459635.akpm@linux-foundation.org>
Message-ID: <p73odkpeusf.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Fri, 11 May 2007 10:07:17 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Fri, 11 May 2007, Andrew Morton wrote:
> > 
> > > yipes.  percpu_counter_sum() is expensive.
> > 
> > Capable of triggering NMI watchdog on 4096+ processors?
> 
> Well.  That would be a millisecond per cpu which sounds improbable.  And
> we'd need to be calling it under local_irq_save() which we presently don't.
> And nobody has reported any problems against the existing callsites.
> 
> But it's no speed demon, that's for sure.

There is one possible optimization for this I did some time ago. You don't really
need to sum all over the possible map, but only all CPUs that were ever 
online. But this only helps on systems where the possible map is bigger
than online map in the common case. But that shouldn't be the case anymore on x86
-- it just used to be. If it's true on some other architectures it might
be still worth it.

Old patches with an network example for reference appended.

-Andi

Index: linux-2.6.21-git2-net/include/linux/cpumask.h
===================================================================
--- linux-2.6.21-git2-net.orig/include/linux/cpumask.h
+++ linux-2.6.21-git2-net/include/linux/cpumask.h
@@ -380,6 +380,7 @@ static inline void __cpus_remap(cpumask_
 extern cpumask_t cpu_possible_map;
 extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
+extern cpumask_t cpu_everonline_map;
 
 #if NR_CPUS > 1
 #define num_online_cpus()	cpus_weight(cpu_online_map)
@@ -388,6 +389,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
+#define cpu_ever_online(cpu)	cpu_isset((cpu), cpu_everonline_map)
 #else
 #define num_online_cpus()	1
 #define num_possible_cpus()	1
@@ -395,6 +397,7 @@ extern cpumask_t cpu_present_map;
 #define cpu_online(cpu)		((cpu) == 0)
 #define cpu_possible(cpu)	((cpu) == 0)
 #define cpu_present(cpu)	((cpu) == 0)
+#define cpu_ever_online(cpu)	((cpu) == 0)
 #endif
 
 #ifdef CONFIG_SMP
@@ -409,5 +412,6 @@ int __any_online_cpu(const cpumask_t *ma
 #define for_each_possible_cpu(cpu)  for_each_cpu_mask((cpu), cpu_possible_map)
 #define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
 #define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_everonline_cpu(cpu) for_each_cpu_mask((cpu), cpu_everonline_map)
 
 #endif /* __LINUX_CPUMASK_H */
Index: linux-2.6.21-git2-net/kernel/cpu.c
===================================================================
--- linux-2.6.21-git2-net.orig/kernel/cpu.c
+++ linux-2.6.21-git2-net/kernel/cpu.c
@@ -26,6 +26,10 @@ static __cpuinitdata RAW_NOTIFIER_HEAD(c
  */
 static int cpu_hotplug_disabled;
 
+/* Contains any CPUs that were ever online at some point.
+   No guarantee they were fully initialized though */
+cpumask_t cpu_everonline_map;
+
 #ifdef CONFIG_HOTPLUG_CPU
 
 /* Crappy recursive lock-takers in cpufreq! Complain loudly about idiots */
@@ -212,6 +216,8 @@ static int __cpuinit _cpu_up(unsigned in
 	if (cpu_online(cpu) || !cpu_present(cpu))
 		return -EINVAL;
 
+	cpu_set(cpu, cpu_everonline_map);
+
 	ret = raw_notifier_call_chain(&cpu_chain, CPU_UP_PREPARE, hcpu);
 	if (ret == NOTIFY_BAD) {
 		printk("%s: attempt to bring up CPU %u failed\n",
Index: linux-2.6.21-git2-net/net/ipv4/proc.c
===================================================================
--- linux-2.6.21-git2-net.orig/net/ipv4/proc.c
+++ linux-2.6.21-git2-net/net/ipv4/proc.c
@@ -50,7 +50,7 @@ static int fold_prot_inuse(struct proto 
 	int res = 0;
 	int cpu;
 
-	for_each_possible_cpu(cpu)
+	for_each_everonline_cpu(cpu)
 		res += proto->stats[cpu].inuse;
 
 	return res;


