Return-Path: <linux-kernel-owner+w=401wt.eu-S1755803AbYGYVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803AbYGYVMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 17:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756198AbYGYVLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 17:11:22 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58872 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755793AbYGYVLT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 17:11:19 -0400
Message-Id: <20080725211118.221552000@polaris-admin.engr.sgi.com>
References: <20080725211117.586723000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Jul 2008 14:11:21 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Hugh Dickins <hugh@veritas.com>, Jack Steiner <steiner@sgi.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: [PATCH 4/4] x86_64: Reference zero-based percpu variables offset from gs
Content-Disposition: inline; filename=zero_based_use_gs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Now that %gs is pointing to the pda, it will then also point to the
    per cpu variables and the __get_cpu_var() and __put_cpu_var() macros
    can use:

        %gs:[&per_cpu_xxxx - __per_cpu_start]

    ... and since __per_cpu_start == 0 then:

        %gs:&per_cpu_var(xxx)
	
    becomes the optimized effective address.

    Since this is now a single instruction, we can remove the x86_64
    non-preemptible versions of x86_read_percpu() and x86_write_percpu().

  * Other cleanups in include/asm-x86/percpu.h

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/percpu.h |   62 +++++++++--------------------------------------
 1 file changed, 13 insertions(+), 49 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
@@ -5,41 +5,19 @@
 #include <linux/compiler.h>
 #include <asm/pda.h>
 
-/* Same as asm-generic/percpu.h */
+/* Same as asm-generic/percpu.h, except we use %gs as a segment offset. */
 #ifdef CONFIG_SMP
 #define __my_cpu_offset read_pda(data_offset)
+#define __percpu_seg "%%gs:"
+#else
+#define __percpu_seg ""
 #endif
+
 #include <asm-generic/percpu.h>
 
 DECLARE_PER_CPU(struct x8664_pda, pda);
 
-/*
- * These are supposed to be implemented as a single instruction which
- * operates on the per-cpu data base segment.  x86-64 doesn't have
- * that yet, so this is a fairly inefficient workaround for the
- * meantime.  The single instruction is atomic with respect to
- * preemption and interrupts, so we need to explicitly disable
- * interrupts here to achieve the same effect.  However, because it
- * can be used from within interrupt-disable/enable, we can't actually
- * disable interrupts; disabling preemption is enough.
- */
-#define x86_read_percpu(var)						\
-	({								\
-		typeof(per_cpu_var(var)) __tmp;				\
-		preempt_disable();					\
-		__tmp = __get_cpu_var(var);				\
-		preempt_enable();					\
-		__tmp;							\
-	})
-
-#define x86_write_percpu(var, val)					\
-	do {								\
-		preempt_disable();					\
-		__get_cpu_var(var) = (val);				\
-		preempt_enable();					\
-	} while(0)
-
-#else /* CONFIG_X86_64 */
+#else /* !CONFIG_X86_64 */
 
 #ifdef __ASSEMBLY__
 
@@ -68,36 +46,23 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 
 #else /* ...!ASSEMBLY */
 
-/*
- * PER_CPU finds an address of a per-cpu variable.
- *
- * Args:
- *    var - variable name
- *    cpu - 32bit register containing the current CPU number
- *
- * The resulting address is stored in the "cpu" argument.
- *
- * Example:
- *    PER_CPU(cpu_gdt_descr, %ebx)
- */
 #ifdef CONFIG_SMP
-
 #define __my_cpu_offset x86_read_percpu(this_cpu_off)
-
-/* fs segment starts at (positive) offset == __per_cpu_offset[cpu] */
 #define __percpu_seg "%%fs:"
-
-#else  /* !SMP */
-
+#else
 #define __percpu_seg ""
-
-#endif	/* SMP */
+#endif
 
 #include <asm-generic/percpu.h>
 
 /* We can use this directly for local CPU (faster). */
 DECLARE_PER_CPU(unsigned long, this_cpu_off);
 
+#endif /* __ASSEMBLY__ */
+#endif /* !CONFIG_X86_64 */
+
+#ifndef __ASSEMBLY__
+
 /* For arch-specific code, we can use direct single-insn ops (they
  * don't give an lvalue though). */
 extern void __bad_percpu_size(void);
@@ -232,7 +197,6 @@ do {							\
 				percpu_cmpxchg_op(per_cpu_var(var), old, new)
 
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 

-- 
