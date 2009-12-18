Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZLSA2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZLSA2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 19:28:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755087AbZLSA04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 19:26:56 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40047 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762AbZLSAZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 19:25:58 -0500
Message-Id: <20091218222655.756199670@quilx.com>
References: <20091218222617.384355422@quilx.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Dec 2009 16:26:32 -0600
From: Christoph Lameter <cl@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
CC: Mel Gorman <mel@csn.ul.ie>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [this_cpu_xx V8 15/16] Generic support for this_cpu_add_return()
Content-Disposition: inline; filename=percpu_add_add_return
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows core code to use this_cpu_add_return()
Provides all fallback scenarios.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/linux/percpu.h |   90 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-12-18 15:34:15.000000000 -0600
+++ linux-2.6/include/linux/percpu.h	2009-12-18 15:34:49.000000000 -0600
@@ -551,6 +551,53 @@ static inline unsigned long this_cpu_xch
 # define this_cpu_xchg(pcp, new) __pcpu_size_call_return(__this_cpu_xchg_, (new))
 #endif
 
+static inline unsigned long __this_cpu_add_return_generic(volatile void *ptr,
+		unsigned long val, int size)
+{
+	unsigned long result;
+
+	switch (size) {
+	case 1: result = (*__this_cpu_ptr((u8 *)ptr) += val);
+		break;
+	case 2: result = (*__this_cpu_ptr((u16 *)ptr) += val);
+		break;
+	case 4: result = (*__this_cpu_ptr((u32 *)ptr) += val);
+		break;
+	case 8: result = (*__this_cpu_ptr((u64 *)ptr) += val);
+		break;
+	default:
+		__bad_size_call_parameter();
+	}
+	return result;
+}
+
+static inline unsigned long this_cpu_add_return_generic(volatile void *ptr,
+		unsigned long val, int size)
+{
+	unsigned long result;
+
+	preempt_disable();
+	result = __this_cpu_add_return_generic(ptr, val, size);
+	preempt_enable();
+	return result;
+}
+
+#ifndef this_cpu_add_return
+# ifndef this_cpu_add_return_1
+#  define this_cpu_add_return_1(pcp, val) this_cpu_add_return_generic((pcp), (val), 1)
+# endif
+# ifndef this_cpu_add_return_2
+#  define this_cpu_add_return_2(pcp, val) this_cpu_add_return_generic((pcp), (val), 2)
+# endif
+# ifndef this_cpu_add_return_4
+#  define this_cpu_add_return_4(pcp, val) this_cpu_add_return_generic((pcp), (val), 4)
+# endif
+# ifndef this_cpu_add_return_8
+#  define this_cpu_add_return_8(pcp, val) this_cpu_add_return_generic((pcp), (val), 8)
+# endif
+# define this_cpu_add_return(pcp, val) __pcpu_size_call_return(__this_cpu_add_return_, (val))
+#endif
+
 /*
  * Generic percpu operations that do not require preemption handling.
  * Either we do not care about races or the caller has the
@@ -734,6 +781,22 @@ do {									\
 # define __this_cpu_xchg(pcp, new) __pcpu_size_call_return(__this_cpu_xchg_, (new))
 #endif
 
+#ifndef __this_cpu_add_return
+# ifndef __this_cpu_add_return_1
+#  define __this_cpu_add_return_1(pcp, val) __this_cpu_add_return_generic((pcp), (val), 1)
+# endif
+# ifndef __this_cpu_add_return_2
+#  define __this_cpu_add_return_2(pcp, val) __this_cpu_add_return_generic((pcp), (val), 2)
+# endif
+# ifndef __this_cpu_add_return_4
+#  define __this_cpu_add_return_4(pcp, val) __this_cpu_add_return_generic((pcp), (val), 4)
+# endif
+# ifndef __this_cpu_add_return_8
+#  define __this_cpu_add_return_8(pcp, val) __this_cpu_add_return_generic((pcp), (val), 8)
+# endif
+# define __this_cpu_add_return(pcp, val) __pcpu_size_call_return(__this_cpu_add_return_, (val))
+#endif
+
 /*
  * IRQ safe versions of the per cpu RMW operations. Note that these operations
  * are *not* safe against modification of the same variable from another
@@ -903,4 +966,31 @@ static inline unsigned long irqsafe_cpu_
 # define irqsafe_cpu_xchg(pcp, new) __pcpu_size_call_return(irqsafe_cpu_xchg_, (new))
 #endif
 
+static inline unsigned long irqsafe_cpu_add_return_generic(volatile void *ptr,
+		unsigned long val, int size)
+{
+	unsigned long flags, result;
+
+	local_irq_save(flags);
+	result = __this_cpu_add_return_generic(ptr, val, size);
+	local_irq_restore(flags);
+	return result;
+}
+
+#ifndef irqsafe_cpu_add_return
+# ifndef irqsafe_cpu_add_return_1
+#  define irqsafe_cpu_add_return_1(pcp, val) irqsafe_cpu_add_return_generic(((pcp), (val), 1)
+# endif
+# ifndef irqsafe_cpu_add_return_2
+#  define irqsafe_cpu_add_return_2(pcp, val) irqsafe_cpu_add_return_generic(((pcp), (val), 2)
+# endif
+# ifndef irqsafe_cpu_add_return_4
+#  define irqsafe_cpu_add_return_4(pcp, val) irqsafe_cpu_add_return_generic(((pcp), (val), 4)
+# endif
+# ifndef irqsafe_cpu_add_return_8
+#  define irqsafe_cpu_add_return_8(pcp, val) irqsafe_cpu_add_return_generic(((pcp), (val), 8)
+# endif
+# define irqsafe_cpu_add_return(pcp, val) __pcpu_size_call_return(irqsafe_cpu_add_return_, (val))
+#endif
+
 #endif /* __LINUX_PERCPU_H */

-- 
