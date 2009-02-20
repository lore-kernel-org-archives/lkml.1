Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbZBTNBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbZBTNBw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 08:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbZBTNBn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 08:01:43 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:52773 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZBTNBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 08:01:43 -0500
Date: Fri, 20 Feb 2009 18:31:31 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de,
       mingo@elte.hu, andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org
Subject: [RFC PATCH 4/4] timers: logic to enable timer migration.
Message-ID: <20090220130131.GD19762@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: linux-kernel@vger.kernel.org,
	linux-pm@lists.linux-foundation.org, a.p.zijlstra@chello.nl,
	ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
	andi@firstfloor.org, venkatesh.pallipadi@intel.com,
	vatsa@linux.vnet.ibm.com, arjan@infradead.org
References: <20090220125516.GB10232@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090220125516.GB10232@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-02-20 18:25:16]:

This patch migrates all non pinned timers and hrtimers to the target
CPU.

Timer migration is enabled by setting the sysfs entry of the
particular CPU. At the time of queuing a timer, it is checked to see
if migration is enabled for that particular CPU. If so, the target CPU
base is set as the new timer base and the timer is queued on that CPU.


Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 kernel/hrtimer.c |   12 +++++++++++-
 kernel/timer.c   |   15 ++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

Index: git-2.6/kernel/timer.c
===================================================================
--- git-2.6.orig/kernel/timer.c
+++ git-2.6/kernel/timer.c
@@ -616,7 +616,7 @@ int __mod_timer(struct timer_list *timer
 {
 	struct tvec_base *base, *new_base;
 	unsigned long flags;
-	int ret = 0;
+	int ret = 0, target_cpu;
 
 	timer_stats_timer_set_start_info(timer);
 	BUG_ON(!timer->function);
@@ -631,6 +631,18 @@ int __mod_timer(struct timer_list *timer
 	debug_timer_activate(timer);
 
 	new_base = __get_cpu_var(tvec_bases);
+	/*
+	 * @target_cpu: The CPU to which timers are to be migrated.
+	 * If timer migration is disabled, target_cpu = this_cpu.
+	 */
+	target_cpu = __get_cpu_var(enable_timer_migration);
+	if (!tbase_get_pinned(timer->base) && cpu_online(target_cpu)) {
+		new_base = per_cpu(tvec_bases, target_cpu);
+		timer_set_base(timer, new_base);
+		timer->expires = expires;
+		internal_add_timer(new_base, timer);
+		goto out;
+	}
 
 	if (base != new_base) {
 		/*
@@ -652,6 +664,7 @@ int __mod_timer(struct timer_list *timer
 
 	timer->expires = expires;
 	internal_add_timer(base, timer);
+out:
 	spin_unlock_irqrestore(&base->lock, flags);
 
 	return ret;
Index: git-2.6/kernel/hrtimer.c
===================================================================
--- git-2.6.orig/kernel/hrtimer.c
+++ git-2.6/kernel/hrtimer.c
@@ -198,8 +198,18 @@ int pinned)
 {
 	struct hrtimer_clock_base *new_base;
 	struct hrtimer_cpu_base *new_cpu_base;
+	int target_cpu;
+
+	/*
+	 * @target_cpu: CPU to which the timers are to be migrated.
+	 * If timer migration is disabled, target_cpu = this_cpu
+	 */
+	target_cpu = __get_cpu_var(enable_timer_migration);
+	if (cpu_online(target_cpu) && !pinned)
+		new_cpu_base = &per_cpu(hrtimer_bases, target_cpu);
+	else
+		new_cpu_base = &__get_cpu_var(hrtimer_bases);
 
-	new_cpu_base = &__get_cpu_var(hrtimer_bases);
 	new_base = &new_cpu_base->clock_base[base->index];
 
 	if (base != new_base) {
