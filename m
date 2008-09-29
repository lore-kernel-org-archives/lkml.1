Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYI2SMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYI2SMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbYI2SDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:58650 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754032AbYI2SCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:55 -0400
Message-Id: <20080929180254.336981000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:21 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 31/31] cpumask: clean misc files
Content-Disposition: inline; filename=clean-misc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 drivers/base/node.c            |    6 +++---
 drivers/base/topology.c        |   20 +++++++++++---------
 drivers/firmware/dcdbas.c      |    6 +++---
 drivers/net/sfc/efx.c          |    2 +-
 drivers/oprofile/buffer_sync.c |    2 +-
 include/asm-x86/paravirt.h     |    6 +++---
 include/asm-x86/processor.h    |    2 +-
 include/asm-x86/topology.h     |   14 +++++++-------
 include/asm-x86/uv/uv_bau.h    |    2 +-
 include/linux/interrupt.h      |    8 ++++----
 include/linux/seq_file.h       |    4 ++--
 include/linux/stop_machine.h   |    6 +++---
 net/core/dev.c                 |    2 +-
 net/iucv/iucv.c                |   12 ++++++------
 virt/kvm/kvm_main.c            |    6 +++---
 15 files changed, 50 insertions(+), 48 deletions(-)

--- struct-cpumasks.orig/drivers/base/node.c
+++ struct-cpumasks/drivers/base/node.c
@@ -22,15 +22,15 @@ static struct sysdev_class node_class = 
 static ssize_t node_read_cpumap(struct sys_device *dev, int type, char *buf)
 {
 	struct node *node_dev = to_node(dev);
-	const cpumask_t mask = node_to_cpumask(node_dev->sysdev.id);
+	const_cpumask_t mask = node_to_cpumask(node_dev->sysdev.id);
 	int len;
 
 	/* 2008/04/07: buf currently PAGE_SIZE, need 9 chars per 32 bits. */
 	BUILD_BUG_ON((NR_CPUS/32 * 9) > (PAGE_SIZE-1));
 
 	len = type?
-		cpulist_scnprintf(buf, PAGE_SIZE-2, *mask):
-		cpumask_scnprintf(buf, PAGE_SIZE-2, *mask);
+		cpulist_scnprintf(buf, PAGE_SIZE-2, mask):
+		cpumask_scnprintf(buf, PAGE_SIZE-2, mask);
  	buf[len++] = '\n';
  	buf[len] = '\0';
 	return len;
--- struct-cpumasks.orig/drivers/base/topology.c
+++ struct-cpumasks/drivers/base/topology.c
@@ -42,15 +42,15 @@ static ssize_t show_##name(struct sys_de
 }
 
 #if defined(topology_thread_siblings) || defined(topology_core_siblings)
