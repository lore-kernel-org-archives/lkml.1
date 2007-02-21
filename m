Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXBUKKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXBUKKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 05:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161216AbXBUKKV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 05:10:21 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:34226 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161217AbXBUKKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 05:10:17 -0500
Date: Wed, 21 Feb 2007 11:10:17 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Please pull git390 'for-linus' branch
Message-ID: <20070221101017.GM13419@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/Kconfig                |    4 +-
 arch/s390/Makefile               |   12 ++--
 arch/s390/defconfig              |   21 +++--
 arch/s390/kernel/early.c         |    5 +-
 arch/s390/kernel/head31.S        |   15 +---
 arch/s390/kernel/head64.S        |   16 +---
 arch/s390/kernel/ipl.c           |   33 ++-----
 arch/s390/kernel/setup.c         |   10 ++-
 arch/s390/kernel/smp.c           |  182 ++++++++++++++++----------------------
 arch/s390/kernel/time.c          |   10 ++-
 arch/s390/lib/delay.c            |    7 ++
 arch/s390/mm/init.c              |    2 +
 drivers/s390/char/sclp_quiesce.c |    1 +
 drivers/s390/cio/cio.c           |    3 +-
 include/asm-s390/atomic.h        |    2 +
 include/asm-s390/ipl.h           |  113 +++++++++++++++++++++++
 include/asm-s390/local.h         |   59 +------------
 include/asm-s390/processor.h     |    5 +
 include/asm-s390/sections.h      |    2 +-
 include/asm-s390/setup.h         |   74 ---------------
 20 files changed, 269 insertions(+), 307 deletions(-)
 create mode 100644 include/asm-s390/ipl.h

Heiko Carstens (4):
      [S390] Optional ZONE_DMA for s390.
      [S390] etr: Add barrier() to etr_sync_cpu_start().
      [S390] bss section clearing.
      [S390] nss: Free unused memory in kernel image.

Jan Glauber (2):
      [S390] fix non-smp compile.
      [S390] smp_call_function cleanup

Martin Schwidefsky (2):
      [S390] update default configuration
      [S390] prevent softirqs if delay is called disabled

Mathieu Desnoyers (2):
      [S390] local_t cleanup : use asm-generic/local.h.
      [S390] add atomic64_xchg to s390

Michael Holzheu (4):
      [S390] New get_cpu_id() inline assembly
      [S390] New header file ipl.h
      [S390] Remove BUG() statement
      [S390] Replace $(ARCH) macros in Makefile

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index eaaac37..d9425f5 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -8,8 +8,8 @@ config MMU
 	default y
 
 config ZONE_DMA
-	bool
-	default y
+	def_bool y
+	depends on 64BIT
 
 config LOCKDEP_SUPPORT
 	bool
diff --git a/arch/s390/Makefile b/arch/s390/Makefile
index 6598e52..b1e5584 100644
--- a/arch/s390/Makefile
+++ b/arch/s390/Makefile
@@ -82,18 +82,18 @@ AFLAGS		+= $(aflags-y)
 OBJCOPYFLAGS	:= -O binary
 LDFLAGS_vmlinux := -e start
 
-head-y		:= arch/$(ARCH)/kernel/head.o arch/$(ARCH)/kernel/init_task.o
+head-y		:= arch/s390/kernel/head.o arch/s390/kernel/init_task.o
 
-core-y		+= arch/$(ARCH)/mm/ arch/$(ARCH)/kernel/ arch/$(ARCH)/crypto/ \
-		   arch/$(ARCH)/appldata/ arch/$(ARCH)/hypfs/
-libs-y		+= arch/$(ARCH)/lib/
+core-y		+= arch/s390/mm/ arch/s390/kernel/ arch/s390/crypto/ \
+		   arch/s390/appldata/ arch/s390/hypfs/
+libs-y		+= arch/s390/lib/
 drivers-y	+= drivers/s390/
-drivers-$(CONFIG_MATHEMU) += arch/$(ARCH)/math-emu/
+drivers-$(CONFIG_MATHEMU) += arch/s390/math-emu/
 
 # must be linked after kernel
 drivers-$(CONFIG_OPROFILE)	+= arch/s390/oprofile/
 
-boot		:= arch/$(ARCH)/boot
+boot		:= arch/s390/boot
 
 all: image
 
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 1406400..741d2bb 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,9 +1,10 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.20-rc1
-# Fri Dec 15 16:52:28 2006
+# Linux kernel version: 2.6.21-rc1
+# Wed Feb 21 10:44:30 2007
 #
 CONFIG_MMU=y
+CONFIG_ZONE_DMA=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
@@ -11,6 +12,7 @@ CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_TIME=y
+CONFIG_NO_IOMEM=y
 CONFIG_S390=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
@@ -29,6 +31,7 @@ CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SWAP=y
 CONFIG_SYSVIPC=y
 # CONFIG_IPC_NS is not set
+CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
@@ -133,6 +136,7 @@ CONFIG_FLAT_NODE_MEM_MAP=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_RESOURCES_64BIT=y
+CONFIG_ZONE_DMA_FLAG=1
 CONFIG_HOLES_IN_ZONE=y
 
 #
@@ -178,7 +182,9 @@ CONFIG_UNIX=y
 CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
+# CONFIG_XFRM_MIGRATE is not set
 CONFIG_NET_KEY=y
+# CONFIG_NET_KEY_MIGRATE is not set
 CONFIG_IUCV=m
 CONFIG_AFIUCV=m
 CONFIG_INET=y
@@ -195,7 +201,7 @@ CONFIG_IP_FIB_HASH=y
 # CONFIG_INET_ESP is not set
 # CONFIG_INET_IPCOMP is not set
 # CONFIG_INET_XFRM_TUNNEL is not set
-# CONFIG_INET_TUNNEL is not set
+CONFIG_INET_TUNNEL=y
 CONFIG_INET_XFRM_MODE_TRANSPORT=y
 CONFIG_INET_XFRM_MODE_TUNNEL=y
 CONFIG_INET_XFRM_MODE_BEET=y
@@ -313,6 +319,7 @@ CONFIG_STANDALONE=y
 CONFIG_PREVENT_FIRMWARE_BUILD=y
 # CONFIG_FW_LOADER is not set
 # CONFIG_DEBUG_DRIVER is not set
+# CONFIG_DEBUG_DEVRES is not set
 CONFIG_SYS_HYPERVISOR=y
 
 #
@@ -686,13 +693,13 @@ CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=17
 # CONFIG_SCHEDSTATS is not set
+# CONFIG_TIMER_STATS is not set
 # CONFIG_DEBUG_SLAB is not set
 CONFIG_DEBUG_PREEMPT=y
 # CONFIG_DEBUG_RT_MUTEXES is not set
 # CONFIG_RT_MUTEX_TESTER is not set
 CONFIG_DEBUG_SPINLOCK=y
 CONFIG_DEBUG_MUTEXES=y
-# CONFIG_DEBUG_RWSEMS is not set
 # CONFIG_DEBUG_LOCK_ALLOC is not set
 # CONFIG_PROVE_LOCKING is not set
 CONFIG_DEBUG_SPINLOCK_SLEEP=y
@@ -702,10 +709,10 @@ CONFIG_DEBUG_SPINLOCK_SLEEP=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_FRAME_POINTER is not set
-# CONFIG_UNWIND_INFO is not set
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_LKDTM is not set
+# CONFIG_FAULT_INJECTION is not set
 
 #
 # Security options
@@ -733,8 +740,10 @@ CONFIG_CRYPTO_MANAGER=y
 # CONFIG_CRYPTO_GF128MUL is not set
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_CBC=y
+CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_LRW is not set
 # CONFIG_CRYPTO_DES is not set
+CONFIG_CRYPTO_FCRYPT=m
 # CONFIG_CRYPTO_BLOWFISH is not set
 # CONFIG_CRYPTO_TWOFISH is not set
 # CONFIG_CRYPTO_SERPENT is not set
@@ -748,6 +757,7 @@ CONFIG_CRYPTO_CBC=y
 # CONFIG_CRYPTO_DEFLATE is not set
 # CONFIG_CRYPTO_MICHAEL_MIC is not set
 # CONFIG_CRYPTO_CRC32C is not set
+CONFIG_CRYPTO_CAMELLIA=m
 # CONFIG_CRYPTO_TEST is not set
 
 #
@@ -768,4 +778,3 @@ CONFIG_BITREVERSE=m
 CONFIG_CRC32=m
 # CONFIG_LIBCRC32C is not set
 CONFIG_PLIST=y
-CONFIG_IOMAP_COPY=y
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index e518dd5..afca1c6 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -14,6 +14,7 @@
 #include <linux/module.h>
 #include <linux/pfn.h>
 #include <linux/uaccess.h>
+#include <asm/ipl.h>
 #include <asm/lowcore.h>
 #include <asm/processor.h>
 #include <asm/sections.h>
@@ -109,7 +110,7 @@ static inline void create_kernel_nss(void) { }
  */
 static noinline __init void clear_bss_section(void)
 {
-	memset(__bss_start, 0, _end - __bss_start);
+	memset(__bss_start, 0, __bss_stop - __bss_start);
 }
 
 /*
@@ -129,7 +130,7 @@ static noinline __init void detect_machine_type(void)
 {
 	struct cpuinfo_S390 *cpuinfo = &S390_lowcore.cpu_data;
 
-	asm volatile("stidp %0" : "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
 
 	/* Running under z/VM ? */
 	if (cpuinfo->cpu_id.version == 0xff)
