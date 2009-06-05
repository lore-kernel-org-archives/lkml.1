Return-Path: <linux-kernel-owner+w=401wt.eu-S1755688AbZFEV7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688AbZFEV7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 17:59:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755123AbZFEV7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 17:59:17 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:47544 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754946AbZFEV7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 17:59:15 -0400
X-Amavis-Alert: BAD HEADER, Duplicate header field: "Cc"
Message-Id: <20090605191850.441840884@gentwo.org>
References: <20090605191819.376530498@gentwo.org>
User-Agent: quilt/0.46-1
Date: Fri, 05 Jun 2009 15:18:20 -0400
From: cl@linux-foundation.org
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>
Cc: davem@davemloft.net
Subject: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_* operations
Content-Disposition: inline; filename=this_cpu_ptr_intro
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).

The problem with per_cpu_ptr(x, smp_processor_id) is that it requires
an array lookup to find the offset for the cpu. Processors typically
have the offset for the current cpu area in some kind of (arch dependent)
efficiently accessible register or memory location.

We can use that instead of doing the array lookup to speed up the
determination of the addressof the percpu variable. This is particularly
significant because these lookups occur in performance critical paths
of the core kernel.

This optimization is a prerequiste to the introduction of per processor
atomic operations for the core code. Atomic per processor operations
implicitly do the offset calculation to the current per cpu area in a
single instruction. All the locations touched by this patchset are potential
candidates for atomic per cpu operations.

this_cpu_ptr comes in two flavors. The preemption context matters since we
are referring the the currently executing processor. In many cases we must
insure that the processor does not change while a code segment is executed.

__this_cpu_ptr 	-> Do not check for preemption context
this_cpu_ptr	-> Check preemption context


Provide generic functions that are used if an arch does not define optimized
this_cpu operations. The functions come also come in the two favors. The first
parameter is a scalar that is pointed to by a pointer acquired through
allocpercpu or by taking the address of a per cpu variable.

The operations are guaranteed to be atomic vs preemption if they modify
the scalar (unless they are prefixed by __ in which case they do not need
to be). The calculation of the per cpu offset is also guaranteed to be atomic.

this_cpu_read(scalar)
this_cpu_write(scalar, value)
this_cpu_add(scale, value)
this_cpu_sub(scalar, value)
this_cpu_inc(scalar)
this_cpu_dec(scalar)
this_cpu_and(scalar, value)
this_cpu_or(scalar, value)
this_cpu_xor(scalar, value)

The arches can override the defaults and provide atomic per cpu operations.
These atomic operations must provide both the relocation (x86 does it
through a segment override) and the operation
on the data in a single instruction. Otherwise preempt needs to be disabled
and there is no gain from providing arch implementations.

A third variant is provided prefixed by irqsafe_. These variants are safe
against hardware interrupts on the *same* processor (all per cpu atomic
primitives are *always* *only* providing safety for code running on the
*same* processor!). The increment needs to be implemented by the hardware
in such a way that it is a single RMW instruction that is either processed
before or after an interrupt.

cc: David Howells <dhowells@redhat.com>
cc: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>
cc: Rusty Russell <rusty@rustcorp.com.au>
cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 include/asm-generic/percpu.h |    5 +
 include/linux/percpu.h       |  144 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 149 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2009-06-04 13:38:28.000000000 -0500
