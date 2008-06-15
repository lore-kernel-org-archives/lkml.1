Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbYFOQPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbYFOQPm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759166AbYFOQPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:15:05 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:42538 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759045AbYFOQOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:14:50 -0400
Date: Sun, 15 Jun 2008 19:13:31 +0300
From: Adrian Bunk <bunk@kernel.org>
To: kyle@mcmartin.ca, matthew@wil.cx, grundler@parisc-linux.org
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] parisc/kernel/ cleanups
Message-ID: <20080615161331.GD7865@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the following cleanups:
- make the following needlessly global code static:
  - cache.c: split_tlb
  - cache.c: clear_user_page_asm()
  - cache.c: parisc_cache_flush_threshold
  - drivers.c: create_tree_node()
  - drivers.c: struct parisc_bus_type
  - drivers.c: walk_lower_bus()
  - firmware.c: real32_call()
  - firmware.c: real64_call()
  - perf.c: struct cpu_device
  - setup.c: setup_cmdline()
  - setup.c: dma_ops_init()
  - smp.c: ipi_lock
  - smp.c: smp_boot_one_cpu()
  - traps.c: parisc_show_stack()
  - traps.c: transfer_pim_to_trap_frame()
  - traps.c: check_ivt()
- #if 0 the following unused function:
  - pdc_cons.c: pdc_console_poll_key()
- remove the following unused code:
  - smp.c: smp_lock
  - traps.c: syscall_ipi()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/parisc/kernel/cache.c         |    7 +++----
 arch/parisc/kernel/drivers.c       |    8 +++++---
 arch/parisc/kernel/firmware.c      |    8 ++++----
 arch/parisc/kernel/pdc_cons.c      |    2 ++
 arch/parisc/kernel/perf.c          |    2 +-
 arch/parisc/kernel/setup.c         |    4 ++--
 arch/parisc/kernel/smp.c           |    6 ++----
 arch/parisc/kernel/traps.c         |   17 ++++++-----------
 include/asm-parisc/cache.h         |    1 -
 include/asm-parisc/parisc-device.h |    2 --
 10 files changed, 25 insertions(+), 32 deletions(-)

a28552f78d6890ea341e3a36031266350f811c60 diff --git a/arch/parisc/kernel/cache.c b/arch/parisc/kernel/cache.c
index e10d25d..09a6475 100644
--- a/arch/parisc/kernel/cache.c
+++ b/arch/parisc/kernel/cache.c
@@ -29,7 +29,7 @@
 #include <asm/processor.h>
 #include <asm/sections.h>
 
-int split_tlb __read_mostly;
+static int split_tlb __read_mostly;
 int dcache_stride __read_mostly;
 int icache_stride __read_mostly;
 EXPORT_SYMBOL(dcache_stride);
@@ -396,7 +396,7 @@ EXPORT_SYMBOL(flush_kernel_dcache_page_asm);
 EXPORT_SYMBOL(flush_data_cache_local);
 EXPORT_SYMBOL(flush_kernel_icache_range_asm);
 
-void clear_user_page_asm(void *page, unsigned long vaddr)
+static void clear_user_page_asm(void *page, unsigned long vaddr)
 {
 	/* This function is implemented in assembly in pacache.S */
 	extern void __clear_user_page_asm(void *page, unsigned long vaddr);
@@ -407,7 +407,7 @@ void clear_user_page_asm(void *page, unsigned long vaddr)
 }
 
 #define FLUSH_THRESHOLD 0x80000 /* 0.5MB */
-int parisc_cache_flush_threshold __read_mostly = FLUSH_THRESHOLD;
+static int parisc_cache_flush_threshold __read_mostly = FLUSH_THRESHOLD;
 
 void __init parisc_setup_cache_timing(void)
 {
@@ -440,7 +440,6 @@ void __init parisc_setup_cache_timing(void)
 }
 
 extern void purge_kernel_dcache_page(unsigned long);
-extern void clear_user_page_asm(void *page, unsigned long vaddr);
 
 void clear_user_page(void *page, unsigned long vaddr, struct page *pg)
 {
diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 2ca654b..09419bd 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -38,6 +38,8 @@
 #include <asm/pdc.h>
 #include <asm/parisc-device.h>
 
+static struct bus_type parisc_bus_type;
+
 /* See comments in include/asm-parisc/pci.h */
 struct hppa_dma_ops *hppa_dma_ops __read_mostly;
 EXPORT_SYMBOL(hppa_dma_ops);
@@ -406,7 +408,7 @@ static void setup_bus_id(struct parisc_device *padev)
 	sprintf(output, "%u", (unsigned char) padev->hw_path);
 }
 
