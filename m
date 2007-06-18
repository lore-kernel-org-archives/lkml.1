Return-Path: <linux-kernel-owner+w=401wt.eu-S1762450AbXFRMhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762450AbXFRMhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 08:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754403AbXFRMhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 08:37:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54168 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbXFRMhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 08:37:07 -0400
Date: Mon, 18 Jun 2007 14:36:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, kiran@scalex86.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618123646.GA22672@elte.hu>
References: <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu> <20070618083109.GA23572@elte.hu> <E1I0ChN-0006nd-00@dorka.pomaz.szeredi.hu> <20070618091832.GA1860@elte.hu> <20070618093848.GA6880@elte.hu> <20070618094414.GA8261@elte.hu> <E1I0EJc-0007El-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0EJc-0007El-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > how about the patch below? Boot-tested on 32-bit. As a side-effect 
> > > this change also removes the 255 CPUs limit from the 32-bit kernel.
> > 
> > boot-tested on 64-bit too now.
> 
> Strange, I can't even get past the compile stage ;)
> 
>   CC      kernel/spinlock.o
> {standard input}: Assembler messages:
> {standard input}:207: Error: backward ref to unknown label "4:"

oh, sorry - i built it with !PREEMPT, which doesnt make use of the flags 
thing. I fixed the build and have cleaned up and simplified that code 
some more - does the patch below work for you? (it does for me on both 
32-bit and 64-bit)

	Ingo

----------------------------->
Subject: [patch] x86: fix spin-loop starvation bug
From: Ingo Molnar <mingo@elte.hu>

Miklos Szeredi reported very long pauses (several seconds, sometimes
more) on his T60 (with a Core2Duo) which he managed to track down to
wait_task_inactive()'s open-coded busy-loop. He observed that an
interrupt on one core tries to acquire the runqueue-lock but does not
succeed in doing so for a very long time - while wait_task_inactive() on
the other core loops waiting for the first core to deschedule a task
(which it wont do while spinning in an interrupt handler).

The problem is: both the spin_lock() code and the wait_task_inactive()
loop uses cpu_relax()/rep_nop(), so in theory the CPU should have
guaranteed MESI-fairness to the two cores - but that didnt happen: one
of the cores was able to monopolize the cacheline that holds the
runqueue lock, for extended periods of time.

This patch changes the spin-loop to assert an atomic op after every REP
NOP instance - this will cause the CPU to express its "MESI interest" in
that cacheline after every REP NOP.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-i386/spinlock.h   |   94 ++++++++++++++++--------------------------
 include/asm-x86_64/spinlock.h |   69 +++++++++++++++---------------
 2 files changed, 72 insertions(+), 91 deletions(-)

Index: linux-cfs-2.6.22-rc5.q/include/asm-i386/spinlock.h
===================================================================
--- linux-cfs-2.6.22-rc5.q.orig/include/asm-i386/spinlock.h
+++ linux-cfs-2.6.22-rc5.q/include/asm-i386/spinlock.h
@@ -29,21 +29,24 @@
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *x)
 {
-	return *(volatile signed char *)(&(x)->slock) <= 0;
+	return *(volatile unsigned int *)(&(x)->slock) == 0;
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
-	asm volatile("\n1:\t"
-		     LOCK_PREFIX " ; decb %0\n\t"
-		     "jns 3f\n"
-		     "2:\t"
-		     "rep;nop\n\t"
-		     "cmpb $0,%0\n\t"
-		     "jle 2b\n\t"
-		     "jmp 1b\n"
-		     "3:\n\t"
-		     : "+m" (lock->slock) : : "memory");
+	asm volatile(
+	"1:							\n"
+		/* copy bit 0 to carry-flag and clear bit 0 */
+		LOCK_PREFIX " ; btrl $0, %[slock]		\n"
+	"	jc 2f						\n"
+		/* PAUSE */
+	"	rep; nop					\n"
+	"	jmp 1b						\n"
+	"2:							\n"
+		: [slock] "+m" (lock->slock)
+		:
+		: "memory", "cc"
+	);
 }
 
 /*
@@ -58,69 +61,46 @@ static inline void __raw_spin_lock(raw_s
 static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decb %[slock]\n\t"
-		"jns 5f\n"
-		"2:\t"
-		"testl $0x200, %[flags]\n\t"
-		"jz 4f\n\t"
-		STI_STRING "\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jle 3b\n\t"
-		CLI_STRING "\n\t"
-		"jmp 1b\n"
-		"4:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jg 1b\n\t"
-		"jmp 4b\n"
-		"5:\n\t"
+	"1:							 \n"
+		/* copy bit 0 to carry-flag and clear bit 0 */
+		LOCK_PREFIX " ; btrl $0, %[slock]		 \n"
+	"	jc 3f						 \n"
+		/* were interrupts disabled? */
+	"	testl $0x200, %[flags]				 \n"
+	"	jz 2f						 \n"
+		STI_STRING					"\n"
+		/* PAUSE */
+	"2:	rep; nop					 \n"
+		CLI_STRING					"\n"
+	"	jmp 1b						 \n"
+	"3:							 \n"
 		: [slock] "+m" (lock->slock)
