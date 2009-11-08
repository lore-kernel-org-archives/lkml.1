Return-Path: <linux-kernel-owner+w=401wt.eu-S1753580AbZKHNIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753580AbZKHNIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 08:08:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZKHNIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 08:08:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:59211 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZKHNIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 08:08:31 -0500
Date: Sun, 8 Nov 2009 13:07:56 GMT
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20091021011233.GB32196@sgi.com>
References: <20091021011233.GB32196@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Limit irq affinity
Message-ID: <tip-683c91f85d7a3e1092d7fa3ec5687af8cd379f02@git.kernel.org>
Git-Commit-ID: 683c91f85d7a3e1092d7fa3ec5687af8cd379f02
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  683c91f85d7a3e1092d7fa3ec5687af8cd379f02
Gitweb:     http://git.kernel.org/tip/683c91f85d7a3e1092d7fa3ec5687af8cd379f02
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Tue, 3 Nov 2009 12:40:37 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 8 Nov 2009 13:30:40 +0100

x86/apic: Limit irq affinity

This patch allows for hard numa restrictions to irq affinity on
x86 systems.

Affinity is masked to allow only those cpus which the
subarchitecture deems accessible by the given irq.

On some UV systems, this domain will be limited to the nodes
accessible to the irq's node.  Initially other X86 systems will
not mask off any cpus so non-UV systems will remain unaffected.

Added apic functions for getting numa irq cpumasks.  Systems other
than UV now simply return the mask passed in.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20091021011233.GB32196@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/include/asm/apic.h           |   13 +++++
 arch/x86/include/asm/uv/uv_irq.h      |    3 +
 arch/x86/include/asm/uv/uv_mmrs.h     |   25 +++++++++
 arch/x86/kernel/apic/apic_flat_64.c   |    4 ++
 arch/x86/kernel/apic/apic_noop.c      |    2 +
 arch/x86/kernel/apic/bigsmp_32.c      |    2 +
 arch/x86/kernel/apic/es7000_32.c      |    4 ++
 arch/x86/kernel/apic/io_apic.c        |   91 ++++++++++++++++++++++++--------
 arch/x86/kernel/apic/numaq_32.c       |    2 +
 arch/x86/kernel/apic/probe_32.c       |    2 +
 arch/x86/kernel/apic/summit_32.c      |    2 +
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +
 arch/x86/kernel/apic/x2apic_phys.c    |    2 +
 arch/x86/kernel/apic/x2apic_uv_x.c    |    6 ++-
 arch/x86/kernel/uv_irq.c              |   66 ++++++++++++++++++++++++
 16 files changed, 203 insertions(+), 24 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c876bac..93decdd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -363,6 +363,7 @@ config X86_UV
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
 	depends on X86_X2APIC
+	depends on NUMA_IRQ_DESC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 08a5f42..b7336ac 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -293,6 +293,9 @@ struct apic {
 	u32 irq_dest_mode;
 
 	const struct cpumask *(*target_cpus)(void);
+	struct cpumask *(*get_restricted_mask)(const struct cpumask *mask,
+					       int node);
+	void (*free_restricted_mask)(struct cpumask *mask);
 
 	int disable_esr;
 
@@ -474,6 +477,16 @@ static inline const struct cpumask *default_target_cpus(void)
 #endif
 }
 
+static inline struct cpumask *
+default_get_restricted_mask(const struct cpumask *mask, int node)
+{
+	return (struct cpumask *)mask;
+}
+
+static inline void default_free_restricted_mask(struct cpumask *mask)
+{
+}
+
 DECLARE_EARLY_PER_CPU(u16, x86_bios_cpu_apicid);
 
 
diff --git a/arch/x86/include/asm/uv/uv_irq.h b/arch/x86/include/asm/uv/uv_irq.h
index d6b17c7..af1b281 100644
--- a/arch/x86/include/asm/uv/uv_irq.h
+++ b/arch/x86/include/asm/uv/uv_irq.h
@@ -31,6 +31,9 @@ enum {
 	UV_AFFINITY_CPU
 };
 
