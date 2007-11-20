Return-Path: <linux-kernel-owner+w=401wt.eu-S1756759AbXKTBOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbXKTBOb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:14:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754128AbXKTBNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:13:36 -0500
Received: from relay1.sgi.com ([192.48.171.29]:49820 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752806AbXKTBNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:33 -0500
Message-Id: <20071120011332.415903723@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:11:35 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 03/45] Generic CPU operations: Core piece
Content-Disposition: inline; filename=cpu_ops_base
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the per cpu subsystem is not able to use the atomic capabilities
of the processors we have.

This adds new functionality that allows the optimizing of per cpu variable
handliong. It in particular provides a simple way to exploit atomic operations
to avoid having to disable itnerrupts or add an per cpu offset.

F.e. current implementations may do

unsigned long flags;
struct stat_struct *p;

local_irq_save(flags);
/* Calculate address of per processor area */
p = CPU_PTR(stat, smp_processor_id());
p->counter++;
local_irq_restore(flags);

This whole segment can be replaced by a single CPU operation

CPU_INC(stat->counter);

And on most processors it is possible to perform the increment with
a single processor instruction. Processors have segment registers,
global registers and per cpu mappings of per cpu areas for that purpose.

The problem is that the current schemes cannot utilize those features.
local_t is not really addressing the issue since the offset calculation
is not solved. local_t is x86 processor specific. This solution here
can utilize other methods than just the x86 instruction set.

On x86 the above CPU_INC translated into a single instruction:

inc %%gs:(&stat->counter)

This instruction is interrupt safe since it can either be completed
or not.

The determination of the correct per cpu area for the current processor
does not require access to smp_processor_id() (expensive...). The gs
register is used to provide a processor specific offset to the respective
per cpu area where the per cpu variabvle resides.

Note tha the counter offset into the struct was added *before* the segment
selector was added. This is necessary to avoid calculation, In the past
we first determine the address of the stats structure on the respective
processor and then added the field offset. However, the offset may as
well be added earlier.

If stat was declared via DECLARE_PER_CPU then this patchset is capoable of
convincing the linker to provide the proper base address. In that case
no calculations are necessary.

Should the stats structure be reachable via a register then the address
calculation capabilities can be leverages to avoid calculations.

On IA64 the same will result in another single instruction using the
factor that we have a virtual address that always maps to the local per cpu
area.

fetchadd &stat->counter + (VCPU_BASE - __per_cpu_base)

The access is forced into the per cpu address reachable via the virtualized
address. Again the counter field offset is eadded to the offset. The access
is then similarly a singular instruction thing as on x86.

In order to be able to exploit the atomicity of this instructions we
introduce a series of new functions that take a BASE pointer (a pointer
into the area of cpu 0 which is the canonical base).

CPU_READ()
CPU_WRITE()
CPU_INC
CPU_DEC
CPU_ADD
CPU_SUB
CPU_XCHG
CPU_CMPXCHG






Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 include/linux/percpu.h |  156 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)

