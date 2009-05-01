Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbZEARJD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbZEARJD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 13:09:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756929AbZEARIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 13:08:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:42790 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759726AbZEARIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 13:08:31 -0400
Date: Fri, 1 May 2009 17:06:53 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, ebiederm@xmission.com,
       akpm@linux-foundation.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49F654E9.4070809@kernel.org>
References: <49F654E9.4070809@kernel.org>
Subject: [tip:irq/numa] irq: change ->set_affinity() to return status
Message-ID: <tip-d5dedd4507d307eb3f35f21b6e16f336fdc0d82a@git.kernel.org>
Git-Commit-ID: d5dedd4507d307eb3f35f21b6e16f336fdc0d82a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 01 May 2009 17:06:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d5dedd4507d307eb3f35f21b6e16f336fdc0d82a
Gitweb:     http://git.kernel.org/tip/d5dedd4507d307eb3f35f21b6e16f336fdc0d82a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 27 Apr 2009 17:59:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 28 Apr 2009 12:21:16 +0200

irq: change ->set_affinity() to return status

according to Ingo, change set_affinity() in irq_chip should return int,
because that way we can handle failure cases in a much cleaner way, in
the genirq layer.

v2: fix two typos

[ Impact: extend API ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-arch@vger.kernel.org
LKML-Reference: <49F654E9.4070809@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/alpha/kernel/sys_dp264.c         |    8 +++-
 arch/alpha/kernel/sys_titan.c         |    4 ++-
 arch/arm/common/gic.c                 |    4 ++-
 arch/cris/arch-v32/kernel/irq.c       |    4 ++-
 arch/ia64/hp/sim/hpsim_irq.c          |    3 +-
 arch/ia64/kernel/iosapic.c            |   10 +++--
 arch/ia64/kernel/msi_ia64.c           |   16 +++++---
 arch/ia64/sn/kernel/irq.c             |    4 ++-
 arch/ia64/sn/kernel/msi_sn.c          |    8 +++--
 arch/mips/cavium-octeon/octeon-irq.c  |    8 +++-
 arch/mips/include/asm/irq.h           |    2 +-
 arch/mips/kernel/irq-gic.c            |    5 ++-
 arch/mips/mti-malta/malta-smtc.c      |    4 ++-
 arch/mips/sibyte/bcm1480/irq.c        |    8 +++--
 arch/mips/sibyte/sb1250/irq.c         |    8 +++--
 arch/parisc/kernel/irq.c              |    6 ++-
 arch/powerpc/platforms/pseries/xics.c |   12 ++++---
 arch/powerpc/sysdev/mpic.c            |    4 ++-
 arch/sparc/kernel/irq_64.c            |   12 +++++--
 arch/x86/kernel/apic/io_apic.c        |   64 +++++++++++++++++++++------------
 drivers/parisc/iosapic.c              |    6 ++-
 drivers/xen/events.c                  |   12 ++++---
 include/linux/irq.h                   |    2 +-
 23 files changed, 140 insertions(+), 74 deletions(-)

diff --git a/arch/alpha/kernel/sys_dp264.c b/arch/alpha/kernel/sys_dp264.c
index 9c9d1fd..5bd5259 100644
--- a/arch/alpha/kernel/sys_dp264.c
+++ b/arch/alpha/kernel/sys_dp264.c
@@ -176,22 +176,26 @@ cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
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
diff --git a/arch/alpha/kernel/sys_titan.c b/arch/alpha/kernel/sys_titan.c
index 27f840a..8dd239e 100644
--- a/arch/alpha/kernel/sys_titan.c
+++ b/arch/alpha/kernel/sys_titan.c
@@ -157,13 +157,15 @@ titan_cpu_set_irq_affinity(unsigned int irq, cpumask_t affinity)
 
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
diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index c6884ba..90f6b7f 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -109,7 +109,7 @@ static void gic_unmask_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
+static int gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 {
 	void __iomem *reg = gic_dist_base(irq) + GIC_DIST_TARGET + (gic_irq(irq) & ~3);
 	unsigned int shift = (irq % 4) * 8;
@@ -122,6 +122,8 @@ static void gic_set_cpu(unsigned int irq, const struct cpumask *mask_val)
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
 	spin_unlock(&irq_controller_lock);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/cris/arch-v32/kernel/irq.c b/arch/cris/arch-v32/kernel/irq.c
index df3925c..d70b445 100644
--- a/arch/cris/arch-v32/kernel/irq.c
+++ b/arch/cris/arch-v32/kernel/irq.c
@@ -325,12 +325,14 @@ static void end_crisv32_irq(unsigned int irq)
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
diff --git a/arch/ia64/hp/sim/hpsim_irq.c b/arch/ia64/hp/sim/hpsim_irq.c
index cc0a318..acb5047 100644
--- a/arch/ia64/hp/sim/hpsim_irq.c
+++ b/arch/ia64/hp/sim/hpsim_irq.c
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
diff --git a/arch/ia64/kernel/iosapic.c b/arch/ia64/kernel/iosapic.c
index 166e0d8..f92cef4 100644
--- a/arch/ia64/kernel/iosapic.c
+++ b/arch/ia64/kernel/iosapic.c
@@ -329,7 +329,7 @@ unmask_irq (unsigned int irq)
 }
 
 
-static void
+static int
 iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 #ifdef CONFIG_SMP
@@ -343,15 +343,15 @@ iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 
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
 
@@ -376,7 +376,9 @@ iosapic_set_affinity(unsigned int irq, const struct cpumask *mask)
 		iosapic_write(iosapic, IOSAPIC_RTE_HIGH(rte_index), high32);
 		iosapic_write(iosapic, IOSAPIC_RTE_LOW(rte_index), low32);
 	}
