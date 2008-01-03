Return-Path: <linux-kernel-owner+w=401wt.eu-S1760821AbYACAyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760821AbYACAyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 19:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759882AbYACAuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 19:50:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58348 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759699AbYACAuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 19:50:09 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103149.088038000@suse.de>
In-Reply-To: <20080103149.088038000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [13/20] x86: Use a deferrable timer for the correctable machine check poller
Message-Id: <20080103005008.DCCF414D40@wotan.suse.de>
Date: Thu,  3 Jan 2008 01:50:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


They are not time critical and delaying them a little for
the next regular wakeup is no problem.

Also when a CPU is idle then it is unlikely to generate
errors anyways, so it is ok to check only when the CPU
is actually doing something.

Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/x86/kernel/cpu/mcheck/mce_64.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -379,8 +379,7 @@ static void mcheck_timer(struct work_str
 	if (mce_notify_user()) {
 		next_interval = max(next_interval/2, HZ/100);
 	} else {
-		next_interval = min(next_interval * 2,
-				(int)round_jiffies_relative(check_interval*HZ));
+		next_interval = min(next_interval * 2, check_interval*HZ);
 	}
 
 	cpu = smp_processor_id();
@@ -442,8 +441,7 @@ static void mce_timers(int restart)
 		struct delayed_work *w = &per_cpu(mcheck_work, i);
 		cancel_delayed_work_sync(w);
 		if (restart)
-			schedule_delayed_work_on(i, w,
-					round_jiffies_relative(next_interval));
+				schedule_delayed_work_on(i, w, next_interval);
 	}
 }
 
@@ -553,7 +551,7 @@ void __cpuinit mcheck_init(struct cpuinf
 	int cpu = smp_processor_id();
 	static cpumask_t mce_cpus = CPU_MASK_NONE;
 
-	INIT_DELAYED_WORK(&per_cpu(mcheck_work, cpu), mcheck_timer);
+	INIT_DELAYED_WORK_DEFERRABLE(&per_cpu(mcheck_work, cpu), mcheck_timer);
 
 	mce_cpu_quirks(c);
 
