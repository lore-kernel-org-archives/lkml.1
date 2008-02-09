Return-Path: <linux-kernel-owner+w=401wt.eu-S1759984AbYBIMIG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984AbYBIMIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 07:08:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbYBIMGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 07:06:03 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:4445 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbYBIMFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 07:05:54 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Sat, 09 Feb 2008 13:05:48 +0100
Message-Id: <1202558748.8936.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/defconfig               |   87 ++++++++++++-----
 arch/s390/kernel/binfmt_elf32.c   |   11 ++
 arch/s390/kernel/compat_wrapper.S |   20 ++++
 arch/s390/kernel/process.c        |    1 -
 arch/s390/kernel/setup.c          |    1 -
 arch/s390/kernel/syscalls.S       |    3 +
 arch/s390/kernel/traps.c          |    3 +-
 arch/s390/mm/fault.c              |   40 ++++++++
 arch/s390/mm/init.c               |    3 +-
 arch/s390/mm/mmap.c               |   65 +++++++++++++
 arch/s390/mm/pgtable.c            |  176 ++++++++++++++++++++++++++++++----
 arch/s390/mm/vmem.c               |   28 +++++-
 drivers/s390/char/sclp_vt220.c    |   31 ++++---
 drivers/s390/cio/qdio.c           |   18 ++--
 drivers/s390/crypto/ap_bus.c      |    4 +-
 include/asm-s390/a.out.h          |   32 ------
 include/asm-s390/bitops.h         |    4 +-
 include/asm-s390/elf.h            |   22 +++--
 include/asm-s390/mmu.h            |    9 ++-
 include/asm-s390/mmu_context.h    |   20 +++--
 include/asm-s390/page.h           |   36 +------
 include/asm-s390/pgalloc.h        |  116 +++++++++++++----------
 include/asm-s390/pgtable.h        |  191 +++++++++++++++++++++----------------
 include/asm-s390/processor.h      |   45 +++------
 include/asm-s390/tlb.h            |   49 +++++++---
 include/asm-s390/tlbflush.h       |   11 +-
 include/asm-s390/unistd.h         |    5 +-
 27 files changed, 689 insertions(+), 342 deletions(-)
 delete mode 100644 include/asm-s390/a.out.h

Christian Borntraeger (1):
      [S390] sclp_vt220: Fix vt220 initialization

Felix Beck (1):
      [S390] zcrypt: Do not start ap poll thread per default

Martin Schwidefsky (8):
      [S390] Update default configuration.
      [S390] Wire up new timerfd syscalls.
      [S390] Fix __ffs_word_loop/__ffz_word_loop inlnie assembly.
      [S390] VMEM_MAX_PHYS overflow on 31 bit.
      [S390] Remove a.out header file.
      [S390] 1K/2K page table pages.
      [S390] Add four level page tables for CONFIG_64BIT=y.
      [S390] dynamic page tables.

Ursula Braun (1):
      [S390] qdio: avoid hang when establishing qdio queues

diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index ece7b99..39921f3 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,12 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.23
-# Mon Oct 22 12:10:44 2007
+# Linux kernel version: 2.6.24
+# Sat Feb  9 12:13:01 2008
 #
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
 CONFIG_LOCKDEP_SUPPORT=y
 CONFIG_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_LATENCYTOP_SUPPORT=y
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
 # CONFIG_ARCH_HAS_ILOG2_U32 is not set
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
@@ -15,6 +16,7 @@ CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_BUG=y
 CONFIG_NO_IOMEM=y
 CONFIG_NO_DMA=y
+CONFIG_GENERIC_LOCKBREAK=y
 CONFIG_S390=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
@@ -32,7 +34,6 @@ CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
 # CONFIG_BSD_PROCESS_ACCT is not set
 # CONFIG_TASKSTATS is not set
-# CONFIG_USER_NS is not set
 CONFIG_AUDIT=y
 # CONFIG_AUDITSYSCALL is not set
 CONFIG_IKCONFIG=y
@@ -41,13 +42,19 @@ CONFIG_LOG_BUF_SHIFT=17
 CONFIG_CGROUPS=y
 # CONFIG_CGROUP_DEBUG is not set
 CONFIG_CGROUP_NS=y
-CONFIG_CGROUP_CPUACCT=y
 # CONFIG_CPUSETS is not set
 CONFIG_FAIR_GROUP_SCHED=y
 CONFIG_FAIR_USER_SCHED=y
 # CONFIG_FAIR_CGROUP_SCHED is not set
+# CONFIG_CGROUP_CPUACCT is not set
+# CONFIG_RESOURCE_COUNTERS is not set
 CONFIG_SYSFS_DEPRECATED=y
 # CONFIG_RELAY is not set
+CONFIG_NAMESPACES=y
+CONFIG_UTS_NS=y
+CONFIG_IPC_NS=y
+# CONFIG_USER_NS is not set
+# CONFIG_PID_NS is not set
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
@@ -61,17 +68,26 @@ CONFIG_HOTPLUG=y
 CONFIG_PRINTK=y
 CONFIG_BUG=y
 CONFIG_ELF_CORE=y
+# CONFIG_COMPAT_BRK is not set
 CONFIG_BASE_FULL=y
 CONFIG_FUTEX=y
 CONFIG_ANON_INODES=y
 CONFIG_EPOLL=y
 CONFIG_SIGNALFD=y
+CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
+# CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+CONFIG_HAVE_OPROFILE=y
+CONFIG_KPROBES=y
+CONFIG_HAVE_KPROBES=y
+CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
 # CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
@@ -99,6 +115,8 @@ CONFIG_DEFAULT_DEADLINE=y
 # CONFIG_DEFAULT_CFQ is not set
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="deadline"
+CONFIG_CLASSIC_RCU=y
+# CONFIG_PREEMPT_RCU is not set
 
 #
 # Base setup
@@ -137,7 +155,7 @@ CONFIG_ARCH_POPULATES_NODE_MAP=y
 # CONFIG_PREEMPT_NONE is not set
 # CONFIG_PREEMPT_VOLUNTARY is not set
 CONFIG_PREEMPT=y
-CONFIG_PREEMPT_BKL=y
+# CONFIG_RCU_TRACE is not set
 CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_FLATMEM_MANUAL=y
 # CONFIG_DISCONTIGMEM_MANUAL is not set
@@ -151,7 +169,6 @@ CONFIG_RESOURCES_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
-CONFIG_HOLES_IN_ZONE=y
 
 #
 # I/O subsystem configuration
@@ -180,6 +197,7 @@ CONFIG_HZ_100=y
 # CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=100
+# CONFIG_SCHED_HRTICK is not set
 CONFIG_NO_IDLE_HZ=y
 CONFIG_NO_IDLE_HZ_INIT=y
 CONFIG_S390_HYPFS_FS=y
@@ -201,6 +219,7 @@ CONFIG_XFRM=y
 # CONFIG_XFRM_USER is not set
 # CONFIG_XFRM_SUB_POLICY is not set
 # CONFIG_XFRM_MIGRATE is not set
+# CONFIG_XFRM_STATISTICS is not set
 CONFIG_NET_KEY=y
 # CONFIG_NET_KEY_MIGRATE is not set
 CONFIG_IUCV=m
@@ -251,6 +270,7 @@ CONFIG_IPV6_SIT=y
 # CONFIG_NETWORK_SECMARK is not set
 CONFIG_NETFILTER=y
 # CONFIG_NETFILTER_DEBUG is not set
+CONFIG_NETFILTER_ADVANCED=y
 
 #
 # Core Netfilter Configuration
@@ -258,7 +278,6 @@ CONFIG_NETFILTER=y
 CONFIG_NETFILTER_NETLINK=m
 CONFIG_NETFILTER_NETLINK_QUEUE=m
 CONFIG_NETFILTER_NETLINK_LOG=m
-CONFIG_NF_CONNTRACK_ENABLED=m
 CONFIG_NF_CONNTRACK=m
 # CONFIG_NF_CT_ACCT is not set
 # CONFIG_NF_CONNTRACK_MARK is not set
@@ -286,7 +305,7 @@ CONFIG_NF_CONNTRACK=m
 # CONFIG_IP_NF_ARPTABLES is not set
 
 #
-# IPv6: Netfilter Configuration (EXPERIMENTAL)
+# IPv6: Netfilter Configuration
 #
 # CONFIG_NF_CONNTRACK_IPV6 is not set
 # CONFIG_IP6_NF_QUEUE is not set
@@ -343,6 +362,7 @@ CONFIG_NET_CLS_U32=m
 CONFIG_CLS_U32_MARK=y
 CONFIG_NET_CLS_RSVP=m
 CONFIG_NET_CLS_RSVP6=m
+CONFIG_NET_CLS_FLOW=m
 # CONFIG_NET_EMATCH is not set
 CONFIG_NET_CLS_ACT=y
 CONFIG_NET_ACT_POLICE=y
@@ -351,7 +371,6 @@ CONFIG_NET_ACT_POLICE=y
 CONFIG_NET_ACT_NAT=m
 # CONFIG_NET_ACT_PEDIT is not set
 # CONFIG_NET_ACT_SIMP is not set
-CONFIG_NET_CLS_POLICE=y
 # CONFIG_NET_CLS_IND is not set
 CONFIG_NET_SCH_FIFO=y
 
@@ -360,6 +379,15 @@ CONFIG_NET_SCH_FIFO=y
 #
 # CONFIG_NET_PKTGEN is not set
 # CONFIG_NET_TCPPROBE is not set
+CONFIG_CAN=m
+CONFIG_CAN_RAW=m
+CONFIG_CAN_BCM=m
+
+#
+# CAN Device Drivers
+#
+CONFIG_CAN_VCAN=m
+# CONFIG_CAN_DEBUG_DEVICES is not set
 # CONFIG_AF_RXRPC is not set
 # CONFIG_RFKILL is not set
 # CONFIG_NET_9P is not set
@@ -389,7 +417,7 @@ CONFIG_BLK_DEV_NBD=m
 CONFIG_BLK_DEV_RAM=y
 CONFIG_BLK_DEV_RAM_COUNT=16
 CONFIG_BLK_DEV_RAM_SIZE=4096
-CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024
+CONFIG_BLK_DEV_XIP=y
 # CONFIG_CDROM_PKTCDVD is not set
 # CONFIG_ATA_OVER_ETH is not set
 
@@ -406,6 +434,7 @@ CONFIG_DASD_DIAG=y
 CONFIG_DASD_EER=y
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
+# CONFIG_ENCLOSURE_SERVICES is not set
 
 #
 # SCSI device support
@@ -487,6 +516,7 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_IBM_NEW_EMAC_TAH is not set
 # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
 CONFIG_NETDEV_1000=y