+
 #endif
+	return 0;
 }
 
 /*
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 2b15e23..0f8ade9 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -12,7 +12,7 @@
 static struct irq_chip	ia64_msi_chip;
 
 #ifdef CONFIG_SMP
-static void ia64_set_msi_irq_affinity(unsigned int irq,
+static int ia64_set_msi_irq_affinity(unsigned int irq,
 				      const cpumask_t *cpu_mask)
 {
 	struct msi_msg msg;
@@ -20,10 +20,10 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 	int cpu = first_cpu(*cpu_mask);
 
 	if (!cpu_online(cpu))
-		return;
+		return -1;
 
 	if (irq_prepare_move(irq, cpu))
-		return;
+		return -1;
 
 	read_msi_msg(irq, &msg);
 
@@ -39,6 +39,8 @@ static void ia64_set_msi_irq_affinity(unsigned int irq,
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(cpu));
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
@@ -130,17 +132,17 @@ void arch_teardown_msi_irq(unsigned int irq)
 
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
 
@@ -151,6 +153,8 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dmar_msi_write(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 66fd705..764f26a 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -227,7 +227,7 @@ finish_up:
 	return new_irq_info;
 }
 
-static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
+static int sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 {
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
@@ -239,6 +239,8 @@ static void sn_set_affinity_irq(unsigned int irq, const struct cpumask *mask)
 	list_for_each_entry_safe(sn_irq_info, sn_irq_info_safe,
 				 sn_irq_lh[irq], list)
 		(void)sn_retarget_vector(sn_irq_info, nasid, slice);
+
+	return 0;
 }
 
 #ifdef CONFIG_SMP
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index 81e4289..fbbfb97 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -151,7 +151,7 @@ int sn_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *entry)
 }
 
 #ifdef CONFIG_SMP
-static void sn_set_msi_irq_affinity(unsigned int irq,
+static int sn_set_msi_irq_affinity(unsigned int irq,
 				    const struct cpumask *cpu_mask)
 {
 	struct msi_msg msg;
@@ -168,7 +168,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 	cpu = cpumask_first(cpu_mask);
 	sn_irq_info = sn_msi_info[irq].sn_irq_info;
 	if (sn_irq_info == NULL || sn_irq_info->irq_int_bit >= 0)
-		return;
+		return -1;
 
 	/*
 	 * Release XIO resources for the old MSI PCI address
@@ -189,7 +189,7 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 	new_irq_info = sn_retarget_vector(sn_irq_info, nasid, slice);
 	sn_msi_info[irq].sn_irq_info = new_irq_info;
 	if (new_irq_info == NULL)
-		return;
+		return -1;
 
 	/*
 	 * Map the xio address into bus space
@@ -206,6 +206,8 @@ static void sn_set_msi_irq_affinity(unsigned int irq,
 
 	write_msi_msg(irq, &msg);
 	cpumask_copy(irq_desc[irq].affinity, cpu_mask);
+
+	return 0;
 }
 #endif /* CONFIG_SMP */
 
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index 1c19af8..d3a0c81 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -177,7 +177,7 @@ static void octeon_irq_ciu0_disable(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
@@ -199,6 +199,8 @@ static void octeon_irq_ciu0_set_affinity(unsigned int irq, const struct cpumask
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN0(cvmx_get_core_num() * 2));
 	write_unlock(&octeon_irq_ciu0_rwlock);
+
+	return 0;
 }
 #endif
 