-struct parisc_device * create_tree_node(char id, struct device *parent)
+static struct parisc_device *create_tree_node(char id, struct device *parent)
 {
 	struct parisc_device *dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (!dev)
@@ -582,7 +584,7 @@ static struct device_attribute parisc_device_attrs[] = {
 	__ATTR_NULL,
 };
 
-struct bus_type parisc_bus_type = {
+static struct bus_type parisc_bus_type = {
 	.name = "parisc",
 	.match = parisc_generic_match,
 	.dev_attrs = parisc_device_attrs,
@@ -769,7 +771,7 @@ EXPORT_SYMBOL(device_to_hwpath);
 static void walk_native_bus(unsigned long io_io_low, unsigned long io_io_high,
                             struct device *parent);
 
-void walk_lower_bus(struct parisc_device *dev)
+static void walk_lower_bus(struct parisc_device *dev)
 {
 	unsigned long io_io_low, io_io_high;
 
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 7177a6c..ca6a00f 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -95,9 +95,9 @@ int parisc_narrow_firmware __read_mostly = 1;
  */
 
 #ifdef CONFIG_64BIT
-long real64_call(unsigned long function, ...);
+static long real64_call(unsigned long function, ...);
 #endif
-long real32_call(unsigned long function, ...);
+static long real32_call(unsigned long function, ...);
 
 #ifdef CONFIG_64BIT
 #   define MEM_PDC (unsigned long)(PAGE0->mem_pdc_hi) << 32 | PAGE0->mem_pdc
@@ -1404,7 +1404,7 @@ struct narrow_stack {
 	/* in reality, there's nearly 8k of stack after this */
 };
 
-long real32_call(unsigned long fn, ...)
+static long real32_call(unsigned long fn, ...)
 {
 	va_list args;
 	extern struct narrow_stack real_stack;
@@ -1455,7 +1455,7 @@ struct wide_stack {
 	/* in reality, there's nearly 8k of stack after this */
 };
 
-long real64_call(unsigned long fn, ...)
+static long real64_call(unsigned long fn, ...)
 {
 	va_list args;
 	extern struct wide_stack real64_stack;
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index ccb6809..6da6470 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -66,6 +66,7 @@ static void pdc_console_write(struct console *co, const char *s, unsigned count)
 	spin_unlock_irqrestore(&pdc_console_lock, flags);
 }
 
+#if 0
 int pdc_console_poll_key(struct console *co)
 {
 	int c;
@@ -77,6 +78,7 @@ int pdc_console_poll_key(struct console *co)
 
 	return c;
 }
+#endif  /*  0  */
 
 static int pdc_console_setup(struct console *co, char *options)
 {
diff --git a/arch/parisc/kernel/perf.c b/arch/parisc/kernel/perf.c
index 89d6d5a..20916f5 100644
--- a/arch/parisc/kernel/perf.c
+++ b/arch/parisc/kernel/perf.c
@@ -70,7 +70,7 @@ struct rdr_tbl_ent {
 static int perf_processor_interface __read_mostly = UNKNOWN_INTF;
 static int perf_enabled __read_mostly;
 static spinlock_t perf_lock;
-struct parisc_device *cpu_device __read_mostly;
+static struct parisc_device *cpu_device __read_mostly;
 
 /* RDRs to write for PCX-W */
 static const int perf_rdrs_W[] =
diff --git a/arch/parisc/kernel/setup.c b/arch/parisc/kernel/setup.c
index 39e7c5a..c9a7ff1 100644
--- a/arch/parisc/kernel/setup.c
+++ b/arch/parisc/kernel/setup.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL(parisc_bus_is_phys);
 unsigned long parisc_vmerge_boundary = 0;
 unsigned long parisc_vmerge_max_size = 0;
 
-void __init setup_cmdline(char **cmdline_p)
+static void __init setup_cmdline(char **cmdline_p)
 {
 	extern unsigned int boot_args[];
 
@@ -89,7 +89,7 @@ void __init setup_cmdline(char **cmdline_p)
 }
 
 #ifdef CONFIG_PA11
-void __init dma_ops_init(void)
+static void __init dma_ops_init(void)
 {
 	switch (boot_cpu_data.cpu_type) {
 	case pcx:
diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index 85fc775..8581f7f 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -59,8 +59,6 @@ static int smp_debug_lvl = 0;
 #define smp_debug(lvl, ...)
 #endif /* DEBUG_SMP */
 
-DEFINE_SPINLOCK(smp_lock);
-
 volatile struct task_struct *smp_init_current_idle_task;
 
 static volatile int cpu_now_booting __read_mostly = 0;	/* track which CPU is booting */
@@ -82,7 +80,7 @@ cpumask_t cpu_possible_map __read_mostly = CPU_MASK_ALL;	/* Bitmap of Present CP
 EXPORT_SYMBOL(cpu_online_map);
 EXPORT_SYMBOL(cpu_possible_map);
 
-DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
+static DEFINE_PER_CPU(spinlock_t, ipi_lock) = SPIN_LOCK_UNLOCKED;
 
 struct smp_call_struct {
 	void (*func) (void *info);
@@ -450,7 +448,7 @@ void __init smp_callin(void)
 /*
  * Bring one cpu online.
  */
-int __cpuinit smp_boot_one_cpu(int cpuid)
+static int __cpuinit smp_boot_one_cpu(int cpuid)
 {
 	struct task_struct *idle;
 	long timeout;
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index 675f1d0..a168503 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -51,8 +51,8 @@
 DEFINE_SPINLOCK(pa_dbit_lock);
 #endif
 
-void parisc_show_stack(struct task_struct *t, unsigned long *sp,
-	struct pt_regs *regs);
+static void parisc_show_stack(struct task_struct *t, unsigned long *sp,
+			      struct pt_regs *regs);
 
 static int printbinary(char *buf, unsigned long x, int nbits)
 {
@@ -186,8 +186,8 @@ static void do_show_stack(struct unwind_frame_info *info)
 	printk("\n");
 }
 
-void parisc_show_stack(struct task_struct *task, unsigned long *sp,
-	struct pt_regs *regs)
+static void parisc_show_stack(struct task_struct *task, unsigned long *sp,
+			      struct pt_regs *regs)
 {
 	struct unwind_frame_info info;
 	struct task_struct *t;
@@ -297,11 +297,6 @@ KERN_CRIT "                     ||     ||\n");
 	do_exit(SIGSEGV);
 }
 
-int syscall_ipi(int (*syscall) (struct pt_regs *), struct pt_regs *regs)
-{
-	return syscall(regs);
-}
-
 /* gdb uses break 4,8 */
 #define GDB_BREAK_INSN 0x10004
 static void handle_gdb_break(struct pt_regs *regs, int wot)
@@ -354,7 +349,7 @@ static void default_trap(int code, struct pt_regs *regs)
 void (*cpu_lpmc) (int code, struct pt_regs *regs) __read_mostly = default_trap;
 
 
-void transfer_pim_to_trap_frame(struct pt_regs *regs)
+static void transfer_pim_to_trap_frame(struct pt_regs *regs)
 {
     register int i;
     extern unsigned int hpmc_pim_data[];
@@ -820,7 +815,7 @@ void handle_interruption(int code, struct pt_regs *regs)
 }
 
 
-int __init check_ivt(void *iva)
+static int __init check_ivt(void *iva)
 {
 	extern const u32 os_hpmc[];
 	extern const u32 os_hpmc_end[];
diff --git a/include/asm-parisc/cache.h b/include/asm-parisc/cache.h
index 32c2cca..56205d6 100644
--- a/include/asm-parisc/cache.h
+++ b/include/asm-parisc/cache.h
@@ -39,7 +39,6 @@ unsigned long alloc_sid(void);
 struct seq_file;
 extern void show_cache_info(struct seq_file *m);
 
-extern int split_tlb;
 extern int dcache_stride;
 extern int icache_stride;
 extern struct pdc_cache_info cache_info;
diff --git a/include/asm-parisc/parisc-device.h b/include/asm-parisc/parisc-device.h
index 7aa13f2..82436f7 100644
--- a/include/asm-parisc/parisc-device.h
+++ b/include/asm-parisc/parisc-device.h
@@ -59,6 +59,4 @@ parisc_get_drvdata(struct parisc_device *d)
 	return dev_get_drvdata(&d->dev);
 }
 
-extern struct bus_type parisc_bus_type;
-
 #endif /*_ASM_PARISC_PARISC_DEVICE_H_*/

