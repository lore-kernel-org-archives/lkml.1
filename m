Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbZDOFqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbZDOFqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZDOFqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:46:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:56482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbZDOFqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:46:06 -0400
Message-ID: <49E5744A.8060203@kernel.org>
Date: Tue, 14 Apr 2009 22:44:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Gary Hade <garyhade@us.ibm.com>, lcm@us.ibm.com,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/4] irq: make set_affinity to return status -v2
References: <200903231757.53709.rusty@rustcorp.com.au> <20090323165921.GA7559@us.ibm.com> <200903241553.58209.rusty@rustcorp.com.au> <20090402013108.GB7103@us.ibm.com> <20090404003520.GA8847@us.ibm.com> <20090410215515.GC7242@us.ibm.com> <20090411065510.GA11799@elte.hu> <20090413220321.GA11098@us.ibm.com> <49E4146C.7060507@kernel.org> <49E4162A.3060701@kernel.org> <20090414131711.GA4403@elte.hu> <49E4F513.1060709@kernel.org> <49E4F54C.7030807@kernel.org>
In-Reply-To: <49E4F54C.7030807@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: prepare to use it to keep affinity consistent

according to Ingo, change set_affinity() in irq_chip to return int.

v2: fix two typo that pointed by Rusty

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/alpha/kernel/sys_dp264.c         |    8 +++-
 arch/alpha/kernel/sys_titan.c         |    4 +-
 arch/arm/common/gic.c                 |    4 +-
 arch/cris/arch-v32/kernel/irq.c       |    4 +-
 arch/ia64/hp/sim/hpsim_irq.c          |    3 +
 arch/ia64/kernel/iosapic.c            |   10 +++--
 arch/ia64/kernel/msi_ia64.c           |   16 +++++---
 arch/ia64/sn/kernel/irq.c             |    4 +-
 arch/ia64/sn/kernel/msi_sn.c          |    8 ++--
 arch/mips/cavium-octeon/octeon-irq.c  |    8 +++-
 arch/mips/include/asm/irq.h           |    2 -
 arch/mips/kernel/irq-gic.c            |    5 +-
 arch/mips/mti-malta/malta-smtc.c      |    4 +-
 arch/mips/sibyte/bcm1480/irq.c        |    8 ++--
 arch/mips/sibyte/sb1250/irq.c         |    8 ++--
 arch/parisc/kernel/irq.c              |    6 ++-
 arch/powerpc/platforms/pseries/xics.c |   12 +++---
 arch/powerpc/sysdev/mpic.c            |    4 +-
 arch/sparc/kernel/irq_64.c            |   12 ++++--
 arch/x86/kernel/apic/io_apic.c        |   64 +++++++++++++++++++++-------------
 drivers/parisc/iosapic.c              |    6 ++-
 drivers/xen/events.c                  |   12 +++---
 include/linux/irq.h                   |    2 -
 23 files changed, 140 insertions(+), 74 deletions(-)

Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -176,22 +176,26 @@ cpu_set_irq_affinity(unsigned int irq, c
 	}
 }
 
-static void
+static int
 dp264_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
+
+	return 0;
 }
 
-static void
+static int
 clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq - 16, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
 	spin_unlock(&dp264_irq_lock);
