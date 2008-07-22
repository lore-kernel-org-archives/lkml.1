Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbYGVVDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbYGVVDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYGVVDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:03:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbYGVVDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:03:22 -0400
Date: Tue, 22 Jul 2008 14:03:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, ak@linux.intel.com,
       mingo@elte.hu, tiwai@suse.de, linux-next@vger.kernel.org
Subject: Re: [PATCH 72/79] sysdev: Pass the attribute to the low level
 sysdev show/store function
Message-Id: <20080722140301.2a334f8c.akpm@linux-foundation.org>
In-Reply-To: <20080722204939.GA3028@suse.de>
References: <20080722051805.GA17373@suse.de>
	<1216703983-21448-72-git-send-email-gregkh@suse.de>
	<20080722134045.7f09ff29.akpm@linux-foundation.org>
	<20080722204939.GA3028@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2008 13:49:39 -0700
Greg KH <gregkh@suse.de> wrote:

> On Tue, Jul 22, 2008 at 01:40:45PM -0700, Andrew Morton wrote:
> > On Mon, 21 Jul 2008 22:19:36 -0700
> > Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > 
> > > From: Andi Kleen <andi@firstfloor.org>
> > > 
> > > This allow to dynamically generate attributes and share show/store
> > > functions between attributes. Right now most attributes are generated
> > > by special macros and lots of duplicated code. With the attribute
> > > passed it's instead possible to attach some data to the attribute
> > > and then use that in shared low level functions to do different things.
> > > 
> > > I need this for the dynamically generated bank attributes in the x86
> > > machine check code, but it'll allow some further cleanups.
> > > 
> > > I converted all users in tree to the new show/store prototype. It's a single
> > > huge patch to avoid unbisectable sections.
> > > 
> > > Runtime tested: x86-32, x86-64
> > > Compiled only: ia64, powerpc
> > > Not compile tested/only grep converted: sh, arm, avr32
> > > 
> > > Signed-off-by: Andi Kleen <ak@linux.intel.com>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > >
> > > ...
> > >
> > >  kernel/sched.c                            |    8 ++++-
> > 
> > This wrecks use-sysdev_class-in-schedc.patch (below), which I merged a
> > week ago and will now drop.
> > 
> > Why did this patch from Andi just turn up in linux-next now, halfway
> > through the merge window?  It has a commit date of July 1 yet it has
> > never before been sighted in linux-next.
> 
> What?  It's been in linux-next for a while now as it's been in my tree
> for quite some time.  Unless it somehow got reverted in -next and I
> didn't realize it?  Which I kind of doubt as it was causing problems
> with the sparc build and I got reports of that.
> 
> This should be a simple merge, the show/store functions of sysdev now
> just got an additional parameter, like we've done for a while with other
> types of attributes.
> 

Well the changelog for yesterday's linux-next lists this change, but
the diff to kernel/sched.c (below) does not contain it.  No idea what
caused that.

A whole pile of greggish stuff just turned up in linux-next and I'm
fixing and dropping stuff left, right and centre over here.

diff -puN kernel/sched.c~linux-next kernel/sched.c
--- a/kernel/sched.c~linux-next
+++ a/kernel/sched.c
@@ -2108,7 +2108,7 @@ find_idlest_group(struct sched_domain *s
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2150,7 +2150,7 @@ find_idlest_cpu(struct sched_group *grou
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask(i, *tmp) {
+	for_each_cpu_mask_nr(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3168,7 +3168,7 @@ find_busiest_group(struct sched_domain *
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3447,7 +3447,7 @@ find_busiest_queue(struct sched_group *g
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask(i, group->cpumask) {
+	for_each_cpu_mask_nr(i, group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -3989,7 +3989,7 @@ static void run_rebalance_domains(struct
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask(balance_cpu, cpus) {
+		for_each_cpu_mask_nr(balance_cpu, cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -5663,12 +5663,7 @@ void sched_show_task(struct task_struct 
 		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
-	{
-		unsigned long *n = end_of_stack(p);
-		while (!*n)
-			n++;
-		free = (unsigned long)n - (unsigned long)end_of_stack(p);
-	}
+	free = stack_not_used(p);
 #endif
 	printk(KERN_CONT "%5lu %5d %6d\n", free,
 		task_pid_nr(p), task_pid_nr(p->real_parent));
@@ -6802,7 +6797,7 @@ init_sched_build_groups(const cpumask_t 
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask(i, *span) {
+	for_each_cpu_mask_nr(i, *span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -6813,7 +6808,7 @@ init_sched_build_groups(const cpumask_t 
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask(j, *span) {
+		for_each_cpu_mask_nr(j, *span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7013,7 +7008,7 @@ static void init_numa_sched_groups_power
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask(j, sg->cpumask) {
+		for_each_cpu_mask_nr(j, sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7038,7 +7033,7 @@ static void free_sched_groups(const cpum
 {
 	int cpu, i;
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7277,7 +7272,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7344,7 +7339,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7361,7 +7356,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7428,7 +7423,7 @@ static int __build_sched_domains(const c
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask(j, *nodemask) {
+		for_each_cpu_mask_nr(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7474,21 +7469,21 @@ static int __build_sched_domains(const c
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7508,7 +7503,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7603,7 +7598,7 @@ static void detach_destroy_domains(const
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask(i, *cpu_map)
+	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);