+extern struct cpumask *uv_get_restricted_mask(const struct cpumask *, int);
+extern void uv_free_restricted_mask(struct cpumask *);
+extern void arch_init_uv_cfg_cpus_allowed(void);
 extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
 extern int uv_setup_irq(char *, int, int, unsigned long, int);
 extern void uv_teardown_irq(unsigned int);
diff --git a/arch/x86/include/asm/uv/uv_mmrs.h b/arch/x86/include/asm/uv/uv_mmrs.h
index 2cae46c..6b79c96 100644
--- a/arch/x86/include/asm/uv/uv_mmrs.h
+++ b/arch/x86/include/asm/uv/uv_mmrs.h
@@ -823,6 +823,31 @@ union uvh_lb_mcast_aoerr0_rpt_enable_u {
 };
 
 /* ========================================================================= */
+/*                     UVH_LB_SOCKET_DESTINATION_TABLE                       */
+/* ========================================================================= */
+#define UVH_LB_SOCKET_DESTINATION_TABLE 0x321000UL
+#define UVH_LB_SOCKET_DESTINATION_TABLE_32 0x1800
+#define UVH_LB_SOCKET_DESTINATION_TABLE_DEPTH 128
+
+#define UVH_LB_SOCKET_DESTINATION_TABLE_NODE_ID_SHFT 1
+#define UVH_LB_SOCKET_DESTINATION_TABLE_NODE_ID_MASK 0x0000000000007ffeUL
+#define UVH_LB_SOCKET_DESTINATION_TABLE_CHIP_ID_SHFT 15
+#define UVH_LB_SOCKET_DESTINATION_TABLE_CHIP_ID_MASK 0x0000000000008000UL
+#define UVH_LB_SOCKET_DESTINATION_TABLE_PARITY_SHFT 16
+#define UVH_LB_SOCKET_DESTINATION_TABLE_PARITY_MASK 0x0000000000010000UL
+
+union uvh_lb_socket_destination_table_u {
+    unsigned long	v;
+    struct uvh_lb_socket_destination_table_s {
+	unsigned long	rsvd_0  :  1;  /*    */
+	unsigned long	node_id : 14;  /* RW */
+	unsigned long	chip_id :  1;  /* RW */
+	unsigned long	parity  :  1;  /* RW */
+	unsigned long	rsvd_17_63: 47;  /*    */
+    } s;
+};
+
+/* ========================================================================= */
 /*                          UVH_LOCAL_INT0_CONFIG                            */
 /* ========================================================================= */
 #define UVH_LOCAL_INT0_CONFIG 0x61000UL
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index d0c99ab..a817e7b 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -174,6 +174,8 @@ struct apic apic_flat =  {
 	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= flat_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
@@ -323,6 +325,8 @@ struct apic apic_physflat =  {
 	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= physflat_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/apic_noop.c b/arch/x86/kernel/apic/apic_noop.c
index 9ab6ffb..1b8a4a1 100644
--- a/arch/x86/kernel/apic/apic_noop.c
+++ b/arch/x86/kernel/apic/apic_noop.c
@@ -147,6 +147,8 @@ struct apic apic_noop = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= noop_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= noop_check_apicid_used,
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index 77a0641..46aaed4 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -216,6 +216,8 @@ struct apic apic_bigsmp = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= bigsmp_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 89174f8..321c655 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -665,6 +665,8 @@ struct apic __refdata apic_es7000_cluster = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= target_cpus_cluster,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= es7000_check_apicid_used,
@@ -730,6 +732,8 @@ struct apic __refdata apic_es7000 = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= es7000_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= es7000_check_apicid_used,
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 31e9db3..e347709 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1427,6 +1427,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
+	struct cpumask *tmp_mask;
 	unsigned int dest;
 
 	if (!IO_APIC_IRQ(irq))
@@ -1434,10 +1435,14 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 
 	cfg = desc->chip_data;
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	tmp_mask = apic->get_restricted_mask(apic->target_cpus(), desc->node);
+	if (!tmp_mask)
 		return;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1451,7 +1456,7 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
-		return;
+		goto error;
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
@@ -1459,6 +1464,8 @@ static void setup_IO_APIC_irq(int apic_id, int pin, unsigned int irq, struct irq
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
+error:
+	apic->free_restricted_mask(tmp_mask);
 }
 
 static struct {
@@ -2278,18 +2285,30 @@ set_desc_affinity(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	unsigned int irq;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
+	struct cpumask *tmp_mask;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+
+	tmp_mask = apic->get_restricted_mask(mask, desc->node);
+	if (!tmp_mask)
 		return BAD_APICID;
 
-	cpumask_copy(desc->affinity, mask);
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask))
+		goto error;
+
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	cpumask_copy(desc->affinity, tmp_mask);
+
+	apic->free_restricted_mask(tmp_mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+
+error:
+	apic->free_restricted_mask(tmp_mask);
+	return BAD_APICID;
 }
 
 static int
@@ -2345,22 +2364,30 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
+	struct cpumask *tmp_mask;
 	unsigned int dest;
 	unsigned int irq;
 	int ret = -1;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	irq = desc->irq;
+
+	tmp_mask = apic->get_restricted_mask(mask, desc->node);
+	if (!tmp_mask)
 		return ret;
 
-	irq = desc->irq;
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask))
+		goto error;
+
 	if (get_irte(irq, &irte))
