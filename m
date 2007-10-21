Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbXJUJbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbXJUJbA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 05:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751313AbXJUJaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 05:30:52 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:50919 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbXJUJav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 05:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=AsxSg4HqRTAacDAJAyL4fQRkyfESUxcDiUuPJaF4vcWWC72mzl+77m7gGEHnoYC1LwRAsZ9SoJ+KlqX7PCi3fNq1goAIwy5ZxzWNBx7V1x/mT4wi7A5DMIhwWOBHpvmkpZJ9+QgxMHFtWAI0Hipd+HagSxTyH0lr4YjRW9xf1q4=
Date: Sun, 21 Oct 2007 13:30:42 +0400
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@osdl.org, akpm@osdl.org, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/2] irq_flags_t: intro and core annotations
Message-ID: <20071021093042.GA2144@martell.zuzino.mipt.ru>
References: <20071020235546.GB1825@martell.zuzino.mipt.ru> <20071021005418.GU8181@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071021005418.GU8181@ftp.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2007 at 01:54:18AM +0100, Al Viro wrote:
> On Sun, Oct 21, 2007 at 03:55:46AM +0400, Alexey Dobriyan wrote:
> > * irq_flags_t is marked with __bitwise__ which means sparse(1) will warn
> >   developer when he accidently uses wrong type or totally wrong variable.
> > * irq_flags_t allows conversion to struct instead of typedef without flag day.
> >   This will give compile-time breakage of buggy users later.
> > * irq_flags_t allows arch maintainers to eventually switch to something
> >   smaller than "unsigned long" if they want to.
> 
> > P.S.: Anyone checking for differences in sparse logs -- don't panic,
> > 	just remove __bitwise__ .
> 
> Umm...  Could you make that conditional on something, so that it could
> be done with e.g. -D__CHECK_IRQFLAGS__?  We could make that unconditional
> closer to the end of conversion.

OK! Resending patch #1, patch #2 stays the same.



[PATCH 1/2] irq_flags_t: intro and core annotations

One type of bugs steadily being fought is the following one:

	unsigned int flags;
	spin_lock_irqsave(&lock, flags);

where "flags" should be "unsigned long". Here is far from complete list of
commits fixing such bugs:

099575b6cb7eaf18211ba72de56264f67651b90b
5efee174f8a101cafb1607d2b629bed353701457
c53421b18f205c5f97c604ae55c6a921f034b0f6	(many)
ca7e235f5eb960d83b45cef4384b490672538cd9
361f6ed1d00f666a1a7c33f3e9aaccb713f9b9e4

So far remedies were:
a) grep(1) -- obviously fragile. I tried at some point grepping for
   spin_lock_irqsave(), found quite a few, but it became booooring quickly.
b) BUILD_BUG_ON(sizeof(flags) != sizeof(unsigned long)) -- was tried,
   brutally broke some arches, survived one commit before revert :^)
   Doesn't work on i386 where sizeof(unsigned int) == sizeof(unsigned long).

So it would be nice to have something more robust.



			irq_flags_t
	
New type for use with spin_lock_irqsave() and friends.

* irq_flags_t is unsigned long which shouldn't change any code 
  (except broken one)
* irq_flags_t is marked with __bitwise__ which means sparse(1) will warn
  developer when he accidently uses wrong type or totally wrong variable.
* irq_flags_t allows conversion to struct instead of typedef without flag day.
  This will give compile-time breakage of buggy users later.
* irq_flags_t allows arch maintainers to eventually switch to something
  smaller than "unsigned long" if they want to.

Typical code after conversion:

	irq_flags_t flags;

	spin_lock_irqsave(&lock, flags);
	[stuff]
	spin_unlock_irqrestore(&lock, flags);

