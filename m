Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXFSTmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXFSTmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761453AbXFSTmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:42:10 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:56116 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761176AbXFSTmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:42:06 -0400
Subject: [PATCH RT] Only check IRQ Thread affinity update if CPU affinity
	changed.
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 19 Jun 2007 15:41:31 -0400
Message-Id: <1182282091.15228.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the softirq in hardirq change. The hard irq threads
pin themselves to one of the CPUs that the IRQ affinity is on.

This patch cleans up this by only updating the cpu affinity, if the cpu
that the thread is pinned on is no longer part of the IRQ affinity.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6-rt-test/kernel/irq/manage.c
===================================================================
--- linux-2.6-rt-test.orig/kernel/irq/manage.c
+++ linux-2.6-rt-test/kernel/irq/manage.c
@@ -762,13 +762,15 @@ static int do_irqd(void * __desc)
 
 #ifdef CONFIG_SMP
 	cpumask_t cpus_allowed, mask;
+	int pinned_cpu;
 
 	cpus_allowed = desc->affinity;
 	/*
 	 * Restrict it to one cpu so we avoid being migrated inside of
 	 * do_softirq_from_hardirq()
 	 */
-	mask = cpumask_of_cpu(first_cpu(desc->affinity));
+	pinned_cpu = first_cpu(desc->affinity);
+	mask = cpumask_of_cpu(pinned_cpu);
 	set_cpus_allowed(current, mask);
 #endif
 	current->flags |= PF_NOFREEZE | PF_HARDIRQ;
@@ -793,14 +795,15 @@ static int do_irqd(void * __desc)
 		/*
 		 * Did IRQ affinities change?
 		 */
-		if (!cpus_equal(cpus_allowed, desc->affinity)) {
+		if (!cpu_isset(pinned_cpu, desc->affinity)) {
 			cpus_allowed = desc->affinity;
 			/*
 			 * Restrict it to one cpu so we avoid being
 			 * migrated inside of
 			 * do_softirq_from_hardirq()
 			 */
-			mask = cpumask_of_cpu(first_cpu(desc->affinity));
+			pinned_cpu = first_cpu(desc->affinity);
+			mask = cpumask_of_cpu(pinned_cpu);
 			set_cpus_allowed(current, mask);
 		}
 #endif


