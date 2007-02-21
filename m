Return-Path: <linux-kernel-owner+w=401wt.eu-S1751214AbXBULLa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751214AbXBULLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 06:11:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbXBULLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 06:11:30 -0500
Received: from a222036.upc-a.chello.nl ([62.163.222.36]:44537 "EHLO
	laptopd505.fenrus.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751205AbXBULL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 06:11:28 -0500
Subject: patch to use more symbolic constants in asm
From: Arjan van de Ven <arjan@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: ak@suse.de, akpm@osdl.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 21 Feb 2007 12:10:42 +0100
Message-Id: <1172056242.3531.181.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Use symbolic constants in inline assembly

This patch replaces several of the %0/%1 uses in x86-64 inline assembly
with symbolic names (this is a new gcc 3.x feature, but that's ok now).
This tends to, imo, make the inline assembly a lot more readable, and
for sure it's less error prone in terms of finding which %<number>
corresponds with which variable.

objdump -d of the vmlinux before and after the patch is the same; also
boot tested.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


---
 include/asm-x86_64/bitops.h      |   89 +++++++++++++++++++++++----------------
 include/asm-x86_64/local.h       |   24 +++++-----
 include/asm-x86_64/mmu_context.h |    2 
 include/asm-x86_64/processor.h   |   22 ++++-----
 include/asm-x86_64/semaphore.h   |   22 +++++----
 include/asm-x86_64/signal.h      |   21 +++++++--
 include/asm-x86_64/spinlock.h    |   36 +++++++--------
 include/asm-x86_64/system.h      |   10 ++--
 include/asm-x86_64/tlbflush.h    |   10 ++--
 9 files changed, 134 insertions(+), 102 deletions(-)

Index: linux-2.6.21-rc1/include/asm-x86_64/bitops.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/bitops.h
+++ linux-2.6.21-rc1/include/asm-x86_64/bitops.h
@@ -10,9 +10,9 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *) addr)
+#define ADDR [addr] "=m" (*(volatile long *) addr)
 #else
