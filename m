Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZFVM6q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZFVM6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 08:58:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752090AbZFVM6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 08:58:38 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:59833 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbZFVM6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 08:58:34 -0400
Date: Mon, 22 Jun 2009 14:58:34 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-s390 <linux-s390@vger.kernel.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.31
Message-ID: <20090622145834.61cc016b@skybase>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Felix Beck (1):
      [S390] ap/zcrypt: Suspend/Resume ap bus and zcrypt

Heiko Carstens (7):
      [S390] time: convert from bootmem to slab
      [S390] 3215 console: convert from bootmem to slab
      [S390] 3270 console: convert from bootmem to slab
      [S390] sclp console: convert from bootmem to slab
      [S390] vt220 console: convert from bootmem to slab
      [S390] pm: fix build error for !SMP
      [S390] kprobes: defer setting of ctlblk state

Jan Glauber (6):
      [S390] qdio: move adapter interrupt tasklet code
      [S390] qdio: fix check for running under z/VM
      [S390] qdio: extract all primed SBALs at once
      [S390] qdio: merge AI tasklet into interrupt handler
      [S390] qdio: leave inbound SBALs primed
      [S390] qdio: Sanitize do_QDIO sanity checks

Martin Schwidefsky (4):
      [S390] driver_data access
      [S390] lockless idle time accounting
      [S390] Enable tick based perf_counter on s390.
      [S390] Update default configuration.

Michael Holzheu (1):
      [S390] Use del_timer instead of del_timer_sync

Pekka Enberg (1):
      [S390] s390: remove DEBUG_MALLOC

Sebastian Ott (1):
      [S390] dasd: fix refcounting in dasd_change_state

Stefan Haberland (1):
      [S390] dasd_pm: fix stop flag handling

 arch/s390/Kconfig                    |    1 +
 arch/s390/defconfig                  |   72 +++++++++++++----
 arch/s390/include/asm/cputime.h      |    2 +-
 arch/s390/include/asm/debug.h        |    9 --
 arch/s390/include/asm/perf_counter.h |    8 ++
 arch/s390/include/asm/qdio.h         |    2 +-
 arch/s390/kernel/kprobes.c           |   18 ++---
 arch/s390/kernel/smp.c               |   28 +++++--
 arch/s390/kernel/time.c              |   16 +---
 arch/s390/kernel/vtime.c             |   27 ++++---
 arch/s390/power/swsusp_asm64.S       |    6 +-
 drivers/s390/block/dasd.c            |   20 ++++-
 drivers/s390/block/dasd_eckd.c       |   10 +--
 drivers/s390/char/con3215.c          |   22 ++---
 drivers/s390/char/con3270.c          |   13 +--
 drivers/s390/char/monreader.c        |    6 +-
 drivers/s390/char/raw3270.c          |   36 +--------
 drivers/s390/char/sclp_con.c         |    7 +-
 drivers/s390/char/sclp_vt220.c       |   18 +---
 drivers/s390/char/tape_core.c        |    2 +-
 drivers/s390/char/vmlogrdr.c         |    4 +-
 drivers/s390/char/vmur.c             |    2 +-
 drivers/s390/cio/qdio.h              |   11 +--
 drivers/s390/cio/qdio_debug.c        |    3 +-
 drivers/s390/cio/qdio_main.c         |  144 +++++++++++++++++----------------
 drivers/s390/cio/qdio_thinint.c      |  114 ++++-----------------------
 drivers/s390/crypto/ap_bus.c         |   85 +++++++++++++++++++-
 drivers/s390/net/netiucv.c           |    4 +-
 tools/perf/perf.h                    |    6 ++
 29 files changed, 350 insertions(+), 346 deletions(-)
 create mode 100644 arch/s390/include/asm/perf_counter.h

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a14dba0..e577839 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -94,6 +94,7 @@ config S390
 	select HAVE_KVM if 64BIT
 	select HAVE_ARCH_TRACEHOOK
 	select INIT_ALL_POSSIBLE
+	select HAVE_PERF_COUNTERS
 
 source "init/Kconfig"
 
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index d401d56..fcba206 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.30-rc3
-# Thu Apr 23 09:29:52 2009
+# Linux kernel version: 2.6.30
+# Mon Jun 22 11:08:16 2009
 #
 CONFIG_SCHED_MC=y
 CONFIG_MMU=y
@@ -25,6 +25,7 @@ CONFIG_VIRT_CPU_ACCOUNTING=y
 CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
 CONFIG_S390=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
+CONFIG_CONSTRUCTORS=y
 
 #
 # General setup
@@ -90,7 +91,6 @@ CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 # CONFIG_KALLSYMS_ALL is not set
 # CONFIG_KALLSYMS_EXTRA_PASS is not set
-# CONFIG_STRIP_ASM_SYMS is not set
 CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
@@ -103,7 +103,14 @@ CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_AIO=y
+CONFIG_HAVE_PERF_COUNTERS=y
+
+#
+# Performance Counters
+#
+# CONFIG_PERF_COUNTERS is not set
 CONFIG_VM_EVENT_COUNTERS=y
+# CONFIG_STRIP_ASM_SYMS is not set
 # CONFIG_COMPAT_BRK is not set
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -119,6 +126,11 @@ CONFIG_HAVE_KRETPROBES=y
 CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_USE_GENERIC_SMP_HELPERS=y
 CONFIG_HAVE_DEFAULT_NO_SPIN_MUTEXES=y
+
+#
+# GCOV-based kernel profiling
+#
+# CONFIG_GCOV_KERNEL is not set
 # CONFIG_SLOW_WORK is not set
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
@@ -150,7 +162,7 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
 CONFIG_PREEMPT_NOTIFIERS=y
-# CONFIG_FREEZER is not set
+CONFIG_FREEZER=y
 
 #
 # Base setup
@@ -199,6 +211,7 @@ CONFIG_ARCH_SPARSEMEM_DEFAULT=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
+CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_SELECT_MEMORY_MODEL=y
 # CONFIG_FLATMEM_MANUAL is not set
 # CONFIG_DISCONTIGMEM_MANUAL is not set
@@ -218,9 +231,9 @@ CONFIG_PHYS_ADDR_T_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
-CONFIG_UNEVICTABLE_LRU=y
 CONFIG_HAVE_MLOCK=y
 CONFIG_HAVE_MLOCKED_PAGE_BIT=y
+CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
 
 #
 # I/O subsystem configuration
@@ -257,6 +270,16 @@ CONFIG_KEXEC=y
 # CONFIG_ZFCPDUMP is not set
 CONFIG_S390_GUEST=y
 CONFIG_SECCOMP=y
+
+#
+# Power Management
+#
+CONFIG_PM=y
+# CONFIG_PM_DEBUG is not set
+CONFIG_PM_SLEEP_SMP=y
+CONFIG_PM_SLEEP=y
+CONFIG_HIBERNATION=y
+CONFIG_PM_STD_PARTITION=""
 CONFIG_NET=y
 
 #
@@ -384,6 +407,7 @@ CONFIG_SCTP_HMAC_MD5=y
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
 # CONFIG_PHONET is not set
+# CONFIG_IEEE802154 is not set
 CONFIG_NET_SCHED=y
 
 #
@@ -446,6 +470,7 @@ CONFIG_CAN_BCM=m
 # CAN Device Drivers
 #
 CONFIG_CAN_VCAN=m
+# CONFIG_CAN_DEV is not set
 # CONFIG_CAN_DEBUG_DEVICES is not set
 # CONFIG_AF_RXRPC is not set
 # CONFIG_WIMAX is not set
@@ -524,10 +549,6 @@ CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
 # CONFIG_CHR_DEV_SCH is not set
-
-#
-# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
-#
 CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
@@ -578,7 +599,6 @@ CONFIG_DM_MULTIPATH=m
 # CONFIG_DM_DELAY is not set
 # CONFIG_DM_UEVENT is not set
 CONFIG_NETDEVICES=y
-CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_IFB is not set
 CONFIG_DUMMY=m
 CONFIG_BONDING=m
@@ -595,6 +615,7 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
 # CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
 # CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