diff --git a/arch/s390/kernel/head31.S b/arch/s390/kernel/head31.S
index 453fd3b..da7c8bb 100644
--- a/arch/s390/kernel/head31.S
+++ b/arch/s390/kernel/head31.S
@@ -148,20 +148,9 @@ startup_continue:
 .Lstartup_init:
 	    .long startup_init
 
-	.globl ipl_schib
-ipl_schib:
-	.rept 13
-	.long 0
-	.endr
-
-	.globl ipl_flags
-ipl_flags:
-	.long 0
-	.globl ipl_devno
-ipl_devno:
-	.word 0
-
 	.org	0x12000
+	.globl	_ehead
+_ehead:
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
 #endif
diff --git a/arch/s390/kernel/head64.S b/arch/s390/kernel/head64.S
index b8fec4e..af09e18 100644
--- a/arch/s390/kernel/head64.S
+++ b/arch/s390/kernel/head64.S
@@ -154,21 +154,9 @@ startup_continue:
 .Lparmaddr:
 	.quad	PARMAREA
 
-	.globl	ipl_schib
-ipl_schib:
-	.rept 13
-	.long 0
-	.endr
-
-	.globl	ipl_flags
-ipl_flags:
-	.long	0
-	.globl	ipl_devno
-ipl_devno:
-	.word 0
-
 	.org	0x12000
-
+	.globl	_ehead
+_ehead:
 #ifdef CONFIG_SHARED_KERNEL
 	.org	0x100000
 #endif
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 0522595..5a863a3 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -14,6 +14,7 @@
 #include <linux/delay.h>
 #include <linux/reboot.h>
 #include <linux/ctype.h>
+#include <asm/ipl.h>
 #include <asm/smp.h>
 #include <asm/setup.h>
 #include <asm/cpcmd.h>
