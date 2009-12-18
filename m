Return-Path: <linux-kernel-owner+w=401wt.eu-S1755552AbZLSA1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552AbZLSA1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbZLSA1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:27:06 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40067 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbZLSA0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:26:00 -0500
Message-Id: <20091218222654.666395441@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:30 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 13/16] Generic support for this_cpu_xchg
Content-Disposition: inline; filename=percpu_add_xchg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide generic this_cpu_xchg() and all fallbacks.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/percpu.h |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-12-18 15:33:12.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2009-12-18 15:34:15.000000000 -0600
@@ -499,6 +499,58 @@ static inline unsigned long this_cpu_cmp
 # define this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(__this_cpu_cmpxchg_, (old), (new))
 #endif
 
+static inline unsigned long __this_cpu_xchg_generic(volatile void *pptr,
+		unsigned long new, int size)
+{
+	unsigned long prev;
+	volatile void *ptr = __this_cpu_ptr(pptr);
+
+	switch (size) {
+	case 1: prev = *(u8 *)ptr;
+		*(u8 *)ptr = (u8)new;
+		break;
+	case 2: prev = *(u16 *)ptr;
+		*(u16 *)ptr = (u16)new;
+		break;
+	case 4: prev = *(u32 *)ptr;
+		*(u32 *)ptr = (u32)new;
+		break;
+	case 8: prev = *(u64 *)ptr;
+		*(u64 *)ptr = (u64)new;
+		break;
+	default:
+		__bad_size_call_parameter();
+	}
+	return prev;
+}
+
+static inline unsigned long this_cpu_xchg_generic(volatile void *ptr,
+		unsigned long new, int size)
+{
+	unsigned long prev;
+
+	preempt_disable();
+	prev = __this_cpu_xchg_generic(ptr, new, size);
+	preempt_enable();
+	return prev;
+}
+
+#ifndef this_cpu_xchg
+# ifndef this_cpu_xchg_1
+#  define this_cpu_xchg_1(pcp, new) this_cpu_xchg_generic((pcp), (new), 1)
+# endif
+# ifndef this_cpu_xchg_2
+#  define this_cpu_xchg_2(pcp, new) this_cpu_xchg_generic((pcp), (new), 2)
+# endif
+# ifndef this_cpu_xchg_4
+#  define this_cpu_xchg_4(pcp, new) this_cpu_xchg_generic((pcp), (new), 4)
+# endif
+# ifndef this_cpu_xchg_8
+#  define this_cpu_xchg_8(pcp, new) this_cpu_xchg_generic((pcp), (new), 8)
+# endif
+# define this_cpu_xchg(pcp, new) __pcpu_size_call_return(__this_cpu_xchg_, (new))
+#endif
+
 /*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
@@ -666,6 +718,22 @@ do {									\
 # define __this_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(__this_cpu_cmpxchg_, (old), (new))
 #endif
 
+#ifndef __this_cpu_xchg
+# ifndef __this_cpu_xchg_1
+#  define __this_cpu_xchg_1(pcp, new) __this_cpu_xchg_generic((pcp), (new), 1)
+# endif
+# ifndef __this_cpu_xchg_2
+#  define __this_cpu_xchg_2(pcp, new) __this_cpu_xchg_generic((pcp), (new), 2)
+# endif
+# ifndef __this_cpu_xchg_4
+#  define __this_cpu_xchg_4(pcp, new) __this_cpu_xchg_generic((pcp), (new), 4)
+# endif
+# ifndef __this_cpu_xchg_8
+#  define __this_cpu_xchg_8(pcp, new) __this_cpu_xchg_generic((pcp), (new), 8)
+# endif
+# define __this_cpu_xchg(pcp, new) __pcpu_size_call_return(__this_cpu_xchg_, (new))
+#endif
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
@@ -808,4 +876,31 @@ static inline unsigned long irqsafe_cpu_
 # define irqsafe_cpu_cmpxchg(pcp, old, new) __pcpu_size_call_return(irqsafe_cpu_cmpxchg_, (old), (new))
 #endif
 
+static inline unsigned long irqsafe_cpu_xchg_generic(volatile void *ptr,
+		unsigned long new, int size)
+{
+	unsigned long flags, prev;
+
+	local_irq_save(flags);
+	prev = __this_cpu_xchg_generic(ptr, new, size);
+	local_irq_restore(flags);
+	return prev;
+}
+
+#ifndef irqsafe_cpu_xchg
+# ifndef irqsafe_cpu_xchg_1
+#  define irqsafe_cpu_xchg_1(pcp, new) irqsafe_cpu_xchg_generic(((pcp), (new), 1)
+# endif
+# ifndef irqsafe_cpu_xchg_2
+#  define irqsafe_cpu_xchg_2(pcp, new) irqsafe_cpu_xchg_generic(((pcp), (new), 2)
+# endif
+# ifndef irqsafe_cpu_xchg_4
+#  define irqsafe_cpu_xchg_4(pcp, new) irqsafe_cpu_xchg_generic(((pcp), (new), 4)
+# endif
+# ifndef irqsafe_cpu_xchg_8
+#  define irqsafe_cpu_xchg_8(pcp, new) irqsafe_cpu_xchg_generic(((pcp), (new), 8)
+# endif
+# define irqsafe_cpu_xchg(pcp, new) __pcpu_size_call_return(irqsafe_cpu_xchg_, (new))
+#endif
+
 #endif /* __LINUX_PERCPU_H */

-- 
