Return-Path: <linux-kernel-owner+w=401wt.eu-S1755111AbZKTVLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111AbZKTVLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 16:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbZKTVLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 16:11:36 -0500
Received: from relay1.sgi.com ([192.48.179.29]:42593 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754173AbZKTVLf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 16:11:35 -0500
Date: Fri, 20 Nov 2009 15:11:39 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v6] x86/apic: limit irq affinity
Message-ID: <20091120211139.GB19106@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows for hard numa restrictions to irq affinity on x86 systems.

Affinity is masked to allow only those cpus which the subarchitecture
deems accessible by the given irq.

On some UV systems, this domain will be limited to the nodes accessible
to the irq's node.  Initially other X86 systems will not mask off any cpus
so non-UV systems will remain unaffected.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Added apic functions for getting numa irq cpumasks.  Systems other than
UV now simply return the mask passed in. Added irq_desc_node for
uniprocessor compatibility.

 arch/x86/Kconfig                      |    1 
 arch/x86/include/asm/apic.h           |   13 +++
 arch/x86/include/asm/uv/uv_irq.h      |    3 
 arch/x86/include/asm/uv/uv_mmrs.h     |   25 +++++++
 arch/x86/kernel/apic/apic_flat_64.c   |    4 +
 arch/x86/kernel/apic/apic_noop.c      |    2 
 arch/x86/kernel/apic/bigsmp_32.c      |    2 
 arch/x86/kernel/apic/es7000_32.c      |    4 +
 arch/x86/kernel/apic/io_apic.c        |  102 +++++++++++++++++++++++-------
 arch/x86/kernel/apic/numaq_32.c       |    2 
 arch/x86/kernel/apic/probe_32.c       |    2 
 arch/x86/kernel/apic/summit_32.c      |    2 
 arch/x86/kernel/apic/x2apic_cluster.c |    2 
 arch/x86/kernel/apic/x2apic_phys.c    |    2 
 arch/x86/kernel/apic/x2apic_uv_x.c    |    4 +
 arch/x86/kernel/uv_irq.c              |   66 +++++++++++++++++++
 16 files changed, 214 insertions(+), 22 deletions(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/io_apic.c	2009-11-20 14:57:28.000000000 -0600
@@ -352,6 +352,18 @@ struct irq_cfg *irq_cfg(unsigned int irq
 
 #endif
 
+#ifdef CONFIG_SMP
+static int irq_desc_node(struct irq_desc *desc)
+{
+	return desc->node;
+}
+#else
+static int irq_desc_node(struct irq_desc *desc)
+{
+	return 0;
+}
+#endif
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -1427,6 +1439,7 @@ static void setup_IO_APIC_irq(int apic_i
 {
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
+	struct cpumask *tmp_mask;
 	unsigned int dest;
 
 	if (!IO_APIC_IRQ(irq))
@@ -1434,10 +1447,15 @@ static void setup_IO_APIC_irq(int apic_i
 
 	cfg = desc->chip_data;
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	tmp_mask = apic->get_restricted_mask(apic->target_cpus(),
+						irq_desc_node(desc));
+	if (!tmp_mask)
 		return;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1451,7 +1469,7 @@ static void setup_IO_APIC_irq(int apic_i
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
-		return;
+		goto error;
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
@@ -1459,6 +1477,8 @@ static void setup_IO_APIC_irq(int apic_i
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
+error:
+	apic->free_restricted_mask(tmp_mask);
 }
 
 static struct {
@@ -2278,18 +2298,30 @@ set_desc_affinity(struct irq_desc *desc,
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
+	tmp_mask = apic->get_restricted_mask(mask, irq_desc_node(desc));
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
@@ -2345,22 +2377,29 @@ migrate_ioapic_irq_desc(struct irq_desc 
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
+	struct cpumask *tmp_mask;
 	unsigned int dest;
 	unsigned int irq;
 	int ret = -1;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	tmp_mask = apic->get_restricted_mask(mask, irq_desc_node(desc));
+	if (!tmp_mask)
 		return ret;
 
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask))
+		goto error;
+
 	irq = desc->irq;
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
@@ -2373,9 +2412,10 @@ migrate_ioapic_irq_desc(struct irq_desc 
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
@@ -3244,18 +3284,27 @@ static int msi_compose_msg(struct pci_de
 			   struct msi_msg *msg, u8 hpet_id)
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
+	tmp_mask = apic->get_restricted_mask(apic->target_cpus(),
+						irq_desc_node(desc));
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
@@ -3313,6 +3362,8 @@ static int msi_compose_msg(struct pci_de
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
 	}
+error:
+	apic->free_restricted_mask(tmp_mask);
 	return err;
 }
 
@@ -3730,19 +3781,25 @@ static struct irq_chip ht_irq_chip = {
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
 
@@ -3766,6 +3823,7 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
+	apic->free_restricted_mask(tmp_mask);
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2009-11-20 13:25:39.000000000 -0600
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
Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/Kconfig	2009-11-20 14:57:26.000000000 -0600
@@ -365,6 +365,7 @@ config X86_UV
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
 	depends on X86_X2APIC
+	depends on NUMA_IRQ_DESC
 	---help---
 	  This option is needed in order to support SGI Ultraviolet systems.
 	  If you don't have one of these, you should say N here.
Index: linux/arch/x86/kernel/uv_irq.c
===================================================================
--- linux.orig/arch/x86/kernel/uv_irq.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/uv_irq.c	2009-11-20 14:38:32.000000000 -0600
@@ -242,6 +242,72 @@ static int uv_set_irq_affinity(unsigned 
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
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-11-20 14:57:27.000000000 -0600
@@ -23,6 +23,7 @@
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_irq.h>
 #include <asm/current.h>
 #include <asm/pgtable.h>
 #include <asm/uv/bios.h>
@@ -264,6 +265,8 @@ struct apic __refdata apic_x2apic_uv_x =
 	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= uv_target_cpus,
+	.get_restricted_mask		= uv_get_restricted_mask,
+	.free_restricted_mask		= uv_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
@@ -659,5 +662,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	arch_init_uv_cfg_cpus_allowed();
 	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/include/asm/uv/uv_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_irq.h	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_irq.h	2009-11-20 13:25:39.000000000 -0600
@@ -31,6 +31,9 @@ enum {
 	UV_AFFINITY_CPU
 };
 
+extern struct cpumask *uv_get_restricted_mask(const struct cpumask *, int);
+extern void uv_free_restricted_mask(struct cpumask *);
+extern void arch_init_uv_cfg_cpus_allowed(void);
 extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
 extern int uv_setup_irq(char *, int, int, unsigned long, int);
 extern void uv_teardown_irq(unsigned int);
Index: linux/arch/x86/include/asm/apic.h
===================================================================
--- linux.orig/arch/x86/include/asm/apic.h	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/include/asm/apic.h	2009-11-20 13:25:39.000000000 -0600
@@ -293,6 +293,9 @@ struct apic {
 	u32 irq_dest_mode;
 
 	const struct cpumask *(*target_cpus)(void);
+	struct cpumask *(*get_restricted_mask)(const struct cpumask *mask,
+					       int node);
+	void (*free_restricted_mask)(struct cpumask *mask);
 
 	int disable_esr;
 
@@ -474,6 +477,16 @@ static inline const struct cpumask *defa
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
 
 
Index: linux/arch/x86/kernel/apic/apic_flat_64.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/apic_flat_64.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/apic_flat_64.c	2009-11-20 13:25:39.000000000 -0600
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
Index: linux/arch/x86/kernel/apic/apic_noop.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/apic_noop.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/apic_noop.c	2009-11-20 13:25:39.000000000 -0600
@@ -142,6 +142,8 @@ struct apic apic_noop = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= noop_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= noop_check_apicid_used,
Index: linux/arch/x86/kernel/apic/bigsmp_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/bigsmp_32.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/bigsmp_32.c	2009-11-20 13:25:39.000000000 -0600
@@ -211,6 +211,8 @@ struct apic apic_bigsmp = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= bigsmp_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= bigsmp_check_apicid_used,
Index: linux/arch/x86/kernel/apic/es7000_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/es7000_32.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/es7000_32.c	2009-11-20 13:25:39.000000000 -0600
@@ -661,6 +661,8 @@ struct apic __refdata apic_es7000_cluste
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= target_cpus_cluster,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= es7000_check_apicid_used,
@@ -726,6 +728,8 @@ struct apic __refdata apic_es7000 = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= es7000_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= 0,
 	.check_apicid_used		= es7000_check_apicid_used,
Index: linux/arch/x86/kernel/apic/numaq_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/numaq_32.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/numaq_32.c	2009-11-20 13:25:39.000000000 -0600
@@ -500,6 +500,8 @@ struct apic __refdata apic_numaq = {
 	.irq_dest_mode			= 0,
 
 	.target_cpus			= numaq_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= numaq_check_apicid_used,
Index: linux/arch/x86/kernel/apic/probe_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/probe_32.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/probe_32.c	2009-11-20 13:25:39.000000000 -0600
@@ -94,6 +94,8 @@ struct apic apic_default = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= default_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= default_check_apicid_used,
Index: linux/arch/x86/kernel/apic/summit_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/summit_32.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/summit_32.c	2009-11-20 13:25:39.000000000 -0600
@@ -517,6 +517,8 @@ struct apic apic_summit = {
 	.irq_dest_mode			= 1,
 
 	.target_cpus			= summit_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 1,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= summit_check_apicid_used,
Index: linux/arch/x86/kernel/apic/x2apic_cluster.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_cluster.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_cluster.c	2009-11-20 13:25:39.000000000 -0600
@@ -198,6 +198,8 @@ struct apic apic_x2apic_cluster = {
 	.irq_dest_mode			= 1, /* logical */
 
 	.target_cpus			= x2apic_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= APIC_DEST_LOGICAL,
 	.check_apicid_used		= NULL,
Index: linux/arch/x86/kernel/apic/x2apic_phys.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_phys.c	2009-11-20 13:25:30.000000000 -0600
+++ linux/arch/x86/kernel/apic/x2apic_phys.c	2009-11-20 13:25:39.000000000 -0600
@@ -187,6 +187,8 @@ struct apic apic_x2apic_phys = {
 	.irq_dest_mode			= 0, /* physical */
 
 	.target_cpus			= x2apic_target_cpus,
+	.get_restricted_mask		= default_get_restricted_mask,
+	.free_restricted_mask		= default_free_restricted_mask,
 	.disable_esr			= 0,
 	.dest_logical			= 0,
 	.check_apicid_used		= NULL,
