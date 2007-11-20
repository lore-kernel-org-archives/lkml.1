Return-Path: <linux-kernel-owner+w=401wt.eu-S1759332AbXKTBZo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759332AbXKTBZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:25:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756698AbXKTBOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:14:14 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36902 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756136AbXKTBNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:13:41 -0500
Message-Id: <20071120011340.569486037@sgi.com>
References: <20071120011132.143632442@sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 19 Nov 2007 17:12:09 -0800
From: clameter@sgi.com
From: Christoph Lameter <clameter@sgi.com>
To: ak@suse.de
Cc: akpm@linux-foundation.org
Cc: travis@sgi.com
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [rfc 37/45] x86_64: Support for fast per cpu operations
Content-Disposition: inline; filename=cpu_ops_x86
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Support fast cpu ops in x86_64 by providing a series of functions that
generate the proper instructions. Define CONFIG_FAST_CPU_OPS so that core code
can exploit the availability of fast per cpu operations.

Signed-off-by: Christoph Lameter <clameter@sgi.com>

---
 arch/x86/Kconfig            |    4 
 include/asm-x86/percpu_64.h |  262 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 266 insertions(+)

Index: linux-2.6/arch/x86/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/Kconfig	2007-11-19 16:16:03.458140098 -0800
+++ linux-2.6/arch/x86/Kconfig	2007-11-19 16:17:17.473389874 -0800
@@ -137,6 +137,10 @@ config GENERIC_PENDING_IRQ
 	depends on GENERIC_HARDIRQS && SMP
 	default y
 
+config FAST_CPU_OPS
+	bool
+	default y
+
 config X86_SMP
 	bool
 	depends on X86_32 && SMP && !X86_VOYAGER
