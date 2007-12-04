Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbXLDSxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbXLDSxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 13:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753872AbXLDSvq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 13:51:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145AbXLDSvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 13:51:45 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 6/8] unify smp parts of system.h
Date: Tue,  4 Dec 2007 14:06:26 -0200
Message-Id: <11967844173360-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11967844123402-git-send-email-gcosta@redhat.com>
References: <11967843881946-git-send-email-gcosta@redhat.com> <11967843943958-git-send-email-gcosta@redhat.com> <11967843983411-git-send-email-gcosta@redhat.com> <11967844032081-git-send-email-gcosta@redhat.com> <11967844071346-git-send-email-gcosta@redhat.com> <11967844123402-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory barrier parts of system.h are not very different between
i386 and x86_64, the main difference being the availability of
instructions, which we handle with the use of ifdefs.

They are consolidated in system.h file, and then removed from
the arch-specific headers.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 include/asm-x86/system.h    |  105 +++++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/system_32.h |   99 ----------------------------------------
 include/asm-x86/system_64.h |   25 ----------
 3 files changed, 105 insertions(+), 124 deletions(-)

diff --git a/include/asm-x86/system.h b/include/asm-x86/system.h
index f1fdc55..ecb782b 100644
--- a/include/asm-x86/system.h
+++ b/include/asm-x86/system.h
@@ -217,4 +217,109 @@ extern void free_init_pages(char *what, unsigned long begin, unsigned long end);
 void default_idle(void);
 void __show_registers(struct pt_regs *, int all);
 
+/*
+ * Force strict CPU ordering.
+ * And yes, this is required on UP too when we're talking
+ * to devices.
+ */
+#ifdef CONFIG_X86_32
+/*
+ * For now, "wmb()" doesn't actually do anything, as all
+ * Intel CPU's follow what Intel calls a *Processor Order*,
+ * in which all writes are seen in the program order even
+ * outside the CPU.
+ *
+ * I expect future Intel CPU's to have a weaker ordering,
+ * but I'd also expect them to finally get their act together
+ * and add some real memory barriers if so.
+ *
+ * Some non intel clones support out of order store. wmb() ceases to be a
+ * nop for these.
+ */
+#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
+#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
+#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
+#else
+#define mb() 	asm volatile("mfence":::"memory")
+#define rmb()	asm volatile("lfence":::"memory")
+#define wmb()	asm volatile("sfence" ::: "memory")
+#endif
+
+/**
+ * read_barrier_depends - Flush all pending reads that subsequents reads
+ * depend on.
+ *
+ * No data-dependent reads from memory-like regions are ever reordered
+ * over this barrier.  All reads preceding this primitive are guaranteed
+ * to access memory (but not necessarily other CPUs' caches) before any
+ * reads following this primitive that depend on the data return by
+ * any of the preceding reads.  This primitive is much lighter weight than
+ * rmb() on most CPUs, and is never heavier weight than is
+ * rmb().
+ *
+ * These ordering constraints are respected by both the local CPU
+ * and the compiler.
+ *
+ * Ordering is not guaranteed by anything other than these primitives,
+ * not even by data dependencies.  See the documentation for
+ * memory_barrier() for examples and URLs to more information.
+ *
+ * For example, the following code would force ordering (the initial
+ * value of "a" is zero, "b" is one, and "p" is "&a"):
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	b = 2;
+ *	memory_barrier();
+ *	p = &b;				q = p;
+ *					read_barrier_depends();
+ *					d = *q;
+ * </programlisting>
+ *
+ * because the read of "*q" depends on the read of "p" and these
+ * two reads are separated by a read_barrier_depends().  However,
+ * the following code, with the same initial values for "a" and "b":
+ *
+ * <programlisting>
+ *	CPU 0				CPU 1
+ *
+ *	a = 2;
+ *	memory_barrier();
+ *	b = 3;				y = b;
+ *					read_barrier_depends();
+ *					x = a;
+ * </programlisting>
+ *
+ * does not enforce ordering, since there is no data dependency between
+ * the read of "a" and the read of "b".  Therefore, on some CPUs, such
+ * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
+ * in cases like this where there are no data dependencies.
+ **/
+
+#define read_barrier_depends()	do { } while (0)
+
+#ifdef CONFIG_SMP
+#define smp_mb()	mb()
+#ifdef CONFIG_X86_PPRO_FENCE
+# define smp_rmb()	rmb()
+#else
+# define smp_rmb()	barrier()
+#endif
+#ifdef CONFIG_X86_OOSTORE
+# define smp_wmb() 	wmb()
+#else
+# define smp_wmb()	barrier()
+#endif
+#define smp_read_barrier_depends()	read_barrier_depends()
+#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
+#else
+#define smp_mb()	barrier()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
+#define smp_read_barrier_depends()	do { } while (0)
+#define set_mb(var, value) do { var = value; barrier(); } while (0)
+#endif
+
+
 #endif
