Return-Path: <linux-kernel-owner+w=401wt.eu-S1752765AbZLRA2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765AbZLRA2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:28:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZLRA2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:28:48 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:32978 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258AbZLRA2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:28:47 -0500
Date: Thu, 17 Dec 2009 18:27:23 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [this_cpu_xx V7 0/8] Per cpu atomics in core allocators and
 cleanup
In-Reply-To: <20091218001357.GA30450@Krystal>
Message-ID: <alpine.DEB.2.00.0912171823120.6885@router.home>
References: <20091214220320.665065925@quilx.com> <20091215174302.GA3928@Krystal> <4B2830CC.7040309@kernel.org> <20091216014031.GA12282@Krystal> <4B283BFE.2040005@kernel.org> <20091217133958.GA21618@Krystal> <alpine.DEB.2.00.0912171327220.3638@router.home>
 <20091217202558.GA21713@Krystal> <alpine.DEB.2.00.0912171443080.5819@router.home> <20091218001357.GA30450@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Dec 2009, Mathieu Desnoyers wrote:

> Sure, can you point me to a git tree I should work on top of which
> includes the per cpu infrastructure to extend ?

Linus' git tree contains what yoou need. I have a early draft here of a
patch to implement the generic portions. Unfinished. I hope I have time to
complete this. Feel free to complete it but keep me posted so that I wont
repeat anything you do.

The modifications to asm-generic/cmpxchg-local wont work since we need to
do this_cpu_ptr() pointer calculations within the protected sections. I
was in the middle of getting rid of it when I found it was time to go
home...


---
 include/asm-generic/cmpxchg-local.h |   24 ++++-
 include/linux/percpu.h              |  151 ++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 6 deletions(-)

Index: linux-2.6/include/asm-generic/cmpxchg-local.h
===================================================================
--- linux-2.6.orig/include/asm-generic/cmpxchg-local.h	2009-12-17 17:44:01.000000000 -0600
+++ linux-2.6/include/asm-generic/cmpxchg-local.h	2009-12-17 17:46:31.000000000 -0600
@@ -6,13 +6,12 @@
 extern unsigned long wrong_size_cmpxchg(volatile void *ptr);

 /*
- * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned
- * long parameter, supporting various types of architectures.
+ * Generic version of __cmpxchg_local.
  */