Index: linux-2.6/include/asm-x86/percpu_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/percpu_64.h	2007-11-19 16:17:16.953139798 -0800
+++ linux-2.6/include/asm-x86/percpu_64.h	2007-11-19 16:17:17.473389874 -0800
@@ -71,4 +71,266 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 #define EXPORT_PER_CPU_SYMBOL_GPL(var) EXPORT_SYMBOL_GPL(per_cpu__##var)
 
 
+#define __xp(x) ((volatile unsigned long *)(x))
+
+static inline unsigned long __cpu_read_gs(volatile void *ptr, int size)
+{
+	unsigned long result;
+	switch (size) {
+	case 1:
+		__asm__ ("mov %%gs:%1, %b0"
+				     : "=r"(result)
+				     : "m"(*__xp(ptr)));
+		return result;
+	case 2:
+		__asm__ ("movw %%gs:%1, %w0"
+				     : "=r"(result)
+				     : "m"(*__xp(ptr)));
+		return result;
+	case 4:
+		__asm__ ("movl %%gs:%1, %k0"
+				     : "=r"(result)
+				     : "m"(*__xp(ptr)));
+		return result;
+	case 8:
+		__asm__ ("movq %%gs:%1, %0"
+				     : "=r"(result)
+				     : "m"(*__xp(ptr)));
+		return result;
+	}
+	BUG();
+}
+
+#define cpu_read_gs(obj)\
+	((__typeof__(obj))__cpu_read_gs(&(obj), sizeof(obj)))
+
+static inline void __cpu_write_gs(volatile void *ptr,
+				unsigned long data, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("mov %b0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("movw %w0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("movl %k0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("movq %0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_write_gs(obj, value)\
+	__cpu_write_gs(&(obj), (unsigned long)value, sizeof(obj))
+
+static inline void __cpu_add_gs(volatile void *ptr,
+				long data, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("add %b0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("addw %w0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("addl %k0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("addq %0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_add_gs(obj, value)\
+	__cpu_add_gs(&(obj), (unsigned long)value, sizeof(obj))
+
+static inline void __cpu_sub_gs(volatile void *ptr,
+				long data, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("sub %b0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("subw %w0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("subl %k0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("subq %0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_sub_gs(obj, value)\
+	__cpu_sub_gs(&(obj), (unsigned long)value, sizeof(obj))
+
+static inline void __cpu_xchg_gs(volatile void *ptr,
+				long data, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("xchg %b0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("xchgw %w0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("xchgl %k0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("xchgq %0, %%gs:%1"
+				: : "ri"(data), "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_xchg_gs(obj, value)\
+	__cpu_xchg_gs(&(obj), (unsigned long)value, sizeof(obj))
+
+static inline void __cpu_inc_gs(volatile void *ptr, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("incb %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("incw %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("incl %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("incq %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_inc_gs(obj)\
+	__cpu_inc_gs(&(obj), sizeof(obj))
+
+static inline void __cpu_dec_gs(volatile void *ptr, int size)
+{
+	switch (size) {
+	case 1:
+		__asm__ ("decb %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 2:
+		__asm__ ("decw %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 4:
+		__asm__ ("decl %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	case 8:
+		__asm__ ("decq %%gs:%0"
+				: : "m"(*__xp(ptr)));
+		return;
+	}
+	BUG();
+}
+
+#define cpu_dec_gs(obj)\
+	__cpu_dec_gs(&(obj), sizeof(obj))
+
+static inline unsigned long __cmpxchg_local_gs(volatile void *ptr,
+			unsigned long old, unsigned long new, int size)
+{
+	unsigned long prev;
+	switch (size) {
+	case 1:
+		__asm__ ("cmpxchgb %b1, %%gs:%2"
+				     : "=a"(prev)
+				     : "q"(new), "m"(*__xp(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 2:
+		__asm__ ("cmpxchgw %w1, %%gs:%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xp(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 4:
+		__asm__ ("cmpxchgl %k1, %%gs:%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xp(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	case 8:
+		__asm__ ("cmpxchgq %1, %%gs:%2"
+				     : "=a"(prev)
+				     : "r"(new), "m"(*__xp(ptr)), "0"(old)
+				     : "memory");
+		return prev;
+	}
+	return old;
+}
+
+#define cmpxchg_local_gs(obj, o, n)\
+	((__typeof__(obj))__cmpxchg_local_gs(&(obj),(unsigned long)(o),\
+					(unsigned long)(n),sizeof(obj)))
+
+#define CPU_READ(obj)		cpu_read_gs(obj)
+#define CPU_WRITE(obj,val)	cpu_write_gs(obj, val)
+#define CPU_ADD(obj,val)	cpu_add_gs(obj, val)
+#define CPU_SUB(obj,val)	cpu_sub_gs(obj, val)
+#define CPU_INC(obj)		cpu_inc_gs(obj)
+#define CPU_DEC(obj)		cpu_dec_gs(obj)
+
+#define CPU_XCHG(obj,val)	cpu_xchg_gs(obj, val)
+#define CPU_CMPXCHG(obj, old, new) cmpxchg_local_gs(obj, old, new)
+
+/*
+ * All cpu operations are interrupt safe and do not need to disable
+ * preempt. So the other variants all reduce to the same instruction.
+ */
+#define _CPU_READ CPU_READ
+#define _CPU_WRITE CPU_WRITE
+#define _CPU_ADD CPU_ADD
+#define _CPU_SUB CPU_SUB
+#define _CPU_INC CPU_INC
+#define _CPU_DEC CPU_DEC
+#define _CPU_XCHG CPU_XCHG
+#define _CPU_CMPXCHG CPU_CMPXCHG
+
+#define __CPU_READ CPU_READ
+#define __CPU_WRITE CPU_WRITE
+#define __CPU_ADD CPU_ADD
+#define __CPU_SUB CPU_SUB
+#define __CPU_INC CPU_INC
+#define __CPU_DEC CPU_DEC
+#define __CPU_XCHG CPU_XCHG
+#define __CPU_CMPXCHG CPU_CMPXCHG
+
 #endif /* _ASM_X8664_PERCPU_H_ */

-- 
