Return-Path: <linux-kernel-owner+w=401wt.eu-S1752184AbZIZMVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbZIZMVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 08:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZIZMVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 08:21:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52268 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074AbZIZMVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 08:21:48 -0400
Date: Sat, 26 Sep 2009 14:21:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090926122137.GA2974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Anders Kaseorg (1):
      x86: fix fragile computation of vsyscall address

Huang Ying (1):
      x86: mce, inject: Use real inject-msg in raise_local

Ingo Molnar (3):
      x86: mce: Clean up thermal throttling state tracking code
      x86: mce: Fix thermal throttling message storm
      x86: mce: Use safer ways to access MCE registers

Jason Wessel (1):
      x86: early_printk: Protect against using the same device twice

Jeremy Fitzhardinge (2):
      xen: check EFER for NX before setting up GDT mapping
      x86: split NX setup into separate file to limit unstack-protected code

Roland Dreier (2):
      x86: Reduce verbosity of "TSC is reliable" message
      x86: Reduce verbosity of "PAT enabled" kernel message

Rusty Russell (1):
      x86: Remove redundant non-NUMA topology functions

Tim Abbott (4):
      x86: convert compressed loader to use __HEAD and HEAD_TEXT macros.
      x86: convert to use __HEAD and HEAD_TEXT macros.
      x86: Use section .data.page_aligned for the idt_table.
      x86: Cleanup linker script using new linker script macros.


 arch/x86/boot/compressed/head_32.S       |    3 +-
 arch/x86/boot/compressed/head_64.S       |    3 +-
 arch/x86/boot/compressed/vmlinux.lds.S   |    6 ++-
 arch/x86/include/asm/pgtable_types.h     |    1 +
 arch/x86/include/asm/topology.h          |   10 ----
 arch/x86/kernel/cpu/mcheck/mce-inject.c  |    7 ++-
 arch/x86/kernel/cpu/mcheck/mce.c         |   23 ++++++++-
 arch/x86/kernel/cpu/mcheck/therm_throt.c |   67 ++++++++++++++++---------
 arch/x86/kernel/early_printk.c           |    5 ++
 arch/x86/kernel/head_32.S                |    2 +-
 arch/x86/kernel/head_64.S                |    2 +-
 arch/x86/kernel/traps.c                  |    6 +--
 arch/x86/kernel/tsc_sync.c               |    2 +-
 arch/x86/kernel/vmlinux.lds.S            |   79 +++++-------------------------
 arch/x86/mm/Makefile                     |    3 +-
 arch/x86/mm/init.c                       |   63 ------------------------
 arch/x86/mm/pat.c                        |    7 ++-
 arch/x86/mm/setup_nx.c                   |   69 ++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c                 |   10 ++--
 19 files changed, 180 insertions(+), 188 deletions(-)
 create mode 100644 arch/x86/mm/setup_nx.c

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 75e4f00..f543b70 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -23,13 +23,14 @@
  */
 	.text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-	.section ".text.head","ax",@progbits
+	__HEAD
 ENTRY(startup_32)
 	cld
 	/*
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index f62c284..077e1b6 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -24,6 +24,7 @@
 	.code32
 	.text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/pgtable_types.h>
@@ -33,7 +34,7 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
-	.section ".text.head"
+	__HEAD
 	.code32
 ENTRY(startup_32)
 	cld
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index cc353e1..f4193bb 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,3 +1,5 @@
+#include <asm-generic/vmlinux.lds.h>
+
 OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
 #undef i386
@@ -18,9 +20,9 @@ SECTIONS
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.head.text : {
 		_head = . ;
-		*(.text.head)
+		HEAD_TEXT
 		_ehead = . ;
 	}
 	.rodata.compressed : {
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 7b467bf..d1f4a76 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -277,6 +277,7 @@ static inline pteval_t pte_flags(pte_t pte)
 typedef struct page *pgtable_t;
 
 extern pteval_t __supported_pte_mask;
+extern void set_nx(void);
 extern int nx_enabled;
 
 #define pgprot_writecombine	pgprot_writecombine
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 6f0695d..25a9284 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -165,21 +165,11 @@ static inline int numa_node_id(void)
 	return 0;
 }
 
-static inline int cpu_to_node(int cpu)
-{
-	return 0;
-}
-
 static inline int early_cpu_to_node(int cpu)
 {
 	return 0;
 }
 
-static inline const struct cpumask *cpumask_of_node(int node)
-{
-	return cpu_online_mask;
-}
-
 static inline void setup_node_to_cpumask_map(void) { }
 
 #endif
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index 7029f0e..472763d 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -98,8 +98,9 @@ static struct notifier_block mce_raise_nb = {
 };
 
 /* Inject mce on current CPU */