-static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
+static inline unsigned long ____cmpxchg_local_generic(volatile void *ptr,
 		unsigned long old, unsigned long new, int size)
 {
-	unsigned long flags, prev;
+	unsigned long prev;

 	/*
 	 * Sanity checking, compile-time.
@@ -20,7 +19,6 @@ static inline unsigned long __cmpxchg_lo
 	if (size == 8 && sizeof(unsigned long) != 8)
 		wrong_size_cmpxchg(ptr);

-	local_irq_save(flags);
 	switch (size) {
 	case 1: prev = *(u8 *)ptr;
 		if (prev == old)
@@ -41,11 +39,25 @@ static inline unsigned long __cmpxchg_lo
 	default:
 		wrong_size_cmpxchg(ptr);
 	}
-	local_irq_restore(flags);
 	return prev;
 }

 /*
+ * Generic version of __cmpxchg_local (disables interrupts). Takes an unsigned
+ * long parameter, supporting various types of architectures.
+ */
+static inline unsigned long __cmpxchg_local_generic(volatile void *ptr,
+		unsigned long old, unsigned long new, int size)
+{
+	unsigned long flags, r;
+
+	local_irq_save(flags);
+	r = ____cmpxchg_local_generic(ptr, old, new ,size);
+	local_irq_restore(flags);
+	return r;
+}
+
+/*
  * Generic version of __cmpxchg64_local. Takes an u64 parameter.
  */
 static inline u64 __cmpxchg64_local_generic(volatile void *ptr,
Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-12-17 17:31:10.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2009-12-17 18:23:02.000000000 -0600
@@ -443,6 +443,48 @@ do {									\
 # define this_cpu_xor(pcp, val)		__pcpu_size_call(this_cpu_or_, (pcp), (val))
 #endif

+#ifndef this_cpu_cmpxchg
+# ifndef this_cpu_cmpxchg_1
+#  define this_cpu_cmpxchg_1(pcp, old, new) this_cpu_cmpxchg_generic(((pcp), (old), (new), 1)
+# endif
+# ifndef this_cpu_cmpxchg_2
+#  define this_cpu_cmpxchg_2(pcp, old, new) this_cpu_cmpxchg_generic(((pcp), (old), (new), 2)
+# endif
+# ifndef this_cpu_cmpxchg_4
+#  define this_cpu_cmpxchg_4(pcp, old, new) this_cpu_cmpxchg_generic(((pcp), (old), (new), 4)
+# endif
+# ifndef this_cpu_cmpxchg_8
+#  define this_cpu_cmpxchg_8(pcp, old, new) this_cpu_cmpxchg_generic(((pcp), (old), (new), 8)
+# endif
+# define this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(this_cpu_cmpxchg_, (old), (new))
+#endif
+
+#define _this_cpu_generic_xchg_op(pcp, val)				\
+  ({									\
+	typeof(*(var)) __tmp_var__;					\
+	preempt_disable();						\
+	__tmp_var = __this_cpu_read(pcp);				\
+	__this_cpu_read(pcp) = (val);					\
+	preemt_enable();						\
+	__tmp_var__;							\
+  })
+
+#ifndef this_cpu_xchg
+# ifndef this_cpu_xchg_1
+#  define this_cpu_xchg_1(pcp, val) _this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef this_cpu_xchg_2
+#  define this_cpu_xchg_2(pcp, val) _this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef this_cpu_xchg_4
+#  define this_cpu_xchg_4(pcp, val) _this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef this_cpu_xchg_8
+#  define this_cpu_xchg_8(pcp, val) _this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# define this_cpu_xchg(pcp, val) __pcpu_size_call_return(this_cpu_xchg_, (val))
+#endif
+
 /*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
@@ -594,6 +636,46 @@ do {									\
 # define __this_cpu_xor(pcp, val)	__pcpu_size_call(__this_cpu_xor_, (pcp), (val))
 #endif

+#ifndef __this_cpu_cmpxchg
+# ifndef __this_cpu_cmpxchg_1
+#  define __this_cpu_cmpxchg _1(pcp, old, new) ____cmpxchg_local_generic(__this_cpu_ptr(pcp), (old), (new), 1)
+# endif
+# ifndef __this_cpu_cmpxchg_2
+#  define __this_cpu_cmpxchg_2(pcp, old, new) ____cmpxchg_local_generic(__this_cpu_ptr(pcp), (old), (new), 2)
+# endif
+# ifndef __this_cpu_cmpxchg_4
+#  define __this_cpu_cmpxchg_4(pcp, old, new) ____cmpxchg_local_generic(__this_cpu_ptr(pcp), (old), (new), 4)
+# endif
+# ifndef __this_cpu_cmpxchg_8
+#  define __this_cpu_cmpxchg_8(pcp, old, new) ____cmpxchg_local_generic(__this_cpu_ptr(pcp), (old), (new), 8)
+# endif
+# define __this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(__this_cpu_cmpxchg_, (old), (new))
+#endif
+
+#define _this_cpu_generic_xchg_op(pcp, val)				\
+  ({									\
+	typeof(*(var)) __tmp_var__;					\
+	__tmp_var = __this_cpu_read(pcp);				\
+	__this_cpu_write((pcp), val);					\
+	__tmp_var__;							\
+  })
+
+#ifndef __this_cpu_xchg
+# ifndef __this_cpu_xchg_1
+#  define __this_cpu_xchg_1(pcp, val) __this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef __this_cpu_xchg_2
+#  define __this_cpu_xchg_2(pcp, val) __this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef __this_cpu_xchg_4
+#  define __this_cpu_xchg_4(pcp, val) __this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# ifndef __this_cpu_xchg_8
+#  define __this_cpu_xchg_8(pcp, val) __this_cpu_generic_xchg_op((pcp), (val))
+# endif
+# define __this_cpu_xchg(pcp, val) __pcpu_size_call_return(__this_cpu_xchg_, (val))
+#endif
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
@@ -709,4 +791,73 @@ do {									\
 # define irqsafe_cpu_xor(pcp, val) __pcpu_size_call(irqsafe_cpu_xor_, (val))
 #endif

+#ifndef irqsafe_cpu_cmpxchg
+# ifndef irqsafe_cpu_cmpxchg_1
+#  define irqsafe_cpu_cmpxchg_1(pcp, old, new) __cmpxchg_local_generic(((pcp), (old), (new), 1)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_2
+#  define irqsafe_cpu_cmpxchg_2(pcp, old, new) __cmpxchg_local_generic(((pcp), (old), (new), 2)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_4
+#  define irqsafe_cpu_cmpxchg_4(pcp, old, new) __cmpxchg_local_generic(((pcp), (old), (new), 4)
+# endif
+# ifndef irqsafe_cpu_cmpxchg_8
+#  define irqsafe_cpu_cmpxchg_8(pcp, old, new) __cmpxchg_local_generic(((pcp), (old), (new), 8)
+# endif
+# define irqsafe_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(irqsafe_cpu_cmpxchg_, (old), (new))
+#endif
+
+#define irqsafe_generic_xchg_op(pcp, val)				\
+  ({									\
+	typeof(*(var)) __tmp_var__;					\
+	unsigned long flags;						\
+	local_irq_disable(flags);					\
+	__tmp_var = __this_cpu_read(pcp);				\
+	__this_cpu_write(pcp, val);					\
+	local_irq_enable(flags);					\
+	__tmp_var__;							\
+  })
+
+#ifndef irqsafe_cpu_xchg
+# ifndef irqsafe_cpu_xchg_1
+#  define irqsafe_cpu_xchg_1(pcp, val) irqsafe_generic_xchg_op((pcp), (val))
+# endif
+# ifndef irqsafe_cpu_xchg_2
+#  define irqsafe_cpu_xchg_2(pcp, val) irqsafe_generic_xchg_op((pcp), (val))
+# endif
+# ifndef irqsafe_cpu_xchg_4
+#  define irqsafe_cpu_xchg_4(pcp, val) irqsafe_generic_xchg_op((pcp), (val))
+# endif
+# ifndef irqsafe_cpu_xchg_8
+#  define irqsafe_cpu_xchg_8(pcp, val) irqsafe_generic_xchg_op((pcp), (val))
+# endif
+# define irqsafe_cpu_xchg(pcp, val) __pcpu_size_call_return(irqsafe_cpu_xchg_, (val))
+#endif
+
+#define _this_cpu_generic_add_return_op(pcp, val)			\
+do {									\
+	preempt_disable();						\
+	*__this_cpu_ptr(&pcp) op val;					\
+	preempt_enable();						\
+} while (0)
+
+
+#ifndef this_cpu_add_return
+# ifndef this_cpu_add_return_1
+#  define this_cpu_add_return_1(pcp, val) _this_cpu_generic_add_return_op((pcp), (val))
+# endif
+# ifndef this_cpu_ _2
+#  define this_cpu_add_return_2(pcp, val) _this_cpu_generic_add_return_op((pcp), (val))
+# endif
+# ifndef this_cpu_add_return_4
+#  define this_cpu_add_return_4(pcp, val) _this_cpu_generic_add_return_op((pcp), (val))
+# endif
+# ifndef this_cpu_add_return_8
+#  define this_cpu_add_return_8(pcp, val) _this_cpu_generic_add_return_op((pcp), (val))
+# endif
+# define this_cpu_add_return(pcp, val) __pcpu_size_call_return(_cpu_ _, (val))
+#endif
+
+#ifndef irqsafe_cpu_add_return
+
 #endif /* __LINUX_PERCPU_H */