+
+	return 0;
 }
 
 static struct hw_interrupt_type dp264_irq_type = {
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -157,13 +157,15 @@ titan_cpu_set_irq_affinity(unsigned int
 
 }
 
-static void
+static int
 titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 { 
 	spin_lock(&titan_irq_lock);
 	titan_cpu_set_irq_affinity(irq - 16, *affinity);
 	titan_update_irq_hw(titan_cached_irq_mask);
 	spin_unlock(&titan_irq_lock);
+
+	return 0;
 }
 
 static void
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -109,7 +109,7 @@ static void gic_unmask_irq(unsigned int
 }
 
 #ifdef CONFIG_SMP
-static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
+static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
@@ -122,6 +122,8 @@ static void gic_set_cpu(unsigned int irq
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
 	spin_unlock(&irq_controller_lock);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -325,12 +325,14 @@ static void end_crisv32_irq(unsigned int
 {
 }
 
-void set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
+int set_affinity_crisv32_irq(unsigned int irq, const struct cpumask *dest)
 {
 	unsigned long flags;
 	spin_lock_irqsave(&irq_lock, flags);
 	irq_allocations[irq - FIRST_IRQ].mask = *dest;
 	spin_unlock_irqrestore(&irq_lock, flags);
+
+	return 0;
 }
 
 static struct irq_chip crisv32_irq_type = {
Index: linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/hp/sim/hpsim_irq.c
+++ linux-2.6/arch/ia64/hp/sim/hpsim_irq.c
@@ -21,9 +21,10 @@ hpsim_irq_noop (unsigned int irq)
 {
 }
 
-static void
+static int
 hpsim_set_affinity_noop(unsigned int a, const struct cpumask *b)
 {
+	return 0;
 }
 
 static struct hw_interrupt_type irq_type_hp_sim = {
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -329,7 +329,7 @@ unmask_irq (unsigned int irq)
 }
 
 
-static void
+static int
 iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
@@ -343,15 +343,15 @@ iosapic_set_affinity(unsigned int irq, c
 
 	cpu = cpumask_first_and(cpu_online_mask, mask);
 	if (cpu >= nr_cpu_ids)
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	dest = cpu_physical_id(cpu);
 
 	if (!iosapic_intr_info[irq].count)
-		return;			/* not an IOSAPIC interrupt */
+		return -1;			/* not an IOSAPIC interrupt */
 
 	set_irq_affinity_info(irq, dest, redir);
 
@@ -376,7 +376,9 @@ iosapic_set_affinity(unsigned int irq, c
 		iosapic_write(iosapic, IOSAPIC_RTE_HIGH(rte_index), high32);
 		iosapic_write(iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
+
 #endif
+	return 0;
 }
 
 /*
Index: linux-2.6/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6/arch/ia64/kernel/msi_ia64.c
@@ -12,7 +12,7 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static void ia64_set_msi_irq_affinity(unsigned int irq,
+static int ia64_set_msi_irq_affinity(unsigned int irq,
 				      const cpumask_t *cpu_mask)
 {
 	struct msi_msg msg;
@@ -20,10 +20,10 @@ static void ia64_set_msi_irq_affinity(un
 	int cpu = first_cpu(*cpu_mask);
 
 	if (!cpu_online(cpu))
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	read_msi_msg(irq, &msg);
 
@@ -39,6 +39,8 @@ static void ia64_set_msi_irq_affinity(un
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -130,17 +132,17 @@ void arch_teardown_msi_irq(unsigned int
 
 #ifdef CONFIG_DMAR
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
 	struct msi_msg msg;
 	int cpu = cpumask_first(mask);
 
 	if (!cpu_online(cpu))
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	dmar_msi_read(irq, &msg);
 
@@ -151,6 +153,8 @@ static void dmar_msi_set_affinity(unsign
 
 	dmar_msi_write(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -227,7 +227,7 @@ finish_up:
 	return new_irq_info;
 }
 
-static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
+static int sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
@@ -239,6 +239,8 @@ static void sn_set_affinity_irq(unsigned
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
+
+	return 0;
 }
 
 #ifdef CONFIG_SMP
Index: linux-2.6/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6/arch/ia64/sn/kernel/msi_sn.c
@@ -151,7 +151,7 @@ int sn_setup_msi_irq(struct pci_dev *pde
 }
 
 #ifdef CONFIG_SMP
-static void sn_set_msi_irq_affinity(unsigned int irq,
+static int sn_set_msi_irq_affinity(unsigned int irq,
 				    const struct cpumask *cpu_mask)
 {
 	struct msi_msg msg;
@@ -168,7 +168,7 @@ static void sn_set_msi_irq_affinity(unsi
 	cpu = cpumask_first(cpu_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
-		return;
+		return -1;
 
 	/*
 	 * Release XIO resources for the old MSI PCI address
@@ -189,7 +189,7 @@ static void sn_set_msi_irq_affinity(unsi
 	new_irq_info = sn_retarget_vector(sn_irq_info, nasid, slice);
 	sn_msi_info[irq].sn_irq_info = new_irq_info;
 	if (new_irq_info == NULL)
-		return;
+		return -1;
 
 	/*
 	 * Map the xio address into bus space
@@ -206,6 +206,8 @@ static void sn_set_msi_irq_affinity(unsi
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
Index: linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/octeon-irq.c
+++ linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
@@ -177,7 +177,7 @@ static void octeon_irq_ciu0_disable(unsi
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
@@ -199,6 +199,8 @@ static void octeon_irq_ciu0_set_affinity
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
 	write_unlock(&octeon_irq_ciu0_rwlock);
+
+	return 0;
 }
 #endif
 
@@ -292,7 +294,7 @@ static void octeon_irq_ciu1_disable(unsi
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
@@ -315,6 +317,8 @@ static void octeon_irq_ciu1_set_affinity
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1));
 	write_unlock(&octeon_irq_ciu1_rwlock);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/mips/kernel/irq-gic.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/irq-gic.c
+++ linux-2.6/arch/mips/kernel/irq-gic.c
@@ -155,7 +155,7 @@ static void gic_unmask_irq(unsigned int
 
 static DEFINE_SPINLOCK(gic_lock);
 
-static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+static int gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
@@ -166,7 +166,7 @@ static void gic_set_affinity(unsigned in
 
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
-		return;
+		return -1;
 
 	/* Assumption : cpumask refers to a single CPU */
 	spin_lock_irqsave(&gic_lock, flags);
@@ -190,6 +190,7 @@ static void gic_set_affinity(unsigned in
 	cpumask_copy(irq_desc[irq].affinity, cpumask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/irq.c
@@ -50,7 +50,7 @@ static void enable_bcm1480_irq(unsigned
 static void disable_bcm1480_irq(unsigned int irq);
 static void ack_bcm1480_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_PCI
@@ -109,7 +109,7 @@ void bcm1480_unmask_irq(int cpu, int irq
 }
 
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
@@ -119,7 +119,7 @@ static void bcm1480_set_affinity(unsigne
 
 	if (cpumask_weight(mask) != 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 	i = cpumask_first(mask);
 
@@ -155,6 +155,8 @@ static void bcm1480_set_affinity(unsigne
 	}
 	spin_unlock(&bcm1480_imr_lock);
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6/arch/mips/sibyte/sb1250/irq.c
@@ -50,7 +50,7 @@ static void enable_sb1250_irq(unsigned i
 static void disable_sb1250_irq(unsigned int irq);
 static void ack_sb1250_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_SIBYTE_HAS_LDT
@@ -103,7 +103,7 @@ void sb1250_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on;
 	u64 cur_ints;
@@ -114,7 +114,7 @@ static void sb1250_set_affinity(unsigned
 
 	if (cpumask_weight(mask) > 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 
 	/* Convert logical CPU to physical CPU */
@@ -146,6 +146,8 @@ static void sb1250_set_affinity(unsigned
 	}
 	spin_unlock(&sb1250_imr_lock);
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/parisc/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/irq.c
+++ linux-2.6/arch/parisc/kernel/irq.c
@@ -130,15 +130,17 @@ int cpu_check_affinity(unsigned int irq,
 	return cpu_dest;
 }
 
-static void cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
+static int cpu_set_affinity_irq(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu_dest;
 
 	cpu_dest = cpu_check_affinity(irq, dest);
 	if (cpu_dest < 0)
-		return;
+		return -1;
 
 	cpumask_copy(&irq_desc[irq].affinity, dest);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -333,7 +333,7 @@ static void xics_eoi_lpar(unsigned int v
 	lpar_xirr_info_set((0xff << 24) | irq);
 }
 
-static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
+static int xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 {
 	unsigned int irq;
 	int status;
@@ -342,14 +342,14 @@ static void xics_set_affinity(unsigned i
 
 	irq = (unsigned int)irq_map[virq].hwirq;
 	if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
-		return;
+		return -1;
 
 	status = rtas_call(ibm_get_xive, 1, 3, xics_status, irq);
 
 	if (status) {
 		printk(KERN_ERR "%s: ibm,get-xive irq=%u returns %d\n",
 			__func__, irq, status);
-		return;
+		return -1;
 	}
 
 	/*
@@ -363,7 +363,7 @@ static void xics_set_affinity(unsigned i
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
-		return;
+		return -1;
 	}
 
 	status = rtas_call(ibm_set_xive, 3, 1, NULL,
@@ -372,8 +372,10 @@ static void xics_set_affinity(unsigned i
 	if (status) {
 		printk(KERN_ERR "%s: ibm,set-xive irq=%u returns %d\n",
 			__func__, irq, status);
-		return;
+		return -1;
 	}
+
+	return 0;
 }
 
 static struct irq_chip xics_pic_direct = {
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -807,7 +807,7 @@ static void mpic_end_ipi(unsigned int ir
 
 #endif /* CONFIG_SMP */
 
-void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -824,6 +824,8 @@ void mpic_set_affinity(unsigned int irq,
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
 			       mpic_physmask(cpus_addr(tmp)[0]));
 	}
+
+	return 0;
 }
 
 static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)
Index: linux-2.6/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6/arch/sparc/kernel/irq_64.c
@@ -318,10 +318,12 @@ static void sun4u_irq_enable(unsigned in
 	}
 }
 
-static void sun4u_set_affinity(unsigned int virt_irq,
+static int sun4u_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
 	sun4u_irq_enable(virt_irq);
+
+	return 0;
 }
 
 /* Don't do anything.  The desc->status check for IRQ_DISABLED in
@@ -377,7 +379,7 @@ static void sun4v_irq_enable(unsigned in
 		       ino, err);
 }
 
-static void sun4v_set_affinity(unsigned int virt_irq,
+static int sun4v_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
@@ -388,6 +390,8 @@ static void sun4v_set_affinity(unsigned
 	if (err != HV_EOK)
 		printk(KERN_ERR "sun4v_intr_settarget(%x,%lu): "
 		       "err(%d)\n", ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_irq_disable(unsigned int virt_irq)
@@ -445,7 +449,7 @@ static void sun4v_virq_enable(unsigned i
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virt_set_affinity(unsigned int virt_irq,
+static int sun4v_virt_set_affinity(unsigned int virt_irq,
 				    const struct cpumask *mask)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
@@ -461,6 +465,8 @@ static void sun4v_virt_set_affinity(unsi
 		printk(KERN_ERR "sun4v_vintr_set_target(%lx,%lx,%lu): "
 		       "err(%d)\n",
 		       dev_handle, dev_ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_virq_disable(unsigned int virt_irq)
Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -2326,13 +2326,14 @@ set_desc_affinity(struct irq_desc *desc,
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
 }
 
-static void
+static int
 set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned long flags;
 	unsigned int dest;
 	unsigned int irq;
+	int ret = -1;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
@@ -2343,18 +2344,21 @@ set_ioapic_affinity_irq_desc(struct irq_
 		/* Only the high 8 bits are valid. */
 		dest = SET_APIC_LOGICAL_ID(dest);
 		__target_IO_APIC_irq(irq, dest, cfg);
+		ret = 0;
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
+
+	return ret;
 }
 
-static void
+static int
 set_ioapic_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc;
 
 	desc = irq_to_desc(irq);
 
-	set_ioapic_affinity_irq_desc(desc, mask);
+	return set_ioapic_affinity_irq_desc(desc, mask);
 }
 
 #ifdef CONFIG_INTR_REMAP
@@ -2370,24 +2374,25 @@ set_ioapic_affinity_irq(unsigned int irq
  * Real vector that is used for interrupting cpu will be coming from
  * the interrupt-remapping table entry.
  */
-static void
+static int
 migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
 	unsigned int dest;
 	unsigned int irq;
+	int ret = -1;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
-		return;
+		return ret;
 
 	irq = desc->irq;
 	if (get_irte(irq, &irte))
-		return;
+		return ret;
 
 	cfg = desc->chip_data;
 	if (assign_irq_vector(irq, cfg, mask))
-		return;
+		return ret;
 
 	set_extra_move_desc(desc, mask);
 
@@ -2405,27 +2410,30 @@ migrate_ioapic_irq_desc(struct irq_desc
 		send_cleanup_vector(cfg);
 
 	cpumask_copy(desc->affinity, mask);
+
+	return 0;
 }
 
 /*
  * Migrates the IRQ destination in the process context.
  */
-static void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 					    const struct cpumask *mask)
 {
-	migrate_ioapic_irq_desc(desc, mask);
+	return migrate_ioapic_irq_desc(desc, mask);
 }
-static void set_ir_ioapic_affinity_irq(unsigned int irq,
+static int set_ir_ioapic_affinity_irq(unsigned int irq,
 				       const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	set_ir_ioapic_affinity_irq_desc(desc, mask);
+	return set_ir_ioapic_affinity_irq_desc(desc, mask);
 }
 #else
-static inline void set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
+static inline int set_ir_ioapic_affinity_irq_desc(struct irq_desc *desc,
 						   const struct cpumask *mask)
 {
+	return 0;
 }
 #endif
 
@@ -3362,7 +3370,7 @@ static int msi_compose_msg(struct pci_de
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3371,7 +3379,7 @@ static void set_msi_irq_affinity(unsigne
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3383,13 +3391,15 @@ static void set_msi_irq_affinity(unsigne
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	write_msi_msg_desc(desc, &msg);
+
+	return 0;
 }
 #ifdef CONFIG_INTR_REMAP
 /*
  * Migrate the MSI irq to another cpumask. This migration is
  * done in the process context using interrupt-remapping hardware.
  */
-static void
+static int
 ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
@@ -3398,11 +3408,11 @@ ir_set_msi_irq_affinity(unsigned int irq
 	struct irte irte;
 
 	if (get_irte(irq, &irte))
-		return;
+		return -1;
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -3419,6 +3429,8 @@ ir_set_msi_irq_affinity(unsigned int irq
 	 */
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
+
+	return 0;
 }
 
 #endif
@@ -3572,7 +3584,7 @@ void arch_teardown_msi_irq(unsigned int
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3581,7 +3593,7 @@ static void dmar_msi_set_affinity(unsign
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3593,6 +3605,8 @@ static void dmar_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3626,7 +3640,7 @@ int arch_setup_dmar_msi(unsigned int irq
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3635,7 +3649,7 @@ static void hpet_msi_set_affinity(unsign
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3647,6 +3661,8 @@ static void hpet_msi_set_affinity(unsign
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3703,7 +3719,7 @@ static void target_ht_irq(unsigned int i
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3711,11 +3727,13 @@ static void set_ht_irq_affinity(unsigned
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
 	target_ht_irq(irq, dest, cfg->vector);
+
+	return 0;
 }
 
 #endif
Index: linux-2.6/drivers/parisc/iosapic.c
===================================================================
--- linux-2.6.orig/drivers/parisc/iosapic.c
+++ linux-2.6/drivers/parisc/iosapic.c
@@ -702,7 +702,7 @@ static unsigned int iosapic_startup_irq(
 }
 
 #ifdef CONFIG_SMP
-static void iosapic_set_affinity_irq(unsigned int irq,
+static int iosapic_set_affinity_irq(unsigned int irq,
 				     const struct cpumask *dest)
 {
 	struct vector_info *vi = iosapic_get_vector(irq);
@@ -712,7 +712,7 @@ static void iosapic_set_affinity_irq(uns
 
 	dest_cpu = cpu_check_affinity(irq, dest);
 	if (dest_cpu < 0)
-		return;
+		return -1;
 
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(dest_cpu));
 	vi->txn_addr = txn_affinity_addr(irq, dest_cpu);
@@ -724,6 +724,8 @@ static void iosapic_set_affinity_irq(uns
 	iosapic_set_irt_data(vi, &dummy_d0, &d1);
 	iosapic_wr_irt_entry(vi, d0, d1);
 	spin_unlock_irqrestore(&iosapic_lock, flags);
+
+	return 0;
 }
 #endif
 
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -694,13 +694,13 @@ void rebind_evtchn_irq(int evtchn, int i
 }
 
 /* Rebind an evtchn so that it gets delivered to a specific cpu */
-static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
+static int rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
 {
 	struct evtchn_bind_vcpu bind_vcpu;
 	int evtchn = evtchn_from_irq(irq);
 
 	if (!VALID_EVTCHN(evtchn))
-		return;
+		return -1;
 
 	/* Send future instances of this interrupt to other vcpu. */
 	bind_vcpu.port = evtchn;
@@ -713,13 +713,15 @@ static void rebind_irq_to_cpu(unsigned i
 	 */
 	if (HYPERVISOR_event_channel_op(EVTCHNOP_bind_vcpu, &bind_vcpu) >= 0)
 		bind_evtchn_to_cpu(evtchn, tcpu);
-}
 
+	return 0;
+}
 
-static void set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
-	rebind_irq_to_cpu(irq, tcpu);
+
+	return rebind_irq_to_cpu(irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
Index: linux-2.6/include/linux/irq.h
===================================================================
--- linux-2.6.orig/include/linux/irq.h
+++ linux-2.6/include/linux/irq.h
@@ -117,7 +117,7 @@ struct irq_chip {
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq,
+	int		(*set_affinity)(unsigned int irq,
 					const struct cpumask *dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
Index: linux-2.6/arch/mips/include/asm/irq.h
===================================================================
--- linux-2.6.orig/arch/mips/include/asm/irq.h
+++ linux-2.6/arch/mips/include/asm/irq.h
@@ -49,7 +49,7 @@ static inline void smtc_im_ack_irq(unsig
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
 #include <linux/cpumask.h>
 
-extern void plat_set_irq_affinity(unsigned int irq,
+extern int plat_set_irq_affinity(unsigned int irq,
 				  const struct cpumask *affinity);
 extern void smtc_forward_irq(unsigned int irq);
 
Index: linux-2.6/arch/mips/mti-malta/malta-smtc.c
===================================================================
--- linux-2.6.orig/arch/mips/mti-malta/malta-smtc.c
+++ linux-2.6/arch/mips/mti-malta/malta-smtc.c
@@ -114,7 +114,7 @@ struct plat_smp_ops msmtc_smp_ops = {
  */
 
 
-void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
+int plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 {
 	cpumask_t tmask;
 	int cpu = 0;
@@ -156,5 +156,7 @@ void plat_set_irq_affinity(unsigned int
 
 	/* Do any generic SMTC IRQ affinity setup */
 	smtc_set_irq_affinity(irq, tmask);
+
+	return 0;
 }
 #endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
