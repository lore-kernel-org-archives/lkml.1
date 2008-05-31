Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYEaB1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYEaB1z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 21:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753145AbYEaB1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 21:27:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbYEaB12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 21:27:28 -0400
Date: Fri, 30 May 2008 21:27:21 -0400
From: Ulrich Drepper <drepper@redhat.com>
Message-Id: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] 64-bit futexes: x86 support
Cc: akpm@linux-foundation.org, mtk.manpages@gmail.com,
       torvalds@linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds 64-bit futex support for x86.  As explained in the
introduction, this requires a new system call.  The remaining changes are
similarly to the x86-64 changes: enable support for FUTEX_WAKE_OP.

[Sorry Andrew, but syscalls unfortunately have to be added at the end.
So you'll have to live with the conflicts.]


 arch/x86/ia32/ia32entry.S          |    1 
 arch/x86/ia32/sys_ia32.c           |   46 ++++++++++++++++++++++++++++++
 arch/x86/kernel/sys_i386_32.c      |   48 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    1 
 include/asm-x86/futex.h            |   55 +++++++++++++++++++++++++++++++++++--
 include/asm-x86/types.h            |    2 -
 include/asm-x86/unistd_32.h        |    1 
 scripts/checksyscalls.sh           |    1 
 8 files changed, 151 insertions(+), 4 deletions(-)


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index b5e329d..776b6a2 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -731,4 +731,5 @@ ia32_sys_call_table:
 	.quad sys32_fallocate
 	.quad compat_sys_timerfd_settime	/* 325 */
 	.quad compat_sys_timerfd_gettime
+	.quad sys32_futex64
 ia32_syscall_end:
diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index f00afdf..f5a6403 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -24,6 +24,7 @@
 #include <linux/sched.h>
 #include <linux/fs.h>
 #include <linux/file.h>
+#include <linux/futex.h>
 #include <linux/signal.h>
 #include <linux/syscalls.h>
 #include <linux/times.h>
@@ -865,3 +866,48 @@ asmlinkage long sys32_fallocate(int fd, int mode, unsigned offset_lo,
 	return sys_fallocate(fd, mode, ((u64)offset_hi << 32) | offset_lo,
 			     ((u64)len_hi << 32) | len_lo);
 }
+
+/* For the futex syscall with 64-bit values we would need more than the six
+   available syscall parameters.  Pass the parameters in memory instead.  */
+struct futex_arg_struct {
+	u32 uaddr;
+	int op;
+	u64 val;
+	u32 utime;
+	u32 uaddr2;
+	u64 val3;
+};
+
+asmlinkage long sys32_futex64(struct futex_arg_struct __user *arg)
+{
+	struct futex_arg_struct a;
+	struct compat_timespec *utime;
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
+	u32 val2 = 0;
+	int cmd;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+
+	cmd = a.op & FUTEX_CMD_MASK;
+	utime = (struct compat_timespec __user *) (u64) a.utime;
+
+	if (utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
+		      cmd == FUTEX_WAIT_BITSET)) {
+		if (get_compat_timespec(&ts, utime))
+			return -EFAULT;
+		if (!timespec_valid(&ts))
+			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
+		if (cmd == FUTEX_WAIT)
+			t = ktime_add_safe(ktime_get(), t);
+		tp = &t;
+	}
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE)
+		val2 = a.utime;
+
+	return do_futex((void __user *) (u64) a.uaddr, a.op, a.val, tp,
+			(void __user *) (u64) a.uaddr2, val2, a.val3);
+}
diff --git a/arch/x86/kernel/sys_i386_32.c b/arch/x86/kernel/sys_i386_32.c
index d2ab52c..a28da03 100644
--- a/arch/x86/kernel/sys_i386_32.c
+++ b/arch/x86/kernel/sys_i386_32.c
@@ -244,3 +244,51 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[])
 	: "0" (__NR_execve),"ri" (filename),"c" (argv), "d" (envp) : "memory");
 	return __res;
 }
+
+
+/* For the futex syscall with 64-bit values we would need more than the six
+   available syscall parameters.  Pass the parameters in memory instead.  */
+struct futex_arg_struct {
+	void __user *uaddr;
+	int op;
+	u64 val;
+	struct timespec __user *utime;
+	void __user *uaddr2;
+	u64 val3;
+};
+
+asmlinkage long sys_futex64(struct futex_arg_struct __user *arg)
+{
+	struct futex_arg_struct a;
+	struct timespec ts;
+	ktime_t t, *tp = NULL;
+	u32 val2 = 0;
+	int cmd;
+
+	if (copy_from_user(&a, arg, sizeof(a)))
+		return -EFAULT;
+
+	cmd = a.op & FUTEX_CMD_MASK;
+
+	if (a.utime && (cmd == FUTEX_WAIT || cmd == FUTEX_LOCK_PI ||
+			cmd == FUTEX_WAIT_BITSET)) {
+		if (copy_from_user(&ts, a.utime, sizeof(ts)) != 0)
+			return -EFAULT;
+		if (!timespec_valid(&ts))
+			return -EINVAL;
+
+		t = timespec_to_ktime(ts);
+		if (cmd == FUTEX_WAIT)
+			t = ktime_add_safe(ktime_get(), t);
+		tp = &t;
+	}
+	/*
+	 * requeue parameter in 'utime' if cmd == FUTEX_REQUEUE.
+	 * number of waiters to wake in 'utime' if cmd == FUTEX_WAKE_OP.
+	 */
+	if (cmd == FUTEX_REQUEUE || cmd == FUTEX_CMP_REQUEUE ||
+	    cmd == FUTEX_WAKE_OP)
+		val2 = (u32) (unsigned long) a.utime;
+
+	return do_futex(a.uaddr, a.op, a.val, tp, a.uaddr2, val2, a.val3);
+}
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index adff556..5b1b5d9 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -326,3 +326,4 @@ ENTRY(sys_call_table)
 	.long sys_fallocate
 	.long sys_timerfd_settime	/* 325 */
 	.long sys_timerfd_gettime