-static ssize_t show_cpumap(int type, cpumask_t *mask, char *buf)
+static ssize_t show_cpumap(int type, const_cpumask_t mask, char *buf)
 {
 	ptrdiff_t len = PTR_ALIGN(buf + PAGE_SIZE - 1, PAGE_SIZE) - buf;
 	int n = 0;
 
 	if (len > 1) {
 		n = type?
-			cpulist_scnprintf(buf, len-2, *mask):
-			cpumask_scnprintf(buf, len-2, *mask);
+			cpulist_scnprintf(buf, len-2, mask):
+			cpumask_scnprintf(buf, len-2, mask);
 		buf[n++] = '\n';
 		buf[n] = '\0';
 	}
@@ -64,7 +64,7 @@ static ssize_t show_##name(struct sys_de
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(0, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(0, topology_##name(cpu), buf);		\
 }
 
 #define define_siblings_show_list(name)					\
@@ -73,7 +73,7 @@ static ssize_t show_##name##_list(struct
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
-	return show_cpumap(1, &(topology_##name(cpu)), buf);		\
+	return show_cpumap(1, topology_##name(cpu), buf);		\
 }
 
 #else
@@ -82,8 +82,9 @@ static ssize_t show_##name(struct sys_de
 			   struct sysdev_attribute *attr, char *buf)	\
 {									\
 	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(0, &mask, buf);				\
+	cpumask_var_t mask;						\
+	cpus_copy(mask, topology_##name(cpu));				\
+	return show_cpumap(0, mask, buf);				\
 }
 
 #define define_siblings_show_list(name)					\
@@ -92,8 +93,9 @@ static ssize_t show_##name##_list(struct
 				  char *buf)				\
 {									\
 	unsigned int cpu = dev->id;					\
-	cpumask_t mask = topology_##name(cpu);				\
-	return show_cpumap(1, &mask, buf);				\
+	cpumask_var_t mask;						\
+	cpus_copy(mask, topology_##name(cpu));				\
+	return show_cpumap(1, mask, buf);				\
 }
 #endif
 
--- struct-cpumasks.orig/drivers/firmware/dcdbas.c
+++ struct-cpumasks/drivers/firmware/dcdbas.c
@@ -244,7 +244,7 @@ static ssize_t host_control_on_shutdown_
  */
 static int smi_request(struct smi_cmd *smi_cmd)
 {
-	cpumask_t old_mask;
+	cpumask_var_t old_mask;
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -254,7 +254,7 @@ static int smi_request(struct smi_cmd *s
 	}
 
 	/* SMI requires CPU 0 */
-	old_mask = current->cpus_allowed;
+	cpus_copy(old_mask, current->cpus_allowed);
 	set_cpus_allowed(current, cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
@@ -275,7 +275,7 @@ static int smi_request(struct smi_cmd *s
 	);
 
 out:
-	set_cpus_allowed(current, &old_mask);
+	set_cpus_allowed(current, old_mask);
 	return ret;
 }
 
--- struct-cpumasks.orig/drivers/net/sfc/efx.c
+++ struct-cpumasks/drivers/net/sfc/efx.c
@@ -834,7 +834,7 @@ static void efx_probe_interrupts(struct 
 		BUG_ON(!pci_find_capability(efx->pci_dev, PCI_CAP_ID_MSIX));
 
 		if (rss_cpus == 0) {
-			cpumask_t core_mask;
+			cpumask_var_t core_mask;
 			int cpu;
 
 			cpus_clear(core_mask);
--- struct-cpumasks.orig/drivers/oprofile/buffer_sync.c
+++ struct-cpumasks/drivers/oprofile/buffer_sync.c
@@ -37,7 +37,7 @@
 
 static LIST_HEAD(dying_tasks);
 static LIST_HEAD(dead_tasks);
-static cpumask_t marked_cpus = CPU_MASK_NONE;
+static cpumask_map_t marked_cpus = CPU_MASK_NONE;
 static DEFINE_SPINLOCK(task_mortuary);
 static void process_task_mortuary(void);
 
--- struct-cpumasks.orig/include/asm-x86/paravirt.h
+++ struct-cpumasks/include/asm-x86/paravirt.h
@@ -245,7 +245,7 @@ struct pv_mmu_ops {
 	void (*flush_tlb_user)(void);
 	void (*flush_tlb_kernel)(void);
 	void (*flush_tlb_single)(unsigned long addr);
-	void (*flush_tlb_others)(const cpumask_t *cpus, struct mm_struct *mm,
+	void (*flush_tlb_others)(const_cpumask_t cpus, struct mm_struct *mm,
 				 unsigned long va);
 
 	/* Hooks for allocating and freeing a pagetable top-level */
@@ -985,10 +985,10 @@ static inline void __flush_tlb_single(un
 	PVOP_VCALL1(pv_mmu_ops.flush_tlb_single, addr);
 }
 
-static inline void flush_tlb_others(cpumask_t cpumask, struct mm_struct *mm,
+static inline void flush_tlb_others(const_cpumask_t cpumask, struct mm_struct *mm,
 				    unsigned long va)
 {
-	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, &cpumask, mm, va);
+	PVOP_VCALL3(pv_mmu_ops.flush_tlb_others, cpumask, mm, va);
 }
 
 static inline int paravirt_pgd_alloc(struct mm_struct *mm)
--- struct-cpumasks.orig/include/asm-x86/processor.h
+++ struct-cpumasks/include/asm-x86/processor.h
@@ -93,7 +93,7 @@ struct cpuinfo_x86 {
 	unsigned long		loops_per_jiffy;
 #ifdef CONFIG_SMP
 	/* cpus sharing the last level cache: */
-	cpumask_t		llc_shared_map;
+	cpumask_var_t		llc_shared_map;
 #endif
 	/* cpuid returned max cores value: */
 	u16			 x86_max_cores;
--- struct-cpumasks.orig/include/asm-x86/topology.h
+++ struct-cpumasks/include/asm-x86/topology.h
@@ -58,15 +58,15 @@ static inline int cpu_to_node(int cpu)
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
 /* Returns a bitmask of CPUs on Node 'node'. */
-static inline const cpumask_t node_to_cpumask(int node)
+static inline const_cpumask_t node_to_cpumask(int node)
 {
-	return (const cpumask_t)&node_to_cpumask_map[node];
+	return (const_cpumask_t)&node_to_cpumask_map[node];
 }
 
 #else /* CONFIG_X86_64 */
 
 /* Mappings between node number and cpus on that node. */
-extern const cpumask_t node_to_cpumask_map;
+extern const_cpumask_t node_to_cpumask_map;
 
 /* Mappings between logical cpu number and node number */
 DECLARE_EARLY_PER_CPU(int, x86_cpu_to_node_map);
@@ -105,7 +105,7 @@ static inline const_cpumask_t node_to_cp
 	char *map = (char *)node_to_cpumask_map;
 
 	map += BITS_TO_LONGS(node * nr_cpu_ids);
-	return (const cpumask_t)map;
+	return (const_cpumask_t)map;
 }
 
 #endif /* !CONFIG_DEBUG_PER_CPU_MAPS */
@@ -175,7 +175,7 @@ extern int __node_distance(int, int);
 
 static inline const_cpumask_t node_to_cpumask(int node)
 {
-	return (const cpumask_t)cpu_online_map;
+	return (const_cpumask_t)cpu_online_map;
 }
 static inline int node_to_first_cpu(int node)
 {
@@ -190,11 +190,11 @@ static inline int node_to_first_cpu(int 
 /* Returns the number of the first CPU on Node 'node'. */
 static inline int node_to_first_cpu(int node)
 {
-	return cpus_first((const cpumask_t)node_to_cpumask(node));
+	return cpus_first((const_cpumask_t)node_to_cpumask(node));
 }
 #endif
 
-extern cpumask_t cpu_coregroup_map(int cpu);
+extern const_cpumask_t cpu_coregroup_map(int cpu);
 
 #ifdef ENABLE_TOPO_DEFINES
 #define topology_physical_package_id(cpu)	(cpu_data(cpu).phys_proc_id)
--- struct-cpumasks.orig/include/asm-x86/uv/uv_bau.h
+++ struct-cpumasks/include/asm-x86/uv/uv_bau.h
@@ -325,7 +325,7 @@ static inline void bau_cpubits_clear(str
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
 
-extern int uv_flush_tlb_others(cpumask_t *, struct mm_struct *, unsigned long);
+extern int uv_flush_tlb_others(cpumask_t, struct mm_struct *, unsigned long);
 extern void uv_bau_message_intr1(void);
 extern void uv_bau_timeout_intr1(void);
 
--- struct-cpumasks.orig/include/linux/interrupt.h
+++ struct-cpumasks/include/linux/interrupt.h
@@ -67,7 +67,7 @@ typedef irqreturn_t (*irq_handler_t)(int
 struct irqaction {
 	irq_handler_t handler;
 	unsigned long flags;
-	cpumask_t mask;
+	cpumask_map_t mask;
 	const char *name;
 	void *dev_id;
 	struct irqaction *next;
@@ -111,15 +111,15 @@ extern void enable_irq(unsigned int irq)
 
 #if defined(CONFIG_SMP) && defined(CONFIG_GENERIC_HARDIRQS)
 
-extern cpumask_t irq_default_affinity;
+extern cpumask_map_t irq_default_affinity;
 
-extern int irq_set_affinity(unsigned int irq, cpumask_t cpumask);
+extern int irq_set_affinity(unsigned int irq, const_cpumask_t cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
 #else /* CONFIG_SMP */
 
-static inline int irq_set_affinity(unsigned int irq, cpumask_t cpumask)
+static inline int irq_set_affinity(unsigned int irq, const_cpumask_t cpumask)
 {
 	return -EINVAL;
 }
--- struct-cpumasks.orig/include/linux/seq_file.h
+++ struct-cpumasks/include/linux/seq_file.h
@@ -50,9 +50,9 @@ int seq_dentry(struct seq_file *, struct
 int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
 		  char *esc);
 int seq_bitmap(struct seq_file *m, unsigned long *bits, unsigned int nr_bits);
-static inline int seq_cpumask(struct seq_file *m, cpumask_t mask)
+static inline int seq_cpumask(struct seq_file *m, const_cpumask_t mask)
 {
-	return seq_bitmap(m, mask->bits, nr_cpu_ids);
+	return seq_bitmap(m, cpus_addr(mask), nr_cpu_ids);
 }
 
 static inline int seq_nodemask(struct seq_file *m, nodemask_t *mask)
--- struct-cpumasks.orig/include/linux/stop_machine.h
+++ struct-cpumasks/include/linux/stop_machine.h
@@ -23,7 +23,7 @@
  *
  * This can be thought of as a very heavy write lock, equivalent to
  * grabbing every spinlock in the kernel. */
-int stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int stop_machine(int (*fn)(void *), void *data, const_cpumask_t cpus);
 
 /**
  * __stop_machine: freeze the machine on all CPUs and run this function
@@ -34,11 +34,11 @@ int stop_machine(int (*fn)(void *), void
  * Description: This is a special version of the above, which assumes cpus
  * won't come or go while it's being called.  Used by hotplug cpu.
  */
-int __stop_machine(int (*fn)(void *), void *data, const cpumask_t *cpus);
+int __stop_machine(int (*fn)(void *), void *data, const_cpumask_t cpus);
 #else
 
 static inline int stop_machine(int (*fn)(void *), void *data,
-			       const cpumask_t *cpus)
+			       const_cpumask_t cpus)
 {
 	int ret;
 	local_irq_disable();
--- struct-cpumasks.orig/net/core/dev.c
+++ struct-cpumasks/net/core/dev.c
@@ -169,7 +169,7 @@ static struct list_head ptype_all __read
 struct net_dma {
 	struct dma_client client;
 	spinlock_t lock;
-	cpumask_t channel_mask;
+	cpumask_map_t channel_mask;
 	struct dma_chan **channels;
 };
 
--- struct-cpumasks.orig/net/iucv/iucv.c
+++ struct-cpumasks/net/iucv/iucv.c
@@ -98,8 +98,8 @@ struct iucv_irq_list {
 };
 
 static struct iucv_irq_data *iucv_irq_data[NR_CPUS];
-static cpumask_t iucv_buffer_cpumask = CPU_MASK_NONE;
-static cpumask_t iucv_irq_cpumask = CPU_MASK_NONE;
+static cpumask_map_t iucv_buffer_cpumask = CPU_MASK_NONE;
+static cpumask_map_t iucv_irq_cpumask = CPU_MASK_NONE;
 
 /*
  * Queue of interrupt buffers lock for delivery via the tasklet
@@ -491,11 +491,11 @@ static void iucv_setmask_mp(void)
  */
 static void iucv_setmask_up(void)
 {
-	cpumask_t cpumask;
+	cpumask_var_t cpumask;
 	int cpu;
 
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
-	cpumask = iucv_irq_cpumask;
+	cpus_copy(cpumask, iucv_irq_cpumask);
 	cpu_clear(cpus_first(iucv_irq_cpumask), cpumask);
 	for_each_cpu(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
@@ -554,7 +554,7 @@ static void iucv_disable(void)
 static int __cpuinit iucv_cpu_notify(struct notifier_block *self,
 				     unsigned long action, void *hcpu)
 {
-	cpumask_t cpumask;
+	cpumask_var_t cpumask;
 	long cpu = (long) hcpu;
 
 	switch (action) {
@@ -589,7 +589,7 @@ static int __cpuinit iucv_cpu_notify(str
 		break;
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		cpumask = iucv_buffer_cpumask;
+		cpus_copy(cpumask, iucv_buffer_cpumask);
 		cpu_clear(cpu, cpumask);
 		if (cpus_empty(cpumask))
 			/* Can't offline last IUCV enabled cpu. */
--- struct-cpumasks.orig/virt/kvm/kvm_main.c
+++ struct-cpumasks/virt/kvm/kvm_main.c
@@ -57,7 +57,7 @@ MODULE_LICENSE("GPL");
 DEFINE_SPINLOCK(kvm_lock);
 LIST_HEAD(vm_list);
 
-static cpumask_t cpus_hardware_enabled;
+static cpumask_map_t cpus_hardware_enabled;
 
 struct kmem_cache *kvm_vcpu_cache;
 EXPORT_SYMBOL_GPL(kvm_vcpu_cache);
@@ -106,7 +106,7 @@ static void ack_flush(void *_completed)
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
 	int i, cpu, me;
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 	struct kvm_vcpu *vcpu;
 
 	me = get_cpu();
@@ -132,7 +132,7 @@ out:
 void kvm_reload_remote_mmus(struct kvm *kvm)
 {
 	int i, cpu, me;
-	cpumask_t cpus;
+	cpumask_var_t cpus;
 	struct kvm_vcpu *vcpu;
 
 	me = get_cpu();

-- 