+# CONFIG_KS8842 is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
 # CONFIG_TR is not set
@@ -674,6 +695,11 @@ CONFIG_S390_TAPE_34XX=m
 # CONFIG_MONREADER is not set
 CONFIG_MONWRITER=m
 CONFIG_S390_VMUR=m
+
+#
+# PPS support
+#
+# CONFIG_PPS is not set
 # CONFIG_POWER_SUPPLY is not set
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
@@ -683,6 +709,10 @@ CONFIG_S390_VMUR=m
 # CONFIG_NEW_LEDS is not set
 CONFIG_ACCESSIBILITY=y
 # CONFIG_AUXDISPLAY is not set
+
+#
+# TI VLYNQ
+#
 # CONFIG_STAGING is not set
 
 #
@@ -703,11 +733,12 @@ CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
-CONFIG_FILE_LOCKING=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
 # CONFIG_BTRFS_FS is not set
+CONFIG_FILE_LOCKING=y
+CONFIG_FSNOTIFY=y
 CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
@@ -865,19 +896,23 @@ CONFIG_DEBUG_MEMORY_INIT=y
 CONFIG_SYSCTL_SYSCALL_CHECK=y
 # CONFIG_DEBUG_PAGEALLOC is not set
 CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
+CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
+CONFIG_HAVE_DYNAMIC_FTRACE=y
+CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
+CONFIG_HAVE_FTRACE_SYSCALLS=y
 CONFIG_TRACING_SUPPORT=y
-
-#
-# Tracers
-#
+CONFIG_FTRACE=y
 # CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_PREEMPT_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
-# CONFIG_CONTEXT_SWITCH_TRACER is not set
-# CONFIG_EVENT_TRACER is not set
+# CONFIG_ENABLE_DEFAULT_TRACERS is not set
+# CONFIG_FTRACE_SYSCALLS is not set
 # CONFIG_BOOT_TRACER is not set
-# CONFIG_TRACE_BRANCH_PROFILING is not set
+CONFIG_BRANCH_PROFILE_NONE=y
+# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
+# CONFIG_PROFILE_ALL_BRANCHES is not set
 # CONFIG_STACK_TRACER is not set
 # CONFIG_KMEMTRACE is not set
 # CONFIG_WORKQUEUE_TRACER is not set
@@ -886,6 +921,7 @@ CONFIG_TRACING_SUPPORT=y
 CONFIG_SAMPLES=y
 # CONFIG_SAMPLE_KOBJECT is not set
 # CONFIG_SAMPLE_KPROBES is not set
+# CONFIG_KMEMCHECK is not set
 
 #
 # Security options
