Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYFSL7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYFSL7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754030AbYFSL7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:59:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54077 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbYFSL7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:59:20 -0400
Date: Thu, 19 Jun 2008 13:58:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, benh@kernel.crashing.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel <kvm-devel@lists.sourceforge.net>, x86@kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Hugh Dickins <hugh@veritas.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1 of 4] mm: add a ptep_modify_prot transaction
	abstraction
Message-ID: <20080619115832.GM15228@elte.hu>
References: <b020e42384197b824320.1213615800@localhost> <1213831403.8011.24.camel@pasglop> <4859A149.9090004@goop.org> <4859A528.1010107@goop.org> <alpine.LFD.1.10.0806181723400.2907@woody.linux-foundation.org> <4859AA47.2020903@goop.org> <alpine.LFD.1.10.0806181743390.2907@woody.linux-foundation.org> <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806182050470.2907@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Wed, 18 Jun 2008, Linus Torvalds wrote:
> > 
> > And yes, the "lock andl" should be noticeably faster than the xchgl.
> 
> I dunno. Here's a untested (!!) patch that turns constant-bit 
> set/clear_bit ops into byte mask ops (lock orb/andb).
> 
> It's not exactly pretty. The reason for using the byte versions is 
> that a locked op is serialized in the memory pipeline anyway, so there 
> are no forwarding issues (that could slow down things when we access 
> things with different sizes), and the byte ops are a lot smaller than 
> 32-bit and particularly 64-bit ops (big constants, and the 64-bit ops 
> need the REX prefix byte too).
> 
> [ Side note: I wonder if we should turn the "test_bit()" C version into a 
>   "char *" version too.. It could actually help with alias analysis, since 
>   char pointers can alias anything. So it might be the RightThing(tm) to 
>   do for multiple reasons. I dunno. It's a separate issue. ]
> 
> It does actually shrink the kernel image a bit (a couple of hundred bytes 
> on the text segment for my everything-compiled-in image), and while it's 
> totally untested the (admittedly few) code generation points I looked at 
> seemed sane. And "lock orb" should be noticeably faster than "lock bts".
> 
> If somebody wants to play with it, go wild. I didn't do 
> "change_bit()", because nobody sane uses that thing anyway. I 
> guarantee nothing. And if it breaks, nobody saw me do anything.  You 
> can't prove this email wasn't sent by somebody who is good at forging 
> smtp.

i stuck this into tip/x86/bitops branch for kicks - and it blew up very 
quickly on 32-bit ;-)

The crash manifests itself as a flood of spurious irqs:

[    0.997179] irq 96, desc: 788ddd80, depth: 1, count: 0, unhandled: 0
[    1.003414] ->handle_irq():  7814c888, handle_bad_irq+0x0/0x1b0
[    1.003414] ->chip(): 78867174, no_irq_chip+0x0/0x40
[    1.008350] ->action(): 00000000
[    1.008350]   IRQ_DISABLED set
[    1.010339] unexpected IRQ trap at vector 60

unappying that change makes the system boot up fine.

a quick guess would be:

   io_apic_32.c:   if (test_and_set_bit(vector, used_vectors))

   io_apic_32.c:           set_bit(i, used_vectors);

config and crashlog can be found at:

  http://redhat.com/~mingo/misc/config-Thu_Jun_19_13_45_21_CEST_2008.bad
  http://redhat.com/~mingo/misc/crash-Thu_Jun_19_13_45_21_CEST_2008.log

Below is the commit, it needed a small amount of massaging to apply the 
void * -> unsigned long * change in the x86/bitops topic.

	Ingo

