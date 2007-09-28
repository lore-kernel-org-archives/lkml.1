Return-Path: <linux-kernel-owner+w=401wt.eu-S1759956AbXI1Psm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbXI1Psm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751648AbXI1Psf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:48:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:33145 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXI1Pse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:48:34 -0400
Date: Fri, 28 Sep 2007 17:48:32 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       alan@lxorguk.ukuu.org.uk
Subject: [patch] x86: improved memory barrier implementation
Message-ID: <20070928154832.GB12538@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

According to latest memory ordering specification documents from Intel and
AMD, both manufacturers are committed to in-order loads from cacheable memory
for the x86 architecture. Hence, smp_rmb() may be a simple barrier.

Also according to those documents, and according to existing practice in Linux
(eg. spin_unlock doesn't enforce ordering), stores to cacheable memory are
visible in program order too. Hence, smp_wmb() may be a simple barrier.

http://developer.intel.com/products/processor/manuals/318147.pdf
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf

Whether or not this noticably helps performance anywhere is not known. My
primary motivation for this is to have a canonical barrier implementation for
x86 architecture.

There is some controversy about whether this is valid in the presence of
string operations or non-temporal stores etc. which may use different memory
ordering rules. However, those would be _already_ broken by non-ordering
spinlocks and, as such, those operations must carry their own ordering code
so they appear to execute in-order (though many places don't seem to, eg. rep
stosb in copy*user*).

The only alternative is to assume a weak memory model, and add the required
barriers to spin_unlock -- something that has been explicitly avoided, but
_may_ be a better way to go? However, unless my logic is broken, it is nonsense
to have our barrier primitives assuming a weakly ordered model but our
spinlocks to assume strongly ordered (weird bugs in simple spinlocked code, but
complex lockless code works fine?!).

The complaint that broken old ppros get more broken seems to be bogus as well:
wmb on i386 never catered to the old ppro to start with. The errata seem to
indicate that lockless code is going to be broken by definition regardless of
anything we do, short of adding a lock prefix to all potentially concurrent
memory operations. As a bandaid to reduce the chance of a bug, it may be
valid to do a dummy lock op here -- the public docs are too vague to really
know -- however that is a separate patch and completely independent of this
one.

So: rather than a vague nack, I'd really like to either have a hole shown
in my logic, or a counter proposal for a plan to "unconstrain" the exotic
memory ops like rep stos / nt operations, and actually have spinlocks and
mbs do the required barriers.

Buggy ppros: I have no interest in, given the vague errata and apparently
unfixable problems with lockless code; anybody is welcome to try adding
whatever they like to help them work, but again please don't confuse that
with having anything to do with this patch...

Winchip: can any of these CPUs with ooostores do SMP? If not, then smp_wmb
can also be a simple barrier on i386 too.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/include/asm-i386/system.h
===================================================================
--- linux-2.6.orig/include/asm-i386/system.h
+++ linux-2.6/include/asm-i386/system.h
@@ -281,12 +281,12 @@ static inline unsigned long get_limit(un
    but make it already an possibility. */
 #define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
 #else
-#define wmb()	__asm__ __volatile__ ("": : :"memory")
+#define wmb() barrier()
 #endif
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
-#define smp_rmb()	rmb()
+#define smp_rmb()	barrier()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
Index: linux-2.6/include/asm-x86_64/system.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/system.h
+++ linux-2.6/include/asm-x86_64/system.h
@@ -141,8 +141,8 @@ static inline void write_cr8(unsigned lo
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do {} while(0)
 #else
 #define smp_mb()	barrier()