+# CONFIG_E1000E_ENABLED is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_TR is not set
 # CONFIG_WAN is not set
@@ -508,7 +538,6 @@ CONFIG_QETH=y
 CONFIG_CCWGROUP=y
 # CONFIG_PPP is not set
 # CONFIG_SLIP is not set
-# CONFIG_SHAPER is not set
 # CONFIG_NETCONSOLE is not set
 # CONFIG_NETPOLL is not set
 # CONFIG_NET_POLL_CONTROLLER is not set
@@ -558,6 +587,7 @@ CONFIG_S390_TAPE_34XX=m
 CONFIG_MONWRITER=m
 CONFIG_S390_VMUR=m
 # CONFIG_POWER_SUPPLY is not set
+# CONFIG_THERMAL is not set
 # CONFIG_WATCHDOG is not set
 
 #
@@ -584,12 +614,10 @@ CONFIG_FS_POSIX_ACL=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
-# CONFIG_MINIX_FS is not set
-# CONFIG_ROMFS_FS is not set
+CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 # CONFIG_QUOTA is not set
-CONFIG_DNOTIFY=y
 # CONFIG_AUTOFS_FS is not set
 # CONFIG_AUTOFS4_FS is not set
 # CONFIG_FUSE_FS is not set
@@ -632,8 +660,10 @@ CONFIG_CONFIGFS_FS=m
 # CONFIG_EFS_FS is not set
 # CONFIG_CRAMFS is not set
 # CONFIG_VXFS_FS is not set
+# CONFIG_MINIX_FS is not set
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
+# CONFIG_ROMFS_FS is not set
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
@@ -686,16 +716,13 @@ CONFIG_MSDOS_PARTITION=y
 # CONFIG_NLS is not set
 CONFIG_DLM=m
 # CONFIG_DLM_DEBUG is not set
-CONFIG_INSTRUMENTATION=y
-# CONFIG_PROFILING is not set
-CONFIG_KPROBES=y
-# CONFIG_MARKERS is not set
 
 #
 # Kernel hacking
 #
 CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 # CONFIG_PRINTK_TIME is not set
+CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_UNUSED_SYMBOLS is not set
@@ -721,12 +748,18 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
+# CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
 CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_KPROBES_SANITY_TEST is not set
+# CONFIG_BACKTRACE_SELF_TEST is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
+# CONFIG_LATENCYTOP is not set
 CONFIG_SAMPLES=y
+# CONFIG_SAMPLE_KOBJECT is not set
+# CONFIG_DEBUG_PAGEALLOC is not set
 
 #
 # Security options
@@ -738,6 +771,7 @@ CONFIG_CRYPTO=y
 CONFIG_CRYPTO_ALGAPI=y
 CONFIG_CRYPTO_AEAD=m
 CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_SEQIV=m
 CONFIG_CRYPTO_HASH=m
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_HMAC=m
@@ -745,17 +779,20 @@ CONFIG_CRYPTO_HMAC=m
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_MD4 is not set
 CONFIG_CRYPTO_MD5=m
-# CONFIG_CRYPTO_SHA1 is not set
+CONFIG_CRYPTO_SHA1=m
 # CONFIG_CRYPTO_SHA256 is not set
 # CONFIG_CRYPTO_SHA512 is not set
 # CONFIG_CRYPTO_WP512 is not set
 # CONFIG_CRYPTO_TGR192 is not set
-# CONFIG_CRYPTO_GF128MUL is not set
+CONFIG_CRYPTO_GF128MUL=m
 CONFIG_CRYPTO_ECB=m
 CONFIG_CRYPTO_CBC=y
 CONFIG_CRYPTO_PCBC=m
 # CONFIG_CRYPTO_LRW is not set
 # CONFIG_CRYPTO_XTS is not set
+CONFIG_CRYPTO_CTR=m
+CONFIG_CRYPTO_GCM=m
+CONFIG_CRYPTO_CCM=m
 # CONFIG_CRYPTO_CRYPTD is not set
 # CONFIG_CRYPTO_DES is not set
 CONFIG_CRYPTO_FCRYPT=m
@@ -770,20 +807,22 @@ CONFIG_CRYPTO_FCRYPT=m
 # CONFIG_CRYPTO_KHAZAD is not set
 # CONFIG_CRYPTO_ANUBIS is not set
 CONFIG_CRYPTO_SEED=m
+CONFIG_CRYPTO_SALSA20=m
 # CONFIG_CRYPTO_DEFLATE is not set
 # CONFIG_CRYPTO_MICHAEL_MIC is not set
 # CONFIG_CRYPTO_CRC32C is not set
 CONFIG_CRYPTO_CAMELLIA=m
 # CONFIG_CRYPTO_TEST is not set
 CONFIG_CRYPTO_AUTHENC=m
+CONFIG_CRYPTO_LZO=m
 CONFIG_CRYPTO_HW=y
+CONFIG_ZCRYPT=m
+# CONFIG_ZCRYPT_MONOLITHIC is not set
 # CONFIG_CRYPTO_SHA1_S390 is not set
 # CONFIG_CRYPTO_SHA256_S390 is not set
 # CONFIG_CRYPTO_DES_S390 is not set
 # CONFIG_CRYPTO_AES_S390 is not set
 CONFIG_S390_PRNG=m
-CONFIG_ZCRYPT=m
-# CONFIG_ZCRYPT_MONOLITHIC is not set
 
 #
 # Library routines
@@ -794,5 +833,7 @@ CONFIG_BITREVERSE=m
 # CONFIG_CRC_ITU_T is not set
 CONFIG_CRC32=m
 CONFIG_CRC7=m
-# CONFIG_LIBCRC32C is not set
+CONFIG_LIBCRC32C=m
+CONFIG_LZO_COMPRESS=m
+CONFIG_LZO_DECOMPRESS=m
 CONFIG_PLIST=y
diff --git a/arch/s390/kernel/binfmt_elf32.c b/arch/s390/kernel/binfmt_elf32.c
index f1e40ca..3e1c315 100644
--- a/arch/s390/kernel/binfmt_elf32.c
+++ b/arch/s390/kernel/binfmt_elf32.c
@@ -134,6 +134,7 @@ static inline int dump_task_fpu(struct task_struct *tsk, elf_fpregset_t *fpregs)
 }
 
 #include <asm/processor.h>
+#include <asm/pgalloc.h>
 #include <linux/module.h>
 #include <linux/elfcore.h>
 #include <linux/binfmts.h>
@@ -183,6 +184,16 @@ struct elf_prpsinfo32
 #undef start_thread
 #define start_thread                    start_thread31 
 
+static inline void start_thread31(struct pt_regs *regs, unsigned long new_psw,
+				  unsigned long new_stackp)
+{
+	set_fs(USER_DS);
+	regs->psw.mask	= psw_user32_bits;
+	regs->psw.addr	= new_psw;
+	regs->gprs[15]	= new_stackp;
+	crst_table_downgrade(current->mm, 1UL << 31);
+}
+
 MODULE_DESCRIPTION("Binary format loader for compatibility with 32bit Linux for S390 binaries,"
                    " Copyright 2000 IBM Corporation"); 
 MODULE_AUTHOR("Gerhard Tonn <ton@de.ibm.com>");
diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index 062c3d4..743d54f 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1712,3 +1712,23 @@ sys_fallocate_wrapper:
 	sllg	%r5,%r6,32		# get high word of 64bit loff_t
 	l	%r5,164(%r15)		# get low word of 64bit loff_t
 	jg	sys_fallocate
+
+	.globl	sys_timerfd_create_wrapper
+sys_timerfd_create_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	jg	sys_timerfd_create
+
+	.globl	compat_sys_timerfd_settime_wrapper
+compat_sys_timerfd_settime_wrapper:
+	lgfr	%r2,%r2			# int
+	lgfr	%r3,%r3			# int
+	llgtr	%r4,%r4			# struct compat_itimerspec *
+	llgtr	%r5,%r5			# struct compat_itimerspec *
+	jg	compat_sys_timerfd_settime
+
+	.globl	compat_sys_timerfd_gettime_wrapper
+compat_sys_timerfd_gettime_wrapper:
+	lgfr	%r2,%r2			# int
+	llgtr	%r3,%r3			# struct compat_itimerspec *
+	jg	compat_sys_timerfd_gettime
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 0e7aca0..a6a4729 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -29,7 +29,6 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/reboot.h>
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index f9f8779..290e504 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -24,7 +24,6 @@
 #include <linux/ptrace.h>
 #include <linux/slab.h>
 #include <linux/user.h>
-#include <linux/a.out.h>
 #include <linux/tty.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
diff --git a/arch/s390/kernel/syscalls.S b/arch/s390/kernel/syscalls.S
index 25eac78..c87ec68 100644
--- a/arch/s390/kernel/syscalls.S
+++ b/arch/s390/kernel/syscalls.S
@@ -327,3 +327,6 @@ SYSCALL(sys_utimensat,sys_utimensat,compat_sys_utimensat_wrapper)	/* 315 */
 SYSCALL(sys_signalfd,sys_signalfd,compat_sys_signalfd_wrapper)
 NI_SYSCALL						/* 317 old sys_timer_fd */
 SYSCALL(sys_eventfd,sys_eventfd,sys_eventfd_wrapper)
+SYSCALL(sys_timerfd_create,sys_timerfd_create,sys_timerfd_create_wrapper)
+SYSCALL(sys_timerfd_settime,sys_timerfd_settime,compat_sys_timerfd_settime_wrapper) /* 320 */
+SYSCALL(sys_timerfd_gettime,sys_timerfd_gettime,compat_sys_timerfd_gettime_wrapper)
diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
index a4d2902..60f728a 100644
--- a/arch/s390/kernel/traps.c
+++ b/arch/s390/kernel/traps.c
@@ -60,6 +60,7 @@ int sysctl_userprocess_debug = 0;
 extern pgm_check_handler_t do_protection_exception;
 extern pgm_check_handler_t do_dat_exception;
 extern pgm_check_handler_t do_monitor_call;
+extern pgm_check_handler_t do_asce_exception;
 
 #define stack_pointer ({ void **sp; asm("la %0,0(15)" : "=&d" (sp)); sp; })
 
@@ -730,7 +731,7 @@ void __init trap_init(void)
         pgm_check_table[0x12] = &translation_exception;
         pgm_check_table[0x13] = &special_op_exception;
 #ifdef CONFIG_64BIT
-        pgm_check_table[0x38] = &do_dat_exception;
+	pgm_check_table[0x38] = &do_asce_exception;
 	pgm_check_table[0x39] = &do_dat_exception;
 	pgm_check_table[0x3A] = &do_dat_exception;
         pgm_check_table[0x3B] = &do_dat_exception;
diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 2456b52..ed13d42 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -32,6 +32,7 @@
 #include <asm/system.h>
 #include <asm/pgtable.h>
 #include <asm/s390_ext.h>
+#include <asm/mmu_context.h>
 
 #ifndef CONFIG_64BIT
 #define __FAIL_ADDR_MASK 0x7ffff000
@@ -444,6 +445,45 @@ void __kprobes do_dat_exception(struct pt_regs *regs, unsigned long error_code)
 	do_exception(regs, error_code & 0xff, 0);
 }
 
+#ifdef CONFIG_64BIT
+void __kprobes do_asce_exception(struct pt_regs *regs, unsigned long error_code)
+{
+	struct mm_struct *mm;
+	struct vm_area_struct *vma;
+	unsigned long address;
+	int space;
+
+	mm = current->mm;
+	address = S390_lowcore.trans_exc_code & __FAIL_ADDR_MASK;
+	space = check_space(current);
+
+	if (unlikely(space == 0 || in_atomic() || !mm))
+		goto no_context;
+
+	local_irq_enable();
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, address);
+	up_read(&mm->mmap_sem);
+
+	if (vma) {
+		update_mm(mm, current);
+		return;
+	}
+
+	/* User mode accesses just cause a SIGSEGV */
+	if (regs->psw.mask & PSW_MASK_PSTATE) {
+		current->thread.prot_addr = address;
+		current->thread.trap_no = error_code;
+		do_sigsegv(regs, error_code, SEGV_MAPERR, address);
+		return;
+	}
+
+no_context:
+	do_no_context(regs, error_code, address);
+}
+#endif
+
 #ifdef CONFIG_PFAULT 
 /*
  * 'pfault' pseudo page faults routines.
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index 983ec6e..8053245 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -112,6 +112,7 @@ void __init paging_init(void)
 	init_mm.pgd = swapper_pg_dir;
 	S390_lowcore.kernel_asce = __pa(init_mm.pgd) & PAGE_MASK;
 #ifdef CONFIG_64BIT
+	/* A three level page table (4TB) is enough for the kernel space. */
 	S390_lowcore.kernel_asce |= _ASCE_TYPE_REGION3 | _ASCE_TABLE_LENGTH;
 	pgd_type = _REGION3_ENTRY_EMPTY;
 #else
@@ -184,7 +185,7 @@ void kernel_map_pages(struct page *page, int numpages, int enable)
 		pmd = pmd_offset(pud, address);
 		pte = pte_offset_kernel(pmd, address);
 		if (!enable) {
-			ptep_invalidate(address, pte);
+			ptep_invalidate(&init_mm, address, pte);
 			continue;
 		}
 		*pte = mk_pte_phys(address, __pgprot(_PAGE_TYPE_RW));
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 356257c..5932a82 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,6 +27,7 @@
 #include <linux/personality.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <asm/pgalloc.h>
 
 /*
  * Top of mmap area (just below the process stack).
@@ -62,6 +63,8 @@ static inline int mmap_is_legacy(void)
 	    current->signal->rlim[RLIMIT_STACK].rlim_cur == RLIM_INFINITY;
 }
 
+#ifndef CONFIG_64BIT
+
 /*
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
@@ -84,3 +87,65 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
 }
 EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
 
+#else
+
+static unsigned long
+s390_get_unmapped_area(struct file *filp, unsigned long addr,
+		unsigned long len, unsigned long pgoff, unsigned long flags)
+{
+	struct mm_struct *mm = current->mm;
+	int rc;
+
+	addr = arch_get_unmapped_area(filp, addr, len, pgoff, flags);
+	if (addr & ~PAGE_MASK)
+		return addr;
+	if (unlikely(mm->context.asce_limit < addr + len)) {
+		rc = crst_table_upgrade(mm, addr + len);
+		if (rc)
+			return (unsigned long) rc;
+	}
+	return addr;
+}
+
+static unsigned long
+s390_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
+			  const unsigned long len, const unsigned long pgoff,
+			  const unsigned long flags)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long addr = addr0;
+	int rc;
+
+	addr = arch_get_unmapped_area_topdown(filp, addr, len, pgoff, flags);
+	if (addr & ~PAGE_MASK)
+		return addr;
+	if (unlikely(mm->context.asce_limit < addr + len)) {
+		rc = crst_table_upgrade(mm, addr + len);
+		if (rc)
+			return (unsigned long) rc;
+	}
+	return addr;
+}
+/*
+ * This function, called very early during the creation of a new
+ * process VM image, sets up which VM layout function to use:
+ */
+void arch_pick_mmap_layout(struct mm_struct *mm)
+{
+	/*
+	 * Fall back to the standard layout if the personality
+	 * bit is set, or if the expected stack growth is unlimited:
+	 */
+	if (mmap_is_legacy()) {
+		mm->mmap_base = TASK_UNMAPPED_BASE;
+		mm->get_unmapped_area = s390_get_unmapped_area;
+		mm->unmap_area = arch_unmap_area;
+	} else {
+		mm->mmap_base = mmap_base();
+		mm->get_unmapped_area = s390_get_unmapped_area_topdown;
+		mm->unmap_area = arch_unmap_area_topdown;
+	}
+}
+EXPORT_SYMBOL_GPL(arch_pick_mmap_layout);
+
+#endif
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 019f518..fd07201 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -23,11 +23,18 @@
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 #include <asm/tlbflush.h>
+#include <asm/mmu_context.h>
 
 #ifndef CONFIG_64BIT
 #define ALLOC_ORDER	1
+#define TABLES_PER_PAGE	4
+#define FRAG_MASK	15UL
+#define SECOND_HALVES	10UL
 #else
 #define ALLOC_ORDER	2
+#define TABLES_PER_PAGE	2
+#define FRAG_MASK	3UL
+#define SECOND_HALVES	2UL
 #endif
 
 unsigned long *crst_table_alloc(struct mm_struct *mm, int noexec)
@@ -45,52 +52,179 @@ unsigned long *crst_table_alloc(struct mm_struct *mm, int noexec)
 		}
 		page->index = page_to_phys(shadow);
 	}
+	spin_lock(&mm->page_table_lock);
+	list_add(&page->lru, &mm->context.crst_list);
+	spin_unlock(&mm->page_table_lock);
 	return (unsigned long *) page_to_phys(page);
 }
 
-void crst_table_free(unsigned long *table)
+void crst_table_free(struct mm_struct *mm, unsigned long *table)
 {
 	unsigned long *shadow = get_shadow_table(table);
+	struct page *page = virt_to_page(table);
 
+	spin_lock(&mm->page_table_lock);
+	list_del(&page->lru);
+	spin_unlock(&mm->page_table_lock);
 	if (shadow)
 		free_pages((unsigned long) shadow, ALLOC_ORDER);
 	free_pages((unsigned long) table, ALLOC_ORDER);
 }
 
+#ifdef CONFIG_64BIT
+int crst_table_upgrade(struct mm_struct *mm, unsigned long limit)
+{
+	unsigned long *table, *pgd;
+	unsigned long entry;
+
+	BUG_ON(limit > (1UL << 53));
+repeat:
+	table = crst_table_alloc(mm, mm->context.noexec);
+	if (!table)
+		return -ENOMEM;
+	spin_lock(&mm->page_table_lock);
+	if (mm->context.asce_limit < limit) {
+		pgd = (unsigned long *) mm->pgd;
+		if (mm->context.asce_limit <= (1UL << 31)) {
+			entry = _REGION3_ENTRY_EMPTY;
+			mm->context.asce_limit = 1UL << 42;
+			mm->context.asce_bits = _ASCE_TABLE_LENGTH |
+						_ASCE_USER_BITS |
+						_ASCE_TYPE_REGION3;
+		} else {
+			entry = _REGION2_ENTRY_EMPTY;
+			mm->context.asce_limit = 1UL << 53;
+			mm->context.asce_bits = _ASCE_TABLE_LENGTH |
+						_ASCE_USER_BITS |
+						_ASCE_TYPE_REGION2;
+		}
+		crst_table_init(table, entry);
+		pgd_populate(mm, (pgd_t *) table, (pud_t *) pgd);
+		mm->pgd = (pgd_t *) table;
+		table = NULL;
+	}
+	spin_unlock(&mm->page_table_lock);
+	if (table)
+		crst_table_free(mm, table);
+	if (mm->context.asce_limit < limit)
+		goto repeat;
+	update_mm(mm, current);
+	return 0;
+}
+
+void crst_table_downgrade(struct mm_struct *mm, unsigned long limit)
+{
+	pgd_t *pgd;
+
+	if (mm->context.asce_limit <= limit)
+		return;
+	__tlb_flush_mm(mm);
+	while (mm->context.asce_limit > limit) {
+		pgd = mm->pgd;
+		switch (pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) {
+		case _REGION_ENTRY_TYPE_R2:
+			mm->context.asce_limit = 1UL << 42;
+			mm->context.asce_bits = _ASCE_TABLE_LENGTH |
+						_ASCE_USER_BITS |
+						_ASCE_TYPE_REGION3;
+			break;
+		case _REGION_ENTRY_TYPE_R3:
+			mm->context.asce_limit = 1UL << 31;
+			mm->context.asce_bits = _ASCE_TABLE_LENGTH |
+						_ASCE_USER_BITS |
+						_ASCE_TYPE_SEGMENT;
+			break;
+		default:
+			BUG();
+		}
+		mm->pgd = (pgd_t *) (pgd_val(*pgd) & _REGION_ENTRY_ORIGIN);
+		crst_table_free(mm, (unsigned long *) pgd);
+	}
+	update_mm(mm, current);
+}
+#endif
+
 /*
  * page table entry allocation/free routines.
  */
-unsigned long *page_table_alloc(int noexec)
+unsigned long *page_table_alloc(struct mm_struct *mm)
 {
-	struct page *page = alloc_page(GFP_KERNEL);
+	struct page *page;
 	unsigned long *table;
+	unsigned long bits;
 
-	if (!page)
-		return NULL;
-	page->index = 0;
-	if (noexec) {
-		struct page *shadow = alloc_page(GFP_KERNEL);
-		if (!shadow) {
-			__free_page(page);
+	bits = mm->context.noexec ? 3UL : 1UL;
+	spin_lock(&mm->page_table_lock);
+	page = NULL;
+	if (!list_empty(&mm->context.pgtable_list)) {
+		page = list_first_entry(&mm->context.pgtable_list,
+					struct page, lru);
+		if ((page->flags & FRAG_MASK) == ((1UL << TABLES_PER_PAGE) - 1))
+			page = NULL;
+	}
+	if (!page) {
+		spin_unlock(&mm->page_table_lock);
+		page = alloc_page(GFP_KERNEL|__GFP_REPEAT);
+		if (!page)
 			return NULL;
-		}
-		table = (unsigned long *) page_to_phys(shadow);
+		pgtable_page_ctor(page);
+		page->flags &= ~FRAG_MASK;
+		table = (unsigned long *) page_to_phys(page);
 		clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
-		page->index = (addr_t) table;
+		spin_lock(&mm->page_table_lock);
+		list_add(&page->lru, &mm->context.pgtable_list);
 	}
-	pgtable_page_ctor(page);
 	table = (unsigned long *) page_to_phys(page);
-	clear_table(table, _PAGE_TYPE_EMPTY, PAGE_SIZE);
+	while (page->flags & bits) {
+		table += 256;
+		bits <<= 1;
+	}
+	page->flags |= bits;
+	if ((page->flags & FRAG_MASK) == ((1UL << TABLES_PER_PAGE) - 1))
+		list_move_tail(&page->lru, &mm->context.pgtable_list);
+	spin_unlock(&mm->page_table_lock);
 	return table;
 }
 
-void page_table_free(unsigned long *table)
+void page_table_free(struct mm_struct *mm, unsigned long *table)
 {
-	unsigned long *shadow = get_shadow_pte(table);
+	struct page *page;
+	unsigned long bits;
 
-	pgtable_page_dtor(virt_to_page(table));
-	if (shadow)
-		free_page((unsigned long) shadow);
-	free_page((unsigned long) table);
+	bits = mm->context.noexec ? 3UL : 1UL;
+	bits <<= (__pa(table) & (PAGE_SIZE - 1)) / 256 / sizeof(unsigned long);
+	page = pfn_to_page(__pa(table) >> PAGE_SHIFT);
+	spin_lock(&mm->page_table_lock);
+	page->flags ^= bits;
+	if (page->flags & FRAG_MASK) {
+		/* Page now has some free pgtable fragments. */
+		list_move(&page->lru, &mm->context.pgtable_list);
+		page = NULL;
+	} else
+		/* All fragments of the 4K page have been freed. */
+		list_del(&page->lru);
+	spin_unlock(&mm->page_table_lock);
+	if (page) {
+		pgtable_page_dtor(page);
+		__free_page(page);
+	}
+}
 
+void disable_noexec(struct mm_struct *mm, struct task_struct *tsk)
+{
+	struct page *page;
+
+	spin_lock(&mm->page_table_lock);
+	/* Free shadow region and segment tables. */
+	list_for_each_entry(page, &mm->context.crst_list, lru)
+		if (page->index) {
+			free_pages((unsigned long) page->index, ALLOC_ORDER);
+			page->index = 0;
+		}
+	/* "Free" second halves of page tables. */
+	list_for_each_entry(page, &mm->context.pgtable_list, lru)
+		page->flags &= ~SECOND_HALVES;
+	spin_unlock(&mm->page_table_lock);
+	mm->context.noexec = 0;
+	update_mm(mm, tsk);
 }
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 7c1287c..35d90a4 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -69,7 +69,19 @@ static void __ref *vmem_alloc_pages(unsigned int order)
 	return alloc_bootmem_pages((1 << order) * PAGE_SIZE);
 }
 
-#define vmem_pud_alloc()	({ BUG(); ((pud_t *) NULL); })
+static inline pud_t *vmem_pud_alloc(void)
+{
+	pud_t *pud = NULL;
+
+#ifdef CONFIG_64BIT
+	pud = vmem_alloc_pages(2);
+	if (!pud)
+		return NULL;
+	pud_val(*pud) = _REGION3_ENTRY_EMPTY;
+	memcpy(pud + 1, pud, (PTRS_PER_PUD - 1)*sizeof(pud_t));
+#endif
+	return pud;
+}
 
 static inline pmd_t *vmem_pmd_alloc(void)
 {
@@ -84,13 +96,18 @@ static inline pmd_t *vmem_pmd_alloc(void)
 	return pmd;
 }
 
-static inline pte_t *vmem_pte_alloc(void)
+static pte_t __init_refok *vmem_pte_alloc(void)
 {
-	pte_t *pte = vmem_alloc_pages(0);
+	pte_t *pte;
 
+	if (slab_is_available())
+		pte = (pte_t *) page_table_alloc(&init_mm);
+	else
+		pte = alloc_bootmem(PTRS_PER_PTE * sizeof(pte_t));
 	if (!pte)
 		return NULL;
-	clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY, PAGE_SIZE);
+	clear_table((unsigned long *) pte, _PAGE_TYPE_EMPTY,
+		    PTRS_PER_PTE * sizeof(pte_t));
 	return pte;
 }
 
@@ -360,6 +377,9 @@ void __init vmem_map_init(void)
 {
 	int i;
 
+	INIT_LIST_HEAD(&init_mm.context.crst_list);
+	INIT_LIST_HEAD(&init_mm.context.pgtable_list);
+	init_mm.context.noexec = 0;
 	NODE_DATA(0)->node_mem_map = VMEM_MAP;
 	for (i = 0; i < MEMORY_CHUNKS && memory_chunk[i].size > 0; i++)
 		vmem_add_mem(memory_chunk[i].addr, memory_chunk[i].size);
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 6807162..f47f4a7 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -3,7 +3,7 @@
  *    SCLP VT220 terminal driver.
  *
  *  S390 version
- *    Copyright (C) 2003 IBM Deutschland Entwicklung GmbH, IBM Corporation
+ *    Copyright IBM Corp. 2003,2008
  *    Author(s): Peter Oberparleiter <Peter.Oberparleiter@de.ibm.com>
  */
 
@@ -632,6 +632,9 @@ static void __init __sclp_vt220_cleanup(void)
 		else
 			free_bootmem((unsigned long) page, PAGE_SIZE);
 	}
+	if (!list_empty(&sclp_vt220_register.list))
+		sclp_unregister(&sclp_vt220_register);
+	sclp_vt220_initialized = 0;
 }
 
 static int __init __sclp_vt220_init(void)
@@ -639,6 +642,7 @@ static int __init __sclp_vt220_init(void)
 	void *page;
 	int i;
 	int num_pages;
+	int rc;
 
 	if (sclp_vt220_initialized)
 		return 0;
@@ -667,7 +671,14 @@ static int __init __sclp_vt220_init(void)
 		}
 		list_add_tail((struct list_head *) page, &sclp_vt220_empty);
 	}
-	return 0;
+	rc = sclp_register(&sclp_vt220_register);
+	if (rc) {
+		printk(KERN_ERR SCLP_VT220_PRINT_HEADER
+		       "could not register vt220 - "
+		       "sclp_register returned %d\n", rc);
+		__sclp_vt220_cleanup();
+	}
+	return rc;
 }
 
 static const struct tty_operations sclp_vt220_ops = {
@@ -688,22 +699,17 @@ static int __init sclp_vt220_tty_init(void)
 {
 	struct tty_driver *driver;
 	int rc;
+	int cleanup;
 
 	/* Note: we're not testing for CONSOLE_IS_SCLP here to preserve
 	 * symmetry between VM and LPAR systems regarding ttyS1. */
 	driver = alloc_tty_driver(1);
 	if (!driver)
 		return -ENOMEM;
+	cleanup = !sclp_vt220_initialized;
 	rc = __sclp_vt220_init();
 	if (rc)
 		goto out_driver;
-	rc = sclp_register(&sclp_vt220_register);
-	if (rc) {
-		printk(KERN_ERR SCLP_VT220_PRINT_HEADER
-		       "could not register tty - "
-		       "sclp_register returned %d\n", rc);
-		goto out_init;
-	}
 
 	driver->owner = THIS_MODULE;
 	driver->driver_name = SCLP_VT220_DRIVER_NAME;
@@ -721,15 +727,14 @@ static int __init sclp_vt220_tty_init(void)
 		printk(KERN_ERR SCLP_VT220_PRINT_HEADER
 		       "could not register tty - "
 		       "tty_register_driver returned %d\n", rc);
-		goto out_sclp;
+		goto out_init;
 	}
 	sclp_vt220_driver = driver;
 	return 0;
 
-out_sclp:
-	sclp_unregister(&sclp_vt220_register);
 out_init:
-	__sclp_vt220_cleanup();
+	if (cleanup)
+		__sclp_vt220_cleanup();
 out_driver:
 	put_tty_driver(driver);
 	return rc;
diff --git a/drivers/s390/cio/qdio.c b/drivers/s390/cio/qdio.c
index e2a781b..097fc09 100644
--- a/drivers/s390/cio/qdio.c
+++ b/drivers/s390/cio/qdio.c
@@ -3189,13 +3189,11 @@ qdio_establish(struct qdio_initialize *init_data)
 	spin_lock_irqsave(get_ccwdev_lock(cdev),saveflags);
 
 	ccw_device_set_options_mask(cdev, 0);
-	result=ccw_device_start_timeout(cdev,&irq_ptr->ccw,
-					QDIO_DOING_ESTABLISH,0, 0,
-					QDIO_ESTABLISH_TIMEOUT);
+	result = ccw_device_start(cdev, &irq_ptr->ccw,
+				QDIO_DOING_ESTABLISH, 0, 0);
 	if (result) {
-		result2=ccw_device_start_timeout(cdev,&irq_ptr->ccw,
-						 QDIO_DOING_ESTABLISH,0,0,
-						 QDIO_ESTABLISH_TIMEOUT);
+		result2 = ccw_device_start(cdev, &irq_ptr->ccw,
+					QDIO_DOING_ESTABLISH, 0, 0);
 		sprintf(dbf_text,"eq:io%4x",result);
 		QDIO_DBF_TEXT2(1,setup,dbf_text);
 		if (result2) {
@@ -3219,10 +3217,10 @@ qdio_establish(struct qdio_initialize *init_data)
 		return result;
 	}
 	
-	/* Timeout is cared for already by using ccw_device_start_timeout(). */
-	wait_event_interruptible(cdev->private->wait_q,
-		 irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
-		 irq_ptr->state == QDIO_IRQ_STATE_ERR);
+	wait_event_interruptible_timeout(cdev->private->wait_q,
+		irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED ||
+		irq_ptr->state == QDIO_IRQ_STATE_ERR,
+		QDIO_ESTABLISH_TIMEOUT);
 
 	if (irq_ptr->state == QDIO_IRQ_STATE_ESTABLISHED)
 		result = 0;
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 67aaff3..d0c6fd3 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -61,9 +61,9 @@ module_param_named(domain, ap_domain_index, int, 0000);
 MODULE_PARM_DESC(domain, "domain index for ap devices");
 EXPORT_SYMBOL(ap_domain_index);
 
-static int ap_thread_flag = 1;
+static int ap_thread_flag = 0;
 module_param_named(poll_thread, ap_thread_flag, int, 0000);
-MODULE_PARM_DESC(poll_thread, "Turn on/off poll thread, default is 1 (on).");
+MODULE_PARM_DESC(poll_thread, "Turn on/off poll thread, default is 0 (off).");
 
 static struct device *ap_root_device = NULL;
 static DEFINE_SPINLOCK(ap_device_lock);
diff --git a/include/asm-s390/a.out.h b/include/asm-s390/a.out.h
deleted file mode 100644
index 8d6bd9c..0000000
--- a/include/asm-s390/a.out.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- *  include/asm-s390/a.out.h
- *
- *  S390 version
- *    Copyright (C) 1999 IBM Deutschland Entwicklung GmbH, IBM Corporation
- *
- *  Derived from "include/asm-i386/a.out.h"
- *    Copyright (C) 1992, Linus Torvalds
- *
- * I don't think we'll ever need a.out ...
- */
-
-#ifndef __S390_A_OUT_H__
-#define __S390_A_OUT_H__
-
-struct exec
-{
-  unsigned long a_info;		/* Use macros N_MAGIC, etc for access */
-  unsigned a_text;		/* length of text, in bytes */
-  unsigned a_data;		/* length of data, in bytes */
-  unsigned a_bss;		/* length of uninitialized data area for file, in bytes */
-  unsigned a_syms;		/* length of symbol table data in file, in bytes */
-  unsigned a_entry;		/* start address */
-  unsigned a_trsize;		/* length of relocation info for text, in bytes */
-  unsigned a_drsize;		/* length of relocation info for data, in bytes */
-};
-
-#define N_TRSIZE(a)	((a).a_trsize)
-#define N_DRSIZE(a)	((a).a_drsize)
-#define N_SYMSIZE(a)	((a).a_syms)
-
-#endif /* __A_OUT_GNU_H__ */
diff --git a/include/asm-s390/bitops.h b/include/asm-s390/bitops.h
index 882db05..ab83c84 100644
--- a/include/asm-s390/bitops.h
+++ b/include/asm-s390/bitops.h
@@ -472,7 +472,7 @@ static inline unsigned long __ffz_word_loop(const unsigned long *addr,
 		"	brct	%1,0b\n"
 		"1:\n"
 #endif
-		: "+a" (bytes), "+d" (size)
+		: "+&a" (bytes), "+&d" (size)
 		: "d" (-1UL), "a" (addr), "m" (*(addrtype *) addr)
 		: "cc" );
 	return bytes;
@@ -507,7 +507,7 @@ static inline unsigned long __ffs_word_loop(const unsigned long *addr,
 		"	brct	%1,0b\n"
 		"1:\n"
 #endif
-		: "+a" (bytes), "+a" (size)
+		: "+&a" (bytes), "+&a" (size)
 		: "d" (0UL), "a" (addr), "m" (*(addrtype *) addr)
 		: "cc" );
 	return bytes;
diff --git a/include/asm-s390/elf.h b/include/asm-s390/elf.h
index b73a424..b3ac262 100644
--- a/include/asm-s390/elf.h
+++ b/include/asm-s390/elf.h
@@ -115,6 +115,7 @@ typedef s390_regs elf_gregset_t;
 
 #include <linux/sched.h>	/* for task_struct */
 #include <asm/system.h>		/* for save_access_regs */
+#include <asm/mmu_context.h>
 
 /*
  * This is used to ensure we don't load something for the wrong architecture.
@@ -137,14 +138,7 @@ typedef s390_regs elf_gregset_t;
    use of this is to invoke "./ld.so someprog" to test out a new version of
    the loader.  We need to make sure that it is out of the way of the program
    that it will "exec", and that there is sufficient room for the brk.  */
-
-#ifndef __s390x__
-#define ELF_ET_DYN_BASE         ((TASK_SIZE & 0x80000000) \
-                                ? TASK_SIZE / 3 * 2 \
-                                : 2 * TASK_SIZE / 3)
-#else /* __s390x__ */
-#define ELF_ET_DYN_BASE         (TASK_SIZE / 3 * 2)
-#endif /* __s390x__ */
+#define ELF_ET_DYN_BASE		(STACK_TOP / 3 * 2)
 
 /* Wow, the "main" arch needs arch dependent functions too.. :) */
 
@@ -214,4 +208,16 @@ do {							\
 } while (0)
 #endif /* __s390x__ */
 
+/*
+ * An executable for which elf_read_implies_exec() returns TRUE will
+ * have the READ_IMPLIES_EXEC personality flag set automatically.
+ */
+#define elf_read_implies_exec(ex, executable_stack)	\
+({							\
+	if (current->mm->context.noexec &&		\
+	    executable_stack != EXSTACK_DISABLE_X)	\
+		disable_noexec(current->mm, current);	\
+	current->mm->context.noexec == 0;		\
+})
+
 #endif
diff --git a/include/asm-s390/mmu.h b/include/asm-s390/mmu.h
index ccd36d2..1698e29 100644
--- a/include/asm-s390/mmu.h
+++ b/include/asm-s390/mmu.h
@@ -1,7 +1,12 @@
 #ifndef __MMU_H
 #define __MMU_H
 
-/* Default "unsigned long" context */
-typedef unsigned long mm_context_t;
+typedef struct {
+	struct list_head crst_list;
+	struct list_head pgtable_list;
+	unsigned long asce_bits;
+	unsigned long asce_limit;
+	int noexec;
+} mm_context_t;
 
 #endif
diff --git a/include/asm-s390/mmu_context.h b/include/asm-s390/mmu_context.h
index a77d4ba..b5a34c6 100644
--- a/include/asm-s390/mmu_context.h
+++ b/include/asm-s390/mmu_context.h
@@ -10,15 +10,19 @@
 #define __S390_MMU_CONTEXT_H
 
 #include <asm/pgalloc.h>
+#include <asm/uaccess.h>
 #include <asm-generic/mm_hooks.h>
 
 static inline int init_new_context(struct task_struct *tsk,
 				   struct mm_struct *mm)
 {
-	mm->context = _ASCE_TABLE_LENGTH | _ASCE_USER_BITS;
+	mm->context.asce_bits = _ASCE_TABLE_LENGTH | _ASCE_USER_BITS;
 #ifdef CONFIG_64BIT
-	mm->context |= _ASCE_TYPE_REGION3;
+	mm->context.asce_bits |= _ASCE_TYPE_REGION3;
 #endif
+	mm->context.noexec = s390_noexec;
+	mm->context.asce_limit = STACK_TOP_MAX;
+	crst_table_init((unsigned long *) mm->pgd, pgd_entry_type(mm));
 	return 0;
 }
 
@@ -32,24 +36,25 @@ static inline int init_new_context(struct task_struct *tsk,
 
 static inline void update_mm(struct mm_struct *mm, struct task_struct *tsk)
 {
-	S390_lowcore.user_asce = mm->context | __pa(mm->pgd);
+	pgd_t *pgd = mm->pgd;
+
+	S390_lowcore.user_asce = mm->context.asce_bits | __pa(pgd);
 	if (switch_amode) {
 		/* Load primary space page table origin. */
-		pgd_t *shadow_pgd = get_shadow_table(mm->pgd) ? : mm->pgd;
-		S390_lowcore.user_exec_asce = mm->context | __pa(shadow_pgd);
+		pgd = mm->context.noexec ? get_shadow_table(pgd) : pgd;
+		S390_lowcore.user_exec_asce = mm->context.asce_bits | __pa(pgd);
 		asm volatile(LCTL_OPCODE" 1,1,%0\n"
 			     : : "m" (S390_lowcore.user_exec_asce) );
 	} else
 		/* Load home space page table origin. */
 		asm volatile(LCTL_OPCODE" 13,13,%0"
 			     : : "m" (S390_lowcore.user_asce) );
+	set_fs(current->thread.mm_segment);
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next,
 			     struct task_struct *tsk)
 {
-	if (unlikely(prev == next))
-		return;
 	cpu_set(smp_processor_id(), next->cpu_vm_mask);
 	update_mm(next, tsk);
 }
@@ -61,7 +66,6 @@ static inline void activate_mm(struct mm_struct *prev,
                                struct mm_struct *next)
 {
         switch_mm(prev, next, current);
-	set_fs(current->thread.mm_segment);
 }
 
 #endif /* __S390_MMU_CONTEXT_H */
diff --git a/include/asm-s390/page.h b/include/asm-s390/page.h
index 7f29a98..fe7f92b 100644
--- a/include/asm-s390/page.h
+++ b/include/asm-s390/page.h
@@ -74,43 +74,17 @@ static inline void copy_page(void *to, void *from)
 
 typedef struct { unsigned long pgprot; } pgprot_t;
 typedef struct { unsigned long pte; } pte_t;
-
-#define pte_val(x)      ((x).pte)
-#define pgprot_val(x)   ((x).pgprot)
-
-#ifndef __s390x__
-
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pud; } pud_t;
-typedef struct {
-        unsigned long pgd0;
-        unsigned long pgd1;
-        unsigned long pgd2;
-        unsigned long pgd3;
-        } pgd_t;
-
-#define pmd_val(x)      ((x).pmd)
-#define pud_val(x)	((x).pud)
-#define pgd_val(x)      ((x).pgd0)
-
-#else /* __s390x__ */
-
-typedef struct { 
-        unsigned long pmd0;
-        unsigned long pmd1; 
-        } pmd_t;
-typedef struct { unsigned long pud; } pud_t;
 typedef struct { unsigned long pgd; } pgd_t;
+typedef pte_t *pgtable_t;
 
-#define pmd_val(x)      ((x).pmd0)
-#define pmd_val1(x)     ((x).pmd1)
+#define pgprot_val(x)	((x).pgprot)
+#define pte_val(x)	((x).pte)
+#define pmd_val(x)	((x).pmd)
 #define pud_val(x)	((x).pud)
 #define pgd_val(x)      ((x).pgd)
 
-#endif /* __s390x__ */
-
-typedef struct page *pgtable_t;
-
 #define __pte(x)        ((pte_t) { (x) } )
 #define __pmd(x)        ((pmd_t) { (x) } )
 #define __pgd(x)        ((pgd_t) { (x) } )
@@ -167,7 +141,7 @@ static inline int pfn_valid(unsigned long pfn)
 #define page_to_phys(page)	(page_to_pfn(page) << PAGE_SHIFT)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
 
-#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | VM_EXEC | \
+#define VM_DATA_DEFAULT_FLAGS	(VM_READ | VM_WRITE | \
 				 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
 
 #include <asm-generic/memory_model.h>
diff --git a/include/asm-s390/pgalloc.h b/include/asm-s390/pgalloc.h
index 900d448..f5b2bf3 100644
--- a/include/asm-s390/pgalloc.h
+++ b/include/asm-s390/pgalloc.h
@@ -20,10 +20,11 @@
 #define check_pgt_cache()	do {} while (0)
 
 unsigned long *crst_table_alloc(struct mm_struct *, int);
-void crst_table_free(unsigned long *);
+void crst_table_free(struct mm_struct *, unsigned long *);
 
-unsigned long *page_table_alloc(int);
-void page_table_free(unsigned long *);
+unsigned long *page_table_alloc(struct mm_struct *);
+void page_table_free(struct mm_struct *, unsigned long *);
+void disable_noexec(struct mm_struct *, struct task_struct *);
 
 static inline void clear_table(unsigned long *s, unsigned long val, size_t n)
 {
@@ -72,23 +73,49 @@ static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 
 static inline unsigned long pgd_entry_type(struct mm_struct *mm)
 {
-	return _REGION3_ENTRY_EMPTY;
+	if (mm->context.asce_limit <= (1UL << 31))
+		return _SEGMENT_ENTRY_EMPTY;
+	if (mm->context.asce_limit <= (1UL << 42))
+		return _REGION3_ENTRY_EMPTY;
+	return _REGION2_ENTRY_EMPTY;
 }
 
-#define pud_alloc_one(mm,address)		({ BUG(); ((pud_t *)2); })
-#define pud_free(mm, x)				do { } while (0)
+int crst_table_upgrade(struct mm_struct *, unsigned long limit);
+void crst_table_downgrade(struct mm_struct *, unsigned long limit);
+
+static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
+{
+	unsigned long *table = crst_table_alloc(mm, mm->context.noexec);
+	if (table)
+		crst_table_init(table, _REGION3_ENTRY_EMPTY);
+	return (pud_t *) table;
+}
+#define pud_free(mm, pud) crst_table_free(mm, (unsigned long *) pud)
 
 static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long vmaddr)
 {
-	unsigned long *crst = crst_table_alloc(mm, s390_noexec);
-	if (crst)
-		crst_table_init(crst, _SEGMENT_ENTRY_EMPTY);
-	return (pmd_t *) crst;
+	unsigned long *table = crst_table_alloc(mm, mm->context.noexec);
+	if (table)
+		crst_table_init(table, _SEGMENT_ENTRY_EMPTY);
+	return (pmd_t *) table;
 }
-#define pmd_free(mm, pmd) crst_table_free((unsigned long *)pmd)
+#define pmd_free(mm, pmd) crst_table_free(mm, (unsigned long *) pmd)
 
-#define pgd_populate(mm, pgd, pud)		BUG()
-#define pgd_populate_kernel(mm, pgd, pud)	BUG()
+static inline void pgd_populate_kernel(struct mm_struct *mm,
+				       pgd_t *pgd, pud_t *pud)
+{
+	pgd_val(*pgd) = _REGION2_ENTRY | __pa(pud);
+}
+
+static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgd, pud_t *pud)
+{
+	pgd_populate_kernel(mm, pgd, pud);
+	if (mm->context.noexec) {
+		pgd = get_shadow_table(pgd);
+		pud = get_shadow_table(pud);
+		pgd_populate_kernel(mm, pgd, pud);
+	}
+}
 
 static inline void pud_populate_kernel(struct mm_struct *mm,
 				       pud_t *pud, pmd_t *pmd)
@@ -98,63 +125,50 @@ static inline void pud_populate_kernel(struct mm_struct *mm,
 
 static inline void pud_populate(struct mm_struct *mm, pud_t *pud, pmd_t *pmd)
 {
-	pud_t *shadow_pud = get_shadow_table(pud);
-	pmd_t *shadow_pmd = get_shadow_table(pmd);
-
-	if (shadow_pud && shadow_pmd)
-		pud_populate_kernel(mm, shadow_pud, shadow_pmd);
 	pud_populate_kernel(mm, pud, pmd);
+	if (mm->context.noexec) {
+		pud = get_shadow_table(pud);
+		pmd = get_shadow_table(pmd);
+		pud_populate_kernel(mm, pud, pmd);
+	}
 }
 
 #endif /* __s390x__ */
 
 static inline pgd_t *pgd_alloc(struct mm_struct *mm)
 {
-	unsigned long *crst = crst_table_alloc(mm, s390_noexec);
-	if (crst)
-		crst_table_init(crst, pgd_entry_type(mm));
-	return (pgd_t *) crst;
+	INIT_LIST_HEAD(&mm->context.crst_list);
+	INIT_LIST_HEAD(&mm->context.pgtable_list);
+	return (pgd_t *) crst_table_alloc(mm, s390_noexec);
 }
-#define pgd_free(mm, pgd) crst_table_free((unsigned long *) pgd)
+#define pgd_free(mm, pgd) crst_table_free(mm, (unsigned long *) pgd)
 
-static inline void 
-pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmd, pte_t *pte)
+static inline void pmd_populate_kernel(struct mm_struct *mm,
+				       pmd_t *pmd, pte_t *pte)
 {
-#ifndef __s390x__
-	pmd_val(pmd[0]) = _SEGMENT_ENTRY + __pa(pte);
-	pmd_val(pmd[1]) = _SEGMENT_ENTRY + __pa(pte+256);
-	pmd_val(pmd[2]) = _SEGMENT_ENTRY + __pa(pte+512);
-	pmd_val(pmd[3]) = _SEGMENT_ENTRY + __pa(pte+768);
-#else /* __s390x__ */
 	pmd_val(*pmd) = _SEGMENT_ENTRY + __pa(pte);
-	pmd_val1(*pmd) = _SEGMENT_ENTRY + __pa(pte+256);
-#endif /* __s390x__ */
 }
 
-static inline void
-pmd_populate(struct mm_struct *mm, pmd_t *pmd, pgtable_t page)
+static inline void pmd_populate(struct mm_struct *mm,
+				pmd_t *pmd, pgtable_t pte)
 {
-	pte_t *pte = (pte_t *)page_to_phys(page);
-	pmd_t *shadow_pmd = get_shadow_table(pmd);
-	pte_t *shadow_pte = get_shadow_pte(pte);
-
 	pmd_populate_kernel(mm, pmd, pte);
-	if (shadow_pmd && shadow_pte)
-		pmd_populate_kernel(mm, shadow_pmd, shadow_pte);
+	if (mm->context.noexec) {
+		pmd = get_shadow_table(pmd);
+		pmd_populate_kernel(mm, pmd, pte + PTRS_PER_PTE);
+	}
 }
-#define pmd_pgtable(pmd) pmd_page(pmd)
+
+#define pmd_pgtable(pmd) \
+	(pgtable_t)(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE)
 
 /*
  * page table entry allocation/free routines.
  */
-#define pte_alloc_one_kernel(mm, vmaddr) \
-	((pte_t *) page_table_alloc(s390_noexec))
-#define pte_alloc_one(mm, vmaddr) \
-	virt_to_page(page_table_alloc(s390_noexec))
-
-#define pte_free_kernel(mm, pte) \
-	page_table_free((unsigned long *) pte)
-#define pte_free(mm, pte) \
-	page_table_free((unsigned long *) page_to_phys((struct page *) pte))
+#define pte_alloc_one_kernel(mm, vmaddr) ((pte_t *) page_table_alloc(mm))
+#define pte_alloc_one(mm, vmaddr) ((pte_t *) page_table_alloc(mm))
+
+#define pte_free_kernel(mm, pte) page_table_free(mm, (unsigned long *) pte)
+#define pte_free(mm, pte) page_table_free(mm, (unsigned long *) pte)
 
 #endif /* _S390_PGALLOC_H */
diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index 3f52075..65154dc 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -57,21 +57,21 @@ extern char empty_zero_page[PAGE_SIZE];
  * PGDIR_SHIFT determines what a third-level page table entry can map
  */
 #ifndef __s390x__
-# define PMD_SHIFT	22
-# define PUD_SHIFT	22
-# define PGDIR_SHIFT	22
+# define PMD_SHIFT	20
+# define PUD_SHIFT	20
+# define PGDIR_SHIFT	20
 #else /* __s390x__ */
-# define PMD_SHIFT	21
+# define PMD_SHIFT	20
 # define PUD_SHIFT	31
-# define PGDIR_SHIFT	31
+# define PGDIR_SHIFT	42
 #endif /* __s390x__ */
 
 #define PMD_SIZE        (1UL << PMD_SHIFT)
 #define PMD_MASK        (~(PMD_SIZE-1))
 #define PUD_SIZE	(1UL << PUD_SHIFT)
 #define PUD_MASK	(~(PUD_SIZE-1))
-#define PGDIR_SIZE      (1UL << PGDIR_SHIFT)
-#define PGDIR_MASK      (~(PGDIR_SIZE-1))
+#define PGDIR_SIZE	(1UL << PGDIR_SHIFT)
+#define PGDIR_MASK	(~(PGDIR_SIZE-1))
 
 /*
  * entries per page directory level: the S390 is two-level, so
@@ -79,17 +79,15 @@ extern char empty_zero_page[PAGE_SIZE];
  * for S390 segment-table entries are combined to one PGD
  * that leads to 1024 pte per pgd
  */
+#define PTRS_PER_PTE	256
 #ifndef __s390x__
-# define PTRS_PER_PTE    1024
-# define PTRS_PER_PMD    1
-# define PTRS_PER_PUD	1
-# define PTRS_PER_PGD    512
+#define PTRS_PER_PMD	1
+#define PTRS_PER_PUD	1
 #else /* __s390x__ */
-# define PTRS_PER_PTE    512
-# define PTRS_PER_PMD    1024
-# define PTRS_PER_PUD	1
-# define PTRS_PER_PGD    2048
+#define PTRS_PER_PMD	2048
+#define PTRS_PER_PUD	2048
 #endif /* __s390x__ */
+#define PTRS_PER_PGD	2048
 
 #define FIRST_USER_ADDRESS  0
 
@@ -127,8 +125,9 @@ extern char empty_zero_page[PAGE_SIZE];
  * mapping. This needs to be calculated at compile time since the size of the
  * VMEM_MAP is static but the size of struct page can change.
  */
-#define VMEM_MAX_PHYS	min(VMALLOC_START, ((VMEM_MAP_END - VMALLOC_END) / \
-			  sizeof(struct page) * PAGE_SIZE) & ~((16 << 20) - 1))
+#define VMEM_MAX_PAGES	((VMEM_MAP_END - VMALLOC_END) / sizeof(struct page))
+#define VMEM_MAX_PFN	min(VMALLOC_START >> PAGE_SHIFT, VMEM_MAX_PAGES)
+#define VMEM_MAX_PHYS	((VMEM_MAX_PFN << PAGE_SHIFT) & ~((16 << 20) - 1))
 #define VMEM_MAP	((struct page *) VMALLOC_END)
 
 /*
@@ -375,24 +374,6 @@ extern char empty_zero_page[PAGE_SIZE];
 # define PxD_SHADOW_SHIFT	2
 #endif /* __s390x__ */
 
-static inline struct page *get_shadow_page(struct page *page)
-{
-	if (s390_noexec && page->index)
-		return virt_to_page((void *)(addr_t) page->index);
-	return NULL;
-}
-
-static inline void *get_shadow_pte(void *table)
-{
-	unsigned long addr, offset;
-	struct page *page;
-
-	addr = (unsigned long) table;
-	offset = addr & (PAGE_SIZE - 1);
-	page = virt_to_page((void *)(addr ^ offset));
-	return (void *)(addr_t)(page->index ? (page->index | offset) : 0UL);
-}
-
 static inline void *get_shadow_table(void *table)
 {
 	unsigned long addr, offset;
@@ -410,17 +391,16 @@ static inline void *get_shadow_table(void *table)
  * hook is made available.
  */
 static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
-			      pte_t *pteptr, pte_t pteval)
+			      pte_t *ptep, pte_t entry)
 {
-	pte_t *shadow_pte = get_shadow_pte(pteptr);
-
-	*pteptr = pteval;
-	if (shadow_pte) {
-		if (!(pte_val(pteval) & _PAGE_INVALID) &&
-		    (pte_val(pteval) & _PAGE_SWX))
-			pte_val(*shadow_pte) = pte_val(pteval) | _PAGE_RO;
+	*ptep = entry;
+	if (mm->context.noexec) {
+		if (!(pte_val(entry) & _PAGE_INVALID) &&
+		    (pte_val(entry) & _PAGE_SWX))
+			pte_val(entry) |= _PAGE_RO;
 		else
-			pte_val(*shadow_pte) = _PAGE_TYPE_EMPTY;
+			pte_val(entry) = _PAGE_TYPE_EMPTY;
+		ptep[PTRS_PER_PTE] = entry;
 	}
 }
 
@@ -439,24 +419,58 @@ static inline int pud_bad(pud_t pud)	 { return 0; }
 
 #else /* __s390x__ */
 
-static inline int pgd_present(pgd_t pgd) { return 1; }
-static inline int pgd_none(pgd_t pgd)	 { return 0; }
-static inline int pgd_bad(pgd_t pgd)	 { return 0; }
+static inline int pgd_present(pgd_t pgd)
+{
+	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R2)
+		return 1;
+	return (pgd_val(pgd) & _REGION_ENTRY_ORIGIN) != 0UL;
+}
+
+static inline int pgd_none(pgd_t pgd)
+{
+	if ((pgd_val(pgd) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R2)
+		return 0;
+	return (pgd_val(pgd) & _REGION_ENTRY_INV) != 0UL;
+}
+
+static inline int pgd_bad(pgd_t pgd)
+{
+	/*
+	 * With dynamic page table levels the pgd can be a region table
+	 * entry or a segment table entry. Check for the bit that are
+	 * invalid for either table entry.
+	 */
+	unsigned long mask =
+		~_SEGMENT_ENTRY_ORIGIN & ~_REGION_ENTRY_INV &
+		~_REGION_ENTRY_TYPE_MASK & ~_REGION_ENTRY_LENGTH;
+	return (pgd_val(pgd) & mask) != 0;
+}
 
 static inline int pud_present(pud_t pud)
 {
+	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R3)
+		return 1;
 	return (pud_val(pud) & _REGION_ENTRY_ORIGIN) != 0UL;
 }
 
 static inline int pud_none(pud_t pud)
 {
+	if ((pud_val(pud) & _REGION_ENTRY_TYPE_MASK) < _REGION_ENTRY_TYPE_R3)
+		return 0;
 	return (pud_val(pud) & _REGION_ENTRY_INV) != 0UL;
 }
 
 static inline int pud_bad(pud_t pud)
 {
-	unsigned long mask = ~_REGION_ENTRY_ORIGIN & ~_REGION_ENTRY_INV;
-	return (pud_val(pud) & mask) != _REGION3_ENTRY;
+	/*
+	 * With dynamic page table levels the pud can be a region table
+	 * entry or a segment table entry. Check for the bit that are
+	 * invalid for either table entry.
+	 */
+	unsigned long mask =
+		~_SEGMENT_ENTRY_ORIGIN & ~_REGION_ENTRY_INV &
+		~_REGION_ENTRY_TYPE_MASK & ~_REGION_ENTRY_LENGTH;
+	return (pud_val(pud) & mask) != 0;
 }
 
 #endif /* __s390x__ */
@@ -535,24 +549,30 @@ static inline int pte_young(pte_t pte)
 #define pgd_clear(pgd)		do { } while (0)
 #define pud_clear(pud)		do { } while (0)
 
-static inline void pmd_clear_kernel(pmd_t * pmdp)
+#else /* __s390x__ */
+
+static inline void pgd_clear_kernel(pgd_t * pgd)
 {
-	pmd_val(pmdp[0]) = _SEGMENT_ENTRY_EMPTY;
-	pmd_val(pmdp[1]) = _SEGMENT_ENTRY_EMPTY;
-	pmd_val(pmdp[2]) = _SEGMENT_ENTRY_EMPTY;
-	pmd_val(pmdp[3]) = _SEGMENT_ENTRY_EMPTY;
+	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R2)
+		pgd_val(*pgd) = _REGION2_ENTRY_EMPTY;
 }
 
-#else /* __s390x__ */
+static inline void pgd_clear(pgd_t * pgd)
+{
+	pgd_t *shadow = get_shadow_table(pgd);
 
-#define pgd_clear(pgd)		do { } while (0)
+	pgd_clear_kernel(pgd);
+	if (shadow)
+		pgd_clear_kernel(shadow);
+}
 
 static inline void pud_clear_kernel(pud_t *pud)
 {
-	pud_val(*pud) = _REGION3_ENTRY_EMPTY;
+	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
+		pud_val(*pud) = _REGION3_ENTRY_EMPTY;
 }
 
-static inline void pud_clear(pud_t * pud)
+static inline void pud_clear(pud_t *pud)
 {
 	pud_t *shadow = get_shadow_table(pud);
 
@@ -561,30 +581,27 @@ static inline void pud_clear(pud_t * pud)
 		pud_clear_kernel(shadow);
 }
 
+#endif /* __s390x__ */
+
 static inline void pmd_clear_kernel(pmd_t * pmdp)
 {
 	pmd_val(*pmdp) = _SEGMENT_ENTRY_EMPTY;
-	pmd_val1(*pmdp) = _SEGMENT_ENTRY_EMPTY;
 }
 
-#endif /* __s390x__ */
-
-static inline void pmd_clear(pmd_t * pmdp)
+static inline void pmd_clear(pmd_t *pmd)
 {
-	pmd_t *shadow_pmd = get_shadow_table(pmdp);
+	pmd_t *shadow = get_shadow_table(pmd);
 
-	pmd_clear_kernel(pmdp);
-	if (shadow_pmd)
-		pmd_clear_kernel(shadow_pmd);
+	pmd_clear_kernel(pmd);
+	if (shadow)
+		pmd_clear_kernel(shadow);
 }
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	pte_t *shadow_pte = get_shadow_pte(ptep);
-
 	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
-	if (shadow_pte)
-		pte_val(*shadow_pte) = _PAGE_TYPE_EMPTY;
+	if (mm->context.noexec)
+		pte_val(ptep[PTRS_PER_PTE]) = _PAGE_TYPE_EMPTY;
 }
 
 /*
@@ -665,7 +682,7 @@ static inline void __ptep_ipte(unsigned long address, pte_t *ptep)
 {
 	if (!(pte_val(*ptep) & _PAGE_INVALID)) {
 #ifndef __s390x__
-		/* S390 has 1mb segments, we are emulating 4MB segments */
+		/* pto must point to the start of the segment table */
 		pte_t *pto = (pte_t *) (((unsigned long) ptep) & 0x7ffffc00);
 #else
 		/* ipte in zarch mode can do the math */
@@ -679,12 +696,12 @@ static inline void __ptep_ipte(unsigned long address, pte_t *ptep)
 	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
 }
 
-static inline void ptep_invalidate(unsigned long address, pte_t *ptep)
+static inline void ptep_invalidate(struct mm_struct *mm,
+				   unsigned long address, pte_t *ptep)
 {
 	__ptep_ipte(address, ptep);
-	ptep = get_shadow_pte(ptep);
-	if (ptep)
-		__ptep_ipte(address, ptep);
+	if (mm->context.noexec)
+		__ptep_ipte(address, ptep + PTRS_PER_PTE);
 }
 
 /*
@@ -706,7 +723,7 @@ static inline void ptep_invalidate(unsigned long address, pte_t *ptep)
 	pte_t __pte = *(__ptep);					\
 	if (atomic_read(&(__mm)->mm_users) > 1 ||			\
 	    (__mm) != current->active_mm)				\
-		ptep_invalidate(__address, __ptep);			\
+		ptep_invalidate(__mm, __address, __ptep);		\
 	else								\
 		pte_clear((__mm), (__address), (__ptep));		\
 	__pte;								\
@@ -717,7 +734,7 @@ static inline pte_t ptep_clear_flush(struct vm_area_struct *vma,
 				     unsigned long address, pte_t *ptep)
 {
 	pte_t pte = *ptep;
-	ptep_invalidate(address, ptep);
+	ptep_invalidate(vma->vm_mm, address, ptep);
 	return pte;
 }
 
@@ -738,7 +755,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	if (full)
 		pte_clear(mm, addr, ptep);
 	else
-		ptep_invalidate(addr, ptep);
+		ptep_invalidate(mm, addr, ptep);
 	return pte;
 }
 
@@ -749,7 +766,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 	if (pte_write(__pte)) {						\
 		if (atomic_read(&(__mm)->mm_users) > 1 ||		\
 		    (__mm) != current->active_mm)			\
-			ptep_invalidate(__addr, __ptep);		\
+			ptep_invalidate(__mm, __addr, __ptep);		\
 		set_pte_at(__mm, __addr, __ptep, pte_wrprotect(__pte));	\
 	}								\
 })
@@ -759,7 +776,7 @@ static inline pte_t ptep_get_and_clear_full(struct mm_struct *mm,
 ({									\
 	int __changed = !pte_same(*(__ptep), __entry);			\
 	if (__changed) {						\
-		ptep_invalidate(__addr, __ptep);			\
+		ptep_invalidate((__vma)->vm_mm, __addr, __ptep);	\
 		set_pte_at((__vma)->vm_mm, __addr, __ptep, __entry);	\
 	}								\
 	__changed;							\
@@ -840,13 +857,21 @@ static inline pte_t mk_pte(struct page *page, pgprot_t pgprot)
 
 #define pmd_deref(pmd) (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN)
 #define pud_deref(pud) (pud_val(pud) & _REGION_ENTRY_ORIGIN)
-#define pgd_deref(pgd) ({ BUG(); 0UL; })
+#define pgd_deref(pgd) (pgd_val(pgd) & _REGION_ENTRY_ORIGIN)
 
-#define pud_offset(pgd, address) ((pud_t *) pgd)
+static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
+{
+	pud_t *pud = (pud_t *) pgd;
+	if ((pgd_val(*pgd) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R2)
+		pud = (pud_t *) pgd_deref(*pgd);
+	return pud  + pud_index(address);
+}
 
 static inline pmd_t *pmd_offset(pud_t *pud, unsigned long address)
 {
-	pmd_t *pmd = (pmd_t *) pud_deref(*pud);
+	pmd_t *pmd = (pmd_t *) pud;
+	if ((pud_val(*pud) & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3)
+		pmd = (pmd_t *) pud_deref(*pud);
 	return pmd + pmd_index(address);
 }
 
diff --git a/include/asm-s390/processor.h b/include/asm-s390/processor.h
index e878563..51d8891 100644
--- a/include/asm-s390/processor.h
+++ b/include/asm-s390/processor.h
@@ -64,24 +64,29 @@ extern int get_cpu_capability(unsigned int *);
  */
 #ifndef __s390x__
 
-# define TASK_SIZE		(0x80000000UL)
-# define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
-# define DEFAULT_TASK_SIZE	(0x80000000UL)
+#define TASK_SIZE		(1UL << 31)
+#define TASK_UNMAPPED_BASE	(1UL << 30)
 
 #else /* __s390x__ */
 
-# define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk, TIF_31BIT) ? \
-					(0x80000000UL) : (0x40000000000UL))
-# define TASK_SIZE		TASK_SIZE_OF(current)
-# define TASK_UNMAPPED_BASE	(TASK_SIZE / 2)
-# define DEFAULT_TASK_SIZE	(0x40000000000UL)
+#define TASK_SIZE_OF(tsk)	(test_tsk_thread_flag(tsk,TIF_31BIT) ? \
+					(1UL << 31) : (1UL << 53))
+#define TASK_UNMAPPED_BASE	(test_thread_flag(TIF_31BIT) ? \
+					(1UL << 30) : (1UL << 41))
+#define TASK_SIZE		TASK_SIZE_OF(current)
 
 #endif /* __s390x__ */
 
 #ifdef __KERNEL__
 
-#define STACK_TOP		TASK_SIZE
-#define STACK_TOP_MAX		DEFAULT_TASK_SIZE
+#ifndef __s390x__
+#define STACK_TOP		(1UL << 31)
+#define STACK_TOP_MAX		(1UL << 31)
+#else /* __s390x__ */
+#define STACK_TOP		(1UL << (test_thread_flag(TIF_31BIT) ? 31:42))
+#define STACK_TOP_MAX		(1UL << 42)
+#endif /* __s390x__ */
+
 
 #endif
 
@@ -138,8 +143,6 @@ struct stack_frame {
 /*
  * Do necessary setup to start up a new thread.
  */
-#ifndef __s390x__
-
 #define start_thread(regs, new_psw, new_stackp) do {            \
 	set_fs(USER_DS);					\
 	regs->psw.mask	= psw_user_bits;			\
@@ -147,24 +150,6 @@ struct stack_frame {
         regs->gprs[15]  = new_stackp ;                          \
 } while (0)
 
-#else /* __s390x__ */
-
-#define start_thread(regs, new_psw, new_stackp) do {            \
-	set_fs(USER_DS);					\
-	regs->psw.mask	= psw_user_bits;			\
-        regs->psw.addr  = new_psw;                              \
-        regs->gprs[15]  = new_stackp;                           \
-} while (0)
-
-#define start_thread31(regs, new_psw, new_stackp) do {          \
-	set_fs(USER_DS);					\
-	regs->psw.mask	= psw_user32_bits;			\
-        regs->psw.addr  = new_psw;                              \
-        regs->gprs[15]  = new_stackp;                           \
-} while (0)
-
-#endif /* __s390x__ */
-
 /* Forward declaration, a strange C thing */
 struct task_struct;
 struct mm_struct;
diff --git a/include/asm-s390/tlb.h b/include/asm-s390/tlb.h
index 3c8177f..3d8a96d 100644
--- a/include/asm-s390/tlb.h
+++ b/include/asm-s390/tlb.h
@@ -38,7 +38,7 @@ struct mmu_gather {
 	struct mm_struct *mm;
 	unsigned int fullmm;
 	unsigned int nr_ptes;
-	unsigned int nr_pmds;
+	unsigned int nr_pxds;
 	void *array[TLB_NR_PTRS];
 };
 
@@ -53,7 +53,7 @@ static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
 	tlb->fullmm = full_mm_flush || (num_online_cpus() == 1) ||
 		(atomic_read(&mm->mm_users) <= 1 && mm == current->active_mm);
 	tlb->nr_ptes = 0;
-	tlb->nr_pmds = TLB_NR_PTRS;
+	tlb->nr_pxds = TLB_NR_PTRS;
 	if (tlb->fullmm)
 		__tlb_flush_mm(mm);
 	return tlb;
@@ -62,12 +62,13 @@ static inline struct mmu_gather *tlb_gather_mmu(struct mm_struct *mm,
 static inline void tlb_flush_mmu(struct mmu_gather *tlb,
 				 unsigned long start, unsigned long end)
 {
-	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pmds < TLB_NR_PTRS))
+	if (!tlb->fullmm && (tlb->nr_ptes > 0 || tlb->nr_pxds < TLB_NR_PTRS))
 		__tlb_flush_mm(tlb->mm);
 	while (tlb->nr_ptes > 0)
 		pte_free(tlb->mm, tlb->array[--tlb->nr_ptes]);
-	while (tlb->nr_pmds < TLB_NR_PTRS)
-		pmd_free(tlb->mm, (pmd_t *) tlb->array[tlb->nr_pmds++]);
+	while (tlb->nr_pxds < TLB_NR_PTRS)
+		/* pgd_free frees the pointer as region or segment table */
+		pgd_free(tlb->mm, tlb->array[tlb->nr_pxds++]);
 }
 
 static inline void tlb_finish_mmu(struct mmu_gather *tlb,
@@ -95,33 +96,57 @@ static inline void tlb_remove_page(struct mmu_gather *tlb, struct page *page)
  * pte_free_tlb frees a pte table and clears the CRSTE for the
  * page table from the tlb.
  */
-static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t page)
+static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte)
 {
 	if (!tlb->fullmm) {
-		tlb->array[tlb->nr_ptes++] = page;
-		if (tlb->nr_ptes >= tlb->nr_pmds)
+		tlb->array[tlb->nr_ptes++] = pte;
+		if (tlb->nr_ptes >= tlb->nr_pxds)
 			tlb_flush_mmu(tlb, 0, 0);
 	} else
-		pte_free(tlb->mm, page);
+		pte_free(tlb->mm, pte);
 }
 
 /*
  * pmd_free_tlb frees a pmd table and clears the CRSTE for the
  * segment table entry from the tlb.
+ * If the mm uses a two level page table the single pmd is freed
+ * as the pgd. pmd_free_tlb checks the asce_limit against 2GB
+ * to avoid the double free of the pmd in this case.
  */
 static inline void pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
 #ifdef __s390x__
+	if (tlb->mm->context.asce_limit <= (1UL << 31))
+		return;
 	if (!tlb->fullmm) {
-		tlb->array[--tlb->nr_pmds] = (struct page *) pmd;
-		if (tlb->nr_ptes >= tlb->nr_pmds)
+		tlb->array[--tlb->nr_pxds] = pmd;
+		if (tlb->nr_ptes >= tlb->nr_pxds)
 			tlb_flush_mmu(tlb, 0, 0);
 	} else
 		pmd_free(tlb->mm, pmd);
 #endif
 }
 
-#define pud_free_tlb(tlb, pud)			do { } while (0)
+/*
+ * pud_free_tlb frees a pud table and clears the CRSTE for the
+ * region third table entry from the tlb.
+ * If the mm uses a three level page table the single pud is freed
+ * as the pgd. pud_free_tlb checks the asce_limit against 4TB
+ * to avoid the double free of the pud in this case.
+ */
+static inline void pud_free_tlb(struct mmu_gather *tlb, pud_t *pud)
+{
+#ifdef __s390x__
+	if (tlb->mm->context.asce_limit <= (1UL << 42))
+		return;
+	if (!tlb->fullmm) {
+		tlb->array[--tlb->nr_pxds] = pud;
+		if (tlb->nr_ptes >= tlb->nr_pxds)
+			tlb_flush_mmu(tlb, 0, 0);
+	} else
+		pud_free(tlb->mm, pud);
+#endif
+}
 
 #define tlb_start_vma(tlb, vma)			do { } while (0)
 #define tlb_end_vma(tlb, vma)			do { } while (0)
diff --git a/include/asm-s390/tlbflush.h b/include/asm-s390/tlbflush.h
index 70fa5ae..35fb4f9 100644
--- a/include/asm-s390/tlbflush.h
+++ b/include/asm-s390/tlbflush.h
@@ -61,11 +61,12 @@ static inline void __tlb_flush_mm(struct mm_struct * mm)
 	 * only ran on the local cpu.
 	 */
 	if (MACHINE_HAS_IDTE) {
-		pgd_t *shadow = get_shadow_table(mm->pgd);
-
-		if (shadow)
-			__tlb_flush_idte((unsigned long) shadow | mm->context);
-		__tlb_flush_idte((unsigned long) mm->pgd | mm->context);
+		if (mm->context.noexec)
+			__tlb_flush_idte((unsigned long)
+					 get_shadow_table(mm->pgd) |
+					 mm->context.asce_bits);
+		__tlb_flush_idte((unsigned long) mm->pgd |
+				 mm->context.asce_bits);
 		return;
 	}
 	preempt_disable();
diff --git a/include/asm-s390/unistd.h b/include/asm-s390/unistd.h
index f04acb2..583da80 100644
--- a/include/asm-s390/unistd.h
+++ b/include/asm-s390/unistd.h
@@ -256,7 +256,10 @@
 #define __NR_signalfd		316
 #define __NR_timerfd		317
 #define __NR_eventfd		318
-#define NR_syscalls 319
+#define __NR_timerfd_create	319
+#define __NR_timerfd_settime	320
+#define __NR_timerfd_gettime	321
+#define NR_syscalls 322
 
 /* 
  * There are some system calls that are not present on 64 bit, some