This patch adds type itself, annotates core locking functions in generic
headers and i386 arch. Warnings become visible by passing __CHECK_IRQFLAGS__
to sparse:

	make C=2 CF="-D__CHECK_IRQFLAGS__"

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 include/asm-x86/irqflags_32.h    |   20 ++++++++++----------
 include/asm-x86/paravirt.h       |   14 +++++++-------
 include/linux/interrupt.h        |   10 +++++-----
 include/linux/irqflags.h         |    2 +-
 include/linux/spinlock_api_smp.h |   14 +++++++-------
 include/linux/spinlock_up.h      |    2 +-
 include/linux/types.h            |    5 +++++
 kernel/spinlock.c                |   24 ++++++++++++------------
 8 files changed, 48 insertions(+), 43 deletions(-)

--- a/include/asm-x86/irqflags_32.h
+++ b/include/asm-x86/irqflags_32.h
@@ -12,14 +12,14 @@
 #include <asm/processor-flags.h>
 
 #ifndef __ASSEMBLY__
-static inline unsigned long native_save_fl(void)
+static inline irq_flags_t native_save_fl(void)
 {
-	unsigned long f;
+	irq_flags_t f;
 	asm volatile("pushfl ; popl %0":"=g" (f): /* no input */);
 	return f;
 }
 
