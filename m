Return-Path: <linux-kernel-owner+w=401wt.eu-S1757795AbXJDFX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757795AbXJDFX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:23:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751789AbXJDFXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:23:50 -0400
Received: from ns2.suse.de ([195.135.220.15]:50377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029AbXJDFXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:23:49 -0400
Date: Thu, 4 Oct 2007 07:23:48 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: [rfc][patch 3/3] x86: optimise barriers
Message-ID: <20071004052348.GC15131@wotan.suse.de>
References: <20071004052153.GA15131@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004052153.GA15131@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


According to latest memory ordering specification documents from Intel and
AMD, both manufacturers are committed to in-order loads from cacheable memory
for the x86 architecture. Hence, smp_rmb() may be a simple barrier.

Also according to those documents, and according to existing practice in Linux
(eg. spin_unlock doesn't enforce ordering), stores to cacheable memory are
visible in program order too. Special string stores are safe -- their
constituent stores may be out of order, but they must complete in order WRT
surrounding stores. Nontemporal stores to WB memory can go out of order, and so
they should be fenced explicitly to make them appear in-order WRT other stores.
Hence, smp_wmb() may be a simple barrier.

http://developer.intel.com/products/processor/manuals/318147.pdf
http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/24593.pdf

In userspace microbenchmarks on a core2 system, fence instructions range
anywhere from around 15 cycles to 50, which may not be totally insignificant
in performance critical paths (code size will go down too).

However the primary motivation for this is to have the canonical barrier
implementation for x86 architecture.

smp_rmb on buggy pentium pros remains a locked op, which is apparently
required.

Signed-off-by: Nick Piggin <npiggin@suse.de>

---
Index: linux-2.6/include/asm-i386/system.h
===================================================================
--- linux-2.6.orig/include/asm-i386/system.h
+++ linux-2.6/include/asm-i386/system.h
@@ -274,7 +274,11 @@ static inline unsigned long get_limit(un
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
-#define smp_rmb()	rmb()
+#ifdef CONFIG_X86_PPRO_FENCE
+# define smp_rmb()	rmb()
+#else
+# define smp_rmb()	barrier()
+#endif
 #ifdef CONFIG_X86_OOSTORE
 # define smp_wmb() 	wmb()
 #else
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