+++ linux-2.6/include/linux/percpu.h	2009-06-04 14:15:51.000000000 -0500
@@ -176,4 +176,148 @@ do {									\
 # define percpu_xor(var, val)		__percpu_generic_to_op(var, (val), ^=)
 #endif
 
+
+/*
+ * Optimized manipulation for memory allocated through the per cpu
+ * allocator or for addresses taken from per cpu variables.
+ *
+ * The first group is used for accesses that must be done in a
+ * preemption safe way since we know that the context is not preempt
+ * safe
+ */
+#ifndef this_cpu_read
+# define this_cpu_read(pcp)						\
+  ({									\
+	*this_cpu_ptr(&(pcp));						\
+  })
+#endif
+
+#define _this_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	preempt_disable();						\
+	*__this_cpu_ptr(&pcp) op val;					\
+	preempt_enable_no_resched();					\
+} while (0)
+
+#ifndef this_cpu_write
+# define this_cpu_write(pcp, val)	__this_cpu_write((pcp), (val))
+#endif
+
+#ifndef this_cpu_add
+# define this_cpu_add(pcp, val)		_this_cpu_generic_to_op((pcp), (val), +=)
+#endif
+
+#ifndef this_cpu_sub
+# define this_cpu_sub(pcp, val)		this_cpu_add((pcp), -(val))
+#endif
+
+#ifndef this_cpu_inc
+# define this_cpu_inc(pcp)		this_cpu_add((pcp), 1)
+#endif
+
+#ifndef this_cpu_dec
+# define this_cpu_dec(pcp)		this_cpu_sub((pcp), 1)
+#endif
+
+#ifndef this_cpu_and
+# define this_cpu_and(pcp, val)		_this_cpu_generic_to_op((pcp), (val), &=)
+#endif
+
+#ifndef this_cpu_or
+# define this_cpu_or(pcp, val)		_this_cpu_generic_to_op((pcp), (val), |=)
+#endif
+
+#ifndef this_cpu_xor
+# define this_cpu_xor(pcp, val)		_this_cpu_generic_to_op((pcp), (val), ^=)
+#endif
+
+
+/*
+ * Generic percpu operations that do not require preemption handling.
+ * Either we do not care about races or the caller has the
+ * responsibility of handling preemptions issues.
+ */
+#ifndef __this_cpu_read
+# define __this_cpu_read(pcp)						\
+  ({									\
+	*__this_cpu_ptr(&(pcp));					\
+  })
+#endif
+
+#define __this_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	*__this_cpu_ptr(&(pcp)) op val;					\
+} while (0)
+
+#ifndef __this_cpu_write
+# define __this_cpu_write(pcp, val)	__this_cpu_generic_to_op((pcp), (val), =)
+#endif
+
+#ifndef __this_cpu_add
+# define __this_cpu_add(pcp, val)	__this_cpu_generic_to_op((pcp), (val), +=)
+#endif
+
+#ifndef __this_cpu_sub
+# define __this_cpu_sub(pcp, val)	__this_cpu_add((pcp), -(var))
+#endif
+
+#ifndef __this_cpu_inc
+# define __this_cpu_inc(pcp)		__this_cpu_add((pcp), 1)
+#endif
+
+#ifndef __this_cpu_dec
+# define __this_cpu_dec(pcp)		__this_cpu_sub((pcp), 1)
+#endif
+
+#ifndef __this_cpu_and
+# define __this_cpu_and(pcp, val)	__this_cpu_generic_to_op((pcp), (val), &=)
+#endif
+
+#ifndef __this_cpu_or
+# define __this_cpu_or(pcp, val)	__this_cpu_generic_to_op((pcp), (val), |=)
+#endif
+
+#ifndef __this_cpu_xor
+# define __this_cpu_xor(pcp, val)	__this_cpu_generic_to_op((pcp), (val), ^=)
+#endif
+
+/*
+ * IRQ safe versions
+ */
+#define irqsafe_cpu_generic_to_op(pcp, val, op)				\
+do {									\
+	unsigned long flags;						\
+	local_irqsave(flags);						\
+	*__this_cpu_ptr(&(pcp)) op val;					\
+	local_irqrestore(flags);					\
+} while (0)
+
+#ifndef irqsafe_this_cpu_add
+# define irqsafe_this_cpu_add(pcp, val)	irqsafe_cpu_generic_to_op((pcp), (val), +=)
+#endif
+
+#ifndef irqsafe_this_cpu_sub
+# define irqsafe_this_cpu_sub(pcp, val)	irqsafe_cpu_add((pcp), -(var))
+#endif
+
+#ifndef irqsafe_this_cpu_inc
+# define irqsafe_this_cpu_inc(pcp)	irqsafe_cpu_add((pcp), 1)
+#endif
+
+#ifndef irqsafe_this_cpu_dec
+# define irqsafe_this_cpu_dec(pcp)	irqsafe_cpu_sub((pcp), 1)
+#endif
+
+#ifndef irqsafe_this_cpu_and
+# define irqsafe_this_cpu_and(pcp, val)	irqsafe_cpu_generic_to_op((pcp), (val), &=)
+#endif
+
+#ifndef irqsafe_this_cpu_or
+# define irqsafe_this_cpu_or(pcp, val)	irqsafe_cpu_generic_to_op((pcp), (val), |=)
+#endif
+
+#ifndef irqsafe_this_cpu_xor
+# define irqsafe_this_cpu_xor(pcp, val)	irqsafe_cpu_generic_to_op((pcp), (val), ^=)
+#endif
+
 #endif /* __LINUX_PERCPU_H */
Index: linux-2.6/include/asm-generic/percpu.h
===================================================================
--- linux-2.6.orig/include/asm-generic/percpu.h	2009-06-04 13:38:28.000000000 -0500
+++ linux-2.6/include/asm-generic/percpu.h	2009-06-04 13:47:10.000000000 -0500
@@ -56,6 +56,9 @@ extern unsigned long __per_cpu_offset[NR
 #define __raw_get_cpu_var(var) \
 	(*SHIFT_PERCPU_PTR(&per_cpu_var(var), __my_cpu_offset))
 
+#define this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, my_cpu_offset)
+#define __this_cpu_ptr(ptr) SHIFT_PERCPU_PTR(ptr, __my_cpu_offset)
+
 
 #ifdef CONFIG_HAVE_SETUP_PER_CPU_AREA
 extern void setup_per_cpu_areas(void);
@@ -66,6 +69,8 @@ extern void setup_per_cpu_areas(void);
 #define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
 #define __get_cpu_var(var)			per_cpu_var(var)
 #define __raw_get_cpu_var(var)			per_cpu_var(var)
+#define this_cpu_ptr(ptr) per_cpu_ptr(ptr, 0)
+#define __this_cpu_ptr(ptr) this_cpu_ptr(ptr)
 
 #endif	/* SMP */
 

-- 
