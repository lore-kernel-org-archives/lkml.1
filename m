Return-Path: <linux-kernel-owner+w=401wt.eu-S1753648AbZCHQtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648AbZCHQtG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 12:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZCHQsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 12:48:37 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52169 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753160AbZCHQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 12:48:36 -0400
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 01/13] [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
Date: Sun,  8 Mar 2009 11:48:14 -0500
Message-Id: <1236530906-7175-2-git-send-email-James.Bottomley@HansenPartnership.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not having apics, Voyager can't use the default apic implementation of
these, it has to read from a special port in the VIC to get the
processor ID, so abstract these functions in smp_ops to allow voyager
to live simultaneously with the apic code.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/smp.h  |   13 +++++++++++--
 arch/x86/kernel/apic/apic.c |    5 -----
 arch/x86/kernel/apic/ipi.c  |    2 +-
 arch/x86/kernel/smp.c       |    7 +++++++
 arch/x86/xen/smp.c          |    7 +++++++
 5 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 47d0e21..d11687e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -60,6 +60,8 @@ struct smp_ops {
 
 	void (*send_call_func_ipi)(const struct cpumask *mask);
 	void (*send_call_func_single_ipi)(int cpu);
+	int (*hard_smp_processor_id)(void);
+	int (*safe_smp_processor_id)(void);
 };
 
 /* Globals due to paravirt */
@@ -158,7 +160,11 @@ extern unsigned disabled_cpus __cpuinitdata;
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
@@ -184,7 +190,10 @@ static inline int logical_smp_processor_id(void)
 
 #endif
 
-extern int hard_smp_processor_id(void);
+static inline int hard_smp_processor_id(void)
+{
+	return smp_ops.hard_smp_processor_id();
+}
 
 #else /* CONFIG_X86_LOCAL_APIC */
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f9cecdf..ee68005 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1856,11 +1856,6 @@ void __cpuinit generic_processor_info(int apicid, int version)
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
index 035582a..0dfb8c0 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -450,6 +450,11 @@ static irqreturn_t xen_call_function_single_interrupt(int irq, void *dev_id)
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
@@ -465,6 +470,8 @@ static const struct smp_ops xen_smp_ops __initdata = {
 
 	.send_call_func_ipi = xen_smp_send_call_function_ipi,
 	.send_call_func_single_ipi = xen_smp_send_call_function_single_ipi,
+	.hard_smp_processor_id = xen_hard_smp_processor_id,
+	.safe_smp_processor_id = apic_safe_smp_processor_id,
 };
 
 void __init xen_smp_init(void)
-- 
1.6.1.3

