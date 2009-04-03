Return-Path: <linux-kernel-owner+w=401wt.eu-S936953AbZDCWkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936953AbZDCWkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 18:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758171AbZDCWj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 18:39:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:42343 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757712AbZDCWjz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 18:39:55 -0400
Message-ID: <49D6900B.2020107@kernel.org>
Date: Fri, 03 Apr 2009 15:39:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 2/2] irq: only update affinity in chip set_affinity()
References: <49D68FBC.7010602@kernel.org>
In-Reply-To: <49D68FBC.7010602@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: keep affinity consistent

irq_set_affinity() and move_masked_irq() try to assign affinity
before calling chip set_affinity(). some archs are assigning again in set_affinity
again.

something like:
cpumask_cpy(desc->affinity, mask);
desc->chip->set_affinity(mask);

in the failing path, affinity should not be touched.

also set_extra_move_desc() ( called by set_affinity)  will rely on the old
affinity to decide if need to move irq_desc to different node when logical
flat apic mode is used.

So try remove those assignment, and make some missed arch to assign affinity
in their set_affinity.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

--
 arch/alpha/kernel/sys_dp264.c         |    6 ++++--
 arch/alpha/kernel/sys_titan.c         |    3 ++-
 arch/arm/common/gic.c                 |    1 +
 arch/cris/arch-v32/kernel/irq.c       |    1 +
 arch/ia64/kernel/iosapic.c            |    3 +++
 arch/ia64/sn/kernel/irq.c             |    3 +++
 arch/mips/cavium-octeon/octeon-irq.c  |    6 ++++++
 arch/mips/sibyte/bcm1480/irq.c        |    2 ++
 arch/mips/sibyte/sb1250/irq.c         |    2 ++
 arch/powerpc/platforms/pseries/xics.c |    5 +++++
 arch/powerpc/sysdev/mpic.c            |    2 ++
 arch/sparc/kernel/irq_64.c            |    7 +++++++
 drivers/xen/events.c                  |    2 ++
 kernel/irq/manage.c                   |    6 ++----
 kernel/irq/migration.c                |    8 +++-----
 15 files changed, 45 insertions(+), 12 deletions(-)

