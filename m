Return-Path: <linux-kernel-owner+w=401wt.eu-S1757393AbXJDFXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393AbXJDFXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 01:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXJDFXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 01:23:00 -0400
Received: from mail.suse.de ([195.135.220.2]:53411 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbXJDFW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 01:22:59 -0400
Date: Thu, 4 Oct 2007 07:22:58 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: [rfc][patch 2/3] x86: fix IO write barriers
Message-ID: <20071004052258.GB15131@wotan.suse.de>
References: <20071004052153.GA15131@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071004052153.GA15131@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


wmb() on x86 must always include a barrier, because stores can go out of
order in many cases when dealing with devices (eg. WC memory).

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/include/asm-i386/system.h
===================================================================
--- linux-2.6.orig/include/asm-i386/system.h
+++ linux-2.6/include/asm-i386/system.h
@@ -216,6 +216,7 @@ static inline unsigned long get_limit(un
 
 #define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
 #define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
+#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
 
 /**
  * read_barrier_depends - Flush all pending reads that subsequents reads
@@ -271,18 +272,14 @@ static inline unsigned long get_limit(un
 
 #define read_barrier_depends()	do { } while(0)
 
-#ifdef CONFIG_X86_OOSTORE
-/* Actually there are no OOO store capable CPUs for now that do SSE, 
-   but make it already an possibility. */
-#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
-#else
-#define wmb()	__asm__ __volatile__ ("": : :"memory")
-#endif
-
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
 #define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
+#ifdef CONFIG_X86_OOSTORE
+# define smp_wmb() 	wmb()
+#else
+# define smp_wmb()	barrier()
+#endif
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 #else
Index: linux-2.6/include/asm-x86_64/system.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/system.h
+++ linux-2.6/include/asm-x86_64/system.h
@@ -159,12 +159,8 @@ static inline void write_cr8(unsigned lo
  */
 #define mb() 	asm volatile("mfence":::"memory")
 #define rmb()	asm volatile("lfence":::"memory")
-
-#ifdef CONFIG_UNORDERED_IO
 #define wmb()	asm volatile("sfence" ::: "memory")
-#else
-#define wmb()	asm volatile("" ::: "memory")
-#endif
+
 #define read_barrier_depends()	do {} while(0)
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
 
