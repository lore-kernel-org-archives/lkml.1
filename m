Return-Path: <linux-kernel-owner+w=401wt.eu-S1757079AbZCDMT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079AbZCDMT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:19:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZCDMTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:19:48 -0500
Received: from e28smtp08.in.ibm.com ([59.145.155.8]:49595 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZCDMTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:19:47 -0500
Date: Wed, 4 Mar 2009 17:49:37 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: [v2 PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090304121937.GE9855@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090304121249.GA9855@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090304121249.GA9855@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-03-04 17:42:49]:

This patch migrates all non pinned timers and hrtimers to the current
idle load balancer, from all the idle CPUs. Timers firing on busy CPUs
are not migrated.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/hrtimer.c      |   12 +++++++++++-
 kernel/sched.c        |    5 +++++
 kernel/timer.c        |   13 ++++++++++++-
 4 files changed, 29 insertions(+), 2 deletions(-)

Index: linux.trees.git/kernel/timer.c
===================================================================
--- linux.trees.git.orig/kernel/timer.c
+++ linux.trees.git/kernel/timer.c
@@ -38,6 +38,7 @@
 #include <linux/tick.h>
 #include <linux/kallsyms.h>
 #include <linux/timer.h>
+#include <linux/sched.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
@@ -628,7 +629,7 @@ __mod_timer(struct timer_list *timer, un
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret;
+	int ret, current_cpu, preferred_cpu;
 
 	ret = 0;
 
@@ -649,6 +650,16 @@ __mod_timer(struct timer_list *timer, un
 
 	new_base = __get_cpu_var(tvec_bases);
 
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (enable_timer_migration && !tbase_get_pinned(timer->base) &&
+			idle_cpu(current_cpu) && preferred_cpu != -1) {
+		new_base = per_cpu(tvec_bases, preferred_cpu);
+		timer_set_base(timer, new_base);
+		timer->expires = expires;
+		internal_add_timer(new_base, timer);
+		goto out_unlock;
+	}
 	if (base != new_base) {
 		/*
 		 * We are trying to schedule the timer on the local CPU.
Index: linux.trees.git/kernel/hrtimer.c
===================================================================
--- linux.trees.git.orig/kernel/hrtimer.c
+++ linux.trees.git/kernel/hrtimer.c
@@ -43,6 +43,8 @@
 #include <linux/seq_file.h>
 #include <linux/err.h>
 #include <linux/debugobjects.h>
+#include <linux/sched.h>
+#include <linux/timer.h>
 
 #include <asm/uaccess.h>
 
@@ -198,8 +200,16 @@ int pinned)
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int current_cpu, preferred_cpu;
+
+	current_cpu = smp_processor_id();
+	preferred_cpu = get_nohz_load_balancer();
+	if (enable_timer_migration && !pinned && preferred_cpu != -1 &&
+			idle_cpu(current_cpu))
+		new_cpu_base = &per_cpu(hrtimer_bases, preferred_cpu);
+	else
+		new_cpu_base = &__get_cpu_var(hrtimer_bases);
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
Index: linux.trees.git/include/linux/sched.h
===================================================================
--- linux.trees.git.orig/include/linux/sched.h
+++ linux.trees.git/include/linux/sched.h
@@ -265,6 +265,7 @@ static inline int select_nohz_load_balan
 }
 #endif
 
+extern int get_nohz_load_balancer(void);
 /*
  * Only dump TASK_* tasks. (0 for all tasks)
  */
Index: linux.trees.git/kernel/sched.c
===================================================================
--- linux.trees.git.orig/kernel/sched.c
+++ linux.trees.git/kernel/sched.c
@@ -4009,6 +4009,11 @@ static struct {
 	.load_balancer = ATOMIC_INIT(-1),
 };
 
+inline int get_nohz_load_balancer(void)
+{
+	return atomic_read(&nohz.load_balancer);
+}
+
 /*
  * This routine will try to nominate the ilb (idle load balancing)
  * owner among the cpus whose ticks are stopped. ilb owner will do the idle
