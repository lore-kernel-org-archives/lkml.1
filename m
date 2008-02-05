Return-Path: <linux-kernel-owner+w=401wt.eu-S1757715AbYBEPpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbYBEPpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYBEPnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:43:24 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:25647 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758680AbYBEPnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:43:17 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 05 Feb 2008 16:43:13 +0100
Message-Id: <1202226193.25021.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 Documentation/DocBook/s390-drivers.tmpl |   21 +-
 arch/s390/Kconfig                       |    8 +
 arch/s390/Kconfig.debug                 |    8 +
 arch/s390/kernel/entry.S                |    7 +-
 arch/s390/kernel/entry64.S              |    7 +-
 arch/s390/kernel/ipl.c                  |   27 +-
 arch/s390/kernel/setup.c                |   14 +-
 arch/s390/kernel/smp.c                  |   13 +-
 arch/s390/kernel/stacktrace.c           |   31 ++-
 arch/s390/kernel/traps.c                |    5 +-
 arch/s390/kernel/vmlinux.lds.S          |    2 +-
 arch/s390/mm/init.c                     |   27 ++
 arch/s390/mm/vmem.c                     |    5 +-
 drivers/s390/block/dasd.c               |   19 +-
 drivers/s390/block/dasd_3990_erp.c      |   62 +++-
 drivers/s390/block/dcssblk.c            |    5 +-
 drivers/s390/char/sclp_tty.c            |    2 +-
 drivers/s390/char/sclp_vt220.c          |    2 +-
 drivers/s390/cio/ccwgroup.c             |   12 +
 drivers/s390/cio/chsc.c                 |  147 +++-----
 drivers/s390/cio/device_id.c            |  107 ++++---
 include/asm-s390/bitops.h               |  558 ++++++++++++++----------------
 include/asm-s390/cacheflush.h           |    4 +
 include/asm-s390/ccwgroup.h             |    2 +
 include/asm-s390/pgtable.h              |   12 +-
 25 files changed, 587 insertions(+), 520 deletions(-)

Christian Borntraeger (1):
      [S390] sclp_tty/sclp_vt220: Fix scheduling while atomic

Cornelia Huck (3):
      [S390] cio: Clean up chsc response code handling.
      [S390] cio: Update documentation.
      [S390] cio: Add shutdown callback for ccwgroup.

Heiko Carstens (8):
      [S390] DEBUG_PAGEALLOC support for s390.
      [S390] Fix linker script.
      [S390] Fix smp_call_function_mask semantics.
      [S390] Fix couple of section mismatches.
      [S390] Implement ext2_find_next_bit.
      [S390] latencytop s390 support.
      [S390] Remove BUILD_BUG_ON() in vmem code.
      [S390] dcss: Initialize workqueue before using it.

Martin Schwidefsky (2):
      [S390] Define GENERIC_LOCKBREAK.
      [S390] Cleanup & optimize bitops.

Peter Oberparleiter (2):
      [S390] cio: make sense id procedure work with partial hardware response
      [S390] console: allow vt220 console to be the only console

Stefan Haberland (1):
      [S390] dasd: add ifcc handling

Stefan Weinhuber (1):
      [S390] dasd: fix panic caused by alias device offline

diff --git a/Documentation/DocBook/s390-drivers.tmpl b/Documentation/DocBook/s390-drivers.tmpl
index 3d2f31b..4acc732 100644
--- a/Documentation/DocBook/s390-drivers.tmpl
+++ b/Documentation/DocBook/s390-drivers.tmpl
@@ -59,7 +59,7 @@
    <title>Introduction</title>
   <para>
     This document describes the interfaces available for device drivers that
-    drive s390 based channel attached devices. This includes interfaces for
+    drive s390 based channel attached I/O devices. This includes interfaces for
     interaction with the hardware and interfaces for interacting with the
     common driver core. Those interfaces are provided by the s390 common I/O
     layer.
@@ -86,9 +86,10 @@
 	The ccw bus typically contains the majority of devices available to
 	a s390 system. Named after the channel command word (ccw), the basic
 	command structure used to address its devices, the ccw bus contains
-	so-called channel attached devices. They are addressed via subchannels,
-	visible on the css bus. A device driver, however, will never interact
-	with the subchannel directly, but only via the device on the ccw bus,
+	so-called channel attached devices. They are addressed via I/O
+	subchannels, visible on the css bus. A device driver for
+	channel-attached devices, however, will never interact	with the
+	subchannel directly, but only via the I/O device on the ccw bus,
 	the ccw device.
   </para>
     <sect1 id="channelIO">
@@ -116,7 +117,6 @@
 !Iinclude/asm-s390/ccwdev.h
 !Edrivers/s390/cio/device.c
 !Edrivers/s390/cio/device_ops.c
-!Edrivers/s390/cio/airq.c
     </sect1>
     <sect1 id="cmf">
      <title>The channel-measurement facility</title>
@@ -147,4 +147,15 @@
    </sect1>
   </chapter>
 
+  <chapter id="genericinterfaces">
+   <title>Generic interfaces</title>
+  <para>
+	Some interfaces are available to other drivers that do not necessarily
+	have anything to do with the busses described above, but still are
+	indirectly using basic infrastructure in the common I/O layer.
+	One example is the support for adapter interrupts.
+  </para>
+!Edrivers/s390/cio/airq.c
+  </chapter>
+
 </book>
diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 82cbffd..92a4f7b 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -16,6 +16,9 @@ config LOCKDEP_SUPPORT
 config STACKTRACE_SUPPORT
 	def_bool y
 
+config HAVE_LATENCYTOP_SUPPORT
+	def_bool y
+
 config RWSEM_GENERIC_SPINLOCK
 	bool
 
@@ -47,6 +50,11 @@ config NO_IOMEM
 config NO_DMA
 	def_bool y
 
+config GENERIC_LOCKBREAK
+	bool
+	default y
+	depends on SMP && PREEMPT
+
 mainmenu "Linux Kernel Configuration"
 
 config S390
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index 2283933..4599fa0 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -6,4 +6,12 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
+config DEBUG_PAGEALLOC
+	bool "Debug page memory allocations"
+	depends on DEBUG_KERNEL
+	help
+	  Unmap pages from the kernel linear mapping after free_pages().
+	  This results in a slowdown, but helps to find certain types of
+	  memory corruptions.
+
 endmenu
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 1a6dac8..6766e37 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -11,6 +11,7 @@
 
 #include <linux/sys.h>
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/cache.h>
 #include <asm/lowcore.h>
 #include <asm/errno.h>
@@ -830,9 +831,7 @@ mcck_return:
  * Restart interruption handler, kick starter for additional CPUs
  */
 #ifdef CONFIG_SMP
-#ifndef CONFIG_HOTPLUG_CPU
-	.section .init.text,"ax"
-#endif
+	__CPUINIT
 	.globl restart_int_handler
 restart_int_handler:
 	l	%r15,__LC_SAVE_AREA+60	# load ksp
@@ -845,9 +844,7 @@ restart_int_handler:
 	br	%r14			# branch to start_secondary
 restart_addr:
 	.long	start_secondary
-#ifndef CONFIG_HOTPLUG_CPU
 	.previous
-#endif
 #else
 /*
  * If we do not run with SMP enabled, let the new CPU crash ...
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index a3e47b8..efde6e1 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -11,6 +11,7 @@
 
 #include <linux/sys.h>
 #include <linux/linkage.h>
+#include <linux/init.h>
 #include <asm/cache.h>
 #include <asm/lowcore.h>
 #include <asm/errno.h>
@@ -801,9 +802,7 @@ mcck_return:
  * Restart interruption handler, kick starter for additional CPUs
  */
 #ifdef CONFIG_SMP
-#ifndef CONFIG_HOTPLUG_CPU
-	.section .init.text,"ax"
-#endif
+	__CPUINIT
 	.globl restart_int_handler
 restart_int_handler:
 	lg	%r15,__LC_SAVE_AREA+120 # load ksp
@@ -814,9 +813,7 @@ restart_int_handler:
 	lmg	%r6,%r15,__SF_GPRS(%r15) # load registers from clone
 	stosm	__SF_EMPTY(%r15),0x04	# now we can turn dat on
 	jg	start_secondary
-#ifndef CONFIG_HOTPLUG_CPU
 	.previous