@@ -292,7 +294,7 @@ static void octeon_irq_ciu1_disable(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
+static int octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask *dest)
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
@@ -315,6 +317,8 @@ static void octeon_irq_ciu1_set_affinity(unsigned int irq, const struct cpumask
 	 */
 	cvmx_read_csr(CVMX_CIU_INTX_EN1(cvmx_get_core_num() * 2 + 1));
 	write_unlock(&octeon_irq_ciu1_rwlock);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/include/asm/irq.h b/arch/mips/include/asm/irq.h
index 3214ade..4f1eed1 100644
--- a/arch/mips/include/asm/irq.h
+++ b/arch/mips/include/asm/irq.h
@@ -49,7 +49,7 @@ static inline void smtc_im_ack_irq(unsigned int irq)
 #ifdef CONFIG_MIPS_MT_SMTC_IRQAFF
 #include <linux/cpumask.h>
 
-extern void plat_set_irq_affinity(unsigned int irq,
+extern int plat_set_irq_affinity(unsigned int irq,
 				  const struct cpumask *affinity);
 extern void smtc_forward_irq(unsigned int irq);
 
diff --git a/arch/mips/kernel/irq-gic.c b/arch/mips/kernel/irq-gic.c
index 87deb8f..3f43c2e 100644
--- a/arch/mips/kernel/irq-gic.c
+++ b/arch/mips/kernel/irq-gic.c
@@ -155,7 +155,7 @@ static void gic_unmask_irq(unsigned int irq)
 
 static DEFINE_SPINLOCK(gic_lock);
 
-static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+static int gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	cpumask_t	tmp = CPU_MASK_NONE;
 	unsigned long	flags;
@@ -166,7 +166,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 
 	cpumask_and(&tmp, cpumask, cpu_online_mask);
 	if (cpus_empty(tmp))
-		return;
+		return -1;
 
 	/* Assumption : cpumask refers to a single CPU */
 	spin_lock_irqsave(&gic_lock, flags);
@@ -190,6 +190,7 @@ static void gic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	cpumask_copy(irq_desc[irq].affinity, cpumask);
 	spin_unlock_irqrestore(&gic_lock, flags);
 
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/mti-malta/malta-smtc.c b/arch/mips/mti-malta/malta-smtc.c
index 5ba3188..499ffe5 100644
--- a/arch/mips/mti-malta/malta-smtc.c
+++ b/arch/mips/mti-malta/malta-smtc.c
@@ -114,7 +114,7 @@ struct plat_smp_ops msmtc_smp_ops = {
  */
 
 
-void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
+int plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 {
 	cpumask_t tmask;
 	int cpu = 0;
@@ -156,5 +156,7 @@ void plat_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
 
 	/* Do any generic SMTC IRQ affinity setup */
 	smtc_set_irq_affinity(irq, tmask);
+
+	return 0;
 }
 #endif /* CONFIG_MIPS_MT_SMTC_IRQAFF */
diff --git a/arch/mips/sibyte/bcm1480/irq.c b/arch/mips/sibyte/bcm1480/irq.c
index 352352b..4f256a1 100644
--- a/arch/mips/sibyte/bcm1480/irq.c
+++ b/arch/mips/sibyte/bcm1480/irq.c
@@ -50,7 +50,7 @@ static void enable_bcm1480_irq(unsigned int irq);
 static void disable_bcm1480_irq(unsigned int irq);
 static void ack_bcm1480_irq(unsigned int irq);
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask);
 #endif
 
 #ifdef CONFIG_PCI
@@ -109,7 +109,7 @@ void bcm1480_unmask_irq(int cpu, int irq)
 }
 
 #ifdef CONFIG_SMP
-static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	int i = 0, old_cpu, cpu, int_on, k;
 	u64 cur_ints;
@@ -119,7 +119,7 @@ static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	if (cpumask_weight(mask) != 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 	i = cpumask_first(mask);
 
@@ -155,6 +155,8 @@ static void bcm1480_set_affinity(unsigned int irq, const struct cpumask *mask)
 	}
 	spin_unlock(&bcm1480_imr_lock);
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/mips/sibyte/sb1250/irq.c b/arch/mips/sibyte/sb1250/irq.c
index c08ff58..e389507 100644
--- a/arch/mips/sibyte/sb1250/irq.c
+++ b/arch/mips/sibyte/sb1250/irq.c
@@ -50,7 +50,7 @@ static void enable_sb1250_irq(unsigned int irq);
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
@@ -114,7 +114,7 @@ static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	if (cpumask_weight(mask) > 1) {
 		printk("attempted to set irq affinity for irq %d to multiple CPUs\n", irq);
-		return;
+		return -1;
 	}
 
 	/* Convert logical CPU to physical CPU */
@@ -146,6 +146,8 @@ static void sb1250_set_affinity(unsigned int irq, const struct cpumask *mask)
 	}
 	spin_unlock(&sb1250_imr_lock);
 	spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/arch/parisc/kernel/irq.c b/arch/parisc/kernel/irq.c
