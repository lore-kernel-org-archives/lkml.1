Return-Path: <linux-kernel-owner+w=401wt.eu-S1756504AbZKDP1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504AbZKDP1L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 10:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbZKDP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 10:27:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:57402 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755853AbZKDP1F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 10:27:05 -0500
Date: Wed, 4 Nov 2009 15:26:38 GMT
From: tip-bot for Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200911031453.52394.rusty@rustcorp.com.au>
References: <200911031453.52394.rusty@rustcorp.com.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] cpumask: Avoid cpumask_t in arch/x86/kernel/apic/nmi.c
Message-ID: <tip-ce7c42710e2dd133f10b7fc9ed9c73bdd2435f7a@git.kernel.org>
Git-Commit-ID: ce7c42710e2dd133f10b7fc9ed9c73bdd2435f7a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce7c42710e2dd133f10b7fc9ed9c73bdd2435f7a
Gitweb:     http://git.kernel.org/tip/ce7c42710e2dd133f10b7fc9ed9c73bdd2435f7a
Author:     Rusty Russell <rusty@rustcorp.com.au>
AuthorDate: Tue, 3 Nov 2009 14:53:52 +1030
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Nov 2009 13:17:53 +0100

cpumask: Avoid cpumask_t in arch/x86/kernel/apic/nmi.c

Ingo wants the certainty of a static cpumask (rather than a
cpumask_var_t), but cpumask_t will some day be undefined to
avoid on-stack declarations.

This is what DECLARE_BITMAP/to_cpumask() is for.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <200911031453.52394.rusty@rustcorp.com.au>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/nmi.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index 7ff61d6..6389432 100644
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
@@ -414,7 +415,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 	}
 
 	/* We can be called before check_nmi_watchdog, hence NULL check. */
-	if (cpumask_test_cpu(cpu, &backtrace_mask)) {
+	if (cpumask_test_cpu(cpu, to_cpumask(backtrace_mask))) {
 		static DEFINE_SPINLOCK(lock);	/* Serialise the printks */
 
 		spin_lock(&lock);
@@ -422,7 +423,7 @@ nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 		show_regs(regs);
 		dump_stack();
 		spin_unlock(&lock);
-		cpumask_clear_cpu(cpu, &backtrace_mask);
+		cpumask_clear_cpu(cpu, to_cpumask(backtrace_mask));
 
 		rc = 1;
 	}
@@ -558,14 +559,14 @@ void arch_trigger_all_cpu_backtrace(void)
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