-#endif
 #else
 /*
  * If we do not run with SMP enabled, let the new CPU crash ...
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index db28cca..60acdc2 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -439,7 +439,7 @@ static void ipl_run(struct shutdown_trigger *trigger)
 		reipl_ccw_dev(&ipl_info.data.ccw.dev_id);
 }
 
-static int ipl_init(void)
+static int __init ipl_init(void)
 {
 	int rc;
 
@@ -471,8 +471,11 @@ out:
 	return 0;
 }
 
-static struct shutdown_action ipl_action = {SHUTDOWN_ACTION_IPL_STR, ipl_run,
-					    ipl_init};
+static struct shutdown_action __refdata ipl_action = {
+	.name	= SHUTDOWN_ACTION_IPL_STR,
+	.fn	= ipl_run,
+	.init	= ipl_init,
+};
 
 /*
  * reipl shutdown action: Reboot Linux on shutdown.
@@ -792,7 +795,7 @@ static int __init reipl_fcp_init(void)
 	return 0;
 }
 
-static int reipl_init(void)
+static int __init reipl_init(void)
 {
 	int rc;
 
@@ -819,8 +822,11 @@ static int reipl_init(void)
 	return 0;
 }
 
-static struct shutdown_action reipl_action = {SHUTDOWN_ACTION_REIPL_STR,
-					      reipl_run, reipl_init};
+static struct shutdown_action __refdata reipl_action = {
+	.name	= SHUTDOWN_ACTION_REIPL_STR,
+	.fn	= reipl_run,
+	.init	= reipl_init,
+};
 
 /*
  * dump shutdown action: Dump Linux on shutdown.
@@ -998,7 +1004,7 @@ static int __init dump_fcp_init(void)
 	return 0;
 }
 
-static int dump_init(void)
+static int __init dump_init(void)
 {
 	int rc;
 
@@ -1020,8 +1026,11 @@ static int dump_init(void)
 	return 0;
 }
 
-static struct shutdown_action dump_action = {SHUTDOWN_ACTION_DUMP_STR,
-					     dump_run, dump_init};
+static struct shutdown_action __refdata dump_action = {
+	.name	= SHUTDOWN_ACTION_DUMP_STR,
+	.fn	= dump_run,
+	.init	= dump_init,
+};
 
 /*
  * vmcmd shutdown action: Trigger vm command on shutdown.
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 766c783..29ae165 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -77,7 +77,7 @@ unsigned long machine_flags = 0;
 unsigned long elf_hwcap = 0;
 char elf_platform[ELF_PLATFORM_SIZE];
 
-struct mem_chunk __initdata memory_chunk[MEMORY_CHUNKS];
+struct mem_chunk __meminitdata memory_chunk[MEMORY_CHUNKS];
 volatile int __cpu_logical_map[NR_CPUS]; /* logical cpu to cpu address */
 static unsigned long __initdata memory_end;
 
@@ -145,7 +145,7 @@ __setup("condev=", condev_setup);
 
 static int __init conmode_setup(char *str)
 {
-#if defined(CONFIG_SCLP_CONSOLE)
+#if defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 	if (strncmp(str, "hwc", 4) == 0 || strncmp(str, "sclp", 5) == 0)
                 SET_CONSOLE_SCLP;
 #endif
@@ -183,7 +183,7 @@ static void __init conmode_default(void)
 		 */
 		cpcmd("TERM CONMODE 3215", NULL, 0, NULL);
 		if (ptr == NULL) {
-#if defined(CONFIG_SCLP_CONSOLE)
+#if defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 			SET_CONSOLE_SCLP;
 #endif
 			return;
@@ -193,7 +193,7 @@ static void __init conmode_default(void)
 			SET_CONSOLE_3270;
 #elif defined(CONFIG_TN3215_CONSOLE)
 			SET_CONSOLE_3215;
-#elif defined(CONFIG_SCLP_CONSOLE)
+#elif defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 			SET_CONSOLE_SCLP;
 #endif
 		} else if (strncmp(ptr + 8, "3215", 4) == 0) {
@@ -201,7 +201,7 @@ static void __init conmode_default(void)
 			SET_CONSOLE_3215;
 #elif defined(CONFIG_TN3270_CONSOLE)
 			SET_CONSOLE_3270;
-#elif defined(CONFIG_SCLP_CONSOLE)
+#elif defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 			SET_CONSOLE_SCLP;
 #endif
 		}
@@ -212,7 +212,7 @@ static void __init conmode_default(void)
 		SET_CONSOLE_3270;
 #endif
 	} else {
-#if defined(CONFIG_SCLP_CONSOLE)
+#if defined(CONFIG_SCLP_CONSOLE) || defined(CONFIG_SCLP_VT220_CONSOLE)
 		SET_CONSOLE_SCLP;
 #endif
 	}
@@ -528,7 +528,7 @@ static void __init setup_memory_end(void)
 	memory_size = 0;
 	memory_end &= PAGE_MASK;
 
-	max_mem = memory_end ? min(VMALLOC_START, memory_end) : VMALLOC_START;
+	max_mem = memory_end ? min(VMEM_MAX_PHYS, memory_end) : VMEM_MAX_PHYS;
 	memory_end = min(max_mem, memory_end);
 
 	/*
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index aa37fa1..8506065 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -225,12 +225,11 @@ EXPORT_SYMBOL(smp_call_function_single);
  * You must not call this function with disabled interrupts or from a
  * hardware interrupt handler or from a bottom half handler.
  */
-int
-smp_call_function_mask(cpumask_t mask,
-			void (*func)(void *), void *info,
-			int wait)
+int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
+			   int wait)
 {
 	preempt_disable();
+	cpu_clear(smp_processor_id(), mask);
 	__smp_call_function_map(func, info, 0, wait, mask);
 	preempt_enable();
 	return 0;
@@ -1008,7 +1007,7 @@ static struct notifier_block __cpuinitdata smp_cpu_nb = {
 	.notifier_call = smp_cpu_notify,
 };
 
-static int smp_add_present_cpu(int cpu)
+static int __devinit smp_add_present_cpu(int cpu)
 {
 	struct cpu *c = &per_cpu(cpu_devices, cpu);
 	struct sys_device *s = &c->sysdev;
@@ -1036,8 +1035,8 @@ out:
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-static ssize_t rescan_store(struct sys_device *dev, const char *buf,
-			    size_t count)
+static ssize_t __ref rescan_store(struct sys_device *dev,
+				  const char *buf, size_t count)
 {
 	cpumask_t newcpus;
 	int cpu;
diff --git a/arch/s390/kernel/stacktrace.c b/arch/s390/kernel/stacktrace.c
index da69247..85e46a5 100644
--- a/arch/s390/kernel/stacktrace.c
+++ b/arch/s390/kernel/stacktrace.c
@@ -14,7 +14,8 @@
 static unsigned long save_context_stack(struct stack_trace *trace,
 					unsigned long sp,
 					unsigned long low,
-					unsigned long high)
+					unsigned long high,
+					int savesched)
 {
 	struct stack_frame *sf;
 	struct pt_regs *regs;
@@ -47,10 +48,12 @@ static unsigned long save_context_stack(struct stack_trace *trace,
 			return sp;
 		regs = (struct pt_regs *)sp;
 		addr = regs->psw.addr & PSW_ADDR_INSN;
-		if (!trace->skip)
-			trace->entries[trace->nr_entries++] = addr;
-		else
-			trace->skip--;
+		if (savesched || !in_sched_functions(addr)) {
+			if (!trace->skip)
+				trace->entries[trace->nr_entries++] = addr;
+			else
+				trace->skip--;
+		}
 		if (trace->nr_entries >= trace->max_entries)
 			return sp;
 		low = sp;
@@ -66,15 +69,27 @@ void save_stack_trace(struct stack_trace *trace)
 	orig_sp = sp & PSW_ADDR_INSN;
 	new_sp = save_context_stack(trace, orig_sp,
 				    S390_lowcore.panic_stack - PAGE_SIZE,
-				    S390_lowcore.panic_stack);
+				    S390_lowcore.panic_stack, 1);
 	if (new_sp != orig_sp)
 		return;
 	new_sp = save_context_stack(trace, new_sp,
 				    S390_lowcore.async_stack - ASYNC_SIZE,
-				    S390_lowcore.async_stack);
+				    S390_lowcore.async_stack, 1);
 	if (new_sp != orig_sp)
 		return;
 	save_context_stack(trace, new_sp,
 			   S390_lowcore.thread_info,
-			   S390_lowcore.thread_info + THREAD_SIZE);
+			   S390_lowcore.thread_info + THREAD_SIZE, 1);
+}
+
+void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	unsigned long sp, low, high;
+
+	sp = tsk->thread.ksp & PSW_ADDR_INSN;
+	low = (unsigned long) task_stack_page(tsk);
+	high = (unsigned long) task_pt_regs(tsk);
+	save_context_stack(trace, sp, low, high, 0);
+	if (trace->nr_entries < trace->max_entries)
+		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index 52b8342..1a2fdb6 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -271,7 +271,10 @@ void die(const char * str, struct pt_regs * regs, long err)
 	printk("PREEMPT ");
 #endif
 #ifdef CONFIG_SMP
-	printk("SMP");
+	printk("SMP ");
+#endif
+#ifdef CONFIG_DEBUG_PAGEALLOC
+	printk("DEBUG_PAGEALLOC");
 #endif
 	printk("\n");
 	notify_die(DIE_OOPS, str, regs, err, current->thread.trap_no, SIGSEGV);
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 7d43c3c..b460715 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -35,7 +35,7 @@ SECTIONS
 		KPROBES_TEXT
 		*(.fixup)
 		*(.gnu.warning)
