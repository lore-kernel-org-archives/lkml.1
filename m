Return-Path: <linux-kernel-owner+w=401wt.eu-S1758790AbYFTX5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758790AbYFTX5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756694AbYFTX4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:56:47 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:33937 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbYFTX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:56:44 -0400
Date: Sat, 21 Jun 2008 03:25:39 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: fix module load failures on smp (bug #10926)
Message-ID: <20080620232539.GA8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To calculate addresses of locally defined variables, GCC uses 32-bit
displacement from the GP. Which doesn't work for per cpu variables in
modules, as an offset to the kernel per cpu area is way above 4G.

The workaround is to force allocation of a GOT entry for per cpu variable
using ldq instruction with a 'literal' relocation.
I had to use custom asm/percpu.h, as a required argument magic doesn't
work with asm-generic/percpu.h macros.

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 include/asm-alpha/percpu.h |   72 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/include/asm-alpha/percpu.h b/include/asm-alpha/percpu.h
index 48348fe..82e8a94 100644
--- a/include/asm-alpha/percpu.h
+++ b/include/asm-alpha/percpu.h
@@ -1,6 +1,76 @@
 #ifndef __ALPHA_PERCPU_H
 #define __ALPHA_PERCPU_H
+#include <linux/compiler.h>
+#include <linux/threads.h>
 
-#include <asm-generic/percpu.h>
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
+#ifdef CONFIG_SMP
+
+/*
+ * per_cpu_offset() is the offset that has to be added to a
+ * percpu variable to get to the instance for a certain processor.
+ */
+extern unsigned long __per_cpu_offset[NR_CPUS];
+
+#define per_cpu_offset(x) (__per_cpu_offset[x])
+
+#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#ifdef CONFIG_DEBUG_PREEMPT
+#define my_cpu_offset per_cpu_offset(smp_processor_id())
+#else
+#define my_cpu_offset __my_cpu_offset
+#endif
+
+#ifndef MODULE
+#define SHIFT_PERCPU_PTR(var, offset) RELOC_HIDE(&per_cpu_var(var), (offset))
+#define PER_CPU_ATTRIBUTES
+#else
+/*
+ * To calculate addresses of locally defined variables, GCC uses 32-bit
+ * displacement from the GP. Which doesn't work for per cpu variables in
+ * modules, as an offset to the kernel per cpu area is way above 4G.
+ *
+ * This forces allocation of a GOT entry for per cpu variable using
+ * ldq instruction with a 'literal' relocation.
+ */
+#define SHIFT_PERCPU_PTR(var, offset) ({		\
+	extern int simple_identifier_##var(void);	\
+	unsigned long __ptr, tmp_gp;			\
+	asm (  "br	%1, 1f		  	      \n\
+	1:	ldgp	%1, 0(%1)	    	      \n\
+		ldq %0, per_cpu__" #var"(%1)\t!literal"		\
+		: "=&r"(__ptr), "=&r"(tmp_gp));		\
+	(typeof(&per_cpu_var(var)))(__ptr + (offset)); })
+
+#define PER_CPU_ATTRIBUTES	__used
+
+#endif /* MODULE */
+
+/*
+ * A percpu variable may point to a discarded regions. The following are
+ * established ways to produce a usable pointer from the percpu variable
+ * offset.
+ */
+#define per_cpu(var, cpu) \
+	(*SHIFT_PERCPU_PTR(var, per_cpu_offset(cpu)))
+#define __get_cpu_var(var) \
+	(*SHIFT_PERCPU_PTR(var, my_cpu_offset))
+#define __raw_get_cpu_var(var) \
+	(*SHIFT_PERCPU_PTR(var, __my_cpu_offset))
+
+#else /* ! SMP */
+
+#define per_cpu(var, cpu)		(*((void)(cpu), &per_cpu_var(var)))
+#define __get_cpu_var(var)		per_cpu_var(var)
+#define __raw_get_cpu_var(var)		per_cpu_var(var)
+
+#endif /* SMP */
+
+#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu_var(name)
 
 #endif /* __ALPHA_PERCPU_H */