@@ -42,6 +43,13 @@ enum ipl_type {
 #define IPL_FCP_STR	 "fcp"
 #define IPL_NSS_STR	 "nss"
 
+/*
+ * Must be in data section since the bss section
+ * is not cleared when these are accessed.
+ */
+u16 ipl_devno __attribute__((__section__(".data"))) = 0;
+u32 ipl_flags __attribute__((__section__(".data"))) = 0;
+
 static char *ipl_type_str(enum ipl_type type)
 {
 	switch (type) {
@@ -90,31 +98,10 @@ static char *shutdown_action_str(enum shutdown_action action)
 	case SHUTDOWN_STOP:
 		return SHUTDOWN_STOP_STR;
 	default:
-		BUG();
+		return NULL;
 	}
 }
 
-enum diag308_subcode  {
-	DIAG308_IPL   = 3,
-	DIAG308_DUMP  = 4,
-	DIAG308_SET   = 5,
-	DIAG308_STORE = 6,
-};
-
-enum diag308_ipl_type {
-	DIAG308_IPL_TYPE_FCP = 0,
-	DIAG308_IPL_TYPE_CCW = 2,
-};
-
-enum diag308_opt {
-	DIAG308_IPL_OPT_IPL  = 0x10,
-	DIAG308_IPL_OPT_DUMP = 0x20,
-};
-
-enum diag308_rc {
-	DIAG308_RC_OK = 1,
-};
-
 static int diag308_set_works = 0;
 
 static int reipl_capabilities = IPL_TYPE_UNKNOWN;
@@ -134,7 +121,7 @@ static struct ipl_parameter_block *dump_block_ccw;
 
 static enum shutdown_action on_panic_action = SHUTDOWN_STOP;
 
-static int diag308(unsigned long subcode, void *addr)
+int diag308(unsigned long subcode, void *addr)
 {
 	register unsigned long _addr asm("0") = (unsigned long) addr;
 	register unsigned long _rc asm("1") = 0;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 50c5210..863c8d0 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -41,6 +41,7 @@
 #include <linux/ctype.h>
 #include <linux/reboot.h>
 
+#include <asm/ipl.h>
 #include <asm/uaccess.h>
 #include <asm/system.h>
 #include <asm/smp.h>
@@ -106,7 +107,7 @@ void __devinit cpu_init (void)
         /*
          * Store processor id in lowcore (used e.g. in timer_interrupt)
          */
-	asm volatile("stidp %0": "=m" (S390_lowcore.cpu_data.cpu_id));
+	get_cpu_id(&S390_lowcore.cpu_data.cpu_id);
         S390_lowcore.cpu_data.cpu_addr = addr;
 
         /*
@@ -689,9 +690,14 @@ setup_memory(void)
 	psw_set_key(PAGE_DEFAULT_KEY);
 
 	free_bootmem_with_active_regions(0, max_pfn);
-	reserve_bootmem(0, PFN_PHYS(start_pfn));
 
 	/*
+	 * Reserve memory used for lowcore/command line/kernel image.
+	 */
+	reserve_bootmem(0, (unsigned long)_ehead);
+	reserve_bootmem((unsigned long)_stext,
+			PFN_PHYS(start_pfn) - (unsigned long)_stext);
+	/*
 	 * Reserve the bootmem bitmap itself as well. We do this in two
 	 * steps (first step was init_bootmem()) because this catches
 	 * the (very unlikely) case of us accidentally initializing the
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 83a4ea6..ecaa432 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -31,6 +31,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/timex.h>
+#include <asm/ipl.h>
 #include <asm/setup.h>
 #include <asm/sigp.h>
 #include <asm/pgalloc.h>
@@ -54,19 +55,18 @@ cpumask_t cpu_possible_map = CPU_MASK_NONE;
 static struct task_struct *current_set[NR_CPUS];
 
 static void smp_ext_bitcall(int, ec_bit_sig);
-static void smp_ext_bitcall_others(ec_bit_sig);
 
 /*
- * Structure and data for smp_call_function(). This is designed to minimise
- * static memory requirements. It also looks cleaner.
+ * Structure and data for __smp_call_function_map(). This is designed to
+ * minimise static memory requirements. It also looks cleaner.
  */
 static DEFINE_SPINLOCK(call_lock);
 
 struct call_data_struct {
 	void (*func) (void *info);
 	void *info;
-	atomic_t started;
-	atomic_t finished;
+	cpumask_t started;
+	cpumask_t finished;
 	int wait;
 };
 
@@ -81,118 +81,113 @@ static void do_call_function(void)
 	void *info = call_data->info;
 	int wait = call_data->wait;
 
-	atomic_inc(&call_data->started);
+	cpu_set(smp_processor_id(), call_data->started);
 	(*func)(info);
 	if (wait)
-		atomic_inc(&call_data->finished);
+		cpu_set(smp_processor_id(), call_data->finished);;
 }
 
-/*
- * this function sends a 'generic call function' IPI to all other CPUs
- * in the system.
- */
-
-int smp_call_function (void (*func) (void *info), void *info, int nonatomic,
-			int wait)
-/*
- * [SUMMARY] Run a function on all other CPUs.
- * <func> The function to run. This must be fast and non-blocking.
- * <info> An arbitrary pointer to pass to the function.
- * <nonatomic> currently unused.
- * <wait> If true, wait (atomically) until function has completed on other CPUs.
- * [RETURNS] 0 on success, else a negative status code. Does not return until
- * remote CPUs are nearly ready to execute <<func>> or are or have executed.
- *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler.
- */
+static void __smp_call_function_map(void (*func) (void *info), void *info,
+				    int nonatomic, int wait, cpumask_t map)
 {
 	struct call_data_struct data;
-	int cpus = num_online_cpus()-1;
+	int cpu, local = 0;
 
-	if (cpus <= 0)
-		return 0;
+	/*
+	 * Can deadlock when interrupts are disabled or if in wrong context,
+	 * caller must disable preemption
+	 */
+	WARN_ON(irqs_disabled() || in_irq() || preemptible());
 
-	/* Can deadlock when interrupts are disabled or if in wrong context */
-	WARN_ON(irqs_disabled() || in_irq());
+	/*
+	 * Check for local function call. We have to have the same call order
+	 * as in on_each_cpu() because of machine_restart_smp().
+	 */
+	if (cpu_isset(smp_processor_id(), map)) {
+		local = 1;
+		cpu_clear(smp_processor_id(), map);
+	}
+
+	cpus_and(map, map, cpu_online_map);
+	if (cpus_empty(map))
+		goto out;
 
 	data.func = func;
 	data.info = info;
-	atomic_set(&data.started, 0);
+	data.started = CPU_MASK_NONE;
 	data.wait = wait;
 	if (wait)
-		atomic_set(&data.finished, 0);
+		data.finished = CPU_MASK_NONE;
 
 	spin_lock_bh(&call_lock);
 	call_data = &data;
-	/* Send a message to all other CPUs and wait for them to respond */
-        smp_ext_bitcall_others(ec_call_function);
+
+	for_each_cpu_mask(cpu, map)
+		smp_ext_bitcall(cpu, ec_call_function);
 
 	/* Wait for response */
-	while (atomic_read(&data.started) != cpus)
+	while (!cpus_equal(map, data.started))
 		cpu_relax();
 
 	if (wait)
-		while (atomic_read(&data.finished) != cpus)
+		while (!cpus_equal(map, data.finished))
 			cpu_relax();
+
 	spin_unlock_bh(&call_lock);
 
-	return 0;
+out:
+	local_irq_disable();
+	if (local)
+		func(info);
+	local_irq_enable();
 }
 
 /*
- * Call a function on one CPU
- * cpu : the CPU the function should be executed on
+ * smp_call_function:
+ * @func: the function to run; this must be fast and non-blocking
+ * @info: an arbitrary pointer to pass to the function
+ * @nonatomic: unused
+ * @wait: if true, wait (atomically) until function has completed on other CPUs
  *
- * You must not call this function with disabled interrupts or from a
- * hardware interrupt handler. You may call it from a bottom half.
+ * Run a function on all other CPUs.
  *
- * It is guaranteed that the called function runs on the specified CPU,
- * preemption is disabled.
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler. Must be called with preemption disabled.
+ * You may call it from a bottom half.
  */
-int smp_call_function_on(void (*func) (void *info), void *info,
-			 int nonatomic, int wait, int cpu)
+int smp_call_function(void (*func) (void *info), void *info, int nonatomic,
+		      int wait)
 {
-	struct call_data_struct data;
-	int curr_cpu;
-
-	if (!cpu_online(cpu))
-		return -EINVAL;
-
-	/* Can deadlock when interrupts are disabled or if in wrong context */
-	WARN_ON(irqs_disabled() || in_irq());
-
-	/* disable preemption for local function call */
-	curr_cpu = get_cpu();
-
-	if (curr_cpu == cpu) {
-		/* direct call to function */
-		func(info);
-		put_cpu();
-		return 0;
-	}
-
-	data.func = func;
-	data.info = info;
-	atomic_set(&data.started, 0);
-	data.wait = wait;
-	if (wait)
-		atomic_set(&data.finished, 0);
-
-	spin_lock_bh(&call_lock);
-	call_data = &data;
-	smp_ext_bitcall(cpu, ec_call_function);
+	cpumask_t map;
 
-	/* Wait for response */
-	while (atomic_read(&data.started) != 1)
-		cpu_relax();
+	map = cpu_online_map;
+	cpu_clear(smp_processor_id(), map);
+	__smp_call_function_map(func, info, nonatomic, wait, map);
+	return 0;
+}
+EXPORT_SYMBOL(smp_call_function);
 
-	if (wait)
-		while (atomic_read(&data.finished) != 1)
-			cpu_relax();
+/*
+ * smp_call_function_on:
+ * @func: the function to run; this must be fast and non-blocking
+ * @info: an arbitrary pointer to pass to the function
+ * @nonatomic: unused
+ * @wait: if true, wait (atomically) until function has completed on other CPUs
+ * @cpu: the CPU where func should run
+ *
+ * Run a function on one processor.
+ *
+ * You must not call this function with disabled interrupts or from a
+ * hardware interrupt handler. Must be called with preemption disabled.
+ * You may call it from a bottom half.
+ */
+int smp_call_function_on(void (*func) (void *info), void *info, int nonatomic,
+			  int wait, int cpu)
+{
+	cpumask_t map = CPU_MASK_NONE;
 
-	spin_unlock_bh(&call_lock);
-	put_cpu();
+	cpu_set(cpu, map);
+	__smp_call_function_map(func, info, nonatomic, wait, map);
 	return 0;
 }
 EXPORT_SYMBOL(smp_call_function_on);
@@ -325,26 +320,6 @@ static void smp_ext_bitcall(int cpu, ec_bit_sig sig)
 		udelay(10);
 }
 
