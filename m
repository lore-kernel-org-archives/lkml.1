Return-Path: <linux-kernel-owner+w=401wt.eu-S932701AbZFLNlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701AbZFLNlV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 09:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760517AbZFLNbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 09:31:11 -0400
Received: from ozlabs.org ([203.10.76.45]:55300 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764591AbZFLNbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 09:31:06 -0400
CC: linux-kernel@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 12 Jun 2009 22:32:35 +0930
Subject: [PATCH 3/7] cpumask: arch_send_call_function_ipi_mask: mips
Message-Id: <20090612133107.CD941DDDE5@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


We're weaning the core code off handing cpumask's around on-stack.
This introduces arch_send_call_function_ipi_mask(), and by defining
it, the old arch_send_call_function_ipi is defined by the core code.

We also take the chance to wean the implementations off the
obsolescent for_each_cpu_mask(): making send_ipi_mask take the pointer
seemed the most natural way to ensure all implementations used
for_each_cpu.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 arch/mips/include/asm/smp-ops.h     |    2 +-
 arch/mips/include/asm/smp.h         |    3 ++-
 arch/mips/kernel/smp-cmp.c          |    4 ++--
 arch/mips/kernel/smp-mt.c           |    4 ++--
 arch/mips/kernel/smp-up.c           |    3 ++-
 arch/mips/kernel/smp.c              |    2 +-
 arch/mips/mipssim/sim_smtc.c        |    5 +++--
 arch/mips/mti-malta/malta-smtc.c    |    4 ++--
 arch/mips/pmc-sierra/yosemite/smp.c |    4 ++--
 arch/mips/sgi-ip27/ip27-smp.c       |    4 ++--
 arch/mips/sibyte/bcm1480/smp.c      |    5 +++--
 arch/mips/sibyte/sb1250/smp.c       |    5 +++--
 12 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/mips/include/asm/smp-ops.h b/arch/mips/include/asm/smp-ops.h
--- a/arch/mips/include/asm/smp-ops.h
+++ b/arch/mips/include/asm/smp-ops.h
@@ -17,7 +17,7 @@
 
 struct plat_smp_ops {
 	void (*send_ipi_single)(int cpu, unsigned int action);
-	void (*send_ipi_mask)(cpumask_t mask, unsigned int action);
+	void (*send_ipi_mask)(const struct cpumask *mask, unsigned int action);
 	void (*init_secondary)(void);
 	void (*smp_finish)(void);
 	void (*cpus_done)(void);
diff --git a/arch/mips/include/asm/smp.h b/arch/mips/include/asm/smp.h
--- a/arch/mips/include/asm/smp.h
+++ b/arch/mips/include/asm/smp.h
@@ -55,6 +55,7 @@ extern asmlinkage void smp_call_function
 extern asmlinkage void smp_call_function_interrupt(void);
 
 extern void arch_send_call_function_single_ipi(int cpu);
-extern void arch_send_call_function_ipi(cpumask_t mask);
+extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
+#define arch_send_call_function_ipi_mask arch_send_call_function_ipi_mask
 
 #endif /* __ASM_SMP_H */
diff --git a/arch/mips/kernel/smp-cmp.c b/arch/mips/kernel/smp-cmp.c
--- a/arch/mips/kernel/smp-cmp.c
+++ b/arch/mips/kernel/smp-cmp.c
@@ -135,11 +135,11 @@ void cmp_send_ipi_single(int cpu, unsign
 	local_irq_restore(flags);
 }
 
-static void cmp_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void cmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		cmp_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/kernel/smp-mt.c b/arch/mips/kernel/smp-mt.c
--- a/arch/mips/kernel/smp-mt.c
+++ b/arch/mips/kernel/smp-mt.c
@@ -141,11 +141,11 @@ static void vsmp_send_ipi_single(int cpu
 	local_irq_restore(flags);
 }
 
-static void vsmp_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void vsmp_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		vsmp_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/kernel/smp-up.c b/arch/mips/kernel/smp-up.c
--- a/arch/mips/kernel/smp-up.c
+++ b/arch/mips/kernel/smp-up.c
@@ -18,7 +18,8 @@ void up_send_ipi_single(int cpu, unsigne
 	panic(KERN_ERR "%s called", __func__);
 }
 
-static inline void up_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void up_send_ipi_mask(const struct cpumask *mask,
+				    unsigned int action)
 {
 	panic(KERN_ERR "%s called", __func__);
 }
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -128,7 +128,7 @@ asmlinkage __cpuinit void start_secondar
 	cpu_idle();
 }
 
-void arch_send_call_function_ipi(cpumask_t mask)
+void arch_send_call_function_ipi_mask(const struct cpumask *mask)
 {
 	mp_ops->send_ipi_mask(mask, SMP_CALL_FUNCTION);
 }
diff --git a/arch/mips/mipssim/sim_smtc.c b/arch/mips/mipssim/sim_smtc.c
--- a/arch/mips/mipssim/sim_smtc.c
+++ b/arch/mips/mipssim/sim_smtc.c
@@ -43,11 +43,12 @@ static void ssmtc_send_ipi_single(int cp
 	/* "CPU" may be TC of same VPE, VPE of same CPU, or different CPU */
 }
 
-static inline void ssmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void ssmtc_send_ipi_mask(const struct cpumask *mask,
+				       unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		ssmtc_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -21,11 +21,11 @@ static void msmtc_send_ipi_single(int cp
 	smtc_send_ipi(cpu, LINUX_SMP_IPI, action);
 }
 
-static void msmtc_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void msmtc_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		msmtc_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/pmc-sierra/yosemite/smp.c b/arch/mips/pmc-sierra/yosemite/smp.c
--- a/arch/mips/pmc-sierra/yosemite/smp.c
+++ b/arch/mips/pmc-sierra/yosemite/smp.c
@@ -96,11 +96,11 @@ static void yos_send_ipi_single(int cpu,
 	}
 }
 
-static void yos_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void yos_send_ipi_mask(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		yos_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sgi-ip27/ip27-smp.c b/arch/mips/sgi-ip27/ip27-smp.c
--- a/arch/mips/sgi-ip27/ip27-smp.c
+++ b/arch/mips/sgi-ip27/ip27-smp.c
@@ -165,11 +165,11 @@ static void ip27_send_ipi_single(int des
 	REMOTE_HUB_SEND_INTR(COMPACT_TO_NASID_NODEID(cpu_to_node(destid)), irq);
 }
 
-static void ip27_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void ip27_send_ipi(const struct cpumask *mask, unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		ip27_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sibyte/bcm1480/smp.c b/arch/mips/sibyte/bcm1480/smp.c
--- a/arch/mips/sibyte/bcm1480/smp.c
+++ b/arch/mips/sibyte/bcm1480/smp.c
@@ -82,11 +82,12 @@ static void bcm1480_send_ipi_single(int 
 	__raw_writeq((((u64)action)<< 48), mailbox_0_set_regs[cpu]);
 }
 
-static void bcm1480_send_ipi_mask(cpumask_t mask, unsigned int action)
+static void bcm1480_send_ipi_mask(const struct cpumask *mask,
+				  unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		bcm1480_send_ipi_single(i, action);
 }
 
diff --git a/arch/mips/sibyte/sb1250/smp.c b/arch/mips/sibyte/sb1250/smp.c
--- a/arch/mips/sibyte/sb1250/smp.c
+++ b/arch/mips/sibyte/sb1250/smp.c
@@ -70,11 +70,12 @@ static void sb1250_send_ipi_single(int c
 	__raw_writeq((((u64)action) << 48), mailbox_set_regs[cpu]);
 }
 
-static inline void sb1250_send_ipi_mask(cpumask_t mask, unsigned int action)
+static inline void sb1250_send_ipi_mask(const struct cpumask *mask,
+					unsigned int action)
 {
 	unsigned int i;
 
-	for_each_cpu_mask(i, mask)
+	for_each_cpu(i, mask)
 		sb1250_send_ipi_single(i, action);
 }
 