-#define ADDR "+m" (*(volatile long *) addr)
+#define ADDR [addr] "+m" (*(volatile long *) addr)
 #endif
 
 /**
@@ -28,9 +28,9 @@
 static __inline__ void set_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
-		"btsl %1,%0"
+		"btsl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr) : "memory");
+		: [nr] "dIr" (nr) : "memory");
 }
 
 /**
@@ -45,9 +45,9 @@ static __inline__ void set_bit(int nr, v
 static __inline__ void __set_bit(int nr, volatile void * addr)
 {
 	__asm__ volatile(
-		"btsl %1,%0"
+		"btsl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr) : "memory");
+		: [nr] "dIr" (nr) : "memory");
 }
 
 /**
@@ -63,17 +63,17 @@ static __inline__ void __set_bit(int nr,
 static __inline__ void clear_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
-		"btrl %1,%0"
+		"btrl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr));
+		: [nr] "dIr" (nr));
 }
 
 static __inline__ void __clear_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__(
-		"btrl %1,%0"
+		"btrl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr));
+		: [nr] "dIr" (nr));
 }
 
 #define smp_mb__before_clear_bit()	barrier()
@@ -91,9 +91,9 @@ static __inline__ void __clear_bit(int n
 static __inline__ void __change_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__(
-		"btcl %1,%0"
+		"btcl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr));
+		: [nr] "dIr" (nr));
 }
 
 /**
@@ -108,9 +108,9 @@ static __inline__ void __change_bit(int 
 static __inline__ void change_bit(int nr, volatile void * addr)
 {
 	__asm__ __volatile__( LOCK_PREFIX
-		"btcl %1,%0"
+		"btcl %[nr],%[addr]"
 		:ADDR
-		:"dIr" (nr));
+		:[nr] "dIr" (nr));
 }
 
 /**
@@ -126,9 +126,12 @@ static __inline__ int test_and_set_bit(i
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
-		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr) : "memory");
+		"btsl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		 ADDR
+		: [nr] "dIr" (nr)
+		: "memory");
 	return oldbit;
 }
 
@@ -146,9 +149,11 @@ static __inline__ int __test_and_set_bit
 	int oldbit;
 
 	__asm__(
-		"btsl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr));
+		"btsl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		  ADDR
+		: [nr] "dIr" (nr));
 	return oldbit;
 }
 
@@ -165,9 +170,11 @@ static __inline__ int test_and_clear_bit
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
-		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr) : "memory");
+		"btrl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		  ADDR
+		: [nr] "dIr" (nr) : "memory");
 	return oldbit;
 }
 
@@ -185,9 +192,11 @@ static __inline__ int __test_and_clear_b
 	int oldbit;
 
 	__asm__(
-		"btrl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr));
+		"btrl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		  ADDR
+		: [nr] "dIr" (nr));
 	return oldbit;
 }
 
@@ -197,9 +206,12 @@ static __inline__ int __test_and_change_
 	int oldbit;
 
 	__asm__ __volatile__(
-		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr) : "memory");
+		"btcl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		  ADDR
+		: [nr] "dIr" (nr)
+		: "memory");
 	return oldbit;
 }
 
@@ -216,9 +228,12 @@ static __inline__ int test_and_change_bi
 	int oldbit;
 
 	__asm__ __volatile__( LOCK_PREFIX
-		"btcl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit),ADDR
-		:"dIr" (nr) : "memory");
+		"btcl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit),
+		  ADDR
+		: [nr] "dIr" (nr)
+		: "memory");
 	return oldbit;
 }
 
@@ -241,9 +256,11 @@ static __inline__ int variable_test_bit(
 	int oldbit;
 
 	__asm__ __volatile__(
-		"btl %2,%1\n\tsbbl %0,%0"
-		:"=r" (oldbit)
-		:"m" (*(volatile long *)addr),"dIr" (nr));
+		"btl %[nr],%[addr]\n\t"
+		"sbbl %[oldbit],%[oldbit]"
+		: [oldbit] "=r" (oldbit)
+		: [addr] "m" (*(volatile long *)addr),
+		  [nr] "dIr" (nr));
 	return oldbit;
 }
 
@@ -262,7 +279,7 @@ extern long find_next_bit(const unsigned
 /* return index of first bet set in val or max when no bit is set */
 static inline unsigned long __scanbit(unsigned long val, unsigned long max)
 {
-	asm("bsfq %1,%0 ; cmovz %2,%0" : "=&r" (val) : "r" (val), "r" (max));
+	asm("bsfq %[val2],%[val] ; cmovz %[max],%[val]" : [val] "=&r" (val) : [val2] "r" (val), [max] "r" (max));
 	return val;
 }
 
Index: linux-2.6.21-rc1/include/asm-x86_64/local.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/local.h
+++ linux-2.6.21-rc1/include/asm-x86_64/local.h
@@ -16,33 +16,35 @@ typedef struct
 static inline void local_inc(local_t *v)
 {
 	__asm__ __volatile__(
-		"incq %0"
-		:"=m" (v->counter)
-		:"m" (v->counter));
+		"incq %[counter]"
+		: [counter] "=m" (v->counter)
+		: "m" (v->counter));
 }
 
 static inline void local_dec(local_t *v)
 {
 	__asm__ __volatile__(
-		"decq %0"
-		:"=m" (v->counter)
+		"decq %[counter]"
+		: [counter] "=m" (v->counter)
 		:"m" (v->counter));
 }
 
 static inline void local_add(long i, local_t *v)
 {
 	__asm__ __volatile__(
-		"addq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+		"addq %[i],%[counter]"
+		: [counter]"=m" (v->counter)
+		: [i] "ir" (i),
+		  "m" (v->counter));
 }
 
 static inline void local_sub(long i, local_t *v)
 {
 	__asm__ __volatile__(
-		"subq %1,%0"
-		:"=m" (v->counter)
-		:"ir" (i), "m" (v->counter));
+		"subq %[i],%[counter]"
+		: [counter] "=m" (v->counter)
+		: [i] "ir" (i),
+		  "m" (v->counter));
 }
 
 /* On x86-64 these are better than the atomic variants on SMP kernels
Index: linux-2.6.21-rc1/include/asm-x86_64/mmu_context.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/mmu_context.h
+++ linux-2.6.21-rc1/include/asm-x86_64/mmu_context.h
@@ -24,7 +24,7 @@ static inline void enter_lazy_tlb(struct
 
 static inline void load_cr3(pgd_t *pgd)
 {
-	asm volatile("movq %0,%%cr3" :: "r" (__pa(pgd)) : "memory");
+	asm volatile("movq %[pgd],%%cr3" :: [pgd] "r" (__pa(pgd)) : "memory");
 }
 
 static inline void switch_mm(struct mm_struct *prev, struct mm_struct *next, 
Index: linux-2.6.21-rc1/include/asm-x86_64/processor.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/processor.h
+++ linux-2.6.21-rc1/include/asm-x86_64/processor.h
@@ -41,7 +41,7 @@
  * Default implementation of macro that returns current
  * instruction pointer ("program counter").
  */
