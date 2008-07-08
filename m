Return-Path: <linux-kernel-owner+w=401wt.eu-S1760940AbYGHXdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940AbYGHXdG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbYGHXPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:31 -0400
Received: from gw.goop.org ([64.81.55.164]:51206 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 19 of 55] xen: move smp setup into smp.c
X-Mercurial-Node: 6bdfddeccabd242a7958e65422a0bf1d45a9341c
Message-Id: <6bdfddeccabd242a7958.1215554801@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:41 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move all the smp_ops setup into smp.c, allowing a lot of things to
become static.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/enlighten.c |   19 +------------------
 arch/x86/xen/smp.c       |   34 ++++++++++++++++++++++++++--------
 arch/x86/xen/xen-ops.h   |   13 +++++--------
 3 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1237,21 +1237,6 @@
 	.set_fixmap = xen_set_fixmap,
 };
 
-#ifdef CONFIG_SMP
-static const struct smp_ops xen_smp_ops __initdata = {
-	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
-	.smp_prepare_cpus = xen_smp_prepare_cpus,
-	.cpu_up = xen_cpu_up,
-	.smp_cpus_done = xen_smp_cpus_done,
-
-	.smp_send_stop = xen_smp_send_stop,
-	.smp_send_reschedule = xen_smp_send_reschedule,
-
-	.send_call_func_ipi = xen_smp_send_call_function_ipi,
-	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
-};
-#endif	/* CONFIG_SMP */
-
 static void xen_reboot(int reason)
 {
 	struct sched_shutdown r = { .reason = reason };
@@ -1340,9 +1325,7 @@
 	have_vcpu_info_placement = 0;
 #endif
 
-#ifdef CONFIG_SMP
-	smp_ops = xen_smp_ops;
-#endif
+	xen_smp_init();
 
 	/* Get mfn list */
 	if (!xen_feature(XENFEAT_auto_translated_physmap))
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -152,7 +152,7 @@
 	}
 }
 
-void __init xen_smp_prepare_boot_cpu(void)
+static void __init xen_smp_prepare_boot_cpu(void)
 {
 	int cpu;
 
@@ -176,7 +176,7 @@
 	xen_setup_vcpu_info_placement();
 }
 
-void __init xen_smp_prepare_cpus(unsigned int max_cpus)
+static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
 
@@ -276,7 +276,7 @@
 	return 0;
 }
 
-int __cpuinit xen_cpu_up(unsigned int cpu)
+static int __cpuinit xen_cpu_up(unsigned int cpu)
 {
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
@@ -319,7 +319,7 @@
 	return 0;
 }
 
-void xen_smp_cpus_done(unsigned int max_cpus)
+static void xen_smp_cpus_done(unsigned int max_cpus)
 {
 }
 
@@ -335,12 +335,12 @@
 	BUG();
 }
 
-void xen_smp_send_stop(void)
+static void xen_smp_send_stop(void)
 {
 	smp_call_function(stop_self, NULL, 0);
 }
 
-void xen_smp_send_reschedule(int cpu)
+static void xen_smp_send_reschedule(int cpu)
 {
 	xen_send_IPI_one(cpu, XEN_RESCHEDULE_VECTOR);
 }
@@ -355,7 +355,7 @@
 		xen_send_IPI_one(cpu, vector);
 }
 
-void xen_smp_send_call_function_ipi(cpumask_t mask)
+static void xen_smp_send_call_function_ipi(cpumask_t mask)
 {
 	int cpu;
 
@@ -370,7 +370,7 @@
 	}
 }
 
-void xen_smp_send_call_function_single_ipi(int cpu)
+static void xen_smp_send_call_function_single_ipi(int cpu)
 {
 	xen_send_IPI_mask(cpumask_of_cpu(cpu), XEN_CALL_FUNCTION_SINGLE_VECTOR);
 }
@@ -394,3 +394,21 @@
 
 	return IRQ_HANDLED;
 }
+
+static const struct smp_ops xen_smp_ops __initdata = {
+	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
+	.smp_prepare_cpus = xen_smp_prepare_cpus,
+	.cpu_up = xen_cpu_up,
+	.smp_cpus_done = xen_smp_cpus_done,
+
+	.smp_send_stop = xen_smp_send_stop,
+	.smp_send_reschedule = xen_smp_send_reschedule,
+
+	.send_call_func_ipi = xen_smp_send_call_function_ipi,
+	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
+};
+
+void __init xen_smp_init(void)
+{
+	smp_ops = xen_smp_ops;
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -47,17 +47,14 @@
 void __init xen_fill_possible_map(void);
 
 void __init xen_setup_vcpu_info_placement(void);
-void xen_smp_prepare_boot_cpu(void);
-void xen_smp_prepare_cpus(unsigned int max_cpus);
-int xen_cpu_up(unsigned int cpu);
-void xen_smp_cpus_done(unsigned int max_cpus);
 
-void xen_smp_send_stop(void);
-void xen_smp_send_reschedule(int cpu);
-void xen_smp_send_call_function_ipi(cpumask_t mask);
-void xen_smp_send_call_function_single_ipi(int cpu);
+#ifdef CONFIG_SMP
+void xen_smp_init(void);
 
 extern cpumask_t xen_cpu_initialized_map;
+#else
+static inline void xen_smp_init(void) {}
+#endif
 
 
 /* Declare an asm function, along with symbols needed to make it