-static int raise_local(struct mce *m)
+static int raise_local(void)
 {
+	struct mce *m = &__get_cpu_var(injectm);
 	int context = MCJ_CTX(m->inject_flags);
 	int ret = 0;
 	int cpu = m->extcpu;
@@ -167,12 +168,12 @@ static void raise_mce(struct mce *m)
 			}
 			cpu_relax();
 		}
-		raise_local(m);
+		raise_local();
 		put_cpu();
 		put_online_cpus();
 	} else
 #endif
-		raise_local(m);
+		raise_local();
 }
 
 /* Error injection interface */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 2f5aab2..4b2af86 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -305,13 +305,25 @@ static int msr_to_offset(u32 msr)
 static u64 mce_rdmsrl(u32 msr)
 {
 	u64 v;
+
 	if (__get_cpu_var(injectm).finished) {
 		int offset = msr_to_offset(msr);
+
 		if (offset < 0)
 			return 0;
 		return *(u64 *)((char *)&__get_cpu_var(injectm) + offset);
 	}
-	rdmsrl(msr, v);
+
+	if (rdmsrl_safe(msr, &v)) {
+		WARN_ONCE(1, "mce: Unable to read msr %d!\n", msr);
+		/*
+		 * Return zero in case the access faulted. This should
+		 * not happen normally but can happen if the CPU does
+		 * something weird, or if the code is buggy.
+		 */
+		v = 0;
+	}
+
 	return v;
 }
 