-/*
- * Send an external call sigp to every other cpu in the system and
- * return without waiting for its completion.
- */
-static void smp_ext_bitcall_others(ec_bit_sig sig)
-{
-        int cpu;
-
-	for_each_online_cpu(cpu) {
-		if (cpu == smp_processor_id())
-                        continue;
-                /*
-                 * Set signaling bit in lowcore of target cpu and kick it
-                 */
-		set_bit(sig, (unsigned long *) &lowcore_ptr[cpu]->ext_call_fast);
-		while (signal_processor(cpu, sigp_emergency_signal) == sigp_busy)
-			udelay(10);
-        }
-}
-
 #ifndef CONFIG_64BIT
 /*
  * this function sends a 'purge tlb' signal to another CPU.
@@ -807,6 +782,5 @@ EXPORT_SYMBOL(cpu_possible_map);
 EXPORT_SYMBOL(lowcore_ptr);
 EXPORT_SYMBOL(smp_ctl_set_bit);
 EXPORT_SYMBOL(smp_ctl_clear_bit);
-EXPORT_SYMBOL(smp_call_function);
 EXPORT_SYMBOL(smp_get_cpu);
 EXPORT_SYMBOL(smp_put_cpu);
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index ee9fd7b..e1ad464 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -747,6 +747,7 @@ static void etr_adjust_time(unsigned long long clock, unsigned long long delay)
 	}
 }
 
+#ifdef CONFIG_SMP
 static void etr_sync_cpu_start(void *dummy)
 {
 	int *in_sync = dummy;
@@ -758,8 +759,14 @@ static void etr_sync_cpu_start(void *dummy)
 	 * __udelay will stop the cpu on an enabled wait psw until the
 	 * TOD is running again.
 	 */
