Return-Path: <linux-kernel-owner+w=401wt.eu-S932836AbZC0Bli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbZC0Bli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 21:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932527AbZC0Bl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 21:41:27 -0400
Received: from 219-87-157-169.static.tfn.net.tw ([219.87.157.169]:40069 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759706AbZC0BlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 21:41:25 -0400
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Subject: Re: [PATCH 6/13] score - New architecure port to SunplusCT S+CORE
  processor
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OF48378D81.6667BB0D-ON48257586.0008F474-48257586.00093CBC@sunplusct.com>
From: liqin.chen@sunplusct.com
Date: Fri, 27 Mar 2009 09:39:09 +0800
X-MIMETrack: Serialize by Router on ctmail01/SunplusCT(Release 7.0.3FP1|February 24, 2008) at 2009/03/27 ?? 09:39:09,
	Serialize complete at 2009/03/27 ?? 09:39:09
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/score lastest patch place at 
http://www.sunplusct.com/images/linux-score-patch/linux-score-20090324.patch

diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/thread_info.h 
linux-2.6-git.new/arch/score/include/asm/thread_info.h
--- linux-2.6-git.ori/arch/score/include/asm/thread_info.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/thread_info.h      2009-03-23 
15:02:37.000000000 +0800
@@ -0,0 +1,97 @@
+#ifndef _ASM_THREAD_INFO_H
+#define _ASM_THREAD_INFO_H
+
+#ifdef __KERNEL__
+
+#define KU_MASK        0x08
+#define KU_USER        0x08
+#define KU_KERN        0x00
+
+#ifndef __ASSEMBLY__
+
+#include <asm/processor.h>
+
+/*
+ * low level task data that entry.S needs immediate access to
+ * - this struct should fit entirely inside of one cache line
+ * - this struct shares the supervisor stack pages
+ * - if the contents of this structure are changed, the assembly 
constants
+ *   must also be changed
+ */
+struct thread_info {
+       struct task_struct      *task;          /* main task structure */
+       struct exec_domain      *exec_domain;   /* execution domain */
+       unsigned long           flags;          /* low level flags */
+       unsigned long           tp_value;       /* thread pointer */
+       __u32                   cpu;            /* current CPU */
+       int                     preempt_count;  /* 0 => preemptable, <0 => 
BUG */
+       mm_segment_t            addr_limit;     /* thread address space:
+                                                  0-0xBFFFFFFF for 
user-thead
+                                                  0-0xFFFFFFFF for 
kernel-thread
+                                               */
+       struct restart_block    restart_block;
+       struct pt_regs          *regs;
+};
+
+/*
+ * macros/functions for gaining access to the thread information 
structure
+ *
+ * preempt_count needs to be 1 initially, until the scheduler is 
functional.
+ */
+#define INIT_THREAD_INFO(tsk)                  \
+{                                              \
+       .task           = &tsk,                 \
+       .exec_domain    = &default_exec_domain, \
+       .cpu            = 0,                    \
+       .preempt_count  = 1,                    \
+       .addr_limit     = KERNEL_DS,            \
+       .restart_block  = {                     \
+               .fn = do_no_restart_syscall,    \
+       },                                      \
+}
+
+#define init_thread_info       (init_thread_union.thread_info)
+#define init_stack             (init_thread_union.stack)
+
+/* How to get the thread information struct from C.  */
+register struct thread_info *__current_thread_info __asm__("r28");
+#define current_thread_info()  __current_thread_info
+
+/* thread information allocation */
+#define THREAD_SIZE_ORDER      (1)
+#define THREAD_SIZE            (PAGE_SIZE << THREAD_SIZE_ORDER)
+#define THREAD_MASK            (THREAD_SIZE - 1UL)
+#define __HAVE_ARCH_THREAD_INFO_ALLOCATOR
+
+#define alloc_thread_info(tsk) kmalloc(THREAD_SIZE, GFP_KERNEL)
+#define free_thread_info(info) kfree(info)
+
+#endif /* !__ASSEMBLY__ */
+
+#define PREEMPT_ACTIVE         0x10000000
+
+/*
+ * thread information flags
+ * - these are process state flags that various assembly files may need 
to
+ *   access
+ * - pending work-to-be-done flags are in LSW
+ * - other flags in MSW
+ */
+#define TIF_SYSCALL_TRACE      0       /* syscall trace active */
+#define TIF_SIGPENDING         1       /* signal pending */
+#define TIF_NEED_RESCHED       2       /* rescheduling necessary */
+#define TIF_RESTORE_SIGMASK    9       /* restore signal mask in 
do_signal() */
+#define TIF_POLLING_NRFLAG     17      /* true if poll_idle() is polling 
TIF_NEED_RESCHED */
+#define TIF_MEMDIE             18
+
+#define _TIF_SYSCALL_TRACE     (1<<TIF_SYSCALL_TRACE)
+#define _TIF_SIGPENDING                (1<<TIF_SIGPENDING)
+#define _TIF_NEED_RESCHED      (1<<TIF_NEED_RESCHED)
+#define _TIF_RESTORE_SIGMASK   (1<<TIF_RESTORE_SIGMASK)
+#define _TIF_POLLING_NRFLAG    (1<<TIF_POLLING_NRFLAG)
+
+#define _TIF_WORK_MASK         (0x0000ffff)
+
+#endif /* __KERNEL__ */
+
+#endif /* _ASM_THREAD_INFO_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/timex.h 
linux-2.6-git.new/arch/score/include/asm/timex.h
--- linux-2.6-git.ori/arch/score/include/asm/timex.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/timex.h    2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,34 @@
+#ifndef _ASM_TIMEX_H
+#define _ASM_TIMEX_H
+
+#ifdef __KERNEL__
+
+/*
+ * This is the clock rate of the i8253 PIT.  A SCORE system may not have
+ * a PIT by the symbol is used all over the kernel including some APIs.
+ * So keeping it defined to the number for the PIT is the only sane thing
+ * for now.
+ */
+#define CLOCK_TICK_RATE 1193182
+
+/*
+ * Standard way to access the cycle counter.
+ * Currently only used on SMP for scheduling.
+ *
+ * Only the low 32 bits are available as a continuously counting entity.
+ * But this only means we'll force a reschedule every 8 seconds or so,
+ * which isn't an evil thing.
+ *
+ * We know that all SMP capable CPUs have cycle counters.
+ */
+
+typedef unsigned int cycles_t;
+
+static inline cycles_t get_cycles(void)
+{
+       return 0;
+}
+
+#endif /* __KERNEL__ */
+
+#endif /*  _ASM_TIMEX_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/tlbflush.h 
linux-2.6-git.new/arch/score/include/asm/tlbflush.h
--- linux-2.6-git.ori/arch/score/include/asm/tlbflush.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/tlbflush.h 2009-03-14 
14:04:05.000000000 +0800
@@ -0,0 +1,142 @@
+#ifndef __ASM_TLBFLUSH_H
+#define __ASM_TLBFLUSH_H
+
+#include <linux/mm.h>
+
+/*
+ * TLB flushing:
+ *
+ *  - flush_tlb_all() flushes all processes TLB entries
+ *  - flush_tlb_mm(mm) flushes the specified mm context TLB entries
+ *  - flush_tlb_page(vma, vmaddr) flushes one page
+ *  - flush_tlb_range(vma, start, end) flushes a range of pages
+ *  - flush_tlb_kernel_range(start, end) flushes a range of kernel pages
+ */
+extern void local_flush_tlb_all(void);
+extern void local_flush_tlb_mm(struct mm_struct *mm);
+extern void local_flush_tlb_range(struct vm_area_struct *vma,
+       unsigned long start, unsigned long end);
+extern void local_flush_tlb_kernel_range(unsigned long start,
+       unsigned long end);
+extern void local_flush_tlb_page(struct vm_area_struct *vma,
+       unsigned long page);
+extern void local_flush_tlb_one(unsigned long vaddr);
+
+#define flush_tlb_all()                        local_flush_tlb_all()
+#define flush_tlb_mm(mm)               local_flush_tlb_mm(mm)
+#define flush_tlb_range(vma, vmaddr, end) \
+       local_flush_tlb_range(vma, vmaddr, end)
+#define flush_tlb_kernel_range(vmaddr,end) \
+       local_flush_tlb_kernel_range(vmaddr, end)
+#define flush_tlb_page(vma, page)      local_flush_tlb_page(vma, page)
+#define flush_tlb_one(vaddr)           local_flush_tlb_one(vaddr)
+
+#ifndef __ASSEMBLY__
+
+static inline unsigned long get_PEVN(void)
+{
+       unsigned long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr11\n"
+               "nop\nnop\n"
+               : "=r" (val));
+
+       return val;
+}
+
+static inline void set_PEVN(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr11\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void set_PECTX(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr12\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       :: "r" (val));
+}
+
+static inline unsigned long get_PECTX(void)
+{
+       unsigned long val;
+       __asm__ __volatile__(
+               "mfcr %0, cr12\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline unsigned long get_TLBLOCK(void)
+{
+       unsigned long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr7\n"
+               "nop\nnop\n"
+       : "=r" (val));
+       return val;
+}
+static inline void set_TLBLOCK(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr7\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+       : : "r" (val));
+}
+
+static inline void set_TLBPT(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr8\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               :: "r" (val));
+}
+
+static inline long get_TLBPT(void)
+{
+       long val;
+
+       __asm__ __volatile__(
+               "mfcr %0, cr8\n"
+               "nop\nnop\n"
+               : "=r" (val));
+
+       return val;
+}
+
+static inline void set_PEADDR(unsigned long val)
+{
+       __asm__ __volatile__(
+               "mtcr %0, cr9\n"
+               "nop\nnop\nnop\nnop\nnop\n"
+               :: "r" (val));
+}
+
+/* TLB operations. */
+static inline void tlb_probe(void)
+{
+       __asm__ __volatile__("stlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_read(void)
+{
+       __asm__ __volatile__("mftlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_indexed(void)
+{
+       __asm__ __volatile__("mtptlb;nop;nop;nop;nop;nop");
+}
+
+static inline void tlb_write_random(void)
+{
+       __asm__ __volatile__("mtrtlb;nop;nop;nop;nop;nop");
+}
+
+#endif /* Not __ASSEMBLY__ */
+
+#endif /* __ASM_TLBFLUSH_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/tlb.h 
linux-2.6-git.new/arch/score/include/asm/tlb.h
--- linux-2.6-git.ori/arch/score/include/asm/tlb.h      1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/tlb.h      2009-03-23 
15:03:16.000000000 +0800
@@ -0,0 +1,15 @@
+#ifndef __ASM_TLB_H
+#define __ASM_TLB_H
+
+/*
+ * SCORE doesn't need any special per-pte or per-vma handling, except
+ * we need to flush cache for area to be unmapped.
+ */
+#define tlb_start_vma(tlb, vma)                do {} while (0)
+#define tlb_end_vma(tlb, vma)          do {} while (0)
+#define __tlb_remove_tlb_entry(tlb, ptep, address) do {} while (0)
+#define tlb_flush(tlb)                 flush_tlb_mm((tlb)->mm)
+
+#include <asm-generic/tlb.h>
+
+#endif /* __ASM_TLB_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/topology.h 
linux-2.6-git.new/arch/score/include/asm/topology.h
--- linux-2.6-git.ori/arch/score/include/asm/topology.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/topology.h 2009-03-13 
14:26:33.000000000 +0800
@@ -0,0 +1,6 @@
+#ifndef __ASM_TOPOLOGY_H
+#define __ASM_TOPOLOGY_H
+
+#include <asm-generic/topology.h>
+
+#endif /* __ASM_TOPOLOGY_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/types.h 
linux-2.6-git.new/arch/score/include/asm/types.h
--- linux-2.6-git.ori/arch/score/include/asm/types.h    1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/types.h    2009-03-23 
15:03:24.000000000 +0800
@@ -0,0 +1,24 @@
+#ifndef _ASM_TYPES_H
+#define _ASM_TYPES_H
+
+#include <asm-generic/int-ll64.h>
+
+#ifndef __ASSEMBLY__
+typedef unsigned short umode_t;
+#endif /* __ASSEMBLY__ */
+
+#ifdef __KERNEL__
+#define BITS_PER_LONG  32
+#ifndef __ASSEMBLY__
+
+typedef u32 dma_addr_t;
+typedef u64 dma64_addr_t;
+
+/*
+ * Don't use phys_t. You've been warned.
+ */
+typedef unsigned long phys_t;
+
+#endif /* __ASSEMBLY__ */
+#endif /* __KERNEL__ */
+#endif /* _ASM_TYPES_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/uaccess.h 
linux-2.6-git.new/arch/score/include/asm/uaccess.h
--- linux-2.6-git.ori/arch/score/include/asm/uaccess.h  1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/uaccess.h  2009-03-23 
17:35:07.000000000 +0800
@@ -0,0 +1,405 @@
+#ifndef _ASM_UACCESS_H
+#define _ASM_UACCESS_H
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/thread_info.h>
+#include <asm-generic/uaccess.h>
+
+#define __UA_LIMIT     0x80000000UL
+#define KERNEL_DS      ((mm_segment_t) { 0UL })
+#define USER_DS                ((mm_segment_t) { __UA_LIMIT })
+
+#define VERIFY_READ    0
+#define VERIFY_WRITE   1
+
+#define get_ds()       (KERNEL_DS)
+#define get_fs()       (current_thread_info()->addr_limit)
+#define set_fs(x)      (current_thread_info()->addr_limit = (x))
+#define segment_eq(a, b)       ((a).seg == (b).seg)
+
+/*
+ * Is a address valid? This does a straighforward calculation rather
+ * than tests.
+ *
+ * Address valid if:
+ *  - "addr" doesn't have any high-bits set
+ *  - AND "size" doesn't have any high-bits set
+ *  - AND "addr+size" doesn't have any high-bits set
+ *  - OR we are in kernel mode.
+ *
+ * __ua_size() is a trick to avoid runtime checking of positive constant
+ * sizes; for those we already know at compile time that the size is ok.
+ */
+#define __ua_size(size) \
+       ((__builtin_constant_p(size) && (signed long) (size) > 0) ? 0 : 
(size))
+
+/*
+ * access_ok: - Checks if a user space pointer is valid
+ * @type: Type of access: %VERIFY_READ or %VERIFY_WRITE.  Note that
+ *        %VERIFY_WRITE is a superset of %VERIFY_READ - if it is safe
+ *        to write to a block, it is always safe to read from it.
+ * @addr: User space pointer to start of block to check
+ * @size: Size of block to check
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * Checks if a pointer to a block of memory in user space is valid.
+ *
+ * Returns true (nonzero) if the memory block may be valid, false (zero)
+ * if it is definitely invalid.
+ *
+ * Note that, depending on architecture, this function probably just
+ * checks that the pointer is in the user space range - after calling
+ * this function, memory access functions may still return -EFAULT.
+ */
+
+#define __access_mask get_fs().seg
+
+#define __access_ok(addr, size, mask)                                  \
+       (((signed long)((mask) & ((addr) | ((addr) + (size)) | 
__ua_size(size)))) == 0)
+
+#define access_ok(type, addr, size)                                    \
+       likely(__access_ok((unsigned long)(addr), (size), __access_mask))
+
+/*
+ * put_user: - Write a simple value into user space.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be 
assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define put_user(x,ptr) __put_user_check((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * get_user: - Get a simple variable from user space.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#define get_user(x,ptr) __get_user_check((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * __put_user: - Write a simple value into user space, with less 
checking.
+ * @x:   Value to copy to user space.
+ * @ptr: Destination address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple value from kernel space to user
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and @x must be 
assignable
+ * to the result of dereferencing @ptr.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ */
+#define __put_user(x,ptr) __put_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+/*
+ * __get_user: - Get a simple variable from user space, with less 
checking.
+ * @x:   Variable to store result.
+ * @ptr: Source address, in user space.
+ *
+ * Context: User context only.  This function may sleep.
+ *
+ * This macro copies a single simple variable from user space to kernel
+ * space.  It supports simple types like char and int, but not larger
+ * data types like structures or arrays.
+ *
+ * @ptr must have pointer-to-simple-variable type, and the result of
+ * dereferencing @ptr must be assignable to @x without a cast.
+ *
+ * Caller must check the pointer with access_ok() before calling this
+ * function.
+ *
+ * Returns zero on success, or -EFAULT on error.
+ * On error, the variable @x is set to zero.
+ */
+#define __get_user(x,ptr) __get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
+struct __large_struct { unsigned long buf[100]; };
+#define __m(x) (*(struct __large_struct __user *)(x))
+
+/*
+ * Yuck.  We need two variants, one for 64bit operation and one
+ * for 32 bit mode and old iron.
+ */
+extern void __get_user_unknown(void);
+
+#define __get_user_common(val, size, ptr)                              \
+do {                                                                   \
+       switch (size) {                                                 \
+       case 1: __get_user_asm(val, "lb", ptr); break;                  \
+       case 2: __get_user_asm(val, "lh", ptr); break;                  \
+       case 4: __get_user_asm(val, "lw", ptr); break;                  \
+       case 8:                                                         \
+               if((copy_from_user((void *)&val, ptr, 8)) == 0)         \
+                       __gu_err = 0;                                   \
+               else                                                    \
+                       __gu_err = -EFAULT;                             \
+               break;                                                  \
+       default: __get_user_unknown(); break;                           \
+       }                                                               \
+} while (0)
+
+#define __get_user_nocheck(x, ptr, size)                               \
+({                                                                     \
+       long __gu_err = 0;                                              \
+       __get_user_common((x), size, ptr);                              \
+       __gu_err;                                                       \
+})
+
+#define __get_user_check(x, ptr, size)                                 \
+({                                                                     \
+       long __gu_err = -EFAULT;                                        \
+       const __typeof__(*(ptr)) __user *__gu_ptr = (ptr);              \
+                                                                       \
+       if (likely(access_ok(VERIFY_READ, __gu_ptr, size)))             \
+               __get_user_common((x), size, __gu_ptr);                 \
+                                                                       \
+       __gu_err;                                                       \
+})
+
+#define __get_user_asm(val, insn, addr) \
+{                                                                      \
+       long __gu_tmp;                                                  \
+                                                                       \
+       __asm__ __volatile__(                                           \
+               "1:" insn " %1, %3\n"                                   \
+               "2:\n"                                                  \
+               ".section .fixup,\"ax\"\n"                              \
+               "3:li   %0, %4\n"                                       \
+               "j      2b\n"                                           \
+               ".previous\n"                                           \
+               ".section __ex_table,\"a\"\n"                           \
+               ".word  1b, 3b\n"                                       \
+               ".previous\n"                                           \
+               : "=r" (__gu_err), "=r" (__gu_tmp)                      \
+               : "0" (0), "o" (__m(addr)), "i" (-EFAULT));             \
+                                                                       \
+               (val) = (__typeof__(*(addr))) __gu_tmp;                 \
+}
+
+/*
+ * Yuck.  We need two variants, one for 64bit operation and one
+ * for 32 bit mode and old iron.
+ */
+#define __put_user_nocheck(val, ptr, size)                             \
+({                                                                     \
+       __typeof__(*(ptr)) __pu_val;                                    \
+       long __pu_err = 0;                                              \
+                                                                       \
+       __pu_val = (val);                                               \
+       switch (size) {                                                 \
+       case 1: __put_user_asm("sb", ptr); break;                       \
+       case 2: __put_user_asm("sh", ptr); break;                       \
+       case 4: __put_user_asm("sw", ptr); break;                       \
+       case 8:                                                         \
+               if((__copy_to_user((void *)ptr, &__pu_val, 8)) == 0)    \
+                       __pu_err = 0;                                   \
+               else                                                    \
+                       __pu_err = -EFAULT;                             \
+               break;                                                  \
+       default: __put_user_unknown(); break;                           \
+       }                                                               \
+       __pu_err;                                                       \
+})
+
+
+#define __put_user_check(val, ptr, size)                               \
+({                                                                     \
+       __typeof__(*(ptr)) __user *__pu_addr = (ptr);                   \
+       __typeof__(*(ptr)) __pu_val = (val);                            \
+       long __pu_err = -EFAULT;                                        \
+                                                                       \
+       if (likely(access_ok(VERIFY_WRITE, __pu_addr, size))) { \
+               switch (size) {                                         \
+               case 1: __put_user_asm("sb", __pu_addr); break;         \
+               case 2: __put_user_asm("sh", __pu_addr); break;         \
+               case 4: __put_user_asm("sw", __pu_addr); break;         \
+               case 8:                                                 \
+                       if ((__copy_to_user((void *)__pu_addr, &__pu_val, 
8)) == 0)\
+                               __pu_err = 0;                           \
+                       else                                            \
+                               __pu_err = -EFAULT;                     \
+                       break;                                          \
+               default: __put_user_unknown(); break;                   \
+               }                                                       \
+       }                                                               \
+       __pu_err;                                                       \
+})
+
+#define __put_user_asm(insn,ptr)                                       \
+       __asm__ __volatile__(                                           \
+               "1:" insn " %2, %3\n"                                   \
+               "2:\n"                                                  \
+               ".section .fixup,\"ax\"\n"                              \
+               "3:li %0, %4\n"                                         \
+               "j 2b\n"                                                \
+               ".previous\n"                                           \
+               ".section __ex_table,\"a\"\n"                           \
+               ".word 1b, 3b\n"                                        \
+               ".previous\n"                                           \
+               : "=r" (__pu_err)                                       \
+               : "0" (0), "r" (__pu_val), "o" (__m(ptr)),              \
+                 "i" (-EFAULT));
+
+extern void __put_user_unknown(void);
+
+extern int __copy_tofrom_user(void *to, const void *from, unsigned long 
len);
+
+static inline unsigned long copy_from_user(void *to, const void *from, 
unsigned long len)
+{
+       unsigned long over;
+       if(access_ok(VERIFY_READ, from, len))
+               return __copy_tofrom_user(to, from, len);
+       if ((unsigned long)from < TASK_SIZE) {
+               over = (unsigned long)from + len - TASK_SIZE;
+               return __copy_tofrom_user(to, from, len - over) + over;
+       }
+       return len;
+}
+
+static inline unsigned long copy_to_user(void *to, const void *from, 
unsigned long len)
+{
+       unsigned long over;
+
+       if (access_ok(VERIFY_WRITE, to, len))
+               return __copy_tofrom_user(to, from, len);
+       if ((unsigned long)to < TASK_SIZE) {
+               over = (unsigned long)to + len - TASK_SIZE;
+               return __copy_tofrom_user(to, from, len - over) + over;
+       }
+       return len;
+}
+
+#define __copy_from_user(to, from, len)        \
+               __copy_tofrom_user((to), (from), (len))
+
+#define __copy_to_user(to, from, len)          \
+               __copy_tofrom_user((to), (from), (len))
+
+
+static inline unsigned long
+__copy_to_user_inatomic(void *to, const void *from, unsigned long len)
+{
+       return __copy_to_user(to, from, len);
+}
+
+static inline unsigned long
+__copy_from_user_inatomic(void *to, const void *from, unsigned long len)
+{
+       return __copy_from_user(to, from, len);
+}
+
+#define __copy_in_user(to, from, len)  __copy_from_user(to, from, len)
+
+static inline unsigned long
+copy_in_user(void *to, const void *from, unsigned long len)
+{
+       if (access_ok(VERIFY_READ, from, len) &&
+                     access_ok(VERFITY_WRITE, to, len))
+               return copy_from_user(to, from, len);
+}
+
+/*
+ * __clear_user: - Zero a block of memory in user space, with less 
checking.
+ * @to:   Destination address, in user space.
+ * @n:    Number of bytes to zero.
+ *
+ * Zero a block of memory in user space.  Caller must check
+ * the specified block with access_ok() before calling this function.
+ *
+ * Returns number of bytes that could not be cleared.
+ * On success, this will be zero.
+ */
+extern unsigned long __clear_user(char *src, unsigned long size);
+
+static inline unsigned long clear_user(char *src, unsigned long size)
+{
+       if (access_ok(VERIFY_WRITE, src, size))
+               return __clear_user(src, size);
+       return -EFAULT;
+}
+
+
+/*
+ * __strncpy_from_user: - Copy a NUL terminated string from userspace, 
with less checking.
+ * @dst:   Destination address, in kernel space.  This buffer must be at
+ *         least @count bytes long.
+ * @src:   Source address, in user space.
+ * @count: Maximum number of bytes to copy, including the trailing NUL.
+ *
+ * Copies a NUL-terminated string from userspace to kernel space.
+ * Caller must check the specified block with access_ok() before calling
+ * this function.
+ *
+ * On success, returns the length of the string (not including the 
trailing
+ * NUL).
+ *
+ * If access to userspace fails, returns -EFAULT (some data may have been
+ * copied).
+ *
+ * If @count is smaller than the length of the string, copies @count 
bytes
+ * and returns @count.
+ */
+extern int __strncpy_from_user(char *dst, const char *src, long len);
+
+static inline int strncpy_from_user(char *dst, const char *src, long len)
+{
+       if (access_ok(VERIFY_READ, src, 1))
+               return __strncpy_from_user(dst, src, len);
+       return -EFAULT;
+}
+
+
+extern int __strlen_user(const char *src);
+static inline long strlen_user(const char __user *src)
+{
+       return __strlen_user(src);
+}
+
+
+extern int __strnlen_user(const char *str, long len);
+static inline long strnlen_user(const char __user *str, long len)
+{
+       if (access_ok(VERIFY_READ, str, len));
+               return __strnlen_user(str, len);
+       return -EFAULT;
+}
+
+struct exception_table_entry
+{
+       unsigned long insn;
+       unsigned long nextinsn;
+};
+
+extern int fixup_exception(struct pt_regs *regs);
+
+#endif /* _ASM_UACCESS_H */
+
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/ucontext.h 
linux-2.6-git.new/arch/score/include/asm/ucontext.h
--- linux-2.6-git.ori/arch/score/include/asm/ucontext.h 1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/ucontext.h 2009-03-23 
15:07:20.000000000 +0800
@@ -0,0 +1,12 @@
+#ifndef _ASM_UCONTEXT_H
+#define _ASM_UCONTEXT_H
+
+struct ucontext {
+       unsigned long   uc_flags;
+       struct ucontext *uc_link;
+       stack_t         uc_stack;
+       struct sigcontext uc_mcontext;
+       sigset_t        uc_sigmask;     /* mask last for extensibility */
+};
+
+#endif /* _ASM_UCONTEXT_H */
diff -uprN -x linux-2.6-git.ori/Documentation/dontdiff 
linux-2.6-git.ori/arch/score/include/asm/unaligned.h 
linux-2.6-git.new/arch/score/include/asm/unaligned.h
--- linux-2.6-git.ori/arch/score/include/asm/unaligned.h        1970-01-01 
08:00:00.000000000 +0800
+++ linux-2.6-git.new/arch/score/include/asm/unaligned.h        2009-03-23 
15:07:26.000000000 +0800
@@ -0,0 +1,21 @@
+#ifndef _ASM_SCORE_UNALIGNED_H
+#define _ASM_SCORE_UNALIGNED_H
+
+#include <linux/compiler.h>
+#if defined(__SCOREEB__)
+# include <linux/unaligned/be_struct.h>
+# include <linux/unaligned/le_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned __get_unaligned_be
+# define put_unaligned __put_unaligned_be
+#elif defined(__SCOREEL__)
+# include <linux/unaligned/le_struct.h>
+# include <linux/unaligned/be_byteshift.h>
+# include <linux/unaligned/generic.h>
+# define get_unaligned __get_unaligned_le
+# define put_unaligned __put_unaligned_le
+#else
+# error "SCORE, but neither __SCOREEB__, nor __SCOREEL__???"
+#endif
+
+#endif /* _ASM_SCORE_UNALIGNED_H */

Signed off by: Chen Liqin <liqin.chen@sunplusct.com>
