Return-Path: <linux-kernel-owner+w=401wt.eu-S933553AbXK3LKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbXK3LKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 06:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756402AbXK3LKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 06:10:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbXK3LKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 06:10:22 -0500
Date: Fri, 30 Nov 2007 12:10:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <clameter@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>
Subject: Re: [patch 03/10] percpu: Make the asm-generic/percpu.h more
	"generic"
Message-ID: <20071130111000.GA32431@elte.hu>
References: <20071128210926.008783214@sgi.com> <20071128211526.640694725@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128211526.640694725@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


note that this did not apply cleanly to latest x86.git. Could you 
double-check my merge fixups below?

	Ingo

-------->
Subject: percpu: Make the asm-generic/percpu.h more "generic"
From: Christoph Lameter <clameter@sgi.com>

V1->V2:
- add support for PER_CPU_ATTRIBUTES

Add the ability to use generic/percpu even if the arch needs to override
several aspects of its operations. This will enable the use of generic
percpu.h for all arches.

An arch may define:

__per_cpu_offset	Do not use the generic pointer array. Arch must
			define per_cpu_offset(cpu) (used by x86_64, s390).

__my_cpu_offset		Can be defined to provide an optimized way to determine
			the offset for variables of the currently executing
			processor. Used by ia64, x86_64, x86_32, sparc64, s/390.

SHIFT_PTR(ptr, offset)	If an arch defines it then special handling
			of pointer arithmentic may be implemented. Used
			by s/390.

(Some of these special percpu arch implementations may be later consolidated
so that there are less cases to deal with.)

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-generic/percpu.h |   69 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 11 deletions(-)

Index: linux-x86.q/include/asm-generic/percpu.h
===================================================================
--- linux-x86.q.orig/include/asm-generic/percpu.h
+++ linux-x86.q/include/asm-generic/percpu.h
@@ -3,18 +3,60 @@
 #include <linux/compiler.h>
 #include <linux/threads.h>
 
+/*
+ * Determine the real variable name from the name visible in the
+ * kernel sources.
+ */
+#define per_cpu_var(var) per_cpu__##var
+
 #ifdef CONFIG_SMP
 
+/*
+ * per_cpu_offset() is the offset that has to be added to a
+ * percpu variable to get to the instance for a certain processor.
+ *
+ * Most arches use the __per_cpu_offset array for those offsets but
+ * some arches have their own ways of determining the offset (x86_64, s390).
+ */
+#ifndef __per_cpu_offset
 extern unsigned long __per_cpu_offset[NR_CPUS];
-
 #define per_cpu_offset(x) (__per_cpu_offset[x])
+#endif
 
-/* var is in discarded region: offset to particular copy we want */
-#define per_cpu(var, cpu) (*({				\
-	extern int simple_identifier_##var(void);	\
-	RELOC_HIDE(&per_cpu__##var, __per_cpu_offset[cpu]); }))
-#define __get_cpu_var(var) per_cpu(var, smp_processor_id())
-#define __raw_get_cpu_var(var) per_cpu(var, raw_smp_processor_id())
+/*
+ * Determine the offset for the currently active processor.
+ * An arch may define __my_cpu_offset to provide a more effective
+ * means of obtaining the offset to the per cpu variables of the
+ * current processor.
+ */
+#ifndef __my_cpu_offset
+#define __my_cpu_offset per_cpu_offset(raw_smp_processor_id())
+#define my_cpu_offset per_cpu_offset(smp_processor_id())
+#else
+#define my_cpu_offset __my_cpu_offset
+#endif
+
+/*
+ * Add a offset to a pointer but keep the pointer as is.
+ *
+ * Only S390 provides its own means of moving the pointer.
+ */
+#ifndef SHIFT_PTR
+#define SHIFT_PTR(__p, __offset)	RELOC_HIDE((__p), (__offset))
+#endif
+
+/*
+ * A percpu variable may point to a discarded reghions. The following are
+ * established ways to produce a usable pointer from the percpu variable
+ * offset.
+ */
+#define per_cpu(var, cpu) (*SHIFT_PTR(&per_cpu_var(var), per_cpu_offset(cpu)))
+#define __get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), my_cpu_offset))
+#define __raw_get_cpu_var(var) (*SHIFT_PTR(&per_cpu_var(var), __my_cpu_offset))
+
+#ifdef CONFIG_ARCH_SETS_UP_PER_CPU_AREA
+extern void setup_per_cpu_areas(void);
+#endif
 
 /* A macro to avoid #include hell... */
 #define percpu_modcopy(pcpudst, src, size)			\
@@ -26,12 +68,17 @@ do {								\
 } while (0)
 #else /* ! SMP */
 
-#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu__##var))
-#define __get_cpu_var(var)			per_cpu__##var
-#define __raw_get_cpu_var(var)			per_cpu__##var
+#define per_cpu(var, cpu)			(*((void)(cpu), &per_cpu_var(var)))
+#define __get_cpu_var(var)			per_cpu_var(var)
+#define __raw_get_cpu_var(var)			per_cpu_var(var)
 
 #endif	/* SMP */
 
-#define DECLARE_PER_CPU(type, name) extern __typeof__(type) per_cpu__##name
+#ifndef PER_CPU_ATTRIBUTES
+#define PER_CPU_ATTRIBUTES
+#endif
+
+#define DECLARE_PER_CPU(type, name) extern PER_CPU_ATTRIBUTES \
+					__typeof__(type) per_cpu_var(name)
 
 #endif /* _ASM_GENERIC_PERCPU_H_ */