-	while (*in_sync == 0)
+	while (*in_sync == 0) {
 		__udelay(1);
+		/*
+		 * A different cpu changes *in_sync. Therefore use
+		 * barrier() to force memory access.
+		 */
+		barrier();
+	}
 	if (*in_sync != 1)
 		/* Didn't work. Clear per-cpu in sync bit again. */
 		etr_disable_sync_clock(NULL);
@@ -773,6 +780,7 @@ static void etr_sync_cpu_start(void *dummy)
 static void etr_sync_cpu_end(void *dummy)
 {
 }
+#endif /* CONFIG_SMP */
 
 /*
  * Sync the TOD clock using the port refered to by aibp. This port
diff --git a/arch/s390/lib/delay.c b/arch/s390/lib/delay.c
index 0285444..70f2a86 100644
--- a/arch/s390/lib/delay.c
+++ b/arch/s390/lib/delay.c
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <linux/timex.h>
 #include <linux/irqflags.h>
+#include <linux/interrupt.h>
 
 void __delay(unsigned long loops)
 {
@@ -35,7 +36,11 @@ void __udelay(unsigned long usecs)
 {
 	u64 end, time, jiffy_timer = 0;
 	unsigned long flags, cr0, mask, dummy;
+	int irq_context;
 
+	irq_context = in_interrupt();
+	if (!irq_context)
+		local_bh_disable();
 	local_irq_save(flags);
 	if (raw_irqs_disabled_flags(flags)) {
 		jiffy_timer = S390_lowcore.jiffy_timer;
@@ -62,6 +67,8 @@ void __udelay(unsigned long usecs)
 		__ctl_load(cr0, 0, 0);
 		S390_lowcore.jiffy_timer = jiffy_timer;
 	}
+	if (!irq_context)
+		_local_bh_enable();
 	set_clock_comparator(S390_lowcore.jiffy_timer);
 	local_irq_restore(flags);
 }
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index b3e7c45..916b72a 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -141,7 +141,9 @@ void __init paging_init(void)
 	__raw_local_irq_ssm(ssm_mask);
 
 	memset(max_zone_pfns, 0, sizeof(max_zone_pfns));
+#ifdef CONFIG_ZONE_DMA
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(MAX_DMA_ADDRESS);
+#endif
 	max_zone_pfns[ZONE_NORMAL] = max_low_pfn;
 	free_area_init_nodes(max_zone_pfns);
 }
diff --git a/drivers/s390/char/sclp_quiesce.c b/drivers/s390/char/sclp_quiesce.c
index ffa9282..baa8fe6 100644
--- a/drivers/s390/char/sclp_quiesce.c
+++ b/drivers/s390/char/sclp_quiesce.c
@@ -16,6 +16,7 @@
 #include <asm/atomic.h>
 #include <asm/ptrace.h>
 #include <asm/sigp.h>
+#include <asm/smp.h>
 
 #include "sclp.h"
 
diff --git a/drivers/s390/cio/cio.c b/drivers/s390/cio/cio.c
index b3a56dc..9cb129a 100644
--- a/drivers/s390/cio/cio.c
+++ b/drivers/s390/cio/cio.c
@@ -21,6 +21,7 @@
 #include <asm/irq_regs.h>
 #include <asm/setup.h>
 #include <asm/reset.h>
+#include <asm/ipl.h>
 #include "airq.h"
 #include "cio.h"
 #include "css.h"
@@ -1047,7 +1048,7 @@ void reipl_ccw_dev(struct ccw_dev_id *devid)
 	do_reipl_asm(*((__u32*)&schid));
 }
 
-extern struct schib ipl_schib;
+static struct schib __initdata ipl_schib;
 
 /*
  * ipl_save_parameters gets called very early. It is not allowed to access
diff --git a/include/asm-s390/atomic.h b/include/asm-s390/atomic.h
index af20c74..c17bdbf 100644
--- a/include/asm-s390/atomic.h
+++ b/include/asm-s390/atomic.h
@@ -215,6 +215,8 @@ static __inline__ void atomic64_set_mask(unsigned long mask, atomic64_t * v)
 	       __CSG_LOOP(v, mask, "ogr");
 }
 
+#define atomic64_xchg(v, new) (xchg(&((v)->counter), new))
+
 static __inline__ long long atomic64_cmpxchg(atomic64_t *v,
 					     long long old, long long new)
 {
diff --git a/include/asm-s390/ipl.h b/include/asm-s390/ipl.h
new file mode 100644
index 0000000..5650d3d
--- /dev/null
+++ b/include/asm-s390/ipl.h
@@ -0,0 +1,113 @@
+/*
+ * s390 (re)ipl support
+ *
+ * Copyright IBM Corp. 2007
+ */
+
+#ifndef _ASM_S390_IPL_H
+#define _ASM_S390_IPL_H
+
+#include <asm/types.h>
+
+#define IPL_PARMBLOCK_ORIGIN	0x2000
+
+#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_fcp))
+
+#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
+			      sizeof(struct ipl_block_ccw))
+
+#define IPL_MAX_SUPPORTED_VERSION (0)
+
+#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
+				 IPL_PARMBLOCK_ORIGIN)
+#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
+
+struct ipl_list_hdr {
+	u32 len;
+	u8  reserved1[3];
+	u8  version;
+	u32 blk0_len;
+	u8  pbt;
+	u8  flags;
+	u16 reserved2;
+} __attribute__((packed));
+
+struct ipl_block_fcp {
+	u8  reserved1[313-1];
+	u8  opt;
+	u8  reserved2[3];
+	u16 reserved3;
+	u16 devno;
+	u8  reserved4[4];
+	u64 wwpn;
+	u64 lun;
+	u32 bootprog;
+	u8  reserved5[12];
+	u64 br_lba;
+	u32 scp_data_len;
+	u8  reserved6[260];
+	u8  scp_data[];
+} __attribute__((packed));
+
+struct ipl_block_ccw {
+	u8  load_param[8];
+	u8  reserved1[84];
+	u8  reserved2[2];
+	u16 devno;
+	u8  vm_flags;
+	u8  reserved3[3];
+	u32 vm_parm_len;
+} __attribute__((packed));
+
+struct ipl_parameter_block {
+	struct ipl_list_hdr hdr;
+	union {
+		struct ipl_block_fcp fcp;
+		struct ipl_block_ccw ccw;
+	} ipl_info;
+} __attribute__((packed));
+
+/*
+ * IPL validity flags and parameters as detected in head.S
+ */
+extern u32 ipl_flags;
+extern u16 ipl_devno;
+
+extern void do_reipl(void);
+extern void ipl_save_parameters(void);
+
+enum {
+	IPL_DEVNO_VALID		= 1,
+	IPL_PARMBLOCK_VALID	= 2,
+	IPL_NSS_VALID		= 4,
+};
+
+/*
+ * DIAG 308 support
+ */
+enum diag308_subcode  {
+	DIAG308_REL_HSA	= 2,
+	DIAG308_IPL	= 3,
+	DIAG308_DUMP	= 4,
+	DIAG308_SET	= 5,
+	DIAG308_STORE	= 6,
+};
+
+enum diag308_ipl_type {
+	DIAG308_IPL_TYPE_FCP	= 0,
+	DIAG308_IPL_TYPE_CCW	= 2,
+};
+
+enum diag308_opt {
+	DIAG308_IPL_OPT_IPL	= 0x10,
+	DIAG308_IPL_OPT_DUMP	= 0x20,
+};
+
+enum diag308_rc {
+	DIAG308_RC_OK	= 1,
+};
+
+extern int diag308(unsigned long subcode, void *addr);
+
+#endif /* _ASM_S390_IPL_H */
diff --git a/include/asm-s390/local.h b/include/asm-s390/local.h
index 86745a1..c11c530 100644
--- a/include/asm-s390/local.h
+++ b/include/asm-s390/local.h
@@ -1,58 +1 @@
-#ifndef _ASM_LOCAL_H
-#define _ASM_LOCAL_H
-
-#include <linux/percpu.h>
-#include <asm/atomic.h>
-
-#ifndef __s390x__
-
-typedef atomic_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC_INIT(i)
-#define local_read(v)	atomic_read(v)
-#define local_set(v,i)	atomic_set(v,i)
-
-#define local_inc(v)	atomic_inc(v)
-#define local_dec(v)	atomic_dec(v)
-#define local_add(i, v)	atomic_add(i, v)
-#define local_sub(i, v)	atomic_sub(i, v)
-
-#else
-
-typedef atomic64_t local_t;
-
-#define LOCAL_INIT(i)	ATOMIC64_INIT(i)
-#define local_read(v)	atomic64_read(v)
-#define local_set(v,i)	atomic64_set(v,i)
-
-#define local_inc(v)	atomic64_inc(v)
-#define local_dec(v)	atomic64_dec(v)
-#define local_add(i, v)	atomic64_add(i, v)
-#define local_sub(i, v)	atomic64_sub(i, v)
-
-#endif
-
-#define __local_inc(v)		((v)->counter++)
-#define __local_dec(v)		((v)->counter--)
-#define __local_add(i,v)	((v)->counter+=(i))
-#define __local_sub(i,v)	((v)->counter-=(i))
-
-/*
- * Use these for per-cpu local_t variables: on some archs they are
- * much more efficient than these naive implementations.  Note they take
- * a variable, not an address.
- */
-#define cpu_local_read(v)	local_read(&__get_cpu_var(v))
-#define cpu_local_set(v, i)	local_set(&__get_cpu_var(v), (i))
-
-#define cpu_local_inc(v)	local_inc(&__get_cpu_var(v))
-#define cpu_local_dec(v)	local_dec(&__get_cpu_var(v))
-#define cpu_local_add(i, v)	local_add((i), &__get_cpu_var(v))
-#define cpu_local_sub(i, v)	local_sub((i), &__get_cpu_var(v))
-
-#define __cpu_local_inc(v)	__local_inc(&__get_cpu_var(v))
-#define __cpu_local_dec(v)	__local_dec(&__get_cpu_var(v))
-#define __cpu_local_add(i, v)	__local_add((i), &__get_cpu_var(v))
-#define __cpu_local_sub(i, v)	__local_sub((i), &__get_cpu_var(v))
-
-#endif /* _ASM_LOCAL_H */
+#include <asm-generic/local.h>
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index 4c1b739..33b80ce 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -36,6 +36,11 @@ typedef struct
         unsigned int unused  : 16;
 } __attribute__ ((packed)) cpuid_t;
 