-static inline void native_restore_fl(unsigned long f)
+static inline void native_restore_fl(irq_flags_t f)
 {
 	asm volatile("pushl %0 ; popfl": /* no output */
 			     :"g" (f)
@@ -52,12 +52,12 @@ static inline void native_halt(void)
 #else
 #ifndef __ASSEMBLY__
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline irq_flags_t __raw_local_save_flags(void)
 {
 	return native_save_fl();
 }
 
-static inline void raw_local_irq_restore(unsigned long flags)
+static inline void raw_local_irq_restore(irq_flags_t flags)
 {
 	native_restore_fl(flags);
 }
@@ -93,9 +93,9 @@ static inline void halt(void)
 /*
  * For spinlocks, etc:
  */
-static inline unsigned long __raw_local_irq_save(void)
+static inline irq_flags_t __raw_local_irq_save(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	irq_flags_t flags = __raw_local_save_flags();
 
 	raw_local_irq_disable();
 
@@ -118,14 +118,14 @@ static inline unsigned long __raw_local_irq_save(void)
 #define raw_local_irq_save(flags) \
 		do { (flags) = __raw_local_irq_save(); } while (0)
 
-static inline int raw_irqs_disabled_flags(unsigned long flags)
+static inline int raw_irqs_disabled_flags(irq_flags_t flags)
 {
-	return !(flags & X86_EFLAGS_IF);
+	return !((unsigned long __force)flags & X86_EFLAGS_IF);
 }
 
 static inline int raw_irqs_disabled(void)
 {
-	unsigned long flags = __raw_local_save_flags();
+	irq_flags_t flags = __raw_local_save_flags();
 
 	return raw_irqs_disabled_flags(flags);
 }
--- a/include/asm-x86/paravirt.h
+++ b/include/asm-x86/paravirt.h
@@ -136,8 +136,8 @@ struct pv_irq_ops {
 	 * returned from save_fl are undefined, and may be ignored by
 	 * restore_fl.
 	 */
-	unsigned long (*save_fl)(void);
-	void (*restore_fl)(unsigned long);
+	irq_flags_t (*save_fl)(void);
+	void (*restore_fl)(irq_flags_t);
 	void (*irq_disable)(void);
 	void (*irq_enable)(void);
 	void (*safe_halt)(void);
@@ -1014,9 +1014,9 @@ struct paravirt_patch_site {
 extern struct paravirt_patch_site __parainstructions[],
 	__parainstructions_end[];
 
-static inline unsigned long __raw_local_save_flags(void)
+static inline irq_flags_t __raw_local_save_flags(void)
 {
-	unsigned long f;
+	irq_flags_t f;
 
 	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
 				  PARAVIRT_CALL
@@ -1028,7 +1028,7 @@ static inline unsigned long __raw_local_save_flags(void)
 	return f;
 }
 
-static inline void raw_local_irq_restore(unsigned long f)
+static inline void raw_local_irq_restore(irq_flags_t f)
 {
 	asm volatile(paravirt_alt("pushl %%ecx; pushl %%edx;"
 				  PARAVIRT_CALL
@@ -1062,9 +1062,9 @@ static inline void raw_local_irq_enable(void)
 		     : "memory", "eax", "cc");
 }
 
-static inline unsigned long __raw_local_irq_save(void)
+static inline irq_flags_t __raw_local_irq_save(void)
 {
-	unsigned long f;
+	irq_flags_t f;
 
 	f = __raw_local_save_flags();
 	raw_local_irq_disable();
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -122,7 +122,7 @@ static inline void disable_irq_nosync_lockdep(unsigned int irq)
 #endif
 }
 
-static inline void disable_irq_nosync_lockdep_irqsave(unsigned int irq, unsigned long *flags)
+static inline void disable_irq_nosync_lockdep_irqsave(unsigned int irq, irq_flags_t *flags)
 {
 	disable_irq_nosync(irq);
 #ifdef CONFIG_LOCKDEP
@@ -146,7 +146,7 @@ static inline void enable_irq_lockdep(unsigned int irq)
 	enable_irq(irq);
 }
 
-static inline void enable_irq_lockdep_irqrestore(unsigned int irq, unsigned long *flags)
+static inline void enable_irq_lockdep_irqrestore(unsigned int irq, irq_flags_t *flags)
 {
 #ifdef CONFIG_LOCKDEP
 	local_irq_restore(*flags);
@@ -211,17 +211,17 @@ static inline void __deprecated sti(void)
 {
 	local_irq_enable();
 }
-static inline void __deprecated save_flags(unsigned long *x)
+static inline void __deprecated save_flags(irq_flags_t *x)
 {
 	local_save_flags(*x);
 }
 #define save_flags(x) save_flags(&x)
-static inline void __deprecated restore_flags(unsigned long x)
+static inline void __deprecated restore_flags(irq_flags_t x)
 {
 	local_irq_restore(x);
 }
 
-static inline void __deprecated save_and_cli(unsigned long *x)
+static inline void __deprecated save_and_cli(irq_flags_t *x)
 {
 	local_irq_save(*x);
 }
--- a/include/linux/irqflags.h
+++ b/include/linux/irqflags.h
@@ -84,7 +84,7 @@
 
 #define irqs_disabled()						\
 ({								\
-	unsigned long flags;					\
+	irq_flags_t flags;					\
 								\
 	raw_local_save_flags(flags);				\
 	raw_irqs_disabled_flags(flags);				\
--- a/include/linux/spinlock_api_smp.h
+++ b/include/linux/spinlock_api_smp.h
@@ -30,13 +30,13 @@ void __lockfunc _write_lock_bh(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _spin_lock_irq(spinlock_t *lock)	__acquires(lock);
 void __lockfunc _read_lock_irq(rwlock_t *lock)		__acquires(lock);
 void __lockfunc _write_lock_irq(rwlock_t *lock)		__acquires(lock);
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+irq_flags_t __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 							__acquires(lock);
-unsigned long __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
+irq_flags_t __lockfunc _spin_lock_irqsave_nested(spinlock_t *lock, int subclass)
 							__acquires(lock);
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+irq_flags_t __lockfunc _read_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+irq_flags_t __lockfunc _write_lock_irqsave(rwlock_t *lock)
 							__acquires(lock);
 int __lockfunc _spin_trylock(spinlock_t *lock);
 int __lockfunc _read_trylock(rwlock_t *lock);
@@ -51,11 +51,11 @@ void __lockfunc _write_unlock_bh(rwlock_t *lock)	__releases(lock);
 void __lockfunc _spin_unlock_irq(spinlock_t *lock)	__releases(lock);
 void __lockfunc _read_unlock_irq(rwlock_t *lock)	__releases(lock);
 void __lockfunc _write_unlock_irq(rwlock_t *lock)	__releases(lock);
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, irq_flags_t flags)
 							__releases(lock);
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, irq_flags_t flags)
 							__releases(lock);
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, irq_flags_t flags)
 							__releases(lock);
 
 #endif /* __LINUX_SPINLOCK_API_SMP_H */
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -26,7 +26,7 @@ static inline void __raw_spin_lock(raw_spinlock_t *lock)
 }
 
 static inline void
-__raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
+__raw_spin_lock_flags(raw_spinlock_t *lock, irq_flags_t flags)
 {
 	local_irq_save(flags);
 	lock->slock = 0;
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -188,6 +188,11 @@ typedef __u32 __bitwise __wsum;
 
 #ifdef __KERNEL__
 typedef unsigned __bitwise__ gfp_t;
+#ifdef __CHECK_IRQFLAGS__
+typedef unsigned long __bitwise__ irq_flags_t;
+#else
+typedef unsigned long irq_flags_t;
+#endif
 
 #ifdef CONFIG_RESOURCES_64BIT
 typedef u64 resource_size_t;
--- a/kernel/spinlock.c
+++ b/kernel/spinlock.c
@@ -76,9 +76,9 @@ void __lockfunc _read_lock(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_lock);
 
-unsigned long __lockfunc _spin_lock_irqsave(spinlock_t *lock)
+irq_flags_t __lockfunc _spin_lock_irqsave(spinlock_t *lock)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	preempt_disable();
@@ -115,9 +115,9 @@ void __lockfunc _spin_lock_bh(spinlock_t *lock)
 }
 EXPORT_SYMBOL(_spin_lock_bh);
 
-unsigned long __lockfunc _read_lock_irqsave(rwlock_t *lock)
+irq_flags_t __lockfunc _read_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	preempt_disable();
@@ -145,9 +145,9 @@ void __lockfunc _read_lock_bh(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_lock_bh);
 
-unsigned long __lockfunc _write_lock_irqsave(rwlock_t *lock)
+irq_flags_t __lockfunc _write_lock_irqsave(rwlock_t *lock)
 {
-	unsigned long flags;
+	irq_flags_t flags;
 
 	local_irq_save(flags);
 	preempt_disable();
@@ -222,9 +222,9 @@ void __lockfunc _##op##_lock(locktype##_t *lock)			\
 									\
 EXPORT_SYMBOL(_##op##_lock);						\
 									\
-unsigned long __lockfunc _##op##_lock_irqsave(locktype##_t *lock)	\
+irq_flags_t __lockfunc _##op##_lock_irqsave(locktype##_t *lock)		\
 {									\
-	unsigned long flags;						\
+	irq_flags_t flags;						\
 									\
 	for (;;) {							\
 		preempt_disable();					\
@@ -254,7 +254,7 @@ EXPORT_SYMBOL(_##op##_lock_irq);					\
 									\
 void __lockfunc _##op##_lock_bh(locktype##_t *lock)			\
 {									\
-	unsigned long flags;						\
+	irq_flags_t flags;						\
 									\
 	/*							*/	\
 	/* Careful: we must exclude softirqs too, hence the	*/	\
@@ -341,7 +341,7 @@ void __lockfunc _read_unlock(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_unlock);
 
-void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, unsigned long flags)
+void __lockfunc _spin_unlock_irqrestore(spinlock_t *lock, irq_flags_t flags)
 {
 	spin_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_spin_unlock(lock);
@@ -368,7 +368,7 @@ void __lockfunc _spin_unlock_bh(spinlock_t *lock)
 }
 EXPORT_SYMBOL(_spin_unlock_bh);
 
-void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _read_unlock_irqrestore(rwlock_t *lock, irq_flags_t flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_read_unlock(lock);
@@ -395,7 +395,7 @@ void __lockfunc _read_unlock_bh(rwlock_t *lock)
 }
 EXPORT_SYMBOL(_read_unlock_bh);
 
-void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, unsigned long flags)
+void __lockfunc _write_unlock_irqrestore(rwlock_t *lock, irq_flags_t flags)
 {
 	rwlock_release(&lock->dep_map, 1, _RET_IP_);
 	_raw_write_unlock(lock);
