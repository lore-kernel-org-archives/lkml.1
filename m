Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYGIQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYGIQwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 12:52:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYGIQve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 12:51:34 -0400
Received: from relay1.sgi.com ([192.48.171.29]:53175 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751852AbYGIQva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 12:51:30 -0400
Message-Id: <20080709165129.747474000@polaris-admin.engr.sgi.com>
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 09:51:32 -0700
From: Mike Travis <travis@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: [RFC 03/15] x86_64: Reference zero-based percpu variables offset from gs
Content-Disposition: inline; filename=zero_based_use_gs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  * Since %gs is pointing to the pda, it will then also point to the per cpu
    variables and can be accessed thusly:

        %gs:[&per_cpu_xxxx - __per_cpu_start]

    ... and since __per_cpu_start == 0 then:

        %gs:&per_cpu_var(xxx)
	
    becomes the optimized effective address.


Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Mike Travis <travis@sgi.com>
---
 include/asm-x86/percpu.h |   36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

--- linux-2.6.tip.orig/include/asm-x86/percpu.h
+++ linux-2.6.tip/include/asm-x86/percpu.h
@@ -5,15 +5,19 @@
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
 
-#else /* CONFIG_X86_64 */
+#else /* !CONFIG_X86_64 */
 
 #ifdef __ASSEMBLY__
 
@@ -42,36 +46,23 @@ DECLARE_PER_CPU(struct x8664_pda, pda);
 
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
@@ -206,7 +197,6 @@ do {							\
 				percpu_cmpxchg_op(per_cpu_var(var), old, new)
 
 #endif /* !__ASSEMBLY__ */
-#endif /* !CONFIG_X86_64 */
 
 #ifdef CONFIG_SMP
 

-- 
