Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413Ab0B0Q4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 11:56:15 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48810 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427Ab0B0Qz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 11:55:56 -0500
Date: Sat, 27 Feb 2010 17:55:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [GIT PULL] x86/rwsem changes for v2.6.34
Message-ID: <20100227165539.GA17970@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-rwsem-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-rwsem-for-linus


out-of-topic modifications in x86-rwsem-for-linus:
--------------------------------------------------
arch/um/sys-x86_64/Makefile        # 4126faf: x86: Fix breakage of UML from the
lib/hweight.c                      # 39d997b: x86, core: Optimize hweight32()

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86, core: Optimize hweight32()

Avi Kivity (1):
      x86-64, rwsem: Avoid store forwarding hazard in __downgrade_write

Brian Gerst (4):
      x86: Split atomic64_t functions into seperate headers
      x86: Sync asm/atomic_32.h and asm/atomic_64.h
      x86: Merge asm/atomic_{32,64}.h
      x86: Merge show_regs()

Dave Jones (1):
      x86: Macroise x86 cache descriptors

H. Peter Anvin (1):
      x86-64, rwsem: 64-bit xadd rwsem implementation

Jan Beulich (3):
      x86: Lift restriction on the location of FIX_BTMAP_*
      x86-64: Modify copy_user_generic() alternatives mechanism
      x86-64: Modify memcpy()/memset() alternatives mechanism

Linus Torvalds (4):
      x86-32: clean up rwsem inline asm statements
      x86: clean up rwsem type system
      x86-64: support native xadd rwsem implementation
      x86: Fix breakage of UML from the changes in the rwsem system


 arch/um/sys-x86_64/Makefile           |    3 +-
 arch/x86/Kconfig.cpu                  |    2 +-
 arch/x86/include/asm/alternative.h    |    7 +-
 arch/x86/include/asm/atomic.h         |  299 ++++++++++++++++++++-
 arch/x86/include/asm/atomic64_32.h    |  160 +++++++++++
 arch/x86/include/asm/atomic64_64.h    |  224 +++++++++++++++
 arch/x86/include/asm/atomic_32.h      |  415 ----------------------------
 arch/x86/include/asm/atomic_64.h      |  485 ---------------------------------
 arch/x86/include/asm/fixmap.h         |   16 +-
 arch/x86/include/asm/rwsem.h          |   81 ++++---
 arch/x86/include/asm/uaccess_64.h     |   21 ++-
 arch/x86/kernel/alternative.c         |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   84 +++---
 arch/x86/kernel/process.c             |    7 +
 arch/x86/kernel/process_32.c          |    6 -
 arch/x86/kernel/process_64.c          |    6 -
 arch/x86/kernel/x8664_ksyms_64.c      |    3 +-
 arch/x86/lib/Makefile                 |    1 +
 arch/x86/lib/copy_user_64.S           |    6 -
 arch/x86/lib/memcpy_64.S              |   23 +-
 arch/x86/lib/memset_64.S              |   18 +-
 arch/x86/lib/rwsem_64.S               |   81 ++++++
 arch/x86/mm/ioremap.c                 |    4 +
 lib/hweight.c                         |    7 +
 24 files changed, 932 insertions(+), 1031 deletions(-)
 create mode 100644 arch/x86/include/asm/atomic64_32.h
 create mode 100644 arch/x86/include/asm/atomic64_64.h
 delete mode 100644 arch/x86/include/asm/atomic_32.h
 delete mode 100644 arch/x86/include/asm/atomic_64.h
 create mode 100644 arch/x86/lib/rwsem_64.S

diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index 2201e9c..c1ea9eb 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -8,7 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
-subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
+		lib/rwsem_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o
diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 08e442b..9d38a13 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -319,7 +319,7 @@ config X86_L1_CACHE_SHIFT
 
 config X86_XADD
 	def_bool y
-	depends on X86_32 && !M386
+	depends on X86_64 || !M386
 
 config X86_PPRO_FENCE
 	bool "PentiumPro memory ordering errata workaround"
diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index 69b74a7..3b5b828 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -125,11 +125,16 @@ static inline void alternatives_smp_switch(int smp) {}
 	asm volatile (ALTERNATIVE(oldinstr, newinstr, feature)		\
 		: output : "i" (0), ## input)
 
+/* Like alternative_io, but for replacing a direct call with another one. */
+#define alternative_call(oldfunc, newfunc, feature, output, input...)	\
+	asm volatile (ALTERNATIVE("call %P[old]", "call %P[new]", feature) \
+		: output : [old] "i" (oldfunc), [new] "i" (newfunc), ## input)
+
 /*
  * use this macro(s) if you need more than one output parameter
  * in alternative_io
  */
-#define ASM_OUTPUT2(a, b) a, b
+#define ASM_OUTPUT2(a...) a
 
 struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
diff --git a/arch/x86/include/asm/atomic.h b/arch/x86/include/asm/atomic.h
index 4e1b887..8baaa71 100644
--- a/arch/x86/include/asm/atomic.h
+++ b/arch/x86/include/asm/atomic.h
@@ -1,5 +1,300 @@
+#ifndef _ASM_X86_ATOMIC_H
+#define _ASM_X86_ATOMIC_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+#include <asm/alternative.h>
+#include <asm/cmpxchg.h>
+
+/*
+ * Atomic operations that C can't guarantee us.  Useful for
+ * resource counting etc..
+ */
+
+#define ATOMIC_INIT(i)	{ (i) }
+
+/**
+ * atomic_read - read atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically reads the value of @v.
+ */
+static inline int atomic_read(const atomic_t *v)
+{
+	return v->counter;
+}
+
+/**
+ * atomic_set - set atomic variable
+ * @v: pointer of type atomic_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic_set(atomic_t *v, int i)
+{
+	v->counter = i;
+}
+
+/**
+ * atomic_add - add integer to atomic variable
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic_add(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "addl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub - subtract integer from atomic variable
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic_sub(int i, atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "subl %1,%0"
+		     : "+m" (v->counter)
+		     : "ir" (i));
+}
+
+/**
+ * atomic_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer of type atomic_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic_sub_and_test(int i, atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * atomic_inc - increment atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic_inc(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "incl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec - decrement atomic variable
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic_dec(atomic_t *v)
+{
+	asm volatile(LOCK_PREFIX "decl %0"
+		     : "+m" (v->counter));
+}
+
+/**
+ * atomic_dec_and_test - decrement and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic_dec_and_test(atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "decl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic_inc_and_test - increment and test
+ * @v: pointer of type atomic_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic_inc_and_test(atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "incl %0; sete %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic_add_negative - add and test if negative
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int atomic_add_negative(int i, atomic_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
+		     : "+m" (v->counter), "=qm" (c)
+		     : "ir" (i) : "memory");
+	return c;
+}
+
+/**
+ * atomic_add_return - add integer and return
+ * @i: integer value to add
+ * @v: pointer of type atomic_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline int atomic_add_return(int i, atomic_t *v)
+{
+	int __i;
+#ifdef CONFIG_M386
+	unsigned long flags;
+	if (unlikely(boot_cpu_data.x86 <= 3))
+		goto no_xadd;
+#endif
+	/* Modern 486+ processor */
+	__i = i;
+	asm volatile(LOCK_PREFIX "xaddl %0, %1"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
+	return i + __i;
+
+#ifdef CONFIG_M386
+no_xadd: /* Legacy 386 processor */
+	local_irq_save(flags);
+	__i = atomic_read(v);
+	atomic_set(v, i + __i);
+	local_irq_restore(flags);
+	return i + __i;
+#endif
+}
+
+/**
+ * atomic_sub_return - subtract integer and return
+ * @v: pointer of type atomic_t
+ * @i: integer value to subtract
+ *
+ * Atomically subtracts @i from @v and returns @v - @i
+ */
+static inline int atomic_sub_return(int i, atomic_t *v)
+{
+	return atomic_add_return(-i, v);
+}
+
+#define atomic_inc_return(v)  (atomic_add_return(1, v))
+#define atomic_dec_return(v)  (atomic_sub_return(1, v))
+
+static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline int atomic_xchg(atomic_t *v, int new)
+{
+	return xchg(&v->counter, new);
+}
+
+/**
+ * atomic_add_unless - add unless the number is already a given value
+ * @v: pointer of type atomic_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as @v was not already @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic_add_unless(atomic_t *v, int a, int u)
+{
+	int c, old;
+	c = atomic_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
+
+/**
+ * atomic_inc_short - increment of a short integer
+ * @v: pointer to type int
+ *
+ * Atomically adds 1 to @v
+ * Returns the new value of @u
+ */
+static inline short int atomic_inc_short(short int *v)
+{
+	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
+	return *v;
+}
+
+#ifdef CONFIG_X86_64
+/**
+ * atomic_or_long - OR of two long integers
+ * @v1: pointer to type unsigned long
+ * @v2: pointer to type unsigned long
+ *
+ * Atomically ORs @v1 and @v2
+ * Returns the result of the OR
+ */
+static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
+{
+	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
+}
+#endif
+
+/* These are x86-specific, used by some header files */
+#define atomic_clear_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "andl %0,%1"			\
+		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
+
+#define atomic_set_mask(mask, addr)				\
+	asm volatile(LOCK_PREFIX "orl %0,%1"			\
+		     : : "r" ((unsigned)(mask)), "m" (*(addr))	\
+		     : "memory")
+
+/* Atomic operations are already serializing on x86 */
+#define smp_mb__before_atomic_dec()	barrier()
+#define smp_mb__after_atomic_dec()	barrier()
+#define smp_mb__before_atomic_inc()	barrier()
+#define smp_mb__after_atomic_inc()	barrier()
+
 #ifdef CONFIG_X86_32
-# include "atomic_32.h"
+# include "atomic64_32.h"
 #else
-# include "atomic_64.h"
+# include "atomic64_64.h"
 #endif
+
+#include <asm-generic/atomic-long.h>
+#endif /* _ASM_X86_ATOMIC_H */
diff --git a/arch/x86/include/asm/atomic64_32.h b/arch/x86/include/asm/atomic64_32.h
new file mode 100644
index 0000000..03027bf
--- /dev/null
+++ b/arch/x86/include/asm/atomic64_32.h
@@ -0,0 +1,160 @@
+#ifndef _ASM_X86_ATOMIC64_32_H
+#define _ASM_X86_ATOMIC64_32_H
+
+#include <linux/compiler.h>
+#include <linux/types.h>
+#include <asm/processor.h>
+//#include <asm/cmpxchg.h>
+
+/* An 64bit atomic type */
+
+typedef struct {
+	u64 __aligned(8) counter;
+} atomic64_t;
+
+#define ATOMIC64_INIT(val)	{ (val) }
+
+extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
+
+/**
+ * atomic64_xchg - xchg atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically xchgs the value of @ptr to @new_val and returns
+ * the old value.
+ */
+extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ * @new_val:  value to assign
+ *
+ * Atomically sets the value of @ptr to @new_val.
+ */
+extern void atomic64_set(atomic64_t *ptr, u64 new_val);
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @ptr:      pointer to type atomic64_t
+ *
+ * Atomically reads the value of @ptr and returns it.
+ */
+static inline u64 atomic64_read(atomic64_t *ptr)
+{
+	u64 res;
+
+	/*
+	 * Note, we inline this atomic64_t primitive because
+	 * it only clobbers EAX/EDX and leaves the others
+	 * untouched. We also (somewhat subtly) rely on the
+	 * fact that cmpxchg8b returns the current 64-bit value
+	 * of the memory location we are touching:
+	 */
+	asm volatile(
+		"mov %%ebx, %%eax\n\t"
+		"mov %%ecx, %%edx\n\t"
+		LOCK_PREFIX "cmpxchg8b %1\n"
+			: "=&A" (res)
+			: "m" (*ptr)
+		);
+
+	return res;
+}
+
+extern u64 atomic64_read(atomic64_t *ptr);
+
+/**
+ * atomic64_add_return - add and return
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns @delta + *@ptr
+ */
+extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
+
+/*
+ * Other variants with different arithmetic operators:
+ */
+extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
+extern u64 atomic64_inc_return(atomic64_t *ptr);
+extern u64 atomic64_dec_return(atomic64_t *ptr);
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr.
+ */
+extern void atomic64_add(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr.
+ */
+extern void atomic64_sub(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @delta: integer value to subtract
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically subtracts @delta from @ptr and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1.
+ */
+extern void atomic64_inc(atomic64_t *ptr);
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1.
+ */
+extern void atomic64_dec(atomic64_t *ptr);
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically decrements @ptr by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+extern int atomic64_dec_and_test(atomic64_t *ptr);
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @ptr: pointer to type atomic64_t
+ *
+ * Atomically increments @ptr by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+extern int atomic64_inc_and_test(atomic64_t *ptr);
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @delta: integer value to add
+ * @ptr:   pointer to type atomic64_t
+ *
+ * Atomically adds @delta to @ptr and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
+
+#endif /* _ASM_X86_ATOMIC64_32_H */
diff --git a/arch/x86/include/asm/atomic64_64.h b/arch/x86/include/asm/atomic64_64.h
new file mode 100644
index 0000000..51c5b40
--- /dev/null
+++ b/arch/x86/include/asm/atomic64_64.h
@@ -0,0 +1,224 @@
+#ifndef _ASM_X86_ATOMIC64_64_H
+#define _ASM_X86_ATOMIC64_64_H
+
+#include <linux/types.h>
+#include <asm/alternative.h>
+#include <asm/cmpxchg.h>
+
+/* The 64-bit atomic type */
+
+#define ATOMIC64_INIT(i)	{ (i) }
+
+/**
+ * atomic64_read - read atomic64 variable
+ * @v: pointer of type atomic64_t
+ *
+ * Atomically reads the value of @v.
+ * Doesn't imply a read memory barrier.
+ */
+static inline long atomic64_read(const atomic64_t *v)
+{
+	return v->counter;
+}
+
+/**
+ * atomic64_set - set atomic64 variable
+ * @v: pointer to type atomic64_t
+ * @i: required value
+ *
+ * Atomically sets the value of @v to @i.
+ */
+static inline void atomic64_set(atomic64_t *v, long i)
+{
+	v->counter = i;
+}
+
+/**
+ * atomic64_add - add integer to atomic64 variable
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v.
+ */
+static inline void atomic64_add(long i, atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "addq %1,%0"
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_sub - subtract the atomic64 variable
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically subtracts @i from @v.
+ */
+static inline void atomic64_sub(long i, atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "subq %1,%0"
+		     : "=m" (v->counter)
+		     : "er" (i), "m" (v->counter));
+}
+
+/**
+ * atomic64_sub_and_test - subtract value from variable and test result
+ * @i: integer value to subtract
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically subtracts @i from @v and returns
+ * true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_sub_and_test(long i, atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "er" (i), "m" (v->counter) : "memory");
+	return c;
+}
+
+/**
+ * atomic64_inc - increment atomic64 variable
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically increments @v by 1.
+ */
+static inline void atomic64_inc(atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "incq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec - decrement atomic64 variable
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically decrements @v by 1.
+ */
+static inline void atomic64_dec(atomic64_t *v)
+{
+	asm volatile(LOCK_PREFIX "decq %0"
+		     : "=m" (v->counter)
+		     : "m" (v->counter));
+}
+
+/**
+ * atomic64_dec_and_test - decrement and test
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically decrements @v by 1 and
+ * returns true if the result is 0, or false for all other
+ * cases.
+ */
+static inline int atomic64_dec_and_test(atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "decq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic64_inc_and_test - increment and test
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically increments @v by 1
+ * and returns true if the result is zero, or false for all
+ * other cases.
+ */
+static inline int atomic64_inc_and_test(atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "incq %0; sete %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "m" (v->counter) : "memory");
+	return c != 0;
+}
+
+/**
+ * atomic64_add_negative - add and test if negative
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v and returns true
+ * if the result is negative, or false when
+ * result is greater than or equal to zero.
+ */
+static inline int atomic64_add_negative(long i, atomic64_t *v)
+{
+	unsigned char c;
+
+	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
+		     : "=m" (v->counter), "=qm" (c)
+		     : "er" (i), "m" (v->counter) : "memory");
+	return c;
+}
+
+/**
+ * atomic64_add_return - add and return
+ * @i: integer value to add
+ * @v: pointer to type atomic64_t
+ *
+ * Atomically adds @i to @v and returns @i + @v
+ */
+static inline long atomic64_add_return(long i, atomic64_t *v)
+{
+	long __i = i;
+	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
+		     : "+r" (i), "+m" (v->counter)
+		     : : "memory");
+	return i + __i;
+}
+
+static inline long atomic64_sub_return(long i, atomic64_t *v)
+{
+	return atomic64_add_return(-i, v);
+}
+
+#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
+#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
+
+static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
+{
+	return cmpxchg(&v->counter, old, new);
+}
+
+static inline long atomic64_xchg(atomic64_t *v, long new)
+{
+	return xchg(&v->counter, new);
+}
+
+/**
+ * atomic64_add_unless - add unless the number is a given value
+ * @v: pointer of type atomic64_t
+ * @a: the amount to add to v...
+ * @u: ...unless v is equal to u.
+ *
+ * Atomically adds @a to @v, so long as it was not @u.
+ * Returns non-zero if @v was not @u, and zero otherwise.
+ */
+static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
+{
+	long c, old;
+	c = atomic64_read(v);
+	for (;;) {
+		if (unlikely(c == (u)))
+			break;
+		old = atomic64_cmpxchg((v), c, c + (a));
+		if (likely(old == c))
+			break;
+		c = old;
+	}
+	return c != (u);
+}
+
+#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
+
+#endif /* _ASM_X86_ATOMIC64_64_H */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
deleted file mode 100644
index dc5a667..0000000
--- a/arch/x86/include/asm/atomic_32.h
+++ /dev/null
@@ -1,415 +0,0 @@
-#ifndef _ASM_X86_ATOMIC_32_H
-#define _ASM_X86_ATOMIC_32_H
-
-#include <linux/compiler.h>
-#include <linux/types.h>
-#include <asm/processor.h>
-#include <asm/cmpxchg.h>
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.
- */
-static inline int atomic_read(const atomic_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic_set(atomic_t *v, int i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "addl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub - subtract integer from atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "subl %1,%0"
-		     : "+m" (v->counter)
-		     : "ir" (i));
-}
-
-/**
- * atomic_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_sub_and_test(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_inc - increment atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic_inc(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "incl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec - decrement atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic_dec(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "decl %0"
-		     : "+m" (v->counter));
-}
-
-/**
- * atomic_dec_and_test - decrement and test
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic_dec_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_inc_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_add_negative - add and test if negative
- * @v: pointer of type atomic_t
- * @i: integer value to add
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "+m" (v->counter), "=qm" (c)
-		     : "ir" (i) : "memory");
-	return c;
-}
-
-/**
- * atomic_add_return - add integer and return
- * @v: pointer of type atomic_t
- * @i: integer value to add
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int __i;
-#ifdef CONFIG_M386
-	unsigned long flags;
-	if (unlikely(boot_cpu_data.x86 <= 3))
-		goto no_xadd;
-#endif
-	/* Modern 486+ processor */
-	__i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-
-#ifdef CONFIG_M386
-no_xadd: /* Legacy 386 processor */
-	local_irq_save(flags);
-	__i = atomic_read(v);
-	atomic_set(v, i + __i);
-	local_irq_restore(flags);
-	return i + __i;
-#endif
-}
-
-/**
- * atomic_sub_return - subtract integer and return
- * @v: pointer of type atomic_t
- * @i: integer value to subtract
- *
- * Atomically subtracts @i from @v and returns @v - @i
- */
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return atomic_add_return(-i, v);
-}
-
-static inline int atomic_cmpxchg(atomic_t *v, int old, int new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline int atomic_xchg(atomic_t *v, int new)
-{
-	return xchg(&v->counter, new);
-}
-
-/**
- * atomic_add_unless - add unless the number is already a given value
- * @v: pointer of type atomic_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as @v was not already @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-#define atomic_inc_return(v)  (atomic_add_return(1, v))
-#define atomic_dec_return(v)  (atomic_sub_return(1, v))
-
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "andl %0,%1"			\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)				\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
-		     : : "r" (mask), "m" (*(addr)) : "memory")
-
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-/* An 64bit atomic type */
-
-typedef struct {
-	u64 __aligned(8) counter;
-} atomic64_t;
-
-#define ATOMIC64_INIT(val)	{ (val) }
-
-extern u64 atomic64_cmpxchg(atomic64_t *ptr, u64 old_val, u64 new_val);
-
-/**
- * atomic64_xchg - xchg atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically xchgs the value of @ptr to @new_val and returns
- * the old value.
- */
-extern u64 atomic64_xchg(atomic64_t *ptr, u64 new_val);
-
-/**
- * atomic64_set - set atomic64 variable
- * @ptr:      pointer to type atomic64_t
- * @new_val:  value to assign
- *
- * Atomically sets the value of @ptr to @new_val.
- */
-extern void atomic64_set(atomic64_t *ptr, u64 new_val);
-
-/**
- * atomic64_read - read atomic64 variable
- * @ptr:      pointer to type atomic64_t
- *
- * Atomically reads the value of @ptr and returns it.
- */
-static inline u64 atomic64_read(atomic64_t *ptr)
-{
-	u64 res;
-
-	/*
-	 * Note, we inline this atomic64_t primitive because
-	 * it only clobbers EAX/EDX and leaves the others
-	 * untouched. We also (somewhat subtly) rely on the
-	 * fact that cmpxchg8b returns the current 64-bit value
-	 * of the memory location we are touching:
-	 */
-	asm volatile(
-		"mov %%ebx, %%eax\n\t"
-		"mov %%ecx, %%edx\n\t"
-		LOCK_PREFIX "cmpxchg8b %1\n"
-			: "=&A" (res)
-			: "m" (*ptr)
-		);
-
-	return res;
-}
-
-extern u64 atomic64_read(atomic64_t *ptr);
-
-/**
- * atomic64_add_return - add and return
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns @delta + *@ptr
- */
-extern u64 atomic64_add_return(u64 delta, atomic64_t *ptr);
-
-/*
- * Other variants with different arithmetic operators:
- */
-extern u64 atomic64_sub_return(u64 delta, atomic64_t *ptr);
-extern u64 atomic64_inc_return(atomic64_t *ptr);
-extern u64 atomic64_dec_return(atomic64_t *ptr);
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr.
- */
-extern void atomic64_add(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr.
- */
-extern void atomic64_sub(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_sub_and_test - subtract value from variable and test result
- * @delta: integer value to subtract
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically subtracts @delta from @ptr and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-extern int atomic64_sub_and_test(u64 delta, atomic64_t *ptr);
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1.
- */
-extern void atomic64_inc(atomic64_t *ptr);
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1.
- */
-extern void atomic64_dec(atomic64_t *ptr);
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically decrements @ptr by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-extern int atomic64_dec_and_test(atomic64_t *ptr);
-
-/**
- * atomic64_inc_and_test - increment and test
- * @ptr: pointer to type atomic64_t
- *
- * Atomically increments @ptr by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-extern int atomic64_inc_and_test(atomic64_t *ptr);
-
-/**
- * atomic64_add_negative - add and test if negative
- * @delta: integer value to add
- * @ptr:   pointer to type atomic64_t
- *
- * Atomically adds @delta to @ptr and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-extern int atomic64_add_negative(u64 delta, atomic64_t *ptr);
-
-#include <asm-generic/atomic-long.h>
-#endif /* _ASM_X86_ATOMIC_32_H */
diff --git a/arch/x86/include/asm/atomic_64.h b/arch/x86/include/asm/atomic_64.h
deleted file mode 100644
index d605dc2..0000000
--- a/arch/x86/include/asm/atomic_64.h
+++ /dev/null
@@ -1,485 +0,0 @@
-#ifndef _ASM_X86_ATOMIC_64_H
-#define _ASM_X86_ATOMIC_64_H
-
-#include <linux/types.h>
-#include <asm/alternative.h>
-#include <asm/cmpxchg.h>
-
-/*
- * Atomic operations that C can't guarantee us.  Useful for
- * resource counting etc..
- */
-
-#define ATOMIC_INIT(i)	{ (i) }
-
-/**
- * atomic_read - read atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically reads the value of @v.
- */
-static inline int atomic_read(const atomic_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic_set - set atomic variable
- * @v: pointer of type atomic_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic_set(atomic_t *v, int i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic_add - add integer to atomic variable
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic_add(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "addl %1,%0"
-		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
-}
-
-/**
- * atomic_sub - subtract the atomic variable
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic_sub(int i, atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "subl %1,%0"
-		     : "=m" (v->counter)
-		     : "ir" (i), "m" (v->counter));
-}
-
-/**
- * atomic_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer of type atomic_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_sub_and_test(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subl %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic_inc - increment atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic_inc(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "incl %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic_dec - decrement atomic variable
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic_dec(atomic_t *v)
-{
-	asm volatile(LOCK_PREFIX "decl %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic_dec_and_test - decrement and test
- * @v: pointer of type atomic_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic_dec_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decl %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_inc_and_test - increment and test
- * @v: pointer of type atomic_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic_inc_and_test(atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incl %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic_add_negative - add and test if negative
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic_add_negative(int i, atomic_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addl %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "ir" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic_add_return - add and return
- * @i: integer value to add
- * @v: pointer of type atomic_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline int atomic_add_return(int i, atomic_t *v)
-{
-	int __i = i;
-	asm volatile(LOCK_PREFIX "xaddl %0, %1"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-}
-
-static inline int atomic_sub_return(int i, atomic_t *v)
-{
-	return atomic_add_return(-i, v);
-}
-
-#define atomic_inc_return(v)  (atomic_add_return(1, v))
-#define atomic_dec_return(v)  (atomic_sub_return(1, v))
-
-/* The 64-bit atomic type */
-
-#define ATOMIC64_INIT(i)	{ (i) }
-
-/**
- * atomic64_read - read atomic64 variable
- * @v: pointer of type atomic64_t
- *
- * Atomically reads the value of @v.
- * Doesn't imply a read memory barrier.
- */
-static inline long atomic64_read(const atomic64_t *v)
-{
-	return v->counter;
-}
-
-/**
- * atomic64_set - set atomic64 variable
- * @v: pointer to type atomic64_t
- * @i: required value
- *
- * Atomically sets the value of @v to @i.
- */
-static inline void atomic64_set(atomic64_t *v, long i)
-{
-	v->counter = i;
-}
-
-/**
- * atomic64_add - add integer to atomic64 variable
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v.
- */
-static inline void atomic64_add(long i, atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "addq %1,%0"
-		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
-}
-
-/**
- * atomic64_sub - subtract the atomic64 variable
- * @i: integer value to subtract
- * @v: pointer to type atomic64_t
- *
- * Atomically subtracts @i from @v.
- */
-static inline void atomic64_sub(long i, atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "subq %1,%0"
-		     : "=m" (v->counter)
-		     : "er" (i), "m" (v->counter));
-}
-
-/**
- * atomic64_sub_and_test - subtract value from variable and test result
- * @i: integer value to subtract
- * @v: pointer to type atomic64_t
- *
- * Atomically subtracts @i from @v and returns
- * true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic64_sub_and_test(long i, atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "subq %2,%0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic64_inc - increment atomic64 variable
- * @v: pointer to type atomic64_t
- *
- * Atomically increments @v by 1.
- */
-static inline void atomic64_inc(atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "incq %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic64_dec - decrement atomic64 variable
- * @v: pointer to type atomic64_t
- *
- * Atomically decrements @v by 1.
- */
-static inline void atomic64_dec(atomic64_t *v)
-{
-	asm volatile(LOCK_PREFIX "decq %0"
-		     : "=m" (v->counter)
-		     : "m" (v->counter));
-}
-
-/**
- * atomic64_dec_and_test - decrement and test
- * @v: pointer to type atomic64_t
- *
- * Atomically decrements @v by 1 and
- * returns true if the result is 0, or false for all other
- * cases.
- */
-static inline int atomic64_dec_and_test(atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "decq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic64_inc_and_test - increment and test
- * @v: pointer to type atomic64_t
- *
- * Atomically increments @v by 1
- * and returns true if the result is zero, or false for all
- * other cases.
- */
-static inline int atomic64_inc_and_test(atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "incq %0; sete %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "m" (v->counter) : "memory");
-	return c != 0;
-}
-
-/**
- * atomic64_add_negative - add and test if negative
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v and returns true
- * if the result is negative, or false when
- * result is greater than or equal to zero.
- */
-static inline int atomic64_add_negative(long i, atomic64_t *v)
-{
-	unsigned char c;
-
-	asm volatile(LOCK_PREFIX "addq %2,%0; sets %1"
-		     : "=m" (v->counter), "=qm" (c)
-		     : "er" (i), "m" (v->counter) : "memory");
-	return c;
-}
-
-/**
- * atomic64_add_return - add and return
- * @i: integer value to add
- * @v: pointer to type atomic64_t
- *
- * Atomically adds @i to @v and returns @i + @v
- */
-static inline long atomic64_add_return(long i, atomic64_t *v)
-{
-	long __i = i;
-	asm volatile(LOCK_PREFIX "xaddq %0, %1;"
-		     : "+r" (i), "+m" (v->counter)
-		     : : "memory");
-	return i + __i;
-}
-
-static inline long atomic64_sub_return(long i, atomic64_t *v)
-{
-	return atomic64_add_return(-i, v);
-}
-
-#define atomic64_inc_return(v)  (atomic64_add_return(1, (v)))
-#define atomic64_dec_return(v)  (atomic64_sub_return(1, (v)))
-
-static inline long atomic64_cmpxchg(atomic64_t *v, long old, long new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline long atomic64_xchg(atomic64_t *v, long new)
-{
-	return xchg(&v->counter, new);
-}
-
-static inline long atomic_cmpxchg(atomic_t *v, int old, int new)
-{
-	return cmpxchg(&v->counter, old, new);
-}
-
-static inline long atomic_xchg(atomic_t *v, int new)
-{
-	return xchg(&v->counter, new);
-}
-
-/**
- * atomic_add_unless - add unless the number is a given value
- * @v: pointer of type atomic_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic_add_unless(atomic_t *v, int a, int u)
-{
-	int c, old;
-	c = atomic_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-#define atomic_inc_not_zero(v) atomic_add_unless((v), 1, 0)
-
-/**
- * atomic64_add_unless - add unless the number is a given value
- * @v: pointer of type atomic64_t
- * @a: the amount to add to v...
- * @u: ...unless v is equal to u.
- *
- * Atomically adds @a to @v, so long as it was not @u.
- * Returns non-zero if @v was not @u, and zero otherwise.
- */
-static inline int atomic64_add_unless(atomic64_t *v, long a, long u)
-{
-	long c, old;
-	c = atomic64_read(v);
-	for (;;) {
-		if (unlikely(c == (u)))
-			break;
-		old = atomic64_cmpxchg((v), c, c + (a));
-		if (likely(old == c))
-			break;
-		c = old;
-	}
-	return c != (u);
-}
-
-/**
- * atomic_inc_short - increment of a short integer
- * @v: pointer to type int
- *
- * Atomically adds 1 to @v
- * Returns the new value of @u
- */
-static inline short int atomic_inc_short(short int *v)
-{
-	asm(LOCK_PREFIX "addw $1, %0" : "+m" (*v));
-	return *v;
-}
-
-/**
- * atomic_or_long - OR of two long integers
- * @v1: pointer to type unsigned long
- * @v2: pointer to type unsigned long
- *
- * Atomically ORs @v1 and @v2
- * Returns the result of the OR
- */
-static inline void atomic_or_long(unsigned long *v1, unsigned long v2)
-{
-	asm(LOCK_PREFIX "orq %1, %0" : "+m" (*v1) : "r" (v2));
-}
-
-#define atomic64_inc_not_zero(v) atomic64_add_unless((v), 1, 0)
-
-/* These are x86-specific, used by some header files */
-#define atomic_clear_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "andl %0,%1"				\
-		     : : "r" (~(mask)), "m" (*(addr)) : "memory")
-
-#define atomic_set_mask(mask, addr)					\
-	asm volatile(LOCK_PREFIX "orl %0,%1"				\
-		     : : "r" ((unsigned)(mask)), "m" (*(addr))		\
-		     : "memory")
-
-/* Atomic operations are already serializing on x86 */
-#define smp_mb__before_atomic_dec()	barrier()
-#define smp_mb__after_atomic_dec()	barrier()
-#define smp_mb__before_atomic_inc()	barrier()
-#define smp_mb__after_atomic_inc()	barrier()
-
-#include <asm-generic/atomic-long.h>
-#endif /* _ASM_X86_ATOMIC_64_H */
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index 14f9890..635f03b 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -118,14 +118,20 @@ enum fixed_addresses {
 	 * 256 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * We round it up to the next 256 pages boundary so that we
-	 * can have a single pgd entry and a single pte table:
+	 * If necessary we round it up to the next 256 pages boundary so
+	 * that we can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
 #define FIX_BTMAPS_SLOTS	4
-	FIX_BTMAP_END = __end_of_permanent_fixed_addresses + 256 -
-			(__end_of_permanent_fixed_addresses & 255),
-	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
+#define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
+	FIX_BTMAP_END =
+	 (__end_of_permanent_fixed_addresses ^
+	  (__end_of_permanent_fixed_addresses + TOTAL_FIX_BTMAPS - 1)) &
+	 -PTRS_PER_PTE
+	 ? __end_of_permanent_fixed_addresses + TOTAL_FIX_BTMAPS -
+	   (__end_of_permanent_fixed_addresses & (TOTAL_FIX_BTMAPS - 1))
+	 : __end_of_permanent_fixed_addresses,
+	FIX_BTMAP_BEGIN = FIX_BTMAP_END + TOTAL_FIX_BTMAPS - 1,
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..606ede1 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -41,6 +41,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/lockdep.h>
+#include <asm/asm.h>
 
 struct rwsem_waiter;
 
@@ -55,17 +56,28 @@ extern asmregparm struct rw_semaphore *
 
 /*
  * the semaphore definition
+ *
+ * The bias values and the counter type limits the number of
+ * potential readers/writers to 32767 for 32 bits and 2147483647
+ * for 64 bits.
  */
 
-#define RWSEM_UNLOCKED_VALUE		0x00000000
-#define RWSEM_ACTIVE_BIAS		0x00000001
-#define RWSEM_ACTIVE_MASK		0x0000ffff
-#define RWSEM_WAITING_BIAS		(-0x00010000)
+#ifdef CONFIG_X86_64
+# define RWSEM_ACTIVE_MASK		0xffffffffL
+#else
+# define RWSEM_ACTIVE_MASK		0x0000ffffL
+#endif
+
+#define RWSEM_UNLOCKED_VALUE		0x00000000L
+#define RWSEM_ACTIVE_BIAS		0x00000001L
+#define RWSEM_WAITING_BIAS		(-RWSEM_ACTIVE_MASK-1)
 #define RWSEM_ACTIVE_READ_BIAS		RWSEM_ACTIVE_BIAS
 #define RWSEM_ACTIVE_WRITE_BIAS		(RWSEM_WAITING_BIAS + RWSEM_ACTIVE_BIAS)
 
+typedef signed long rwsem_count_t;
+
 struct rw_semaphore {
-	signed long		count;
+	rwsem_count_t		count;
 	spinlock_t		wait_lock;
 	struct list_head	wait_list;
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
@@ -105,7 +117,7 @@ do {								\
 static inline void __down_read(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning down_read\n\t"
-		     LOCK_PREFIX "  incl      (%%eax)\n\t"
+		     LOCK_PREFIX _ASM_INC "(%1)\n\t"
 		     /* adds 0x00000001, returns the old value */
 		     "  jns        1f\n"
 		     "  call call_rwsem_down_read_failed\n"
@@ -121,14 +133,14 @@ static inline void __down_read(struct rw_semaphore *sem)
  */
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
-	__s32 result, tmp;
+	rwsem_count_t result, tmp;
 	asm volatile("# beginning __down_read_trylock\n\t"
-		     "  movl      %0,%1\n\t"
+		     "  mov          %0,%1\n\t"
 		     "1:\n\t"
-		     "  movl	     %1,%2\n\t"
-		     "  addl      %3,%2\n\t"
+		     "  mov          %1,%2\n\t"
+		     "  add          %3,%2\n\t"
 		     "  jle	     2f\n\t"
-		     LOCK_PREFIX "  cmpxchgl  %2,%0\n\t"
+		     LOCK_PREFIX "  cmpxchg  %2,%0\n\t"
 		     "  jnz	     1b\n\t"
 		     "2:\n\t"
 		     "# ending __down_read_trylock\n\t"
@@ -143,13 +155,13 @@ static inline int __down_read_trylock(struct rw_semaphore *sem)
  */
 static inline void __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
-	int tmp;
+	rwsem_count_t tmp;
 
 	tmp = RWSEM_ACTIVE_WRITE_BIAS;
 	asm volatile("# beginning down_write\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtract 0x0000ffff, returns the old value */
-		     "  testl     %%edx,%%edx\n\t"
+		     "  test      %1,%1\n\t"
 		     /* was the count 0 before? */
 		     "  jz        1f\n"
 		     "  call call_rwsem_down_write_failed\n"
@@ -170,9 +182,9 @@ static inline void __down_write(struct rw_semaphore *sem)
  */
 static inline int __down_write_trylock(struct rw_semaphore *sem)
 {
-	signed long ret = cmpxchg(&sem->count,
-				  RWSEM_UNLOCKED_VALUE,
-				  RWSEM_ACTIVE_WRITE_BIAS);
+	rwsem_count_t ret = cmpxchg(&sem->count,
+				    RWSEM_UNLOCKED_VALUE,
+				    RWSEM_ACTIVE_WRITE_BIAS);
 	if (ret == RWSEM_UNLOCKED_VALUE)
 		return 1;
 	return 0;
@@ -183,9 +195,9 @@ static inline int __down_write_trylock(struct rw_semaphore *sem)
  */
 static inline void __up_read(struct rw_semaphore *sem)
 {
-	__s32 tmp = -RWSEM_ACTIVE_READ_BIAS;
+	rwsem_count_t tmp = -RWSEM_ACTIVE_READ_BIAS;
 	asm volatile("# beginning __up_read\n\t"
-		     LOCK_PREFIX "  xadd      %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* subtracts 1, returns the old value */
 		     "  jns        1f\n\t"
 		     "  call call_rwsem_wake\n"
@@ -201,18 +213,18 @@ static inline void __up_read(struct rw_semaphore *sem)
  */
 static inline void __up_write(struct rw_semaphore *sem)
 {
+	rwsem_count_t tmp;
 	asm volatile("# beginning __up_write\n\t"
-		     "  movl      %2,%%edx\n\t"
-		     LOCK_PREFIX "  xaddl     %%edx,(%%eax)\n\t"
+		     LOCK_PREFIX "  xadd      %1,(%2)\n\t"
 		     /* tries to transition
 			0xffff0001 -> 0x00000000 */
 		     "  jz       1f\n"
 		     "  call call_rwsem_wake\n"
 		     "1:\n\t"
 		     "# ending __up_write\n"
-		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_ACTIVE_WRITE_BIAS)
-		     : "memory", "cc", "edx");
+		     : "+m" (sem->count), "=d" (tmp)
+		     : "a" (sem), "1" (-RWSEM_ACTIVE_WRITE_BIAS)
+		     : "memory", "cc");
 }
 
 /*
@@ -221,33 +233,38 @@ static inline void __up_write(struct rw_semaphore *sem)
 static inline void __downgrade_write(struct rw_semaphore *sem)
 {
 	asm volatile("# beginning __downgrade_write\n\t"
-		     LOCK_PREFIX "  addl      %2,(%%eax)\n\t"
-		     /* transitions 0xZZZZ0001 -> 0xYYYY0001 */
+		     LOCK_PREFIX _ASM_ADD "%2,(%1)\n\t"
+		     /*
+		      * transitions 0xZZZZ0001 -> 0xYYYY0001 (i386)
+		      *     0xZZZZZZZZ00000001 -> 0xYYYYYYYY00000001 (x86_64)
+		      */
 		     "  jns       1f\n\t"
 		     "  call call_rwsem_downgrade_wake\n"
 		     "1:\n\t"
 		     "# ending __downgrade_write\n"
 		     : "+m" (sem->count)
-		     : "a" (sem), "i" (-RWSEM_WAITING_BIAS)
+		     : "a" (sem), "er" (-RWSEM_WAITING_BIAS)
 		     : "memory", "cc");
 }
 
 /*
  * implement atomic add functionality
  */
-static inline void rwsem_atomic_add(int delta, struct rw_semaphore *sem)
+static inline void rwsem_atomic_add(rwsem_count_t delta,
+				    struct rw_semaphore *sem)
 {
-	asm volatile(LOCK_PREFIX "addl %1,%0"
+	asm volatile(LOCK_PREFIX _ASM_ADD "%1,%0"
 		     : "+m" (sem->count)
-		     : "ir" (delta));
+		     : "er" (delta));
 }
 
 /*
  * implement exchange and add functionality
  */
-static inline int rwsem_atomic_update(int delta, struct rw_semaphore *sem)
+static inline rwsem_count_t rwsem_atomic_update(rwsem_count_t delta,
+						struct rw_semaphore *sem)
 {
-	int tmp = delta;
+	rwsem_count_t tmp = delta;
 
 	asm volatile(LOCK_PREFIX "xadd %0,%1"
 		     : "+r" (tmp), "+m" (sem->count)
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 46324c6..a78c403 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -8,6 +8,8 @@
 #include <linux/errno.h>
 #include <linux/prefetch.h>
 #include <linux/lockdep.h>
+#include <asm/alternative.h>
+#include <asm/cpufeature.h>
 #include <asm/page.h>
 
 /*
@@ -16,7 +18,24 @@
 
 /* Handles exceptions in both to and from, but doesn't do access_ok */
 __must_check unsigned long
-copy_user_generic(void *to, const void *from, unsigned len);
+copy_user_generic_string(void *to, const void *from, unsigned len);
+__must_check unsigned long
+copy_user_generic_unrolled(void *to, const void *from, unsigned len);
+
+static __always_inline __must_check unsigned long
+copy_user_generic(void *to, const void *from, unsigned len)
+{
+	unsigned ret;
+
+	alternative_call(copy_user_generic_unrolled,
+			 copy_user_generic_string,
+			 X86_FEATURE_REP_GOOD,
+			 ASM_OUTPUT2("=a" (ret), "=D" (to), "=S" (from),
+				     "=d" (len)),
+			 "1" (to), "2" (from), "3" (len)
+			 : "memory", "rcx", "r8", "r9", "r10", "r11");
+	return ret;
+}
 
 __must_check unsigned long
 _copy_to_user(void __user *to, const void *from, unsigned len);
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de7353c..2589ea4 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -205,7 +205,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 					 struct alt_instr *end)
 {
 	struct alt_instr *a;
-	char insnbuf[MAX_PATCH_LEN];
+	u8 insnbuf[MAX_PATCH_LEN];
 
 	DPRINTK("%s: alt table %p -> %p\n", __func__, start, end);
 	for (a = start; a < end; a++) {
@@ -223,6 +223,8 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		}
 #endif
 		memcpy(insnbuf, a->replacement, a->replacementlen);
+		if (*insnbuf == 0xe8 && a->replacementlen == 5)
+		    *(s32 *)(insnbuf + 1) += a->replacement - a->instr;
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index fc6c8ef..c2b722d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -31,6 +31,8 @@ struct _cache_table {
 	short size;
 };
 
+#define MB(x)	((x) * 1024)
+
 /* All the cache descriptor types we care about (no TLB or
    trace cache entries) */
 
@@ -44,9 +46,9 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x0d, LVL_1_DATA, 16 },	/* 4-way set assoc, 64 byte line size */
 	{ 0x21, LVL_2,      256 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x22, LVL_3,      512 },	/* 4-way set assoc, sectored cache, 64 byte line size */
-	{ 0x23, LVL_3,      1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x25, LVL_3,      2048 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x29, LVL_3,      4096 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x23, LVL_3,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x25, LVL_3,      MB(2) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x29, LVL_3,      MB(4) },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x2c, LVL_1_DATA, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x30, LVL_1_INST, 32 },	/* 8-way set assoc, 64 byte line size */
 	{ 0x39, LVL_2,      128 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -59,16 +61,16 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x41, LVL_2,      128 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x42, LVL_2,      256 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x43, LVL_2,      512 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x44, LVL_2,      1024 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x45, LVL_2,      2048 },	/* 4-way set assoc, 32 byte line size */
-	{ 0x46, LVL_3,      4096 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x47, LVL_3,      8192 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x49, LVL_3,      4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4a, LVL_3,      6144 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4b, LVL_3,      8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4c, LVL_3,     12288 },	/* 12-way set assoc, 64 byte line size */
-	{ 0x4d, LVL_3,     16384 },	/* 16-way set assoc, 64 byte line size */
-	{ 0x4e, LVL_2,      6144 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x44, LVL_2,      MB(1) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x45, LVL_2,      MB(2) },	/* 4-way set assoc, 32 byte line size */
+	{ 0x46, LVL_3,      MB(4) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x47, LVL_3,      MB(8) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x49, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4a, LVL_3,      MB(6) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4b, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4c, LVL_3,      MB(12) },	/* 12-way set assoc, 64 byte line size */
+	{ 0x4d, LVL_3,      MB(16) },	/* 16-way set assoc, 64 byte line size */
+	{ 0x4e, LVL_2,      MB(6) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x60, LVL_1_DATA, 16 },	/* 8-way set assoc, sectored cache, 64 byte line size */
 	{ 0x66, LVL_1_DATA, 8 },	/* 4-way set assoc, sectored cache, 64 byte line size */
 	{ 0x67, LVL_1_DATA, 16 },	/* 4-way set assoc, sectored cache, 64 byte line size */
@@ -77,34 +79,34 @@ static const struct _cache_table __cpuinitconst cache_table[] =
 	{ 0x71, LVL_TRACE,  16 },	/* 8-way set assoc */
 	{ 0x72, LVL_TRACE,  32 },	/* 8-way set assoc */
 	{ 0x73, LVL_TRACE,  64 },	/* 8-way set assoc */
-	{ 0x78, LVL_2,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x79, LVL_2,     128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7a, LVL_2,     256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7b, LVL_2,     512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7c, LVL_2,    1024 },	/* 8-way set assoc, sectored cache, 64 byte line size */
-	{ 0x7d, LVL_2,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0x7f, LVL_2,     512 },	/* 2-way set assoc, 64 byte line size */
-	{ 0x82, LVL_2,     256 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x83, LVL_2,     512 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x84, LVL_2,    1024 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x85, LVL_2,    2048 },	/* 8-way set assoc, 32 byte line size */
-	{ 0x86, LVL_2,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0x87, LVL_2,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd0, LVL_3,     512 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd1, LVL_3,    1024 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd2, LVL_3,    2048 },	/* 4-way set assoc, 64 byte line size */
-	{ 0xd6, LVL_3,    1024 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd7, LVL_3,    2048 },	/* 8-way set assoc, 64 byte line size */
-	{ 0xd8, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdc, LVL_3,    2048 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xdd, LVL_3,    4096 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xde, LVL_3,    8192 },	/* 12-way set assoc, 64 byte line size */
-	{ 0xe2, LVL_3,    2048 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe3, LVL_3,    4096 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xe4, LVL_3,    8192 },	/* 16-way set assoc, 64 byte line size */
-	{ 0xea, LVL_3,    12288 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xeb, LVL_3,    18432 },	/* 24-way set assoc, 64 byte line size */
-	{ 0xec, LVL_3,    24576 },	/* 24-way set assoc, 64 byte line size */
+	{ 0x78, LVL_2,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0x79, LVL_2,      128 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7a, LVL_2,      256 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7b, LVL_2,      512 },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7c, LVL_2,      MB(1) },	/* 8-way set assoc, sectored cache, 64 byte line size */
+	{ 0x7d, LVL_2,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0x7f, LVL_2,      512 },	/* 2-way set assoc, 64 byte line size */
+	{ 0x82, LVL_2,      256 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x83, LVL_2,      512 },	/* 8-way set assoc, 32 byte line size */
+	{ 0x84, LVL_2,      MB(1) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x85, LVL_2,      MB(2) },	/* 8-way set assoc, 32 byte line size */
+	{ 0x86, LVL_2,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0x87, LVL_2,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd0, LVL_3,      512 },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd1, LVL_3,      MB(1) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd2, LVL_3,      MB(2) },	/* 4-way set assoc, 64 byte line size */
+	{ 0xd6, LVL_3,      MB(1) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd7, LVL_3,      MB(2) },	/* 8-way set assoc, 64 byte line size */
+	{ 0xd8, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdc, LVL_3,      MB(2) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xdd, LVL_3,      MB(4) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xde, LVL_3,      MB(8) },	/* 12-way set assoc, 64 byte line size */
+	{ 0xe2, LVL_3,      MB(2) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe3, LVL_3,      MB(4) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xe4, LVL_3,      MB(8) },	/* 16-way set assoc, 64 byte line size */
+	{ 0xea, LVL_3,      MB(12) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xeb, LVL_3,      MB(18) },	/* 24-way set assoc, 64 byte line size */
+	{ 0xec, LVL_3,      MB(24) },	/* 24-way set assoc, 64 byte line size */
 	{ 0x00, 0, 0}
 };
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 98c2cde..cf1e04b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -92,6 +92,13 @@ void exit_thread(void)
 	}
 }
 
+void show_regs(struct pt_regs *regs)
+{
+	show_registers(regs);
+	show_trace(NULL, regs, (unsigned long *)kernel_stack_pointer(regs),
+		   regs->bp);
+}
+
 void show_regs_common(void)
 {
 	const char *board, *product;
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 9c517b5..fe6a34e 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -174,12 +174,6 @@ void __show_regs(struct pt_regs *regs, int all)
 			d6, d7);
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, &regs->sp, regs->bp);
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	BUG_ON(dead_task->mm);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 52fbd0c..418f860 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -211,12 +211,6 @@ void __show_regs(struct pt_regs *regs, int all)
 	printk(KERN_INFO "DR3: %016lx DR6: %016lx DR7: %016lx\n", d3, d6, d7);
 }
 
-void show_regs(struct pt_regs *regs)
-{
-	show_registers(regs);
-	show_trace(NULL, regs, (void *)(regs + 1), regs->bp);
-}
-
 void release_thread(struct task_struct *dead_task)
 {
 	if (dead_task->mm) {
diff --git a/arch/x86/kernel/x8664_ksyms_64.c b/arch/x86/kernel/x8664_ksyms_64.c
index 619f7f8..693920b 100644
--- a/arch/x86/kernel/x8664_ksyms_64.c
+++ b/arch/x86/kernel/x8664_ksyms_64.c
@@ -26,7 +26,8 @@ EXPORT_SYMBOL(__put_user_2);
 EXPORT_SYMBOL(__put_user_4);
 EXPORT_SYMBOL(__put_user_8);
 
-EXPORT_SYMBOL(copy_user_generic);
+EXPORT_SYMBOL(copy_user_generic_string);
+EXPORT_SYMBOL(copy_user_generic_unrolled);
 EXPORT_SYMBOL(__copy_user_nocache);
 EXPORT_SYMBOL(_copy_from_user);
 EXPORT_SYMBOL(_copy_to_user);
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index cffd754..c802451 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -39,4 +39,5 @@ else
         lib-y += thunk_64.o clear_page_64.o copy_page_64.o
         lib-y += memmove_64.o memset_64.o
         lib-y += copy_user_64.o rwlock_64.o copy_user_nocache_64.o
+	lib-$(CONFIG_RWSEM_XCHGADD_ALGORITHM) += rwsem_64.o
 endif
diff --git a/arch/x86/lib/copy_user_64.S b/arch/x86/lib/copy_user_64.S
index cf889d4..71100c9 100644
--- a/arch/x86/lib/copy_user_64.S
+++ b/arch/x86/lib/copy_user_64.S
@@ -90,12 +90,6 @@ ENTRY(_copy_from_user)
 	CFI_ENDPROC
 ENDPROC(_copy_from_user)
 
-ENTRY(copy_user_generic)
-	CFI_STARTPROC
-	ALTERNATIVE_JUMP X86_FEATURE_REP_GOOD,copy_user_generic_unrolled,copy_user_generic_string
-	CFI_ENDPROC
-ENDPROC(copy_user_generic)
-
 	.section .fixup,"ax"
 	/* must zero dest */
 ENTRY(bad_from_user)
diff --git a/arch/x86/lib/memcpy_64.S b/arch/x86/lib/memcpy_64.S
index ad5441e..f82e884 100644
--- a/arch/x86/lib/memcpy_64.S
+++ b/arch/x86/lib/memcpy_64.S
@@ -20,12 +20,11 @@
 /*
  * memcpy_c() - fast string ops (REP MOVSQ) based variant.
  *
- * Calls to this get patched into the kernel image via the
+ * This gets patched over the unrolled variant (below) via the
  * alternative instructions framework:
  */
-	ALIGN
-memcpy_c:
-	CFI_STARTPROC
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemcpy_c:
 	movq %rdi, %rax
 
 	movl %edx, %ecx
@@ -35,8 +34,8 @@ memcpy_c:
 	movl %edx, %ecx
 	rep movsb
 	ret
-	CFI_ENDPROC
-ENDPROC(memcpy_c)
+.Lmemcpy_e:
+	.previous
 
 ENTRY(__memcpy)
 ENTRY(memcpy)
@@ -128,16 +127,10 @@ ENDPROC(__memcpy)
 	 * It is also a lot simpler. Use this when possible:
 	 */
 
-	.section .altinstr_replacement, "ax"
-1:	.byte 0xeb				/* jmp <disp8> */
-	.byte (memcpy_c - memcpy) - (2f - 1b)	/* offset */
-2:
-	.previous
-
 	.section .altinstructions, "a"
 	.align 8
 	.quad memcpy
-	.quad 1b
+	.quad .Lmemcpy_c
 	.byte X86_FEATURE_REP_GOOD
 
 	/*
@@ -145,6 +138,6 @@ ENDPROC(__memcpy)
 	 * so it is silly to overwrite itself with nops - reboot is the
 	 * only outcome...
 	 */
-	.byte 2b - 1b
-	.byte 2b - 1b
+	.byte .Lmemcpy_e - .Lmemcpy_c
+	.byte .Lmemcpy_e - .Lmemcpy_c
 	.previous
diff --git a/arch/x86/lib/memset_64.S b/arch/x86/lib/memset_64.S
index 2c59481..e88d3b8 100644
--- a/arch/x86/lib/memset_64.S
+++ b/arch/x86/lib/memset_64.S
@@ -12,9 +12,8 @@
  * 
  * rax   original destination
  */	
-	ALIGN
-memset_c:
-	CFI_STARTPROC
+	.section .altinstr_replacement, "ax", @progbits
+.Lmemset_c:
 	movq %rdi,%r9
 	movl %edx,%r8d
 	andl $7,%r8d
@@ -29,8 +28,8 @@ memset_c:
 	rep stosb
 	movq %r9,%rax
 	ret
-	CFI_ENDPROC
-ENDPROC(memset_c)
+.Lmemset_e:
+	.previous
 
 ENTRY(memset)
 ENTRY(__memset)
@@ -118,16 +117,11 @@ ENDPROC(__memset)
 
 #include <asm/cpufeature.h>
 
-	.section .altinstr_replacement,"ax"
-1:	.byte 0xeb				/* jmp <disp8> */
-	.byte (memset_c - memset) - (2f - 1b)	/* offset */
-2:
-	.previous
 	.section .altinstructions,"a"
 	.align 8
 	.quad memset
-	.quad 1b
+	.quad .Lmemset_c
 	.byte X86_FEATURE_REP_GOOD
 	.byte .Lfinal - memset
-	.byte 2b - 1b
+	.byte .Lmemset_e - .Lmemset_c
 	.previous
diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
new file mode 100644
index 0000000..15acecf
--- /dev/null
+++ b/arch/x86/lib/rwsem_64.S
@@ -0,0 +1,81 @@
+/*
+ * x86-64 rwsem wrappers
+ *
+ * This interfaces the inline asm code to the slow-path
+ * C routines. We need to save the call-clobbered regs
+ * that the asm does not mark as clobbered, and move the
+ * argument from %rax to %rdi.
+ *
+ * NOTE! We don't need to save %rax, because the functions
+ * will always return the semaphore pointer in %rax (which
+ * is also the input argument to these helpers)
+ *
+ * The following can clobber %rdx because the asm clobbers it:
+ *   call_rwsem_down_write_failed
+ *   call_rwsem_wake
+ * but %rdi, %rsi, %rcx, %r8-r11 always need saving.
+ */
+
+#include <linux/linkage.h>
+#include <asm/rwlock.h>
+#include <asm/alternative-asm.h>
+#include <asm/frame.h>
+#include <asm/dwarf2.h>
+
+#define save_common_regs \
+	pushq %rdi; \
+	pushq %rsi; \
+	pushq %rcx; \
+	pushq %r8; \
+	pushq %r9; \
+	pushq %r10; \
+	pushq %r11
+
+#define restore_common_regs \
+	popq %r11; \
+	popq %r10; \
+	popq %r9; \
+	popq %r8; \
+	popq %rcx; \
+	popq %rsi; \
+	popq %rdi
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_down_read_failed)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_down_read_failed
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_read_failed)
+
+ENTRY(call_rwsem_down_write_failed)
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_down_write_failed
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_down_write_failed)
+
+ENTRY(call_rwsem_wake)
+	decw %dx    /* do nothing if still outstanding active readers */
+	jnz 1f
+	save_common_regs
+	movq %rax,%rdi
+	call rwsem_wake
+	restore_common_regs
+1:	ret
+	ENDPROC(call_rwsem_wake)
+
+/* Fix up special calling conventions */
+ENTRY(call_rwsem_downgrade_wake)
+	save_common_regs
+	pushq %rdx
+	movq %rax,%rdi
+	call rwsem_downgrade_wake
+	popq %rdx
+	restore_common_regs
+	ret
+	ENDPROC(call_rwsem_downgrade_wake)
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index c246d25..03c75ff 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -422,6 +422,10 @@ void __init early_ioremap_init(void)
 	 * The boot-ioremap range spans multiple pmds, for which
 	 * we are not prepared:
 	 */
+#define __FIXADDR_TOP (-PAGE_SIZE)
+	BUILD_BUG_ON((__fix_to_virt(FIX_BTMAP_BEGIN) >> PMD_SHIFT)
+		     != (__fix_to_virt(FIX_BTMAP_END) >> PMD_SHIFT));
+#undef __FIXADDR_TOP
 	if (pmd != early_ioremap_pmd(fix_to_virt(FIX_BTMAP_END))) {
 		WARN_ON(1);
 		printk(KERN_WARNING "pmd %p != %p\n",
diff --git a/lib/hweight.c b/lib/hweight.c
index 389424e..63ee4eb 100644
--- a/lib/hweight.c
+++ b/lib/hweight.c
@@ -11,11 +11,18 @@
 
 unsigned int hweight32(unsigned int w)
 {
+#ifdef ARCH_HAS_FAST_MULTIPLIER
+	w -= (w >> 1) & 0x55555555;
+	w =  (w & 0x33333333) + ((w >> 2) & 0x33333333);
+	w =  (w + (w >> 4)) & 0x0f0f0f0f;
+	return (w * 0x01010101) >> 24;
+#else
 	unsigned int res = w - ((w >> 1) & 0x55555555);
 	res = (res & 0x33333333) + ((res >> 2) & 0x33333333);
 	res = (res + (res >> 4)) & 0x0F0F0F0F;
 	res = res + (res >> 8);
 	return (res + (res >> 16)) & 0x000000FF;
+#endif
 }
 EXPORT_SYMBOL(hweight32);
 
