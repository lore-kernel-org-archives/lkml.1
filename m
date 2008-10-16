Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbYJPLwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbYJPLwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 07:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYJPLw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 07:52:28 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:51118 "EHLO
	e28esmtp06.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753195AbYJPLw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 07:52:27 -0400
Date: Thu, 16 Oct 2008 17:22:19 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org, arun@linux.vnet.ibm.com
Subject: [RFC PATCH 4/4] timers: Migrating non pinned regular and hrtimers.
Message-ID: <20081016115219.GE7641@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch migrates all the non cpu-pinned regular and hrtimers
from a particular cpu to the target cpu specified.

The migration is triggered by setting the target cpu number at
/sys/devices/system/cpu/cpuX/timer_migration.

In the situation where the cpuX goes offline *after* the user sets
X as the target_cpu, then timers are not migrated and stay on
the source cpu. But this is just a short term fix and any discussion
in this regard will help greatly.

I have tested this patch by stressing the system using a script
which continuously hotplug-add and removes the cpus.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 kernel/hrtimer.c |    6 ++++++
 kernel/timer.c   |    7 ++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

Index: linux-2.6.27/kernel/timer.c
===================================================================
--- linux-2.6.27.orig/kernel/timer.c
+++ linux-2.6.27/kernel/timer.c
@@ -547,7 +547,7 @@ int __mod_timer(struct timer_list *timer
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret = 0;
+	int ret = 0, target_cpu;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
@@ -562,6 +562,11 @@ int __mod_timer(struct timer_list *timer
 	debug_timer_activate(timer);
 
 	new_base = __get_cpu_var(tvec_bases);
+	target_cpu = __get_cpu_var(enable_timer_migration);
+	if (target_cpu != smp_processor_id() && !tbase_get_pinned(timer->base)
+			&& cpu_online(target_cpu))
+		new_base = per_cpu(tvec_bases, target_cpu);
+
 
 	if (base != new_base) {
 		/*
Index: linux-2.6.27/kernel/hrtimer.c
===================================================================
--- linux-2.6.27.orig/kernel/hrtimer.c
+++ linux-2.6.27/kernel/hrtimer.c
@@ -206,8 +206,14 @@ switch_hrtimer_base(struct hrtimer *time
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int target_cpu;
 
 	new_cpu_base = &__get_cpu_var(hrtimer_bases);
+	target_cpu = __get_cpu_var(enable_timer_migration);
+	if (target_cpu != smp_processor_id() && !is_hrtimer_pinned(timer)
+			&& cpu_online(target_cpu))
+		new_cpu_base = &per_cpu(hrtimer_bases, target_cpu);
+
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