-#define current_text_addr() ({ void *pc; asm volatile("leaq 1f(%%rip),%0\n1:":"=r"(pc)); pc; })
+#define current_text_addr() ({ void *pc; asm volatile("leaq 1f(%%rip),%[pc]\n1:": [pc] "=r"(pc)); pc; })
 
 /*
  *  CPU type and hardware bug flags. Kept separately for each CPU.
@@ -150,9 +150,9 @@ static inline void set_in_cr4 (unsigned 
 {
 	mmu_cr4_features |= mask;
 	__asm__("movq %%cr4,%%rax\n\t"
-		"orq %0,%%rax\n\t"
+		"orq %[mask],%%rax\n\t"
 		"movq %%rax,%%cr4\n"
-		: : "irg" (mask)
+		: : [mask] "irg" (mask)
 		:"ax");
 }
 
@@ -160,9 +160,9 @@ static inline void clear_in_cr4 (unsigne
 {
 	mmu_cr4_features &= ~mask;
 	__asm__("movq %%cr4,%%rax\n\t"
-		"andq %0,%%rax\n\t"
+		"andq %[mask],%%rax\n\t"
 		"movq %%rax,%%cr4\n"
-		: : "irg" (~mask)
+		: : [mask] "irg" (~mask)
 		:"ax");
 }
 
@@ -300,12 +300,12 @@ struct thread_struct {
 } while(0) 
 
 #define get_debugreg(var, register)				\
-		__asm__("movq %%db" #register ", %0"		\
-			:"=r" (var))
+		__asm__("movq %%db" #register ", %[_var]"	\
+			: [_var] "=r" (var))
 #define set_debugreg(value, register)			\
-		__asm__("movq %0,%%db" #register		\
+		__asm__("movq %[_value],%%db" #register		\
 			: /* no output */			\
-			:"r" (value))
+			: [_value] "r" (value))
 
 struct task_struct;
 struct mm_struct;
@@ -408,7 +408,7 @@ static inline void sync_core(void)
 #define ARCH_HAS_PREFETCH
 static inline void prefetch(void *x) 
 { 
-	asm volatile("prefetcht0 %0" :: "m" (*(unsigned long *)x));
+	asm volatile("prefetcht0 %[x]" :: [x] "m" (*(unsigned long *)x));
 } 
 
 #define ARCH_HAS_PREFETCHW 1
@@ -488,7 +488,7 @@ extern void mwait_idle_with_hints(unsign
 #define stack_current() \
 ({								\
 	struct thread_info *ti;					\
-	asm("andq %%rsp,%0; ":"=r" (ti) : "0" (CURRENT_MASK));	\
+	asm("andq %%rsp,%[ti]; ": [ti] "=r" (ti) : "0" (CURRENT_MASK));	\
 	ti->task;					\
 })
 
Index: linux-2.6.21-rc1/include/asm-x86_64/semaphore.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/semaphore.h
+++ linux-2.6.21-rc1/include/asm-x86_64/semaphore.h
@@ -106,11 +106,11 @@ static inline void down(struct semaphore
 
 	__asm__ __volatile__(
 		"# atomic down operation\n\t"
-		LOCK_PREFIX "decl %0\n\t"     /* --sem->count */
+		LOCK_PREFIX "decl %[count]\n\t"     /* --sem->count */
 		"jns 1f\n\t"
 		"call __down_failed\n"
 		"1:"
-		:"=m" (sem->count)
+		:[count] "=m" (sem->count)
 		:"D" (sem)
 		:"memory");
 }
@@ -127,12 +127,13 @@ static inline int down_interruptible(str
 
 	__asm__ __volatile__(
 		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		"xorl %[result],%[result]\n\t"
+		LOCK_PREFIX "decl %[count]\n\t"     /* --sem->count */
 		"jns 2f\n\t"
 		"call __down_failed_interruptible\n"
 		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
+		: [result] "=&a" (result),
+		  [count] "=m" (sem->count)
 		:"D" (sem)
 		:"memory");
 	return result;
@@ -148,12 +149,13 @@ static inline int down_trylock(struct se
 
 	__asm__ __volatile__(
 		"# atomic interruptible down operation\n\t"
-		"xorl %0,%0\n\t"
-		LOCK_PREFIX "decl %1\n\t"     /* --sem->count */
+		"xorl %[result],%[result]\n\t"
+		LOCK_PREFIX "decl %[count]\n\t"     /* --sem->count */
 		"jns 2f\n\t"
 		"call __down_failed_trylock\n\t"
 		"2:\n"
-		:"=&a" (result), "=m" (sem->count)
+		: [result] "=&a" (result),
+		  [count] "=m" (sem->count)
 		:"D" (sem)
 		:"memory","cc");
 	return result;
@@ -169,11 +171,11 @@ static inline void up(struct semaphore *
 {
 	__asm__ __volatile__(
 		"# atomic up operation\n\t"
-		LOCK_PREFIX "incl %0\n\t"     /* ++sem->count */
+		LOCK_PREFIX "incl %[count]\n\t"     /* ++sem->count */
 		"jg 1f\n\t"
 		"call __up_wakeup\n"
 		"1:"
-		:"=m" (sem->count)
+		: [count] "=m" (sem->count)
 		:"D" (sem)
 		:"memory");
 }
Index: linux-2.6.21-rc1/include/asm-x86_64/signal.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/signal.h
+++ linux-2.6.21-rc1/include/asm-x86_64/signal.h
@@ -139,12 +139,16 @@ typedef struct sigaltstack {
 
 static inline void sigaddset(sigset_t *set, int _sig)
 {
-	__asm__("btsq %1,%0" : "=m"(*set) : "Ir"(_sig - 1) : "cc");
+	__asm__("btsq %[sig],%[set]" 	: [set] "=m"(*set)
+	 				: [sig] "Ir"(_sig - 1)
+					: "cc");
 }
 
 static inline void sigdelset(sigset_t *set, int _sig)
 {
-	__asm__("btrq %1,%0" : "=m"(*set) : "Ir"(_sig - 1) : "cc");
+	__asm__("btrq %[sig],%[set]" 	: [set] "=m"(*set)
+					: [sig] "Ir"(_sig - 1)
+					: "cc");
 }
 
 static inline int __const_sigismember(sigset_t *set, int _sig)
@@ -156,8 +160,12 @@ static inline int __const_sigismember(si
 static inline int __gen_sigismember(sigset_t *set, int _sig)
 {
 	int ret;
-	__asm__("btq %2,%1\n\tsbbq %0,%0"
-		: "=r"(ret) : "m"(*set), "Ir"(_sig-1) : "cc");
+	__asm__("btq  %[sig],%[set]  \n\t"
+		"sbbq %[ret],%[ret]      "
+		: [ret] "=r"(ret)
+		: [set] "m"(*set),
+		  [sig] "Ir"(_sig-1)
+		: "cc");
 	return ret;
 }
 
@@ -168,7 +176,10 @@ static inline int __gen_sigismember(sigs
 
 static inline int sigfindinword(unsigned long word)
 {
-	__asm__("bsfq %1,%0" : "=r"(word) : "rm"(word) : "cc");
+	__asm__("bsfq %[word2],%[word]"
+		: [word] "=r"(word)
+		: [word2] "rm"(word)
+		: "cc");
 	return word;
 }
 #endif
Index: linux-2.6.21-rc1/include/asm-x86_64/spinlock.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/spinlock.h
+++ linux-2.6.21-rc1/include/asm-x86_64/spinlock.h
@@ -26,14 +26,14 @@ static inline void __raw_spin_lock(raw_s
 {
 	asm volatile(
 		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
+		LOCK_PREFIX " ; decl %[slock]\n\t"
 		"jns 2f\n"
 		"3:\n"
 		"rep;nop\n\t"
-		"cmpl $0,%0\n\t"
+		"cmpl $0,%[slock]\n\t"
 		"jle 3b\n\t"
 		"jmp 1b\n"
-		"2:\t" : "=m" (lock->slock) : : "memory");
+		"2:\t" : [slock] "=m" (lock->slock) : : "memory");
 }
 
 /*
@@ -44,24 +44,24 @@ static inline void __raw_spin_lock_flags
 {
 	asm volatile(
 		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
+		LOCK_PREFIX " ; decl %[slock]\n\t"
 		"jns 5f\n"
-		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
+		"testl $0x200, %[flags]\n\t"	/* interrupts were disabled? */
 		"jz 4f\n\t"
 	        "sti\n"
 		"3:\t"
 		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
+		"cmpl $0, %[slock]\n\t"
 		"jle 3b\n\t"
 		"cli\n\t"
 		"jmp 1b\n"
 		"4:\t"
 		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
+		"cmpl $0, %[slock]\n\t"
 		"jg 1b\n\t"
 		"jmp 4b\n"
 		"5:\n\t"
-		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
+		: [slock] "+m" (lock->slock) : [flags] "r" ((unsigned)flags) : "memory");
 }
 #endif
 
@@ -70,8 +70,8 @@ static inline int __raw_spin_trylock(raw
 	int oldval;
 
 	asm volatile(
-		"xchgl %0,%1"
-		:"=q" (oldval), "=m" (lock->slock)
+		"xchgl %[oldval], %[slock]"
+		:[oldval] "=q" (oldval), [slock] "=m" (lock->slock)
 		:"0" (0) : "memory");
 
 	return oldval > 0;
@@ -79,7 +79,7 @@ static inline int __raw_spin_trylock(raw
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile("movl $1,%0" :"=m" (lock->slock) :: "memory");
+	asm volatile("movl $1,%[slock]" : [slock] "=m" (lock->slock) :: "memory");
 }
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
@@ -114,20 +114,20 @@ static inline int __raw_write_can_lock(r
 
 static inline void __raw_read_lock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "subl $1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX "subl $1,(%[rw])\n\t"
 		     "jns 1f\n"
 		     "call __read_lock_failed\n"
 		     "1:\n"
-		     ::"D" (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     :: [rw] "D" (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
 static inline void __raw_write_lock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX "subl %1,(%0)\n\t"
+	asm volatile(LOCK_PREFIX "subl %1,(%[rw])\n\t"
 		     "jz 1f\n"
 		     "\tcall __write_lock_failed\n\t"
 		     "1:\n"
-		     ::"D" (rw), "i" (RW_LOCK_BIAS) : "memory");
+		     ::[rw] "D" (rw), "i" (RW_LOCK_BIAS) : "memory");
 }
 
 static inline int __raw_read_trylock(raw_rwlock_t *lock)
@@ -151,13 +151,13 @@ static inline int __raw_write_trylock(ra
 
 static inline void __raw_read_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " ; incl %0" :"=m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX " ; incl %[lock]" : [lock] "=m" (rw->lock) : : "memory");
 }
 
 static inline void __raw_write_unlock(raw_rwlock_t *rw)
 {
-	asm volatile(LOCK_PREFIX " ; addl $" RW_LOCK_BIAS_STR ",%0"
-				: "=m" (rw->lock) : : "memory");
+	asm volatile(LOCK_PREFIX " ; addl $" RW_LOCK_BIAS_STR ",%[lock]"
+				: [lock] "=m" (rw->lock) : : "memory");
 }
 
 #define _raw_spin_relax(lock)	cpu_relax()
Index: linux-2.6.21-rc1/include/asm-x86_64/system.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/system.h
+++ linux-2.6.21-rc1/include/asm-x86_64/system.h
@@ -73,32 +73,32 @@ extern void load_gs_index(unsigned); 
 static inline unsigned long read_cr0(void)
 { 
 	unsigned long cr0;
-	asm volatile("movq %%cr0,%0" : "=r" (cr0));
+	asm volatile("movq %%cr0,%[cr0]" : [cr0] "=r" (cr0));
 	return cr0;
 } 
 
 static inline void write_cr0(unsigned long val) 
 { 
-	asm volatile("movq %0,%%cr0" :: "r" (val));
+	asm volatile("movq %[val],%%cr0" :: [val] "r" (val));
 } 
 
 static inline unsigned long read_cr3(void)
 { 
 	unsigned long cr3;
-	asm("movq %%cr3,%0" : "=r" (cr3));
+	asm("movq %%cr3,%[cr3]" : [cr3] "=r" (cr3));
 	return cr3;
 } 
 
 static inline unsigned long read_cr4(void)
 { 
 	unsigned long cr4;
-	asm("movq %%cr4,%0" : "=r" (cr4));
+	asm("movq %%cr4,%[cr4]" : [cr4] "=r" (cr4));
 	return cr4;
 } 
 
 static inline void write_cr4(unsigned long val)
 { 
-	asm volatile("movq %0,%%cr4" :: "r" (val));
+	asm volatile("movq %[val],%%cr4" :: [val] "r" (val));
 } 
 
 #define stts() write_cr0(8 | read_cr0())
Index: linux-2.6.21-rc1/include/asm-x86_64/tlbflush.h
===================================================================
--- linux-2.6.21-rc1.orig/include/asm-x86_64/tlbflush.h
+++ linux-2.6.21-rc1/include/asm-x86_64/tlbflush.h
@@ -7,13 +7,13 @@
 static inline unsigned long get_cr3(void)
 {
 	unsigned long cr3;
-	asm volatile("mov %%cr3,%0" : "=r" (cr3));
+	asm volatile("mov %%cr3,%[cr3]" : [cr3] "=r" (cr3));
 	return cr3;
 }
 
 static inline void set_cr3(unsigned long cr3)
 {
-	asm volatile("mov %0,%%cr3" :: "r" (cr3) : "memory");
+	asm volatile("mov %[cr3],%%cr3" :: [cr3] "r" (cr3) : "memory");
 }
 
 static inline void __flush_tlb(void)
@@ -24,13 +24,13 @@ static inline void __flush_tlb(void)
 static inline unsigned long get_cr4(void)
 {
 	unsigned long cr4;
-	asm volatile("mov %%cr4,%0" : "=r" (cr4));
+	asm volatile("mov %%cr4,%[cr4]" : [cr4] "=r" (cr4));
 	return cr4;
 }
 
 static inline void set_cr4(unsigned long cr4)
 {
-	asm volatile("mov %0,%%cr4" :: "r" (cr4) : "memory");
+	asm volatile("mov %[cr4],%%cr4" :: [cr4] "r" (cr4) : "memory");
 }
 
 static inline void __flush_tlb_all(void)
@@ -41,7 +41,7 @@ static inline void __flush_tlb_all(void)
 }
 
 #define __flush_tlb_one(addr) \
-	__asm__ __volatile__("invlpg (%0)" :: "r" (addr) : "memory")
+	__asm__ __volatile__("invlpg (%[_addr])" :: [_addr] "r" (addr) : "memory")
 
 
 /*