-	} = 0x0700
+	} :text = 0x0700
 
 	_etext = .;		/* End of text section */
 
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index b234bb4..983ec6e 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -167,6 +167,33 @@ void __init mem_init(void)
 	       PFN_ALIGN((unsigned long)&_eshared) - 1);
 }
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+void kernel_map_pages(struct page *page, int numpages, int enable)
+{
+	pgd_t *pgd;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	unsigned long address;
+	int i;
+
+	for (i = 0; i < numpages; i++) {
+		address = page_to_phys(page + i);
+		pgd = pgd_offset_k(address);
+		pud = pud_offset(pgd, address);
+		pmd = pmd_offset(pud, address);
+		pte = pte_offset_kernel(pmd, address);
+		if (!enable) {
+			ptep_invalidate(address, pte);
+			continue;
+		}
+		*pte = mk_pte_phys(address, __pgprot(_PAGE_TYPE_RW));
+		/* Flush cpu write queue. */
+		mb();
+	}
+}
+#endif
+
 void free_initmem(void)
 {
         unsigned long addr;
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 79d13a1..7c1287c 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -62,7 +62,7 @@ void __meminit memmap_init(unsigned long size, int nid, unsigned long zone,
 	}
 }
 
-static void __init_refok *vmem_alloc_pages(unsigned int order)
+static void __ref *vmem_alloc_pages(unsigned int order)
 {
 	if (slab_is_available())
 		return (void *)__get_free_pages(GFP_KERNEL, order);
@@ -250,7 +250,7 @@ static int insert_memory_segment(struct memory_segment *seg)
 {
 	struct memory_segment *tmp;
 
-	if (seg->start + seg->size >= VMALLOC_START ||
+	if (seg->start + seg->size >= VMEM_MAX_PHYS ||
 	    seg->start + seg->size < seg->start)
 		return -ERANGE;
 
@@ -360,7 +360,6 @@ void __init vmem_map_init(void)
 {
 	int i;
 
-	BUILD_BUG_ON((unsigned long)VMEM_MAP + VMEM_MAP_SIZE > VMEM_MAP_MAX);
 	NODE_DATA(0)->node_mem_map = VMEM_MAP;
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++)
 		vmem_add_mem(memory_chunk[i].addr, memory_chunk[i].size);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index d640427..d984e0f 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1057,12 +1057,11 @@ void dasd_int_handler(struct ccw_device *cdev, unsigned long intparm,
 		if (device->features & DASD_FEATURE_ERPLOG) {
 			dasd_log_sense(cqr, irb);
 		}
-		/* If we have no sense data, or we just don't want complex ERP
-		 * for this request, but if we have retries left, then just
-		 * reset this request and retry it in the fastpath
+		/*
+		 * If we don't want complex ERP for this request, then just
+		 * reset this and retry it in the fastpath
 		 */
-		if (!(cqr->irb.esw.esw0.erw.cons &&
-		      test_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags)) &&
+		if (!test_bit(DASD_CQR_FLAGS_USE_ERP, &cqr->flags) &&
 		    cqr->retries > 0) {
 			DEV_MESSAGE(KERN_DEBUG, device,
 				    "default ERP in fastpath (%i retries left)",
@@ -1707,7 +1706,7 @@ static void __dasd_cleanup_cqr(struct dasd_ccw_req *cqr)
 
 	req = (struct request *) cqr->callback_data;
 	dasd_profile_end(cqr->block, cqr, req);
-	status = cqr->memdev->discipline->free_cp(cqr, req);
+	status = cqr->block->base->discipline->free_cp(cqr, req);
 	if (status <= 0)
 		error = status ? status : -EIO;
 	dasd_end_request(req, error);
@@ -1742,12 +1741,8 @@ restart:
 
 		/*  Process requests that may be recovered */
 		if (cqr->status == DASD_CQR_NEED_ERP) {
-			if (cqr->irb.esw.esw0.erw.cons &&
-			    test_bit(DASD_CQR_FLAGS_USE_ERP,
-				     &cqr->flags)) {
-				erp_fn = base->discipline->erp_action(cqr);
-				erp_fn(cqr);
-			}
+			erp_fn = base->discipline->erp_action(cqr);
+			erp_fn(cqr);
 			goto restart;
 		}
 
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index c361ab6..f69714a 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -164,7 +164,7 @@ dasd_3990_erp_alternate_path(struct dasd_ccw_req * erp)
 
 		/* reset status to submit the request again... */
 		erp->status = DASD_CQR_FILLED;
-		erp->retries = 1;
+		erp->retries = 10;
 	} else {
 		DEV_MESSAGE(KERN_ERR, device,
 			    "No alternate channel path left (lpum=%x / "
@@ -301,8 +301,7 @@ dasd_3990_erp_action_4(struct dasd_ccw_req * erp, char *sense)
 		erp->function = dasd_3990_erp_action_4;
 
 	} else {
-
-		if (sense[25] == 0x1D) {	/* state change pending */
+		if (sense && (sense[25] == 0x1D)) { /* state change pending */
 
 			DEV_MESSAGE(KERN_INFO, device,
 				    "waiting for state change pending "
@@ -311,7 +310,7 @@ dasd_3990_erp_action_4(struct dasd_ccw_req * erp, char *sense)
 
 			dasd_3990_erp_block_queue(erp, 30*HZ);
 
-                } else if (sense[25] == 0x1E) {	/* busy */
+		} else if (sense && (sense[25] == 0x1E)) {	/* busy */
 			DEV_MESSAGE(KERN_INFO, device,
 				    "busy - redriving request later, "
 				    "%d retries left",
@@ -2120,6 +2119,34 @@ dasd_3990_erp_inspect_32(struct dasd_ccw_req * erp, char *sense)
  */
 
 /*
+ * DASD_3990_ERP_CONTROL_CHECK
+ *
+ * DESCRIPTION
+ *   Does a generic inspection if a control check occured and sets up
+ *   the related error recovery procedure
+ *
+ * PARAMETER
+ *   erp		pointer to the currently created default ERP
+ *
+ * RETURN VALUES
+ *   erp_filled		pointer to the erp
+ */
+
+static struct dasd_ccw_req *
+dasd_3990_erp_control_check(struct dasd_ccw_req *erp)
+{
+	struct dasd_device *device = erp->startdev;
+
+	if (erp->refers->irb.scsw.cstat & (SCHN_STAT_INTF_CTRL_CHK
+					   | SCHN_STAT_CHN_CTRL_CHK)) {
+		DEV_MESSAGE(KERN_DEBUG, device, "%s",
+			    "channel or interface control check");
+		erp = dasd_3990_erp_action_4(erp, NULL);
+	}
+	return erp;
+}
+
+/*
  * DASD_3990_ERP_INSPECT
  *
  * DESCRIPTION
@@ -2145,8 +2172,11 @@ dasd_3990_erp_inspect(struct dasd_ccw_req * erp)
 	if (erp_new)
 		return erp_new;
 
+	/* check if no concurrent sens is available */
+	if (!erp->refers->irb.esw.esw0.erw.cons)
+		erp_new = dasd_3990_erp_control_check(erp);
 	/* distinguish between 24 and 32 byte sense data */
-	if (sense[27] & DASD_SENSE_BIT_0) {
+	else if (sense[27] & DASD_SENSE_BIT_0) {
 
 		/* inspect the 24 byte sense data */
 		erp_new = dasd_3990_erp_inspect_24(erp, sense);
@@ -2285,6 +2315,17 @@ dasd_3990_erp_error_match(struct dasd_ccw_req *cqr1, struct dasd_ccw_req *cqr2)
 		//	return 0;	/* CCW doesn't match */
 	}
 
+	if (cqr1->irb.esw.esw0.erw.cons != cqr2->irb.esw.esw0.erw.cons)
+		return 0;
+
+	if ((cqr1->irb.esw.esw0.erw.cons == 0) &&
+	    (cqr2->irb.esw.esw0.erw.cons == 0))	{
+		if ((cqr1->irb.scsw.cstat & (SCHN_STAT_INTF_CTRL_CHK |
+					     SCHN_STAT_CHN_CTRL_CHK)) ==
+		    (cqr2->irb.scsw.cstat & (SCHN_STAT_INTF_CTRL_CHK |
+					     SCHN_STAT_CHN_CTRL_CHK)))
+			return 1; /* match with ifcc*/
+	}
 	/* check sense data; byte 0-2,25,27 */
 	if (!((memcmp (cqr1->irb.ecw, cqr2->irb.ecw, 3) == 0) &&
 	      (cqr1->irb.ecw[27] == cqr2->irb.ecw[27]) &&
@@ -2560,17 +2601,6 @@ dasd_3990_erp_action(struct dasd_ccw_req * cqr)
 
 		return cqr;
 	}
-	/* check if sense data are available */
-	if (!cqr->irb.ecw) {
-		DEV_MESSAGE(KERN_DEBUG, device,
-			    "ERP called witout sense data avail ..."
-			    "request %p - NO ERP possible", cqr);
-
-		cqr->status = DASD_CQR_FAILED;
-
-		return cqr;
-
-	}
 
 	/* check if error happened before */
 	erp = dasd_3990_erp_in_erp(cqr);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 7779bfc..3faf053 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -415,6 +415,8 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->queue = dev_info->dcssblk_queue;
 	dev_info->gd->private_data = dev_info;
 	dev_info->gd->driverfs_dev = &dev_info->dev;
+	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
+	blk_queue_hardsect_size(dev_info->dcssblk_queue, 4096);
 	/*
 	 * load the segment
 	 */
@@ -472,9 +474,6 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	if (rc)
 		goto unregister_dev;
 
-	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
-	blk_queue_hardsect_size(dev_info->dcssblk_queue, 4096);
-
 	add_disk(dev_info->gd);
 
 	switch (dev_info->segment_type) {
diff --git a/drivers/s390/char/sclp_tty.c b/drivers/s390/char/sclp_tty.c
index e3b3d39..2e616e3 100644
--- a/drivers/s390/char/sclp_tty.c
+++ b/drivers/s390/char/sclp_tty.c
@@ -332,7 +332,7 @@ sclp_tty_write_string(const unsigned char *str, int count)
 		if (sclp_ttybuf == NULL) {
 			while (list_empty(&sclp_tty_pages)) {
 				spin_unlock_irqrestore(&sclp_tty_lock, flags);
-				if (in_interrupt())
+				if (in_atomic())
 					sclp_sync_wait();
 				else
 					wait_event(sclp_tty_waitq,
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 40cd21b..6807162 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -400,7 +400,7 @@ __sclp_vt220_write(const unsigned char *buf, int count, int do_schedule,
 			while (list_empty(&sclp_vt220_empty)) {
 				spin_unlock_irqrestore(&sclp_vt220_lock,
 						       flags);
-				if (in_interrupt())
+				if (in_atomic())
 					sclp_sync_wait();
 				else
 					wait_event(sclp_vt220_waitq,
diff --git a/drivers/s390/cio/ccwgroup.c b/drivers/s390/cio/ccwgroup.c
index 3964056..03914fa 100644
--- a/drivers/s390/cio/ccwgroup.c
+++ b/drivers/s390/cio/ccwgroup.c
@@ -391,12 +391,24 @@ ccwgroup_remove (struct device *dev)
 	return 0;
 }
 
+static void ccwgroup_shutdown(struct device *dev)
+{
+	struct ccwgroup_device *gdev;
+	struct ccwgroup_driver *gdrv;
+
+	gdev = to_ccwgroupdev(dev);
+	gdrv = to_ccwgroupdrv(dev->driver);
+	if (gdrv && gdrv->shutdown)
+		gdrv->shutdown(gdev);
+}
+
 static struct bus_type ccwgroup_bus_type = {
 	.name   = "ccwgroup",
 	.match  = ccwgroup_bus_match,
 	.uevent = ccwgroup_uevent,
 	.probe  = ccwgroup_probe,
 	.remove = ccwgroup_remove,
+	.shutdown = ccwgroup_shutdown,
 };
 
 /**
diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index e7ba16a..007aaeb 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -26,6 +26,25 @@
 
 static void *sei_page;
 
+static int chsc_error_from_response(int response)
+{
+	switch (response) {
+	case 0x0001:
+		return 0;
+	case 0x0002:
+	case 0x0003:
+	case 0x0006:
+	case 0x0007:
+	case 0x0008:
+	case 0x000a:
+		return -EINVAL;
+	case 0x0004:
+		return -EOPNOTSUPP;
+	default:
+		return -EIO;
+	}
+}
+
 struct chsc_ssd_area {
 	struct chsc_header request;
 	u16 :10;
@@ -75,11 +94,11 @@ int chsc_get_ssd_info(struct subchannel_id schid, struct chsc_ssd_info *ssd)
 		ret = (ccode == 3) ? -ENODEV : -EBUSY;
 		goto out_free;
 	}
-	if (ssd_area->response.code != 0x0001) {
+	ret = chsc_error_from_response(ssd_area->response.code);
+	if (ret != 0) {
 		CIO_MSG_EVENT(2, "chsc: ssd failed for 0.%x.%04x (rc=%04x)\n",
 			      schid.ssid, schid.sch_no,
 			      ssd_area->response.code);
-		ret = -EIO;
 		goto out_free;
 	}
 	if (!ssd_area->sch_valid) {
@@ -717,36 +736,15 @@ __chsc_do_secm(struct channel_subsystem *css, int enable, void *page)
 		return (ccode == 3) ? -ENODEV : -EBUSY;
 
 	switch (secm_area->response.code) {
-	case 0x0001: /* Success. */
-		ret = 0;
-		break;
-	case 0x0003: /* Invalid block. */
-	case 0x0007: /* Invalid format. */
-	case 0x0008: /* Other invalid block. */
-		CIO_CRW_EVENT(2, "Error in chsc request block!\n");
-		ret = -EINVAL;
-		break;
-	case 0x0004: /* Command not provided in model. */
-		CIO_CRW_EVENT(2, "Model does not provide secm\n");
-		ret = -EOPNOTSUPP;
-		break;
-	case 0x0102: /* cub adresses incorrect */
-		CIO_CRW_EVENT(2, "Invalid addresses in chsc request block\n");
-		ret = -EINVAL;
-		break;
-	case 0x0103: /* key error */
-		CIO_CRW_EVENT(2, "Access key error in secm\n");
+	case 0x0102:
+	case 0x0103:
 		ret = -EINVAL;
-		break;
-	case 0x0105: /* error while starting */
-		CIO_CRW_EVENT(2, "Error while starting channel measurement\n");
-		ret = -EIO;
-		break;
 	default:
-		CIO_CRW_EVENT(2, "Unknown CHSC response %d\n",
-			      secm_area->response.code);
-		ret = -EIO;
+		ret = chsc_error_from_response(secm_area->response.code);
 	}
+	if (ret != 0)
+		CIO_CRW_EVENT(2, "chsc: secm failed (rc=%04x)\n",
+			      secm_area->response.code);
 	return ret;
 }
 
@@ -827,27 +825,14 @@ int chsc_determine_channel_path_description(struct chp_id chpid,
 		goto out;
 	}
 
-	switch (scpd_area->response.code) {
-	case 0x0001: /* Success. */
+	ret = chsc_error_from_response(scpd_area->response.code);
+	if (ret == 0)
+		/* Success. */
 		memcpy(desc, &scpd_area->desc,
 		       sizeof(struct channel_path_desc));
-		ret = 0;
-		break;
-	case 0x0003: /* Invalid block. */
-	case 0x0007: /* Invalid format. */
-	case 0x0008: /* Other invalid block. */
-		CIO_CRW_EVENT(2, "Error in chsc request block!\n");
-		ret = -EINVAL;
-		break;
-	case 0x0004: /* Command not provided in model. */
-		CIO_CRW_EVENT(2, "Model does not provide scpd\n");
-		ret = -EOPNOTSUPP;
-		break;
-	default:
-		CIO_CRW_EVENT(2, "Unknown CHSC response %d\n",
+	else
+		CIO_CRW_EVENT(2, "chsc: scpd failed (rc=%04x)\n",
 			      scpd_area->response.code);
-		ret = -EIO;
-	}
 out:
 	free_page((unsigned long)scpd_area);
 	return ret;
@@ -923,8 +908,9 @@ int chsc_get_channel_measurement_chars(struct channel_path *chp)
 		goto out;
 	}
 
-	switch (scmc_area->response.code) {
-	case 0x0001: /* Success. */
+	ret = chsc_error_from_response(scmc_area->response.code);
+	if (ret == 0) {
+		/* Success. */
 		if (!scmc_area->not_valid) {
 			chp->cmg = scmc_area->cmg;
 			chp->shared = scmc_area->shared;
@@ -935,22 +921,9 @@ int chsc_get_channel_measurement_chars(struct channel_path *chp)
 			chp->cmg = -1;
 			chp->shared = -1;
 		}
-		ret = 0;
-		break;
-	case 0x0003: /* Invalid block. */
-	case 0x0007: /* Invalid format. */
-	case 0x0008: /* Invalid bit combination. */
-		CIO_CRW_EVENT(2, "Error in chsc request block!\n");
-		ret = -EINVAL;
-		break;
-	case 0x0004: /* Command not provided. */
-		CIO_CRW_EVENT(2, "Model does not provide scmc\n");
-		ret = -EOPNOTSUPP;
-		break;
-	default:
-		CIO_CRW_EVENT(2, "Unknown CHSC response %d\n",
+	} else {
+		CIO_CRW_EVENT(2, "chsc: scmc failed (rc=%04x)\n",
 			      scmc_area->response.code);
-		ret = -EIO;
 	}
 out:
 	free_page((unsigned long)scmc_area);
@@ -1002,21 +975,17 @@ chsc_enable_facility(int operation_code)
 		ret = (ret == 3) ? -ENODEV : -EBUSY;
 		goto out;
 	}
+
 	switch (sda_area->response.code) {
-	case 0x0001: /* everything ok */
-		ret = 0;
-		break;
-	case 0x0003: /* invalid request block */
-	case 0x0007:
-		ret = -EINVAL;
-		break;
-	case 0x0004: /* command not provided */
-	case 0x0101: /* facility not provided */
+	case 0x0101:
 		ret = -EOPNOTSUPP;
 		break;
-	default: /* something went wrong */
-		ret = -EIO;
+	default:
+		ret = chsc_error_from_response(sda_area->response.code);
 	}
+	if (ret != 0)
+		CIO_CRW_EVENT(2, "chsc: sda (oc=%x) failed (rc=%04x)\n",
+			      operation_code, sda_area->response.code);
  out:
 	free_page((unsigned long)sda_area);
 	return ret;
@@ -1041,33 +1010,27 @@ chsc_determine_css_characteristics(void)
 	} __attribute__ ((packed)) *scsc_area;
 
 	scsc_area = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
-	if (!scsc_area) {
-		CIO_MSG_EVENT(0, "Was not able to determine available "
-			      "CHSCs due to no memory.\n");
+	if (!scsc_area)
 		return -ENOMEM;
-	}
 
 	scsc_area->request.length = 0x0010;
 	scsc_area->request.code = 0x0010;
 
 	result = chsc(scsc_area);
 	if (result) {
-		CIO_MSG_EVENT(0, "Was not able to determine available CHSCs, "
-			      "cc=%i.\n", result);
-		result = -EIO;
+		result = (result == 3) ? -ENODEV : -EBUSY;
 		goto exit;
 	}
 
-	if (scsc_area->response.code != 1) {
-		CIO_MSG_EVENT(0, "Was not able to determine "
-			      "available CHSCs.\n");
-		result = -EIO;
-		goto exit;
-	}
-	memcpy(&css_general_characteristics, scsc_area->general_char,
-	       sizeof(css_general_characteristics));
-	memcpy(&css_chsc_characteristics, scsc_area->chsc_char,
-	       sizeof(css_chsc_characteristics));
+	result = chsc_error_from_response(scsc_area->response.code);
+	if (result == 0) {
+		memcpy(&css_general_characteristics, scsc_area->general_char,
+		       sizeof(css_general_characteristics));
+		memcpy(&css_chsc_characteristics, scsc_area->chsc_char,
+		       sizeof(css_chsc_characteristics));
+	} else
+		CIO_CRW_EVENT(2, "chsc: scsc failed (rc=%04x)\n",
+			      scsc_area->response.code);
 exit:
 	free_page ((unsigned long) scsc_area);
 	return result;
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index 918b8b8..dc4d87f 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -26,17 +26,18 @@
 #include "ioasm.h"
 #include "io_sch.h"
 
-/*
- * Input :
- *   devno - device number
- *   ps	   - pointer to sense ID data area
- * Output : none
+/**
+ * vm_vdev_to_cu_type - Convert vm virtual device into control unit type
+ *			for certain devices.
+ * @class: virtual device class
+ * @type: virtual device type
+ *
+ * Returns control unit type if a match was made or %0xffff otherwise.
  */
-static void
-VM_virtual_device_info (__u16 devno, struct senseid *ps)
+static int vm_vdev_to_cu_type(int class, int type)
 {
 	static struct {
-		int vrdcvcla, vrdcvtyp, cu_type;
+		int class, type, cu_type;
 	} vm_devices[] = {
 		{ 0x08, 0x01, 0x3480 },
 		{ 0x08, 0x02, 0x3430 },
@@ -68,8 +69,26 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
 		{ 0x40, 0xc0, 0x5080 },
 		{ 0x80, 0x00, 0x3215 },
 	};
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
+		if (class == vm_devices[i].class && type == vm_devices[i].type)
+			return vm_devices[i].cu_type;
+
+	return 0xffff;
+}
+
+/**
+ * diag_get_dev_info - retrieve device information via DIAG X'210'
+ * @devno: device number
+ * @ps: pointer to sense ID data area
+ *
+ * Returns zero on success, non-zero otherwise.
+ */
+static int diag_get_dev_info(u16 devno, struct senseid *ps)
+{
 	struct diag210 diag_data;
-	int ccode, i;
+	int ccode;
 
 	CIO_TRACE_EVENT (4, "VMvdinf");
 
@@ -79,21 +98,21 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
 	};
 
 	ccode = diag210 (&diag_data);
-	ps->reserved = 0xff;
+	if ((ccode == 0) || (ccode == 2)) {
+		ps->reserved = 0xff;
 
-	/* Special case for bloody osa devices. */
-	if (diag_data.vrdcvcla == 0x02 &&
-	    diag_data.vrdcvtyp == 0x20) {
-		ps->cu_type = 0x3088;
-		ps->cu_model = 0x60;
-		return;
-	}
-	for (i = 0; i < ARRAY_SIZE(vm_devices); i++)
-		if (diag_data.vrdcvcla == vm_devices[i].vrdcvcla &&
-		    diag_data.vrdcvtyp == vm_devices[i].vrdcvtyp) {
-			ps->cu_type = vm_devices[i].cu_type;
-			return;
+		/* Special case for osa devices. */
+		if (diag_data.vrdcvcla == 0x02 && diag_data.vrdcvtyp == 0x20) {
+			ps->cu_type = 0x3088;
+			ps->cu_model = 0x60;
+			return 0;
 		}
+		ps->cu_type = vm_vdev_to_cu_type(diag_data.vrdcvcla,
+						diag_data.vrdcvtyp);
+		if (ps->cu_type != 0xffff)
+			return 0;
+	}
+
 	CIO_MSG_EVENT(0, "DIAG X'210' for device %04X returned (cc = %d):"
 		      "vdev class : %02X, vdev type : %04X \n ...  "
 		      "rdev class : %02X, rdev type : %04X, "
@@ -102,6 +121,8 @@ VM_virtual_device_info (__u16 devno, struct senseid *ps)
 		      diag_data.vrdcvcla, diag_data.vrdcvtyp,
 		      diag_data.vrdcrccl, diag_data.vrdccrty,
 		      diag_data.vrdccrmd);
+
+	return -ENODEV;
 }
 
 /*
@@ -130,6 +151,7 @@ __ccw_device_sense_id_start(struct ccw_device *cdev)
 	/* Try on every path. */
 	ret = -ENODEV;
 	while (cdev->private->imask != 0) {
+		cdev->private->senseid.cu_type = 0xFFFF;
 		if ((sch->opm & cdev->private->imask) != 0 &&
 		    cdev->private->iretry > 0) {
 			cdev->private->iretry--;
@@ -153,7 +175,6 @@ ccw_device_sense_id_start(struct ccw_device *cdev)
 	int ret;
 
 	memset (&cdev->private->senseid, 0, sizeof (struct senseid));
-	cdev->private->senseid.cu_type = 0xFFFF;
 	cdev->private->imask = 0x80;
 	cdev->private->iretry = 5;
 	ret = __ccw_device_sense_id_start(cdev);
@@ -173,13 +194,7 @@ ccw_device_check_sense_id(struct ccw_device *cdev)
 
 	sch = to_subchannel(cdev->dev.parent);
 	irb = &cdev->private->irb;
-	/* Did we get a proper answer ? */
-	if (cdev->private->senseid.cu_type != 0xFFFF && 
-	    cdev->private->senseid.reserved == 0xFF) {
-		if (irb->scsw.count < sizeof (struct senseid) - 8)
-			cdev->private->flags.esid = 1;
-		return 0; /* Success */
-	}
+
 	/* Check the error cases. */
 	if (irb->scsw.fctl & (SCSW_FCTL_HALT_FUNC | SCSW_FCTL_CLEAR_FUNC)) {
 		/* Retry Sense ID if requested. */
@@ -231,6 +246,15 @@ ccw_device_check_sense_id(struct ccw_device *cdev)
 				      sch->schid.ssid, sch->schid.sch_no);
 		return -EACCES;
 	}
+
+	/* Did we get a proper answer ? */
+	if (irb->scsw.cc == 0 && cdev->private->senseid.cu_type != 0xFFFF &&
+	    cdev->private->senseid.reserved == 0xFF) {
+		if (irb->scsw.count < sizeof(struct senseid) - 8)
+			cdev->private->flags.esid = 1;
+		return 0; /* Success */
+	}
+
 	/* Hmm, whatever happened, try again. */
 	CIO_MSG_EVENT(2, "SenseID : start_IO() for device %04x on "
 		      "subchannel 0.%x.%04x returns status %02X%02X\n",
@@ -283,20 +307,17 @@ ccw_device_sense_id_irq(struct ccw_device *cdev, enum dev_event dev_event)
 			break;
 		/* fall through. */
 	default:		/* Sense ID failed. Try asking VM. */
-		if (MACHINE_IS_VM) {
-			VM_virtual_device_info (cdev->private->dev_id.devno,
+		if (MACHINE_IS_VM)
+			ret = diag_get_dev_info(cdev->private->dev_id.devno,
 						&cdev->private->senseid);
-			if (cdev->private->senseid.cu_type != 0xFFFF) {
-				/* Got the device information from VM. */
-				ccw_device_sense_id_done(cdev, 0);
-				return;
-			}
-		}
-		/*
-		 * If we can't couldn't identify the device type we
-		 *  consider the device "not operational".
-		 */
-		ccw_device_sense_id_done(cdev, -ENODEV);
+		else
+			/*
+			 * If we can't couldn't identify the device type we
+			 *  consider the device "not operational".
+			 */
+			ret = -ENODEV;
+
+		ccw_device_sense_id_done(cdev, ret);
 		break;
 	}
 }
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index dba6fec..882db05 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -440,242 +440,256 @@ __constant_test_bit(unsigned long nr, const volatile unsigned long *addr) {
  __test_bit((nr),(addr)) )
 
 /*
- * ffz = Find First Zero in word. Undefined if no zero exists,
- * so code should check against ~0UL first..
+ * Optimized find bit helper functions.
  */
-static inline unsigned long ffz(unsigned long word)
+
+/**
+ * __ffz_word_loop - find byte offset of first long != -1UL
+ * @addr: pointer to array of unsigned long
+ * @size: size of the array in bits
+ */
+static inline unsigned long __ffz_word_loop(const unsigned long *addr,
+					    unsigned long size)
 {
-        unsigned long bit = 0;
+	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
+	unsigned long bytes = 0;
 
+	asm volatile(
+#ifndef __s390x__
+		"	ahi	%1,31\n"
+		"	srl	%1,5\n"
+		"0:	c	%2,0(%0,%3)\n"
+		"	jne	1f\n"
+		"	la	%0,4(%0)\n"
+		"	brct	%1,0b\n"
+		"1:\n"
+#else
+		"	aghi	%1,63\n"
+		"	srlg	%1,%1,6\n"
+		"0:	cg	%2,0(%0,%3)\n"
+		"	jne	1f\n"
+		"	la	%0,8(%0)\n"
+		"	brct	%1,0b\n"
+		"1:\n"
+#endif
+		: "+a" (bytes), "+d" (size)
+		: "d" (-1UL), "a" (addr), "m" (*(addrtype *) addr)
+		: "cc" );
+	return bytes;
+}
+
+/**
+ * __ffs_word_loop - find byte offset of first long != 0UL
+ * @addr: pointer to array of unsigned long
+ * @size: size of the array in bits
+ */
+static inline unsigned long __ffs_word_loop(const unsigned long *addr,
+					    unsigned long size)
+{
+	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
+	unsigned long bytes = 0;
+
+	asm volatile(
+#ifndef __s390x__
+		"	ahi	%1,31\n"
+		"	srl	%1,5\n"
+		"0:	c	%2,0(%0,%3)\n"
+		"	jne	1f\n"
+		"	la	%0,4(%0)\n"
+		"	brct	%1,0b\n"
+		"1:\n"
+#else
+		"	aghi	%1,63\n"
+		"	srlg	%1,%1,6\n"
+		"0:	cg	%2,0(%0,%3)\n"
+		"	jne	1f\n"
+		"	la	%0,8(%0)\n"
+		"	brct	%1,0b\n"
+		"1:\n"
+#endif
+		: "+a" (bytes), "+a" (size)
+		: "d" (0UL), "a" (addr), "m" (*(addrtype *) addr)
+		: "cc" );
+	return bytes;
+}
+
+/**
+ * __ffz_word - add number of the first unset bit
+ * @nr: base value the bit number is added to
+ * @word: the word that is searched for unset bits
+ */
+static inline unsigned long __ffz_word(unsigned long nr, unsigned long word)
+{
 #ifdef __s390x__
 	if (likely((word & 0xffffffff) == 0xffffffff)) {
 		word >>= 32;
-		bit += 32;
+		nr += 32;
 	}
 #endif
 	if (likely((word & 0xffff) == 0xffff)) {
 		word >>= 16;
-		bit += 16;
+		nr += 16;
 	}
 	if (likely((word & 0xff) == 0xff)) {
 		word >>= 8;
-		bit += 8;
+		nr += 8;
 	}
-	return bit + _zb_findmap[word & 0xff];
+	return nr + _zb_findmap[(unsigned char) word];
 }
 
-/*
- * __ffs = find first bit in word. Undefined if no bit exists,
- * so code should check against 0UL first..
+/**
+ * __ffs_word - add number of the first set bit
+ * @nr: base value the bit number is added to
+ * @word: the word that is searched for set bits
  */
-static inline unsigned long __ffs (unsigned long word)
+static inline unsigned long __ffs_word(unsigned long nr, unsigned long word)
 {
-	unsigned long bit = 0;
-
 #ifdef __s390x__
 	if (likely((word & 0xffffffff) == 0)) {
 		word >>= 32;
-		bit += 32;
+		nr += 32;
 	}
 #endif
 	if (likely((word & 0xffff) == 0)) {
 		word >>= 16;
-		bit += 16;
+		nr += 16;
 	}
 	if (likely((word & 0xff) == 0)) {
 		word >>= 8;
-		bit += 8;
+		nr += 8;
 	}
-	return bit + _sb_findmap[word & 0xff];
+	return nr + _sb_findmap[(unsigned char) word];
 }
 
-/*
- * Find-bit routines..
- */
 
-#ifndef __s390x__
+/**
+ * __load_ulong_be - load big endian unsigned long
+ * @p: pointer to array of unsigned long
+ * @offset: byte offset of source value in the array
+ */
+static inline unsigned long __load_ulong_be(const unsigned long *p,
+					    unsigned long offset)
+{
+	p = (unsigned long *)((unsigned long) p + offset);
+	return *p;
+}
 
-static inline int
-find_first_zero_bit(const unsigned long * addr, unsigned long size)
+/**
+ * __load_ulong_le - load little endian unsigned long
+ * @p: pointer to array of unsigned long
+ * @offset: byte offset of source value in the array
+ */
+static inline unsigned long __load_ulong_le(const unsigned long *p,
+					    unsigned long offset)
 {
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-	unsigned long cmp, count;
-        unsigned int res;
+	unsigned long word;
 
-        if (!size)
-                return 0;
+	p = (unsigned long *)((unsigned long) p + offset);
+#ifndef __s390x__
 	asm volatile(
-		"	lhi	%1,-1\n"
-		"	lr	%2,%3\n"
-		"	slr	%0,%0\n"
-		"	ahi	%2,31\n"
-		"	srl	%2,5\n"
-		"0:	c	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	la	%0,4(%0)\n"
-		"	brct	%2,0b\n"
-		"	lr	%0,%3\n"
-		"	j	4f\n"
-		"1:	l	%2,0(%0,%4)\n"
-		"	sll	%0,3\n"
-		"	lhi	%1,0xff\n"
-		"	tml	%2,0xffff\n"
-		"	jno	2f\n"
-		"	ahi	%0,16\n"
-		"	srl	%2,16\n"
-		"2:	tml	%2,0x00ff\n"
-		"	jno	3f\n"
-		"	ahi	%0,8\n"
-		"	srl	%2,8\n"
-		"3:	nr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	alr	%0,%2\n"
-		"4:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (addr), "a" (&_zb_findmap),
-		  "m" (*(addrtype *) addr) : "cc");
-        return (res < size) ? res : size;
+		"	ic	%0,0(%1)\n"
+		"	icm	%0,2,1(%1)\n"
+		"	icm	%0,4,2(%1)\n"
+		"	icm	%0,8,3(%1)"
+		: "=&d" (word) : "a" (p), "m" (*p) : "cc");
+#else
+	asm volatile(
+		"	lrvg	%0,%1"
+		: "=d" (word) : "m" (*p) );
+#endif
+	return word;
 }
 
-static inline int
-find_first_bit(const unsigned long * addr, unsigned long size)
+/*
+ * The various find bit functions.
+ */
+
+/*
+ * ffz - find first zero in word.
+ * @word: The word to search
+ *
+ * Undefined if no zero exists, so code should check against ~0UL first.
+ */
+static inline unsigned long ffz(unsigned long word)
 {
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-	unsigned long cmp, count;
-        unsigned int res;
+	return __ffz_word(0, word);
+}
 
-        if (!size)
-                return 0;
-	asm volatile(
-		"	slr	%1,%1\n"
-		"	lr	%2,%3\n"
-		"	slr	%0,%0\n"
-		"	ahi	%2,31\n"
-		"	srl	%2,5\n"
-		"0:	c	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	la	%0,4(%0)\n"
-		"	brct	%2,0b\n"
-		"	lr	%0,%3\n"
-		"	j	4f\n"
-		"1:	l	%2,0(%0,%4)\n"
-		"	sll	%0,3\n"
-		"	lhi	%1,0xff\n"
-		"	tml	%2,0xffff\n"
-		"	jnz	2f\n"
-		"	ahi	%0,16\n"
-		"	srl	%2,16\n"
-		"2:	tml	%2,0x00ff\n"
-		"	jnz	3f\n"
-		"	ahi	%0,8\n"
-		"	srl	%2,8\n"
-		"3:	nr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	alr	%0,%2\n"
-		"4:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (addr), "a" (&_sb_findmap),
-		  "m" (*(addrtype *) addr) : "cc");
-        return (res < size) ? res : size;
+/**
+ * __ffs - find first bit in word.
+ * @word: The word to search
+ *
+ * Undefined if no bit exists, so code should check against 0 first.
+ */
+static inline unsigned long __ffs (unsigned long word)
+{
+	return __ffs_word(0, word);
 }
 
-#else /* __s390x__ */
+/**
+ * ffs - find first bit set
+ * @x: the word to search
+ *
+ * This is defined the same way as
+ * the libc and compiler builtin ffs routines, therefore
+ * differs in spirit from the above ffz (man ffs).
+ */
+static inline int ffs(int x)
+{
+	if (!x)
+		return 0;
+	return __ffs_word(1, x);
+}
 
-static inline unsigned long
-find_first_zero_bit(const unsigned long * addr, unsigned long size)
+/**
+ * find_first_zero_bit - find the first zero bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit-number of the first zero bit, not the number of the byte
+ * containing a bit.
+ */
+static inline unsigned long find_first_zero_bit(const unsigned long *addr,
+						unsigned long size)
 {
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-        unsigned long res, cmp, count;
+	unsigned long bytes, bits;
 
         if (!size)
                 return 0;
-	asm volatile(
-		"	lghi	%1,-1\n"
-		"	lgr	%2,%3\n"
-		"	slgr	%0,%0\n"
-		"	aghi	%2,63\n"
-		"	srlg	%2,%2,6\n"
-		"0:	cg	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	la	%0,8(%0)\n"
-		"	brct	%2,0b\n"
-		"	lgr	%0,%3\n"
-		"	j	5f\n"
-		"1:	lg	%2,0(%0,%4)\n"
-		"	sllg	%0,%0,3\n"
-		"	clr	%2,%1\n"
-		"	jne	2f\n"
-		"	aghi	%0,32\n"
-		"	srlg	%2,%2,32\n"
-		"2:	lghi	%1,0xff\n"
-		"	tmll	%2,0xffff\n"
-		"	jno	3f\n"
-		"	aghi	%0,16\n"
-		"	srl	%2,16\n"
-		"3:	tmll	%2,0x00ff\n"
-		"	jno	4f\n"
-		"	aghi	%0,8\n"
-		"	srl	%2,8\n"
-		"4:	ngr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	algr	%0,%2\n"
-		"5:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (addr), "a" (&_zb_findmap),
-		  "m" (*(addrtype *) addr) : "cc");
-        return (res < size) ? res : size;
-}
-
-static inline unsigned long
-find_first_bit(const unsigned long * addr, unsigned long size)
+	bytes = __ffz_word_loop(addr, size);
+	bits = __ffz_word(bytes*8, __load_ulong_be(addr, bytes));
+	return (bits < size) ? bits : size;
+}
+
+/**
+ * find_first_bit - find the first set bit in a memory region
+ * @addr: The address to start the search at
+ * @size: The maximum size to search
+ *
+ * Returns the bit-number of the first set bit, not the number of the byte
+ * containing a bit.
+ */
+static inline unsigned long find_first_bit(const unsigned long * addr,
+					   unsigned long size)
 {
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-        unsigned long res, cmp, count;
+	unsigned long bytes, bits;
 
         if (!size)
                 return 0;
-	asm volatile(
-		"	slgr	%1,%1\n"
-		"	lgr	%2,%3\n"
-		"	slgr	%0,%0\n"
-		"	aghi	%2,63\n"
-		"	srlg	%2,%2,6\n"
-		"0:	cg	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	aghi	%0,8\n"
-		"	brct	%2,0b\n"
-		"	lgr	%0,%3\n"
-		"	j	5f\n"
-		"1:	lg	%2,0(%0,%4)\n"
-		"	sllg	%0,%0,3\n"
-		"	clr	%2,%1\n"
-		"	jne	2f\n"
-		"	aghi	%0,32\n"
-		"	srlg	%2,%2,32\n"
-		"2:	lghi	%1,0xff\n"
-		"	tmll	%2,0xffff\n"
-		"	jnz	3f\n"
-		"	aghi	%0,16\n"
-		"	srl	%2,16\n"
-		"3:	tmll	%2,0x00ff\n"
-		"	jnz	4f\n"
-		"	aghi	%0,8\n"
-		"	srl	%2,8\n"
-		"4:	ngr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	algr	%0,%2\n"
-		"5:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (addr), "a" (&_sb_findmap),
-		  "m" (*(addrtype *) addr) : "cc");
-        return (res < size) ? res : size;
+	bytes = __ffs_word_loop(addr, size);
+	bits = __ffs_word(bytes*8, __load_ulong_be(addr, bytes));
+	return (bits < size) ? bits : size;
 }
 
-#endif /* __s390x__ */
-
-static inline int
-find_next_zero_bit (const unsigned long * addr, unsigned long size,
-		    unsigned long offset)
+/**
+ * find_next_zero_bit - find the first zero bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The maximum size to search
+ */
+static inline int find_next_zero_bit (const unsigned long * addr,
+				      unsigned long size,
+				      unsigned long offset)
 {
         const unsigned long *p;
 	unsigned long bit, set;
@@ -688,10 +702,10 @@ find_next_zero_bit (const unsigned long * addr, unsigned long size,
 	p = addr + offset / __BITOPS_WORDSIZE;
 	if (bit) {
 		/*
-		 * s390 version of ffz returns __BITOPS_WORDSIZE
+		 * __ffz_word returns __BITOPS_WORDSIZE
 		 * if no zero bit is present in the word.
 		 */
-		set = ffz(*p >> bit) + bit;
+		set = __ffz_word(0, *p >> bit) + bit;
 		if (set >= size)
 			return size + offset;
 		if (set < __BITOPS_WORDSIZE)
@@ -703,9 +717,15 @@ find_next_zero_bit (const unsigned long * addr, unsigned long size,
 	return offset + find_first_zero_bit(p, size);
 }
 
-static inline int
-find_next_bit (const unsigned long * addr, unsigned long size,
-	       unsigned long offset)
+/**
+ * find_next_bit - find the first set bit in a memory region
+ * @addr: The address to base the search on
+ * @offset: The bitnumber to start searching at
+ * @size: The maximum size to search
+ */
+static inline int find_next_bit (const unsigned long * addr,
+				 unsigned long size,
+				 unsigned long offset)
 {
         const unsigned long *p;
 	unsigned long bit, set;
@@ -718,10 +738,10 @@ find_next_bit (const unsigned long * addr, unsigned long size,
 	p = addr + offset / __BITOPS_WORDSIZE;
 	if (bit) {
 		/*
-		 * s390 version of __ffs returns __BITOPS_WORDSIZE
+		 * __ffs_word returns __BITOPS_WORDSIZE
 		 * if no one bit is present in the word.
 		 */
-		set = __ffs(*p & (~0UL << bit));
+		set = __ffs_word(0, *p & (~0UL << bit));
 		if (set >= size)
 			return size + offset;
 		if (set < __BITOPS_WORDSIZE)
@@ -744,8 +764,6 @@ static inline int sched_find_first_bit(unsigned long *b)
 	return find_first_bit(b, 140);
 }
 
-#include <asm-generic/bitops/ffs.h>
-
 #include <asm-generic/bitops/fls.h>
 #include <asm-generic/bitops/fls64.h>
 
@@ -772,108 +790,23 @@ static inline int sched_find_first_bit(unsigned long *b)
 	test_and_clear_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
 #define ext2_test_bit(nr, addr)      \
 	test_bit((nr)^(__BITOPS_WORDSIZE - 8), (unsigned long *)addr)
-#define ext2_find_next_bit(addr, size, off) \
-	generic_find_next_le_bit((unsigned long *)(addr), (size), (off))
 
-#ifndef __s390x__
-
-static inline int 
-ext2_find_first_zero_bit(void *vaddr, unsigned int size)
+static inline int ext2_find_first_zero_bit(void *vaddr, unsigned int size)
 {
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-	unsigned long cmp, count;
-        unsigned int res;
+	unsigned long bytes, bits;
 
         if (!size)
                 return 0;
-	asm volatile(
-		"	lhi	%1,-1\n"
-		"	lr	%2,%3\n"
-		"	ahi	%2,31\n"
-		"	srl	%2,5\n"
-		"	slr	%0,%0\n"
-		"0:	cl	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	ahi	%0,4\n"
-		"	brct	%2,0b\n"
-		"	lr	%0,%3\n"
-		"	j	4f\n"
-		"1:	l	%2,0(%0,%4)\n"
-		"	sll	%0,3\n"
-		"	ahi	%0,24\n"
-		"	lhi	%1,0xff\n"
-		"	tmh	%2,0xffff\n"
-		"	jo	2f\n"
-		"	ahi	%0,-16\n"
-		"	srl	%2,16\n"
-		"2:	tml	%2,0xff00\n"
-		"	jo	3f\n"
-		"	ahi	%0,-8\n"
-		"	srl	%2,8\n"
-		"3:	nr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	alr	%0,%2\n"
-		"4:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (vaddr), "a" (&_zb_findmap),
-		  "m" (*(addrtype *) vaddr) : "cc");
-        return (res < size) ? res : size;
+	bytes = __ffz_word_loop(vaddr, size);
+	bits = __ffz_word(bytes*8, __load_ulong_le(vaddr, bytes));
+	return (bits < size) ? bits : size;
 }
 
-#else /* __s390x__ */
-
-static inline unsigned long
-ext2_find_first_zero_bit(void *vaddr, unsigned long size)
-{
-	typedef struct { long _[__BITOPS_WORDS(size)]; } addrtype;
-        unsigned long res, cmp, count;
-
-        if (!size)
-                return 0;
-	asm volatile(
-		"	lghi	%1,-1\n"
-		"	lgr	%2,%3\n"
-		"	aghi	%2,63\n"
-		"	srlg	%2,%2,6\n"
-		"	slgr	%0,%0\n"
-		"0:	clg	%1,0(%0,%4)\n"
-		"	jne	1f\n"
-		"	aghi	%0,8\n"
-		"	brct	%2,0b\n"
-		"	lgr	%0,%3\n"
-		"	j	5f\n"
-		"1:	cl	%1,0(%0,%4)\n"
-		"	jne	2f\n"
-		"	aghi	%0,4\n"
-		"2:	l	%2,0(%0,%4)\n"
-		"	sllg	%0,%0,3\n"
-		"	aghi	%0,24\n"
-		"	lghi	%1,0xff\n"
-		"	tmlh	%2,0xffff\n"
-		"	jo	3f\n"
-		"	aghi	%0,-16\n"
-		"	srl	%2,16\n"
-		"3:	tmll	%2,0xff00\n"
-		"	jo	4f\n"
-		"	aghi	%0,-8\n"
-		"	srl	%2,8\n"
-		"4:	ngr	%2,%1\n"
-		"	ic	%2,0(%2,%5)\n"
-		"	algr	%0,%2\n"
-		"5:"
-		: "=&a" (res), "=&d" (cmp), "=&a" (count)
-		: "a" (size), "a" (vaddr), "a" (&_zb_findmap),
-		  "m" (*(addrtype *) vaddr) : "cc");
-        return (res < size) ? res : size;
-}
-
-#endif /* __s390x__ */
-
-static inline int
-ext2_find_next_zero_bit(void *vaddr, unsigned long size, unsigned long offset)
+static inline int ext2_find_next_zero_bit(void *vaddr, unsigned long size,
+					  unsigned long offset)
 {
         unsigned long *addr = vaddr, *p;
-	unsigned long word, bit, set;
+	unsigned long bit, set;
 
         if (offset >= size)
                 return size;
@@ -882,23 +815,11 @@ ext2_find_next_zero_bit(void *vaddr, unsigned long size, unsigned long offset)
 	size -= offset;
 	p = addr + offset / __BITOPS_WORDSIZE;
         if (bit) {
-#ifndef __s390x__
-		asm volatile(
-			"	ic	%0,0(%1)\n"
-			"	icm	%0,2,1(%1)\n"
-			"	icm	%0,4,2(%1)\n"
-			"	icm	%0,8,3(%1)"
-			: "=&a" (word) : "a" (p), "m" (*p) : "cc");
-#else
-		asm volatile(
-			"	lrvg	%0,%1"
-			: "=a" (word) : "m" (*p) );
-#endif
 		/*
 		 * s390 version of ffz returns __BITOPS_WORDSIZE
 		 * if no zero bit is present in the word.
 		 */
-		set = ffz(word >> bit) + bit;
+		set = ffz(__load_ulong_le(p, 0) >> bit) + bit;
 		if (set >= size)
 			return size + offset;
 		if (set < __BITOPS_WORDSIZE)
@@ -910,6 +831,47 @@ ext2_find_next_zero_bit(void *vaddr, unsigned long size, unsigned long offset)
 	return offset + ext2_find_first_zero_bit(p, size);
 }
 
+static inline unsigned long ext2_find_first_bit(void *vaddr,
+						unsigned long size)
+{
+	unsigned long bytes, bits;
+
+	if (!size)
+		return 0;
+	bytes = __ffs_word_loop(vaddr, size);
+	bits = __ffs_word(bytes*8, __load_ulong_le(vaddr, bytes));
+	return (bits < size) ? bits : size;
+}
+
+static inline int ext2_find_next_bit(void *vaddr, unsigned long size,
+				     unsigned long offset)
+{
+	unsigned long *addr = vaddr, *p;
+	unsigned long bit, set;
+
+	if (offset >= size)
+		return size;
+	bit = offset & (__BITOPS_WORDSIZE - 1);
+	offset -= bit;
+	size -= offset;
+	p = addr + offset / __BITOPS_WORDSIZE;
+	if (bit) {
+		/*
+		 * s390 version of ffz returns __BITOPS_WORDSIZE
+		 * if no zero bit is present in the word.
+		 */
+		set = ffs(__load_ulong_le(p, 0) >> bit) + bit;
+		if (set >= size)
+			return size + offset;
+		if (set < __BITOPS_WORDSIZE)
+			return set + offset;
+		offset += __BITOPS_WORDSIZE;
+		size -= __BITOPS_WORDSIZE;
+		p++;
+	}
+	return offset + ext2_find_first_bit(p, size);
+}
+
 #include <asm-generic/bitops/minix.h>
 
 #endif /* __KERNEL__ */
diff --git a/include/asm-s390/cacheflush.h b/include/asm-s390/cacheflush.h
index f7cade8..49d5af9 100644
--- a/include/asm-s390/cacheflush.h
+++ b/include/asm-s390/cacheflush.h
@@ -24,4 +24,8 @@
 #define copy_from_user_page(vma, page, vaddr, dst, src, len) \
 	memcpy(dst, src, len)
 
+#ifdef CONFIG_DEBUG_PAGEALLOC
+void kernel_map_pages(struct page *page, int numpages, int enable);
+#endif
+
 #endif /* _S390_CACHEFLUSH_H */
diff --git a/include/asm-s390/ccwgroup.h b/include/asm-s390/ccwgroup.h
index 7109c7c..289053e 100644
--- a/include/asm-s390/ccwgroup.h
+++ b/include/asm-s390/ccwgroup.h
@@ -37,6 +37,7 @@ struct ccwgroup_device {
  * @remove: function called on remove
  * @set_online: function called when device is set online
  * @set_offline: function called when device is set offline
+ * @shutdown: function called when device is shut down
  * @driver: embedded driver structure
  */
 struct ccwgroup_driver {
@@ -49,6 +50,7 @@ struct ccwgroup_driver {
 	void (*remove) (struct ccwgroup_device *);
 	int (*set_online) (struct ccwgroup_device *);
 	int (*set_offline) (struct ccwgroup_device *);
+	void (*shutdown)(struct ccwgroup_device *);
 
 	struct device_driver driver;
 };
diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index 79b9eab..3f52075 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -115,15 +115,21 @@ extern char empty_zero_page[PAGE_SIZE];
 #ifndef __s390x__
 #define VMALLOC_START	0x78000000UL
 #define VMALLOC_END	0x7e000000UL
-#define VMEM_MAP_MAX	0x80000000UL
+#define VMEM_MAP_END	0x80000000UL
 #else /* __s390x__ */
 #define VMALLOC_START	0x3e000000000UL
 #define VMALLOC_END	0x3e040000000UL
-#define VMEM_MAP_MAX	0x40000000000UL
+#define VMEM_MAP_END	0x40000000000UL
 #endif /* __s390x__ */
 
+/*
+ * VMEM_MAX_PHYS is the highest physical address that can be added to the 1:1
+ * mapping. This needs to be calculated at compile time since the size of the
+ * VMEM_MAP is static but the size of struct page can change.
+ */
+#define VMEM_MAX_PHYS	min(VMALLOC_START, ((VMEM_MAP_END - VMALLOC_END) / \
+			  sizeof(struct page) * PAGE_SIZE) & ~((16 << 20) - 1))
 #define VMEM_MAP	((struct page *) VMALLOC_END)
-#define VMEM_MAP_SIZE	((VMALLOC_START / PAGE_SIZE) * sizeof(struct page))
 
 /*
  * A 31 bit pagetable entry of S390 has following format:


