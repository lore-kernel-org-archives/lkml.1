Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYK0KRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYK0KRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752461AbYK0KRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:17:03 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:40723 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYK0KQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:16:58 -0500
Subject: [GIT PULL] s390 patches for 2.6.28-rc6
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.or
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 27 Nov 2008 11:16:09 +0100
Message-Id: <1227780969.20571.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the presumably last set of updates for 2.6.28:

Christian Borntraeger (2):
      [S390] fix/cleanup sched_clock
      [S390] pgtable.h: Fix oops in unmap_vmas for KVM processes

Heiko Carstens (1):
      [S390] Fix alignment of initial kernel stack.

Martin Schwidefsky (2):
      [S390] fix system call parameter functions.
      [S390] Update default configuration.

 arch/s390/defconfig              |   74 ++++++++++++++++++++++++++------------
 arch/s390/include/asm/pgtable.h  |    2 -
 arch/s390/include/asm/ptrace.h   |    2 +-
 arch/s390/include/asm/syscall.h  |   28 ++++++++------
 arch/s390/kernel/asm-offsets.c   |    2 +-
 arch/s390/kernel/compat_signal.c |    2 +-
 arch/s390/kernel/entry.S         |   21 ++++++-----
 arch/s390/kernel/entry64.S       |   23 +++++-------
 arch/s390/kernel/init_task.c     |    2 +-
 arch/s390/kernel/ptrace.c        |    2 +-
 arch/s390/kernel/signal.c        |    6 ++--
 arch/s390/kernel/time.c          |   13 +++----
 arch/s390/kernel/vmlinux.lds.S   |    3 +-
 13 files changed, 103 insertions(+), 77 deletions(-)

diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 9b0bc2c..a0e748d 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.27-rc4
-# Thu Aug 21 19:43:29 2008
+# Linux kernel version: 2.6.28-rc6
+# Thu Nov 27 11:00:49 2008
 #
 CONFIG_SCHED_MC=y
 CONFIG_MMU=y
@@ -45,6 +45,7 @@ CONFIG_LOG_BUF_SHIFT=17
 CONFIG_CGROUPS=y
 # CONFIG_CGROUP_DEBUG is not set
 CONFIG_CGROUP_NS=y
+# CONFIG_CGROUP_FREEZER is not set
 # CONFIG_CGROUP_DEVICE is not set
 # CONFIG_CPUSETS is not set
 CONFIG_GROUP_SCHED=y
@@ -84,6 +85,7 @@ CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
+CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
 CONFIG_SLAB=y
 # CONFIG_SLUB is not set
@@ -92,16 +94,10 @@ CONFIG_SLAB=y
 # CONFIG_MARKERS is not set
 CONFIG_HAVE_OPROFILE=y
 CONFIG_KPROBES=y
-# CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS is not set
 CONFIG_KRETPROBES=y
-# CONFIG_HAVE_IOREMAP_PROT is not set
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
-# CONFIG_HAVE_ARCH_TRACEHOOK is not set
-# CONFIG_HAVE_DMA_ATTRS is not set
-# CONFIG_USE_GENERIC_SMP_HELPERS is not set
-# CONFIG_HAVE_CLK is not set
-CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -135,6 +131,7 @@ CONFIG_DEFAULT_DEADLINE=y
 CONFIG_DEFAULT_IOSCHED="deadline"
 CONFIG_PREEMPT_NOTIFIERS=y
 CONFIG_CLASSIC_RCU=y
+# CONFIG_FREEZER is not set
 
 #
 # Base setup
@@ -189,7 +186,6 @@ CONFIG_SELECT_MEMORY_MODEL=y
 CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_SPARSEMEM=y
 CONFIG_HAVE_MEMORY_PRESENT=y
-# CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPARSEMEM_EXTREME=y
 CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
 CONFIG_SPARSEMEM_VMEMMAP=y
@@ -200,9 +196,11 @@ CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_MIGRATION=y
 CONFIG_RESOURCES_64BIT=y
+CONFIG_PHYS_ADDR_T_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
 
 #
 # I/O subsystem configuration
@@ -220,6 +218,8 @@ CONFIG_IPL=y
 CONFIG_IPL_VM=y
 CONFIG_BINFMT_ELF=y
 CONFIG_COMPAT_BINFMT_ELF=y
+# CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
+# CONFIG_HAVE_AOUT is not set
 CONFIG_BINFMT_MISC=m
 CONFIG_FORCE_MAX_ZONEORDER=9
 # CONFIG_PROCESS_DEBUG is not set
@@ -255,7 +255,7 @@ CONFIG_XFRM=y
 # CONFIG_XFRM_STATISTICS is not set
 CONFIG_NET_KEY=y
 # CONFIG_NET_KEY_MIGRATE is not set
-CONFIG_IUCV=m
+CONFIG_IUCV=y
 CONFIG_AFIUCV=m
 CONFIG_INET=y
 CONFIG_IP_MULTICAST=y
@@ -282,7 +282,6 @@ CONFIG_INET_TCP_DIAG=y
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_TCP_MD5SIG is not set
-# CONFIG_IP_VS is not set
 CONFIG_IPV6=y
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
@@ -331,10 +330,12 @@ CONFIG_NF_CONNTRACK=m
 # CONFIG_NF_CONNTRACK_TFTP is not set
 # CONFIG_NF_CT_NETLINK is not set
 # CONFIG_NETFILTER_XTABLES is not set
+# CONFIG_IP_VS is not set
 
 #
 # IP: Netfilter Configuration
 #
+# CONFIG_NF_DEFRAG_IPV4 is not set
 # CONFIG_NF_CONNTRACK_IPV4 is not set
 # CONFIG_IP_NF_QUEUE is not set
 # CONFIG_IP_NF_IPTABLES is not set
@@ -374,6 +375,7 @@ CONFIG_NET_SCH_CBQ=m
 # CONFIG_NET_SCH_HTB is not set
 # CONFIG_NET_SCH_HFSC is not set
 CONFIG_NET_SCH_PRIO=m
+CONFIG_NET_SCH_MULTIQ=y
 CONFIG_NET_SCH_RED=m
 CONFIG_NET_SCH_SFQ=m
 CONFIG_NET_SCH_TEQL=m
@@ -406,6 +408,7 @@ CONFIG_NET_ACT_POLICE=y
 CONFIG_NET_ACT_NAT=m
 # CONFIG_NET_ACT_PEDIT is not set
 # CONFIG_NET_ACT_SIMP is not set
+# CONFIG_NET_ACT_SKBEDIT is not set
 # CONFIG_NET_CLS_IND is not set
 CONFIG_NET_SCH_FIFO=y
 
@@ -424,6 +427,7 @@ CONFIG_CAN_BCM=m
 CONFIG_CAN_VCAN=m
 # CONFIG_CAN_DEBUG_DEVICES is not set
 # CONFIG_AF_RXRPC is not set
+# CONFIG_PHONET is not set
 # CONFIG_RFKILL is not set
 # CONFIG_NET_9P is not set
 # CONFIG_PCMCIA is not set
@@ -473,7 +477,7 @@ CONFIG_VIRTIO_BLK=m
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
-# CONFIG_HAVE_IDE is not set
+# CONFIG_C2PORT is not set
 
 #
 # SCSI device support
@@ -525,6 +529,7 @@ CONFIG_SCSI_DH_EMC=m
 CONFIG_SCSI_DH_ALUA=m
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=y
+CONFIG_MD_AUTODETECT=y
 CONFIG_MD_LINEAR=m
 CONFIG_MD_RAID0=m
 CONFIG_MD_RAID1=m
@@ -555,6 +560,9 @@ CONFIG_NET_ETHERNET=y
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
 # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
 CONFIG_NETDEV_1000=y
 CONFIG_NETDEV_10000=y
 # CONFIG_TR is not set
@@ -632,13 +640,12 @@ CONFIG_S390_VMUR=m
 # CONFIG_THERMAL is not set
 # CONFIG_THERMAL_HWMON is not set
 # CONFIG_WATCHDOG is not set
-
-#
-# Sonics Silicon Backplane
-#
+# CONFIG_REGULATOR is not set
 # CONFIG_MEMSTICK is not set
 # CONFIG_NEW_LEDS is not set
 CONFIG_ACCESSIBILITY=y
+# CONFIG_STAGING is not set
+CONFIG_STAGING_EXCLUDE_BUILD=y
 
 #
 # File systems
@@ -650,13 +657,14 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 # CONFIG_EXT3_FS_POSIX_ACL is not set
 # CONFIG_EXT3_FS_SECURITY is not set
-# CONFIG_EXT4DEV_FS is not set
+# CONFIG_EXT4_FS is not set
 CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
@@ -688,6 +696,7 @@ CONFIG_GENERIC_ACL=y
 CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
@@ -728,6 +737,7 @@ CONFIG_LOCKD_V4=y
 CONFIG_EXPORTFS=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
+# CONFIG_SUNRPC_REGISTER_V4 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -800,12 +810,24 @@ CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
+
+#
+# Tracers
+#
+# CONFIG_IRQSOFF_TRACER is not set
+# CONFIG_PREEMPT_TRACER is not set
+# CONFIG_SCHED_TRACER is not set
+# CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
+# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 CONFIG_SAMPLES=y
 # CONFIG_SAMPLE_KOBJECT is not set
 # CONFIG_SAMPLE_KPROBES is not set
@@ -816,16 +838,19 @@ CONFIG_SAMPLES=y
 #
 # CONFIG_KEYS is not set
 # CONFIG_SECURITY is not set
+# CONFIG_SECURITYFS is not set
 # CONFIG_SECURITY_FILE_CAPABILITIES is not set
 CONFIG_CRYPTO=y
 
 #
 # Crypto core or helper
 #
+CONFIG_CRYPTO_FIPS=y
 CONFIG_CRYPTO_ALGAPI=y
-CONFIG_CRYPTO_AEAD=m
+CONFIG_CRYPTO_AEAD=y
 CONFIG_CRYPTO_BLKCIPHER=y
-CONFIG_CRYPTO_HASH=m
+CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_RNG=y
 CONFIG_CRYPTO_MANAGER=y
 CONFIG_CRYPTO_GF128MUL=m
 # CONFIG_CRYPTO_NULL is not set
@@ -877,7 +902,7 @@ CONFIG_CRYPTO_SHA1=m
 #
 # Ciphers
 #
-# CONFIG_CRYPTO_AES is not set
+CONFIG_CRYPTO_AES=m
 # CONFIG_CRYPTO_ANUBIS is not set
 # CONFIG_CRYPTO_ARC4 is not set
 # CONFIG_CRYPTO_BLOWFISH is not set
@@ -898,6 +923,11 @@ CONFIG_CRYPTO_SEED=m
 #
 # CONFIG_CRYPTO_DEFLATE is not set
 CONFIG_CRYPTO_LZO=m
+
+#
+# Random Number Generation
+#
+CONFIG_CRYPTO_ANSI_CPRNG=m
 CONFIG_CRYPTO_HW=y
 CONFIG_ZCRYPT=m
 # CONFIG_ZCRYPT_MONOLITHIC is not set
@@ -912,8 +942,6 @@ CONFIG_S390_PRNG=m
 # Library routines
 #
 CONFIG_BITREVERSE=m
-# CONFIG_GENERIC_FIND_FIRST_BIT is not set
-# CONFIG_GENERIC_FIND_NEXT_BIT is not set
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
 CONFIG_CRC_T10DIF=y
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 7fc7613..5caddd4 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -679,8 +679,6 @@ static inline void pmd_clear(pmd_t *pmd)
 
 static inline void pte_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
-	if (mm->context.has_pgste)
-		ptep_rcp_copy(ptep);
 	pte_val(*ptep) = _PAGE_TYPE_EMPTY;
 	if (mm->context.noexec)
 		pte_val(ptep[PTRS_PER_PTE]) = _PAGE_TYPE_EMPTY;
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index a7226f8..fb0ca47 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -321,8 +321,8 @@ struct pt_regs
 	psw_t psw;
 	unsigned long gprs[NUM_GPRS];
 	unsigned long orig_gpr2;
+	unsigned short svcnr;
 	unsigned short ilc;
-	unsigned short trap;
 };
 #endif
 
diff --git a/arch/s390/include/asm/syscall.h b/arch/s390/include/asm/syscall.h
index 6e62397..2429b87 100644
--- a/arch/s390/include/asm/syscall.h
+++ b/arch/s390/include/asm/syscall.h
@@ -17,9 +17,7 @@
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	if (regs->trap != __LC_SVC_OLD_PSW)
-		return -1;
-	return regs->gprs[2];
+	return regs->svcnr ? regs->svcnr : -1;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
@@ -52,18 +50,20 @@ static inline void syscall_get_arguments(struct task_struct *task,
 					 unsigned int i, unsigned int n,
 					 unsigned long *args)
 {
+	unsigned long mask = -1UL;
+
 	BUG_ON(i + n > 6);
 #ifdef CONFIG_COMPAT
-	if (test_tsk_thread_flag(task, TIF_31BIT)) {
-		if (i + n == 6)
-			args[--n] = (u32) regs->args[0];
-		while (n-- > 0)
-			args[n] = (u32) regs->gprs[2 + i + n];
-	}
+	if (test_tsk_thread_flag(task, TIF_31BIT))
+		mask = 0xffffffff;
 #endif
 	if (i + n == 6)
-		args[--n] = regs->args[0];
-	memcpy(args, &regs->gprs[2 + i], n * sizeof(args[0]));
+		args[--n] = regs->args[0] & mask;
+	while (n-- > 0)
+		if (i + n > 0)
+			args[n] = regs->gprs[2 + i + n] & mask;
+	if (i == 0)
+		args[0] = regs->orig_gpr2 & mask;
 }
 
 static inline void syscall_set_arguments(struct task_struct *task,
@@ -74,7 +74,11 @@ static inline void syscall_set_arguments(struct task_struct *task,
 	BUG_ON(i + n > 6);
 	if (i + n == 6)
 		regs->args[0] = args[--n];
-	memcpy(&regs->gprs[2 + i], args, n * sizeof(args[0]));
+	while (n-- > 0)
+		if (i + n > 0)
+			regs->gprs[2 + i + n] = args[n];
+	if (i == 0)
+		regs->orig_gpr2 = args[0];
 }
 
 #endif	/* _ASM_SYSCALL_H */
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index fa28eca..3d144e6 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -32,7 +32,7 @@ int main(void)
 	DEFINE(__PT_GPRS, offsetof(struct pt_regs, gprs));
 	DEFINE(__PT_ORIG_GPR2, offsetof(struct pt_regs, orig_gpr2));
 	DEFINE(__PT_ILC, offsetof(struct pt_regs, ilc));
-	DEFINE(__PT_TRAP, offsetof(struct pt_regs, trap));
+	DEFINE(__PT_SVCNR, offsetof(struct pt_regs, svcnr));
 	DEFINE(__PT_SIZE, sizeof(struct pt_regs));
 	BLANK();
 	DEFINE(__SF_BACKCHAIN, offsetof(struct stack_frame, back_chain));
diff --git a/arch/s390/kernel/compat_signal.c b/arch/s390/kernel/compat_signal.c
index c7f02e7..b537cb0 100644
--- a/arch/s390/kernel/compat_signal.c
+++ b/arch/s390/kernel/compat_signal.c
@@ -340,7 +340,7 @@ static int restore_sigregs32(struct pt_regs *regs,_sigregs32 __user *sregs)
 		return err;
 
 	restore_fp_regs(&current->thread.fp_regs);
-	regs->trap = -1;	/* disable syscall checks */
+	regs->svcnr = 0;	/* disable syscall checks */
 	return 0;
 }
 
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 08844fc..198ea18 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -46,7 +46,7 @@ SP_R14	     =	STACK_FRAME_OVERHEAD + __PT_GPRS + 56
 SP_R15	     =	STACK_FRAME_OVERHEAD + __PT_GPRS + 60
 SP_ORIG_R2   =	STACK_FRAME_OVERHEAD + __PT_ORIG_GPR2
 SP_ILC	     =	STACK_FRAME_OVERHEAD + __PT_ILC
-SP_TRAP      =	STACK_FRAME_OVERHEAD + __PT_TRAP
+SP_SVCNR     =	STACK_FRAME_OVERHEAD + __PT_SVCNR
 SP_SIZE      =	STACK_FRAME_OVERHEAD + __PT_SIZE
 
 _TIF_WORK_SVC = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
@@ -183,11 +183,10 @@ STACK_SIZE  = 1 << STACK_SHIFT
 	.macro	CREATE_STACK_FRAME psworg,savearea
 	s	%r15,BASED(.Lc_spsize)	# make room for registers & psw
 	mvc	SP_PSW(8,%r15),0(%r12)	# move user PSW to stack
-	la	%r12,\psworg
 	st	%r2,SP_ORIG_R2(%r15)	# store original content of gpr 2
-	icm	%r12,12,__LC_SVC_ILC
+	icm	%r12,3,__LC_SVC_ILC
 	stm	%r0,%r11,SP_R0(%r15)	# store gprs %r0-%r11 to kernel stack
-	st	%r12,SP_ILC(%r15)
+	st	%r12,SP_SVCNR(%r15)
 	mvc	SP_R12(16,%r15),\savearea # move %r12-%r15 to stack
 	la	%r12,0
 	st	%r12,__SF_BACKCHAIN(%r15)	# clear back chain
@@ -264,16 +263,17 @@ sysc_update:
 #endif
 sysc_do_svc:
 	l	%r9,__LC_THREAD_INFO	# load pointer to thread_info struct
-	sla	%r7,2			# *4 and test for svc 0
+	ltr	%r7,%r7			# test for svc 0
 	bnz	BASED(sysc_nr_ok)	# svc number > 0
 	# svc 0: system call number in %r1
 	cl	%r1,BASED(.Lnr_syscalls)
 	bnl	BASED(sysc_nr_ok)
 	lr	%r7,%r1 	  # copy svc number to %r7
-	sla	%r7,2		  # *4
 sysc_nr_ok:
 	mvc	SP_ARGS(4,%r15),SP_R7(%r15)
 sysc_do_restart:
+	sth	%r7,SP_SVCNR(%r15)
+	sll	%r7,2		  # svc number *4
 	l	%r8,BASED(.Lsysc_table)
 	tm	__TI_flags+3(%r9),(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT)
 	l	%r8,0(%r7,%r8)	  # get system call addr.
@@ -376,7 +376,6 @@ sysc_notify_resume:
 sysc_restart:
 	ni	__TI_flags+3(%r9),255-_TIF_RESTART_SVC # clear TIF_RESTART_SVC
 	l	%r7,SP_R2(%r15) 	# load new svc number
-	sla	%r7,2
 	mvc	SP_R2(4,%r15),SP_ORIG_R2(%r15) # restore first argument
 	lm	%r2,%r6,SP_R2(%r15)	# load svc arguments
 	b	BASED(sysc_do_restart)	# restart svc