@@ -319,6 +331,7 @@ static void mce_wrmsrl(u32 msr, u64 v)
 {
 	if (__get_cpu_var(injectm).finished) {
 		int offset = msr_to_offset(msr);
+
 		if (offset >= 0)
 			*(u64 *)((char *)&__get_cpu_var(injectm) + offset) = v;
 		return;
@@ -415,7 +428,7 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC 
+#ifdef CONFIG_X86_LOCAL_APIC
 /*
  * Called after interrupts have been reenabled again
  * when a MCE happened during an interrupts off region
@@ -1172,6 +1185,7 @@ static int mce_banks_init(void)
 		return -ENOMEM;
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		b->ctl = -1ULL;
 		b->init = 1;
 	}
@@ -1203,6 +1217,7 @@ static int __cpuinit mce_cap_init(void)
 	banks = b;
 	if (!mce_banks) {
 		int err = mce_banks_init();
+
 		if (err)
 			return err;
 	}
@@ -1237,6 +1252,7 @@ static void mce_init(void)
 
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (!b->init)
 			continue;
 		wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
@@ -1626,6 +1642,7 @@ static int mce_disable(void)
 
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
@@ -1911,6 +1928,7 @@ static void mce_disable_cpu(void *h)
 		cmci_clear();
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), 0);
 	}
@@ -1928,6 +1946,7 @@ static void mce_reenable_cpu(void *h)
 		cmci_reenable();
 	for (i = 0; i < banks; i++) {
 		struct mce_bank *b = &mce_banks[i];
+
 		if (b->init)
 			wrmsrl(MSR_IA32_MCx_CTL(i), b->ctl);
 	}
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 63a56d1..b3a1dba 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -34,20 +34,31 @@
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
 
-static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
-static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
-static DEFINE_PER_CPU(bool, thermal_throttle_active);
+/*
+ * Current thermal throttling state:
+ */
+struct thermal_state {
+	bool			is_throttled;
+
+	u64			next_check;
+	unsigned long		throttle_count;
+	unsigned long		last_throttle_count;
+};
+
+static DEFINE_PER_CPU(struct thermal_state, thermal_state);
 
-static atomic_t therm_throt_en		= ATOMIC_INIT(0);
+static atomic_t therm_throt_en	= ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
 	static SYSDEV_ATTR(_name, 0444, therm_throt_sysdev_show_##_name, NULL)
 
 #define define_therm_throt_sysdev_show_func(name)			\
-static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
-					struct sysdev_attribute *attr,	\
-					      char *buf)		\
+									\
+static ssize_t therm_throt_sysdev_show_##name(				\
+			struct sys_device *dev,				\
+			struct sysdev_attribute *attr,			\
+			char *buf)					\
 {									\
 	unsigned int cpu = dev->id;					\
 	ssize_t ret;							\
@@ -55,7 +66,7 @@ static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
 	preempt_disable();	/* CPU hotplug */			\
 	if (cpu_online(cpu))						\
 		ret = sprintf(buf, "%lu\n",				\
-			      per_cpu(thermal_throttle_##name, cpu));	\
+			      per_cpu(thermal_state, cpu).name);	\
 	else								\
 		ret = 0;						\
 	preempt_enable();						\
@@ -63,11 +74,11 @@ static ssize_t therm_throt_sysdev_show_##name(struct sys_device *dev,	\
 	return ret;							\
 }
 
-define_therm_throt_sysdev_show_func(count);
-define_therm_throt_sysdev_one_ro(count);
+define_therm_throt_sysdev_show_func(throttle_count);
+define_therm_throt_sysdev_one_ro(throttle_count);
 
 static struct attribute *thermal_throttle_attrs[] = {
-	&attr_count.attr,
+	&attr_throttle_count.attr,
 	NULL
 };
 
@@ -93,33 +104,39 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-static int therm_throt_process(int curr)
+static int therm_throt_process(bool is_throttled)
 {
-	unsigned int cpu = smp_processor_id();
-	__u64 tmp_jiffs = get_jiffies_64();
-	bool was_throttled = __get_cpu_var(thermal_throttle_active);
-	bool is_throttled = __get_cpu_var(thermal_throttle_active) = curr;
+	struct thermal_state *state;
+	unsigned int this_cpu;
+	bool was_throttled;
+	u64 now;
+
+	this_cpu = smp_processor_id();
+	now = get_jiffies_64();
+	state = &per_cpu(thermal_state, this_cpu);
+
+	was_throttled = state->is_throttled;
+	state->is_throttled = is_throttled;
 
 	if (is_throttled)
-		__get_cpu_var(thermal_throttle_count)++;
+		state->throttle_count++;
 
-	if (!(was_throttled ^ is_throttled) &&
-	    time_before64(tmp_jiffs, __get_cpu_var(next_check)))
+	if (time_before64(now, state->next_check) &&
+			state->throttle_count != state->last_throttle_count)
 		return 0;
 
-	__get_cpu_var(next_check) = tmp_jiffs + CHECK_INTERVAL;
+	state->next_check = now + CHECK_INTERVAL;
+	state->last_throttle_count = state->throttle_count;
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {
-		printk(KERN_CRIT "CPU%d: Temperature above threshold, "
-		       "cpu clock throttled (total events = %lu)\n",
-		       cpu, __get_cpu_var(thermal_throttle_count));
+		printk(KERN_CRIT "CPU%d: Temperature above threshold, cpu clock throttled (total events = %lu)\n", this_cpu, state->throttle_count);
 
 		add_taint(TAINT_MACHINE_CHECK);
 		return 1;
 	}
 	if (was_throttled) {
-		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", cpu);
+		printk(KERN_INFO "CPU%d: Temperature/speed normal\n", this_cpu);
 		return 1;
 	}
 
@@ -213,7 +230,7 @@ static void intel_thermal_interrupt(void)
 	__u64 msr_val;
 
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
+	if (therm_throt_process((msr_val & THERM_STATUS_PROCHOT) != 0))
 		mce_log_therm_throt_event(msr_val);
 }
 
diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index 2acfd3f..41fd965 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -178,6 +178,11 @@ asmlinkage void early_printk(const char *fmt, ...)
 
 static inline void early_console_register(struct console *con, int keep_early)
 {
+	if (early_console->index != -1) {
+		printk(KERN_CRIT "ERROR: earlyprintk= %s already used\n",
+		       con->name);
+		return;
+	}
 	early_console = con;
 	if (keep_early)
 		early_console->flags &= ~CON_BOOT;
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index b766e8c..0ad4302 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -79,7 +79,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index fa54f78..2640660 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -40,7 +40,7 @@ L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
-	.section .text.head
+	__HEAD
 	.code64
 	.globl startup_64
 startup_64:
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9346e10..8351175 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -73,11 +73,9 @@ char ignore_fpu_irq;
 
 /*
  * The IDT has to be page-aligned to simplify the Pentium
- * F0 0F bug workaround.. We have a special link segment
- * for this.
+ * F0 0F bug workaround.
  */
-gate_desc idt_table[NR_VECTORS]
-	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
+gate_desc idt_table[NR_VECTORS] __page_aligned_data = { { { { 0, 0 } } }, };
 #endif
 
 DECLARE_BITMAP(used_vectors, NR_VECTORS);
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index 027b5b4..f379309 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -114,7 +114,7 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		pr_info("Skipping synchronization checks as TSC is reliable.\n");
+		printk_once(KERN_INFO "Skipping synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index a46accc..92929fb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -65,17 +65,11 @@ SECTIONS
 #endif
 
 	/* Text and read-only data */
-
-	/* bootstrapping code */
-	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
-		_text = .;
-		*(.text.head)
-	} :text = 0x9090
-
-	/* The rest of the text */
 	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
+		_text = .;
+		/* bootstrapping code */
+		HEAD_TEXT
 #ifdef CONFIG_X86_32
-		/* not really needed, already page aligned */
 		. = ALIGN(PAGE_SIZE);
 		*(.text.page_aligned)
 #endif
@@ -94,13 +88,7 @@ SECTIONS
 
 	NOTES :text :note
 
-	/* Exception table */
-	. = ALIGN(16);
-	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-		__start___ex_table = .;
-		*(__ex_table)
-		__stop___ex_table = .;
-	} :text = 0x9090
+	EXCEPTION_TABLE(16) :text = 0x9090
 
 	RO_DATA(PAGE_SIZE)
 
@@ -118,7 +106,6 @@ SECTIONS
 #endif
 
 		PAGE_ALIGNED_DATA(PAGE_SIZE)
-		*(.data.idt)
 
 		CACHELINE_ALIGNED_DATA(CONFIG_X86_L1_CACHE_BYTES)
 
@@ -135,24 +122,21 @@ SECTIONS
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
-                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
-                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
-#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
+#define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
 
-#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
+#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
+	. = ALIGN(4096);
+	__vsyscall_0 = .;
+
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
+	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
 		*(.vsyscall_0)
 	} :user
 
-	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
-
 	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
 		*(.vsyscall_fn)
@@ -192,11 +176,9 @@ SECTIONS
 		*(.vsyscall_3)
 	}
 
