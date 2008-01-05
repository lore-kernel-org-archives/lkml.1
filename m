Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYAEOwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYAEOwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYAEOwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:52:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49691 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYAEOwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:52:18 -0500
Subject: Re: [PATCH 6/7] sched: rt-group: per group period
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080104135653.157876000@chello.nl>
References: <20080104135457.336761000@chello.nl>
	 <20080104135653.157876000@chello.nl>
Content-Type: text/plain
Date: Sat, 05 Jan 2008 15:51:59 +0100
Message-Id: <1199544719.31975.34.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please fold this into the 6/7 patch.

It reverts a wandering chunk (the 32768 thing), but more importantly
it fixes !FAIR_GROUP_SCHED compilation.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -647,7 +647,7 @@ const_debug unsigned int sysctl_sched_rt
  * ratio of time -rt tasks may consume.
  * default: 95%
  */
-const_debug unsigned int sysctl_sched_rt_ratio = 32768; //62259;
+const_debug unsigned int sysctl_sched_rt_ratio = 62259;
 
 /*
  * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
@@ -5379,6 +5379,7 @@ static void __init sched_rt_period_init(
 	hotcpu_notifier(sched_rt_period_hotplug, 0);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static void __sched_rt_period_init_tg(void *arg)
 {
 	struct task_group *tg = arg;
@@ -5404,12 +5405,14 @@ static void sched_rt_period_destroy_tg(s
 {
 	on_each_cpu(__sched_rt_period_destroy_tg, tg, 0, 1);
 }
-#else
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+#else /* CONFIG_SMP */
 static void __init sched_rt_period_init(void)
 {
 	sched_rt_period_start_cpu(0);
 }
 
+#ifdef CONFIG_FAIR_GROUP_SCHED
 static void sched_rt_period_init_tg(struct task_group *tg)
 {
 	sched_rt_period_start(tg->rt_rq[0]);
@@ -5419,7 +5422,8 @@ static void sched_rt_period_destroy_tg(s
 {
 	sched_rt_period_stop(tg->rt_rq[0]);
 }
-#endif
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_SMP */
 
 #ifdef CONFIG_SMP
 /*


