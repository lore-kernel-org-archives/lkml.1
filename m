Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbZJUBNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbZJUBNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 21:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZJUBNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 21:13:43 -0400
Received: from relay1.sgi.com ([192.48.179.29]:53006 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752025AbZJUBNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 21:13:41 -0400
Date: Tue, 20 Oct 2009 20:12:33 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v4] x86/apic: limit irq affinity
Message-ID: <20091021011233.GB32196@sgi.com>
References: <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu> <20091015011339.GA17374@sgi.com> <4AD6B364.2050801@kernel.org> <20091015135039.GA24455@sgi.com> <20091020125649.GA25066@sgi.com> <20091020133810.GA26088@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091020133810.GA26088@sgi.com>
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

Removed allowed cpumask and node from irq_cfg.  Storing allowed cpumasks in UV
specific IRQ code.

 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/hw_irq.h      |    2 
 arch/x86/include/asm/uv/uv_irq.h   |    1 
 arch/x86/include/asm/uv/uv_mmrs.h  |   25 +++++++
 arch/x86/kernel/apic/io_apic.c     |  117 ++++++++++++++++++++++++++-------
 arch/x86/kernel/apic/x2apic_uv_x.c |    4 -
 arch/x86/kernel/uv_irq.c           |   58 ++++++++++++++++
 7 files changed, 184 insertions(+), 24 deletions(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2009-10-20 20:03:14.000000000 -0500
@@ -168,6 +168,17 @@ void __init io_apic_disable_legacy(void)
 	nr_irqs_gsi = 0;
 }
 
