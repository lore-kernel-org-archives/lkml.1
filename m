Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbZKTGw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbZKTGw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 01:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbZKTGw2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 01:52:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:38303 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754552AbZKTGw1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 01:52:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/uMFUET1Du6PzbNN3rVoT99oKDBNGN3dKMXndjV+
	W/qJuOrFXquPiv
Subject: Re: [Bug #14383] hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1258695658.29789.27.camel@localhost>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.65H.2TdALB@chimera>  <1258542581.3918.255.camel@laptop>
	 <1258695658.29789.27.camel@localhost>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 07:52:30 +0100
Message-Id: <1258699950.7148.9.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:40 +0800, Zhang, Yanmin wrote:

> Mike's patch 1b9508f6831e10 could improve netperf loopback testing.
> The latest upstream doesn't merge it yet.

The kinda ugly thing below gives me around a 4% boost for pinned tasks.
Looking around is expensive to fast movers, some cost can be avoided.

---
 kernel/sched_fair.c |   40 +++++++++++++++++++++++++++++-----------
 1 file changed, 29 insertions(+), 11 deletions(-)

Index: linux-2.6/kernel/sched_fair.c
===================================================================
--- linux-2.6.orig/kernel/sched_fair.c
+++ linux-2.6/kernel/sched_fair.c
@@ -1396,26 +1396,36 @@ static int select_task_rq_fair(struct ta
 {
 	struct sched_domain *tmp, *affine_sd = NULL, *sd = NULL;
 	int cpu = smp_processor_id();
-	int prev_cpu = task_cpu(p);
-	int new_cpu = cpu;
-	int want_affine = 0;
-	int want_sd = 1;
+	int new_cpu, prev_cpu = task_cpu(p);
+	int pinned, want_sd, want_affine = 0;
 	int sync = wake_flags & WF_SYNC;
 
-	if (sd_flag & SD_BALANCE_WAKE) {
-		if (sched_feat(AFFINE_WAKEUPS) &&
-		    cpumask_test_cpu(cpu, &p->cpus_allowed))
-			want_affine = 1;
+	rcu_read_lock();
+	pinned = !(cpumask_weight(&p->cpus_allowed) > 1);
+	new_cpu = pinned ? prev_cpu : cpu;
+	want_sd = !pinned;
+
+#ifndef CONFIG_FAIR_GROUP_SCHED
+		/*
+		 * If we don't need to balance shares, we can skip
+		 * everything below, and save some time.
+		 */
+		if (pinned)
+			goto out;
+#endif
+
+	if ((sd_flag & SD_BALANCE_WAKE) && sched_feat(AFFINE_WAKEUPS) &&
+			cpumask_test_cpu(cpu, &p->cpus_allowed)) {
+		want_affine = 1;
 		new_cpu = prev_cpu;
 	}
 
-	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		/*
 		 * If power savings logic is enabled for a domain, see if we
 		 * are not overloaded, if so, don't balance wider.
 		 */
-		if (tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
+		if (want_sd && tmp->flags & (SD_POWERSAVINGS_BALANCE|SD_PREFER_LOCAL)) {
 			unsigned long power = 0;
 			unsigned long nr_running = 0;
 			unsigned long capacity;
@@ -1454,7 +1464,7 @@ static int select_task_rq_fair(struct ta
 			 * If there's an idle sibling in this domain, make that
 			 * the wake_affine target instead of the current cpu.
 			 */
-			if (tmp->flags & SD_PREFER_SIBLING)
+			if (!pinned && tmp->flags & SD_PREFER_SIBLING)
 				target = select_idle_sibling(p, tmp, target);
 
 			if (target >= 0) {
@@ -1476,6 +1486,7 @@ static int select_task_rq_fair(struct ta
 			sd = tmp;
 	}
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 	if (sched_feat(LB_SHARES_UPDATE)) {
 		/*
 		 * Pick the largest domain to update shares over
@@ -1490,6 +1501,13 @@ static int select_task_rq_fair(struct ta
 			update_shares(tmp);
 	}
 
+	/*
+	 * Balance shares, but don't waste time.
+	 */
+	if (pinned)
+		goto out;
+#endif
+
 	if (affine_sd && wake_affine(affine_sd, p, sync)) {
 		new_cpu = cpu;
 		goto out;


