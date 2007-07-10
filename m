Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXGJKJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXGJKJ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 06:09:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757311AbXGJKJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 06:09:19 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:64714 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757265AbXGJKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 06:09:16 -0400
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Tue, 10 Jul 2007 12:11:47 +0200
Message-Id: <1184062308.13483.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/crypto/crypt_s390.h       |    2 +-
 arch/s390/kernel/early.c            |   45 +++-------
 arch/s390/kernel/entry.S            |    7 ++-
 arch/s390/kernel/entry64.S          |    7 ++-
 arch/s390/kernel/ipl.c              |   17 ++--
 arch/s390/kernel/process.c          |    6 +-
 arch/s390/kernel/smp.c              |   63 +++++---------
 arch/s390/kernel/time.c             |    4 +-
 arch/s390/kernel/vtime.c            |    4 +-
 arch/s390/lib/Makefile              |    4 +-
 drivers/s390/block/dasd_proc.c      |    4 +
 drivers/s390/char/sclp.h            |   12 +++
 drivers/s390/char/sclp_chp.c        |    4 +
 drivers/s390/char/sclp_info.c       |  117 ++++++++++++++++++------
 drivers/s390/char/vmcp.c            |   13 ++--
 drivers/s390/char/vmlogrdr.c        |    4 +-
 drivers/s390/char/zcore.c           |    2 +-
 drivers/s390/cio/device_id.c        |   22 ++---
 drivers/s390/crypto/ap_bus.c        |   98 +++++++++++++++++++--
 drivers/s390/crypto/ap_bus.h        |   11 +++
 drivers/s390/crypto/zcrypt_cex2a.c  |   27 ++----
 drivers/s390/crypto/zcrypt_pcica.c  |   27 ++----
 drivers/s390/crypto/zcrypt_pcicc.c  |   27 ++----
 drivers/s390/crypto/zcrypt_pcixcc.c |   40 +++------
 fs/partitions/ibm.c                 |  167 ++++++++++++++++++++---------------
 include/asm-s390/atomic.h           |    4 +-
 include/asm-s390/cmb.h              |    1 -
 include/asm-s390/processor.h        |    4 +-
 include/asm-s390/sclp.h             |   47 ++++------
 include/asm-s390/sfp-machine.h      |    6 +-
 include/asm-s390/sfp-util.h         |   11 +++
 31 files changed, 459 insertions(+), 348 deletions(-)

Christian Borntraeger (1):
      [S390] vmlogrdr function annotation.

Cornelia Huck (1):
      [S390] cio: Remove prototype for non-existing function cmf_reset().

Heiko Carstens (7):
      [S390] sclp: introduce some new interfaces.
      [S390] sclp: Test facility list before executing a service call.
      [S390] zcore: Fix __user annotation.
      [S390] smp: Merge smp_count_cpus() and smp_get_save_areas().
      [S390] Remove volatile from atomic_t
      [S390] dasd: Avoid compile warnings on !CONFIG_DASD_PROFILE
      [S390] s390: rename CPU_IDLE to S390_CPU_IDLE

Martin Schwidefsky (2):
      [S390] Bogomips calculation for 64 bit.
      [S390] system call optimization.

Michael Holzheu (1):
      [S390] Program check in diag 210 under 31 bit

Ralph Wuerthner (2):
      [S390] Fixed comment typo.
      [S390] zcrypt: fix request timeout handling

Robert P. J. Day (1):
      [S390] vmcp cleanup

Stefan Haberland (1):
      [S390] fixed cdl-format detection.

diff --git a/arch/s390/crypto/crypt_s390.h b/arch/s390/crypto/crypt_s390.h
index 2775d26..95f5160 100644
--- a/arch/s390/crypto/crypt_s390.h
+++ b/arch/s390/crypto/crypt_s390.h
@@ -24,7 +24,7 @@
 #define CRYPT_S390_PRIORITY 300
 #define CRYPT_S390_COMPOSITE_PRIORITY 400
 
-/* s930 cryptographic operations */
+/* s390 cryptographic operations */
 enum crypt_s390_operations {
 	CRYPT_S390_KM   = 0x0100,
 	CRYPT_S390_KMC  = 0x0200,
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 50538e5..e6289ee 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -171,37 +171,6 @@ static inline int memory_fast_detect(void)
 }
 #endif
 
