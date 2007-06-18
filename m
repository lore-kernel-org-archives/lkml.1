Return-Path: <linux-kernel-owner+w=401wt.eu-S1759058AbXFRIMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759058AbXFRIMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754202AbXFRIM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:12:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49692 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbXFRIM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:12:28 -0400
Date: Mon, 18 Jun 2007 10:12:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618081204.GA11153@elte.hu>
References: <E1HrEIp-0005qy-00@dorka.pomaz.szeredi.hu> <20070524144447.GA25068@elte.hu> <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu>
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

> My previous attempt was just commenting out parts of your patch.  But 
> maybe it's more logical to move the barrier to immediately after the 
> unlock.
> 
> With this patch I can't reproduce the problem, which may not mean very 
> much, since it was rather a "fragile" bug anyway.  But at least the 
> fix looks pretty harmless.

>  		task_rq_unlock(rq, &flags);
> +		/*
> +		 * Without this barrier, wait_task_inactive() can starve
> +		 * waiters of rq->lock (observed on Core2Duo)
> +		 */
> +		smp_mb();
>  		cpu_relax();

yeah. The problem is, that the open-coded loop there is totally fine, 
and we have similar loops elsewhere, so this problem could hit us again, 
in an even harder to debug place! Since this affects our basic SMP 
primitives, quite some caution is warranted i think.

So ... to inquire about the scope of the problem, another possibility 
would be for the _spin loop_ being 'too nice', not wait_task_inactive() 
being too agressive!

To test this theory, could you try the patch below, does this fix your 
hangs too? This change causes the memory access of the "easy" spin-loop 
portion to be more agressive: after the REP; NOP we'd not do the 
'easy-loop' with a simple CMPB, but we'd re-attempt the atomic op. (in 
theory the non-LOCK-ed memory accesses should have a similar effect, but 
maybe the Core2Duo has some special optimization for non-LOCK-ed 
cacheline accesses that causes cacheline starvation?)

	Ingo

---------------------------------------------------->
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

Reported-and-debugged-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-i386/spinlock.h    |   16 ++++------------
 include/asm-x86_64/processor.h |    8 ++++++--
 include/asm-x86_64/spinlock.h  |   15 +++------------
 3 files changed, 13 insertions(+), 26 deletions(-)

Index: linux-cfs-2.6.22-rc5.q/include/asm-i386/spinlock.h
===================================================================
--- linux-cfs-2.6.22-rc5.q.orig/include/asm-i386/spinlock.h
+++ linux-cfs-2.6.22-rc5.q/include/asm-i386/spinlock.h
@@ -37,10 +37,7 @@ static inline void __raw_spin_lock(raw_s
 	asm volatile("\n1:\t"
 		     LOCK_PREFIX " ; decb %0\n\t"
 		     "jns 3f\n"
-		     "2:\t"
-		     "rep;nop\n\t"
-		     "cmpb $0,%0\n\t"
-		     "jle 2b\n\t"
+		     "rep; nop\n\t"
 		     "jmp 1b\n"
 		     "3:\n\t"
 		     : "+m" (lock->slock) : : "memory");
@@ -65,21 +62,16 @@ static inline void __raw_spin_lock_flags
 		"testl $0x200, %[flags]\n\t"
 		"jz 4f\n\t"
 		STI_STRING "\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jle 3b\n\t"
+		"rep; nop\n\t"
 		CLI_STRING "\n\t"
 		"jmp 1b\n"
 		"4:\t"
-		"rep;nop\n\t"
-		"cmpb $0, %[slock]\n\t"
-		"jg 1b\n\t"
+		"rep; nop\n\t"
 		"jmp 4b\n"
 		"5:\n\t"
 		: [slock] "+m" (lock->slock)
 		: [flags] "r" (flags)
-	 	  CLI_STI_INPUT_ARGS
+		  CLI_STI_INPUT_ARGS
 		: "memory" CLI_STI_CLOBBERS);
 }
 #endif
Index: linux-cfs-2.6.22-rc5.q/include/asm-x86_64/processor.h
===================================================================
--- linux-cfs-2.6.22-rc5.q.orig/include/asm-x86_64/processor.h
+++ linux-cfs-2.6.22-rc5.q/include/asm-x86_64/processor.h
@@ -358,7 +358,7 @@ struct extended_sigtable {
 /* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
 static inline void rep_nop(void)
 {
-	__asm__ __volatile__("rep;nop": : :"memory");
+	__asm__ __volatile__("rep; nop" : : : "memory");
 }
 
 /* Stop speculative execution */
@@ -389,7 +389,11 @@ static inline void prefetchw(void *x) 
 
 #define spin_lock_prefetch(x)  prefetchw(x)
 
-#define cpu_relax()   rep_nop()
+static inline void cpu_relax(void)
+{
+	smp_mb(); /* Core2Duo needs this to not starve other cores */
+	rep_nop();
+}
 
 /*
  *      NSC/Cyrix CPU indexed register access macros
Index: linux-cfs-2.6.22-rc5.q/include/asm-x86_64/spinlock.h
===================================================================
--- linux-cfs-2.6.22-rc5.q.orig/include/asm-x86_64/spinlock.h
+++ linux-cfs-2.6.22-rc5.q/include/asm-x86_64/spinlock.h
@@ -28,10 +28,7 @@ static inline void __raw_spin_lock(raw_s
 		"\n1:\t"
 		LOCK_PREFIX " ; decl %0\n\t"
 		"jns 2f\n"
-		"3:\n"
-		"rep;nop\n\t"
-		"cmpl $0,%0\n\t"
-		"jle 3b\n\t"
+		"rep; nop\n\t"
 		"jmp 1b\n"
 		"2:\t" : "=m" (lock->slock) : : "memory");
 }
@@ -49,16 +46,10 @@ static inline void __raw_spin_lock_flags
 		"testl $0x200, %1\n\t"	/* interrupts were disabled? */
 		"jz 4f\n\t"
 	        "sti\n"
-		"3:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jle 3b\n\t"
+		"rep; nop\n\t"
 		"cli\n\t"
 		"jmp 1b\n"
-		"4:\t"
-		"rep;nop\n\t"
-		"cmpl $0, %0\n\t"
-		"jg 1b\n\t"
+		"rep; nop\n\t"
 		"jmp 4b\n"
 		"5:\n\t"
 		: "+m" (lock->slock) : "r" ((unsigned)flags) : "memory");