index 4ea4229..8007f1e 100644
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -130,15 +130,17 @@ int cpu_check_affinity(unsigned int irq, const struct cpumask *dest)
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
 
diff --git a/arch/powerpc/platforms/pseries/xics.c b/arch/powerpc/platforms/pseries/xics.c
index 80b5134..be3581a 100644
--- a/arch/powerpc/platforms/pseries/xics.c
+++ b/arch/powerpc/platforms/pseries/xics.c
@@ -333,7 +333,7 @@ static void xics_eoi_lpar(unsigned int virq)
 	lpar_xirr_info_set((0xff << 24) | irq);
 }
 
-static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
+static int xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 {
 	unsigned int irq;
 	int status;
@@ -342,14 +342,14 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 
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
@@ -363,7 +363,7 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
 		printk(KERN_WARNING
 			"%s: No online cpus in the mask %s for irq %d\n",
 			__func__, cpulist, virq);
-		return;
+		return -1;
 	}
 
 	status = rtas_call(ibm_set_xive, 3, 1, NULL,
@@ -372,8 +372,10 @@ static void xics_set_affinity(unsigned int virq, const struct cpumask *cpumask)
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
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 21b9567..f4cbd15 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -807,7 +807,7 @@ static void mpic_end_ipi(unsigned int irq)
 
 #endif /* CONFIG_SMP */
 
-void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
+int mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
@@ -824,6 +824,8 @@ void mpic_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		mpic_irq_write(src, MPIC_INFO(IRQ_DESTINATION),
 			       mpic_physmask(cpus_addr(tmp)[0]));
 	}
+
+	return 0;
 }
 
 static unsigned int mpic_type_to_vecpri(struct mpic *mpic, unsigned int type)
diff --git a/arch/sparc/kernel/irq_64.c b/arch/sparc/kernel/irq_64.c
index 5deabe9..e5e78f9 100644
--- a/arch/sparc/kernel/irq_64.c
+++ b/arch/sparc/kernel/irq_64.c
@@ -318,10 +318,12 @@ static void sun4u_irq_enable(unsigned int virt_irq)
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
@@ -377,7 +379,7 @@ static void sun4v_irq_enable(unsigned int virt_irq)
 		       ino, err);
 }
 
