Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbZDNPwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbZDNPwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 11:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbZDNPvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 11:51:45 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45953 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753968AbZDNPvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 11:51:42 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 01/14] [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
Date: Tue, 14 Apr 2009 10:51:27 -0500
Message-Id: <1239724300-16371-2-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1239724300-16371-1-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not having apics, Voyager can't use the default apic implementation of
these, it has to read from a special port in the VIC to get the
processor ID, so abstract these functions in smp_ops to allow voyager
to live simultaneously with the apic code.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/include/asm/smp.h  |   13 +++++++++++--
 arch/x86/kernel/apic/apic.c |    5 -----
 arch/x86/kernel/apic/ipi.c  |    2 +-
 arch/x86/kernel/smp.c       |    7 +++++++
 arch/x86/xen/smp.c          |    7 +++++++
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19e0d88..aac866f 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -60,6 +60,8 @@ struct smp_ops {
 
 	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
+	int (*hard_smp_processor_id)(void);
+	int (*safe_smp_processor_id)(void);
 };
 
 /* Globals due to paravirt */
@@ -159,7 +161,11 @@ extern unsigned disabled_cpus __cpuinitdata;
  * so this is correct in the x86 case.
  */
 #define raw_smp_processor_id() (percpu_read(cpu_number))
-extern int safe_smp_processor_id(void);
+int apic_safe_smp_processor_id(void);
+static inline int safe_smp_processor_id(void)
+{
+	return smp_ops.safe_smp_processor_id();
+}
 
 #elif defined(CONFIG_X86_64_SMP)
 #define raw_smp_processor_id() (percpu_read(cpu_number))
@@ -185,7 +191,10 @@ static inline int logical_smp_processor_id(void)
 
 #endif
 
-extern int hard_smp_processor_id(void);
+static inline int hard_smp_processor_id(void)
+{
+	return smp_ops.hard_smp_processor_id();
+}
 
 #else /* CONFIG_X86_LOCAL_APIC */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f287092..f9e830e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1885,11 +1885,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	set_cpu_present(cpu, true);
 }
 
-int hard_smp_processor_id(void)
-{
-	return read_apic_id();
-}
-
 void default_init_apic_ldr(void)
 {
 	unsigned long val;
diff --git a/arch/x86/kernel/apic/ipi.c b/arch/x86/kernel/apic/ipi.c
index dbf5445..90bb775 100644
--- a/arch/x86/kernel/apic/ipi.c
+++ b/arch/x86/kernel/apic/ipi.c
@@ -146,7 +146,7 @@ static int convert_apicid_to_cpu(int apic_id)
 	return -1;
 }
 
-int safe_smp_processor_id(void)
+int apic_safe_smp_processor_id(void)
 {
 	int apicid, cpuid;
 
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 13f33ea..29d0af7 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -192,6 +192,11 @@ void smp_call_function_single_interrupt(struct pt_regs *regs)
 	irq_exit();
 }
 
+static int native_hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+
 struct smp_ops smp_ops = {
 	.smp_prepare_boot_cpu = native_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = native_smp_prepare_cpus,
@@ -207,5 +212,7 @@ struct smp_ops smp_ops = {
 
 	.send_call_func_ipi = native_send_call_func_ipi,
 	.send_call_func_single_ipi = native_send_call_func_single_ipi,
+	.hard_smp_processor_id = native_hard_smp_processor_id,
+	.safe_smp_processor_id = apic_safe_smp_processor_id,
 };
 EXPORT_SYMBOL_GPL(smp_ops);
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 429834e..eb795bf 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -454,6 +454,11 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+static int xen_hard_smp_processor_id(void)
+{
+	return read_apic_id();
+}
+
 static const struct smp_ops xen_smp_ops __initdata = {
 	.smp_prepare_boot_cpu = xen_smp_prepare_boot_cpu,
 	.smp_prepare_cpus = xen_smp_prepare_cpus,
@@ -469,6 +474,8 @@ static const struct smp_ops xen_smp_ops __initdata = {
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,
 	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
+	.hard_smp_processor_id = xen_hard_smp_processor_id,
+	.safe_smp_processor_id = apic_safe_smp_processor_id,
 };
 
 void __init xen_smp_init(void)
-- 
1.6.2.1