+static int default_irq_allowed_and(int node, struct cpumask *dstp,
+						const struct cpumask *srcp)
+{
+	cpumask_copy(dstp, srcp);
+
+	return 1;
+}
+
+int (*x86_irq_allowed_and)(int, struct cpumask *, const struct cpumask *) =
+			default_irq_allowed_and;
+
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -1428,16 +1439,23 @@ static void setup_IO_APIC_irq(int apic_i
 	struct irq_cfg *cfg;
 	struct IO_APIC_route_entry entry;
 	unsigned int dest;
+	cpumask_var_t tmp_mask;
 
 	if (!IO_APIC_IRQ(irq))
 		return;
 
 	cfg = desc->chip_data;
 
-	if (assign_irq_vector(irq, cfg, apic->target_cpus()))
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	if (!x86_irq_allowed_and(desc->node, tmp_mask, apic->target_cpus()))
+		goto error;
+
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
@@ -1459,6 +1477,9 @@ static void setup_IO_APIC_irq(int apic_i
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
+error:
+	free_cpumask_var(tmp_mask);
+	return;
 }
 
 static struct {
@@ -2282,18 +2303,32 @@ set_desc_affinity(struct irq_desc *desc,
 {
 	struct irq_cfg *cfg;
 	unsigned int irq;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return BAD_APICID;
+	cpumask_var_t tmp_mask;
 
 	irq = desc->irq;
 	cfg = desc->chip_data;
-	if (assign_irq_vector(irq, cfg, mask))
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return BAD_APICID;
 
-	cpumask_copy(desc->affinity, mask);
+	if (!x86_irq_allowed_and(desc->node, tmp_mask, mask))
+		goto error;
+
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask))
+		goto error;
+
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	cpumask_copy(desc->affinity, tmp_mask);
+
+	free_cpumask_var(tmp_mask);
 
 	return apic->cpu_mask_to_apicid_and(desc->affinity, cfg->domain);
+
+error:
+	free_cpumask_var(tmp_mask);
+	return BAD_APICID;
 }
 
 static int
@@ -2349,22 +2384,32 @@ migrate_ioapic_irq_desc(struct irq_desc 
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
+	cpumask_var_t tmp_mask;
 	unsigned int dest;
 	unsigned int irq;
 	int ret = -1;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	irq = desc->irq;
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return ret;
 
-	irq = desc->irq;
+	if (!x86_irq_allowed_and(desc->node, tmp_mask, mask))
+		goto error;
+
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
@@ -2377,9 +2422,10 @@ migrate_ioapic_irq_desc(struct irq_desc 
 	if (cfg->move_in_progress)
 		send_cleanup_vector(cfg);
 
-	cpumask_copy(desc->affinity, mask);
-
-	return 0;
+	cpumask_copy(desc->affinity, tmp_mask);
+error:
+	free_cpumask_var(tmp_mask);
+	return ret;
 }
 
 /*
@@ -3212,18 +3258,29 @@ static int msi_compose_msg(struct pci_de
 			   struct msi_msg *msg, u8 hpet_id)
 {
 	struct irq_cfg *cfg;
+	struct irq_desc *desc;
 	int err;
 	unsigned dest;
+	cpumask_var_t tmp_mask;
 
 	if (disable_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
+	desc = irq_to_desc(irq);
+	if (!x86_irq_allowed_and(desc->node, tmp_mask, apic->target_cpus())) {
+		err = -ENOSPC;
+		goto error;
+	}
+
+	err = assign_irq_vector(irq, cfg, tmp_mask);
 	if (err)
-		return err;
+		goto error;
 
-	dest = apic->cpu_mask_to_apicid_and(cfg->domain, apic->target_cpus());
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	if (irq_remapped(irq)) {
 		struct irte irte;
@@ -3281,6 +3338,8 @@ static int msi_compose_msg(struct pci_de
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
 	}
+error:
+	free_cpumask_var(tmp_mask);
 	return err;
 }
 
@@ -3698,19 +3757,29 @@ static struct irq_chip ht_irq_chip = {
 int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 {
 	struct irq_cfg *cfg;
+	cpumask_var_t tmp_mask;
 	int err;
 
 	if (disable_apic)
 		return -ENXIO;
 
 	cfg = irq_cfg(irq);
-	err = assign_irq_vector(irq, cfg, apic->target_cpus());
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
+		return -ENOMEM;
+
+	if (!x86_irq_allowed_and(dev_to_node(&dev->dev), tmp_mask,
+				apic->target_cpus())) {
+		err = -ENOSPC;
+		goto error;
+	}
+
+	err = assign_irq_vector(irq, cfg, tmp_mask);
 	if (!err) {
 		struct ht_irq_msg msg;
 		unsigned dest;
 
-		dest = apic->cpu_mask_to_apicid_and(cfg->domain,
-						    apic->target_cpus());
+		dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 		msg.address_hi = HT_IRQ_HIGH_DEST_ID(dest);
 
@@ -3734,6 +3803,8 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
+error:
+	free_cpumask_var(tmp_mask);
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2009-10-20 19:54:42.000000000 -0500
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
--- linux.orig/arch/x86/Kconfig	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/Kconfig	2009-10-20 19:54:42.000000000 -0500
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
--- linux.orig/arch/x86/kernel/uv_irq.c	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/kernel/uv_irq.c	2009-10-20 19:54:42.000000000 -0500
@@ -242,6 +242,64 @@ static int uv_set_irq_affinity(unsigned 
 	return 0;
 }
 
+static cpumask_var_t *uv_irq_cpus_allowed;
+
+int uv_irq_cpus_allowed_and(int node, struct cpumask *dstp,
+				const struct cpumask *srcp)
+{
+	int bid;
+
+	if (node < 0) {
+		cpumask_copy(dstp, srcp);
+		return 1;
+	}
+
+	bid = uv_node_to_blade_id(node);
+
+	return cpumask_and(dstp, srcp, uv_irq_cpus_allowed[bid]);
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
+
+	x86_irq_allowed_and = uv_irq_cpus_allowed_and;
+}
+
 /*
  * Set up a mapping of an available irq and vector, and enable the specified
  * MMR that defines the MSI that is to be sent to the specified CPU when an
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-20 19:54:42.000000000 -0500
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
@@ -659,5 +660,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	arch_init_uv_cfg_cpus_allowed();
 	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/include/asm/hw_irq.h	2009-10-20 19:54:42.000000000 -0500
@@ -99,6 +99,8 @@ struct irq_cfg {
 	u8			move_in_progress : 1;
 };
 
+extern int (*x86_irq_allowed_and)(int, struct cpumask *,
+					const struct cpumask *);
 extern struct irq_cfg *irq_cfg(unsigned int);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
Index: linux/arch/x86/include/asm/uv/uv_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_irq.h	2009-10-20 19:54:36.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_irq.h	2009-10-20 19:54:42.000000000 -0500
@@ -31,6 +31,7 @@ enum {
 	UV_AFFINITY_CPU
 };
 
+extern void arch_init_uv_cfg_cpus_allowed(void);
 extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
 extern int uv_setup_irq(char *, int, int, unsigned long, int);
 extern void uv_teardown_irq(unsigned int);