-	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
+	. = __vsyscall_0 + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
-#undef VSYSCALL_PHYS_ADDR
-#undef VSYSCALL_VIRT_ADDR
 #undef VLOAD_OFFSET
 #undef VLOAD
 #undef VVIRT_OFFSET
@@ -219,36 +201,12 @@ SECTIONS
 	PERCPU_VADDR(0, :percpu)
 #endif
 
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
+	INIT_TEXT_SECTION(PAGE_SIZE)
 #ifdef CONFIG_X86_64
 	:init
 #endif
 
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		INIT_DATA
-	}
-
-	. = ALIGN(16);
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
+	INIT_DATA_SECTION(16)
 
 	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 		__x86_cpu_dev_start = .;
@@ -256,8 +214,6 @@ SECTIONS
 		__x86_cpu_dev_end = .;
 	}
 
-	SECURITY_INIT
-
 	. = ALIGN(8);
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
@@ -288,15 +244,6 @@ SECTIONS
 		EXIT_DATA
 	}
 
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
 #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
 	PERCPU(PAGE_SIZE)
 #endif
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 9b5a9f5..06630d2 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,9 +1,10 @@
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
-	    pat.o pgtable.o physaddr.o gup.o
+	    pat.o pgtable.o physaddr.o gup.o setup_nx.o
 
 # Make sure __phys_addr has no stackprotector
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_physaddr.o		:= $(nostackp)
+CFLAGS_setup_nx.o		:= $(nostackp)
 
 obj-$(CONFIG_SMP)		+= tlb.o
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 0607119..73ffd55 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -28,69 +28,6 @@ int direct_gbpages
 #endif
 ;
 
