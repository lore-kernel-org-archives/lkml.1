Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZKCEXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZKCEXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755268AbZKCEXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:23:49 -0500
Received: from ozlabs.org ([203.10.76.45]:48122 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZKCEXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:23:48 -0500
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031453.52394.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:53:52 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/14] cpumask: avoid cpumask_t in arch/x86/kernel/apic/nmi.c
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo wants the certainty of a static cpumask (rather than a
cpumask_var_t), but cpumask_t will some day be undefined to avoid
on-stack declarations.

This is what DECLARE_BITMAP/to_cpumask() is for.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/nmi.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -39,7 +39,8 @@
 int unknown_nmi_panic;
 int nmi_watchdog_enabled;
 
-static cpumask_t backtrace_mask __read_mostly;
+/* For reliability, we're prepared to waste bits here. */
+static DECLARE_BITMAP(backtrace_mask, NR_CPUS) __read_mostly;
 
 /* nmi_active:
  * >0: the lapic NMI watchdog is active, but can be disabled
@@ -414,7 +415,7 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 	}
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (cpumask_test_cpu(cpu, &backtrace_mask)) {
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
@@ -422,7 +423,7 @@ nmi_watchdog_tick(struct pt_regs *regs, 
 		show_regs(regs);
 		dump_stack();
 		spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, &backtrace_mask);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
 		rc = 1;
 	}
@@ -558,14 +559,14 @@ void arch_trigger_all_cpu_backtrace(void
 {
 	int i;
 
-	cpumask_copy(&backtrace_mask, cpu_online_mask);
+	cpumask_copy(to_cpumask(backtrace_mask), cpu_online_mask);
 
 	printk(KERN_INFO "sending NMI to all CPUs:\n");
 	apic->send_IPI_all(NMI_VECTOR);
 
 	/* Wait for up to 10 seconds for all CPUs to do the backtrace */
 	for (i = 0; i < 10 * 1000; i++) {
-		if (cpumask_empty(&backtrace_mask))
+		if (cpumask_empty(to_cpumask(backtrace_mask)))
 			break;
 		mdelay(1);
 	}

