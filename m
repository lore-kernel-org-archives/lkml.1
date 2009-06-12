Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbZFLNma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbZFLNma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbZFLNbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:15 -0400
Received: from ozlabs.org ([203.10.76.45]:55307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759714AbZFLNbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:07 -0400
CC: linux-kernel@vger.kernel.org
To: Richard Henderson <rth@twiddle.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 1/7] cpumask: arch_send_call_function_ipi_mask: alpha
Message-Id: <20090612133108.EF027DDDE6@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask().

We also take the chance to wean the send_ipi_message off the
obsolescent for_each_cpu_mask(): making it take a pointer seemed the
most natural way to do this.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/alpha/include/asm/smp.h |    3 ++-
 arch/alpha/kernel/smp.c      |   14 +++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/include/asm/smp.h b/arch/alpha/include/asm/smp.h
--- a/arch/alpha/include/asm/smp.h
+++ b/arch/alpha/include/asm/smp.h
@@ -47,7 +47,8 @@ extern int smp_num_cpus;
 extern int smp_num_cpus;
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #else /* CONFIG_SMP */
 
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -547,16 +547,16 @@ setup_profiling_timer(unsigned int multi
 
 
 static void
-send_ipi_message(cpumask_t to_whom, enum ipi_message_type operation)
+send_ipi_message(const struct cpumask *to_whom, enum ipi_message_type operation)
 {
 	int i;
 
 	mb();
-	for_each_cpu_mask(i, to_whom)
+	for_each_cpu(i, to_whom)
 		set_bit(operation, &ipi_data[i].bits);
 
 	mb();
-	for_each_cpu_mask(i, to_whom)
+	for_each_cpu(i, to_whom)
 		wripir(i);
 }
 
@@ -623,7 +623,7 @@ smp_send_reschedule(int cpu)
 		printk(KERN_WARNING
 		       "smp_send_reschedule: Sending IPI to self.\n");
 #endif
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_RESCHEDULE);
+	send_ipi_message(cpumask_of(cpu), IPI_RESCHEDULE);
 }
 
 void
@@ -635,17 +635,17 @@ smp_send_stop(void)
 	if (hard_smp_processor_id() != boot_cpu_id)
 		printk(KERN_WARNING "smp_send_stop: Not on boot cpu.\n");
 #endif
-	send_ipi_message(to_whom, IPI_CPU_STOP);
+	send_ipi_message(&to_whom, IPI_CPU_STOP);
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	send_ipi_message(mask, IPI_CALL_FUNC);
 }
 
 void arch_send_call_function_single_ipi(int cpu)
 {
-	send_ipi_message(cpumask_of_cpu(cpu), IPI_CALL_FUNC_SINGLE);
+	send_ipi_message(cpumask_of(cpu), IPI_CALL_FUNC_SINGLE);
 }
 
 static void