-int nx_enabled;
-
-#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
-static int disable_nx __cpuinitdata;
-
-/*
- * noexec = on|off
- *
- * Control non-executable mappings for processes.
- *
- * on      Enable
- * off     Disable
- */
-static int __init noexec_setup(char *str)
-{
-	if (!str)
-		return -EINVAL;
-	if (!strncmp(str, "on", 2)) {
-		__supported_pte_mask |= _PAGE_NX;
-		disable_nx = 0;
-	} else if (!strncmp(str, "off", 3)) {
-		disable_nx = 1;
-		__supported_pte_mask &= ~_PAGE_NX;
-	}
-	return 0;
-}
-early_param("noexec", noexec_setup);
-#endif
-
-#ifdef CONFIG_X86_PAE
-static void __init set_nx(void)
-{
-	unsigned int v[4], l, h;
-
-	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
-		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
-
-		if ((v[3] & (1 << 20)) && !disable_nx) {
-			rdmsr(MSR_EFER, l, h);
-			l |= EFER_NX;
-			wrmsr(MSR_EFER, l, h);
-			nx_enabled = 1;
-			__supported_pte_mask |= _PAGE_NX;
-		}
-	}
-}
-#else
-static inline void set_nx(void)
-{
-}
-#endif
-
-#ifdef CONFIG_X86_64
-void __cpuinit check_efer(void)
-{
-	unsigned long efer;
-
-	rdmsrl(MSR_EFER, efer);
-	if (!(efer & EFER_NX) || disable_nx)
-		__supported_pte_mask &= ~_PAGE_NX;
-}
-#endif
-
 static void __init find_early_table_space(unsigned long end, int use_pse,
 					  int use_gbpages)
 {
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 7257cf3..e78cd0e 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -81,6 +81,7 @@ enum {
 void pat_init(void)
 {
 	u64 pat;
+	bool boot_cpu = !boot_pat_state;
 
 	if (!pat_enabled)
 		return;
@@ -122,8 +123,10 @@ void pat_init(void)
 		rdmsrl(MSR_IA32_CR_PAT, boot_pat_state);
 
 	wrmsrl(MSR_IA32_CR_PAT, pat);
-	printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
-	       smp_processor_id(), boot_pat_state, pat);
+
+	if (boot_cpu)
+		printk(KERN_INFO "x86 PAT enabled: cpu %d, old 0x%Lx, new 0x%Lx\n",
+		       smp_processor_id(), boot_pat_state, pat);
 }
 
 #undef PAT
diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
new file mode 100644
index 0000000..513d8ed
--- /dev/null
+++ b/arch/x86/mm/setup_nx.c
@@ -0,0 +1,69 @@
+#include <linux/spinlock.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+
+#include <asm/pgtable.h>
+
+int nx_enabled;
+
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_PAE)
+static int disable_nx __cpuinitdata;
+
+/*
+ * noexec = on|off
+ *
+ * Control non-executable mappings for processes.
+ *
+ * on      Enable
+ * off     Disable
+ */
+static int __init noexec_setup(char *str)
+{
+	if (!str)
+		return -EINVAL;
+	if (!strncmp(str, "on", 2)) {
+		__supported_pte_mask |= _PAGE_NX;
+		disable_nx = 0;
+	} else if (!strncmp(str, "off", 3)) {
+		disable_nx = 1;
+		__supported_pte_mask &= ~_PAGE_NX;
+	}
+	return 0;
+}
+early_param("noexec", noexec_setup);
+#endif
+
+#ifdef CONFIG_X86_PAE
+void __init set_nx(void)
+{
+	unsigned int v[4], l, h;
+
+	if (cpu_has_pae && (cpuid_eax(0x80000000) > 0x80000001)) {
+		cpuid(0x80000001, &v[0], &v[1], &v[2], &v[3]);
+
+		if ((v[3] & (1 << 20)) && !disable_nx) {
+			rdmsr(MSR_EFER, l, h);
+			l |= EFER_NX;
+			wrmsr(MSR_EFER, l, h);
+			nx_enabled = 1;
+			__supported_pte_mask |= _PAGE_NX;
+		}
+	}
+}
+#else
+void set_nx(void)
+{
+}
+#endif
+
+#ifdef CONFIG_X86_64
+void __cpuinit check_efer(void)
+{
+	unsigned long efer;
+
+	rdmsrl(MSR_EFER, efer);
+	if (!(efer & EFER_NX) || disable_nx)
+		__supported_pte_mask &= ~_PAGE_NX;
+}
+#endif
+
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 544eb74..3439616 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1082,6 +1082,11 @@ asmlinkage void __init xen_start_kernel(void)
 
 	__supported_pte_mask |= _PAGE_IOMAP;
 
+#ifdef CONFIG_X86_64
+	/* Work out if we support NX */
+	check_efer();
+#endif
+
 	xen_setup_features();
 
 	/* Get mfn list */
@@ -1123,11 +1128,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	pgd = (pgd_t *)xen_start_info->pt_base;
 
-#ifdef CONFIG_X86_64
-	/* Work out if we support NX */
-	check_efer();
-#endif
-
 	/* Don't do the full vcpu_info placement stuff until we have a
 	   possible map and a non-dummy shared_info. */
 	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];