-static void sun4v_set_affinity(unsigned int virt_irq,
+static int sun4v_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
@@ -388,6 +390,8 @@ static void sun4v_set_affinity(unsigned int virt_irq,
 	if (err != HV_EOK)
 		printk(KERN_ERR "sun4v_intr_settarget(%x,%lu): "
 		       "err(%d)\n", ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_irq_disable(unsigned int virt_irq)
@@ -445,7 +449,7 @@ static void sun4v_virq_enable(unsigned int virt_irq)
 		       dev_handle, dev_ino, err);
 }
 
-static void sun4v_virt_set_affinity(unsigned int virt_irq,
+static int sun4v_virt_set_affinity(unsigned int virt_irq,
 				    const struct cpumask *mask)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
@@ -461,6 +465,8 @@ static void sun4v_virt_set_affinity(unsigned int virt_irq,
 		printk(KERN_ERR "sun4v_vintr_set_target(%lx,%lx,%lu): "
 		       "err(%d)\n",
 		       dev_handle, dev_ino, cpuid, err);
+
+	return 0;
 }
 
 static void sun4v_virq_disable(unsigned int virt_irq)
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9fbf0f7..5c7630b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -574,13 +574,14 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
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
@@ -591,18 +592,21 @@ set_ioapic_affinity_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
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
 #endif /* CONFIG_SMP */
 
@@ -2348,24 +2352,25 @@ static int ioapic_retrigger_irq(unsigned int irq)
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
 
 	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
 
@@ -2381,27 +2386,30 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
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
 
@@ -3318,7 +3326,7 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 }
 
 #ifdef CONFIG_SMP
-static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3327,7 +3335,7 @@ static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3339,13 +3347,15 @@ static void set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
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
@@ -3354,11 +3364,11 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
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
@@ -3375,6 +3385,8 @@ ir_set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	 */
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
+
+	return 0;
 }
 
 #endif
@@ -3528,7 +3540,7 @@ void arch_teardown_msi_irq(unsigned int irq)
 
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
-static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3537,7 +3549,7 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3549,6 +3561,8 @@ static void dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	dmar_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3582,7 +3596,7 @@ int arch_setup_dmar_msi(unsigned int irq)
 #ifdef CONFIG_HPET_TIMER
 
 #ifdef CONFIG_SMP
-static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
+static int hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3591,7 +3605,7 @@ static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 	dest = set_desc_affinity(desc, mask);
 	if (dest == BAD_APICID)
-		return;
+		return -1;
 
 	cfg = desc->chip_data;
 
@@ -3603,6 +3617,8 @@ static void hpet_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 	msg.address_lo |= MSI_ADDR_DEST_ID(dest);
 
 	hpet_msi_write(irq, &msg);
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
@@ -3659,7 +3675,7 @@ static void target_ht_irq(unsigned int irq, unsigned int dest, u8 vector)
 	write_ht_irq_msg(irq, &msg);
 }
 
-static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
+static int set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 	struct irq_cfg *cfg;
@@ -3667,11 +3683,13 @@ static void set_ht_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
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
diff --git a/drivers/parisc/iosapic.c b/drivers/parisc/iosapic.c
index 73348c4..4a9cc92 100644
--- a/drivers/parisc/iosapic.c
+++ b/drivers/parisc/iosapic.c
@@ -702,7 +702,7 @@ static unsigned int iosapic_startup_irq(unsigned int irq)
 }
 
 #ifdef CONFIG_SMP
-static void iosapic_set_affinity_irq(unsigned int irq,
+static int iosapic_set_affinity_irq(unsigned int irq,
 				     const struct cpumask *dest)
 {
 	struct vector_info *vi = iosapic_get_vector(irq);
@@ -712,7 +712,7 @@ static void iosapic_set_affinity_irq(unsigned int irq,
 
 	dest_cpu = cpu_check_affinity(irq, dest);
 	if (dest_cpu < 0)
-		return;
+		return -1;
 
 	cpumask_copy(irq_desc[irq].affinity, cpumask_of(dest_cpu));
 	vi->txn_addr = txn_affinity_addr(irq, dest_cpu);
@@ -724,6 +724,8 @@ static void iosapic_set_affinity_irq(unsigned int irq,
 	iosapic_set_irt_data(vi, &dummy_d0, &d1);
 	iosapic_wr_irt_entry(vi, d0, d1);
 	spin_unlock_irqrestore(&iosapic_lock, flags);
+
+	return 0;
 }
 #endif
 
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 30963af..3338988 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -688,13 +688,13 @@ void rebind_evtchn_irq(int evtchn, int irq)
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
@@ -707,13 +707,15 @@ static void rebind_irq_to_cpu(unsigned irq, unsigned tcpu)
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
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 2a34cd6..8e4c18b 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -117,7 +117,7 @@ struct irq_chip {
 	void		(*eoi)(unsigned int irq);
 
 	void		(*end)(unsigned int irq);
-	void		(*set_affinity)(unsigned int irq,
+	int		(*set_affinity)(unsigned int irq,
 					const struct cpumask *dest);
 	int		(*retrigger)(unsigned int irq);
 	int		(*set_type)(unsigned int irq, unsigned int flow_type);
