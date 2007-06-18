Return-Path: <linux-kernel-owner+w=401wt.eu-S1759897AbXFRIbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759897AbXFRIbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 04:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbXFRIbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 04:31:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51558 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbXFRIbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 04:31:24 -0400
Date: Mon, 18 Jun 2007 10:31:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: cebbert@redhat.com, chris@atlee.ca, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, Ravikiran G Thirumalai <kiran@scalex86.org>
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070618083109.GA23572@elte.hu>
References: <E1HrGom-0006AC-00@dorka.pomaz.szeredi.hu> <20070524210153.GB19672@elte.hu> <E1HrWSH-0000mH-00@dorka.pomaz.szeredi.hu> <E1Hyrnk-0006On-00@dorka.pomaz.szeredi.hu> <20070616103707.GA28096@elte.hu> <E1I02Zx-0005qu-00@dorka.pomaz.szeredi.hu> <20070618064343.GA31113@elte.hu> <E1I0Baz-0006cP-00@dorka.pomaz.szeredi.hu> <20070618081204.GA11153@elte.hu> <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1I0CY4-0006lF-00@dorka.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


(Ravikiran Cc:-ed too)

* Miklos Szeredi <miklos@szeredi.hu> wrote:

> > To test this theory, could you try the patch below, does this fix 
> > your hangs too?
> 
> Not tried yet, but obviously it does, since it's a superset of the 
> previous fix.  I could try without the smb_mb(), but see below.

oops - the 64-bit processor.h bits were included by accident - updated 
patch below.

> > This change causes the memory access of the "easy" spin-loop portion 
> > to be more agressive: after the REP; NOP we'd not do the 'easy-loop' 
> > with a simple CMPB, but we'd re-attempt the atomic op.
> 
> It looks as if this is going to overflow of the lock counter, no?

hm, what do you mean? There's no lock counter.

	Ingo

-------------------------->
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
 include/asm-i386/spinlock.h   |   16 ++++------------
 include/asm-x86_64/spinlock.h |   15 +++------------
 2 files changed, 7 insertions(+), 24 deletions(-)

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