diff --git a/include/asm-x86/system_32.h b/include/asm-x86/system_32.h
index 6c69567..1201880 100644
--- a/include/asm-x86/system_32.h
+++ b/include/asm-x86/system_32.h
@@ -36,105 +36,6 @@ extern struct task_struct * FASTCALL(__switch_to(struct task_struct *prev, struc
 #endif	/* __KERNEL__ */
 
 
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- *
- * For now, "wmb()" doesn't actually do anything, as all
- * Intel CPU's follow what Intel calls a *Processor Order*,
- * in which all writes are seen in the program order even
- * outside the CPU.
- *
- * I expect future Intel CPU's to have a weaker ordering,
- * but I'd also expect them to finally get their act together
- * and add some real memory barriers if so.
- *
- * Some non intel clones support out of order store. wmb() ceases to be a
- * nop for these.
- */
- 
-
-#define mb() alternative("lock; addl $0,0(%%esp)", "mfence", X86_FEATURE_XMM2)
-#define rmb() alternative("lock; addl $0,0(%%esp)", "lfence", X86_FEATURE_XMM2)
-#define wmb() alternative("lock; addl $0,0(%%esp)", "sfence", X86_FEATURE_XMM)
-
-/**
- * read_barrier_depends - Flush all pending reads that subsequents reads
- * depend on.
- *
- * No data-dependent reads from memory-like regions are ever reordered
- * over this barrier.  All reads preceding this primitive are guaranteed
- * to access memory (but not necessarily other CPUs' caches) before any
- * reads following this primitive that depend on the data return by
- * any of the preceding reads.  This primitive is much lighter weight than
- * rmb() on most CPUs, and is never heavier weight than is
- * rmb().
- *
- * These ordering constraints are respected by both the local CPU
- * and the compiler.
- *
- * Ordering is not guaranteed by anything other than these primitives,
- * not even by data dependencies.  See the documentation for
- * memory_barrier() for examples and URLs to more information.
- *
- * For example, the following code would force ordering (the initial
- * value of "a" is zero, "b" is one, and "p" is "&a"):
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	b = 2;
- *	memory_barrier();
- *	p = &b;				q = p;
- *					read_barrier_depends();
- *					d = *q;
- * </programlisting>
- *
- * because the read of "*q" depends on the read of "p" and these
- * two reads are separated by a read_barrier_depends().  However,
- * the following code, with the same initial values for "a" and "b":
- *
- * <programlisting>
- *	CPU 0				CPU 1
- *
- *	a = 2;
- *	memory_barrier();
- *	b = 3;				y = b;
- *					read_barrier_depends();
- *					x = a;
- * </programlisting>
- *
- * does not enforce ordering, since there is no data dependency between
- * the read of "a" and the read of "b".  Therefore, on some CPUs, such
- * as Alpha, "y" could be set to 3 and "x" to 0.  Use rmb()
- * in cases like this where there are no data dependencies.
- **/
-
-#define read_barrier_depends()	do { } while(0)
-
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#ifdef CONFIG_X86_PPRO_FENCE
-# define smp_rmb()	rmb()
-#else
-# define smp_rmb()	barrier()
-#endif
-#ifdef CONFIG_X86_OOSTORE
-# define smp_wmb() 	wmb()
-#else
-# define smp_wmb()	barrier()
-#endif
-#define smp_read_barrier_depends()	read_barrier_depends()
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do { } while(0)
-#define set_mb(var, value) do { var = value; barrier(); } while (0)
-#endif
-
 #include <linux/irqflags.h>
 
 /*
diff --git a/include/asm-x86/system_64.h b/include/asm-x86/system_64.h
index bb058ad..80be206 100644
--- a/include/asm-x86/system_64.h
+++ b/include/asm-x86/system_64.h
@@ -41,31 +41,6 @@
 
 #endif	/* __KERNEL__ */
 
-#ifdef CONFIG_SMP
-#define smp_mb()	mb()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#else
-#define smp_mb()	barrier()
-#define smp_rmb()	barrier()
-#define smp_wmb()	barrier()
-#define smp_read_barrier_depends()	do {} while(0)
-#endif
-
-    
-/*
- * Force strict CPU ordering.
- * And yes, this is required on UP too when we're talking
- * to devices.
- */
-#define mb() 	asm volatile("mfence":::"memory")
-#define rmb()	asm volatile("lfence":::"memory")
-#define wmb()	asm volatile("sfence" ::: "memory")
-
-#define read_barrier_depends()	do {} while(0)
-#define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
-
 #include <linux/irqflags.h>
 
 #endif
-- 
1.4.4.2

