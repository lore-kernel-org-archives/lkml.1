Return-Path: <linux-kernel-owner+w=401wt.eu-S932772AbZJOBPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbZJOBPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761820AbZJOBPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:15:31 -0400
Received: from relay2.sgi.com ([192.48.179.30]:58903 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754346AbZJOBP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:15:29 -0400
Date: Wed, 14 Oct 2009 20:13:39 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2] x86/apic: limit irq affinity
Message-ID: <20091015011339.GA17374@sgi.com>
References: <20090930160259.GA7822@sgi.com> <20091012193433.GB2691@elte.hu> <20091012193704.GA8708@sgi.com> <20091014071014.GK784@elte.hu> <20091014120225.GA9674@sgi.com> <20091014122653.GA15048@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014122653.GA15048@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows for hard restrictions to irq affinity via a new cpumask and
device node value in the irq_cfg structure.

The mask forces IRQ affinity to remain within the specified cpu domain.
On some UV systems, this domain will be limited to the nodes accessible
to the given node.  Currently other X86 systems will have all bits in
the cpumask set, so non-UV systems will remain unaffected at this time.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

Removed UV specific code from generic IO APIC code.

 arch/x86/Kconfig                   |    1 
 arch/x86/include/asm/hw_irq.h      |    3 
 arch/x86/include/asm/uv/uv_irq.h   |    1 
 arch/x86/include/asm/uv/uv_mmrs.h  |   25 +++++
 arch/x86/kernel/apic/io_apic.c     |  144 ++++++++++++++++++++++++++-------
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 
 arch/x86/kernel/uv_irq.c           |   77 +++++++++++++++++
 7 files changed, 225 insertions(+), 28 deletions(-)

Index: linux/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/io_apic.c	2009-10-14 12:48:50.000000000 -0500
+++ linux/arch/x86/kernel/apic/io_apic.c	2009-10-14 15:04:23.000000000 -0500
@@ -168,6 +168,19 @@ void __init io_apic_disable_legacy(void)
 	nr_irqs_gsi = 0;
 }
 
+void (*set_irq_cfg_allowed)(cpumask_var_t, int) = NULL;
+/*
+ * Setup IRQ affinity restriction.
+ */
+static void set_irq_cfg_cpus_allowed(struct irq_cfg *irq_cfg)
+{
+	if (set_irq_cfg_allowed)
+		set_irq_cfg_allowed(irq_cfg->allowed, irq_cfg->node);
+	else
+		/* Default to allow anything */
+		cpumask_setall(irq_cfg->allowed);
+}
+
 int __init arch_early_irq_init(void)
 {
 	struct irq_cfg *cfg;
@@ -183,8 +196,11 @@ int __init arch_early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc = irq_to_desc(i);
 		desc->chip_data = &cfg[i];
+		cfg->node = node;
 		zalloc_cpumask_var_node(&cfg[i].domain, GFP_NOWAIT, node);
 		zalloc_cpumask_var_node(&cfg[i].old_domain, GFP_NOWAIT, node);
+		zalloc_cpumask_var_node(&cfg[i].allowed, GFP_NOWAIT, node);
+		set_irq_cfg_cpus_allowed(&cfg[i]);
 		if (i < nr_legacy_irqs)
 			cpumask_setall(cfg[i].domain);
 	}
