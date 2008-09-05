Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546AbYIEVkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbYIEVkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 17:40:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYIEVkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 17:40:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33830 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751505AbYIEVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 17:40:21 -0400
Message-Id: <20080905214020.263636000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.47-1
Date: Fri, 05 Sep 2008 14:40:21 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>, Jes Sorensen <jes@sgi.com>,
       David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: reduce stack requirements for send_call_func_ipi
References: <20080905214019.821172000@polaris-admin.engr.sgi.com>
Content-Disposition: inline; filename=smp_ops
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * By converting the internal x86 smp_ops function send_call_func_ipi
    to pass a pointer to the cpumask_t variable, we greatly reduce the
    stack space required when NR_CPUS=4096.

    Further reduction will be realized when the send_IPI_mask interface
    is changed in 2.6.28.

Based on 2.6.27-rc5-git6.

Applies to linux-2.6.tip/master (with FUZZ).

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smp.c |    6 +++---
 arch/x86/xen/smp.c    |    6 +++---
 include/asm-x86/smp.h |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- linux-2.6.orig/arch/x86/kernel/smp.c
+++ linux-2.6/arch/x86/kernel/smp.c
@@ -126,18 +126,18 @@ void native_send_call_func_single_ipi(in
 	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(cpumask_t mask)
+void native_send_call_func_ipi(const cpumask_t *mask)
 {
 	cpumask_t allbutself;
 
 	allbutself = cpu_online_map;
 	cpu_clear(smp_processor_id(), allbutself);
 
-	if (cpus_equal(mask, allbutself) &&
+	if (cpus_equal(*mask, allbutself) &&
 	    cpus_equal(cpu_online_map, cpu_callout_map))
 		send_IPI_allbutself(CALL_FUNCTION_VECTOR);
 	else
-		send_IPI_mask(mask, CALL_FUNCTION_VECTOR);
+		send_IPI_mask(*mask, CALL_FUNCTION_VECTOR);
 }
 
 static void stop_this_cpu(void *dummy)
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -371,14 +371,14 @@ static void xen_send_IPI_mask(cpumask_t 
 		xen_send_IPI_one(cpu, vector);
 }
 
-static void xen_smp_send_call_function_ipi(cpumask_t mask)
+static void xen_smp_send_call_function_ipi(const cpumask_t *mask)
 {
 	int cpu;
 
-	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
+	xen_send_IPI_mask(*mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, *mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
--- linux-2.6.orig/include/asm-x86/smp.h
+++ linux-2.6/include/asm-x86/smp.h
@@ -53,7 +53,7 @@ struct smp_ops {
 	void (*smp_send_stop)(void);
 	void (*smp_send_reschedule)(int cpu);
 
-	void (*send_call_func_ipi)(cpumask_t mask);
+	void (*send_call_func_ipi)(const cpumask_t *mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -103,14 +103,14 @@ static inline void arch_send_call_functi
 
 static inline void arch_send_call_function_ipi(cpumask_t mask)
 {
-	smp_ops.send_call_func_ipi(mask);
+	smp_ops.send_call_func_ipi(&mask);
 }
 
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
 int native_cpu_up(unsigned int cpunum);
-void native_send_call_func_ipi(cpumask_t mask);
+void native_send_call_func_ipi(const cpumask_t *mask);
 void native_send_call_func_single_ipi(int cpu);
 
 extern int __cpu_disable(void);