Index: linux-2.6/arch/alpha/kernel/sys_dp264.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_dp264.c
+++ linux-2.6/arch/alpha/kernel/sys_dp264.c
@@ -178,7 +178,8 @@ cpu_set_irq_affinity(unsigned int irq, c
 
 static void
 dp264_set_affinity(unsigned int irq, const struct cpumask *affinity)
-{ 
+{
+	cpumask_copy(irq_desc[irq].affinity, affinity);
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
@@ -187,7 +188,8 @@ dp264_set_affinity(unsigned int irq, con
 
 static void
 clipper_set_affinity(unsigned int irq, const struct cpumask *affinity)
-{ 
+{
+	cpumask_copy(irq_desc[irq].affinity, affinity);
 	spin_lock(&dp264_irq_lock);
 	cpu_set_irq_affinity(irq - 16, *affinity);
 	tsunami_update_irq_hw(cached_irq_mask);
Index: linux-2.6/arch/alpha/kernel/sys_titan.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/sys_titan.c
+++ linux-2.6/arch/alpha/kernel/sys_titan.c
@@ -159,7 +159,8 @@ titan_cpu_set_irq_affinity(unsigned int
 
 static void
 titan_set_irq_affinity(unsigned int irq, const struct cpumask *affinity)
-{ 
+{
+	cpumask_copy(irq_desc[irq].affinity, affinity);
 	spin_lock(&titan_irq_lock);
 	titan_cpu_set_irq_affinity(irq - 16, *affinity);
 	titan_update_irq_hw(titan_cached_irq_mask);
Index: linux-2.6/arch/arm/common/gic.c
===================================================================
--- linux-2.6.orig/arch/arm/common/gic.c
+++ linux-2.6/arch/arm/common/gic.c
@@ -118,6 +118,7 @@ static void gic_set_cpu(unsigned int irq
 
 	spin_lock(&irq_controller_lock);
 	irq_desc[irq].cpu = cpu;
+	cpumask_copy(irq_desc[irq].affinity, mask_val);
 	val = readl(reg) & ~(0xff << shift);
 	val |= 1 << (cpu + shift);
 	writel(val, reg);
Index: linux-2.6/arch/cris/arch-v32/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/irq.c
+++ linux-2.6/arch/cris/arch-v32/kernel/irq.c
@@ -330,6 +330,7 @@ void set_affinity_crisv32_irq(unsigned i
 	unsigned long flags;
 	spin_lock_irqsave(&irq_lock, flags);
 	irq_allocations[irq - FIRST_IRQ].mask = *dest;
+	cpumask_copy(irq_desc[j].affinity, dest);
 	spin_unlock_irqrestore(&irq_lock, flags);
 }
 
Index: linux-2.6/arch/ia64/kernel/iosapic.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/iosapic.c
+++ linux-2.6/arch/ia64/kernel/iosapic.c
@@ -338,6 +338,7 @@ iosapic_set_affinity(unsigned int irq, c
 	int redir = (irq & IA64_IRQ_REDIRECTED) ? 1 : 0;
 	struct iosapic_rte_info *rte;
 	struct iosapic *iosapic;
+	irq_desc_t *idesc = irq_desc + irq;
 
 	irq &= (~IA64_IRQ_REDIRECTED);
 
@@ -353,6 +354,8 @@ iosapic_set_affinity(unsigned int irq, c
 	if (!iosapic_intr_info[irq].count)
 		return;			/* not an IOSAPIC interrupt */
 
+	cpumask_copy(desc->affinity, mask);
+
 	set_irq_affinity_info(irq, dest, redir);
 
 	/* dest contains both id and eid */
Index: linux-2.6/arch/ia64/sn/kernel/irq.c
===================================================================
--- linux-2.6.orig/arch/ia64/sn/kernel/irq.c
+++ linux-2.6/arch/ia64/sn/kernel/irq.c
@@ -232,6 +232,9 @@ static void sn_set_affinity_irq(unsigned
 	struct sn_irq_info *sn_irq_info, *sn_irq_info_safe;
 	nasid_t nasid;
 	int slice;
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	cpumask_copy(desc->affinity, mask);
 
 	nasid = cpuid_to_nasid(cpumask_first(mask));
 	slice = cpuid_to_slice(cpumask_first(mask));
Index: linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
===================================================================
--- linux-2.6.orig/arch/mips/cavium-octeon/octeon-irq.c
+++ linux-2.6/arch/mips/cavium-octeon/octeon-irq.c
@@ -181,6 +181,9 @@ static void octeon_irq_ciu0_set_affinity
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WORKQ0;	/* Bit 0-63 of EN0 */
+	irq_desc_t *desc = irq_desc + irq;
+
+	cpumask_copy(desc->affinity, dest);
 
 	write_lock(&octeon_irq_ciu0_rwlock);
 	for_each_online_cpu(cpu) {
@@ -296,6 +299,9 @@ static void octeon_irq_ciu1_set_affinity
 {
 	int cpu;
 	int bit = irq - OCTEON_IRQ_WDOG0;	/* Bit 0-63 of EN1 */
+	irq_desc_t *desc = irq_desc + irq;
+
+	cpumask_copy(desc->affinity, dest);
 
 	write_lock(&octeon_irq_ciu1_rwlock);
 	for_each_online_cpu(cpu) {
Index: linux-2.6/arch/mips/sibyte/bcm1480/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/bcm1480/irq.c
+++ linux-2.6/arch/mips/sibyte/bcm1480/irq.c
@@ -123,6 +123,8 @@ static void bcm1480_set_affinity(unsigne
 	}
 	i = cpumask_first(mask);
 
+	cpumask_copy(desc->affinity, mask);
+
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
 
Index: linux-2.6/arch/mips/sibyte/sb1250/irq.c
===================================================================
--- linux-2.6.orig/arch/mips/sibyte/sb1250/irq.c
+++ linux-2.6/arch/mips/sibyte/sb1250/irq.c
@@ -117,6 +117,8 @@ static void sb1250_set_affinity(unsigned
 		return;
 	}
 
+	cpumask_copy(desc->affinity, mask);
+
 	/* Convert logical CPU to physical CPU */
 	cpu = cpu_logical_map(i);
 
Index: linux-2.6/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6/arch/powerpc/platforms/pseries/xics.c
@@ -339,6 +339,7 @@ static void xics_set_affinity(unsigned i
 	int status;
 	int xics_status[2];
 	int irq_server;
+	struct irq_desc *desc;
 
 	irq = (unsigned int)irq_map[virq].hwirq;
 	if (irq == XICS_IPI || irq == XICS_IRQ_SPURIOUS)
@@ -374,6 +375,10 @@ static void xics_set_affinity(unsigned i
 			__func__, irq, status);
 		return;
 	}
+
+	desc = get_irq_desc(virq);
+
+	cpumask_copy(desc->affinity, cpumask);
 }
 
 static struct irq_chip xics_pic_direct = {
Index: linux-2.6/arch/powerpc/sysdev/mpic.c
===================================================================
--- linux-2.6.orig/arch/powerpc/sysdev/mpic.c
+++ linux-2.6/arch/powerpc/sysdev/mpic.c
@@ -811,7 +811,9 @@ void mpic_set_affinity(unsigned int irq,
 {
 	struct mpic *mpic = mpic_from_irq(irq);
 	unsigned int src = mpic_irq_to_hw(irq);
+	struct irq_desc *desc = get_irq_desc(irq);
 
+	cpumask_copy(desc->affinity, cpumask);
 	if (mpic->flags & MPIC_SINGLE_DEST_CPU) {
 		int cpuid = irq_choose_cpu(irq);
 
Index: linux-2.6/arch/sparc/kernel/irq_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/irq_64.c
+++ linux-2.6/arch/sparc/kernel/irq_64.c
@@ -321,6 +321,9 @@ static void sun4u_irq_enable(unsigned in
 static void sun4u_set_affinity(unsigned int virt_irq,
 			       const struct cpumask *mask)
 {
+	struct irq_desc *desc = irq_desc + virt_irq;
+
+	cpumask_copy(desc->affinity, mask);
 	sun4u_irq_enable(virt_irq);
 }
 
@@ -382,8 +385,10 @@ static void sun4v_set_affinity(unsigned
 {
 	unsigned int ino = virt_irq_table[virt_irq].dev_ino;
 	unsigned long cpuid = irq_choose_cpu(virt_irq);
+	struct irq_desc *desc = irq_desc + virt_irq;
 	int err;
 
+	cpumask_copy(desc->affinity, mask);
 	err = sun4v_intr_settarget(ino, cpuid);
 	if (err != HV_EOK)
 		printk(KERN_ERR "sun4v_intr_settarget(%x,%lu): "
@@ -449,8 +454,10 @@ static void sun4v_virt_set_affinity(unsi
 				    const struct cpumask *mask)
 {
 	unsigned long cpuid, dev_handle, dev_ino;
+	struct irq_desc *desc = irq_desc + virt_irq;
 	int err;
 
+	cpumask_copy(desc->affinity, mask);
 	cpuid = irq_choose_cpu(virt_irq);
 
 	dev_handle = virt_irq_table[virt_irq].dev_handle;
Index: linux-2.6/drivers/xen/events.c
===================================================================
--- linux-2.6.orig/drivers/xen/events.c
+++ linux-2.6/drivers/xen/events.c
@@ -713,6 +713,8 @@ static void rebind_irq_to_cpu(unsigned i
 static void set_affinity_irq(unsigned irq, const struct cpumask *dest)
 {
 	unsigned tcpu = cpumask_first(dest);
+
+	cpumask_copy(irq_to_desc(irq)->affinity, mask);
 	rebind_irq_to_cpu(irq, tcpu);
 }
 
Index: linux-2.6/kernel/irq/manage.c
===================================================================
--- linux-2.6.orig/kernel/irq/manage.c
+++ linux-2.6/kernel/irq/manage.c
@@ -109,15 +109,13 @@ int irq_set_affinity(unsigned int irq, c
 	spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
-	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
-		cpumask_copy(desc->affinity, cpumask);
+	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED)
 		desc->chip->set_affinity(irq, cpumask);
-	} else {
+	else {
 		desc->status |= IRQ_MOVE_PENDING;
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	cpumask_copy(desc->affinity, cpumask);
 	desc->chip->set_affinity(irq, cpumask);
 #endif
 	irq_set_thread_affinity(desc, cpumask);
Index: linux-2.6/kernel/irq/migration.c
===================================================================
--- linux-2.6.orig/kernel/irq/migration.c
+++ linux-2.6/kernel/irq/migration.c
@@ -39,11 +39,9 @@ void move_masked_irq(int irq)
 	 * masking the irqs.
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
-		   < nr_cpu_ids)) {
-		cpumask_and(desc->affinity,
-			    desc->pending_mask, cpu_online_mask);
-		desc->chip->set_affinity(irq, desc->affinity);
-	}
+		   < nr_cpu_ids))
+		desc->chip->set_affinity(irq, desc->pending_mask);
+
 	cpumask_clear(desc->pending_mask);
 }
 
