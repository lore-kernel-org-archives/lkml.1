Return-Path: <linux-kernel-owner+w=401wt.eu-S1755263AbZAELoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263AbZAELoA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbZAELm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:42:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:55623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbZAELm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:42:57 -0500
Message-Id: <20090105103136.194327781@chello.nl>
References: <20090105102818.829119334@chello.nl>
User-Agent: quilt/0.46-1
Date: Mon, 05 Jan 2009 11:28:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/5] hrtimer: fix HOTPLUG_CPU=n compile warning
Content-Disposition: inline; filename=hrtimers-fix-hotplug-cpu-n-compile.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

kernel/hrtimer.c: In function 'hrtimer_cpu_notify':
kernel/hrtimer.c:1574: warning: unused variable 'dcpu'

Introduced by commit 37810659ea7d9572c5ac284ade272f806ef8f788
("hrtimer: removing all ur callback modes, fix hotplug") from the
timers.  dcpu is only used if CONFIG_HOTPLUG_CPU is set.

Pointed-out-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
===================================================================
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -1532,6 +1532,11 @@ static void __cpuinit init_hrtimers_cpu(
 
 #ifdef CONFIG_HOTPLUG_CPU
 
+static void tickle_timers(void *arg)
+{
+	hrtimer_peek_ahead_timers();
+}
+
 static void migrate_hrtimer_list(struct hrtimer_clock_base *old_base,
 				struct hrtimer_clock_base *new_base)
 {
@@ -1567,7 +1572,7 @@ static void migrate_hrtimer_list(struct 
 	}
 }
 
-static int migrate_hrtimers(int scpu)
+static void migrate_hrtimers(int scpu)
 {
 	struct hrtimer_cpu_base *old_base, *new_base;
 	int dcpu, i;
@@ -1595,12 +1600,7 @@ static int migrate_hrtimers(int scpu)
 	spin_unlock_irq(&new_base->lock);
 	put_cpu_var(hrtimer_bases);
 
-	return dcpu;
-}
-
-static void tickle_timers(void *arg)
-{
-	hrtimer_peek_ahead_timers();
+	smp_call_function_single(dcpu, tickle_timers, NULL, 0);
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -1625,11 +1625,8 @@ static int __cpuinit hrtimer_cpu_notify(
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 	{
-		int dcpu;
-
 		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
-		dcpu = migrate_hrtimers(scpu);
-		smp_call_function_single(dcpu, tickle_timers, NULL, 0);
+		migrate_hrtimers(scpu);
 		break;
 	}
 #endif

-- 