-		: [flags] "r" (flags)
-	 	  CLI_STI_INPUT_ARGS
-		: "memory" CLI_STI_CLOBBERS);
+		: [flags] "r"  (flags)
+		  CLI_STI_INPUT_ARGS
+		: "memory", "cc" CLI_STI_CLOBBERS);
 }
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
-	char oldval;
+	unsigned int oldval;
+
 	asm volatile(
-		"xchgb %b0,%1"
+		"xchgl %0, %1"
 		:"=q" (oldval), "+m" (lock->slock)
 		:"0" (0) : "memory");
-	return oldval > 0;
+
+	return oldval != 0;
 }
 
 /*
- * __raw_spin_unlock based on writing $1 to the low byte.
- * This method works. Despite all the confusion.
- * (except on PPro SMP or if we are using OOSTORE, so we use xchgb there)
- * (PPro errata 66, 92)
+ * __raw_spin_unlock based on writing $1 to the lock.
  */
-
-#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
-
-static inline void __raw_spin_unlock(raw_spinlock_t *lock)
-{
-	asm volatile("movb $1,%0" : "+m" (lock->slock) :: "memory");
-}
-
-#else
-
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	char oldval = 1;
-
-	asm volatile("xchgb %b0, %1"
-		     : "=q" (oldval), "+m" (lock->slock)
-		     : "0" (oldval) : "memory");
+	asm volatile("movl $1, %0" : "+m" (lock->slock) : : "memory");
 }
 
-#endif
-
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
 	while (__raw_spin_is_locked(lock))
Index: linux-cfs-2.6.22-rc5.q/include/asm-x86_64/spinlock.h
===================================================================
--- linux-cfs-2.6.22-rc5.q.orig/include/asm-x86_64/spinlock.h
+++ linux-cfs-2.6.22-rc5.q/include/asm-x86_64/spinlock.h
@@ -19,21 +19,24 @@
 
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
-	return *(volatile signed int *)(&(lock)->slock) <= 0;
+	return *(volatile unsigned int *)(&(lock)->slock) == 0;
 }
 
 static inline void __raw_spin_lock(raw_spinlock_t *lock)
 {
 	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
-		"jns 2f\n"
-		"3:\n"
-		"rep;nop\n\t"
-		"cmpl $0,%0\n\t"
-		"jle 3b\n\t"
-		"jmp 1b\n"
-		"2:\t" : "=m" (lock->slock) : : "memory");
+	"1:							\n"
+		/* copy bit 0 to carry-flag and clear bit 0 */
+		LOCK_PREFIX " ; btrl $0, %[slock]		\n"
+	"	jc 2f						\n"
+		/* PAUSE */
+	"	rep; nop					\n"
+	"	jmp 1b						\n"
+	"2:							\n"
+		: [slock] "+m" (lock->slock)
+		:
+		: "memory", "cc"
+	);
 }
 
 /*
@@ -43,43 +46,41 @@ static inline void __raw_spin_lock(raw_s
 static inline void __raw_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	asm volatile(
-		"\n1:\t"
-		LOCK_PREFIX " ; decl %0\n\t"
-		"jns 5f\n"
-		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
-		"jz 4f\n\t"
-	        "sti\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jle 3b\n\t"
-		"cli\n\t"
-		"jmp 1b\n"
-		"4:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jg 1b\n\t"
-		"jmp 4b\n"
-		"5:\n\t"
-		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
+	"1:							\n"
+		/* copy bit 0 to carry-flag and clear bit 0 */
+		LOCK_PREFIX " ; btrl $0, %[slock]		\n"
+	"	jc 3f						\n"
+		/* were interrupts disabled? */
+	"	testl $0x200, %[flags]				\n"
+	"	jz 2f						\n"
+	"	sti						\n"
+		/* PAUSE */
+	"2:	rep; nop					\n"
+	"	cli						\n"
+	"	jmp 1b						\n"
+	"3:							\n"
+		: [slock] "+m" (lock->slock)
+		: [flags] "r"  ((unsigned int)flags)
+		: "memory", "cc"
+	);
 }
 #endif
 
 static inline int __raw_spin_trylock(raw_spinlock_t *lock)
 {
-	int oldval;
+	unsigned int oldval;
 
 	asm volatile(
-		"xchgl %0,%1"
-		:"=q" (oldval), "=m" (lock->slock)
+		"xchgl %0, %1"
+		:"=q" (oldval), "+m" (lock->slock)
 		:"0" (0) : "memory");
 
-	return oldval > 0;
+	return oldval != 0;
 }
 
 static inline void __raw_spin_unlock(raw_spinlock_t *lock)
 {
-	asm volatile("movl $1,%0" :"=m" (lock->slock) :: "memory");
+	asm volatile("movl $1, %0" : "+m" (lock->slock) : : "memory");
 }
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