@@ -213,12 +229,19 @@ static struct irq_cfg *get_one_free_irq_
 	if (cfg) {
 		if (!zalloc_cpumask_var_node(&cfg->domain, GFP_ATOMIC, node)) {
 			kfree(cfg);
-			cfg = NULL;
-		} else if (!zalloc_cpumask_var_node(&cfg->old_domain,
+			return NULL;
+		}
+		if (!zalloc_cpumask_var_node(&cfg->old_domain,
 							  GFP_ATOMIC, node)) {
 			free_cpumask_var(cfg->domain);
 			kfree(cfg);
-			cfg = NULL;
+			return NULL;
+		}
+		if (!zalloc_cpumask_var_node(&cfg->allowed, GFP_ATOMIC, node)) {
+			free_cpumask_var(cfg->old_domain);
+			free_cpumask_var(cfg->domain);
+			kfree(cfg);
+			return NULL;
 		}
 	}
 
@@ -231,12 +254,14 @@ int arch_init_chip_data(struct irq_desc 
 
 	cfg = desc->chip_data;
 	if (!cfg) {
-		desc->chip_data = get_one_free_irq_cfg(node);
+		cfg = desc->chip_data = get_one_free_irq_cfg(node);
 		if (!desc->chip_data) {
 			printk(KERN_ERR "can not alloc irq_cfg\n");
 			BUG_ON(1);
 		}
 	}
+	cfg->node = node;
+	set_irq_cfg_cpus_allowed(cfg);
 
 	return 0;
 }
@@ -318,6 +343,10 @@ void arch_init_copy_chip_data(struct irq
 
 	memcpy(cfg, old_cfg, sizeof(struct irq_cfg));
 
+	cfg->node = node;
+
+	set_irq_cfg_cpus_allowed(cfg);
+
 	init_copy_irq_2_pin(old_cfg, cfg, node);
 }
 
@@ -1428,16 +1457,23 @@ static void setup_IO_APIC_irq(int apic_i
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
+	if (!cpumask_and(tmp_mask, apic->target_cpus(), cfg->allowed))
+		goto error;
+
+	if (assign_irq_vector(irq, cfg, tmp_mask))
+		goto error;
+
+	dest = apic->cpu_mask_to_apicid_and(cfg->domain, tmp_mask);
 
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
@@ -1451,7 +1487,7 @@ static void setup_IO_APIC_irq(int apic_i
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 		       mp_ioapics[apic_id].apicid, pin);
 		__clear_irq_vector(irq, cfg);
-		return;
+		goto error;
 	}
 
 	ioapic_register_intr(irq, desc, trigger);
@@ -1459,6 +1495,9 @@ static void setup_IO_APIC_irq(int apic_i
 		disable_8259A_irq(irq);
 
 	ioapic_write_entry(apic_id, pin, entry);
+error:
+	free_cpumask_var(tmp_mask);
+	return;
 }
 
 static struct {
@@ -2265,18 +2304,32 @@ set_desc_affinity(struct irq_desc *desc,
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
+	if (!cpumask_and(tmp_mask, mask, cfg->allowed))
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
@@ -2332,22 +2385,32 @@ migrate_ioapic_irq_desc(struct irq_desc 
 {
 	struct irq_cfg *cfg;
 	struct irte irte;
+	cpumask_var_t tmp_mask;
 	unsigned int dest;
 	unsigned int irq;
 	int ret = -1;
 
-	if (!cpumask_intersects(mask, cpu_online_mask))
+	irq = desc->irq;
+	cfg = desc->chip_data;
+
+	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
 		return ret;
 
-	irq = desc->irq;
+	if (!cpumask_and(tmp_mask, mask, cfg->allowed))
+		goto error;
+
+	if (!cpumask_intersects(tmp_mask, cpu_online_mask))
+		goto error;
+
 	if (get_irte(irq, &irte))
-		return ret;
+		goto error;
 
-	cfg = desc->chip_data;
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
@@ -2360,9 +2423,10 @@ migrate_ioapic_irq_desc(struct irq_desc 
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
@@ -3146,6 +3210,8 @@ unsigned int create_irq_nr(unsigned int 
 
 	if (irq > 0) {
 		dynamic_irq_init(irq);
+		cfg_new->node = node;
+		set_irq_cfg_cpus_allowed(cfg_new);
 		/* restore it, in case dynamic_irq_init clear it */
 		if (desc_new)
 			desc_new->chip_data = cfg_new;
@@ -3197,16 +3263,25 @@ static int msi_compose_msg(struct pci_de
 	struct irq_cfg *cfg;
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
+	if (!cpumask_and(tmp_mask, apic->target_cpus(), cfg->allowed)) {
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
@@ -3264,6 +3339,8 @@ static int msi_compose_msg(struct pci_de
 				MSI_DATA_DELIVERY_LOWPRI) |
 			MSI_DATA_VECTOR(cfg->vector);
 	}
+error:
+	free_cpumask_var(tmp_mask);
 	return err;
 }
 
@@ -3681,19 +3758,28 @@ static struct irq_chip ht_irq_chip = {
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
+	if (!cpumask_and(tmp_mask, apic->target_cpus(), cfg->allowed)) {
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
 
@@ -3717,6 +3803,8 @@ int arch_setup_ht_irq(unsigned int irq, 
 
 		dev_printk(KERN_DEBUG, &dev->dev, "irq %d for HT\n", irq);
 	}
+error:
+	free_cpumask_var(tmp_mask);
 	return err;
 }
 #endif /* CONFIG_HT_IRQ */
Index: linux/arch/x86/include/asm/uv/uv_mmrs.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_mmrs.h	2009-10-14 12:44:57.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_mmrs.h	2009-10-14 12:48:50.000000000 -0500
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
--- linux.orig/arch/x86/Kconfig	2009-10-14 12:44:57.000000000 -0500
+++ linux/arch/x86/Kconfig	2009-10-14 15:04:23.000000000 -0500
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
--- linux.orig/arch/x86/kernel/uv_irq.c	2009-10-14 12:48:50.000000000 -0500
+++ linux/arch/x86/kernel/uv_irq.c	2009-10-14 14:27:10.000000000 -0500
@@ -241,6 +241,83 @@ static int uv_set_irq_affinity(unsigned 
 }
 
 /*
+ * Setup the cpumask for IRQ restriction for a given UV node.
+ */
+static void uv_set_irq_cfg_cpus_allowed(struct cpumask *mask, int node)
+{
+#ifdef CONFIG_SPARSE_IRQ
+	unsigned long pnode_tbl[UVH_LB_SOCKET_DESTINATION_TABLE_DEPTH];
+	unsigned long *pa, *pa_end;
+	int cpu, i;
+
+	/* Assume nodes accessible from node 0 */
+	if (node < 0)
+		node = 0;
+
+	pa = uv_global_mmr64_address(uv_node_to_pnode(node),
+			UVH_LB_SOCKET_DESTINATION_TABLE);
+
+	for (i = 0; i < UVH_LB_SOCKET_DESTINATION_TABLE_DEPTH; pa++, i++)
+		pnode_tbl[i] = UV_NASID_TO_PNODE(*pa &
+			UVH_LB_SOCKET_DESTINATION_TABLE_NODE_ID_MASK);
+
+	cpumask_clear(mask);
+
+	pa = pnode_tbl;
+	pa_end = pa + UVH_LB_SOCKET_DESTINATION_TABLE_DEPTH;
+
+	/* Select the cpus on nodes accessible from our hub */
+	for_each_possible_cpu(cpu) {
+		int p = uv_cpu_to_pnode(cpu);
+
+		if (p < *pa) {
+			while (p < *pa) {
+				pa--;
+				if (pa < pnode_tbl) {
+					pa++;
+					break;
+				}
+			}
+			if (*pa == p)
+				cpumask_set_cpu(cpu, mask);
+			continue;
+		}
+
+		while (*pa < p) {
+			pa++;
+			if (pa == pa_end) {
+				pa--;
+				break;
+			}
+		}
+
+		if (*pa == p)
+			cpumask_set_cpu(cpu, mask);
+	}
+#else
+	cpumask_setall(mask);
+#endif
+}
+
+/*
+ * Setup IRQ affinity restriction for IRQ's setup prior to the availability
+ * of UV topology information.
+ */
+void arch_init_uv_cfg_cpus_allowed(void)
+{
+	struct irq_cfg *cfg;
+	int i;
+
+	set_irq_cfg_allowed = uv_set_irq_cfg_cpus_allowed;
+	/* Set allowed mask now that topology information is known */
+	for (i = 0; i < NR_IRQS; i++) {
+		cfg = irq_cfg(i);
+		if (cfg)
+			uv_set_irq_cfg_cpus_allowed(cfg->allowed, cfg->node);
+	}
+}
+
+/*
  * Set up a mapping of an available irq and vector, and enable the specified
  * MMR that defines the MSI that is to be sent to the specified CPU when an
  * interrupt is raised.
Index: linux/arch/x86/kernel/apic/x2apic_uv_x.c
===================================================================
--- linux.orig/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-14 12:44:57.000000000 -0500
+++ linux/arch/x86/kernel/apic/x2apic_uv_x.c	2009-10-14 15:04:23.000000000 -0500
@@ -23,6 +23,7 @@
 
 #include <asm/uv/uv_mmrs.h>
 #include <asm/uv/uv_hub.h>
+#include <asm/uv/uv_irq.h>
 #include <asm/current.h>
 #include <asm/pgtable.h>
 #include <asm/uv/bios.h>
@@ -659,5 +660,6 @@ void __init uv_system_init(void)
 
 	uv_cpu_init();
 	uv_scir_register_cpu_notifier();
+	arch_init_uv_cfg_cpus_allowed();
 	proc_mkdir("sgi_uv", NULL);
 }
Index: linux/arch/x86/include/asm/hw_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/hw_irq.h	2009-10-14 12:48:50.000000000 -0500
+++ linux/arch/x86/include/asm/hw_irq.h	2009-10-14 12:48:50.000000000 -0500
@@ -94,11 +94,14 @@ struct irq_cfg {
 	struct irq_pin_list *irq_2_pin;
 	cpumask_var_t domain;
 	cpumask_var_t old_domain;
+	cpumask_var_t allowed;
+	int node;
 	unsigned move_cleanup_count;
 	u8 vector;
 	u8 move_in_progress : 1;
 };
 
+extern void (*set_irq_cfg_allowed)(cpumask_var_t, int);
 extern struct irq_cfg *irq_cfg(unsigned int);
 extern int assign_irq_vector(int, struct irq_cfg *, const struct cpumask *);
 extern void send_cleanup_vector(struct irq_cfg *);
Index: linux/arch/x86/include/asm/uv/uv_irq.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_irq.h	2009-10-14 12:48:50.000000000 -0500
+++ linux/arch/x86/include/asm/uv/uv_irq.h	2009-10-14 12:48:50.000000000 -0500
@@ -31,6 +31,7 @@ enum {
 	UV_AFFINITY_CPU
 };
 
+extern void arch_init_uv_cfg_cpus_allowed(void);
 extern int uv_irq_2_mmr_info(int, unsigned long *, int *);
 extern int uv_setup_irq(char *, int, int, unsigned long, int);
 extern void uv_teardown_irq(unsigned int);