-#define ADDR2G	(1UL << 31)
-
-static noinline __init unsigned long sclp_memory_detect(void)
-{
-	struct sclp_readinfo_sccb *sccb;
-	unsigned long long memsize;
-
-	sccb = &s390_readinfo_sccb;
-
-	if (sccb->header.response_code != 0x10)
-		return 0;
-
-	if (sccb->rnsize)
-		memsize = sccb->rnsize << 20;
-	else
-		memsize = sccb->rnsize2 << 20;
-	if (sccb->rnmax)
-		memsize *= sccb->rnmax;
-	else
-		memsize *= sccb->rnmax2;
-#ifndef CONFIG_64BIT
-	/*
-	 * Can't deal with more than 2G in 31 bit addressing mode, so
-	 * limit the value in order to avoid strange side effects.
-	 */
-	if (memsize > ADDR2G)
-		memsize = ADDR2G;
-#endif
-	return (unsigned long) memsize;
-}
-
 static inline __init unsigned long __tprot(unsigned long addr)
 {
 	int cc = -1;
@@ -218,6 +187,7 @@ static inline __init unsigned long __tprot(unsigned long addr)
 
 /* Checking memory in 128KB increments. */
 #define CHUNK_INCR	(1UL << 17)
+#define ADDR2G		(1UL << 31)
 
 static noinline __init void find_memory_chunks(unsigned long memsize)
 {
@@ -293,7 +263,7 @@ static noinline __init void setup_lowcore_early(void)
  */
 void __init startup_init(void)
 {
-	unsigned long memsize;
+	unsigned long long memsize;
 
 	ipl_save_parameters();
 	clear_bss_section();
@@ -305,8 +275,17 @@ void __init startup_init(void)
 	sort_main_extable();
 	setup_lowcore_early();
 	sclp_readinfo_early();
+	sclp_facilities_detect();
 	memsize = sclp_memory_detect();
+#ifndef CONFIG_64BIT
+	/*
+	 * Can't deal with more than 2G in 31 bit addressing mode, so
+	 * limit the value in order to avoid strange side effects.
+	 */
+	if (memsize > ADDR2G)
+		memsize = ADDR2G;
+#endif
 	if (memory_fast_detect() < 0)
-		find_memory_chunks(memsize);
+		find_memory_chunks((unsigned long) memsize);
 	lockdep_on();
 }
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 6234c69..bc7ff36 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -107,6 +107,11 @@ STACK_SIZE  = 1 << STACK_SHIFT
 	l	%r13,__LC_SVC_NEW_PSW+4	# load &system_call to %r13
 	.endm
 
+	.macro	SAVE_ALL_SVC psworg,savearea
+	la	%r12,\psworg
+	l	%r15,__LC_KERNEL_STACK	# problem state -> load ksp
+	.endm
+
 	.macro	SAVE_ALL_SYNC psworg,savearea
 	la	%r12,\psworg
 	tm	\psworg+1,0x01		# test problem state bit
@@ -218,7 +223,7 @@ system_call:
 	STORE_TIMER __LC_SYNC_ENTER_TIMER
 sysc_saveall:
 	SAVE_ALL_BASE __LC_SAVE_AREA
-	SAVE_ALL_SYNC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
+	SAVE_ALL_SVC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	CREATE_STACK_FRAME __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	lh	%r7,0x8a	  # get svc number from lowcore
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 685f11f..2a7b130 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -99,6 +99,11 @@ _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_RESTORE_SIGMASK | _TIF_NEED_RESCHED | \
 	larl	%r13,system_call
 	.endm
 
+	.macro	SAVE_ALL_SVC psworg,savearea
+	la	%r12,\psworg
+	lg	%r15,__LC_KERNEL_STACK	# problem state -> load ksp
+	.endm
+
 	.macro	SAVE_ALL_SYNC psworg,savearea
 	la	%r12,\psworg
 	tm	\psworg+1,0x01		# test problem state bit
@@ -207,7 +212,7 @@ system_call:
 	STORE_TIMER __LC_SYNC_ENTER_TIMER
 sysc_saveall:
 	SAVE_ALL_BASE __LC_SAVE_AREA
-	SAVE_ALL_SYNC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
+	SAVE_ALL_SVC __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	CREATE_STACK_FRAME __LC_SVC_OLD_PSW,__LC_SAVE_AREA
 	llgh	%r7,__LC_SVC_INT_CODE	# get svc number from lowcore
 #ifdef CONFIG_VIRT_CPU_ACCOUNTING
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 367caf9..82b131d 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -25,10 +25,6 @@
 
 #define IPL_PARM_BLOCK_VERSION 0
 
-#define SCCB_VALID (s390_readinfo_sccb.header.response_code == 0x10)
-#define SCCB_LOADPARM (&s390_readinfo_sccb.loadparm)
-#define SCCB_FLAG (s390_readinfo_sccb.flags)
-
 #define IPL_UNKNOWN_STR		"unknown"
 #define IPL_CCW_STR		"ccw"
 #define IPL_FCP_STR		"fcp"
@@ -146,6 +142,8 @@ static struct ipl_parameter_block *dump_block_ccw;
 
 static enum shutdown_action on_panic_action = SHUTDOWN_STOP;
 
+static struct sclp_ipl_info sclp_ipl_info;
+
 int diag308(unsigned long subcode, void *addr)
 {
 	register unsigned long _addr asm("0") = (unsigned long) addr;
@@ -375,9 +373,9 @@ static ssize_t ipl_ccw_loadparm_show(struct kset *kset, char *page)
 {
 	char loadparm[LOADPARM_LEN + 1] = {};
 
-	if (!SCCB_VALID)
+	if (!sclp_ipl_info.is_valid)
 		return sprintf(page, "#unknown#\n");
-	memcpy(loadparm, SCCB_LOADPARM, LOADPARM_LEN);
+	memcpy(loadparm, &sclp_ipl_info.loadparm, LOADPARM_LEN);
 	EBCASC(loadparm, LOADPARM_LEN);
 	strstrip(loadparm);
 	return sprintf(page, "%s\n", loadparm);
@@ -910,9 +908,9 @@ static int __init reipl_ccw_init(void)
 	reipl_block_ccw->hdr.blk0_len = IPL_PARM_BLK0_CCW_LEN;
 	reipl_block_ccw->hdr.pbt = DIAG308_IPL_TYPE_CCW;
 	/* check if read scp info worked and set loadparm */
-	if (SCCB_VALID)
+	if (sclp_ipl_info.is_valid)
 		memcpy(reipl_block_ccw->ipl_info.ccw.load_param,
-		       SCCB_LOADPARM, LOADPARM_LEN);
+		       &sclp_ipl_info.loadparm, LOADPARM_LEN);
 	else
 		/* read scp info failed: set empty loadparm (EBCDIC blanks) */
 		memset(reipl_block_ccw->ipl_info.ccw.load_param, 0x40,
@@ -1007,7 +1005,7 @@ static int __init dump_fcp_init(void)
 {
 	int rc;
 
-	if(!(SCCB_FLAG & 0x2) || !SCCB_VALID)
+	if (!sclp_ipl_info.has_dump)
 		return 0; /* LDIPL DUMP is not installed */
 	if (!diag308_set_works)
 		return 0;
@@ -1088,6 +1086,7 @@ static int __init s390_ipl_init(void)
 {
 	int rc;
 
+	sclp_get_ipl_info(&sclp_ipl_info);
 	reipl_probe();
 	rc = ipl_init();
 	if (rc)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index eb43c3b..441975b 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -93,8 +93,8 @@ void do_monitor_call(struct pt_regs *regs, long interruption_code)
 	/* disable monitor call class 0 */
 	__ctl_clear_bit(8, 15);
 
-	atomic_notifier_call_chain(&idle_chain, CPU_NOT_IDLE,
-			    (void *)(long) smp_processor_id());
+	atomic_notifier_call_chain(&idle_chain, S390_CPU_NOT_IDLE,
+				   (void *)(long) smp_processor_id());
 }
 
 extern void s390_handle_mcck(void);
@@ -115,7 +115,7 @@ static void default_idle(void)
 	}
 
 	rc = atomic_notifier_call_chain(&idle_chain,
-			CPU_IDLE, (void *)(long) cpu);
+					S390_CPU_IDLE, (void *)(long) cpu);
 	if (rc != NOTIFY_OK && rc != NOTIFY_DONE)
 		BUG();
 	if (rc != NOTIFY_OK) {
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 8ff2fea..182c085 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -410,58 +410,40 @@ EXPORT_SYMBOL(smp_ctl_clear_bit);
 unsigned int zfcpdump_prefix_array[NR_CPUS + 1] \
 	__attribute__((__section__(".data")));
 
-static void __init smp_get_save_areas(void)
+static void __init smp_get_save_area(unsigned int cpu, unsigned int phy_cpu)
 {
-	unsigned int cpu, cpu_num, rc;
-	__u16 boot_cpu_addr;
-
 	if (ipl_info.type != IPL_TYPE_FCP_DUMP)
 		return;
-	boot_cpu_addr = S390_lowcore.cpu_data.cpu_addr;
-	cpu_num = 1;
-	for (cpu = 0; cpu <= 65535; cpu++) {
-		if ((u16) cpu == boot_cpu_addr)
-			continue;
-		__cpu_logical_map[1] = (__u16) cpu;
-		if (signal_processor(1, sigp_sense) == sigp_not_operational)
-			continue;
-		if (cpu_num >= NR_CPUS) {
-			printk("WARNING: Registers for cpu %i are not "
-			       "saved, since dump kernel was compiled with"
-			       "NR_CPUS=%i!\n", cpu_num, NR_CPUS);
-			continue;
-		}
-		zfcpdump_save_areas[cpu_num] =
-			alloc_bootmem(sizeof(union save_area));
-		while (1) {
-			rc = signal_processor(1, sigp_stop_and_store_status);
-			if (rc != sigp_busy)
-				break;
-			cpu_relax();
-		}
-		memcpy(zfcpdump_save_areas[cpu_num],
-		       (void *)(unsigned long) store_prefix() +
-		       SAVE_AREA_BASE, SAVE_AREA_SIZE);
-#ifdef __s390x__
-		/* copy original prefix register */
-		zfcpdump_save_areas[cpu_num]->s390x.pref_reg =
-			zfcpdump_prefix_array[cpu_num];
-#endif
-		cpu_num++;
+	if (cpu >= NR_CPUS) {
+		printk(KERN_WARNING "Registers for cpu %i not saved since dump "
+		       "kernel was compiled with NR_CPUS=%i\n", cpu, NR_CPUS);
+		return;
 	}
+	zfcpdump_save_areas[cpu] = alloc_bootmem(sizeof(union save_area));
+	__cpu_logical_map[1] = (__u16) phy_cpu;
+	while (signal_processor(1, sigp_stop_and_store_status) == sigp_busy)
+		cpu_relax();
+	memcpy(zfcpdump_save_areas[cpu],
+	       (void *)(unsigned long) store_prefix() + SAVE_AREA_BASE,
+	       SAVE_AREA_SIZE);
+#ifdef CONFIG_64BIT
+	/* copy original prefix register */
+	zfcpdump_save_areas[cpu]->s390x.pref_reg = zfcpdump_prefix_array[cpu];
+#endif
 }
 
 union save_area *zfcpdump_save_areas[NR_CPUS + 1];
 EXPORT_SYMBOL_GPL(zfcpdump_save_areas);
 
 #else
-#define smp_get_save_areas() do { } while (0)
-#endif
+
+static inline void smp_get_save_area(unsigned int cpu, unsigned int phy_cpu) { }
+
+#endif /* CONFIG_ZFCPDUMP || CONFIG_ZFCPDUMP_MODULE */
 
 /*
  * Lets check how many CPUs we have.
  */
-
 static unsigned int __init smp_count_cpus(void)
 {
 	unsigned int cpu, num_cpus;
@@ -470,7 +452,6 @@ static unsigned int __init smp_count_cpus(void)
 	/*
 	 * cpu 0 is the boot cpu. See smp_prepare_boot_cpu.
 	 */
-
 	boot_cpu_addr = S390_lowcore.cpu_data.cpu_addr;
 	current_thread_info()->cpu = 0;
 	num_cpus = 1;
@@ -480,12 +461,11 @@ static unsigned int __init smp_count_cpus(void)
 		__cpu_logical_map[1] = (__u16) cpu;
 		if (signal_processor(1, sigp_sense) == sigp_not_operational)
 			continue;
+		smp_get_save_area(num_cpus, cpu);
 		num_cpus++;
 	}
-
 	printk("Detected %d CPU's\n", (int) num_cpus);
 	printk("Boot cpu address %2X\n", boot_cpu_addr);
-
 	return num_cpus;
 }
 
@@ -606,7 +586,6 @@ void __init smp_setup_cpu_possible_map(void)
 {
 	unsigned int phy_cpus, pos_cpus, cpu;
 
-	smp_get_save_areas();
 	phy_cpus = smp_count_cpus();
 	pos_cpus = min(phy_cpus + additional_cpus, (unsigned int) NR_CPUS);
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 9c2872a..48dae49 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -226,10 +226,10 @@ static int nohz_idle_notify(struct notifier_block *self,
 			    unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_hz_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_hz_timer();
 		break;
 	}
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 1e1a6ee..b6ed143 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -545,10 +545,10 @@ static int vtimer_idle_notify(struct notifier_block *self,
 			      unsigned long action, void *hcpu)
 {
 	switch (action) {
-	case CPU_IDLE:
+	case S390_CPU_IDLE:
 		stop_cpu_timer();
 		break;
-	case CPU_NOT_IDLE:
+	case S390_CPU_NOT_IDLE:
 		start_cpu_timer();
 		break;
 	}
diff --git a/arch/s390/lib/Makefile b/arch/s390/lib/Makefile
index 59aea65..5208443 100644
--- a/arch/s390/lib/Makefile
+++ b/arch/s390/lib/Makefile
@@ -4,7 +4,7 @@
 
 EXTRA_AFLAGS := -traditional
 
-lib-y += delay.o string.o uaccess_std.o uaccess_pt.o qrnnd.o
-obj-$(CONFIG_32BIT) += div64.o
+lib-y += delay.o string.o uaccess_std.o uaccess_pt.o
+obj-$(CONFIG_32BIT) += div64.o qrnnd.o
 lib-$(CONFIG_64BIT) += uaccess_mvcos.o
 lib-$(CONFIG_SMP) += spinlock.o
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 8b3b0f4..ac7e8ef 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -28,6 +28,7 @@ static struct proc_dir_entry *dasd_proc_root_entry = NULL;
 static struct proc_dir_entry *dasd_devices_entry = NULL;
 static struct proc_dir_entry *dasd_statistics_entry = NULL;
 
+#ifdef CONFIG_DASD_PROFILE
 static char *
 dasd_get_user_string(const char __user *user_buf, size_t user_len)
 {
@@ -47,6 +48,7 @@ dasd_get_user_string(const char __user *user_buf, size_t user_len)
 		buffer[user_len] = 0;
 	return buffer;
 }
+#endif /* CONFIG_DASD_PROFILE */
 
 static int
 dasd_devices_show(struct seq_file *m, void *v)
@@ -167,6 +169,7 @@ dasd_calc_metrics(char *page, char **start, off_t off,
 	return len;
 }
 
+#ifdef CONFIG_DASD_PROFILE
 static char *
 dasd_statistics_array(char *str, unsigned int *array, int shift)
 {
@@ -180,6 +183,7 @@ dasd_statistics_array(char *str, unsigned int *array, int shift)
 	str += sprintf(str,"\n");
 	return str;
 }
+#endif /* CONFIG_DASD_PROFILE */
 
 static int
 dasd_statistics_read(char *page, char **start, off_t off,
diff --git a/drivers/s390/char/sclp.h b/drivers/s390/char/sclp.h
index dbb99d1..c7318a1 100644
--- a/drivers/s390/char/sclp.h
+++ b/drivers/s390/char/sclp.h
@@ -72,6 +72,18 @@ typedef unsigned int sclp_cmdw_t;
 
 typedef u32 sccb_mask_t;	/* ATTENTION: assumes 32bit mask !!! */
 
+struct sccb_header {
+	u16	length;
+	u8	function_code;
+	u8	control_mask[3];
+	u16	response_code;
+} __attribute__((packed));
+
+extern u64 sclp_facilities;
+
+#define SCLP_HAS_CHP_INFO	(sclp_facilities & 0x8000000000000000ULL)
+#define SCLP_HAS_CHP_RECONFIG	(sclp_facilities & 0x2000000000000000ULL)
+
 struct gds_subvector {
 	u8	length;
 	u8	key;
diff --git a/drivers/s390/char/sclp_chp.c b/drivers/s390/char/sclp_chp.c
index a66b914..c68f5e7 100644
--- a/drivers/s390/char/sclp_chp.c
+++ b/drivers/s390/char/sclp_chp.c
@@ -55,6 +55,8 @@ static int do_configure(sclp_cmdw_t cmd)
 	struct chp_cfg_data *data;
 	int rc;
 
+	if (!SCLP_HAS_CHP_RECONFIG)
+		return -EOPNOTSUPP;
 	/* Prepare sccb. */
 	data = (struct chp_cfg_data *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!data)
@@ -152,6 +154,8 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 	struct chp_info_data *data;
 	int rc;
 
+	if (!SCLP_HAS_CHP_INFO)
+		return -EOPNOTSUPP;
 	/* Prepare sccb. */
 	data = (struct chp_info_data *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 	if (!data)
diff --git a/drivers/s390/char/sclp_info.c b/drivers/s390/char/sclp_info.c
index 7bcbe64..a1136e0 100644
--- a/drivers/s390/char/sclp_info.c
+++ b/drivers/s390/char/sclp_info.c
@@ -11,47 +11,106 @@
 #include <asm/sclp.h>
 #include "sclp.h"
 
-struct sclp_readinfo_sccb s390_readinfo_sccb;
+struct sclp_readinfo_sccb {
+	struct	sccb_header header;	/* 0-7 */
+	u16	rnmax;			/* 8-9 */
+	u8	rnsize;			/* 10 */
+	u8	_reserved0[24 - 11];	/* 11-23 */
+	u8	loadparm[8];		/* 24-31 */
+	u8	_reserved1[48 - 32];	/* 32-47 */
+	u64	facilities;		/* 48-55 */
+	u8	_reserved2[91 - 56];	/* 56-90 */
+	u8	flags;			/* 91 */
+	u8	_reserved3[100 - 92];	/* 92-99 */
+	u32	rnsize2;		/* 100-103 */
+	u64	rnmax2;			/* 104-111 */
+	u8	_reserved4[4096 - 112];	/* 112-4095 */
+} __attribute__((packed, aligned(4096)));
+
+static struct sclp_readinfo_sccb __initdata early_readinfo_sccb;
+static int __initdata early_readinfo_sccb_valid;
+
+u64 sclp_facilities;
 
 void __init sclp_readinfo_early(void)
 {
-	sclp_cmdw_t command;
-	struct sccb_header *sccb;
 	int ret;
+	int i;
+	struct sclp_readinfo_sccb *sccb;
+	sclp_cmdw_t commands[] = {SCLP_CMDW_READ_SCP_INFO_FORCED,
+				  SCLP_CMDW_READ_SCP_INFO};
 
-	__ctl_set_bit(0, 9); /* enable service signal subclass mask */
-
-	sccb = &s390_readinfo_sccb.header;
-	command = SCLP_CMDW_READ_SCP_INFO_FORCED;
-	while (1) {
-		u16 response;
-
-		memset(&s390_readinfo_sccb, 0, sizeof(s390_readinfo_sccb));
-		sccb->length = sizeof(s390_readinfo_sccb);
-		sccb->control_mask[2] = 0x80;
-
-		ret = sclp_service_call(command, &s390_readinfo_sccb);
-
-		if (ret == -EIO)
-			goto out;
-		if (ret == -EBUSY)
-			continue;
+	/* Enable service signal subclass mask. */
+	__ctl_set_bit(0, 9);
+	sccb = &early_readinfo_sccb;
+	for (i = 0; i < ARRAY_SIZE(commands); i++) {
+		do {
+			memset(sccb, 0, sizeof(*sccb));
+			sccb->header.length = sizeof(*sccb);
+			sccb->header.control_mask[2] = 0x80;
+			ret = sclp_service_call(commands[i], sccb);
+		} while (ret == -EBUSY);
 
+		if (ret)
+			break;
 		__load_psw_mask(PSW_BASE_BITS | PSW_MASK_EXT |
 				PSW_MASK_WAIT | PSW_DEFAULT_KEY);
 		local_irq_disable();
+		/*
+		 * Contents of the sccb might have changed
+		 * therefore a barrier is needed.
+		 */
 		barrier();
+		if (sccb->header.response_code == 0x10) {
+			early_readinfo_sccb_valid = 1;
+			break;
+		}
+		if (sccb->header.response_code != 0x1f0)
+			break;
+	}
+	/* Disable service signal subclass mask again. */
+	__ctl_clear_bit(0, 9);
+}
 
-		response = sccb->response_code;
+void __init sclp_facilities_detect(void)
+{
+	if (!early_readinfo_sccb_valid)
+		return;
+	sclp_facilities = early_readinfo_sccb.facilities;
+}
 
-		if (response == 0x10)
-			break;
+unsigned long long __init sclp_memory_detect(void)
+{
+	unsigned long long memsize;
+	struct sclp_readinfo_sccb *sccb;
 
-		if (response != 0x1f0 || command == SCLP_CMDW_READ_SCP_INFO)
-			break;
+	if (!early_readinfo_sccb_valid)
+		return 0;
+	sccb = &early_readinfo_sccb;
+	if (sccb->rnsize)
+		memsize = sccb->rnsize << 20;
+	else
+		memsize = sccb->rnsize2 << 20;
+	if (sccb->rnmax)
+		memsize *= sccb->rnmax;
+	else
+		memsize *= sccb->rnmax2;
+	return memsize;
+}
 
-		command = SCLP_CMDW_READ_SCP_INFO;
-	}
-out:
-	__ctl_clear_bit(0, 9); /* disable service signal subclass mask */
+/*
+ * This function will be called after sclp_memory_detect(), which gets called
+ * early from early.c code. Therefore the sccb should have valid contents.
+ */
+void __init sclp_get_ipl_info(struct sclp_ipl_info *info)
+{
+	struct sclp_readinfo_sccb *sccb;
+
+	if (!early_readinfo_sccb_valid)
+		return;
+	sccb = &early_readinfo_sccb;
+	info->is_valid = 1;
+	if (sccb->flags & 0x2)
+		info->has_dump = 1;
+	memcpy(&info->loadparm, &sccb->loadparm, LOADPARM_LEN);
 }
diff --git a/drivers/s390/char/vmcp.c b/drivers/s390/char/vmcp.c
index fce3dac..82e6a6b 100644
--- a/drivers/s390/char/vmcp.c
+++ b/drivers/s390/char/vmcp.c
@@ -175,13 +175,12 @@ static long vmcp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 static const struct file_operations vmcp_fops = {
 	.owner		= THIS_MODULE,
-	.open		= &vmcp_open,
-	.release	= &vmcp_release,
-	.read		= &vmcp_read,
-	.llseek		= &no_llseek,
-	.write		= &vmcp_write,
-	.unlocked_ioctl	= &vmcp_ioctl,
-	.compat_ioctl	= &vmcp_ioctl
+	.open		= vmcp_open,
+	.release	= vmcp_release,
+	.read		= vmcp_read,
+	.write		= vmcp_write,
+	.unlocked_ioctl	= vmcp_ioctl,
+	.compat_ioctl	= vmcp_ioctl
 };
 
 static struct miscdevice vmcp_dev = {
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index a5a00e9..12f7a4c 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -835,7 +835,7 @@ static void vmlogrdr_cleanup(void)
 }
 
 
-static int vmlogrdr_init(void)
+static int __init vmlogrdr_init(void)
 {
 	int rc;
 	int i;
@@ -885,7 +885,7 @@ cleanup:
 }
 
 
-static void vmlogrdr_exit(void)
+static void __exit vmlogrdr_exit(void)
 {
 	vmlogrdr_cleanup();
 	printk (KERN_INFO "vmlogrdr: driver unloaded\n");
diff --git a/drivers/s390/char/zcore.c b/drivers/s390/char/zcore.c
index 4e711a9..3712ede 100644
--- a/drivers/s390/char/zcore.c
+++ b/drivers/s390/char/zcore.c
@@ -156,7 +156,7 @@ static int memcpy_real(void *dest, unsigned long src, size_t count)
 	return rc;
 }
 
-static int memcpy_real_user(__user void *dest, unsigned long src, size_t count)
+static int memcpy_real_user(void __user *dest, unsigned long src, size_t count)
 {
 	static char buf[4096];
 	int offs = 0, size;
diff --git a/drivers/s390/cio/device_id.c b/drivers/s390/cio/device_id.c
index 997f468..60b9347 100644
--- a/drivers/s390/cio/device_id.c
+++ b/drivers/s390/cio/device_id.c
@@ -27,7 +27,6 @@
 /*
  * diag210 is used under VM to get information about a virtual device
  */
-#ifdef CONFIG_64BIT
 int
 diag210(struct diag210 * addr)
 {
@@ -43,6 +42,7 @@ diag210(struct diag210 * addr)
 	spin_lock_irqsave(&diag210_lock, flags);
 	diag210_tmp = *addr;
 
+#ifdef CONFIG_64BIT
 	asm volatile(
 		"	lhi	%0,-1\n"
 		"	sam31\n"
@@ -51,19 +51,8 @@ diag210(struct diag210 * addr)
 		"	srl	%0,28\n"
 		"1:	sam64\n"
 		EX_TABLE(0b,1b)
-		: "=&d" (ccode) : "a" (__pa(&diag210_tmp)) : "cc", "memory");
-
-	*addr = diag210_tmp;
-	spin_unlock_irqrestore(&diag210_lock, flags);
-
-	return ccode;
-}
+		: "=&d" (ccode) : "a" (&diag210_tmp) : "cc", "memory");
 #else
-int
-diag210(struct diag210 * addr)
-{
-	int ccode;
-
 	asm volatile(
 		"	lhi	%0,-1\n"
 		"	diag	%1,0,0x210\n"
@@ -71,11 +60,14 @@ diag210(struct diag210 * addr)
 		"	srl	%0,28\n"
 		"1:\n"
 		EX_TABLE(0b,1b)
-		: "=&d" (ccode) : "a" (__pa(addr)) : "cc", "memory");
+		: "=&d" (ccode) : "a" (&diag210_tmp) : "cc", "memory");
+#endif
+
+	*addr = diag210_tmp;
+	spin_unlock_irqrestore(&diag210_lock, flags);
 
 	return ccode;
 }
-#endif
 
 /*
  * Input :
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 5aac0ec..90bd220 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -43,6 +43,7 @@ static void ap_poll_all(unsigned long);
 static void ap_poll_timeout(unsigned long);
 static int ap_poll_thread_start(void);
 static void ap_poll_thread_stop(void);
+static void ap_request_timeout(unsigned long);
 
 /**
  * Module description.
@@ -189,6 +190,7 @@ int ap_send(ap_qid_t qid, unsigned long long psmid, void *msg, size_t length)
 	case AP_RESPONSE_NORMAL:
 		return 0;
 	case AP_RESPONSE_Q_FULL:
+	case AP_RESPONSE_RESET_IN_PROGRESS:
 		return -EBUSY;
 	default:	/* Device is gone. */
 		return -ENODEV;
@@ -252,6 +254,8 @@ int ap_recv(ap_qid_t qid, unsigned long long *psmid, void *msg, size_t length)
 		if (status.queue_empty)
 			return -ENOENT;
 		return -EBUSY;
+	case AP_RESPONSE_RESET_IN_PROGRESS:
+		return -EBUSY;
 	default:
 		return -ENODEV;
 	}
@@ -326,11 +330,12 @@ static int ap_init_queue(ap_qid_t qid)
 			i = AP_MAX_RESET;	/* return with -ENODEV */
 			break;
 		case AP_RESPONSE_RESET_IN_PROGRESS:
+			rc = -EBUSY;
 		case AP_RESPONSE_BUSY:
 		default:
 			break;
 		}
-		if (rc != -ENODEV)
+		if (rc != -ENODEV && rc != -EBUSY)
 			break;
 		if (i < AP_MAX_RESET - 1) {
 			udelay(5);
@@ -341,6 +346,40 @@ static int ap_init_queue(ap_qid_t qid)
 }
 
 /**
+ * Arm request timeout if a AP device was idle and a new request is submitted.
+ */
+static void ap_increase_queue_count(struct ap_device *ap_dev)
+{
+	int timeout = ap_dev->drv->request_timeout;
+
+	ap_dev->queue_count++;
+	if (ap_dev->queue_count == 1) {
+		mod_timer(&ap_dev->timeout, jiffies + timeout);
+		ap_dev->reset = AP_RESET_ARMED;
+	}
+}
+
+/**
+ * AP device is still alive, re-schedule request timeout if there are still
+ * pending requests.
+ */
+static void ap_decrease_queue_count(struct ap_device *ap_dev)
+{
+	int timeout = ap_dev->drv->request_timeout;
+
+	ap_dev->queue_count--;
+	if (ap_dev->queue_count > 0)
+		mod_timer(&ap_dev->timeout, jiffies + timeout);
+	else
+		/**
+		 * The timeout timer should to be disabled now - since
+		 * del_timer_sync() is very expensive, we just tell via the
+		 * reset flag to ignore the pending timeout timer.
+		 */
+		ap_dev->reset = AP_RESET_IGNORE;
+}
+
+/**
  * AP device related attributes.
  */
 static ssize_t ap_hwtype_show(struct device *dev,
@@ -498,6 +537,7 @@ static int ap_device_remove(struct device *dev)
 	struct ap_driver *ap_drv = ap_dev->drv;
 
 	ap_flush_queue(ap_dev);
+	del_timer_sync(&ap_dev->timeout);
 	if (ap_drv->remove)
 		ap_drv->remove(ap_dev);
 	spin_lock_bh(&ap_device_lock);
@@ -759,17 +799,21 @@ static void ap_scan_bus(struct work_struct *unused)
 				      __ap_scan_bus);
 		rc = ap_query_queue(qid, &queue_depth, &device_type);
 		if (dev) {
+			if (rc == -EBUSY) {
+				set_current_state(TASK_UNINTERRUPTIBLE);
+				schedule_timeout(AP_RESET_TIMEOUT);
+				rc = ap_query_queue(qid, &queue_depth,
+						    &device_type);
+			}
 			ap_dev = to_ap_dev(dev);
 			spin_lock_bh(&ap_dev->lock);
 			if (rc || ap_dev->unregistered) {
 				spin_unlock_bh(&ap_dev->lock);
-				put_device(dev);
 				device_unregister(dev);
+				put_device(dev);
 				continue;
-			} else
-				spin_unlock_bh(&ap_dev->lock);
-		}
-		if (dev) {
+			}
+			spin_unlock_bh(&ap_dev->lock);
 			put_device(dev);
 			continue;
 		}
@@ -788,6 +832,8 @@ static void ap_scan_bus(struct work_struct *unused)
 		INIT_LIST_HEAD(&ap_dev->pendingq);
 		INIT_LIST_HEAD(&ap_dev->requestq);
 		INIT_LIST_HEAD(&ap_dev->list);
+		setup_timer(&ap_dev->timeout, ap_request_timeout,
+			    (unsigned long) ap_dev);
 		if (device_type == 0)
 			ap_probe_device_type(ap_dev);
 		else
@@ -853,7 +899,7 @@ static int ap_poll_read(struct ap_device *ap_dev, unsigned long *flags)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		atomic_dec(&ap_poll_requests);
-		ap_dev->queue_count--;
+		ap_decrease_queue_count(ap_dev);
 		list_for_each_entry(ap_msg, &ap_dev->pendingq, list) {
 			if (ap_msg->psmid != ap_dev->reply->psmid)
 				continue;
@@ -904,7 +950,7 @@ static int ap_poll_write(struct ap_device *ap_dev, unsigned long *flags)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		atomic_inc(&ap_poll_requests);
-		ap_dev->queue_count++;
+		ap_increase_queue_count(ap_dev);
 		list_move_tail(&ap_msg->list, &ap_dev->pendingq);
 		ap_dev->requestq_count--;
 		ap_dev->pendingq_count++;
@@ -914,6 +960,7 @@ static int ap_poll_write(struct ap_device *ap_dev, unsigned long *flags)
 		*flags |= 2;
 		break;
 	case AP_RESPONSE_Q_FULL:
+	case AP_RESPONSE_RESET_IN_PROGRESS:
 		*flags |= 2;
 		break;
 	case AP_RESPONSE_MESSAGE_TOO_BIG:
@@ -960,10 +1007,11 @@ static int __ap_queue_message(struct ap_device *ap_dev, struct ap_message *ap_ms
 			list_add_tail(&ap_msg->list, &ap_dev->pendingq);
 			atomic_inc(&ap_poll_requests);
 			ap_dev->pendingq_count++;
-			ap_dev->queue_count++;
+			ap_increase_queue_count(ap_dev);
 			ap_dev->total_request_count++;
 			break;
 		case AP_RESPONSE_Q_FULL:
+		case AP_RESPONSE_RESET_IN_PROGRESS:
 			list_add_tail(&ap_msg->list, &ap_dev->requestq);
 			ap_dev->requestq_count++;
 			ap_dev->total_request_count++;
@@ -1046,6 +1094,25 @@ static void ap_poll_timeout(unsigned long unused)
 }
 
 /**
+ * Reset a not responding AP device and move all requests from the
+ * pending queue to the request queue.
+ */
+static void ap_reset(struct ap_device *ap_dev)
+{
+	int rc;
+
+	ap_dev->reset = AP_RESET_IGNORE;
+	atomic_sub(ap_dev->queue_count, &ap_poll_requests);
+	ap_dev->queue_count = 0;
+	list_splice_init(&ap_dev->pendingq, &ap_dev->requestq);
+	ap_dev->requestq_count += ap_dev->pendingq_count;
+	ap_dev->pendingq_count = 0;
+	rc = ap_init_queue(ap_dev->qid);
+	if (rc == -ENODEV)
+		ap_dev->unregistered = 1;
+}
+
+/**
  * Poll all AP devices on the bus in a round robin fashion. Continue
  * polling until bit 2^0 of the control flags is not set. If bit 2^1
  * of the control flags has been set arm the poll timer.
@@ -1056,6 +1123,8 @@ static int __ap_poll_all(struct ap_device *ap_dev, unsigned long *flags)
 	if (!ap_dev->unregistered) {
 		if (ap_poll_queue(ap_dev, flags))
 			ap_dev->unregistered = 1;
+		if (ap_dev->reset == AP_RESET_DO)
+			ap_reset(ap_dev);
 	}
 	spin_unlock(&ap_dev->lock);
 	return 0;
@@ -1147,6 +1216,17 @@ static void ap_poll_thread_stop(void)
 	mutex_unlock(&ap_poll_thread_mutex);
 }
 
+/**
+ * Handling of request timeouts
+ */
+static void ap_request_timeout(unsigned long data)
+{
+	struct ap_device *ap_dev = (struct ap_device *) data;
+
+	if (ap_dev->reset == AP_RESET_ARMED)
+		ap_dev->reset = AP_RESET_DO;
+}
+
 static void ap_reset_domain(void)
 {
 	int i;
diff --git a/drivers/s390/crypto/ap_bus.h b/drivers/s390/crypto/ap_bus.h
index 008559e..87c2d64 100644
--- a/drivers/s390/crypto/ap_bus.h
+++ b/drivers/s390/crypto/ap_bus.h
@@ -33,6 +33,7 @@
 #define AP_DEVICES 64		/* Number of AP devices. */
 #define AP_DOMAINS 16		/* Number of AP domains. */
 #define AP_MAX_RESET 90		/* Maximum number of resets. */
+#define AP_RESET_TIMEOUT (HZ/2)	/* Time in ticks for reset timeouts. */
 #define AP_CONFIG_TIME 30	/* Time in seconds between AP bus rescans. */
 #define AP_POLL_TIME 1		/* Time in ticks between receive polls. */
 
@@ -83,6 +84,13 @@ struct ap_queue_status {
 #define AP_DEVICE_TYPE_CEX2A	6
 #define AP_DEVICE_TYPE_CEX2C	7
 
+/**
+ * AP reset flag states
+ */
+#define AP_RESET_IGNORE	0	/* request timeout will be ignored */
+#define AP_RESET_ARMED	1	/* request timeout timer is active */
+#define AP_RESET_DO	2	/* AP reset required */
+
 struct ap_device;
 struct ap_message;
 
@@ -95,6 +103,7 @@ struct ap_driver {
 	/* receive is called from tasklet context */
 	void (*receive)(struct ap_device *, struct ap_message *,
 			struct ap_message *);
+	int request_timeout;		/* request timeout in jiffies */
 };
 
 #define to_ap_drv(x) container_of((x), struct ap_driver, driver)
@@ -112,6 +121,8 @@ struct ap_device {
 	int queue_depth;		/* AP queue depth.*/
 	int device_type;		/* AP device type. */
 	int unregistered;		/* marks AP device as unregistered */
+	struct timer_list timeout;	/* Timer for request timeouts. */
+	int reset;			/* Reset required after req. timeout. */
 
 	int queue_count;		/* # messages currently on AP queue. */
 
diff --git a/drivers/s390/crypto/zcrypt_cex2a.c b/drivers/s390/crypto/zcrypt_cex2a.c
index 5bb13a9..08657f6 100644
--- a/drivers/s390/crypto/zcrypt_cex2a.c
+++ b/drivers/s390/crypto/zcrypt_cex2a.c
@@ -70,6 +70,7 @@ static struct ap_driver zcrypt_cex2a_driver = {
 	.remove = zcrypt_cex2a_remove,
 	.receive = zcrypt_cex2a_receive,
 	.ids = zcrypt_cex2a_ids,
+	.request_timeout = CEX2A_CLEANUP_TIME,
 };
 
 /**
@@ -306,18 +307,13 @@ static long zcrypt_cex2a_modexpo(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, CEX2A_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, mex->outputdata,
 				      mex->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	kfree(ap_msg.message);
 	return rc;
@@ -348,18 +344,13 @@ static long zcrypt_cex2a_modexpo_crt(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, CEX2A_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, crt->outputdata,
 				      crt->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	kfree(ap_msg.message);
 	return rc;
diff --git a/drivers/s390/crypto/zcrypt_pcica.c b/drivers/s390/crypto/zcrypt_pcica.c
index 818ffe0..6e93b47 100644
--- a/drivers/s390/crypto/zcrypt_pcica.c
+++ b/drivers/s390/crypto/zcrypt_pcica.c
@@ -70,6 +70,7 @@ static struct ap_driver zcrypt_pcica_driver = {
 	.remove = zcrypt_pcica_remove,
 	.receive = zcrypt_pcica_receive,
 	.ids = zcrypt_pcica_ids,
+	.request_timeout = PCICA_CLEANUP_TIME,
 };
 
 /**
@@ -290,18 +291,13 @@ static long zcrypt_pcica_modexpo(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, PCICA_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, mex->outputdata,
 				      mex->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	kfree(ap_msg.message);
 	return rc;
@@ -332,18 +328,13 @@ static long zcrypt_pcica_modexpo_crt(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, PCICA_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, crt->outputdata,
 				      crt->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	kfree(ap_msg.message);
 	return rc;
diff --git a/drivers/s390/crypto/zcrypt_pcicc.c b/drivers/s390/crypto/zcrypt_pcicc.c
index f295a40..d6d59bf 100644
--- a/drivers/s390/crypto/zcrypt_pcicc.c
+++ b/drivers/s390/crypto/zcrypt_pcicc.c
@@ -82,6 +82,7 @@ static struct ap_driver zcrypt_pcicc_driver = {
 	.remove = zcrypt_pcicc_remove,
 	.receive = zcrypt_pcicc_receive,
 	.ids = zcrypt_pcicc_ids,
+	.request_timeout = PCICC_CLEANUP_TIME,
 };
 
 /**
@@ -501,18 +502,13 @@ static long zcrypt_pcicc_modexpo(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, PCICC_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, mex->outputdata,
 				      mex->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	free_page((unsigned long) ap_msg.message);
 	return rc;
@@ -544,18 +540,13 @@ static long zcrypt_pcicc_modexpo_crt(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&work, PCICC_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&work);
+	if (rc == 0)
 		rc = convert_response(zdev, &ap_msg, crt->outputdata,
 				      crt->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	free_page((unsigned long) ap_msg.message);
 	return rc;
diff --git a/drivers/s390/crypto/zcrypt_pcixcc.c b/drivers/s390/crypto/zcrypt_pcixcc.c
index 252443b..6494878 100644
--- a/drivers/s390/crypto/zcrypt_pcixcc.c
+++ b/drivers/s390/crypto/zcrypt_pcixcc.c
@@ -93,6 +93,7 @@ static struct ap_driver zcrypt_pcixcc_driver = {
 	.remove = zcrypt_pcixcc_remove,
 	.receive = zcrypt_pcixcc_receive,
 	.ids = zcrypt_pcixcc_ids,
+	.request_timeout = PCIXCC_CLEANUP_TIME,
 };
 
 /**
@@ -641,18 +642,13 @@ static long zcrypt_pcixcc_modexpo(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&resp_type.work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&resp_type.work, PCIXCC_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&resp_type.work);
+	if (rc == 0)
 		rc = convert_response_ica(zdev, &ap_msg, mex->outputdata,
 					  mex->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	free_page((unsigned long) ap_msg.message);
 	return rc;
@@ -685,18 +681,13 @@ static long zcrypt_pcixcc_modexpo_crt(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&resp_type.work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&resp_type.work, PCIXCC_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&resp_type.work);
+	if (rc == 0)
 		rc = convert_response_ica(zdev, &ap_msg, crt->outputdata,
 					  crt->outputdatalength);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	free_page((unsigned long) ap_msg.message);
 	return rc;
@@ -729,17 +720,12 @@ static long zcrypt_pcixcc_send_cprb(struct zcrypt_device *zdev,
 		goto out_free;
 	init_completion(&resp_type.work);
 	ap_queue_message(zdev->ap_dev, &ap_msg);
-	rc = wait_for_completion_interruptible_timeout(
-				&resp_type.work, PCIXCC_CLEANUP_TIME);
-	if (rc > 0)
+	rc = wait_for_completion_interruptible(&resp_type.work);
+	if (rc == 0)
 		rc = convert_response_xcrb(zdev, &ap_msg, xcRB);
-	else {
-		/* Signal pending or message timed out. */
+	else
+		/* Signal pending. */
 		ap_cancel_message(zdev->ap_dev, &ap_msg);
-		if (rc == 0)
-			/* Message timed out. */
-			rc = -ETIME;
-	}
 out_free:
 	memset(ap_msg.message, 0x0, ap_msg.length);
 	kfree(ap_msg.message);
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index 9f7ad42..1e064c4 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -45,7 +45,7 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
 	int blocksize, offset, size,res;
 	loff_t i_size;
-	dasd_information_t *info;
+	dasd_information2_t *info;
 	struct hd_geometry *geo;
 	char type[5] = {0,};
 	char name[7] = {0,};
@@ -64,14 +64,17 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 	if (i_size == 0)
 		goto out_exit;
 
-	if ((info = kmalloc(sizeof(dasd_information_t), GFP_KERNEL)) == NULL)
+	info = kmalloc(sizeof(dasd_information2_t), GFP_KERNEL);
+	if (info == NULL)
 		goto out_exit;
-	if ((geo = kmalloc(sizeof(struct hd_geometry), GFP_KERNEL)) == NULL)
+	geo = kmalloc(sizeof(struct hd_geometry), GFP_KERNEL);
+	if (geo == NULL)
 		goto out_nogeo;
-	if ((label = kmalloc(sizeof(union label_t), GFP_KERNEL)) == NULL)
+	label = kmalloc(sizeof(union label_t), GFP_KERNEL);
+	if (label == NULL)
 		goto out_nolab;
 
-	if (ioctl_by_bdev(bdev, BIODASDINFO, (unsigned long)info) != 0 ||
+	if (ioctl_by_bdev(bdev, BIODASDINFO2, (unsigned long)info) != 0 ||
 	    ioctl_by_bdev(bdev, HDIO_GETGEO, (unsigned long)geo) != 0)
 		goto out_freeall;
 
@@ -96,84 +99,108 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 	res = 1;
 
 	/*
-	 * Three different types: CMS1, VOL1 and LNX1/unlabeled
+	 * Three different formats: LDL, CDL and unformated disk
+	 *
+	 * identified by info->format
+	 *
+	 * unformated disks we do not have to care about
 	 */
-	if (strncmp(type, "CMS1", 4) == 0) {
-		/*
-		 * VM style CMS1 labeled disk
-		 */
-		if (label->cms.disk_offset != 0) {
-			printk("CMS1/%8s(MDSK):", name);
-			/* disk is reserved minidisk */
-			blocksize = label->cms.block_size;
-			offset = label->cms.disk_offset;
-			size = (label->cms.block_count - 1) * (blocksize >> 9);
+	if (info->format == DASD_FORMAT_LDL) {
+		if (strncmp(type, "CMS1", 4) == 0) {
+			/*
+			 * VM style CMS1 labeled disk
+			 */
+			if (label->cms.disk_offset != 0) {
+				printk("CMS1/%8s(MDSK):", name);
+				/* disk is reserved minidisk */
+				blocksize = label->cms.block_size;
+				offset = label->cms.disk_offset;
+				size = (label->cms.block_count - 1)
+					* (blocksize >> 9);
+			} else {
+				printk("CMS1/%8s:", name);
+				offset = (info->label_block + 1);
+				size = i_size >> 9;
+			}
 		} else {
-			printk("CMS1/%8s:", name);
+			/*
+			 * Old style LNX1 or unlabeled disk
+			 */
+			if (strncmp(type, "LNX1", 4) == 0)
+				printk ("LNX1/%8s:", name);
+			else
+				printk("(nonl)");
 			offset = (info->label_block + 1);
 			size = i_size >> 9;
 		}
 		put_partition(state, 1, offset*(blocksize >> 9),
-				 size-offset*(blocksize >> 9));
-	} else if ((strncmp(type, "VOL1", 4) == 0) &&
-		(!info->FBA_layout) && (!strcmp(info->type, "ECKD"))) {
+				      size-offset*(blocksize >> 9));
+	} else if (info->format == DASD_FORMAT_CDL) {
 		/*
-		 * New style VOL1 labeled disk
+		 * New style CDL formatted disk
 		 */
 		unsigned int blk;
 		int counter;
 
-		printk("VOL1/%8s:", name);
-
-		/* get block number and read then go through format1 labels */
-		blk = cchhb2blk(&label->vol.vtoc, geo) + 1;
-		counter = 0;
-		while ((data = read_dev_sector(bdev, blk*(blocksize/512),
-					       &sect)) != NULL) {
-			struct vtoc_format1_label f1;
-
-			memcpy(&f1, data, sizeof(struct vtoc_format1_label));
-			put_dev_sector(sect);
-
-			/* skip FMT4 / FMT5 / FMT7 labels */
-			if (f1.DS1FMTID == _ascebc['4']
-			    || f1.DS1FMTID == _ascebc['5']
-			    || f1.DS1FMTID == _ascebc['7']) {
-			        blk++;
-				continue;
-			}
-
-			/* only FMT1 valid at this point */
-			if (f1.DS1FMTID != _ascebc['1'])
-				break;
-
-			/* OK, we got valid partition data */
-		        offset = cchh2blk(&f1.DS1EXT1.llimit, geo);
-			size  = cchh2blk(&f1.DS1EXT1.ulimit, geo) -
-				offset + geo->sectors;
-			if (counter >= state->limit)
-				break;
-			put_partition(state, counter + 1,
-				      offset * (blocksize >> 9),
-				      size * (blocksize >> 9));
-			counter++;
-			blk++;
-		}
-		if (!data)
-		/* Are we not supposed to report this ? */
-			goto out_readerr;
-	} else {
 		/*
-		 * Old style LNX1 or unlabeled disk
+		 * check if VOL1 label is available
+		 * if not, something is wrong, skipping partition detection
 		 */
-		if (strncmp(type, "LNX1", 4) == 0)
-			printk ("LNX1/%8s:", name);
-		else
-			printk("(nonl)/%8s:", name);
-		offset = (info->label_block + 1);
-		size = i_size >> 9;
-		put_partition(state, 1, offset*(blocksize >> 9),
-			      size-offset*(blocksize >> 9));
+		if (strncmp(type, "VOL1",  4) == 0) {
+			printk("VOL1/%8s:", name);
+			/*
+			 * get block number and read then go through format1
+			 * labels
+			 */
+			blk = cchhb2blk(&label->vol.vtoc, geo) + 1;
+			counter = 0;
+			data = read_dev_sector(bdev, blk * (blocksize/512),
+					       &sect);
+			while (data != NULL) {
+				struct vtoc_format1_label f1;
+
+				memcpy(&f1, data,
+				       sizeof(struct vtoc_format1_label));
+				put_dev_sector(sect);
+
+				/* skip FMT4 / FMT5 / FMT7 labels */
+				if (f1.DS1FMTID == _ascebc['4']
+				    || f1.DS1FMTID == _ascebc['5']
+				    || f1.DS1FMTID == _ascebc['7']) {
+					blk++;
+					data = read_dev_sector(bdev, blk *
+							       (blocksize/512),
+								&sect);
+					continue;
+				}
+
+				/* only FMT1 valid at this point */
+				if (f1.DS1FMTID != _ascebc['1'])
+					break;
+
+				/* OK, we got valid partition data */
+				offset = cchh2blk(&f1.DS1EXT1.llimit, geo);
+				size  = cchh2blk(&f1.DS1EXT1.ulimit, geo) -
+					offset + geo->sectors;
+				if (counter >= state->limit)
+					break;
+				put_partition(state, counter + 1,
+					      offset * (blocksize >> 9),
+					      size * (blocksize >> 9));
+				counter++;
+				blk++;
+				data = read_dev_sector(bdev,
+						       blk * (blocksize/512),
+						       &sect);
+			}
+
+			if (!data)
+				/* Are we not supposed to report this ? */
+				goto out_readerr;
+		} else
+			printk(KERN_WARNING "Warning, expected Label VOL1 not "
+			       "found, treating as CDL formated Disk");
+
 	}
 
 	printk("\n");
diff --git a/include/asm-s390/atomic.h b/include/asm-s390/atomic.h
index c17bdbf..ea48695 100644
--- a/include/asm-s390/atomic.h
+++ b/include/asm-s390/atomic.h
@@ -24,7 +24,7 @@
  */
 
 typedef struct {
-	volatile int counter;
+	int counter;
 } __attribute__ ((aligned (4))) atomic_t;
 #define ATOMIC_INIT(i)  { (i) }
 
@@ -141,7 +141,7 @@ static __inline__ int atomic_add_unless(atomic_t *v, int a, int u)
 
 #ifdef __s390x__
 typedef struct {
-	volatile long long counter;
+	long long counter;
 } __attribute__ ((aligned (8))) atomic64_t;
 #define ATOMIC64_INIT(i)  { (i) }
 
diff --git a/include/asm-s390/cmb.h b/include/asm-s390/cmb.h
index 241756f..021e7c3 100644
--- a/include/asm-s390/cmb.h
+++ b/include/asm-s390/cmb.h
@@ -88,7 +88,6 @@ extern u64 cmf_read(struct ccw_device *cdev, int index);
  *    any
  **/
 extern int cmf_readall(struct ccw_device *cdev, struct cmbdata*data);
-extern void cmf_reset(struct ccw_device *cdev);
 
 #endif /* __KERNEL__ */
 #endif /* S390_CMB_H */
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index 5cb480a..3b972d4 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -357,8 +357,8 @@ extern void (*s390_base_ext_handler_fn)(void);
 /*
  * CPU idle notifier chain.
  */
-#define CPU_IDLE	0
-#define CPU_NOT_IDLE	1
+#define S390_CPU_IDLE		0
+#define S390_CPU_NOT_IDLE	1
 
 struct notifier_block;
 int register_idle_notifier(struct notifier_block *nb);
diff --git a/include/asm-s390/sclp.h b/include/asm-s390/sclp.h
index 21ed647..cb9faf1 100644
--- a/include/asm-s390/sclp.h
+++ b/include/asm-s390/sclp.h
@@ -11,29 +11,6 @@
 #include <linux/types.h>
 #include <asm/chpid.h>
 
-struct sccb_header {
-	u16	length;
-	u8	function_code;
-	u8	control_mask[3];
-	u16	response_code;
-} __attribute__((packed));
-
-#define LOADPARM_LEN 8
-
-struct sclp_readinfo_sccb {
-	struct	sccb_header header;	/* 0-7 */
-	u16	rnmax;			/* 8-9 */
-	u8	rnsize;			/* 10 */
-	u8	_reserved0[24 - 11];	/* 11-23 */
-	u8	loadparm[LOADPARM_LEN];	/* 24-31 */
-	u8	_reserved1[91 - 32];	/* 32-90 */
-	u8	flags;			/* 91 */
-	u8	_reserved2[100 - 92];	/* 92-99 */
-	u32	rnsize2;		/* 100-103 */
-	u64	rnmax2;			/* 104-111 */
-	u8	_reserved3[4096 - 112];	/* 112-4095 */
-} __attribute__((packed, aligned(4096)));
-
 #define SCLP_CHP_INFO_MASK_SIZE		32
 
 struct sclp_chp_info {
@@ -42,12 +19,22 @@ struct sclp_chp_info {
 	u8 configured[SCLP_CHP_INFO_MASK_SIZE];
 };
 
-extern struct sclp_readinfo_sccb s390_readinfo_sccb;
-extern void sclp_readinfo_early(void);
-extern int sclp_sdias_blk_count(void);
-extern int sclp_sdias_copy(void *dest, int blk_num, int nr_blks);
-extern int sclp_chp_configure(struct chp_id chpid);
-extern int sclp_chp_deconfigure(struct chp_id chpid);
-extern int sclp_chp_read_info(struct sclp_chp_info *info);
+#define LOADPARM_LEN 8
+
+struct sclp_ipl_info {
+	int is_valid;
+	int has_dump;
+	char loadparm[LOADPARM_LEN];
+};
+
+void sclp_readinfo_early(void);
+void sclp_facilities_detect(void);
+unsigned long long sclp_memory_detect(void);
+int sclp_sdias_blk_count(void);
+int sclp_sdias_copy(void *dest, int blk_num, int nr_blks);
+int sclp_chp_configure(struct chp_id chpid);
+int sclp_chp_deconfigure(struct chp_id chpid);
+int sclp_chp_read_info(struct sclp_chp_info *info);
+void sclp_get_ipl_info(struct sclp_ipl_info *info);
 
 #endif /* _ASM_S390_SCLP_H */
diff --git a/include/asm-s390/sfp-machine.h b/include/asm-s390/sfp-machine.h
index 8ca8c77..4e16aed 100644
--- a/include/asm-s390/sfp-machine.h
+++ b/include/asm-s390/sfp-machine.h
@@ -27,9 +27,9 @@
    
 
 #define _FP_W_TYPE_SIZE		32
-#define _FP_W_TYPE		unsigned long
-#define _FP_WS_TYPE		signed long
-#define _FP_I_TYPE		long
+#define _FP_W_TYPE		unsigned int
+#define _FP_WS_TYPE		signed int
+#define _FP_I_TYPE		int
 
 #define _FP_MUL_MEAT_S(R,X,Y)					\
   _FP_MUL_MEAT_1_wide(_FP_WFRACBITS_S,R,X,Y,umul_ppmm)
diff --git a/include/asm-s390/sfp-util.h b/include/asm-s390/sfp-util.h
index 8cabcd2..0addc64 100644
--- a/include/asm-s390/sfp-util.h
+++ b/include/asm-s390/sfp-util.h
@@ -51,6 +51,16 @@
 	wl = __wl;					\
 })
 
+#ifdef __s390x__
+#define udiv_qrnnd(q, r, n1, n0, d)			\
+  do { unsigned long __n;				\
+       unsigned int __r, __d;				\
+    __n = ((unsigned long)(n1) << 32) + n0;		\
+    __d = (d);						\
+    (q) = __n / __d;					\
+    (r) = __n % __d;					\
+  } while (0)
+#else
 #define udiv_qrnnd(q, r, n1, n0, d)			\
   do { unsigned int __r;				\
     (q) = __udiv_qrnnd (&__r, (n1), (n0), (d));		\
@@ -58,6 +68,7 @@
   } while (0)
 extern unsigned long __udiv_qrnnd (unsigned int *, unsigned int,
 				   unsigned int , unsigned int);
+#endif
 
 #define UDIV_NEEDS_NORMALIZATION 0
 