+static inline void get_cpu_id(cpuid_t *ptr)
+{
+	asm volatile("stidp 0(%1)" : "=m" (*ptr) : "a" (ptr));
+}
+
 struct cpuinfo_S390
 {
         cpuid_t  cpu_id;
diff --git a/include/asm-s390/sections.h b/include/asm-s390/sections.h
index 1c5a2c4..fbd9116 100644
--- a/include/asm-s390/sections.h
+++ b/include/asm-s390/sections.h
@@ -3,6 +3,6 @@
 
 #include <asm-generic/sections.h>
 
-extern char _eshared[];
+extern char _eshared[], _ehead[];
 
 #endif
diff --git a/include/asm-s390/setup.h b/include/asm-s390/setup.h
index 3388bb5..44c7aee 100644
--- a/include/asm-s390/setup.h
+++ b/include/asm-s390/setup.h
@@ -16,7 +16,6 @@
 
 #define PARMAREA		0x10400
 #define MEMORY_CHUNKS		16	/* max 0x7fff */
-#define IPL_PARMBLOCK_ORIGIN	0x2000
 
 #ifndef __ASSEMBLY__
 
@@ -97,82 +96,9 @@ extern char vmpoff_cmd[];
 #define SET_CONSOLE_3215	do { console_mode = 2; } while (0)
 #define SET_CONSOLE_3270	do { console_mode = 3; } while (0)
 
-struct ipl_list_hdr {
-	u32 len;
-	u8  reserved1[3];
-	u8  version;
-	u32 blk0_len;
-	u8  pbt;
-	u8  flags;
-	u16 reserved2;
-} __attribute__((packed));
-
-struct ipl_block_fcp {
-	u8  reserved1[313-1];
-	u8  opt;
-	u8  reserved2[3];
-	u16 reserved3;
-	u16 devno;
-	u8  reserved4[4];
-	u64 wwpn;
-	u64 lun;
-	u32 bootprog;
-	u8  reserved5[12];
-	u64 br_lba;
-	u32 scp_data_len;
-	u8  reserved6[260];
-	u8  scp_data[];
-} __attribute__((packed));
-
-struct ipl_block_ccw {
-	u8  load_param[8];
-	u8  reserved1[84];
-	u8  reserved2[2];
-	u16 devno;
-	u8  vm_flags;
-	u8  reserved3[3];
-	u32 vm_parm_len;
-} __attribute__((packed));
-
-struct ipl_parameter_block {
-	struct ipl_list_hdr hdr;
-	union {
-		struct ipl_block_fcp fcp;
-		struct ipl_block_ccw ccw;
-	} ipl_info;
-} __attribute__((packed));
-
-#define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_fcp))
-
-#define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
-			      sizeof(struct ipl_block_ccw))
-
-#define IPL_MAX_SUPPORTED_VERSION (0)
-
-/*
- * IPL validity flags and parameters as detected in head.S
- */
-extern u32 ipl_flags;
-extern u16 ipl_devno;
-
-extern void do_reipl(void);
-extern void ipl_save_parameters(void);
-
-enum {
-	IPL_DEVNO_VALID	= 1,
-	IPL_PARMBLOCK_VALID = 2,
-	IPL_NSS_VALID = 4,
-};
-
 #define NSS_NAME_SIZE	8
-
 extern char kernel_nss_name[];
 
-#define IPL_PARMBLOCK_START	((struct ipl_parameter_block *) \
-				 IPL_PARMBLOCK_ORIGIN)
-#define IPL_PARMBLOCK_SIZE	(IPL_PARMBLOCK_START->hdr.len)
-
 #else /* __ASSEMBLY__ */
 
 #ifndef __s390x__
-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher 
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294
   
"Reality continues to ruin my life." - Calvin.