Index: linux-2.6/include/linux/percpu.h
===================================================================
--- linux-2.6.orig/include/linux/percpu.h	2007-11-18 22:13:51.773274119 -0800
+++ linux-2.6/include/linux/percpu.h	2007-11-18 22:15:10.396773779 -0800
@@ -190,4 +190,160 @@ void cpu_free(void *cpu_pointer, unsigne
  */
 void *boot_cpu_alloc(unsigned long size);
 
+/*
+ * Fast Atomic per cpu operations.
+ *
+ * The following operations can be overridden by arches to implement fast
+ * and efficient operations. The operations are atomic meaning that the
+ * determination of the processor, the calculation of the address and the
+ * operation on the data is an atomic operation.
+ */
+
+#ifndef CONFIG_FAST_CPU_OPS
+
+/*
+ * The fallbacks are rather slow but they are safe
+ *
+ * The first group of macros is used when we it is
+ * safe to update the per cpu variable because
+ * preemption is off (per cpu variables that are not
+ * updated from interrupt cointext) or because
+ * interrupts are already off.
+ */
+
+#define __CPU_READ(obj)				\
+({						\
+	typeof(obj) x;				\
+	x = *THIS_CPU(&(obj));			\
+	(x);					\
+})
+
+#define __CPU_WRITE(obj, value)			\
+({						\
+	*THIS_CPU((&(obj)) = value;		\
+})
+
+#define __CPU_ADD(obj, value)			\
+({						\
+	*THIS_CPU(&(obj)) += value;		\
+})
+
+
+#define __CPU_INC(addr) __CPU_ADD(addr, 1)
+#define __CPU_DEC(addr) __CPU_ADD(addr, -1)
+#define __CPU_SUB(addr, value) __CPU_ADD(addr, -(value))
+
+#define __CPU_CMPXCHG(obj, old, new)		\
+({						\
+	typeof(obj) x;				\
+	typeof(obj) *p = THIS_CPU(&(obj));	\
+	x = *p;					\
+	if (x == old)				\
+		*p = new;			\
+	(x);					\
+})
+
+#define __CPU_XCHG(obj, new)			\
+({						\
+	typeof(obj) x;				\
+	typeof(obj) *p = THIS_CPU(&(obj));	\
+	x = *p;					\
+	*p = new;				\
+	(x);					\
+})
+
+/*
+ * Second group used for per cpu variables that
+ * are not updated from an interrupt context.
+ * In that case we can simply disable preemption which
+ * may be free if the kernel is compiled without preemption.
+ */
+
+#define _CPU_READ(addr)				\
+({						\
+	(__CPU_READ(addr));			\
+})
+
+#define _CPU_WRITE(addr, value)			\
+({						\
+	__CPU_WRITE(addr, value);		\
+})
+
+#define _CPU_ADD(addr, value)			\
+({						\
+	preempt_disable();			\
+	__CPU_ADD(addr, value);			\
+	preempt_enable();			\
+})
+
+#define _CPU_INC(addr) _CPU_ADD(addr, 1)
+#define _CPU_DEC(addr) _CPU_ADD(addr, -1)
+#define _CPU_SUB(addr, value) _CPU_ADD(addr, -(value))
+
+#define _CPU_CMPXCHG(addr, old, new)		\
+({						\
+	typeof(addr) x;				\
+	preempt_disable();			\
+	x = __CPU_CMPXCHG(addr, old, new);	\
+	preempt_enable();			\
+	(x);					\
+})
+
+#define _CPU_XCHG(addr, new)			\
+({						\
+	typeof(addr) x;				\
+	preempt_disable();			\
+	x = __CPU_XCHG(addr, new);		\
+	preempt_enable();			\
+	(x);					\
+})
+
+/*
+ * Interrupt safe CPU functions
+ */
+
+#define CPU_READ(addr)				\
+({						\
+	(__CPU_READ(addr));			\
+})
+
+#define CPU_WRITE(addr, value)			\
+({						\
+	__CPU_WRITE(addr, value);		\
+})
+
+#define CPU_ADD(addr, value)			\
+({						\
+	unsigned long flags;			\
+	local_irq_save(flags);			\
+	__CPU_ADD(addr, value);			\
+	local_irq_restore(flags);		\
+})
+
+#define CPU_INC(addr) CPU_ADD(addr, 1)
+#define CPU_DEC(addr) CPU_ADD(addr, -1)
+#define CPU_SUB(addr, value) CPU_ADD(addr, -(value))
+
+#define CPU_CMPXCHG(addr, old, new)		\
+({						\
+	unsigned long flags;			\
+	typeof(*addr) x;			\
+	local_irq_save(flags);			\
+	x = __CPU_CMPXCHG(addr, old, new);	\
+	local_irq_restore(flags);		\
+	(x);					\
+})
+
+#define CPU_XCHG(addr, new)			\
+({						\
+	unsigned long flags;			\
+	typeof(*addr) x;			\
+	local_irq_save(flags);			\
+	x = __CPU_XCHG(addr, new);		\
+	local_irq_restore(flags);		\
+	(x);					\
+})
+
+#endif /* CONFIG_FAST_CPU_OPS */
+
 #endif /* __LINUX_PERCPU_H */

-- 