@@ -386,7 +385,8 @@ sysc_restart:
 #
 sysc_singlestep:
 	ni	__TI_flags+3(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
-	mvi	SP_TRAP+1(%r15),0x28	# set trap indication to pgm check
+	mvi	SP_SVCNR(%r15),0xff	# set trap indication to pgm check
+	mvi	SP_SVCNR+1(%r15),0xff
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	l	%r1,BASED(.Lhandle_per)	# load adr. of per handler
 	la	%r14,BASED(sysc_return)	# load adr. of system return
@@ -407,7 +407,7 @@ sysc_tracesys:
 	bnl	BASED(sysc_tracenogo)
 	l	%r8,BASED(.Lsysc_table)
 	lr	%r7,%r2
-	sll	%r7,2			# *4
+	sll	%r7,2			# svc number *4
 	l	%r8,0(%r7,%r8)
 sysc_tracego:
 	lm	%r3,%r6,SP_R3(%r15)
@@ -586,7 +586,8 @@ pgm_svcper:
 # per was called from kernel, must be kprobes
 #
 kernel_per:
-	mvi	SP_TRAP+1(%r15),0x28	# set trap indication to pgm check
+	mvi	SP_SVCNR(%r15),0xff	# set trap indication to pgm check
+	mvi	SP_SVCNR+1(%r15),0xff
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	l	%r1,BASED(.Lhandle_per)	# load adr. of per handler
 	la	%r14,BASED(sysc_restore)# load adr. of system return
diff --git a/arch/s390/kernel/entry64.S b/arch/s390/kernel/entry64.S
index 41aca06..89c121a 100644
--- a/arch/s390/kernel/entry64.S
+++ b/arch/s390/kernel/entry64.S
@@ -46,7 +46,7 @@ SP_R14	     =	STACK_FRAME_OVERHEAD + __PT_GPRS + 112
 SP_R15	     =	STACK_FRAME_OVERHEAD + __PT_GPRS + 120
 SP_ORIG_R2   =	STACK_FRAME_OVERHEAD + __PT_ORIG_GPR2
 SP_ILC	     =	STACK_FRAME_OVERHEAD + __PT_ILC
-SP_TRAP      =	STACK_FRAME_OVERHEAD + __PT_TRAP
+SP_SVCNR      =	STACK_FRAME_OVERHEAD + __PT_SVCNR
 SP_SIZE      =	STACK_FRAME_OVERHEAD + __PT_SIZE
 
 STACK_SHIFT = PAGE_SHIFT + THREAD_ORDER
@@ -171,11 +171,10 @@ _TIF_WORK_INT = (_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_NEED_RESCHED | \
 	.macro	CREATE_STACK_FRAME psworg,savearea
 	aghi	%r15,-SP_SIZE		# make room for registers & psw
 	mvc	SP_PSW(16,%r15),0(%r12)	# move user PSW to stack
-	la	%r12,\psworg
 	stg	%r2,SP_ORIG_R2(%r15)	# store original content of gpr 2
-	icm	%r12,12,__LC_SVC_ILC
+	icm	%r12,3,__LC_SVC_ILC
 	stmg	%r0,%r11,SP_R0(%r15)	# store gprs %r0-%r11 to kernel stack
-	st	%r12,SP_ILC(%r15)
+	st	%r12,SP_SVCNR(%r15)
 	mvc	SP_R12(32,%r15),\savearea # move %r12-%r15 to stack
 	la	%r12,0
 	stg	%r12,__SF_BACKCHAIN(%r15)
@@ -250,16 +249,17 @@ sysc_update:
 #endif
 sysc_do_svc:
 	lg	%r9,__LC_THREAD_INFO	# load pointer to thread_info struct
-	slag	%r7,%r7,2	# *4 and test for svc 0
+	ltgr	%r7,%r7		# test for svc 0
 	jnz	sysc_nr_ok
 	# svc 0: system call number in %r1
 	cl	%r1,BASED(.Lnr_syscalls)
 	jnl	sysc_nr_ok
 	lgfr	%r7,%r1 	# clear high word in r1
-	slag	%r7,%r7,2	# svc 0: system call number in %r1
 sysc_nr_ok:
 	mvc	SP_ARGS(8,%r15),SP_R7(%r15)
 sysc_do_restart:
+	sth	%r7,SP_SVCNR(%r15)
+	sllg	%r7,%r7,2	# svc number * 4
 	larl	%r10,sys_call_table
 #ifdef CONFIG_COMPAT
 	tm	__TI_flags+5(%r9),(_TIF_31BIT>>16)  # running in 31 bit mode ?
@@ -363,7 +363,6 @@ sysc_notify_resume:
 sysc_restart:
 	ni	__TI_flags+7(%r9),255-_TIF_RESTART_SVC # clear TIF_RESTART_SVC
 	lg	%r7,SP_R2(%r15)		# load new svc number
-	slag	%r7,%r7,2		# *4
 	mvc	SP_R2(8,%r15),SP_ORIG_R2(%r15) # restore first argument
 	lmg	%r2,%r6,SP_R2(%r15)	# load svc arguments
 	j	sysc_do_restart 	# restart svc
@@ -372,9 +371,8 @@ sysc_restart:
 # _TIF_SINGLE_STEP is set, call do_single_step
 #
 sysc_singlestep:
-	ni	__TI_flags+7(%r9),255-_TIF_SINGLE_STEP # clear TIF_SINGLE_STEP
-	lhi	%r0,__LC_PGM_OLD_PSW
-	sth	%r0,SP_TRAP(%r15)	# set trap indication to pgm check
+	ni	__TI_flags+7(%r9),255-_TIF_SINGLE_STEP	# clear TIF_SINGLE_STEP
+	xc	SP_SVCNR(2,%r15),SP_SVCNR(%r15)		# clear svc number
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	larl	%r14,sysc_return	# load adr. of system return
 	jg	do_single_step		# branch to do_sigtrap
@@ -392,7 +390,7 @@ sysc_tracesys:
 	lghi	%r0,NR_syscalls
 	clgr	%r0,%r2
 	jnh	sysc_tracenogo
-	slag	%r7,%r2,2		# *4
+	sllg	%r7,%r2,2		# svc number *4
 	lgf	%r8,0(%r7,%r10)
 sysc_tracego:
 	lmg	%r3,%r6,SP_R3(%r15)
@@ -567,8 +565,7 @@ pgm_svcper:
 # per was called from kernel, must be kprobes
 #
 kernel_per:
-	lhi	%r0,__LC_PGM_OLD_PSW
-	sth	%r0,SP_TRAP(%r15)	# set trap indication to pgm check
+	xc	SP_SVCNR(2,%r15),SP_SVCNR(%r15)	# clear svc number
 	la	%r2,SP_PTREGS(%r15)	# address of register-save area
 	larl	%r14,sysc_restore	# load adr. of system ret, no work
 	jg	do_single_step		# branch to do_single_step
diff --git a/arch/s390/kernel/init_task.c b/arch/s390/kernel/init_task.c
index 7ad0039..e807168 100644
--- a/arch/s390/kernel/init_task.c
+++ b/arch/s390/kernel/init_task.c
@@ -26,7 +26,7 @@ EXPORT_SYMBOL(init_mm);
 /*
  * Initial thread structure.
  *
- * We need to make sure that this is 8192-byte aligned due to the
+ * We need to make sure that this is THREAD_SIZE aligned due to the
  * way process stacks are handled. This is done by having a special
  * "init_task" linker map entry..
  */
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 1f31be1..38ff2bc 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -657,7 +657,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 		 * debugger stored an invalid system call number. Skip
 		 * the system call and the system call restart handling.
 		 */
-		regs->trap = -1;
+		regs->svcnr = 0;
 		ret = -1;
 	}
 
diff --git a/arch/s390/kernel/signal.c b/arch/s390/kernel/signal.c
index 4f7fc30..8e6812a 100644
--- a/arch/s390/kernel/signal.c
+++ b/arch/s390/kernel/signal.c
@@ -160,7 +160,7 @@ static int restore_sigregs(struct pt_regs *regs, _sigregs __user *sregs)
 	current->thread.fp_regs.fpc &= FPC_VALID_MASK;
 
 	restore_fp_regs(&current->thread.fp_regs);
-	regs->trap = -1;	/* disable syscall checks */
+	regs->svcnr = 0;	/* disable syscall checks */
 	return 0;
 }
 