-		return ret;
+		goto error;
 
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
-		return ret;
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	ret = 0;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, mask);
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	irte.vector = cfg->vector;
 	irte.dest_id = IRTE_DEST(dest);
@@ -2373,9 +2400,10 @@ migrate_ioapic_irq_desc(struct irq_desc *desc, const struct cpumask *mask)
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(desc->affinity, mask);
-
-	return 0;
+	cpumask_copy(desc->affinity, tmp_mask);
+error:
+	apic->free_restricted_mask(tmp_mask);
+	return ret;
 }
 
 /*
@@ -3243,18 +3271,26 @@ void destroy_irq(unsigned int irq)
 static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	int err;
 	unsigned dest;
+	struct cpumask *tmp_mask;
 
 	if (disable_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	desc = irq_to_desc(irq);
+
+	tmp_mask = apic->get_restricted_mask(apic->target_cpus(), desc->node);
+	if (!tmp_mask)
+		return -ENOMEM;
+
+	err = assign_irq_vector(irq, cfg, tmp_mask);
 	if (err)
-		return err;
+		goto error;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	if (irq_remapped(irq)) {
 		struct irte irte;
@@ -3309,6 +3345,8 @@ static int msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_ms
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
 	}
+error:
+	apic->free_restricted_mask(tmp_mask);
 	return err;
 }
 
@@ -3697,19 +3735,25 @@ static struct irq_chip ht_irq_chip = {
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
 	struct irq_cfg *cfg;
+	struct cpumask *tmp_mask;
 	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+
+	tmp_mask = apic->get_restricted_mask(apic->target_cpus(),
+						dev_to_node(&dev->dev));
+	if (!tmp_mask)
+		return -ENOMEM;
+
+	err = assign_irq_vector(irq, cfg, tmp_mask);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		dest = apic->cpu_mask_to_apicid_and(cfg->domain,
-						    apic->target_cpus());
+		dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3733,6 +3777,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 
 		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
+	apic->free_restricted_mask(tmp_mask);
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index efa00e2..d46f4b5 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -501,6 +501,8 @@ struct apic __refdata apic_numaq = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= numaq_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= numaq_check_apicid_used,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 0c0182c..22b6716 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -94,6 +94,8 @@ struct apic apic_default = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= default_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= default_check_apicid_used,
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 645ecc4..8d43a00 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -517,6 +517,8 @@ struct apic apic_summit = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= summit_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= summit_check_apicid_used,
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index a5371ec..d8cab82 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -198,6 +198,8 @@ struct apic apic_x2apic_cluster = {
 	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= x2apic_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index a8989aa..4e64e84 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -187,6 +187,8 @@ struct apic apic_x2apic_phys = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= x2apic_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index f5f5886..c1da399 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -23,6 +23,7 @@
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_irq.h>
 #include <asm/current.h>
 #include <asm/pgtable.h>
 #include <asm/uv/bios.h>
@@ -96,7 +97,7 @@ EXPORT_SYMBOL(sn_rtc_cycles_per_second);
 
 static const struct cpumask *uv_target_cpus(void)
 {
-	return cpumask_of(0);
+	return cpu_online_mask;
 }
 
 static void uv_vector_allocation_domain(int cpu, struct cpumask *retmask)
@@ -264,6 +265,8 @@ struct apic __refdata apic_x2apic_uv_x = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= uv_target_cpus,
+	.get_restricted_mask		= uv_get_restricted_mask,
+	.free_restricted_mask		= uv_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
@@ -658,5 +661,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	arch_init_uv_cfg_cpus_allowed();
 	proc_mkdir("sgi_uv", NULL);
 }
diff --git a/arch/x86/kernel/uv_irq.c b/arch/x86/kernel/uv_irq.c
index 61d805d..b81273c 100644
--- a/arch/x86/kernel/uv_irq.c
+++ b/arch/x86/kernel/uv_irq.c
@@ -242,6 +242,72 @@ static int uv_set_irq_affinity(unsigned int irq, const struct cpumask *mask)
 	return 0;
 }
 
+static cpumask_var_t *uv_irq_cpus_allowed;
+
+struct cpumask *uv_get_restricted_mask(const struct cpumask *mask, int node)
+{
+	cpumask_var_t tmp_mask;
+	int bid;
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return NULL;
+
+	if (!uv_irq_cpus_allowed || node < 0) {
+		cpumask_copy(tmp_mask, mask);
+		return tmp_mask;
+	}
+
+	bid = uv_node_to_blade_id(node);
+
+	cpumask_and(tmp_mask, mask, uv_irq_cpus_allowed[bid]);
+
+	return tmp_mask;
+}
+
+void uv_free_restricted_mask(struct cpumask *mask)
+{
+	free_cpumask_var(mask);
+}
+
+void arch_init_uv_cfg_cpus_allowed(void)
+{
+	int bid;
+
+	uv_irq_cpus_allowed = kzalloc(uv_num_possible_blades() *
+			sizeof(cpumask_var_t *), GFP_KERNEL);
+
+	if (uv_irq_cpus_allowed == NULL) {
+		printk(KERN_EMERG "Out of memory");
+		return;
+	}
+
+	for_each_possible_blade(bid) {
+		unsigned long *pa;
+		int i;
+
+		if (!zalloc_cpumask_var_node(&uv_irq_cpus_allowed[bid],
+				GFP_KERNEL, uv_blade_to_memory_nid(bid))) {
+			printk(KERN_EMERG "Out of memory on blade %d", bid);
+			return;
+		}
+
+		pa = uv_global_mmr64_address(uv_blade_to_pnode(bid),
+			UVH_LB_SOCKET_DESTINATION_TABLE);
+
+		for (i = 0; i < UVH_LB_SOCKET_DESTINATION_TABLE_DEPTH; pa++,
+				i++) {
+			int cpu;
+			int pnode = UV_NASID_TO_PNODE(*pa &
+				UVH_LB_SOCKET_DESTINATION_TABLE_NODE_ID_MASK);
+
+			for_each_possible_cpu(cpu)
+				if (uv_cpu_to_pnode(cpu) == pnode)
+					cpumask_set_cpu(cpu,
+						uv_irq_cpus_allowed[bid]);
+		}
+	}
+}
+
 /*
  * Set up a mapping of an available irq and vector, and enable the specified
  * MMR that defines the MSI that is to be sent to the specified CPU when an