-------------->
commit 1a750e0cd7a30c478723ecfa1df685efcdd38a90
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed Jun 18 21:03:26 2008 -0700

    x86, bitops: make constant-bit set/clear_bit ops faster
    
    On Wed, 18 Jun 2008, Linus Torvalds wrote:
    >
    > And yes, the "lock andl" should be noticeably faster than the xchgl.
    
    I dunno. Here's a untested (!!) patch that turns constant-bit
    set/clear_bit ops into byte mask ops (lock orb/andb).
    
    It's not exactly pretty. The reason for using the byte versions is that a
    locked op is serialized in the memory pipeline anyway, so there are no
    forwarding issues (that could slow down things when we access things with
    different sizes), and the byte ops are a lot smaller than 32-bit and
    particularly 64-bit ops (big constants, and the 64-bit ops need the REX
    prefix byte too).
    
    [ Side note: I wonder if we should turn the "test_bit()" C version into a
      "char *" version too.. It could actually help with alias analysis, since
      char pointers can alias anything. So it might be the RightThing(tm) to
      do for multiple reasons. I dunno. It's a separate issue. ]
    
    It does actually shrink the kernel image a bit (a couple of hundred bytes
    on the text segment for my everything-compiled-in image), and while it's
    totally untested the (admittedly few) code generation points I looked at
    seemed sane. And "lock orb" should be noticeably faster than "lock bts".
    
    If somebody wants to play with it, go wild. I didn't do "change_bit()",
    because nobody sane uses that thing anyway. I guarantee nothing. And if it
    breaks, nobody saw me do anything.  You can't prove this email wasn't sent
    by somebody who is good at forging smtp.
    
    This does require a gcc that is recent enough for "__builtin_constant_p()"
    to work in an inline function, but I suspect our kernel requirements are
    already higher than that. And if you do have an old gcc that is supported,
    the worst that would happen is that the optimization doesn't trigger.
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/include/asm-x86/bitops.h b/include/asm-x86/bitops.h
index 7d2494b..ab7635a 100644
--- a/include/asm-x86/bitops.h
+++ b/include/asm-x86/bitops.h
@@ -23,11 +23,22 @@
 #if __GNUC__ < 4 || (__GNUC__ == 4 && __GNUC_MINOR__ < 1)
 /* Technically wrong, but this avoids compilation errors on some gcc
    versions. */
-#define ADDR "=m" (*(volatile long *) addr)
+#define BITOP_ADDR(x) "=m" (*(volatile long *) (x))
 #else
-#define ADDR "+m" (*(volatile long *) addr)
+#define BITOP_ADDR(x) "+m" (*(volatile long *) (x))
 #endif
 
+#define ADDR BITOP_ADDR(addr)
+
+/*
+ * We do the locked ops that don't return the old value as
+ * a mask operation on a byte.
+ */
+#define IS_IMMEDIATE(nr) \
+	(__builtin_constant_p(nr))
+#define CONST_MASK_ADDR BITOP_ADDR(addr + (nr>>3))
+#define CONST_MASK (1 << (nr & 7))
+
 /**
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
@@ -43,11 +54,15 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(int nr, volatile unsigned long *addr)
+static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
 {
-	asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
+	if (IS_IMMEDIATE(nr))
+		asm volatile(LOCK_PREFIX "orb %1,%0" : CONST_MASK_ADDR : "i" (CONST_MASK) : "memory");
+	else
+		asm volatile(LOCK_PREFIX "bts %1,%0" : ADDR : "Ir" (nr) : "memory");
 }
 
+
 /**
  * __set_bit - Set a bit in memory
  * @nr: the bit to set
@@ -74,7 +89,10 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  */
 static inline void clear_bit(int nr, volatile unsigned long *addr)
 {
-	asm volatile(LOCK_PREFIX "btr %1,%0" : ADDR : "Ir" (nr));
+	if (IS_IMMEDIATE(nr))
+		asm volatile(LOCK_PREFIX "andb %1,%0" : CONST_MASK_ADDR : "i" (~CONST_MASK));
+	else
+		asm volatile(LOCK_PREFIX "btr %1,%0" : ADDR : "Ir" (nr));
 }
 
 /*
