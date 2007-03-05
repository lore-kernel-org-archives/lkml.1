Return-Path: <linux-kernel-owner+w=401wt.eu-S932457AbXCEWjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457AbXCEWjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932459AbXCEWji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:39:38 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:1330 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbXCEWjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:39:37 -0500
Date: Mon, 5 Mar 2007 23:39:37 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: heiko.carstens@de.ibm.com
Subject: [S390] smp: disable preemption in smp_call_function/smp_call_function_on
Message-ID: <20070305223937.GB22630@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

[S390] smp: disable preemption in smp_call_function/smp_call_function_on

Avoid sprinkling a _lot_ of preempt_disable/preempt_enable pairs.
This would be necessary for e.g. the iucv driver. Also this way we
are more consistent with other architectures which disable
preemption at least for smp_call_function.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/smp.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff -urpN linux-2.6/arch/s390/kernel/smp.c linux-2.6-patched/arch/s390/kernel/smp.c
--- linux-2.6/arch/s390/kernel/smp.c	2007-03-05 22:51:29.000000000 +0100
+++ linux-2.6-patched/arch/s390/kernel/smp.c	2007-03-05 22:51:48.000000000 +0100
@@ -94,10 +94,9 @@ static void __smp_call_function_map(void
 	int cpu, local = 0;
 
 	/*
-	 * Can deadlock when interrupts are disabled or if in wrong context,
-	 * caller must disable preemption
+	 * Can deadlock when interrupts are disabled or if in wrong context.
 	 */
-	WARN_ON(irqs_disabled() || in_irq() || preemptible());
+	WARN_ON(irqs_disabled() || in_irq());
 
 	/*
 	 * Check for local function call. We have to have the same call order
@@ -152,17 +151,18 @@ out:
  * Run a function on all other CPUs.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. Must be called with preemption disabled.
- * You may call it from a bottom half.
+ * hardware interrupt handler. You may call it from a bottom half.
  */
 int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
 		      int wait)
 {
 	cpumask_t map;
 
+	preempt_disable();
 	map = cpu_online_map;
 	cpu_clear(smp_processor_id(), map);
 	__smp_call_function_map(func, info, nonatomic, wait, map);
+	preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function);
@@ -178,16 +178,17 @@ EXPORT_SYMBOL(smp_call_function);
  * Run a function on one processor.
  *
  * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. Must be called with preemption disabled.
- * You may call it from a bottom half.
+ * hardware interrupt handler. You may call it from a bottom half.
  */
 int smp_call_function_on(void (*func) (void *info), void *info, int nonatomic,
 			  int wait, int cpu)
 {
 	cpumask_t map = CPU_MASK_NONE;
 
+	preempt_disable();
 	cpu_set(cpu, map);
 	__smp_call_function_map(func, info, nonatomic, wait, map);
+	preempt_enable();
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_on);