+	.long sys_futex64
diff --git a/include/asm-x86/unistd_32.h b/include/asm-x86/unistd_32.h
index 8317d94..8be8e19 100644
--- a/include/asm-x86/unistd_32.h
+++ b/include/asm-x86/unistd_32.h
@@ -332,6 +332,7 @@
 #define __NR_fallocate		324
 #define __NR_timerfd_settime	325
 #define __NR_timerfd_gettime	326
+#define __NR_futex64		327
 
 #ifdef __KERNEL__
 
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 366f8c7..a03b34c 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -98,6 +98,7 @@ cat << EOF
 #define __IGNORE_setgid32
 #define __IGNORE_setfsuid32
 #define __IGNORE_setfsgid32
+#define __IGNORE_futex64
 
 /* sync_file_range had a stupid ABI. Allow sync_file_range2 instead */
 #ifdef __NR_sync_file_range2
--- a/include/asm-x86/types.h	2008-05-28 15:57:16.000000000 -0700
+++ b/include/asm-x86/types.h	2008-05-28 15:57:39.000000000 -0700
@@ -30,10 +30,8 @@
 typedef u32 dma_addr_t;
 #endif
 
-#ifdef CONFIG_X86_64
 typedef u64 futex_val_t;
 #define __have_futex_val_t
-#endif
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
--- a/include/asm-x86/futex.h	2008-05-28 16:09:03.000000000 -0700
+++ b/include/asm-x86/futex.h	2008-05-28 16:09:20.000000000 -0700
@@ -46,7 +46,34 @@
 	oldval = oldvaltemp;					\
   } while (0)
 
-#ifndef CONFIG_X86_32
+#ifdef CONFIG_X86_32
+#define __futex_atomic64_op(insns, ret, oldval, uaddr, oparg)	\
+  do {								\
+	u32 oldvaltemp1, oldvaltemp2;				\
+	int tem2;						\
+	asm volatile("1:\tmovl	%3, %0\n"			\
+		     "2:\tmovl %4, %1\n"			\
+		     "\tmovl\t%0, %5\n"				\
+		     "\tmovl\t%1, %6\n"				\
+		     "\t" insns "\n"				\
+		     "3:\tlock; cmpxchg8b %3\n"			\
+		     "\tjnz\t1b\n"				\
+		     "4:\t.section .fixup,\"ax\"\n"		\
+		     "5:\tmov\t%5, %1\n"			\
+		     "\tjmp\t4b\n"				\
+		     "\t.previous\n"				\
+		     _ASM_EXTABLE(1b, 5b)			\
+		     _ASM_EXTABLE(2b, 5b)			\
+		     _ASM_EXTABLE(3b, 5b)			\
+		     : "=&a" (oldvaltemp1), "=&d" (oldvaltmep2),\
+		       "=&r" (ret),				\
+		       "+m" (((u32 __user *) uaddr)[0]),	\
+		       "+m" (((u32 __user *) uaddr)[1]),	\
+		       "=&b" (tem), "=&c" (tem2)		\
+		     : "r" (oparg), "i" (-EFAULT), "2" (0));	\
+	oldval = (((u64) oldvaltemp2) << 32) | oldvaltemp1;	\
+  } while (0)
+#else
 #define __futex_atomic64_op1(insn, ret, oldval, uaddr, oparg)	\
 	asm volatile("1:\t" insn "\n"				\
 		     "2:\t.section .fixup,\"ax\"\n"		\
@@ -97,6 +124,12 @@ static inline int futex_atomic_op_inuser
 	if (op != FUTEX_OP_SET && boot_cpu_data.x86 == 3)
 		return -ENOSYS;
 #endif
+#ifdef CONFIG_X86_32
+	/* Not all 32-bit machines support 8-byte cmpxchg.  We just
+	   unconditionally perform a runtime check for the feature.  */
+	if ((op & FUTEX_FLAG_64) && !boot_cpu_has(X86_FEATURE_CX8))
+		return -ENOSYS;
+#endif
 
 	pagefault_disable();
 
@@ -117,7 +150,25 @@ static inline int futex_atomic_op_inuser
 	case FUTEX_OP_XOR:
 		__futex_atomic_op2("xorl %4, %3", ret, oldval, uaddr, oparg);
 		break;
-#ifndef CONFIG_X86_32
+#ifdef CONFIG_X86_32
+	case FUTEX_OP64_SET:
+		__futex_atomic64_op("movl %7, %5\n\txorl %6, %6",
+				    ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP64_ADD:
+		__futex_atomic64_op("addl %7, %5\n\tadcl $0, %6", ret, oldval,
+				    uaddr, oparg);
+		break;
+	case FUTEX_OP64_OR:
+		__futex_atomic64_op("orl %7, %5", ret, oldval, uaddr, oparg);
+		break;
+	case FUTEX_OP64_ANDN:
+		__futex_atomic64_op("andl %7, %5", ret, oldval, uaddr, ~oparg);
+		break;
+	case FUTEX_OP64_XOR:
+		__futex_atomic64_op("xorl %7, %5", ret, oldval, uaddr, oparg);
+		break;		
+#else
 	case FUTEX_OP64_SET:
 		__futex_atomic64_op1("xchgq %q0, %q2",
 				     ret, oldval, uaddr, oparg);