diff --git a/arch/s390/include/asm/cputime.h b/arch/s390/include/asm/cputime.h
index ec917d4..7a3817a 100644
--- a/arch/s390/include/asm/cputime.h
+++ b/arch/s390/include/asm/cputime.h
@@ -178,7 +178,7 @@ cputime64_to_clock_t(cputime64_t cputime)
 }
 
 struct s390_idle_data {
-	spinlock_t lock;
+	unsigned int sequence;
 	unsigned long long idle_count;
 	unsigned long long idle_enter;
 	unsigned long long idle_time;
diff --git a/arch/s390/include/asm/debug.h b/arch/s390/include/asm/debug.h
index 9450ce6..31ed568 100644
--- a/arch/s390/include/asm/debug.h
+++ b/arch/s390/include/asm/debug.h
@@ -248,14 +248,5 @@ int debug_unregister_view(debug_info_t* id, struct debug_view* view);
 #define PRINT_FATAL(x...) printk ( KERN_DEBUG PRINTK_HEADER x )
 #endif				/* DASD_DEBUG */
 
-#undef DEBUG_MALLOC
-#ifdef DEBUG_MALLOC
-void *b;
-#define kmalloc(x...) (PRINT_INFO(" kmalloc %p\n",b=kmalloc(x)),b)
-#define kfree(x) PRINT_INFO(" kfree %p\n",x);kfree(x)
-#define get_zeroed_page(x...) (PRINT_INFO(" gfp %p\n",b=get_zeroed_page(x)),b)
-#define __get_free_pages(x...) (PRINT_INFO(" gfps %p\n",b=__get_free_pages(x)),b)
-#endif				/* DEBUG_MALLOC */
-
 #endif				/* __KERNEL__ */
 #endif				/* DEBUG_H */
diff --git a/arch/s390/include/asm/perf_counter.h b/arch/s390/include/asm/perf_counter.h
new file mode 100644
index 0000000..a7205a3
--- /dev/null
+++ b/arch/s390/include/asm/perf_counter.h
@@ -0,0 +1,8 @@
+/*
+ * Performance counter support - s390 specific definitions.
+ *
+ * Copyright 2009 Martin Schwidefsky, IBM Corporation.
+ */
+
+static inline void set_perf_counter_pending(void) {}
+static inline void clear_perf_counter_pending(void) {}
diff --git a/arch/s390/include/asm/qdio.h b/arch/s390/include/asm/qdio.h
index 402d6dc..79d849f 100644
--- a/arch/s390/include/asm/qdio.h
+++ b/arch/s390/include/asm/qdio.h
@@ -380,7 +380,7 @@ extern int qdio_establish(struct qdio_initialize *);
 extern int qdio_activate(struct ccw_device *);
 
 extern int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
-		   int q_nr, int bufnr, int count);
+		   int q_nr, unsigned int bufnr, unsigned int count);
 extern int qdio_cleanup(struct ccw_device*, int);
 extern int qdio_shutdown(struct ccw_device*, int);
 extern int qdio_free(struct ccw_device *);
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 9bb2f62..86783ef 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -154,39 +154,35 @@ void __kprobes get_instruction_type(struct arch_specific_insn *ainsn)
 
 static int __kprobes swap_instruction(void *aref)
 {
+	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
+	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args *args = aref;
+	int rc;
 
-	return probe_kernel_write(args->ptr, &args->new, sizeof(args->new));
+	kcb->kprobe_status = KPROBE_SWAP_INST;
+	rc = probe_kernel_write(args->ptr, &args->new, sizeof(args->new));
+	kcb->kprobe_status = status;
+	return rc;
 }
 
 void __kprobes arch_arm_kprobe(struct kprobe *p)
 {
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args args;
 
 	args.ptr = p->addr;
 	args.old = p->opcode;
 	args.new = BREAKPOINT_INSTRUCTION;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
 	stop_machine(swap_instruction, &args, NULL);
-	kcb->kprobe_status = status;
 }
 
 void __kprobes arch_disarm_kprobe(struct kprobe *p)
 {
-	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
-	unsigned long status = kcb->kprobe_status;
 	struct ins_replace_args args;
 
 	args.ptr = p->addr;
 	args.old = BREAKPOINT_INSTRUCTION;
 	args.new = p->opcode;
-
-	kcb->kprobe_status = KPROBE_SWAP_INST;
 	stop_machine(swap_instruction, &args, NULL);
-	kcb->kprobe_status = status;
 }
 
 void __kprobes arch_remove_kprobe(struct kprobe *p)
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index fd8e311..2270730 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -856,13 +856,20 @@ static ssize_t show_idle_count(struct sys_device *dev,
 {
 	struct s390_idle_data *idle;
 	unsigned long long idle_count;
+	unsigned int sequence;
 
 	idle = &per_cpu(s390_idle, dev->id);
-	spin_lock(&idle->lock);
+repeat:
+	sequence = idle->sequence;
+	smp_rmb();
+	if (sequence & 1)
+		goto repeat;
 	idle_count = idle->idle_count;
 	if (idle->idle_enter)
 		idle_count++;
-	spin_unlock(&idle->lock);
+	smp_rmb();
+	if (idle->sequence != sequence)
+		goto repeat;
 	return sprintf(buf, "%llu\n", idle_count);
 }
 static SYSDEV_ATTR(idle_count, 0444, show_idle_count, NULL);
@@ -872,15 +879,22 @@ static ssize_t show_idle_time(struct sys_device *dev,
 {
 	struct s390_idle_data *idle;
 	unsigned long long now, idle_time, idle_enter;
+	unsigned int sequence;
 
 	idle = &per_cpu(s390_idle, dev->id);
-	spin_lock(&idle->lock);
 	now = get_clock();
+repeat:
+	sequence = idle->sequence;
+	smp_rmb();
+	if (sequence & 1)
+		goto repeat;
 	idle_time = idle->idle_time;
 	idle_enter = idle->idle_enter;
 	if (idle_enter != 0ULL && idle_enter < now)
 		idle_time += now - idle_enter;
-	spin_unlock(&idle->lock);
+	smp_rmb();
+	if (idle->sequence != sequence)
+		goto repeat;
 	return sprintf(buf, "%llu\n", idle_time >> 12);
 }
 static SYSDEV_ATTR(idle_time_us, 0444, show_idle_time, NULL);
@@ -908,11 +922,7 @@ static int __cpuinit smp_cpu_notify(struct notifier_block *self,
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		idle = &per_cpu(s390_idle, cpu);
-		spin_lock_irq(&idle->lock);
-		idle->idle_enter = 0;
-		idle->idle_time = 0;
-		idle->idle_count = 0;
-		spin_unlock_irq(&idle->lock);
+		memset(idle, 0, sizeof(struct s390_idle_data));
 		if (sysfs_create_group(&s->kobj, &cpu_online_attr_group))
 			return NOTIFY_BAD;
 		break;
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 215330a..d4c8e9c 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -36,7 +36,6 @@
 #include <linux/notifier.h>
 #include <linux/clocksource.h>
 #include <linux/clockchips.h>
-#include <linux/bootmem.h>
 #include <asm/uaccess.h>
 #include <asm/delay.h>
 #include <asm/s390_ext.h>
@@ -62,9 +61,6 @@
 
 u64 sched_clock_base_cc = -1;	/* Force to data section. */
 
-static ext_int_info_t ext_int_info_cc;
-static ext_int_info_t ext_int_etr_cc;
-
 static DEFINE_PER_CPU(struct clock_event_device, comparators);
 
 /*
@@ -255,15 +251,11 @@ void __init time_init(void)
 	stp_reset();
 
 	/* request the clock comparator external interrupt */
-	if (register_early_external_interrupt(0x1004,
-					      clock_comparator_interrupt,
-					      &ext_int_info_cc) != 0)
+	if (register_external_interrupt(0x1004, clock_comparator_interrupt))
                 panic("Couldn't request external interrupt 0x1004");
 
 	/* request the timing alert external interrupt */
-	if (register_early_external_interrupt(0x1406,
-					      timing_alert_interrupt,
-					      &ext_int_etr_cc) != 0)
+	if (register_external_interrupt(0x1406, timing_alert_interrupt))
 		panic("Couldn't request external interrupt 0x1406");
 
 	if (clocksource_register(&clocksource_tod) != 0)
@@ -1445,14 +1437,14 @@ static void __init stp_reset(void)
 {
 	int rc;
 
-	stp_page = alloc_bootmem_pages(PAGE_SIZE);
+	stp_page = (void *) get_zeroed_page(GFP_ATOMIC);
 	rc = chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000);
 	if (rc == 0)
 		set_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags);
 	else if (stp_online) {
 		pr_warning("The real or virtual hardware system does "
 			   "not provide an STP interface\n");
-		free_bootmem((unsigned long) stp_page, PAGE_SIZE);
+		free_page((unsigned long) stp_page);
 		stp_page = NULL;
 		stp_online = 0;
 	}
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index c8eb725..c41bb0d 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -25,13 +25,9 @@
 #include <asm/irq_regs.h>
 #include <asm/cputime.h>
 
-static ext_int_info_t ext_int_info_timer;
-
 static DEFINE_PER_CPU(struct vtimer_queue, virt_cpu_timer);
 
-DEFINE_PER_CPU(struct s390_idle_data, s390_idle) = {
-	.lock = __SPIN_LOCK_UNLOCKED(s390_idle.lock)
-};
+DEFINE_PER_CPU(struct s390_idle_data, s390_idle);
 
 static inline __u64 get_vtimer(void)
 {
@@ -153,11 +149,13 @@ void vtime_start_cpu(void)
 		vq->elapsed -= vq->idle - S390_lowcore.async_enter_timer;
 	}
 
-	spin_lock(&idle->lock);
+	idle->sequence++;
+	smp_wmb();
 	idle->idle_time += idle_time;
 	idle->idle_enter = 0ULL;
 	idle->idle_count++;
-	spin_unlock(&idle->lock);
+	smp_wmb();
+	idle->sequence++;
 }
 
 void vtime_stop_cpu(void)
@@ -244,15 +242,23 @@ cputime64_t s390_get_idle_time(int cpu)
 {
 	struct s390_idle_data *idle;
 	unsigned long long now, idle_time, idle_enter;
+	unsigned int sequence;
 
 	idle = &per_cpu(s390_idle, cpu);
-	spin_lock(&idle->lock);
+
 	now = get_clock();
+repeat:
+	sequence = idle->sequence;
+	smp_rmb();
+	if (sequence & 1)
+		goto repeat;
 	idle_time = 0;
 	idle_enter = idle->idle_enter;
 	if (idle_enter != 0ULL && idle_enter < now)
 		idle_time = now - idle_enter;
-	spin_unlock(&idle->lock);
+	smp_rmb();
+	if (idle->sequence != sequence)
+		goto repeat;
 	return idle_time;
 }
 
@@ -557,8 +563,7 @@ void init_cpu_vtimer(void)
 void __init vtime_init(void)
 {
 	/* request the cpu timer external interrupt */
-	if (register_early_external_interrupt(0x1005, do_cpu_timer_interrupt,
-					      &ext_int_info_timer) != 0)
+	if (register_external_interrupt(0x1005, do_cpu_timer_interrupt))
 		panic("Couldn't request external interrupt 0x1005");
 
 	/* Enable cpu timer interrupts on the boot cpu. */
diff --git a/arch/s390/power/swsusp_asm64.S b/arch/s390/power/swsusp_asm64.S
index 3c74e7d..76d688d 100644
--- a/arch/s390/power/swsusp_asm64.S
+++ b/arch/s390/power/swsusp_asm64.S
@@ -109,10 +109,11 @@ swsusp_arch_resume:
 	aghi	%r15,-STACK_FRAME_OVERHEAD
 	stg	%r1,__SF_BACKCHAIN(%r15)
 
+#ifdef CONFIG_SMP
 	/* Save boot cpu number */
 	brasl	%r14,smp_get_phys_cpu_id
 	lgr	%r10,%r2
-
+#endif
 	/* Deactivate DAT */
 	stnsm	__SF_EMPTY(%r15),0xfb
 
@@ -177,11 +178,12 @@ swsusp_arch_resume:
 	/* Pointer to save arae */
 	lghi	%r13,0x1000
 
+#ifdef CONFIG_SMP
 	/* Switch CPUs */
 	lgr	%r2,%r10		/* get cpu id */
 	llgf	%r3,0x318(%r13)
 	brasl	%r14,smp_switch_boot_cpu_in_resume
-
+#endif
 	/* Restore prefix register */
 	spx	0x318(%r13)
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index e5b84db..7498366 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -470,7 +470,7 @@ static int dasd_decrease_state(struct dasd_device *device)
  */
 static void dasd_change_state(struct dasd_device *device)
 {
-        int rc;
+	int rc;
 
 	if (device->state == device->target)
 		/* Already where we want to go today... */
@@ -479,8 +479,10 @@ static void dasd_change_state(struct dasd_device *device)
 		rc = dasd_increase_state(device);
 	else
 		rc = dasd_decrease_state(device);
-        if (rc && rc != -EAGAIN)
-                device->target = device->state;
+	if (rc == -EAGAIN)
+		return;
+	if (rc)
+		device->target = device->state;
 
 	if (device->state == device->target) {
 		wake_up(&dasd_init_waitq);
@@ -2503,15 +2505,25 @@ int dasd_generic_restore_device(struct ccw_device *cdev)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	/* allow new IO again */
+	device->stopped &= ~DASD_STOPPED_PM;
+	device->stopped &= ~DASD_UNRESUMED_PM;
+
 	dasd_schedule_device_bh(device);
 	if (device->block)
 		dasd_schedule_block_bh(device->block);
 
 	if (device->discipline->restore)
 		rc = device->discipline->restore(device);
+	if (rc)
+		/*
+		 * if the resume failed for the DASD we put it in
+		 * an UNRESUMED stop state
+		 */
+		device->stopped |= DASD_UNRESUMED_PM;
 
 	dasd_put_device(device);
-	return rc;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dasd_generic_restore_device);
 
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 1c28ec3..f8b1f04 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -3243,9 +3243,6 @@ int dasd_eckd_restore_device(struct dasd_device *device)
 	int is_known, rc;
 	struct dasd_uid temp_uid;
 
-	/* allow new IO again */
-	device->stopped &= ~DASD_STOPPED_PM;
-
 	private = (struct dasd_eckd_private *) device->private;
 
 	/* Read Configuration Data */
@@ -3295,12 +3292,7 @@ int dasd_eckd_restore_device(struct dasd_device *device)
 	return 0;
 
 out_err:
-	/*
-	 * if the resume failed for the DASD we put it in
-	 * an UNRESUMED stop state
-	 */
-	device->stopped |= DASD_UNRESUMED_PM;
-	return 0;
+	return -1;
 }
 
 static struct ccw_driver dasd_eckd_driver = {
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 04dc734..21639d6 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -20,10 +20,7 @@
 #include <linux/interrupt.h>
 #include <linux/err.h>
 #include <linux/reboot.h>
-
 #include <linux/slab.h>
-#include <linux/bootmem.h>
-
 #include <asm/ccwdev.h>
 #include <asm/cio.h>
 #include <asm/io.h>
@@ -735,7 +732,7 @@ static int raw3215_pm_stop(struct ccw_device *cdev)
 	unsigned long flags;
 
 	/* Empty the output buffer, then prevent new I/O. */
-	raw = cdev->dev.driver_data;
+	raw = dev_get_drvdata(&cdev->dev);
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 	raw3215_make_room(raw, RAW3215_BUFFER_SIZE);
 	raw->flags |= RAW3215_FROZEN;
@@ -749,7 +746,7 @@ static int raw3215_pm_start(struct ccw_device *cdev)
 	unsigned long flags;
 
 	/* Allow I/O again and flush output buffer. */
-	raw = cdev->dev.driver_data;
+	raw = dev_get_drvdata(&cdev->dev);
 	spin_lock_irqsave(get_ccwdev_lock(raw->cdev), flags);
 	raw->flags &= ~RAW3215_FROZEN;
 	raw->flags |= RAW3215_FLUSHING;
@@ -883,7 +880,7 @@ static int __init con3215_init(void)
 	raw3215_freelist = NULL;
 	spin_lock_init(&raw3215_freelist_lock);
 	for (i = 0; i < NR_3215_REQ; i++) {
-		req = (struct raw3215_req *) alloc_bootmem_low(sizeof(struct raw3215_req));
+		req = kzalloc(sizeof(struct raw3215_req), GFP_KERNEL | GFP_DMA);
 		req->next = raw3215_freelist;
 		raw3215_freelist = req;
 	}
@@ -893,10 +890,9 @@ static int __init con3215_init(void)
 		return -ENODEV;
 
 	raw3215[0] = raw = (struct raw3215_info *)
-		alloc_bootmem_low(sizeof(struct raw3215_info));
-	memset(raw, 0, sizeof(struct raw3215_info));
-	raw->buffer = (char *) alloc_bootmem_low(RAW3215_BUFFER_SIZE);
-	raw->inbuf = (char *) alloc_bootmem_low(RAW3215_INBUF_SIZE);
+		kzalloc(sizeof(struct raw3215_info), GFP_KERNEL | GFP_DMA);
+	raw->buffer = kzalloc(RAW3215_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
+	raw->inbuf = kzalloc(RAW3215_INBUF_SIZE, GFP_KERNEL | GFP_DMA);
 	raw->cdev = cdev;
 	dev_set_drvdata(&cdev->dev, raw);
 	cdev->handler = raw3215_irq;
@@ -906,9 +902,9 @@ static int __init con3215_init(void)
 
 	/* Request the console irq */
 	if (raw3215_startup(raw) != 0) {
-		free_bootmem((unsigned long) raw->inbuf, RAW3215_INBUF_SIZE);
-		free_bootmem((unsigned long) raw->buffer, RAW3215_BUFFER_SIZE);
-		free_bootmem((unsigned long) raw, sizeof(struct raw3215_info));
+		kfree(raw->inbuf);
+		kfree(raw->buffer);
+		kfree(raw);
 		raw3215[0] = NULL;
 		return -ENODEV;
 	}
diff --git a/drivers/s390/char/con3270.c b/drivers/s390/char/con3270.c
index 44d02e3..bb838bd 100644
--- a/drivers/s390/char/con3270.c
+++ b/drivers/s390/char/con3270.c
@@ -7,7 +7,6 @@
  *     Copyright IBM Corp. 2003, 2009
  */
 
-#include <linux/bootmem.h>
 #include <linux/console.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
@@ -600,16 +599,14 @@ con3270_init(void)
 	if (IS_ERR(rp))
 		return PTR_ERR(rp);
 
-	condev = (struct con3270 *) alloc_bootmem_low(sizeof(struct con3270));
-	memset(condev, 0, sizeof(struct con3270));
+	condev = kzalloc(sizeof(struct con3270), GFP_KERNEL | GFP_DMA);
 	condev->view.dev = rp;
 
-	condev->read = raw3270_request_alloc_bootmem(0);
+	condev->read = raw3270_request_alloc(0);
 	condev->read->callback = con3270_read_callback;
 	condev->read->callback_data = condev;
-	condev->write = 
-		raw3270_request_alloc_bootmem(CON3270_OUTPUT_BUFFER_SIZE);
-	condev->kreset = raw3270_request_alloc_bootmem(1);
+	condev->write = raw3270_request_alloc(CON3270_OUTPUT_BUFFER_SIZE);
+	condev->kreset = raw3270_request_alloc(1);
 
 	INIT_LIST_HEAD(&condev->lines);
 	INIT_LIST_HEAD(&condev->update);
@@ -623,7 +620,7 @@ con3270_init(void)
 
 	INIT_LIST_HEAD(&condev->freemem);
 	for (i = 0; i < CON3270_STRING_PAGES; i++) {
-		cbuf = (void *) alloc_bootmem_low_pages(PAGE_SIZE);
+		cbuf = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
 		add_string_memory(&condev->freemem, cbuf, PAGE_SIZE);
 	}
 	condev->cline = alloc_string(&condev->freemem, condev->view.cols);
diff --git a/drivers/s390/char/monreader.c b/drivers/s390/char/monreader.c
index 75a8831..7892550 100644
--- a/drivers/s390/char/monreader.c
+++ b/drivers/s390/char/monreader.c
@@ -320,7 +320,7 @@ static int mon_open(struct inode *inode, struct file *filp)
 		goto out_path;
 	}
 	filp->private_data = monpriv;
-	monreader_device->driver_data = monpriv;
+	dev_set_drvdata(&monreader_device, monpriv);
 	unlock_kernel();
 	return nonseekable_open(inode, filp);
 
@@ -463,7 +463,7 @@ static struct miscdevice mon_dev = {
  *****************************************************************************/
 static int monreader_freeze(struct device *dev)
 {
-	struct mon_private *monpriv = dev->driver_data;
+	struct mon_private *monpriv = dev_get_drvdata(&dev);
 	int rc;
 
 	if (!monpriv)
@@ -487,7 +487,7 @@ static int monreader_freeze(struct device *dev)
 
 static int monreader_thaw(struct device *dev)
 {
-	struct mon_private *monpriv = dev->driver_data;
+	struct mon_private *monpriv = dev_get_drvdata(dev);
 	int rc;
 
 	if (!monpriv)
diff --git a/drivers/s390/char/raw3270.c b/drivers/s390/char/raw3270.c
index acab7b2..d6a022f 100644
--- a/drivers/s390/char/raw3270.c
+++ b/drivers/s390/char/raw3270.c
@@ -7,7 +7,6 @@
  *     Copyright IBM Corp. 2003, 2009
  */
 
-#include <linux/bootmem.h>
 #include <linux/module.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -143,33 +142,6 @@ raw3270_request_alloc(size_t size)
 	return rq;
 }
 
-#ifdef CONFIG_TN3270_CONSOLE
-/*
- * Allocate a new 3270 ccw request from bootmem. Only works very
- * early in the boot process. Only con3270.c should be using this.
- */
-struct raw3270_request __init *raw3270_request_alloc_bootmem(size_t size)
-{
-	struct raw3270_request *rq;
-
-	rq = alloc_bootmem_low(sizeof(struct raw3270));
-
-	/* alloc output buffer. */
-	if (size > 0)
-		rq->buffer = alloc_bootmem_low(size);
-	rq->size = size;
-	INIT_LIST_HEAD(&rq->list);
-
-	/*
-	 * Setup ccw.
-	 */
-	rq->ccw.cda = __pa(rq->buffer);
-	rq->ccw.flags = CCW_FLAG_SLI;
-
-	return rq;
-}
-#endif
-
 /*
  * Free 3270 ccw request
  */
@@ -846,8 +818,8 @@ struct raw3270 __init *raw3270_setup_console(struct ccw_device *cdev)
 	char *ascebc;
 	int rc;
 
-	rp = (struct raw3270 *) alloc_bootmem_low(sizeof(struct raw3270));
-	ascebc = (char *) alloc_bootmem(256);
+	rp = kzalloc(sizeof(struct raw3270), GFP_KERNEL | GFP_DMA);
+	ascebc = kzalloc(256, GFP_KERNEL);
 	rc = raw3270_setup_device(cdev, rp, ascebc);
 	if (rc)
 		return ERR_PTR(rc);
@@ -1350,7 +1322,7 @@ static int raw3270_pm_stop(struct ccw_device *cdev)
 	struct raw3270_view *view;
 	unsigned long flags;
 
-	rp = cdev->dev.driver_data;
+	rp = dev_get_drvdata(&cdev->dev);
 	if (!rp)
 		return 0;
 	spin_lock_irqsave(get_ccwdev_lock(rp->cdev), flags);
@@ -1376,7 +1348,7 @@ static int raw3270_pm_start(struct ccw_device *cdev)
 	struct raw3270 *rp;
 	unsigned long flags;
 
-	rp = cdev->dev.driver_data;
+	rp = dev_get_drvdata(&cdev->dev);
 	if (!rp)
 		return 0;
 	spin_lock_irqsave(get_ccwdev_lock(rp->cdev), flags);
diff --git a/drivers/s390/char/sclp_con.c b/drivers/s390/char/sclp_con.c
index 336811a..ad698d3 100644
--- a/drivers/s390/char/sclp_con.c
+++ b/drivers/s390/char/sclp_con.c
@@ -11,7 +11,6 @@
 #include <linux/init.h>
 #include <linux/timer.h>
 #include <linux/jiffies.h>
-#include <linux/bootmem.h>
 #include <linux/termios.h>
 #include <linux/err.h>
 #include <linux/reboot.h>
@@ -110,7 +109,7 @@ static void sclp_console_sync_queue(void)
 
 	spin_lock_irqsave(&sclp_con_lock, flags);
 	if (timer_pending(&sclp_con_timer))
-		del_timer_sync(&sclp_con_timer);
+		del_timer(&sclp_con_timer);
 	while (sclp_con_queue_running) {
 		spin_unlock_irqrestore(&sclp_con_lock, flags);
 		sclp_sync_wait();
@@ -298,8 +297,8 @@ sclp_console_init(void)
 	/* Allocate pages for output buffering */
 	INIT_LIST_HEAD(&sclp_con_pages);
 	for (i = 0; i < MAX_CONSOLE_PAGES; i++) {
-		page = alloc_bootmem_low_pages(PAGE_SIZE);
-		list_add_tail((struct list_head *) page, &sclp_con_pages);
+		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		list_add_tail(page, &sclp_con_pages);
 	}
 	INIT_LIST_HEAD(&sclp_con_outqueue);
 	spin_lock_init(&sclp_con_lock);
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 5518e24..178724f 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -20,7 +20,6 @@
 #include <linux/major.h>
 #include <linux/console.h>
 #include <linux/kdev_t.h>
-#include <linux/bootmem.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
 #include <linux/reboot.h>
@@ -601,10 +600,7 @@ static void __init __sclp_vt220_free_pages(void)
 
 	list_for_each_safe(page, p, &sclp_vt220_empty) {
 		list_del(page);
-		if (slab_is_available())
-			free_page((unsigned long) page);
-		else
-			free_bootmem((unsigned long) page, PAGE_SIZE);
+		free_page((unsigned long) page);
 	}
 }
 
@@ -640,16 +636,12 @@ static int __init __sclp_vt220_init(int num_pages)
 	sclp_vt220_flush_later = 0;
 
 	/* Allocate pages for output buffering */
+	rc = -ENOMEM;
 	for (i = 0; i < num_pages; i++) {
-		if (slab_is_available())
-			page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
-		else
-			page = alloc_bootmem_low_pages(PAGE_SIZE);
-		if (!page) {
-			rc = -ENOMEM;
+		page = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+		if (!page)
 			goto out;
-		}
-		list_add_tail((struct list_head *) page, &sclp_vt220_empty);
+		list_add_tail(page, &sclp_vt220_empty);
 	}
 	rc = sclp_register(&sclp_vt220_register);
 out:
diff --git a/drivers/s390/char/tape_core.c b/drivers/s390/char/tape_core.c
index 595aa04..1d420d9 100644
--- a/drivers/s390/char/tape_core.c
+++ b/drivers/s390/char/tape_core.c
@@ -396,7 +396,7 @@ int tape_generic_pm_suspend(struct ccw_device *cdev)
 {
 	struct tape_device *device;
 
-	device = cdev->dev.driver_data;
+	device = dev_get_drvdata(&cdev->dev);
 	if (!device) {
 		return -ENODEV;
 	}
diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index 411cfa3..c20a4fe 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -663,7 +663,7 @@ static struct attribute *vmlogrdr_attrs[] = {
 static int vmlogrdr_pm_prepare(struct device *dev)
 {
 	int rc;
-	struct vmlogrdr_priv_t *priv = dev->driver_data;
+	struct vmlogrdr_priv_t *priv = dev_get_drvdata(dev);
 
 	rc = 0;
 	if (priv) {
@@ -753,7 +753,7 @@ static int vmlogrdr_register_device(struct vmlogrdr_priv_t *priv)
 		dev->bus = &iucv_bus;
 		dev->parent = iucv_root;
 		dev->driver = &vmlogrdr_driver;
-		dev->driver_data = priv;
+		dev_set_drvdata(dev, priv);
 		/*
 		 * The release function could be called after the
 		 * module has been unloaded. It's _only_ task is to
diff --git a/drivers/s390/char/vmur.c b/drivers/s390/char/vmur.c
index 7d9e67c..31b902e 100644
--- a/drivers/s390/char/vmur.c
+++ b/drivers/s390/char/vmur.c
@@ -170,7 +170,7 @@ static void urdev_put(struct urdev *urd)
  */
 static int ur_pm_suspend(struct ccw_device *cdev)
 {
-	struct urdev *urd = cdev->dev.driver_data;
+	struct urdev *urd = dev_get_drvdata(&cdev->dev);
 
 	TRACE("ur_pm_suspend: cdev=%p\n", cdev);
 	if (urd->open_flag) {
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 13bcb81..b1241f8 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -351,15 +351,6 @@ static inline unsigned long long get_usecs(void)
 	((bufnr - dec) & QDIO_MAX_BUFFERS_MASK)
 
 /* prototypes for thin interrupt */
-void qdio_sync_after_thinint(struct qdio_q *q);
-int get_buf_state(struct qdio_q *q, unsigned int bufnr, unsigned char *state,
-		  int auto_ack);
-void qdio_check_outbound_after_thinint(struct qdio_q *q);
-int qdio_inbound_q_moved(struct qdio_q *q);
-void qdio_kick_handler(struct qdio_q *q);
-void qdio_stop_polling(struct qdio_q *q);
-int qdio_siga_sync_q(struct qdio_q *q);
-
 void qdio_setup_thinint(struct qdio_irq *irq_ptr);
 int qdio_establish_thinint(struct qdio_irq *irq_ptr);
 void qdio_shutdown_thinint(struct qdio_irq *irq_ptr);
@@ -392,4 +383,6 @@ void qdio_setup_destroy_sysfs(struct ccw_device *cdev);
 int qdio_setup_init(void);
 void qdio_setup_exit(void);
 
+int debug_get_buf_state(struct qdio_q *q, unsigned int bufnr,
+			unsigned char *state);
 #endif /* _CIO_QDIO_H */
diff --git a/drivers/s390/cio/qdio_debug.c b/drivers/s390/cio/qdio_debug.c
index e3434b3..b8626d4 100644
--- a/drivers/s390/cio/qdio_debug.c
+++ b/drivers/s390/cio/qdio_debug.c
@@ -70,9 +70,8 @@ static int qstat_show(struct seq_file *m, void *v)
 	seq_printf(m, "slsb buffer states:\n");
 	seq_printf(m, "|0      |8      |16     |24     |32     |40     |48     |56  63|\n");
 
-	qdio_siga_sync_q(q);
 	for (i = 0; i < QDIO_MAX_BUFFERS_PER_Q; i++) {
-		get_buf_state(q, i, &state, 0);
+		debug_get_buf_state(q, i, &state);
 		switch (state) {
 		case SLSB_P_INPUT_NOT_INIT:
 		case SLSB_P_OUTPUT_NOT_INIT:
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index d79cf5b..0038750 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -231,8 +231,8 @@ static inline int get_buf_states(struct qdio_q *q, unsigned int bufnr,
 	return i;
 }
 
-inline int get_buf_state(struct qdio_q *q, unsigned int bufnr,
-		  unsigned char *state, int auto_ack)
+static inline int get_buf_state(struct qdio_q *q, unsigned int bufnr,
+				unsigned char *state, int auto_ack)
 {
 	return get_buf_states(q, bufnr, state, 1, auto_ack);
 }
@@ -276,7 +276,7 @@ void qdio_init_buf_states(struct qdio_irq *irq_ptr)
 			       QDIO_MAX_BUFFERS_PER_Q);
 }
 
-static int qdio_siga_sync(struct qdio_q *q, unsigned int output,
+static inline int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 			  unsigned int input)
 {
 	int cc;
@@ -293,7 +293,7 @@ static int qdio_siga_sync(struct qdio_q *q, unsigned int output,
 	return cc;
 }
 
-inline int qdio_siga_sync_q(struct qdio_q *q)
+static inline int qdio_siga_sync_q(struct qdio_q *q)
 {
 	if (q->is_input_q)
 		return qdio_siga_sync(q, 0, q->mask);
@@ -358,8 +358,7 @@ static inline int qdio_siga_input(struct qdio_q *q)
 	return cc;
 }
 
-/* called from thinint inbound handler */
-void qdio_sync_after_thinint(struct qdio_q *q)
+static inline void qdio_sync_after_thinint(struct qdio_q *q)
 {
 	if (pci_out_supported(q)) {
 		if (need_siga_sync_thinint(q))
@@ -370,7 +369,14 @@ void qdio_sync_after_thinint(struct qdio_q *q)
 		qdio_siga_sync_q(q);
 }
 
-inline void qdio_stop_polling(struct qdio_q *q)
+int debug_get_buf_state(struct qdio_q *q, unsigned int bufnr,
+			unsigned char *state)
+{
+	qdio_siga_sync_q(q);
+	return get_buf_states(q, bufnr, state, 1, 0);
+}
+
+static inline void qdio_stop_polling(struct qdio_q *q)
 {
 	if (!q->u.in.polling)
 		return;
@@ -449,13 +455,6 @@ static inline void inbound_primed(struct qdio_q *q, int count)
 	count--;
 	if (!count)
 		return;
-
-	/*
-	 * Need to change all PRIMED buffers to NOT_INIT, otherwise
-	 * we're loosing initiative in the thinint code.
-	 */
-	set_buf_states(q, q->first_to_check, SLSB_P_INPUT_NOT_INIT,
-		       count);
 }
 
 static int get_inbound_buffer_frontier(struct qdio_q *q)
@@ -470,19 +469,13 @@ static int get_inbound_buffer_frontier(struct qdio_q *q)
 	count = min(atomic_read(&q->nr_buf_used), QDIO_MAX_BUFFERS_MASK);
 	stop = add_buf(q->first_to_check, count);
 
-	/*
-	 * No siga sync here, as a PCI or we after a thin interrupt
-	 * will sync the queues.
-	 */
-
-	/* need to set count to 1 for non-qebsm */
-	if (!is_qebsm(q))
-		count = 1;
-
-check_next:
 	if (q->first_to_check == stop)
 		goto out;
 
+	/*
+	 * No siga sync here, as a PCI or we after a thin interrupt
+	 * already sync'ed the queues.
+	 */
 	count = get_buf_states(q, q->first_to_check, &state, count, 1);
 	if (!count)
 		goto out;
@@ -490,14 +483,9 @@ check_next:
 	switch (state) {
 	case SLSB_P_INPUT_PRIMED:
 		inbound_primed(q, count);
-		/*
-		 * No siga-sync needed for non-qebsm here, as the inbound queue
-		 * will be synced on the next siga-r, resp.
-		 * tiqdio_is_inbound_q_done will do the siga-sync.
-		 */
 		q->first_to_check = add_buf(q->first_to_check, count);
 		atomic_sub(count, &q->nr_buf_used);
-		goto check_next;
+		break;
 	case SLSB_P_INPUT_ERROR:
 		announce_buffer_error(q, count);
 		/* process the buffer, the upper layer will take care of it */
@@ -516,7 +504,7 @@ out:
 	return q->first_to_check;
 }
 
-int qdio_inbound_q_moved(struct qdio_q *q)
+static int qdio_inbound_q_moved(struct qdio_q *q)
 {
 	int bufnr;
 
@@ -524,35 +512,32 @@ int qdio_inbound_q_moved(struct qdio_q *q)
 
 	if ((bufnr != q->last_move) || q->qdio_error) {
 		q->last_move = bufnr;
-		if (!need_siga_sync(q) && !pci_out_supported(q))
+		if (!is_thinint_irq(q->irq_ptr) && !MACHINE_IS_VM)
 			q->u.in.timestamp = get_usecs();
-
-		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in moved");
 		return 1;
 	} else
 		return 0;
 }
 
-static int qdio_inbound_q_done(struct qdio_q *q)
+static inline int qdio_inbound_q_done(struct qdio_q *q)
 {
 	unsigned char state = 0;
 
 	if (!atomic_read(&q->nr_buf_used))
 		return 1;
 
-	/*
-	 * We need that one for synchronization with the adapter, as it
-	 * does a kind of PCI avoidance.
-	 */
 	qdio_siga_sync_q(q);
-
 	get_buf_state(q, q->first_to_check, &state, 0);
+
 	if (state == SLSB_P_INPUT_PRIMED)
-		/* we got something to do */
+		/* more work coming */
 		return 0;
 
-	/* on VM, we don't poll, so the q is always done here */
-	if (need_siga_sync(q) || pci_out_supported(q))
+	if (is_thinint_irq(q->irq_ptr))
+		return 1;
+
+	/* don't poll under z/VM */
+	if (MACHINE_IS_VM)
 		return 1;
 
 	/*
@@ -563,14 +548,11 @@ static int qdio_inbound_q_done(struct qdio_q *q)
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in done:%3d",
 			      q->first_to_check);
 		return 1;
-	} else {
-		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr, "in notd:%3d",
-			      q->first_to_check);
+	} else
 		return 0;
-	}
 }
 
-void qdio_kick_handler(struct qdio_q *q)
+static void qdio_kick_handler(struct qdio_q *q)
 {
 	int start = q->first_to_kick;
 	int end = q->first_to_check;
@@ -619,7 +601,6 @@ again:
 		goto again;
 }
 
-/* inbound tasklet */
 void qdio_inbound_processing(unsigned long data)
 {
 	struct qdio_q *q = (struct qdio_q *)data;
@@ -642,11 +623,6 @@ static int get_outbound_buffer_frontier(struct qdio_q *q)
 	count = min(atomic_read(&q->nr_buf_used), QDIO_MAX_BUFFERS_MASK);
 	stop = add_buf(q->first_to_check, count);
 
-	/* need to set count to 1 for non-qebsm */
-	if (!is_qebsm(q))
-		count = 1;
-
-check_next:
 	if (q->first_to_check == stop)
 		return q->first_to_check;
 
@@ -661,13 +637,7 @@ check_next:
 
 		atomic_sub(count, &q->nr_buf_used);
 		q->first_to_check = add_buf(q->first_to_check, count);
-		/*
-		 * We fetch all buffer states at once. get_buf_states may
-		 * return count < stop. For QEBSM we do not loop.
-		 */
-		if (is_qebsm(q))
-			break;
-		goto check_next;
+		break;
 	case SLSB_P_OUTPUT_ERROR:
 		announce_buffer_error(q, count);
 		/* process the buffer, the upper layer will take care of it */
@@ -797,8 +767,7 @@ void qdio_outbound_timer(unsigned long data)
 	tasklet_schedule(&q->tasklet);
 }
 
-/* called from thinint inbound tasklet */
-void qdio_check_outbound_after_thinint(struct qdio_q *q)
+static inline void qdio_check_outbound_after_thinint(struct qdio_q *q)
 {
 	struct qdio_q *out;
 	int i;
@@ -811,6 +780,46 @@ void qdio_check_outbound_after_thinint(struct qdio_q *q)
 			tasklet_schedule(&out->tasklet);
 }
 
+static void __tiqdio_inbound_processing(struct qdio_q *q)
+{
+	qdio_perf_stat_inc(&perf_stats.thinint_inbound);
+	qdio_sync_after_thinint(q);
+
+	/*
+	 * The interrupt could be caused by a PCI request. Check the
+	 * PCI capable outbound queues.
+	 */
+	qdio_check_outbound_after_thinint(q);
+
+	if (!qdio_inbound_q_moved(q))
+		return;
+
+	qdio_kick_handler(q);
+
+	if (!qdio_inbound_q_done(q)) {
+		qdio_perf_stat_inc(&perf_stats.thinint_inbound_loop);
+		if (likely(q->irq_ptr->state != QDIO_IRQ_STATE_STOPPED))
+			tasklet_schedule(&q->tasklet);
+	}
+
+	qdio_stop_polling(q);
+	/*
+	 * We need to check again to not lose initiative after
+	 * resetting the ACK state.
+	 */
+	if (!qdio_inbound_q_done(q)) {
+		qdio_perf_stat_inc(&perf_stats.thinint_inbound_loop2);
+		if (likely(q->irq_ptr->state != QDIO_IRQ_STATE_STOPPED))
+			tasklet_schedule(&q->tasklet);
+	}
+}
+
+void tiqdio_inbound_processing(unsigned long data)
+{
+	struct qdio_q *q = (struct qdio_q *)data;
+	__tiqdio_inbound_processing(q);
+}
+
 static inline void qdio_set_state(struct qdio_irq *irq_ptr,
 				  enum qdio_irq_states state)
 {
@@ -1488,18 +1497,13 @@ out:
  * @count: how many buffers to process
  */
 int do_QDIO(struct ccw_device *cdev, unsigned int callflags,
-	    int q_nr, int bufnr, int count)
+	    int q_nr, unsigned int bufnr, unsigned int count)
 {
 	struct qdio_irq *irq_ptr;
 
-	if ((bufnr > QDIO_MAX_BUFFERS_PER_Q) ||
-	    (count > QDIO_MAX_BUFFERS_PER_Q) ||
-	    (q_nr >= QDIO_MAX_QUEUES_PER_IRQ))
+	if (bufnr >= QDIO_MAX_BUFFERS_PER_Q || count > QDIO_MAX_BUFFERS_PER_Q)
 		return -EINVAL;
 
-	if (!count)
-		return 0;
-
 	irq_ptr = cdev->private->qdio_data;
 	if (!irq_ptr)
 		return -ENODEV;
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index c655d01..981a77e 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -43,9 +43,6 @@ struct indicator_t {
 };
 static struct indicator_t *q_indicators;
 
-static void tiqdio_tasklet_fn(unsigned long data);
-static DECLARE_TASKLET(tiqdio_tasklet, tiqdio_tasklet_fn, 0);
-
 static int css_qdio_omit_svs;
 
 static inline unsigned long do_clear_global_summary(void)
@@ -103,11 +100,6 @@ void tiqdio_add_input_queues(struct qdio_irq *irq_ptr)
 	xchg(irq_ptr->dsci, 1);
 }
 
-/*
- * we cannot stop the tiqdio tasklet here since it is for all
- * thinint qdio devices and it must run as long as there is a
- * thinint device left
- */
 void tiqdio_remove_input_queues(struct qdio_irq *irq_ptr)
 {
 	struct qdio_q *q;
@@ -126,79 +118,39 @@ void tiqdio_remove_input_queues(struct qdio_irq *irq_ptr)
 	}
 }
 
-static inline int tiqdio_inbound_q_done(struct qdio_q *q)
-{
-	unsigned char state = 0;
-
-	if (!atomic_read(&q->nr_buf_used))
-		return 1;
-
-	qdio_siga_sync_q(q);
-	get_buf_state(q, q->first_to_check, &state, 0);
-
-	if (state == SLSB_P_INPUT_PRIMED)
-		/* more work coming */
-		return 0;
-	return 1;
-}
-
 static inline int shared_ind(struct qdio_irq *irq_ptr)
 {
 	return irq_ptr->dsci == &q_indicators[TIQDIO_SHARED_IND].ind;
 }
 
-static void __tiqdio_inbound_processing(struct qdio_q *q)
+/**
+ * tiqdio_thinint_handler - thin interrupt handler for qdio
+ * @ind: pointer to adapter local summary indicator
+ * @drv_data: NULL
+ */
+static void tiqdio_thinint_handler(void *ind, void *drv_data)
 {
-	qdio_perf_stat_inc(&perf_stats.thinint_inbound);
-	qdio_sync_after_thinint(q);
+	struct qdio_q *q;
+
+	qdio_perf_stat_inc(&perf_stats.thin_int);
 
 	/*
-	 * Maybe we have work on our outbound queues... at least
-	 * we have to check the PCI capable queues.
+	 * SVS only when needed: issue SVS to benefit from iqdio interrupt
+	 * avoidance (SVS clears adapter interrupt suppression overwrite)
 	 */
-	qdio_check_outbound_after_thinint(q);
-
-	if (!qdio_inbound_q_moved(q))
-		return;
-
-	qdio_kick_handler(q);
-
-	if (!tiqdio_inbound_q_done(q)) {
-		qdio_perf_stat_inc(&perf_stats.thinint_inbound_loop);
-		if (likely(q->irq_ptr->state != QDIO_IRQ_STATE_STOPPED))
-			tasklet_schedule(&q->tasklet);
-	}
+	if (!css_qdio_omit_svs)
+		do_clear_global_summary();
 
-	qdio_stop_polling(q);
 	/*
-	 * We need to check again to not lose initiative after
-	 * resetting the ACK state.
+	 * reset local summary indicator (tiqdio_alsi) to stop adapter
+	 * interrupts for now
 	 */
-	if (!tiqdio_inbound_q_done(q)) {
-		qdio_perf_stat_inc(&perf_stats.thinint_inbound_loop2);
-		if (likely(q->irq_ptr->state != QDIO_IRQ_STATE_STOPPED))
-			tasklet_schedule(&q->tasklet);
-	}
-}
-
-void tiqdio_inbound_processing(unsigned long data)
-{
-	struct qdio_q *q = (struct qdio_q *)data;
-
-	__tiqdio_inbound_processing(q);
-}
-
-/* check for work on all inbound thinint queues */
-static void tiqdio_tasklet_fn(unsigned long data)
-{
-	struct qdio_q *q;
-
-	qdio_perf_stat_inc(&perf_stats.tasklet_thinint);
-again:
+	xchg((u8 *)ind, 0);
 
 	/* protect tiq_list entries, only changed in activate or shutdown */
 	rcu_read_lock();
 
+	/* check for work on all inbound thinint queues */
 	list_for_each_entry_rcu(q, &tiq_list, entry)
 		/* only process queues from changed sets */
 		if (*q->irq_ptr->dsci) {
@@ -226,37 +178,6 @@ again:
 		if (*tiqdio_alsi)
 			xchg(&q_indicators[TIQDIO_SHARED_IND].ind, 1);
 	}
-
-	/* check for more work */
-	if (*tiqdio_alsi) {
-		xchg(tiqdio_alsi, 0);
-		qdio_perf_stat_inc(&perf_stats.tasklet_thinint_loop);
-		goto again;
-	}
-}
-
-/**
- * tiqdio_thinint_handler - thin interrupt handler for qdio
- * @ind: pointer to adapter local summary indicator
- * @drv_data: NULL
- */
-static void tiqdio_thinint_handler(void *ind, void *drv_data)
-{
-	qdio_perf_stat_inc(&perf_stats.thin_int);
-
-	/*
-	 * SVS only when needed: issue SVS to benefit from iqdio interrupt
-	 * avoidance (SVS clears adapter interrupt suppression overwrite)
-	 */
-	if (!css_qdio_omit_svs)
-		do_clear_global_summary();
-
-	/*
-	 * reset local summary indicator (tiqdio_alsi) to stop adapter
-	 * interrupts for now, the tasklet will clean all dsci's
-	 */
-	xchg((u8 *)ind, 0);
-	tasklet_hi_schedule(&tiqdio_tasklet);
 }
 
 static int set_subchannel_ind(struct qdio_irq *irq_ptr, int reset)
@@ -376,5 +297,4 @@ void __exit tiqdio_unregister_thinints(void)
 		s390_unregister_adapter_interrupt(tiqdio_alsi, QDIO_AIRQ_ISC);
 		isc_unregister(QDIO_AIRQ_ISC);
 	}
-	tasklet_kill(&tiqdio_tasklet);
 }
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 9c14840..727a809 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -54,6 +54,12 @@ static int ap_poll_thread_start(void);
 static void ap_poll_thread_stop(void);
 static void ap_request_timeout(unsigned long);
 static inline void ap_schedule_poll_timer(void);
+static int __ap_poll_device(struct ap_device *ap_dev, unsigned long *flags);
+static int ap_device_remove(struct device *dev);
+static int ap_device_probe(struct device *dev);
+static void ap_interrupt_handler(void *unused1, void *unused2);
+static void ap_reset(struct ap_device *ap_dev);
+static void ap_config_timeout(unsigned long ptr);
 
 /*
  * Module description.
@@ -101,6 +107,10 @@ static struct hrtimer ap_poll_timer;
  * If z/VM change to 1500000 nanoseconds to adjust to z/VM polling.*/
 static unsigned long long poll_timeout = 250000;
 
+/* Suspend flag */
+static int ap_suspend_flag;
+static struct bus_type ap_bus_type;
+
 /**
  * ap_using_interrupts() - Returns non-zero if interrupt support is
  * available.
@@ -617,10 +627,79 @@ static int ap_uevent (struct device *dev, struct kobj_uevent_env *env)
 	return retval;
 }
 
+static int ap_bus_suspend(struct device *dev, pm_message_t state)
+{
+	struct ap_device *ap_dev = to_ap_dev(dev);
+	unsigned long flags;
+
+	if (!ap_suspend_flag) {
+		ap_suspend_flag = 1;
+
+		/* Disable scanning for devices, thus we do not want to scan
+		 * for them after removing.
+		 */
+		del_timer_sync(&ap_config_timer);
+		if (ap_work_queue != NULL) {
+			destroy_workqueue(ap_work_queue);
+			ap_work_queue = NULL;
+		}
+		tasklet_disable(&ap_tasklet);
+	}
+	/* Poll on the device until all requests are finished. */
+	do {
+		flags = 0;
+		__ap_poll_device(ap_dev, &flags);
+	} while ((flags & 1) || (flags & 2));
+
+	ap_device_remove(dev);
+	return 0;
+}
+
+static int ap_bus_resume(struct device *dev)
+{
+	int rc = 0;
+	struct ap_device *ap_dev = to_ap_dev(dev);
+
+	if (ap_suspend_flag) {
+		ap_suspend_flag = 0;
+		if (!ap_interrupts_available())
+			ap_interrupt_indicator = NULL;
+		ap_device_probe(dev);
+		ap_reset(ap_dev);
+		setup_timer(&ap_dev->timeout, ap_request_timeout,
+			    (unsigned long) ap_dev);
+		ap_scan_bus(NULL);
+		init_timer(&ap_config_timer);
+		ap_config_timer.function = ap_config_timeout;
+		ap_config_timer.data = 0;
+		ap_config_timer.expires = jiffies + ap_config_time * HZ;
+		add_timer(&ap_config_timer);
+		ap_work_queue = create_singlethread_workqueue("kapwork");
+		if (!ap_work_queue)
+			return -ENOMEM;
+		tasklet_enable(&ap_tasklet);
+		if (!ap_using_interrupts())
+			ap_schedule_poll_timer();
+		else
+			tasklet_schedule(&ap_tasklet);
+		if (ap_thread_flag)
+			rc = ap_poll_thread_start();
+	} else {
+		ap_device_probe(dev);
+		ap_reset(ap_dev);
+		setup_timer(&ap_dev->timeout, ap_request_timeout,
+			    (unsigned long) ap_dev);
+	}
+
+	return rc;
+}
+
 static struct bus_type ap_bus_type = {
 	.name = "ap",
 	.match = &ap_bus_match,
 	.uevent = &ap_uevent,
+	.suspend = ap_bus_suspend,
+	.resume = ap_bus_resume
 };
 
 static int ap_device_probe(struct device *dev)
@@ -1066,7 +1145,7 @@ ap_config_timeout(unsigned long ptr)
  */
 static inline void ap_schedule_poll_timer(void)
 {
-	if (ap_using_interrupts())
+	if (ap_using_interrupts() || ap_suspend_flag)
 		return;
 	if (hrtimer_is_queued(&ap_poll_timer))
 		return;
@@ -1384,6 +1463,8 @@ static int ap_poll_thread(void *data)
 
 	set_user_nice(current, 19);
 	while (1) {
+		if (ap_suspend_flag)
+			return 0;
 		if (need_resched()) {
 			schedule();
 			continue;
@@ -1414,7 +1495,7 @@ static int ap_poll_thread_start(void)
 {
 	int rc;
 
-	if (ap_using_interrupts())
+	if (ap_using_interrupts() || ap_suspend_flag)
 		return 0;
 	mutex_lock(&ap_poll_thread_mutex);
 	if (!ap_poll_kthread) {
diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 52574ce..8c36eaf 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1307,7 +1307,7 @@ static void netiucv_pm_complete(struct device *dev)
  */
 static int netiucv_pm_freeze(struct device *dev)
 {
-	struct netiucv_priv *priv = dev->driver_data;
+	struct netiucv_priv *priv = dev_get_drvdata(dev);
 	struct net_device *ndev = NULL;
 	int rc = 0;
 
@@ -1331,7 +1331,7 @@ out:
  */
 static int netiucv_pm_restore_thaw(struct device *dev)
 {
-	struct netiucv_priv *priv = dev->driver_data;
+	struct netiucv_priv *priv = dev_get_drvdata(dev);
 	struct net_device *ndev = NULL;
 	int rc = 0;
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index bccb529..ceb68aa 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -13,6 +13,12 @@
 #define cpu_relax()	asm volatile ("" ::: "memory");
 #endif
 
+#ifdef __s390__
+#include "../../arch/s390/include/asm/unistd.h"
+#define rmb()		asm volatile("bcr 15,0" ::: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory");
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