@@ -445,7 +445,7 @@ void do_signal(struct pt_regs *regs)
 		oldset = &current->blocked;
 
 	/* Are we from a system call? */
-	if (regs->trap == __LC_SVC_OLD_PSW) {
+	if (regs->svcnr) {
 		continue_addr = regs->psw.addr;
 		restart_addr = continue_addr - regs->ilc;
 		retval = regs->gprs[2];
@@ -462,7 +462,7 @@ void do_signal(struct pt_regs *regs)
 		case -ERESTART_RESTARTBLOCK:
 			regs->gprs[2] = -EINTR;
 		}
-		regs->trap = -1;	/* Don't deal with this again. */
+		regs->svcnr = 0;	/* Don't deal with this again. */
 	}
 
 	/* Get signal to deliver.  When running under ptrace, at this point
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index b94e9e3..eccefbb 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -59,7 +59,7 @@
 
 static ext_int_info_t ext_int_info_cc;
 static ext_int_info_t ext_int_etr_cc;
-static u64 jiffies_timer_cc;
+static u64 sched_clock_base_cc;
 
 static DEFINE_PER_CPU(struct clock_event_device, comparators);
 
@@ -68,7 +68,7 @@ static DEFINE_PER_CPU(struct clock_event_device, comparators);
  */
 unsigned long long sched_clock(void)
 {
-	return ((get_clock_xt() - jiffies_timer_cc) * 125) >> 9;
+	return ((get_clock_xt() - sched_clock_base_cc) * 125) >> 9;
 }
 
 /*
@@ -229,13 +229,10 @@ static struct clocksource clocksource_tod = {
  */
 void __init time_init(void)
 {
-	u64 init_timer_cc;
-
-	init_timer_cc = reset_tod_clock();
-	jiffies_timer_cc = init_timer_cc - jiffies_64 * CLK_TICKS_PER_JIFFY;
+	sched_clock_base_cc = reset_tod_clock();
 
 	/* set xtime */
-	tod_to_timeval(init_timer_cc - TOD_UNIX_EPOCH, &xtime);
+	tod_to_timeval(sched_clock_base_cc - TOD_UNIX_EPOCH, &xtime);
         set_normalized_timespec(&wall_to_monotonic,
                                 -xtime.tv_sec, -xtime.tv_nsec);
 
@@ -289,7 +286,7 @@ static unsigned long long adjust_time(unsigned long long old,
 		delta = -delta;
 		adjust.offset = -ticks * (1000000 / HZ);
 	}
-	jiffies_timer_cc += delta;
+	sched_clock_base_cc += delta;
 	if (adjust.offset != 0) {
 		printk(KERN_NOTICE "etr: time adjusted by %li micro-seconds\n",
 		       adjust.offset);
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 607bd67..d796d05 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -2,6 +2,7 @@
  * Written by Martin Schwidefsky (schwidefsky@de.ibm.com)
  */
 
+#include <asm/thread_info.h>
 #include <asm/page.h>
 #include <asm-generic/vmlinux.lds.h>
 
@@ -86,7 +87,7 @@ SECTIONS
 	}
 	_edata = .;		/* End of data section */
 
-	. = ALIGN(2 * PAGE_SIZE);	/* init_task */
+	. = ALIGN(THREAD_SIZE);	/* init_task */
 	.data.init_task : {
 		*(.data.init_task)
 	}


